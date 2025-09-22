table 50025 "Mail Detail"
{
    LookupPageID = 50025;

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; Type; Text[30])
        {
        }
        field(3; "Source No."; Code[20])
        {
        }
        field(4; "Date Time"; DateTime)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Source No.", "Date Time")
        {
        }
    }

    fieldgroups
    {
    }
}

