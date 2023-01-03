table 50031 "Item Customer Re-Order"
{

    fields
    {
        field(1; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item;
        }
        field(2; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(3; "Customer Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Customer Name 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Item No.", "Customer No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

