tableextension 50262 "Warehouse Entry_Ext" extends "Warehouse Entry"
{
    fields
    {
        field(50000; "Item Name"; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            FieldClass = FlowField;
        }
    }
}
