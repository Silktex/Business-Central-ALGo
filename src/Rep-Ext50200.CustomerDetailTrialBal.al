reportextension 50200 CustomerDetailTrialBal extends "Customer - Detail Trial Bal."
{
    dataset
    {
        modify("Cust. Ledger Entry")
        {
            trigger OnBeforePreDataItem()
            begin
                SetRange("Future/Paid Invoice", false);
            end;
        }
    }
}
