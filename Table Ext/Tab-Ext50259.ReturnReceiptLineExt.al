tableextension 50259 "Return Receipt Line_Ext" extends "Return Receipt Line"
{
    fields
    {
        field(50006; "Quantity Variance %"; Decimal)
        {
        }
        field(50007; "Original Quantity"; Decimal)
        {
        }
        field(50050; Observation; Code[10])
        {
            Description = 'spdspl sushant';
            TableRelation = "Return Reason";
        }
    }
}