pageextension 50224 "Purch. Comment List_Ext" extends "Purch. Comment List"
{
    layout
    {
        addafter(Comment)
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Document Line No."; Rec."Document Line No.")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
    }
}
