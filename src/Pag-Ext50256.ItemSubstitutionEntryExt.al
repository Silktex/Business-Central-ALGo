pageextension 50256 "Item Substitution Entry_Ext" extends "Item Substitution Entry"
{
    layout
    {
        addafter(Condition)
        {
            field("No."; Rec."No.")
            {
                ApplicationArea = all;
            }
            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = all;
            }
        }
    }
}
