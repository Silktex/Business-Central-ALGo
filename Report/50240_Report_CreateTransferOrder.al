report 50240 "Create Transfer Order"
{
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ImportOption; ImportOption)
                    {
                        Caption = 'Option';
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            IF CloseAction = ACTION::OK THEN BEGIN
                //ServerFileName := FileMgt.UploadFile(Text006, ExcelExtensionTok);
                UploadResult := UploadIntoStream(Text006, '', '', ServerFileName, NVInStream);
                IF ServerFileName = '' THEN
                    EXIT(FALSE);

                SheetName := ExcelBuf.SelectSheetsNameStream(NVInStream);
                IF SheetName = '' THEN
                    EXIT(FALSE);
            END;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        X: Integer;
    begin
        ExcelBuf.LOCKTABLE;
        ExcelBuf.OpenBookStream(NVInStream, SheetName);
        ExcelBuf.ReadSheet;
        GetLastRowandColumn;

        FOR X := 2 TO TotalRows DO
            CuPortal.RemoveReservationEntryNAV(GetValueAtCell(X, 1));

        FOR X := 2 TO TotalRows DO
            InsertData(X);

        recPurchaseHeader.RESET;
        recPurchaseHeader.SETRANGE("Document Type", recPurchaseHeader."Document Type"::Order);
        recPurchaseHeader.SETRANGE(recPurchaseHeader."Consignment No.", DocketNo);
        IF recPurchaseHeader.FINDFIRST THEN BEGIN
            REPEAT
                /*
                WITH TempPurchLine DO BEGIN
                  SETRANGE("Document No.",recPurchaseHeader."No.");
                  SETFILTER(Quantity,'<>0');
                  SETFILTER("Qty. to Receive",'<>0');
                  SETRANGE("Receipt No.",'');
                  Receive := FINDFIRST;
                END;
                IF Receive THEN
                */
                CuPortal.PostReceipt(recPurchaseHeader."No.");
            UNTIL recPurchaseHeader.NEXT = 0;
        END;

        CuPortal.InsertTransferOrderNAV(DocketNo, ShipVia);

        ExcelBuf.DELETEALL;
        MESSAGE('Import Completed.');

    end;

    var
        ImportOption: Option "Add entries";
        Text005: Label 'Imported from Excel ';
        ServerFileName: Text;
        SheetName: Text[250];
        FileMgt: Codeunit "File Management";
        Text006: Label 'Import Excel File';
        ExcelExtensionTok: Label '.xlsx', Locked = true;
        ExcelBuf: Record "Excel Buffer";
        Text010: Label 'Add entries,Replace entries';
        Window: Dialog;
        Text001: Label 'Do you want to create %1 %2.';
        Text003: Label 'Are you sure you want to %1 for %2 %3.';
        TotalColumns: Integer;
        TotalRows: Integer;
        recTransferHeader: Record "Transfer Header";
        recTransfersLine: Record "Transfer Line";
        recTransfersLine1: Record "Transfer Line";
        ExcelImport: Record "Tracking No.";
        SalesRecSetup: Record "Sales & Receivables Setup";
        NoSeriesManagment: Codeunit NoSeriesManagement;
        LineNo: Integer;
        CustNo: Code[30];
        OrderNo: Code[30];
        decItemQty: Decimal;
        decUnitPrice: Decimal;
        DecountAmount: Decimal;
        RE: Record "Reservation Entry";
        recItem: Record Item;
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        InvtSetup: Record "Inventory Setup";
        cuNoSeries: Codeunit NoSeriesManagement;
        decQuantity: Decimal;
        CuPortal: Codeunit "Portal CU";
        DocNo: Text;
        ShipVia: Text;
        DocketNo: Text;
        recPurchaseHeader: Record "Purchase Header";
        TempPurchLine: Record "Purchase Line" temporary;
        Receive: Boolean;
        Name: Text;
        UploadResult: Boolean;
        NVInStream: InStream;


    procedure GetLastRowandColumn()
    begin
        ExcelBuf.SETRANGE("Row No.", 1);
        TotalColumns := ExcelBuf.COUNT;

        ExcelBuf.RESET;
        IF ExcelBuf.FINDLAST THEN
            TotalRows := ExcelBuf."Row No.";
    end;


    procedure InsertData(RowNo: Integer)
    var
        ItemNo: Code[20];
        RecItem: Record Item;
        LMonth: Integer;
        Qty: Decimal;
        DocLineNo: Integer;
        SerialNo: Text;
        LotNo: Text;
        recPurchLine: Record "Purchase Line";
        ItemTrackingCheck: Record Item;
        recPurchHeader: Record "Purchase Header";
        cuSalesRelease: Codeunit "Release Purchase Document";
        PostingDate: Date;
        ETADate: Date;
    begin
        Qty := 0;
        DocNo := GetValueAtCell(RowNo, 1);
        EVALUATE(DocLineNo, GetValueAtCell(RowNo, 2));
        EVALUATE(Qty, GetValueAtCell(RowNo, 10));
        SerialNo := '';
        LotNo := GetValueAtCell(RowNo, 11);
        DocketNo := GetValueAtCell(RowNo, 12);
        ShipVia := GetValueAtCell(RowNo, 13);
        PostingDate := 0D;
        Evaluate(PostingDate, GetValueAtCell(RowNo, 14));
        ETADate := 0D;
        Evaluate(ETADate, GetValueAtCell(RowNo, 15));
        if PostingDate = 0D then
            Error('Please enter Posting Date in excel.');
        if ETADate = 0D then
            Error('Please enter ETA Date in excel.');
        /*
        recPurchLine.RESET;
        recPurchLine.SETRANGE("Document Type",recPurchLine."Document Type"::Order);
        recPurchLine.SETRANGE("Document No.",DocNo);
        IF recPurchLine.FINDFIRST THEN BEGIN
          REPEAT
           recPurchLine.VALIDATE("Qty. to Receive",0);
           recPurchLine.MODIFY;
          UNTIL recPurchLine.NEXT=0;
        END;
        */

        recPurchLine.RESET;
        recPurchLine.SETRANGE("Document Type", recPurchLine."Document Type"::Order);
        recPurchLine.SETRANGE("Document No.", DocNo);
        recPurchLine.SETRANGE("Line No.", DocLineNo);
        recPurchLine.SETRANGE(Type, recPurchLine.Type::Item);
        IF recPurchLine.FIND('-') THEN BEGIN
            ItemTrackingCheck.GET(recPurchLine."No.");
            IF (ItemTrackingCheck."Item Tracking Code" <> '') THEN BEGIN
                CuPortal.InsertTrackingSpecificationPurNAV(DocNo, DocLineNo, Qty, SerialNo, LotNo, DocketNo, ShipVia, PostingDate, ETADate);
            END ELSE BEGIN
                recPurchLine.VALIDATE("Qty. to Receive", Qty / recPurchLine."Qty. per Unit of Measure");
                recPurchLine.VALIDATE("Variant Code", recPurchLine."Variant Code");
                recPurchLine.MODIFY;

                recPurchHeader.RESET;
                recPurchHeader.SETRANGE("Document Type", recPurchLine."Document Type"::Order);
                recPurchHeader.SETRANGE("No.", DocNo);
                IF recPurchHeader.FIND('-') THEN BEGIN
                    recPurchHeader.SetHideValidationDialog(TRUE);
                    cuSalesRelease.Reopen(recPurchHeader);
                    recPurchHeader."Consignment No." := DocketNo;
                    recPurchHeader."Ship Via" := ShipVia;
                    recPurchHeader.Validate("Posting Date", PostingDate);
                    recPurchHeader.Validate("ETA Date", ETADate);
                    recPurchHeader.MODIFY(FALSE);
                    recPurchHeader.SetHideValidationDialog(TRUE);
                    cuSalesRelease.RUN(recPurchHeader);
                END;
            END;
        END;

    end;

    procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    var
        ExcelBuf1: Record "Excel Buffer";
    begin
        ExcelBuf1.RESET;
        ExcelBuf1.SETRANGE(ExcelBuf1."Row No.", RowNo);
        ExcelBuf1.SETRANGE(ExcelBuf1."Column No.", ColNo);
        IF ExcelBuf1.FINDFIRST THEN
            EXIT(ExcelBuf1."Cell Value as Text")
        ELSE
            EXIT('');
    end;
}

