table 50018 "SalesPerson Commision"
{

    fields
    {
        field(1; "Customer Price Group"; Code[20])
        {
            TableRelation = "Customer Price Group".Code;
        }
        field(2; "Product Group Code"; Code[20])
        {
        }
        field(3; "Discount %"; Decimal)
        {
        }
        field(4; "Commision %"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Customer Price Group", "Product Group Code", "Discount %")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

