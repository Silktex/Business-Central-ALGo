pageextension 50268 "Warehouse Setup_Ext" extends "Warehouse Setup"
{
    layout
    {
        addafter("Shipment Posting Policy")
        {
            field("Image Path"; Rec."Image Path")
            {
                ApplicationArea = all;
            }
            field("Packing No."; Rec."Packing No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
