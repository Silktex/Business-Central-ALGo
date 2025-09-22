tableextension 50300 "Price Calculation Buffer_Ext" extends "Price Calculation Buffer"
{
    fields
    {
        field(50000; "Item Category"; Code[20])
        {
            Caption = 'Item Category';
            DataClassification = ToBeClassified;
        }
    }
}
