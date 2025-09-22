report 50042 "50042_Report_SalesListYearWise"
{
    ApplicationArea = All;
    Caption = 'Sales List Year Wise';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Customer Posting Group", "Customer Price Group";


            trigger OnAfterGetRecord()
            var
                CalcYear: Integer;
                AmountForCalcYear: array[99] of Decimal;
            begin

                CalcYear := YearStart;
                YearLoop := 0;
                repeat
                    YearLoop += 1;
                    AmountForCalcYear[YearLoop] := 0;

                    // SalesInvoiceHeader.Reset();
                    // SalesInvoiceHeader.SetRange("Sell-to Customer No.", "No.");
                    // SalesInvoiceHeader.SetRange("Posting Date", DMY2Date(01, 01, CalcYear), DMY2Date(31, 12, CalcYear));
                    // if SalesInvoiceHeader.FindSet() then
                    //     repeat
                    //         SalesInvoiceHeader.CalcFields("Amount Including VAT");
                    //         AmountForCalcYear[YearLoop] := AmountForCalcYear[YearLoop] + SalesInvoiceHeader."Amount Including VAT";
                    //     until SalesInvoiceHeader.Next() = 0;
                    if YearLoop > 1 then
                        CalcYear += 1;

                    SalesInvoiceLine.Reset();
                    SalesInvoiceLine.SetCurrentKey("Sell-to Customer No.", "Posting Date");
                    SalesInvoiceLine.SetRange("Sell-to Customer No.", "No.");
                    SalesInvoiceLine.SetRange("Posting Date", DMY2Date(01, 01, CalcYear), DMY2Date(31, 12, CalcYear));
                    if SalesInvoiceLine.FindSet() then begin
                        SalesInvoiceLine.CalcSums("Amount Including VAT");
                        AmountForCalcYear[YearLoop] := SalesInvoiceLine."Amount Including VAT";
                    end;
                until CalcYear = YearEnd;

                ExcelBuf.NewRow;
                ExcelBuf.AddColumn("No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Name 2", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Customer Posting Group", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Customer Price Group", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                if "Salesperson Code" = '' then
                    ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text)
                else begin
                    if Salesperson.get("Salesperson Code") then
                        ExcelBuf.AddColumn(Salesperson.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text)
                    else
                        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                end;
                ExcelBuf.AddColumn(County, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Address, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Contact, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("E-Mail", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Phone No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                For YearLoop := 1 to YearCount do
                    ExcelBuf.AddColumn(Format(AmountForCalcYear[YearLoop]), false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
            end;
        }
    }

    trigger OnPreReport()
    begin
        SalesInvoiceHeader.Reset();
        SalesInvoiceHeader.SetCurrentKey("Posting Date");
        SalesInvoiceHeader.setfilter("Posting Date", '<>%1', 0D);
        if SalesInvoiceHeader.FindFirst() then
            InvoiceFirstDate := SalesInvoiceHeader."Posting Date";

        RecDate.Reset();
        RecDate.SetRange("Period Type", RecDate."Period Type"::Year);
        RecDate.SetRange("Period Start", DMY2Date(01, 01, Date2DMY(InvoiceFirstDate, 3)), DMY2Date(01, 01, Date2DMY(Today, 3)));
        if RecDate.FindSet() then
            YearCount := RecDate.Count;

        YearStart := Date2DMY(InvoiceFirstDate, 3);
        if StrLen(Format(YearStart)) = 2 then
            YearStart := 2000 + YearStart;
        YearEnd := Date2DMY(Today, 3);
        if StrLen(Format(YearEnd)) = 2 then
            YearEnd := 2000 + YearEnd;

        MakeExcelDataHeader();
    end;

    trigger OnPostReport()
    begin
        CreateExcelbook();
    end;

    var
        InvoiceFirstDate: Date;
        RecDate: Record Date;
        CustLedger: Record "Cust. Ledger Entry";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        YearCount: Integer;
        YearStart: Integer;
        YearEnd: Integer;
        YearLoop: Integer;
        ExcelBuf: Record "Excel Buffer" temporary;
        Salesperson: Record "Salesperson/Purchaser";


    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.DeleteAll();

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Customer No.', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Company
        ExcelBuf.AddColumn('Name', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Seller GST No
        ExcelBuf.AddColumn('Name 2', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Unit Code
        ExcelBuf.AddColumn('Customer Posting Group', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Department Code
        ExcelBuf.AddColumn('Customer Price Group', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Financial Year
        ExcelBuf.AddColumn('Salesperson Name', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Financial Quarter
        ExcelBuf.AddColumn('State', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Transaction Type
        ExcelBuf.AddColumn('Address', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Transaction Type
        ExcelBuf.AddColumn('Contact Person Name', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Type of Document
        ExcelBuf.AddColumn('E-Mail ID', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Type
        ExcelBuf.AddColumn('Phone No.', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Invoice No./Original Invoice No. 
        For YearLoop := 0 to YearCount - 1 do
            ExcelBuf.AddColumn(Format(YearStart + YearLoop), false, '', true, false, true, '', ExcelBuf."Cell Type"::Number);//Customer No
    end;

    procedure CreateExcelbook()
    begin
        ExcelBuf.CreateNewBook('Sales List');
        ExcelBuf.WriteSheet('Sales List', CompanyName, UserId);
        ExcelBuf.CloseBook();
        ExcelBuf.SetFriendlyFilename('Sales List');
        ExcelBuf.OpenExcel();
    end;
}
