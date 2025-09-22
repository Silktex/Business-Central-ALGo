report 50234 "Import Transfer Order XML"
{
    // Saurav.NAV#ExcelImport
    //   # Report to Simulate Excel Import

    ProcessingOnly = true;

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

                //SheetName := ExcelBuf.SelectSheetsName(ServerFileName);
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
        //IF ImportOption = ImportOption::"Replace entries" THEN
        //ExcelImport.DELETEALL;

        ExcelBuf.LOCKTABLE;
        // ExcelBuf.OpenBook(ServerFileName, SheetName);
        ExcelBuf.OpenBookStream(NVInStream, SheetName);
        ExcelBuf.ReadSheet;
        GetLastRowandColumn;

        FOR X := 2 TO TotalRows DO
            InsertData(X);

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
    begin
        decItemQty := 0;
        recTransferHeader.RESET;
        recTransferHeader.SETCURRENTKEY("No.");
        recTransferHeader.SETRANGE("No.", GetValueAtCell(RowNo, 1));
        IF NOT recTransferHeader.FINDFIRST THEN BEGIN
            recTransferHeader.INIT;
            //SalesRecSetup.GET;
            //recTransferHeader."No." := NoSeriesManagment.GetNextNo(SalesRecSetup."Order Nos.",WORKDATE,TRUE);
            recTransferHeader."No." := GetValueAtCell(RowNo, 1);
            recTransferHeader.INSERT(TRUE);
            recTransferHeader.VALIDATE(recTransferHeader."Transfer-from Code", GetValueAtCell(RowNo, 2));
            recTransferHeader.VALIDATE(recTransferHeader."Transfer-to Code", GetValueAtCell(RowNo, 3));
            recTransferHeader.VALIDATE(recTransferHeader."In-Transit Code", GetValueAtCell(RowNo, 4));
            recTransferHeader.VALIDATE(recTransferHeader."Posting Date", WORKDATE);
            recTransferHeader.VALIDATE(recTransferHeader."Shipment Date", WORKDATE);

            recTransferHeader.MODIFY(TRUE);
        END;

        recTransfersLine.RESET;
        recTransfersLine.SETRANGE(recTransfersLine."Document No.", GetValueAtCell(RowNo, 1));
        recTransfersLine.SETRANGE(recTransfersLine."Item No.", GetValueAtCell(RowNo, 5));
        IF recTransfersLine.FINDFIRST THEN BEGIN
            EVALUATE(decItemQty, GetValueAtCell(RowNo, 6));
            recTransfersLine.VALIDATE(recTransfersLine.Quantity, recTransfersLine.Quantity + decItemQty);
            recTransfersLine.MODIFY;
            IF RecItem.GET(recTransfersLine."Item No.") THEN BEGIN
                IF RecItem."Item Tracking Code" <> '' THEN
                    CreateReservEntry(recTransfersLine, GetValueAtCell(RowNo, 7), decItemQty);
            END;
        END ELSE BEGIN
            recTransfersLine1.RESET;
            recTransfersLine1.SETRANGE(recTransfersLine1."Document No.", GetValueAtCell(RowNo, 1));
            IF recTransfersLine1.FINDLAST THEN
                LineNo := recTransfersLine1."Line No."
            ELSE
                LineNo := 0;

            recTransfersLine.INIT;
            recTransfersLine."Document No." := GetValueAtCell(RowNo, 1);
            recTransfersLine."Line No." := LineNo + 10000;
            recTransfersLine.VALIDATE(recTransfersLine."Item No.", GetValueAtCell(RowNo, 5));
            EVALUATE(decItemQty, GetValueAtCell(RowNo, 6));
            recTransfersLine.VALIDATE(recTransfersLine.Quantity, decItemQty);
            IF NOT recTransfersLine.INSERT(TRUE) THEN
                recTransfersLine.MODIFY(TRUE);
            IF RecItem.GET(recTransfersLine."Item No.") THEN BEGIN
                IF RecItem."Item Tracking Code" <> '' THEN
                    CreateReservEntry(recTransfersLine, GetValueAtCell(RowNo, 7), decItemQty);
            END;
        END;
    end;


    procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    var
        ExcelBuf1: Record "Excel Buffer";
    begin
        ExcelBuf1.GET(RowNo, ColNo);
        EXIT(ExcelBuf1."Cell Value as Text");
    end;


    procedure CreateReservEntry(LSalesLine: Record "Transfer Line"; LLotNo: Code[20]; LQty: Decimal)
    var
        REntry: Record "Reservation Entry";
        ENo: Integer;
        recILE: Record "Item Ledger Entry";
    begin
        RE.RESET;
        IF RE.FINDLAST THEN
            ENo := RE."Entry No." + 1
        ELSE
            ENo := 1;

        REntry.INIT;
        REntry."Entry No." := ENo;
        REntry.VALIDATE("Item No.", LSalesLine."Item No.");
        REntry.VALIDATE("Location Code", LSalesLine."Transfer-from Code");
        REntry."Reservation Status" := REntry."Reservation Status"::Surplus;
        REntry."Source Type" := 5741;
        REntry."Source Subtype" := 0;
        REntry."Source ID" := LSalesLine."Document No.";
        REntry."Source Batch Name" := '';
        REntry."Source Ref. No." := LSalesLine."Line No.";
        REntry.VALIDATE(REntry."Qty. per Unit of Measure", LSalesLine."Qty. per Unit of Measure");
        REntry.VALIDATE(REntry."Lot No.", LLotNo);
        REntry."Created By" := USERID;
        REntry.VALIDATE(REntry.Quantity, -LQty);
        REntry."Quantity (Base)" := -(LQty * LSalesLine."Qty. per Unit of Measure");
        REntry."Qty. to Handle (Base)" := -(LQty * LSalesLine."Qty. per Unit of Measure");
        REntry."Qty. to Invoice (Base)" := -(LQty * LSalesLine."Qty. per Unit of Measure");
        REntry."Creation Date" := WORKDATE;
        REntry.VALIDATE(REntry."Item Tracking", REntry."Item Tracking"::"Lot No.");
        REntry.Positive := FALSE;
        recILE.RESET;
        recILE.SETRANGE("Entry Type", recILE."Entry Type"::Purchase);
        recILE.SETRANGE("Document Type", recILE."Document Type"::"Purchase Receipt");
        recILE.SETRANGE("Lot No.", LLotNo);
        IF recILE.FIND('-') THEN
            REntry.VALIDATE(REntry."Dylot No.", recILE."Dylot No.");

        REntry.INSERT;

        REntry.INIT;
        REntry."Entry No." := ENo + 1;
        REntry.VALIDATE("Item No.", LSalesLine."Item No.");
        REntry.VALIDATE("Location Code", LSalesLine."Transfer-to Code");
        REntry."Reservation Status" := REntry."Reservation Status"::Surplus;
        REntry."Source Type" := 5741;
        REntry."Source Subtype" := 1;
        REntry."Source ID" := LSalesLine."Document No.";
        REntry."Source Batch Name" := '';
        REntry."Source Ref. No." := LSalesLine."Line No.";
        REntry.VALIDATE(REntry."Qty. per Unit of Measure", LSalesLine."Qty. per Unit of Measure");
        REntry.VALIDATE(REntry."Lot No.", LLotNo);
        REntry."Created By" := USERID;
        REntry.VALIDATE(REntry.Quantity, LQty);
        REntry."Quantity (Base)" := (LQty * LSalesLine."Qty. per Unit of Measure");
        REntry."Qty. to Handle (Base)" := (LQty * LSalesLine."Qty. per Unit of Measure");
        REntry."Qty. to Invoice (Base)" := (LQty * LSalesLine."Qty. per Unit of Measure");
        REntry."Creation Date" := WORKDATE;
        REntry.VALIDATE(REntry."Item Tracking", REntry."Item Tracking"::"Lot No.");
        REntry.Positive := TRUE;
        recILE.RESET;
        recILE.SETRANGE("Entry Type", recILE."Entry Type"::Purchase);
        recILE.SETRANGE("Document Type", recILE."Document Type"::"Purchase Receipt");
        recILE.SETRANGE("Lot No.", LLotNo);
        IF recILE.FIND('-') THEN
            REntry.VALIDATE(REntry."Dylot No.", recILE."Dylot No.");

        REntry.INSERT;
    end;
}

