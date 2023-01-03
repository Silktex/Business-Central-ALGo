report 50041 "Customer Data"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "No.", County, "Country/Region Code";

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
        //ExcelBuff.CreateBook('', Text0001);
        ExcelBuff.CreateNewBook(Text0001);
        ExcelBuff.WriteSheet(Text0001, COMPANYNAME, USERID);
        ExcelBuff.CloseBook;
        ExcelBuff.SetFriendlyFilename(Text0001);
        ExcelBuff.OpenExcel;
        //ExcelBuff.GiveUserControl;
    end;


    procedure MakeExcelDataHeader()
    begin
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn('No.', FALSE, 'Item Number', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Name', FALSE, 'Item Description', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Name 2', FALSE, 'Lot Number', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Address', FALSE, 'Remaining Quantity', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Address 2', FALSE, 'Remaining Quantity', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('City', FALSE, 'Remaining Quantity', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Post Code', FALSE, 'Remaining Quantity', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('County', FALSE, 'Remaining Quantity', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Country/Region Code', FALSE, 'Remaining Quantity', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
    end;


    procedure MakeExcelDataBody()
    begin
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn(Customer."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(Customer.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(Customer."Name 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(Customer.Address, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(Customer."Address 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(Customer.City, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(Customer."Post Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(Customer.County, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(Customer."Country/Region Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
    end;
}

