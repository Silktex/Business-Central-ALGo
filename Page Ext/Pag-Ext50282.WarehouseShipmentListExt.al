pageextension 50282 "Warehouse Shipment List_Ext" extends "Warehouse Shipment List"
{
    layout
    {
        addafter("No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
