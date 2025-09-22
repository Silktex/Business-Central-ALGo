report 50076 "Material Received & Not Invoic"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50076_Report_MaterialReceivedNotInvoic.rdlc';
    Caption = 'Material Received and Not Invoiced';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.");
            RequestFilterFields = "Order Date", "Buy-from Vendor No.", "Location Code";
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = FIELD("No."), "Buy-from Vendor No." = FIELD("Buy-from Vendor No.");
                DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending) WHERE("Qty. Rcd. Not Invoiced" = FILTER(<> 0));
                column(Document_Type; "Purchase Line"."Document Type")
                {
                }
                column(Buy_from_Vendor_No; "Purchase Line"."Buy-from Vendor No.")
                {
                }
                column(Vendor_Name; "Purchase Header"."Pay-to Name")
                {
                }
                column(Order_Date; FORMAT("Purchase Line"."Order Date"))
                {
                }
                column(Document_No; "Purchase Line"."Document No.")
                {
                }
                column(Line_No; "Purchase Line"."Line No.")
                {
                }
                column(Type; "Purchase Line".Type)
                {
                }
                column(No_; "Purchase Line"."No.")
                {
                }
                column(Location_Code; "Purchase Line"."Location Code")
                {
                }
                column(Posting_Group; "Purchase Line"."Posting Group")
                {
                }
                column(Gen_Prod_Posting_Group; "Purchase Line"."Gen. Prod. Posting Group")
                {
                }
                column(Expected_Receipt_Date; FORMAT("Purchase Line"."Expected Receipt Date"))
                {
                }
                column(Description; "Purchase Line".Description)
                {
                }
                column(Unit_of_Measure; "Purchase Line"."Unit of Measure")
                {
                }
                column(Quantity; "Purchase Line".Quantity)
                {
                }
                column(Quantity_Received; "Purchase Line"."Quantity Received")
                {
                }
                column(Quantity_Invoiced; "Purchase Line"."Quantity Invoiced")
                {
                }
                column(Qty_to_Invoice; "Purchase Line"."Qty. to Invoice")
                {
                }
                column(Qty_Rcd_Not_Invoiced; "Purchase Line"."Qty. Rcd. Not Invoiced")
                {
                }
                column(Amt_Rcd_Not_Invoiced; "Purchase Line"."Amt. Rcd. Not Invoiced")
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

