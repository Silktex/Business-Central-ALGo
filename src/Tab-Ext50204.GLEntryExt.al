tableextension 50204 GLEntry_Ext extends "G/L Entry"
{
    fields
    {
        field(50000; "Sales Invoice Ref."; Code[10])
        {
            Caption = 'Sales Invoice Ref.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
}
