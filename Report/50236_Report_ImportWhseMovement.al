report 50236 "Import Whse Movement"
{
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

                // SheetName := ExcelBuf.SelectSheetsName(ServerFileName);
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
        //  ExcelBuf.OpenBook(ServerFileName, SheetName);
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
        WhseJournalLine: Record "Whse. Worksheet Line";
        recWarehouseJournalLine1: Record "Warehouse Journal Line";
        ExcelImport: Record "Tracking No.";
        NoSeriesManagment: Codeunit NoSeriesManagement;
        LineNo: Integer;
        decQtyPhysInventory: Decimal;
        decQuantity: Decimal;
        dtRegisteringDate: Date;
        WarehouseJournalBatch: Record "Warehouse Journal Batch";
        LineN: Integer;
        WhseJouLine: Record "Whse. Worksheet Line";
        WhseItemTrackingLine: Record "Whse. Item Tracking Line";
        WITL: Record "Whse. Item Tracking Line";
        MovQuantity: Decimal;
        WITLQty: Decimal;
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
        /*
        WhseJournalLine.RESET;
        WhseJournalLine.SETRANGE("Worksheet Template Name", GetValueAtCell(RowNo,1));
        WhseJournalLine.SETRANGE(Name, GetValueAtCell(RowNo,2));
        WhseJournalLine.SETRANGE("Location Code", GetValueAtCell(RowNo,3));
        WhseJournalLine.SETRANGE("Item No.", GetValueAtCell(RowNo,5));
        EVALUATE(LineN,GetValueAtCell(RowNo,4));
        WhseJournalLine.SETRANGE("Line No.", LineN);
        IF WhseJournalLine.FINDFIRST THEN BEGIN
          REPEAT
            IF GetValueAtCell(RowNo,20) = 'Yes' THEN
               WhseJournalLine.DELETE
            ELSE BEGIN
              WhseJournalLine.VALIDATE("To Zone Code", GetValueAtCell(RowNo,9));
              WhseJournalLine.VALIDATE("To Bin Code", GetValueAtCell(RowNo,10));
              WhseJournalLine.MODIFY(TRUE);
            END;
          UNTIL WhseJournalLine.NEXT=0;
        END;
        */
        WITLQty := 0;
        WhseItemTrackingLine.RESET;
        WhseItemTrackingLine.SETRANGE("Source ID", GetValueAtCell(RowNo, 2));
        WhseItemTrackingLine.SETRANGE("Source Batch Name", GetValueAtCell(RowNo, 1));
        WhseItemTrackingLine.SETRANGE("Source Type", 7326);
        WhseItemTrackingLine.SETRANGE("Location Code", GetValueAtCell(RowNo, 3));
        WhseItemTrackingLine.SETRANGE("Item No.", GetValueAtCell(RowNo, 5));
        EVALUATE(LineN, GetValueAtCell(RowNo, 4));
        WhseItemTrackingLine.SETRANGE("Source Ref. No.", LineN);
        WhseItemTrackingLine.SETRANGE("Lot No.", GetValueAtCell(RowNo, 18));
        IF WhseItemTrackingLine.FINDFIRST THEN BEGIN
            REPEAT
                WITLQty := WhseItemTrackingLine."Quantity (Base)";
                IF GetValueAtCell(RowNo, 20) = 'Yes' THEN BEGIN
                    WhseItemTrackingLine.DELETE;
                    WITL.RESET;
                    WITL.SETRANGE("Source ID", GetValueAtCell(RowNo, 2));
                    WITL.SETRANGE("Source Batch Name", GetValueAtCell(RowNo, 1));
                    WITL.SETRANGE("Source Type", 7326);
                    WITL.SETRANGE("Location Code", GetValueAtCell(RowNo, 3));
                    WITL.SETRANGE("Location Code", GetValueAtCell(RowNo, 3));
                    WITL.SETRANGE("Item No.", GetValueAtCell(RowNo, 5));
                    WITL.SETRANGE("Source Ref. No.", LineN);
                    IF NOT WITL.FINDFIRST THEN BEGIN
                        WhseJournalLine.RESET;
                        WhseJournalLine.SETRANGE("Worksheet Template Name", GetValueAtCell(RowNo, 1));
                        WhseJournalLine.SETRANGE(Name, GetValueAtCell(RowNo, 2));
                        WhseJournalLine.SETRANGE("Location Code", GetValueAtCell(RowNo, 3));
                        WhseJournalLine.SETRANGE("Item No.", GetValueAtCell(RowNo, 5));
                        WhseJournalLine.SETRANGE("Line No.", LineN);
                        IF WhseJournalLine.FINDFIRST THEN
                            WhseJournalLine.DELETE;
                    END ELSE BEGIN
                        WhseJournalLine.RESET;
                        WhseJournalLine.SETRANGE("Worksheet Template Name", GetValueAtCell(RowNo, 1));
                        WhseJournalLine.SETRANGE(Name, GetValueAtCell(RowNo, 2));
                        WhseJournalLine.SETRANGE("Location Code", GetValueAtCell(RowNo, 3));
                        WhseJournalLine.SETRANGE("Item No.", GetValueAtCell(RowNo, 5));
                        WhseJournalLine.SETRANGE("Line No.", LineN);
                        IF WhseJournalLine.FINDFIRST THEN BEGIN
                            WhseJournalLine.VALIDATE("To Zone Code", GetValueAtCell(RowNo, 9));
                            WhseJournalLine.VALIDATE("To Bin Code", GetValueAtCell(RowNo, 10));
                            WhseJournalLine.VALIDATE(Quantity, WhseJournalLine.Quantity - WITLQty);
                            WhseJournalLine.MODIFY(TRUE);
                        END;
                    END;

                END ELSE BEGIN
                    WhseJournalLine.RESET;
                    WhseJournalLine.SETRANGE("Worksheet Template Name", WhseItemTrackingLine."Source Batch Name");
                    WhseJournalLine.SETRANGE(Name, WhseItemTrackingLine."Source ID");
                    WhseJournalLine.SETRANGE("Location Code", WhseItemTrackingLine."Location Code");
                    WhseJournalLine.SETRANGE("Item No.", WhseItemTrackingLine."Item No.");
                    WhseJournalLine.SETRANGE("Line No.", WhseItemTrackingLine."Source Ref. No.");
                    IF WhseJournalLine.FINDFIRST THEN BEGIN
                        WhseJournalLine.VALIDATE("To Zone Code", GetValueAtCell(RowNo, 9));
                        WhseJournalLine.VALIDATE("To Bin Code", GetValueAtCell(RowNo, 10));
                        //MovQuantity := MovQuantity+ WhseItemTrackingLine."Quantity (Base)";
                        //WhseJournalLine.VALIDATE(Quantity, MovQuantity);
                        WhseJournalLine.MODIFY(TRUE);
                    END;
                END;
            UNTIL WhseItemTrackingLine.NEXT = 0;
        END;

    end;


    procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    var
        ExcelBuf1: Record "Excel Buffer";
    begin
        ExcelBuf1.GET(RowNo, ColNo);
        EXIT(ExcelBuf1."Cell Value as Text");
    end;
}

