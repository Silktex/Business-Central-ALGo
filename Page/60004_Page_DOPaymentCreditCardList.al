page 60004 "DO Payment Credit Card List"
{
    Caption = 'DO Payment Credit Card List';
    CardPageID = "DO Payment Credit Card";
    Editable = false;
    PageType = List;
    SourceTable = "DO Payment Credit Card";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                ShowCaption = false;
                field("Customer No."; Rec."Customer No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("Card Holder Name"; Rec."Card Holder Name")
                {
                    ApplicationArea = all;
                }
                field("Credit Card Number"; Rec."Credit Card Number")
                {
                    Caption = 'Number (Last 4 Digits)';
                    ApplicationArea = all;
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = all;
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = all;
                }
                field("No. Series"; Rec."No. Series")
                {
                    Visible = false;
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Credit Card")
            {
                Caption = '&Credit Card';
                Image = CreditCard;
                action("Transaction Log E&ntries")
                {
                    Caption = 'Transaction Log E&ntries';
                    Image = Log;
                    RunObject = Page "DO Payment Trans. Log Entries";
                    RunPageLink = "Credit Card No." = FIELD("No.");
                    ShortCutKey = 'Ctrl+F7';
                    ApplicationArea = all;
                }
            }
        }
    }
}

