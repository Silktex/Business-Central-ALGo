pageextension 50269 "Shipping Agent Services_Ext" extends "Shipping Agent Services"
{
    layout
    {
        addbefore(Code)
        {
            field("Shipping Agent Code"; Rec."Shipping Agent Code")
            {
                ApplicationArea = all;
            }
        }
    }
}
