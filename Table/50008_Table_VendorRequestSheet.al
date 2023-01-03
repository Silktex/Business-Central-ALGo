table 50008 "Vendor Request Sheet"
{

    fields
    {
        field(1; "Order No."; Code[20])
        {
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Order));
        }
        field(2; "Order Line No."; Integer)
        {
        }
        field(3; "Line No."; Integer)
        {
        }
        field(4; "Item No."; Code[20])
        {
            TableRelation = Item;
        }
        field(5; Quantity; Decimal)
        {
        }
        field(6; "Planned Shipment Date"; Date)
        {
        }
        field(7; "Requested Shipment Date"; Date)
        {
        }
        field(8; "Posting Date"; Date)
        {
        }
        field(9; Close; Boolean)
        {
        }
        field(10; "Posted Shipment No."; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Order No.", "Order Line No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Order Line No.")
        {
        }
        key(Key3; "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

