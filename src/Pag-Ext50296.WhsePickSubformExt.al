pageextension 50296 WhsePickSubform_Ext extends "Whse. Pick Subform"
{
    layout
    {
        modify("Lot No.")
        {
            Visible = true;
        }
        modify(Quantity)
        {
            Visible = false;
        }
        addafter(Quantity)
        {
            field(QuantityNew; Rec.QuantityNew)
            {
                ApplicationArea = all;
            }
        }
    }
}
