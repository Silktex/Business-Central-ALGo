pageextension 50233 PostedPurchaseRcptSubform_Ext extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addafter(Correction)
        {
            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
                ApplicationArea = all;
            }
        }
    }
}
