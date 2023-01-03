pageextension 50253 "Location Card_Ext" extends "Location Card"
{
    layout
    {
        addafter("Pick According to FEFO")
        {
            field("stamps.com"; Rec."stamps.com")
            {
                ApplicationArea = all;
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
                    }
                    field("UPS Account"; Rec."UPS Account")
                    {
                        ApplicationArea = all;
                    }
                    field("UPS User Name"; Rec."UPS User Name")
                    {
                        ApplicationArea = all;
                    }
                    field("UPS Password"; Rec."UPS Password")
                    {
                        ApplicationArea = all;
                    }
                }
                group("Fedex Details")
                {
                    Caption = 'Fedex Details';

                    field("Fedex URL"; Rec."Fedex URL")
                    {
                        ApplicationArea = all;
                    }
                    field("Certificate Number"; Rec."Certificate Number")
                    {
                        ApplicationArea = all;
                    }
                    field("FedEx Account"; Rec."FedEx Account")
                    {
                        ApplicationArea = all;
                    }
                    field("Fedex Password"; Rec."Fedex Password")
                    {
                        ApplicationArea = all;
                    }
                    field("Fedex Meter No"; Rec."Fedex Meter No")
                    {
                        ApplicationArea = all;
                    }
                }
                group("Stamps Details")
                {
                    Caption = 'Stamps Details';
                    field("Stamps Username"; Rec."Stamps Username")
                    {
                        ApplicationArea = all;
                    }
                    field("Stamps Password"; Rec."Stamps Password")
                    {
                        ApplicationArea = all;
                    }
                    field("Stamps Authentication Id"; Rec."Stamps Authentication Id")
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }
    }
}
