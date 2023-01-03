table 50007 "BACKING TABLE FOR NAV"
{

    fields
    {
        field(1; "Customer Type"; Option)
        {
            OptionCaption = 'All Customers,Customer Posting Group,Customer';
            OptionMembers = "All Customers","Customer Posting Group",Customer;
        }
        field(2; "Customer Code"; Code[20])
        {
            TableRelation = IF ("Customer Type" = CONST("Customer Posting Group")) "Customer Posting Group" ELSE
            IF ("Customer Type" = CONST(Customer)) Customer;
        }
        field(3; "Product Type"; Option)
        {
            OptionCaption = 'Item Category Code,Item';
            OptionMembers = "Item Category Code",Item;
        }
        field(4; "Product Code"; Code[20])
        {
            TableRelation = IF ("Product Type" = CONST("Item Category Code")) "Item Category".Code ELSE
            IF ("Product Type" = CONST(Item)) Item;
        }
        field(5; "Resc. Code"; Code[20])
        {
            TableRelation = Resource WHERE("Gen. Prod. Posting Group" = FILTER('BACKING'));
        }
        field(6; "Resc. Price"; Decimal)
        {
        }
        field(7; "Last Modified Date"; Date)
        {
            Editable = false;
        }
        field(8; "Last Modified User"; Code[20])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Customer Type", "Customer Code", "Product Type", "Product Code", "Resc. Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Last Modified Date" := TODAY;
        "Last Modified User" := USERID;
    end;

    trigger OnModify()
    begin
        "Last Modified Date" := TODAY;
        "Last Modified User" := USERID;
    end;
}

