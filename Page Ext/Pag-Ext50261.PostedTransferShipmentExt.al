pageextension 50261 "Posted Transfer Shipment_Ext" extends "Posted Transfer Shipment"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("Link To SO"; Rec."Sales Order No")
            {
                ApplicationArea = all;
            }
        }
    }
}
