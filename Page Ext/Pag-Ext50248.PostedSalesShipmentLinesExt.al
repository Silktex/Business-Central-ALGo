pageextension 50248 PostedSalesShipmentLines_Ext extends "Posted Sales Shipment Lines"
{
    layout
    {
        addafter(Type)
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
