pageextension 50234 "Posted Purchase Invoice_Ext" extends "Posted Purchase Invoice"
{
    layout
    {
        addafter("Tax Liable")
        {
            field("Ship Via"; Rec."Ship Via")
            {
                ApplicationArea = all;
            }
        }
    }
}
