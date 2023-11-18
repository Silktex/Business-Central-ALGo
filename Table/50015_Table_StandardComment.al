table 50015 "Standard Comment"
{
    LookupPageID = 50015;

    fields
    {
        field(1; "Product Code"; Code[20])
        {
            TableRelation = "Item Category".Code;
        }
        field(2; "Sales Type"; Option)
        {
            OptionCaption = ',Customer,All Customer,Customer Price Group,Vendor,All Vendor';
            OptionMembers = ,Customer,"All Customer","Customer Price Group",Vendor,"All Vendor";
        }
        field(3; "Sales Code"; Code[20])
        {
            TableRelation = IF ("Sales Type" = FILTER(Customer)) Customer."No." ELSE
            IF ("Sales Type" = FILTER("Customer Price Group")) "Customer Price Group".Code else
            if ("Sales Type" = filter(Vendor)) Vendor."No.";
        }
        field(4; Comment; Text[250])
        {
        }
        field(5; "Comment 2"; Text[250])
        {
        }
        field(6; Internal; Boolean)
        {
        }
        field(7; External; Boolean)
        {
        }
        field(8; "From Date"; Date)
        {
        }
        field(9; "Comment 3"; Text[250])
        {
        }
        field(10; "Comment 4"; Text[250])
        {
        }
        field(11; "Comment 5"; Text[250])
        {
        }
        field(14; Internal2; Boolean)
        {
        }
        field(15; External2; Boolean)
        {
        }
        field(16; Internal3; Boolean)
        {
        }
        field(17; External4; Boolean)
        {
        }
        field(18; Internal5; Boolean)
        {
        }
        field(19; External5; Boolean)
        {
        }
        field(20; External3; Boolean)
        {
        }
        field(21; Internal4; Boolean)
        {
        }
        field(30; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        // key(Key1; "Product Code", "Sales Type", "Sales Code", "From Date")
        // {
        //     Clustered = true;
        // }
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Product Code", "Sales Type", "Sales Code", "From Date")
        {
        }
    }

    fieldgroups
    {
    }
}

