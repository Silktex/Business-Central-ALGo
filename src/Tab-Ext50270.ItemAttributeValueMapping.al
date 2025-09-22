tableextension 50270 "Item Attribute Value Mapping" extends "Item Attribute Value Mapping"
{
    fields
    {
        field(50001; "Item Attribute Name"; Text[250])
        {
            Caption = 'Item Attribute Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Attribute".Name WHERE("ID" = FIELD("Item Attribute ID")));
        }

        field(50002; "Item Attribute Value Name"; Text[250])
        {
            Caption = 'Item Attribute Value';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Attribute Value".Value where("ID" = field("Item Attribute Value ID")));
        }
    }
}
