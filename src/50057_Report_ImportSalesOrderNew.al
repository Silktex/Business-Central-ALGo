report 50057 "Import Sales Order New"
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
        IF ImportOption = ImportOption::"Replace entries" THEN
            ExcelImport.DELETEALL;

        ExcelBuf.LOCKTABLE;
        // ExcelBuf.OpenBook(ServerFileName, SheetName);
        ExcelBuf.OpenBookStream(NVInStream, SheetName);
        ExcelBuf.ReadSheet;
        //ExcelBuf.ReadSheet;
        GetLastRowandColumn;

        FOR X := 2 TO TotalRows DO
            InsertData(X);

        ExcelBuf.DELETEALL;

        MESSAGE('Import Completed.');
    end;

    var
        ImportOption: Option "Add entries","Replace entries";
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
        recSalesHeader: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recSalesLine1: Record "Sales Line";
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
        recSalesHeader.RESET;
        recSalesHeader.SETCURRENTKEY("Document Type", "Sell-to Customer No.");
        recSalesHeader.SETRANGE(recSalesHeader."No.", GetValueAtCell(RowNo, 1));
        IF NOT recSalesHeader.FINDFIRST THEN BEGIN
            recSalesHeader.INIT;
            recSalesHeader."Document Type" := recSalesHeader."Document Type"::Order;
            SalesRecSetup.GET;
            //recSalesHeader."No." := NoSeriesManagment.GetNextNo(SalesRecSetup."Order Nos.",WORKDATE,TRUE);
            recSalesHeader."No." := GetValueAtCell(RowNo, 1);
            //OrderNo := recSalesHeader."No.";
            recSalesHeader.VALIDATE(recSalesHeader."Sell-to Customer No.", GetValueAtCell(RowNo, 2));
            recSalesHeader.VALIDATE(recSalesHeader."Order Date", WORKDATE);
            recSalesHeader.VALIDATE(recSalesHeader."Document Date", WORKDATE);
            recSalesHeader.VALIDATE(recSalesHeader."Posting Date", WORKDATE);
            recSalesHeader.INSERT(TRUE);
            recSalesHeader.VALIDATE(recSalesHeader."Location Code", GetValueAtCell(RowNo, 7));
            recSalesHeader.MODIFY(TRUE);
            //CustNo := GetValueAtCell(RowNo,1);
        END;

        recSalesLine.RESET;
        recSalesLine.SETRANGE(recSalesLine."Document Type", recSalesLine."Document Type"::Order);
        recSalesLine.SETRANGE(recSalesLine."Document No.", GetValueAtCell(RowNo, 1));
        recSalesLine.SETFILTER(recSalesLine.Type, GetValueAtCell(RowNo, 3));
        recSalesLine.SETRANGE(recSalesLine."No.", GetValueAtCell(RowNo, 4));
        recSalesLine.SETRANGE(recSalesLine."Location Code", GetValueAtCell(RowNo, 7));
        IF recSalesLine.FINDFIRST THEN BEGIN
            EVALUATE(decItemQty, GetValueAtCell(RowNo, 5));
            recSalesLine.VALIDATE(recSalesLine.Quantity, recSalesLine.Quantity + decItemQty);
            EVALUATE(decUnitPrice, GetValueAtCell(RowNo, 9));
            recSalesLine.VALIDATE(recSalesLine."Unit Price", decUnitPrice);
            EVALUATE(DecountAmount, GetValueAtCell(RowNo, 8));
            recSalesLine.VALIDATE(recSalesLine."Line Discount %", DecountAmount);
            recSalesLine.MODIFY;
            IF recSalesLine.Type = recSalesLine.Type::Item THEN BEGIN
                IF RecItem.GET(recSalesLine."No.") THEN BEGIN
                    IF RecItem."Item Tracking Code" <> '' THEN
                        CreateReservEntry(recSalesLine, GetValueAtCell(RowNo, 6), decItemQty);
                END;
            END;
        END ELSE BEGIN
            recSalesLine1.RESET;
            recSalesLine1.SETRANGE(recSalesLine1."Document Type", recSalesLine1."Document Type"::Order);
            recSalesLine1.SETRANGE(recSalesLine1."Document No.", GetValueAtCell(RowNo, 1));
            IF recSalesLine1.FINDLAST THEN
                LineNo := recSalesLine1."Line No."
            ELSE
                LineNo := 0;

            recSalesLine.INIT;
            recSalesLine."Document Type" := recSalesLine."Document Type"::Order;
            recSalesLine."Document No." := GetValueAtCell(RowNo, 1);
            recSalesLine."Line No." := LineNo + 10000;
            EVALUATE(recSalesLine.Type, GetValueAtCell(RowNo, 3));
            recSalesLine.VALIDATE(recSalesLine."No.", GetValueAtCell(RowNo, 4));
            recSalesLine.VALIDATE(recSalesLine."Location Code", GetValueAtCell(RowNo, 7));
            EVALUATE(decItemQty, GetValueAtCell(RowNo, 5));
            recSalesLine.VALIDATE(recSalesLine.Quantity, decItemQty);
            EVALUATE(decUnitPrice, GetValueAtCell(RowNo, 9));
            recSalesLine.VALIDATE(recSalesLine."Unit Price", decUnitPrice);
            EVALUATE(DecountAmount, GetValueAtCell(RowNo, 8));
            recSalesLine.VALIDATE(recSalesLine."Line Discount %", DecountAmount);
            IF NOT recSalesLine.INSERT(TRUE) THEN
                recSalesLine.MODIFY(TRUE);
            IF recSalesLine.Type = recSalesLine.Type::Item THEN BEGIN
                IF RecItem.GET(recSalesLine."No.") THEN BEGIN
                    IF RecItem."Item Tracking Code" <> '' THEN
                        CreateReservEntry(recSalesLine, GetValueAtCell(RowNo, 6), decItemQty);
                END;
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


    procedure CreateReservEntry(LSalesLine: Record "Sales Line"; LLotNo: Code[20]; LQty: Decimal)
    var
        REntry: Record "Reservation Entry";
        ENo: Integer;
    begin
        RE.RESET;
        IF RE.FINDLAST THEN
            ENo := RE."Entry No." + 1
        ELSE
            ENo := 1;

        REntry.INIT;
        REntry."Entry No." := ENo;
        REntry.VALIDATE("Item No.", LSalesLine."No.");
        REntry.VALIDATE("Location Code", LSalesLine."Location Code");
        REntry."Reservation Status" := REntry."Reservation Status"::Surplus;
        REntry."Source Type" := DATABASE::"Sales Line";
        REntry."Source Subtype" := 1;
        REntry."Source ID" := LSalesLine."Document No.";
        REntry."Source Batch Name" := '';
        REntry."Source Ref. No." := LSalesLine."Line No.";
        REntry.VALIDATE(REntry."Qty. per Unit of Measure", recSalesLine."Qty. per Unit of Measure");
        REntry.VALIDATE(REntry."Lot No.", LLotNo);
        REntry."Created By" := USERID;
        REntry.VALIDATE(REntry.Quantity, -LQty);
        REntry."Quantity (Base)" := -(LQty * LSalesLine."Qty. per Unit of Measure");
        REntry."Qty. to Handle (Base)" := -(LQty * LSalesLine."Qty. per Unit of Measure");
        REntry."Qty. to Invoice (Base)" := -(LQty * LSalesLine."Qty. per Unit of Measure");
        REntry."Creation Date" := WORKDATE;
        REntry.Positive := FALSE;
        REntry.INSERT;
    end;
}

