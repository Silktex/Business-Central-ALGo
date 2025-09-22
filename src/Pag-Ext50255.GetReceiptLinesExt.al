pageextension 50255 "Get Receipt Lines_Ext" extends "Get Receipt Lines"
{
    layout
    {
        moveafter("Qty. Rcd. Not Invoiced"; "Location Code")
        addafter("Location Code")
        {
            field("Bin Code"; Rec."Bin Code")
            {
                ApplicationArea = all;
            }
        }
    }
}
