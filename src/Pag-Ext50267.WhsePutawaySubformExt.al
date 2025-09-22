pageextension 50267 "Whse. Put-away Subform_Ext" extends "Whse. Put-away Subform"
{
    layout
    {
        addafter("Source No.")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
