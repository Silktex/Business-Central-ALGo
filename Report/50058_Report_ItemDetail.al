report 50058 "Item Detail"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {

            trigger OnAfterGetRecord()
            begin
                MakeExcelDataBody;
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

    trigger OnPostReport()
    begin
        CreateExcelBook;
    end;

    trigger OnPreReport()
    begin
        MakeExcelDataHeader;
    end;

    var
        ExcelBuff: Record "Excel Buffer" temporary;
        Text0001: Label 'Lot Report';
        Text0002: Label 'Data';


    procedure CreateExcelBook()
    begin
        // ExcelBuff.CreateBook('', Text0001);
        ExcelBuff.CreateNewBook(Text0001);
        ExcelBuff.WriteSheet(Text0001, COMPANYNAME, USERID);
        ExcelBuff.CloseBook;
        ExcelBuff.OpenExcel;
        // ExcelBuff.GiveUserControl;
    end;


    procedure MakeExcelDataHeader()
    begin
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn(Item.FIELDCAPTION("No."), FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(Item.FIELDCAPTION(Description), FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(Item.FIELDCAPTION("Product Line"), FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
    end;


    procedure MakeExcelDataBody()
    begin
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn(Item."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(Item.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(Item."Product Line", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
    end;
}

