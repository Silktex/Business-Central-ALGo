tableextension 50240 "Sales Line Archive_Ext" extends "Sales Line Archive"
{
    fields
    {
        field(50006; "Quantity Variance %"; Decimal)
        {
        }
        field(50007; "Original Quantity"; Decimal)
        {
        }
        field(50008; "Customer Item No."; Text[30])
        {
        }
        field(50050; Observation; Code[10])
        {
            Description = 'spdspl sushant';
            TableRelation = "Return Reason";
        }
    }
}
