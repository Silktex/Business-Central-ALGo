report 50237 "Import Put Away Bins"
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

        MESSAGE('Put Away Bin Update Completed.');
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
        recWarehouseActivityLine: Record "Warehouse Activity Line";
        LineNo: Integer;
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
        recWarehouseActivityLine.RESET;
        recWarehouseActivityLine.SETRANGE("Activity Type", recWarehouseActivityLine."Activity Type"::"Put-away");
        recWarehouseActivityLine.SETRANGE("Action Type", recWarehouseActivityLine."Action Type"::Place);
        recWarehouseActivityLine.SETRANGE("No.", GetValueAtCell(RowNo, 2));
        EVALUATE(LineNo, GetValueAtCell(RowNo, 3));
        recWarehouseActivityLine.SETRANGE("Line No.", LineNo);
        recWarehouseActivityLine.SETRANGE("Item No.", GetValueAtCell(RowNo, 4));
        //IF GetValueAtCell(RowNo,6) <> '' THEN
        //recWarehouseActivityLine.SETRANGE("Lot No.", GetValueAtCell(RowNo,6));
        IF recWarehouseActivityLine.FINDFIRST THEN BEGIN
            recWarehouseActivityLine.VALIDATE("Zone Code", GetValueAtCell(RowNo, 8));
            recWarehouseActivityLine.VALIDATE("Bin Code", GetValueAtCell(RowNo, 9));
            recWarehouseActivityLine.MODIFY(TRUE);
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

