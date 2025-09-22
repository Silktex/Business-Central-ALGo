tableextension 50230 "Purch. Cr. Memo Hdr_Ext" extends "Purch. Cr. Memo Hdr."
{
    fields
    {
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
