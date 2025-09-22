pageextension 50228 "User Setup_Ext" extends "User Setup"
{
    layout
    {
        addafter("Register Time")
        {
            field("Allow Reopen Sales Doc."; Rec."Allow Reopen Sales Doc.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Time Sheet Admin.")
        {
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = all;
            }
            field("Sent Mail Sales Invoice"; Rec."Sent Mail Sales Invoice")
            {
                ApplicationArea = all;
            }
            field("Sent Mail Sales Order"; Rec."Sent Mail Sales Order")
            {
                ApplicationArea = all;
            }
            field("Sent Mail Sales Shipment"; Rec."Sent Mail Sales Shipment")
            {
                ApplicationArea = all;
            }
            field("Sent Mail Customer Ledger"; Rec."Sent Mail Customer Ledger")
            {
                ApplicationArea = all;
            }
            field("Sent Mail Purchase Order"; Rec."Sent Mail Purchase Order")
            {
                ApplicationArea = all;
            }
            field("Sent Mail Vendor Ledger"; Rec."Sent Mail Vendor Ledger")
            {
                ApplicationArea = all;
            }

        }
    }
}
