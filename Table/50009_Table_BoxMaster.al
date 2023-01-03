table 50009 "Box Master"
{
    DataCaptionFields = "Box Code", Description;
    DrillDownPageID = 50009;
    LookupPageID = 50009;

    fields
    {
        field(1; "Box Code"; Code[20])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(3; Height; Decimal)
        {
        }
        field(4; Width; Decimal)
        {
        }
        field(5; Length; Decimal)
        {
        }
        field(6; "Box Weight"; Decimal)
        {
        }
        field(7; "Shipping Agent Service Code"; Code[20])
        {
            TableRelation = "Shipping Agent Services".Code;
        }
        field(8; "Show in Handheld"; Boolean)
        {
            Description = 'Handheld';
        }
    }

    keys
    {
        key(Key1; "Box Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

