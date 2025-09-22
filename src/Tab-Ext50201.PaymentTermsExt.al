tableextension 50201 "Payment Terms_Ext" extends "Payment Terms"
{
    fields
    {
        field(50000; "Dont Ship"; Boolean)
        {
            Caption = 'Dont Ship';
            DataClassification = ToBeClassified;
            Description = 'If this is checked, shipping will be disabled for SO';
        }
    }
}
