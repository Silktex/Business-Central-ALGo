page 50010 "Multiple Credit Card Payment"
{
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Multiple Payment";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Credit Card No."; Rec."Credit Card No.")
                {
                    ApplicationArea = All;
                }
                field("Amount to Capture"; Rec."Amount to Capture")
                {
                    ApplicationArea = All;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Transaction Status"; Rec."Transaction Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Transaction Result"; Rec."Transaction Result")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Make Payment Nav")
            {
                ApplicationArea = All;
                Image = AuthorizeCreditCard;

                trigger OnAction()
                var
                    IntAuthenticationID: Integer;
                begin
                    recSalesHeader.Reset;
                    recSalesHeader.SetRange("No.", Rec."Order No.");
                    recSalesHeader.SetRange("Document Type", Rec."Document Type");
                    if recSalesHeader.Find('-') then begin
                        if SalesPost.IsOnlinePayment(recSalesHeader) then begin
                            Rec.TestField("Credit Card No.");
                            recSalesHeader.CalcFields(Amount);
                            CapturedAmount := 0;
                            DPTLE.Reset;
                            DPTLE.SetRange("Document Type", Rec."Document Type");
                            DPTLE.SetRange("Document No.", Rec."Order No.");
                            DPTLE.SetRange("Transaction Status", DPTLE."Transaction Status"::Captured);
                            //DPTLE.SetRange("Entry No.", Rec."Entry No.");
                            DPTLE.SetRange("Payment Entry No.", Rec."Entry No.");
                            if DPTLE.Find('-') then
                                Error('Already Captured')
                            else begin
                                DPTLE.Reset;
                                if DPTLE.Find('+') then
                                    EntryNo := DPTLE."Entry No." + 1
                                else
                                    EntryNo := 1;

                                DPTLE.Init;
                                DPTLE.Validate("Entry No.", EntryNo);
                                DPTLE."Document Type" := Rec."Document Type";
                                DPTLE."Document No." := Rec."Order No.";
                                DPTLE."Customer No." := recSalesHeader."Sell-to Customer No.";
                                DPTLE."Credit Card No." := Rec."Credit Card No.";
                                DPTLE."Transaction Description" := Rec."Order No.";
                                DPTLE.Amount := Rec."Amount to Capture";
                                DPTLE."Transaction Date-Time" := CurrentDateTime;
                                DPTLE."Currency Code" := recSalesHeader."Currency Code";
                                DPTLE."Transaction Type" := DPTLE."Transaction Type"::Capture;
                                DPTLE."Transaction Result" := DPTLE."Transaction Result"::Failed;
                                DPTLE."Payment Entry No." := Rec."Entry No.";
                                DPTLE.Insert;
                                IntAuthenticationID := EntryNo;
                            end;
                            CUAuthentication.ChargeCreditCardJson(IntAuthenticationID);
                        end else begin
                            Error('Payment Method Code is not defined for online Payment');
                        end;
                    end;
                end;
            }
            action("Void Payment Nav")
            {
                ApplicationArea = All;
                Image = VoidCreditCard;

                trigger OnAction()
                var
                    IntAuthenticationID: Integer;
                begin
                    Authentication := '';
                    AuthenticationID := '';
                    recSalesHeader.Reset;
                    recSalesHeader.SetRange("No.", Rec."Order No.");
                    recSalesHeader.SetRange("Document Type", Rec."Document Type");
                    if recSalesHeader.Find('-') then begin
                        if SalesPost.IsOnlinePayment(recSalesHeader) then begin
                            Rec.TestField("Credit Card No.");
                            recSalesHeader.CalcFields(Amount);
                            DPTLE.Reset;
                            DPTLE.SetRange("Document Type", Rec."Document Type");
                            DPTLE.SetRange("Document No.", Rec."Order No.");
                            DPTLE.SetRange("Entry No.", Rec."Entry No.");
                            DPTLE.SetRange(DPTLE."Transaction Status", DPTLE."Transaction Status"::Voided);
                            if DPTLE.Find('-') then
                                Error('Already Voided')
                            else begin
                                DPTLE.Reset;
                                DPTLE.SetRange("Document Type", Rec."Document Type");
                                DPTLE.SetRange("Document No.", Rec."Order No.");
                                DPTLE.SetRange(DPTLE."Transaction Status", DPTLE."Transaction Status"::Captured);
                                DPTLE.SetRange("Entry No.", Rec."Entry No.");
                                if DPTLE.Find('-') then begin
                                    AuthenticationID := Format(DPTLE."Refund No.");
                                    IntAuthenticationID := DPTLE."Refund No.";
                                end else
                                    Error('Entry Not Found');
                            end;
                            CUAuthentication.VoidCreditCardJson(IntAuthenticationID);
                        end else begin
                            Error('Payment Method Code is not defined for online Payment')
                        end;
                    end;
                end;
            }
        }
    }

    var
        recSalesLine: Record "Sales Line";
        AuthenticationID: Text[30];
        DPTLE: Record "DO Payment Trans. Log Entry";
        EntryNo: Integer;
        SalesPost: Codeunit SalesPost_Ext;
        decAmount: Decimal;
        DataText: BigText;
        //EncryptionMgt: Codeunit "Encryption Management";
        IntLength: Integer;
        Authentication: Text[1024];
        CapturedAmount: Decimal;
        recSalesHeader: Record "Sales Header";
        webserverIP: Label '192.168.1.228:57474';
        CUAuthentication: Codeunit "Authorize Dot Net.";
}

