tableextension 50203 Location_Ext extends Location
{
    fields
    {
        field(50000; "License Number"; Text[50])
        {
        }
        field(50001; "Certificate Number"; Text[50])
        {
        }
        field(50002; "UPS Account"; Text[6])
        {
        }
        field(50003; "FedEx Account"; Text[15])
        {
        }
        field(50004; "stamps.com"; Text[50])
        {
        }
        field(50005; "Fedex Password"; Text[50])
        {
        }
        field(50006; "Fedex Meter No"; Text[50])
        {
        }
        field(50007; "UPS User Name"; Text[50])
        {
        }
        field(50008; "UPS Password"; Text[50])
        {
        }
        field(50009; "Stamps Username"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'Stamps';
        }
        field(50010; "Stamps Password"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'Stamps';
        }
        field(50011; "Stamps Authentication Id"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'Stamps';
        }

        field(50012; "Fedex URL"; Text[100])
        {
        }

        field(50050; "USPS Role Name"; Text[50])
        {
        }
        field(50051; "USPS CRID"; Text[15])
        {
        }
        field(50052; "USPS MID"; Text[10])
        {
        }
        field(50053; "USPS Manifest MID"; Text[10])
        {
        }
        field(50054; "USPS Account Type"; Text[20])
        {
        }
        field(50055; "USPS Account No."; Text[10])
        {
        }


    }
}
