tableextension 50208 "Vendor Ledger Entry_Ext" extends "Vendor Ledger Entry"
{
    fields
    {
        field(50000; "Agreement No."; Code[20])
        {
            Caption = 'Agreement No.';
            // TableRelation = Table50060.Field2 WHERE(Field1 = FIELD("Vendor No.")); //VR same error in old verison
        }
        field(50001; Skip; Boolean)
        {
        }
    }
}
