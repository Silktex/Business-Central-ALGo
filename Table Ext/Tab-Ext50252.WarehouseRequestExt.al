tableextension 50252 "Warehouse Request_Ext" extends "Warehouse Request"
{
    fields
    {

        field(50000; "Shipping Agent Service Code1"; Code[10])
        {
            Caption = 'Shipping Agent Service Code New';
            TableRelation = "Shipping Agent Services".Code WHERE("Shipping Agent Code" = FIELD("Shipping Agent Code"));

            trigger OnValidate()
            begin
                //TESTFIELD(Status,Status::Open);
                //GetShippingTime(FIELDNO("Shipping Agent Service Code"));
                //UpdateSalesLines(FIELDCAPTION("Shipping Agent Service Code"),CurrFieldNo <> 0);
            end;
        }
        field(50001; "Shipping Account No."; Code[20])
        {
        }
        field(50002; "Charges Pay By"; Option)
        {
            OptionCaption = ' ,SENDER,RECEIVER';
            OptionMembers = " ",SENDER,RECEIVER;
        }
        field(50055; "Third Party"; Boolean)
        {
        }
        field(50056; "Third Party Account No."; Code[20])
        {

        }
    }
}