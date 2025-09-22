pageextension 50253 "Location Card_Ext" extends "Location Card"
{
    layout
    {
        addafter("Pick According to FEFO")
        {
            field("stamps.com"; Rec."stamps.com")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the stamps.com field.';
            }
        }

        Moveafter("Directed Put-away and Pick"; "Use ADCS")

        modify("Use ADCS")
        {
            ApplicationArea = all;
            Visible = true;
        }

        addafter("Bin Policies")
        {
            group("RocketShipIt Details")
            {
                Caption = 'RocketShipIt Details';
                group("UPS Details")
                {
                    Caption = 'UPS Details';
                    field("License Number"; Rec."License Number")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the License Number field.';
                    }
                    field("UPS Account"; Rec."UPS Account")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the UPS Account field.';
                    }
                    field("UPS User Name"; Rec."UPS User Name")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the UPS User Name field.';
                    }
                    field("UPS Password"; Rec."UPS Password")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the UPS Password field.';
                    }
                }
                group("Fedex Details")
                {
                    Caption = 'Fedex Details';

                    field("Fedex URL"; Rec."Fedex URL")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Fedex URL field.';
                    }
                    field("Certificate Number"; Rec."Certificate Number")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Certificate Number field.';
                    }
                    field("FedEx Account"; Rec."FedEx Account")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the FedEx Account field.';
                    }
                    field("Fedex Password"; Rec."Fedex Password")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Fedex Password field.';
                    }
                    field("Fedex Meter No"; Rec."Fedex Meter No")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Fedex Meter No field.';
                    }
                }
                group("Stamps Details")
                {
                    Caption = 'Stamps Details';
                    field("Stamps Username"; Rec."Stamps Username")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Stamps Username field.';
                    }
                    field("Stamps Password"; Rec."Stamps Password")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Stamps Password field.';
                    }
                    field("Stamps Authentication Id"; Rec."Stamps Authentication Id")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Stamps Authentication Id field.';
                    }
                }
                group(USPS)
                {
                    Caption = 'USPS';

                    field("USPS Role Name"; Rec."USPS Role Name")
                    {
                        ToolTip = 'Specifies the value of the USPS Role Name field.';
                        ApplicationArea = All;
                    }
                    field("USPS CRID"; Rec."USPS CRID")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the USPS CRID field.', Comment = '%';
                    }
                    field("USPS MID"; Rec."USPS MID")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the USPS MID field.', Comment = '%';
                    }
                    field("USPS Manifest MID"; Rec."USPS Manifest MID")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the USPS Manifest MID field.', Comment = '%';
                    }
                    field("USPS Account Type"; Rec."USPS Account Type")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the USPS Account Type field.', Comment = '%';
                    }
                    field("USPS Account No."; Rec."USPS Account No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the USPS Account No. field.', Comment = '%';
                    }
                }
            }
        }
    }
}
