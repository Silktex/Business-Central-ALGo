pageextension 50202 "Payment Terms_Ext" extends "Payment Terms"
{
    layout
    {
        addafter(Description)
        {
            field("Dont Ship"; Rec."Dont Ship")
            {
                ApplicationArea = all;
            }
        }
    }
}
