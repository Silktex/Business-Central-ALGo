pageextension 50263 "Posted Transfer Receipt_Ext" extends "Posted Transfer Receipt"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("Link To SO"; Rec."Sales Order No")
            {
                ApplicationArea = all;
            }
        }
    }
}
