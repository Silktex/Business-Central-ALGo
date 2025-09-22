report 50054 "STK PLACEMENT"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {

            trigger OnAfterGetRecord()
            begin
                recSalesInvHdr.RESET;
                recSalesInvHdr.SETRANGE(recSalesInvHdr."Sell-to Customer No.", Customer."No.");
                recSalesInvHdr.SETRANGE(recSalesInvHdr."Campaign No.", 'PLACEMENT');
                IF FromDate <> 0D THEN
                    recSalesInvHdr.SETRANGE(recSalesInvHdr."Posting Date", FromDate, ToDate);
                IF recSalesInvHdr.FINDFIRST THEN BEGIN
                    recSalesInvHdr1.RESET;
                    recSalesInvHdr1.SETRANGE(recSalesInvHdr1."Sell-to Customer No.", Customer."No.");
                    IF recSalesInvHdr1.FINDFIRST THEN
                        REPEAT
                            recSalesInvLine.RESET;
                            recSalesInvLine.SETRANGE(recSalesInvLine."Document No.", recSalesInvHdr1."No.");
                            IF recSalesInvLine.FINDFIRST THEN
                                REPEAT
                                    MakeExcelDataBody;
                                UNTIL recSalesInvLine.NEXT = 0;
                        UNTIL recSalesInvHdr1.NEXT = 0;
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    Caption = 'Option';
                    field(FromDate; FromDate)
                    {
                        Caption = 'From Date';
                        ApplicationArea = all;
                    }
                    field(ToDate; ToDate)
                    {
                        Caption = 'To Date';
                        ApplicationArea = all;
                    }
                }
            }
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
        IF FromDate <> 0D THEN
            IF ToDate = 0D THEN
                ERROR('Please Check Date');
        ExcelBuff.RESET;
        ExcelBuff.DELETEALL;
        MakeExcelDataHeader;
    end;

    var
        ExcelBuff: Record "Excel Buffer";
        recSalesInvHdr: Record "Sales Invoice Header";
        recSalesInvHdr1: Record "Sales Invoice Header";
        recSalesInvLine: Record "Sales Invoice Line";
        Text0001: Label 'STK PLACEMENT';
        FromDate: Date;
        ToDate: Date;


    procedure CreateExcelBook()
    begin
        //ExcelBuff.CreateBook('', Text0001);
        ExcelBuff.CreateNewBook(Text0001);
        ExcelBuff.WriteSheet(Text0001, COMPANYNAME, USERID);
        ExcelBuff.CloseBook;
        ExcelBuff.OpenExcel;
        //ExcelBuff.GiveUserControl;
    end;


    procedure MakeExcelDataHeader()
    begin
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn('Customer No.', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Customer Name', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Posting Date', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Invoice No.', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Type', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('No.', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Description', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('UOM', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Quantity', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Unit Price', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Discount', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Amount', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Campaign', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
    end;


    procedure MakeExcelDataBody()
    begin
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn(Customer."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(Customer.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(FORMAT(recSalesInvHdr1."Posting Date"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Date);
        ExcelBuff.AddColumn(recSalesInvHdr1."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(recSalesInvLine.Type, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(recSalesInvLine."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(recSalesInvLine.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(recSalesInvLine."Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(FORMAT(recSalesInvLine.Quantity), FALSE, '', FALSE, FALSE, FALSE, '##,#0.00', ExcelBuff."Cell Type"::Number);
        ExcelBuff.AddColumn(FORMAT(recSalesInvLine."Unit Price"), FALSE, '', FALSE, FALSE, FALSE, '##,#0.00', ExcelBuff."Cell Type"::Number);
        ExcelBuff.AddColumn(FORMAT(recSalesInvLine."Line Discount Amount") + FORMAT(recSalesInvLine."Inv. Discount Amount"), FALSE, '', FALSE, FALSE, FALSE, '##,#0.00', ExcelBuff."Cell Type"::Number);
        ExcelBuff.AddColumn(FORMAT(recSalesInvLine.Amount), FALSE, '', FALSE, FALSE, FALSE, '##,#0.00', ExcelBuff."Cell Type"::Number);
        ExcelBuff.AddColumn(recSalesInvHdr1."Campaign No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
    end;
}

