table 50004 "Handheld Login"
{

    fields
    {
        field(1; "User ID"; Code[20])
        {
        }
        field(2; "User Name"; Text[30])
        {
        }
        field(3; Password; Text[30])
        {
        }
        field(4; "Warehouse Employee"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "User ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

