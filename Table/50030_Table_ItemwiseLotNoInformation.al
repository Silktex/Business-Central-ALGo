table 50030 "Item wise Lot No. Information"
{
    DrillDownPageID = 6508;
    LookupPageID = 6508;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            NotBlank = true;
            TableRelation = Item;
        }
        field(2; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';
            NotBlank = true;
        }
    }

    keys
    {
        key(Key1; "Item No.", "Lot No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ItemTrackingComment: Record "Item Tracking Comment";
}

