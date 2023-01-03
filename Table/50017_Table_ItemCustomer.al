table 50017 "Item Customer"
{
    Caption = 'Item Vendor';
    LookupPageID = 50017;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            NotBlank = true;
            TableRelation = Item;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            NotBlank = true;
            TableRelation = Customer;
        }
        field(6; "Lead Time Calculation"; DateFormula)
        {
            Caption = 'Lead Time Calculation';
        }
        field(7; "Customer Item No."; Text[20])
        {
            Caption = 'Customer Item No.';
        }
        field(5700; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(5701; Description; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Customer No.", "Item No.", "Variant Code")
        {
            Clustered = true;
        }
        key(Key2; "Item No.", "Variant Code", "Customer No.")
        {
        }
        key(Key3; "Customer No.", "Customer Item No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Vend: Record Vendor;
        DistIntegration: Codeunit "Dist. Integration";
}

