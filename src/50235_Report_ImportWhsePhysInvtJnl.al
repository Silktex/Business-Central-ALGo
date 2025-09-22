report 50235 "Import Whse Phys Invt Jnl"
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
        recWarehouseJournalLine: Record "Warehouse Journal Line";
        recWarehouseJournalLine1: Record "Warehouse Journal Line";
        ExcelImport: Record "Tracking No.";
        NoSeriesManagment: Codeunit NoSeriesManagement;
        LineNo: Integer;
        decQtyPhysInventory: Decimal;
        decQuantity: Decimal;
        dtRegisteringDate: Date;
        WarehouseJournalBatch: Record "Warehouse Journal Batch";
        LineN: Integer;
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
        decQuantity := 0;

        recWarehouseJournalLine.RESET;
        recWarehouseJournalLine.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Location Code", "Line No.");
        recWarehouseJournalLine.SETRANGE("Journal Template Name", GetValueAtCell(RowNo, 1));
        recWarehouseJournalLine.SETRANGE("Journal Batch Name", GetValueAtCell(RowNo, 2));
        recWarehouseJournalLine.SETRANGE("Location Code", GetValueAtCell(RowNo, 3));
        EVALUATE(LineN, GetValueAtCell(RowNo, 4));
        recWarehouseJournalLine.SETRANGE("Line No.", LineN);
        recWarehouseJournalLine.SETRANGE("Whse. Document No.", GetValueAtCell(RowNo, 5));
        IF recWarehouseJournalLine.FINDSET THEN BEGIN
            REPEAT
                EVALUATE(decQuantity, GetValueAtCell(RowNo, 12));
                recWarehouseJournalLine.VALIDATE("Qty. (Phys. Inventory)", decQuantity);
                recWarehouseJournalLine.MODIFY(TRUE);
            UNTIL recWarehouseJournalLine.NEXT = 0;
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

