tableextension 50210 "Item Ledger Entry_Ext" extends "Item Ledger Entry"
{
    fields
    {
        field(50000; "Quality Grade"; Option)
        {
            Caption = 'Quality Grade';
            DataClassification = ToBeClassified;
            Description = 'SKNAV11.00';
            OptionCaption = ' ,A,B,C,D,E,F,X';
            OptionMembers = " ",A,B,C,D,E,F,X;
        }
        field(50001; "Dylot No."; Code[20])
        {
            Caption = 'Dylot No.';
            DataClassification = ToBeClassified;
            Description = 'SKNAV11.00';
        }
        field(50002; "ETA Date"; Date)
        {
            Caption = 'ETA Date';
            DataClassification = ToBeClassified;
            Description = 'SKNAV11.00';
        }
        field(50003; "Total Requested-HH"; Decimal)
        {
            CalcFormula = Lookup("Reservation Entry".Quantity WHERE(Positive = FILTER(false), "Lot No." = FIELD("Lot No.")));
            Description = 'SKNAV11.00';
            FieldClass = FlowField;
        }
        field(50004; "QR Code"; BLOB)
        {
            DataClassification = ToBeClassified;
            Description = 'SKNAV11.00';
        }

        // field(50005; "Related Bin Code"; Code[20])
        // {
        //     Caption = 'Bin Code';
        //     FieldClass = FlowField;
        //     CalcFormula = lookup("Bin Content"."Bin Code" where("Location Code" = field("Location Code"), "Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No. Filter" = field("Lot No.")));
        //     Editable = false;
        // }
    }

}
