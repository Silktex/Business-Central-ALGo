table 50000 "Tracking No."
{

    fields
    {
        field(1; "Warehouse Shipment No"; Code[20])
        {
        }
        field(2; "Tracking No."; Text[30])
        {
        }
        field(3; Image; BLOB)
        {
        }
        field(4; "Packing No."; Code[20])
        {
        }
        field(5; "Creation Date"; Date)
        {
        }
        field(6; "Source Document No."; Code[20])
        {
        }
        field(7; "Service Name"; Code[30])
        {
        }
        field(8; "Transaction No."; Code[30])
        {
        }
        field(9; "Charges Pay By"; Text[10])
        {
        }
        field(10; "No. of Boxes"; Integer)
        {
        }
        field(11; "Gross Weight"; Decimal)
        {
        }
        field(12; "Handling Charges"; Decimal)
        {
        }
        field(13; "Insurance Charges"; Decimal)
        {
        }
        field(14; "Cash On Delivery"; Boolean)
        {
        }
        field(15; "Signature Required"; Boolean)
        {
        }
        field(16; "Shipping Agent Service Code"; Code[10])
        {
        }
        field(17; "Box Code"; Code[20])
        {
        }
        field(18; "Shipping Account No"; Code[10])
        {
        }
        field(19; "COD Amount"; Decimal)
        {
        }
        field(20; "Billed Weight"; Decimal)
        {
        }
        field(21; "Total Base Charge"; Decimal)
        {
        }
        field(22; INSURED_VALUE; Decimal)
        {
        }
        field(23; SIGNATURE_OPTION; Decimal)
        {
        }
        field(24; "Total Charges"; Decimal)
        {
        }
        field(25; "Total Discounts"; Decimal)
        {
        }
        field(26; DELIVERY_AREA; Decimal)
        {
        }
        field(27; FUEL; Decimal)
        {
        }
        field(28; "Transportation Charges"; Decimal)
        {
        }
        field(29; "Service Option Charges"; Decimal)
        {
        }
        field(30; "Void Entry"; Boolean)
        {
            Description = 'Void';
        }
    }

    keys
    {
        key(Key1; "Warehouse Shipment No", "Tracking No.")
        {
            Clustered = true;
        }
        key(Key2; "Source Document No.")
        {
        }
    }

    fieldgroups
    {
    }
}

