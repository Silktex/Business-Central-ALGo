report 50078 "Posted Purchase Receipt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50078_Report_PostedPurchaseReceipt.rdlc';
    Caption = 'Posted Purchase Receipt (Goods Not Invoiced)';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Posting Date";
            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending) WHERE("Qty. Rcd. Not Invoiced" = FILTER(<> 0));
                dataitem("Item Entry Relation"; "Item Entry Relation")
                {
                    DataItemLink = "Source ID" = FIELD("Document No."), "Source Ref. No." = FIELD("Line No.");
                    DataItemTableView = SORTING("Source ID", "Source Type", "Source Subtype", "Source Ref. No.", "Source Prod. Order Line", "Source Batch Name") ORDER(Ascending) WHERE("Source Type" = FILTER(121));
                    dataitem("Item Ledger Entry"; "Item Ledger Entry")
                    {
                        DataItemLink = "Entry No." = FIELD("Item Entry No.");
                        DataItemTableView = SORTING("Entry No.");
                        column(Document_No; "Purch. Rcpt. Header"."No.")
                        {
                        }
                        column(Posting_Date; "Purch. Rcpt. Header"."Posting Date")
                        {
                        }
                        column(Vendor_Code; "Purch. Rcpt. Header"."Buy-from Vendor No.")
                        {
                        }
                        column(Vendor_Shipment_No; "Purch. Rcpt. Header"."Vendor Shipment No.")
                        {
                        }
                        column(Vendor_Name; recVendor.Name)
                        {
                        }
                        column(Type; "Purch. Rcpt. Line".Type)
                        {
                        }
                        column(Item_No; "Purch. Rcpt. Line"."No.")
                        {
                        }
                        column(Description; "Purch. Rcpt. Line".Description)
                        {
                        }
                        column(Total_Quantity; "Item Ledger Entry".Quantity)
                        {
                        }
                        column(Quantity_Invoiced; "Item Ledger Entry"."Invoiced Quantity")
                        {
                        }
                        column(Quantity_Not_Invoiced; Quantity - "Invoiced Quantity")
                        {
                        }
                    }
                }
            }

            trigger OnAfterGetRecord()
            begin

                IF recVendor.GET("Purch. Rcpt. Header"."Buy-from Vendor No.") THEN;
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
        recVendor: Record Vendor;
}

