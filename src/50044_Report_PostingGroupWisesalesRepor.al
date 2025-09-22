report 50044 "Posting Group Wise sales Repor"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50044_Report_PostingGroupWisesalesRepor.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Customer Posting Group";
            column(No_Customer; "No.")
            {
            }
            column(Name_Customer; Name)
            {
            }
            column(CustomerPostingGroup_Customer; "Customer Posting Group")
            {
            }
            dataitem("Sales Invoice Header"; "Sales Invoice Header")
            {
                CalcFields = Amount;
                DataItemLink = "Sell-to Customer No." = FIELD("No.");
                RequestFilterFields = "Posting Date";
                column(PostingDate_SalesInvoiceHeader; FORMAT("Posting Date"))
                {
                }
                column(No_SalesInvoiceHeader; "No.")
                {
                }
                column(CurrencyCode_SalesInvoiceHeader; "Currency Code")
                {
                }
                column(Amount_SalesInvoiceHeader; Amount)
                {
                }
            }
            dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
            {
                CalcFields = Amount;
                DataItemLink = "Sell-to Customer No." = FIELD("No.");
                RequestFilterFields = "Posting Date";
                column(PostingDate_SalesCrMemoHeader; FORMAT("Posting Date"))
                {
                }
                column(No_SalesCrMemoHeader; "No.")
                {
                }
                column(CurrencyCode_SalesCrMemoHeader; "Currency Code")
                {
                }
                column(Amount_SalesCrMemoHeader; -Amount)
                {
                }
            }
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
}

