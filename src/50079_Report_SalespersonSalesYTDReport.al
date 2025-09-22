report 50079 "Salesperson Sales YTD Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50079_Report_SalespersonSalesYTDReport.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Salesperson/Purchaser"; "Salesperson/Purchaser")
        {
            DataItemTableView = SORTING(Code);
            RequestFilterFields = "Code";
            column(Salesperson_Code; "Salesperson/Purchaser".Code)
            {
            }
            column(Salesperson_Name; "Salesperson/Purchaser".Name)
            {
            }
            column(YTD_Sales; YTDSales)
            {
            }
            column(Total_Sample_Sent; TotalSampleSent)
            {
            }

            trigger OnAfterGetRecord()
            begin
                YTDSales := 0;
                SalesInvoiceHeader.RESET;
                SalesInvoiceHeader.SETRANGE("Salesperson Code", Code);
                SalesInvoiceHeader.SETRANGE("Posting Date", StartDate, EndDate);
                IF SalesInvoiceHeader.FINDFIRST THEN
                    REPEAT
                        SalesInvoiceLine.RESET;
                        SalesInvoiceLine.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                        SalesInvoiceLine.SETRANGE(Type, SalesInvoiceLine.Type::Item);
                        SalesInvoiceLine.SETRANGE("Posting Group", 'FAB');
                        //SalesInvoiceLine.SETFILTER(SalesInvoiceLine."No.", '%1', '*@I*');
                        IF SalesInvoiceLine.FINDSET THEN
                            REPEAT
                                YTDSales := YTDSales + SalesInvoiceLine.Amount;
                            UNTIL SalesInvoiceLine.NEXT = 0;
                    UNTIL SalesInvoiceHeader.NEXT = 0;

                TotalSampleSent := 0;
                SalesInvoiceHeader1.RESET;
                SalesInvoiceHeader1.SETRANGE("Salesperson Code", Code);
                SalesInvoiceHeader1.SETRANGE("Posting Date", StartDate, EndDate);
                IF SalesInvoiceHeader1.FINDFIRST THEN
                    REPEAT
                        SalesInvoiceLine1.RESET;
                        SalesInvoiceLine1.SETRANGE("Document No.", SalesInvoiceHeader1."No.");
                        SalesInvoiceLine1.SETRANGE(Type, SalesInvoiceLine1.Type::Item);
                        SalesInvoiceLine1.SETRANGE("Posting Group", 'SAMPLES');
                        //SalesInvoiceLine1.SETFILTER(SalesInvoiceLine1."No.", '%1', '*@S*');
                        IF SalesInvoiceLine1.FINDSET THEN
                            REPEAT
                                TotalSampleSent := TotalSampleSent + SalesInvoiceLine1.Quantity;
                            UNTIL SalesInvoiceLine1.NEXT = 0;
                    UNTIL SalesInvoiceHeader1.NEXT = 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Start Date"; StartDate)
                {
                    ApplicationArea = all;
                }
                field("End Date"; EndDate)
                {
                    ApplicationArea = all;
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

    trigger OnPreReport()
    begin
        IF (StartDate <> 0D) AND (EndDate = 0D) THEN
            ERROR('Start Date OR End Date Both must have Date or Blank');

        IF (StartDate = 0D) AND (EndDate <> 0D) THEN
            ERROR('Start Date OR End Date Both must have Date or Blank');

        IF (StartDate = 0D) AND (EndDate = 0D) THEN BEGIN
            StartDate := 0D;
            EndDate := TODAY;
        END;
    end;

    var
        YTDSales: Decimal;
        TotalSampleSent: Decimal;
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine1: Record "Sales Invoice Line";
        SalesInvoiceHeader1: Record "Sales Invoice Header";
        StartDate: Date;
        EndDate: Date;
}

