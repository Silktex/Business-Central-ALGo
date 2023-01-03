report 50077 "Posted Purchase Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50077_Report_PostedPurchaseInvoice.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            RequestFilterFields = "Buy-from Vendor No.", "No.", "Posting Date";
            column(Invoice_No; "Purch. Inv. Header"."No.")
            {
            }
            column(Invoice_Date; "Purch. Inv. Header"."Posting Date")
            {
            }
            column(Vendor_No; "Purch. Inv. Header"."Buy-from Vendor No.")
            {
            }
            column(Vendor_Name; "Purch. Inv. Header"."Pay-to Name")
            {
            }
            column(Vendor_Invoice_No; "Purch. Inv. Header"."Vendor Invoice No.")
            {
            }
            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = FILTER(<> ' '));
                column(Type; "Purch. Inv. Line".Type)
                {
                }
                column(Item_No; "Purch. Inv. Line"."No.")
                {
                }
                column(Description; "Purch. Inv. Line".Description)
                {
                }
                column(Quantity; "Purch. Inv. Line".Quantity)
                {
                }
                column(Line_No; "Purch. Inv. Line"."Line No.")
                {
                }
                column(Unit_Cost; "Purch. Inv. Line"."Direct Unit Cost")
                {
                }
                column(Unit_Price; "Purch. Inv. Line"."Unit Price (LCY)")
                {
                }
                column(Amount; "Purch. Inv. Line".Amount)
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

