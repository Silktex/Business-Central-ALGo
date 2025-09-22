pageextension 50218 "Sales Invoice Subform_Ext" extends "Sales Invoice Subform"
{
    layout
    {
        addafter("IC Partner Reference")
        {
            field(Backing; Rec.Backing)
            {
                ApplicationArea = all;
            }
        }
    }
}
