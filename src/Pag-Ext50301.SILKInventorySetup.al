pageextension 50301 "SILK Inventory Setup" extends "Inventory Setup"
{
    layout
    {
        addlast(General)
        {
            field("ZPL Print IP Address"; Rec."ZPL Print IP Add. Label Only")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the ZPL Print IP Address field.';
            }
        }
    }
}
