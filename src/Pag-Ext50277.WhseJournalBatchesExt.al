pageextension 50277 "Whse. Journal Batches_Ext" extends "Whse. Journal Batches"
{
    layout
    {
        addafter("Assigned User ID")
        {
            field("Template Type"; Rec."Template Type")
            {
                ApplicationArea = all;
            }
        }
    }
}
