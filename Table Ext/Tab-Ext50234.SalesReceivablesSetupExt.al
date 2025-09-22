tableextension 50234 "Sales & Receivables Setup_Ext" extends "Sales & Receivables Setup"
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
        field(50003; "Start Date"; Date)
        {
        }
        field(50004; "End Date"; Date)
        {
        }
        field(50005; "Show Project Info"; Boolean)
        {
        }
        field(50009; "Custom Price Mgmt. Enabled"; Boolean)
        {
        }
    }
}
