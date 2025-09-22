pageextension 50280 "Whse. Shipment Subform_Ext" extends "Whse. Shipment Subform"
{
    layout
    {
        addafter("Destination No.")
        {
            field("Net Weight"; Rec."Net Weight")
            {
                ApplicationArea = all;
            }
            field("Gross Weight"; Rec."Gross Weight")
            {
                ApplicationArea = all;
            }
            field("Tariff No."; Rec."Tariff No.")
            {
                ApplicationArea = all;
            }
            field("Country/Region Purchased Code"; Rec."Country/Region Purchased Code")
            {
                ApplicationArea = all;
            }
        }
    }
}
