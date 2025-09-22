tableextension 50249 "Transfer Shipment Line_Ext" extends "Transfer Shipment Line"
{
    fields
    {
        field(50000; "Purchase Receipt No."; Code[20])
        {
            TableRelation = "Purch. Rcpt. Header"."No.";
        }
        field(50001; "Purchase Receipt Line No."; Integer)
        {
        }
        field(50010; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
        }
        field(50011; "Sales Order Line No."; Integer)
        {
            Caption = 'Sales Order Line No.';
        }
        field(50012; "SLK Instructions"; Text[100])
        {
            Caption = 'Instructions';
        }

    }
}
