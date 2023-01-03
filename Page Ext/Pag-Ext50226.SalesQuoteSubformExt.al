pageextension 50226 "Sales Quote Subform_Ext" extends "Sales Quote Subform"
{
    layout
    {
        addafter("Location Code")
        {
            field("Minimum Qty"; Rec."Minimum Qty")
            {
                ApplicationArea = all;
            }
        }
    }
}
