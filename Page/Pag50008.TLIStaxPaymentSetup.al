page 50008 "TLI Stax Payment Setup"
{
    ApplicationArea = All;
    Caption = 'Stax Payment Setup';
    PageType = Card;
    SourceTable = "TLI Stax Payment Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("User Name"; Rec."User Name")
                {
                    ToolTip = 'Specifies the value of the User Name field.', Comment = '%';
                }
                field("Auth Token / Password"; Rec."Auth Token / Password")
                {
                    ToolTip = 'Specifies the value of the Auth Token / Password field.', Comment = '%';
                }
                field("Base URL"; Rec."Base URL")
                {
                    ToolTip = 'Specifies the value of the Base URL field.', Comment = '%';
                }
                field(Enabled; Rec.Enabled)
                {
                    ToolTip = 'Specifies the value of the Enabled field.', Comment = '%';
                }
                field("Show Payload"; Rec."Show Payload")
                {
                    ToolTip = 'Specifies the value of the Show Payload field.';
                }
            }
            group(APIs)
            {
                Caption = 'APIs';

                field("Customer API"; Rec."Customer API")
                {
                    ToolTip = 'Specifies the value of the Customer API field.', Comment = '%';
                }
                field("Payment Method API"; Rec."Payment Method API")
                {
                    ToolTip = 'Specifies the value of the Payment Method API field.', Comment = '%';
                }
                field("Charge Payment Method API"; Rec."Charge Payment Method API")
                {
                    ToolTip = 'Specifies the value of the Charge Payment Method API field.', Comment = '%';
                }
                field("Transaction API"; Rec."Transaction API")
                {
                    ToolTip = 'Specifies the value of the Transaction API field.', Comment = '%';
                }
                field("Payment Link API"; Rec."Payment Link API")
                {
                    ToolTip = 'Specifies the value of the Payment Link API field.', Comment = '%';
                }
                field("Payment Token"; Rec."Payment Token")
                {
                    ToolTip = 'Specifies the value of the Payment Token field.';
                }
            }
        }
    }
}
