page 60005 "DO Payment Trans. Log Entries"
{
    Caption = 'Credit Cards Transaction Log Entries.';
    Editable = false;
    PageType = List;
    SourceTable = "DO Payment Trans. Log Entry";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = all;
                }
                field("Credit Card No."; Rec."Credit Card No.")
                {
                    ApplicationArea = all;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Transaction Description"; Rec."Transaction Description")
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field("Transaction Date-Time"; Rec."Transaction Date-Time")
                {
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Transaction Status"; Rec."Transaction Status")
                {
                    ApplicationArea = all;
                }
                field("Transaction Result"; Rec."Transaction Result")
                {
                    ApplicationArea = all;
                }
                field("Cust. Ledger Entry No."; Rec."Cust. Ledger Entry No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Visible = false;
                    ApplicationArea = all;
                }
                field("User ID"; Rec."User ID")
                {
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Parent Entry No."; Rec."Parent Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Transaction ID"; Rec."Transaction ID")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Update Transaction Status from Payment Services")
                {
                    Caption = 'Update Transaction Status from Payment Services';
                    Image = Refresh;
                    Visible = false;
                    ApplicationArea = all;

                    trigger OnAction()
                    var
                        DOPaymentIntegrationMgt: Codeunit "DO Payment Integration Mgt.";
                    begin
                        // if (not Rec.IsEmpty) and (Rec."Transaction Result" <> Rec."Transaction Result"::Failed) then
                        //     DOPaymentIntegrationMgt.RefreshTransactionStatus(Rec);
                    end;
                }
                action(UpdateTransactionStatus)
                {
                    Caption = 'Update Transaction Status from Payment Services';
                    Image = Refresh;
                    Visible = false;
                    ApplicationArea = all;

                    trigger OnAction()
                    var
                        DOPaymentIntegrationMgt: Codeunit "DO Payment Integration Mgt.";
                    begin
                        if (not Rec.IsEmpty) and (Rec."Transaction Result" <> Rec."Transaction Result"::Failed) then
                            AuthorizeDotNet.CaptureCreditCardJson(Rec."Entry No.");
                    end;
                }
            }
        }
    }

    var
        AuthorizeDotNet: Codeunit "Authorize Dot Net.";
}

