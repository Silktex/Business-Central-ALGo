tableextension 50235 "Purchases & Payables Setup_Ext" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "Email Id"; Text[50])
        {
            ExtendedDatatype = EMail;
        }
        field(50001; "Allow Quantity Variance"; Boolean)
        {
        }
        field(50002; "Define % for Variance"; Boolean)
        {
        }

    }
}
