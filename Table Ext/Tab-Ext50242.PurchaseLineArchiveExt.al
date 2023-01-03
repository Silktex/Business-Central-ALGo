tableextension 50242 "Purchase Line Archive_Ext" extends "Purchase Line Archive"
{
    fields
    {
        field(50000; "Quantity Variance %"; Decimal)
        {
        }
        field(50001; "Original Quantity"; Decimal)
        {

            trigger OnValidate()
            begin
                //VALIDATE(Quantity,"Original Quantity");
            end;
        }

    }
}
