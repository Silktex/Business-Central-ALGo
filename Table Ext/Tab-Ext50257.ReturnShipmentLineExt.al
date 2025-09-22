tableextension 50257 "Return Shipment Line_Ext" extends "Return Shipment Line"
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
