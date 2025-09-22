table 50050 HandHeld
{

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            Editable = true;
            OptionCaption = ' ,Put-away,Pick,Movement,Invt. Put-away,Invt. Pick,Invt. Movement';
            OptionMembers = " ","Put-away",Pick,Movement,"Invt. Put-away","Invt. Pick","Invt. Movement";
        }
        field(2; No; Code[20])
        {
            Caption = 'No.';
            Editable = true;

            trigger OnValidate()
            begin
                /*IF "No." <> xRec."No." THEN BEGIN
                  NoSeriesMgt.TestManual(GetNoSeriesCode);
                  "No. Series" := '';
                END;
                 */

            end;
        }
        field(3; "Item No"; Code[20])
        {
            Editable = true;
        }
        field(4; Quantity; Decimal)
        {
            DecimalPlaces = 2 : 2;
            Editable = true;
        }
        field(5; "Bin Code"; Code[20])
        {
            TableRelation = Bin.Code;
        }
        field(6; "Zone Code"; Code[20])
        {
        }
        field(7; "Lot No"; Text[30])
        {
        }
        field(8; "Creation Time"; Time)
        {
            Editable = true;
        }
        field(9; "Register Time"; Time)
        {
            Editable = true;
        }
        field(10; "Action Type"; Option)
        {
            Editable = true;
            OptionMembers = " ",Take,Place;
        }
        field(11; "User Id"; Text[100])
        {
            Editable = true;
        }
        field(12; "Qty to Handle"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(13; "Line No"; Integer)
        {
            Editable = true;
        }
        field(14; Description; Text[50])
        {
            Editable = true;
        }
        field(15; "Location Code"; Code[10])
        {
            TableRelation = Location;
        }
        field(16; Open; Boolean)
        {
        }
        field(17; "Outstanding Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Warehouse Activity Line"."Qty. Outstanding" WHERE("Activity Type" = FIELD(Type), "No." = FIELD(No), "Lot No." = FIELD("Lot No"), "Action Type" = FILTER(Take)));
            Editable = false;
        }
    }

    keys
    {
        key(Key1; Type, No, "Item No", "Bin Code", "Zone Code", "Lot No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

