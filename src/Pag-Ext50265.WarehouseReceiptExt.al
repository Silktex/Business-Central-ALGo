pageextension 50265 "Warehouse Receipt_Ext" extends "Warehouse Receipt"
{
    layout
    {
        addafter("Sorting Method")
        {
            field("ETA Date"; Rec."ETA Date")
            {
                ApplicationArea = all;
            }
        }
    }
}
