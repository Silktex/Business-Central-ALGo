table 50041 "Inventory Status Handheld"
{

    fields
    {
        field(1; "Location code"; Code[20])
        {
        }
        field(2; "Zone Code"; Code[20])
        {
        }
        field(3; "Bin Code"; Code[20])
        {
        }
        field(4; "Lot No."; Code[20])
        {
        }
        field(5; "Item No."; Code[20])
        {
        }
        field(6; Quantity; Decimal)
        {
            CalcFormula = Sum("Warehouse Entry".Quantity WHERE("Item No." = FIELD("Item No."), "Location Code" = FIELD("Location code"), "Zone Code" = FIELD("Zone Code"), "Bin Code" = FIELD("Bin Code"), "Lot No." = FIELD("Lot No.")));
            FieldClass = FlowField;
        }
        field(7; "Item Name"; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Item No.", "Location code", "Zone Code", "Bin Code", "Lot No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

