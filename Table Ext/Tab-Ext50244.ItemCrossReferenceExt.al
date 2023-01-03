tableextension 50244 "Item Cross Reference_Ext" extends "Item Cross Reference"
{
    fields
    {
        field(50000; "Palcement Start Date"; Date)
        {
            Caption = 'Palcement Start Date';
            DataClassification = ToBeClassified;
        }
        field(50001; "Placement End Date"; Date)
        {
            Caption = 'Placement End Date';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(key20; "Placement End Date")
        {

        }
    }
}

tableextension 50268 "Item Reference_Ext" extends "Item Reference"
{
    fields
    {
        field(50000; "Palcement Start Date"; Date)
        {
            Caption = 'Palcement Start Date';
            DataClassification = ToBeClassified;
        }
        field(50001; "Placement End Date"; Date)
        {
            Caption = 'Placement End Date';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(key20; "Placement End Date")
        {

        }
    }
}