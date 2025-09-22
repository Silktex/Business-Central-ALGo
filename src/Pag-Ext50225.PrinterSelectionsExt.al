pageextension 50225 "Printer Selections_Ext" extends "Printer Selections"
{
    layout
    {
        addafter("Printer Name")
        {
            field("Label Printer IP"; Rec."Label Printer IP")
            {
                ApplicationArea = all;
            }
        }
    }
}
