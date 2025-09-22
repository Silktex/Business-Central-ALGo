table 50005 "TLI Stax Payment Setup"
{
    Caption = 'Stax Payment Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "Base URL"; Text[250])
        {
            Caption = 'Base URL';
            DataClassification = CustomerContent;
        }
        field(3; Enabled; Boolean)
        {
            Caption = 'Enabled';
            DataClassification = CustomerContent;
        }
        field(4; "Payment Token"; Text[50])
        {
            Caption = 'Payment Token';
            DataClassification = CustomerContent;
        }
        field(6; "Show Payload"; Boolean)
        {
            Caption = 'Show Payload';
            DataClassification = CustomerContent;
        }
        field(10; "User Name"; Text[100])
        {
            Caption = 'User Name';
            DataClassification = CustomerContent;
        }
        field(11; "Auth Token / Password"; Text[1000])
        {
            Caption = 'Auth Token / Password';
            DataClassification = CustomerContent;
        }
        field(20; "Payment Link API"; Text[100])
        {
            Caption = 'Payment Link API';
            DataClassification = CustomerContent;
        }
        field(21; "Customer API"; Text[100])
        {
            Caption = 'Customer API';
            DataClassification = CustomerContent;
        }
        field(22; "Payment Method API"; Text[100])
        {
            Caption = 'Payment Method API';
            DataClassification = CustomerContent;
        }
        field(23; "Charge Payment Method API"; Text[100])
        {
            Caption = 'Charge Payment Method API';
            DataClassification = CustomerContent;
        }
        field(24; "Transaction API"; Text[100])
        {
            Caption = 'Transaction API';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
