tableextension 50223 "Sales Invoice Line_Ext" extends "Sales Invoice Line"
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

    keys
    {
        key(Custom1; "Sell-to Customer No.", "Posting Date")
        {
            MaintainSQLIndex = false;
            SumIndexFields = Amount, "Amount Including VAT", "Inv. Discount Amount";
        }
    }
}
