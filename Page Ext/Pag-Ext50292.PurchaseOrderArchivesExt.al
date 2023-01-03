pageextension 50292 "Purchase Order Archives_Ext" extends "Purchase Order Archives"
{
    layout
    {
        addafter("Shipment Method Code")
        {
            field("Vendor Order No."; Rec."Vendor Order No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
