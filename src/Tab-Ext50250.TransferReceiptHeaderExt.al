tableextension 50250 "Transfer Receipt Header_Ext" extends "Transfer Receipt Header"
{
    fields
    {
        field(50001; "Sales Order No"; Code[20])
        {
            Description = 'SPD MS 050815';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = FILTER(Order));
        }
        field(50002; "Consignment No."; Text[30])
        {
        }
        field(50003; "Ship Via"; Code[20])
        {
        }
        field(50004; "Expected Receipt Days"; DateFormula)
        {
        }
        field(50005; "Expected Receipt Date"; Date)
        {
        }
        field(50100; "Charges Pay By"; Option)
        {
            Description = 'Handheld';
            OptionCaption = ' ,SENDER,RECEIVER';
            OptionMembers = " ",SENDER,RECEIVER;
        }

    }
}
