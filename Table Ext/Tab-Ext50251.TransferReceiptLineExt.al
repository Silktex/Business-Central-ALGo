tableextension 50251 "Transfer Receipt Line_Ext" extends "Transfer Receipt Line"
{
    fields
    {
          field(50000;"Purchase Receipt No.";Code[20])
        {
            TableRelation = "Purch. Rcpt. Header"."No.";
        }
        field(50001;"Purchase Receipt Line No.";Integer)
        {
        }
    }
}
