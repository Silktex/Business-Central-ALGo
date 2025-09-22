tableextension 50226 "Purch. Rcpt. Header_Ext" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50027; "ETA Date"; Date)
        {
        }
        field(50051; "Ship Via"; Code[20])
        {
        }
        field(50052; "Consignment No."; Text[30])
        {
        }
        field(50053; "File No."; Text[50])
        {
            Description = 'SPD MS 270815';
        }
    }
}
