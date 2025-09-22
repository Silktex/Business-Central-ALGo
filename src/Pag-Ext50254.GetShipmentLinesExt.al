pageextension 50254 "Get Shipment Lines_Ext" extends "Get Shipment Lines"
{
    layout
    {
        movebefore("Document No."; "Bill-to Customer No.")
        addafter("Bill-to Customer No.")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
