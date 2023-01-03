pageextension 50227 "General Ledger Setup_Ext" extends "General Ledger Setup"
{
    layout
    {
        addafter("Print VAT specification in LCY")
        {
            field("Amount Decimal Places"; Rec."Amount Decimal Places")
            {
                ApplicationArea = all;
            }
        }
        modify("Adjust for Payment Disc.")
        {
            Caption = 'Adjust for Tax Payment Disc.';
            Visible = true;
        }
        modify("Electronic Invoice")
        {
            Visible = true;
        }
    }
}
