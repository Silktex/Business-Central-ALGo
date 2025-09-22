pageextension 50235 PostedPurchInvoiceSubform_Ext extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addbefore(Type)
        {
            field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
