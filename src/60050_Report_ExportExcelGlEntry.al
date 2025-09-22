report 60050 ExportExcelGlEntry
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/60050_Report_ExportExcelGlEntry.rdlc';

    dataset
    {
        dataitem("G/L Register"; "G/L Register")
        {
            DataItemTableView = SORTING("Creation Date");
            dataitem("G/L Entry"; "G/L Entry")
            {

                trigger OnAfterGetRecord()
                begin
                    IF DATE2DMY("Posting Date", 3) = 2015 THEN BEGIN
                        RNo += 1;
                        EnterCell(RNo, 1, FORMAT("Entry No."));
                        EnterCell(RNo, 2, FORMAT("G/L Account No."));
                        EnterCell(RNo, 3, FORMAT("Posting Date"));
                        EnterCell(RNo, 4, FORMAT("Document No."));
                        EnterCell(RNo, 5, FORMAT(Amount));
                        EnterCell(RNo, 6, FORMAT("G/L Register"."Creation Date"));
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Entry No.", "G/L Register"."From Entry No.", "G/L Register"."To Entry No.");
                end;
            }

            trigger OnPostDataItem()
            begin
                ExcelBuffer.WriteSheet('GL Entry', COMPANYNAME, USERID);
                ExcelBuffer.CloseBook;
                ExcelBuffer.OpenExcel;
                // ExcelBuffer.GiveUserControl;
            end;

            trigger OnPreDataItem()
            begin
                CLEAR(ExcelBuffer);
                //ExcelBuffer.CreateBook('', 'GL Entry');
                ExcelBuffer.CreateNewBook('GL Entry');
                SETFILTER("Creation Date", '%1..%2', 20160101D, 20161231D);
                RNo := 1;
                EnterCell(RNo, 1, 'Entry No.');
                EnterCell(RNo, 2, 'GL Account No.');
                EnterCell(RNo, 3, 'Posting Date');
                EnterCell(RNo, 4, 'Document No.');
                EnterCell(RNo, 5, 'Amount');
                EnterCell(RNo, 6, 'Transaction Date')
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        RNo: Integer;
        CNo: Integer;


    procedure EnterCell(RowNo: Integer; colNo: Integer; Value: Text[250])
    begin
        ExcelBuffer.INIT;
        ExcelBuffer.VALIDATE("Row No.", RowNo);
        ExcelBuffer.VALIDATE("Column No.", colNo);
        ExcelBuffer."Cell Value as Text" := Value;
        IF RowNo = 1 THEN
            ExcelBuffer.Bold := TRUE;
        IF colNo = 5 THEN
            ExcelBuffer."Cell Type" := ExcelBuffer."Cell Type"::Number
        ELSE
            ExcelBuffer."Cell Type" := ExcelBuffer."Cell Type"::Text;
        ExcelBuffer.INSERT;
    end;
}

