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
    }
}
