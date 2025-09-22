tableextension 50241 "Purchase Header Archive_Ext" extends "Purchase Header Archive"
{
    fields
    {
        field(50050; "Short Close"; Boolean)
        {
        }
        field(50051; "Ship Via"; Text[30])
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
