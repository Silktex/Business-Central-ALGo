table 50006 "Item Spec Cleaning Code"
{
    DrillDownPageID = 50006;
    LookupPageID = 50006;

    fields
    {
        field(1; "Code"; Code[50])
        {
        }
        field(2; Description; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

