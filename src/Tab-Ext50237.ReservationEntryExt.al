tableextension 50237 "Reservation Entry_Ext" extends "Reservation Entry"
{
    fields
    {
        field(50000; "Quality Grade"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'SKNAV11.00';
            OptionCaption = ' ,A,B,C,D,E,F,X';
            OptionMembers = " ",A,B,C,D,E,F,X;
        }
        field(50001; "Dylot No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'SKNAV11.00';
        }
        field(50004; "QR Code"; BLOB)
        {
            DataClassification = ToBeClassified;
            Description = 'SKNAV11.00';
        }
        field(50005; "Item Description"; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            Caption = 'Item Description';
            Description = 'New';
            FieldClass = FlowField;
        }
    }
    keys
    {
        // key(Key25; Description)
        // {
        // }
    }
}
