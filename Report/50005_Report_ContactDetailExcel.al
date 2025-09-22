report 50005 "Contact Detail (Excel)"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "Customer Posting Group";

            trigger OnAfterGetRecord()
            begin
                MakeExcelDataBody(Customer);
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
        Text0001: Label 'Contact Detail';
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
        ExcelBuff.AddColumn('Customer No.', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Customer Name', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Customer Posting Group', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Contac No.', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Contact Name', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Address', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Address 2', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('City', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Post Code', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Country', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Phone', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Mobile', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Email', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Mail To', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Mail CC', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Mail BCC', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Sales Order', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Sales Shipment', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Sales Invoice', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Customer Ledger', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
    end;


    procedure MakeExcelDataBody(recCustomer: Record Customer)
    var
        ContBusRel: Record "Contact Business Relation";
        Cont: Record Contact;
    begin
        ContBusRel.SETCURRENTKEY("Link to Table", "No.");
        ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Customer);
        ContBusRel.SETRANGE("No.", recCustomer."No.");
        IF ContBusRel.FINDFIRST THEN
            REPEAT
                Cont.SETCURRENTKEY("Company Name", "Company No.", Type, Name);
                Cont.SETRANGE("Company No.", ContBusRel."Contact No.");
                IF Cont.FINDFIRST THEN
                    REPEAT
                        ExcelBuff.NewRow;
                        ExcelBuff.AddColumn(recCustomer."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
                        ExcelBuff.AddColumn(recCustomer.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
                        ExcelBuff.AddColumn(recCustomer."Customer Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
                        ExcelBuff.AddColumn(Cont."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
                        ExcelBuff.AddColumn(Cont.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
                        ExcelBuff.AddColumn(Cont.Address, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
                        ExcelBuff.AddColumn(Cont."Address 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
                        ExcelBuff.AddColumn(Cont.City, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
                        ExcelBuff.AddColumn(Cont."Post Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
                        ExcelBuff.AddColumn(Cont.County, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
                        ExcelBuff.AddColumn(Cont."Phone No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
                        ExcelBuff.AddColumn(Cont."Mobile Phone No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
                        ExcelBuff.AddColumn(Cont."E-Mail", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
                        ExcelBuff.AddColumn(Cont."Mail To", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
                        ExcelBuff.AddColumn(Cont."Mail CC", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
                        ExcelBuff.AddColumn(Cont."Mail BCC", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
                        ExcelBuff.AddColumn(Cont."Sales Order", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
                        ExcelBuff.AddColumn(Cont."Sales Shipment", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
                        ExcelBuff.AddColumn(Cont."Sales Invoice", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
                        ExcelBuff.AddColumn(Cont."Customer Ledger", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
                    UNTIL Cont.NEXT = 0;
            UNTIL ContBusRel.NEXT = 0;
    end;
}

