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
        // >>>>>>>>>>>>>> START OF FIX <<<<<<<<<<<<<<<
        field(5; "Variant Code"; Code[10]) // New field for Variant Code
        {
            DataClassification = ToBeClassified;
            // Establish a table relation to the "Item Variant" table
            // This ensures data integrity by linking the variant to the item.
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        // >>>>>>>>>>>>>> END OF FIX <<<<<<<<<<<<<<<<<
    }

    keys
    {
        // >>>>>>>>>>>>>> START OF FIX <<<<<<<<<<<<<<<
        // Modify the primary key to include "Variant Code"
        // This is crucial if you expect to have different re-order settings
        // for the same Item and Customer, but for different variants.
        key(Key1; "Item No.", "Customer No.")
        {
            Clustered = true;
        }
        key(Key2; "Variant Code")
        {
            Clustered = false;
        }
        // >>>>>>>>>>>>>> END OF FIX <<<<<<<<<<<<<<<<<
    }

    fieldgroups
    {
    }
}