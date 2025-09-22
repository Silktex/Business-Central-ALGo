tableextension 50269 "SILK Inventory Setup" extends "Inventory Setup"
{
    fields
    {
        field(50200; "ZPL Print IP Add. Label Only"; Text[250])
        {
            Caption = 'IP Address Label Only';
            DataClassification = CustomerContent;
        }
        field(50201; "ZPL Print IP Add. Ship Label"; Text[250])
        {
            Caption = 'IP Address Shipping Label';
            DataClassification = CustomerContent;
        }
    }
}
