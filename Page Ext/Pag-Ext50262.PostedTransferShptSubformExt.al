pageextension 50262 PostedTransferShptSubform_Ext extends "Posted Transfer Shpt. Subform"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("Purchase Receipt No."; Rec."Purchase Receipt No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
