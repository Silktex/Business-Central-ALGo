tableextension 50207 Vendor_Ext extends Vendor
{
    fields
    {
        field(50000; "Email CC"; Text[30])
        {
            Caption = 'Email CC';
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
    }
}
