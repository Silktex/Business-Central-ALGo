tableextension 50216 "Company Information_Ext" extends "Company Information"
{
    fields
    {
        field(50001; IsUpdateNopDatabase; Boolean)
        {
        }
        field(50002; NopDataHandlerIP; Text[100])
        {
        }
        field(50003; RocketShipIP; Text[100])
        {
        }
        field(50004; "D-U-N-S Number"; Integer)
        {
        }
        field(50005; "NOP Sync URL"; Text[100])
        {
            Description = 'NOP';
        }
        field(50006; "NOP Sync URL Activate"; Boolean)
        {
            Description = 'NOP';
        }
        field(50007; "Item Sync Activate NOP"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'NOP';
        }
        field(50008; "Customer Sync Activate NOP"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'NOP';
        }
        field(50009; "Sales Order Sync Activate NOP"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'NOP';
        }
        field(50010; "Sales Ship Sync Activate NOP"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'NOP';
        }
        field(50011; "Stamp Postage Nos."; Code[20])
        {
            Caption = 'Stamp Postage Nos.';
            DataClassification = ToBeClassified;
            Description = 'Meghna';
            TableRelation = "No. Series";
        }
        field(50012; "Stamps Username"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'Stamps';
        }
        field(50013; "Stamps Password"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'Stamps';
        }
        field(50014; "Stamps Integration ID"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'Stamps';
        }
        field(50015; "Stamps URL"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'Stamps';
        }
        field(50020; MerchantAuthenticationName; Text[20])
        {

        }
        field(50021; MerchantTransactionKey; Text[20])
        { }
        field(50022; "Report Selection"; Option)
        {
            OptionMembers = "",Slik,POSH;
        }
        field(50023; "Address Validation URL"; Text[100])
        {

        }
        field(50024; "Auth Dot Net URL"; Text[100])
        {

        }
        field(50025; "Fedex Lebal Type"; Text[10])
        { }
        field(50026; "Test MIS E-Mail"; Text[240])
        { }
    }
}
