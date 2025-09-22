table 50051 "Auto Email Setup"
{

    fields
    {
        field(1; "Entry No."; integer)
        {
            Caption = 'Entry No.';
            Editable = true;
            AutoIncrement = true;

        }
        field(2; "Report Id"; integer)
        {
            Caption = 'Report Id';
            Editable = true;
        }
        field(3; "Email Name"; Text[80])
        {
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            Editable = true;
            OptionCaption = ' ,To,CC,BCC';
            OptionMembers = " ",To,CC,BCC;
        }
        field(5; "Email ID"; Text[80])
        {
        }

    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

}

