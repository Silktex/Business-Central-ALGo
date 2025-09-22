pageextension 50230 "Posted Sales Invoice_Ext" extends "Posted Sales Invoice"
{
    layout
    {

        addafter("External Document No.")
        {
            field("Campaign No."; Rec."Campaign No.")
            {
                ApplicationArea = all;
                Visible = true;
                Importance = Standard;
            }
        }
        modify("Foreign Trade")
        {
            Visible = true;

        }
        addafter("No. Printed")
        {
            field("Commission Override"; Rec."Commission Override")
            {
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    if Rec."Commission Override" then
                        if not Confirm('Do you want to override commision Amount', true) then
                            Error('Commision Override must be no');

                    if Rec."Commission Override" then
                        blnOverride := true
                    else
                        blnOverride := false;
                end;
            }
            field("Commision %"; Rec."Commision %")
            {
                Editable = blnOverride;
                ApplicationArea = all;
            }
        }
        addafter("Payment Terms Code")
        {
            field("Tracking No."; Rec."Tracking No.")
            {
                Visible = false;
                ApplicationArea = all;
            }
        }
        addlast(General)
        {
            field("Specifier Designer Contact No."; Rec."Specifier Designer Contact No.")
            {
                ApplicationArea = All;
            }
            field("Specifier Designer Name"; Rec."Specifier Designer Name")
            {
                ApplicationArea = All;
            }
            field("Specifier Designer Email"; Rec."Specifier Designer Email")
            {
                ApplicationArea = All;
            }
            field("Project Name"; Rec."Project Name")
            {
                ApplicationArea = all;
            }
            field("Project Type"; Rec."Project Type")
            {
                ApplicationArea = All;
                Visible = ShowProjectInfo;
            }
            field("Project Phase"; Rec."Project Phase")
            {
                ApplicationArea = All;
                Visible = ShowProjectInfo;
            }
            field("Project Description"; Rec."Project Description")
            {
                ApplicationArea = All;
                Visible = ShowProjectInfo;
                MultiLine = true;
            }
            field("Project Location"; Rec."Project Location")
            {
                ApplicationArea = all;
            }
            field("Project City"; Rec."Project City")
            {
                ApplicationArea = All;
                Visible = ShowProjectInfo;
            }
            field("Project Size"; Rec."Project Size")
            {
                ApplicationArea = All;
                Visible = ShowProjectInfo;
            }
            field("Project Budget"; Rec."Project Budget")
            {
                ApplicationArea = All;
                Visible = ShowProjectInfo;
            }
            field("Expected Project Completion Month"; Rec.ExpectedProjectCompletionMonth)
            {
                ApplicationArea = All;
                Visible = ShowProjectInfo;
            }
            field("Expected Project Completion Year"; Rec.Expected_ProjectCompletionYear)
            {
                ApplicationArea = All;
                Visible = ShowProjectInfo;
            }
            field("MB Order ID"; Rec."MBOrderID")
            {
                ApplicationArea = All;
                Visible = ShowProjectInfo;
            }
        }
    }
    actions
    {
        addafter(CancelInvoice)
        {
            action("Tracking No")
            {
                ApplicationArea = all;

                trigger OnAction()
                var
                    TrackingNo: Record "Tracking No.";
                begin
                    TrackingNo.Reset;
                    TrackingNo.SetRange(TrackingNo."Source Document No.", Rec."Order No.");
                    if TrackingNo.FindFirst then
                        PAGE.Run(PAGE::"Tracking No", TrackingNo);
                end;
            }
        }
        addafter(ShowCreditMemo)
        {
            Group(AuthorizeDotNet)
            {
                Caption = 'Authorize.Net';

                action(MakePayment)
                {
                    ApplicationArea = all;

                    trigger OnAction()
                    begin
                        if DOPaymentMgt.IsValidPaymentMethod(Rec."Payment Method Code") then begin
                            Rec.TestField("Credit Card No.");
                            Rec.CalcFields(Amount);
                            DPTLE.Reset;
                            //DPTLE.SETRANGE("Document Type",DPTLE."Document Type"::Payment);
                            DPTLE.SetRange("Document No.", Rec."No.");
                            DPTLE.SetRange(DPTLE."Transaction Status", DPTLE."Transaction Status"::Captured);
                            if DPTLE.Find('-') then
                                Error('Already Captured')
                            else begin
                                DPTLE.Reset;
                                //DPTLE.SETRANGE("Document Type",DPTLE."Document Type"::Payment);
                                DPTLE.SetRange("Document No.", Rec."No.");

                                if DPTLE.Find('-') then
                                    AuthenticationID := Format(DPTLE."Entry No.")
                                else begin
                                    DPTLE.Reset;
                                    if DPTLE.Find('+') then
                                        EntryNo := DPTLE."Entry No." + 1
                                    else
                                        EntryNo := 1;
                                    decAmount := 0;
                                    recCLE.Reset;
                                    recCLE.SetRange("Document No.", Rec."No.");
                                    recCLE.SetRange("Document Type", recCLE."Document Type"::Invoice);
                                    recCLE.SetRange("Customer No.", Rec."Bill-to Customer No.");
                                    recCLE.SetRange("Posting Date", Rec."Posting Date");
                                    if recCLE.Find('-') then begin
                                        recCLE.CalcFields(Amount);
                                        decAmount := Abs(recCLE.Amount);
                                    end;
                                    decAmount := Round(decAmount);
                                    DPTLE.Init;
                                    DPTLE.Validate("Entry No.", EntryNo);
                                    DPTLE."Document Type" := DPTLE."Document Type"::Order;
                                    DPTLE."Document No." := Rec."No.";
                                    DPTLE."Customer No." := Rec."Sell-to Customer No.";
                                    DPTLE."Credit Card No." := Rec."Credit Card No.";
                                    DPTLE."Transaction Type" := DPTLE."Transaction Type"::Capture;
                                    DPTLE."Transaction Description" := Rec."No.";
                                    DPTLE.Amount := decAmount;
                                    DPTLE."Transaction Date-Time" := CurrentDateTime;
                                    DPTLE."Currency Code" := Rec."Currency Code";
                                    DPTLE."Transaction Result" := DPTLE."Transaction Result"::Failed;
                                    DPTLE.Insert;
                                    AuthenticationID := Format(DPTLE."Entry No.");
                                end;
                            end;
                            Clear(DataText);
                            DataText.AddText(Encrypt(Format(AuthenticationID))); //Vishal
                            IntLength := DataText.Length;
                            //FOR i:=1 to 8 DO BEGIN
                            DataText.GetSubText(Authentication, 1);
                            //Authentication

                            HyperLink('http://192.168.1.11:57474/PayNow.aspx?PayId=' + Authentication);
                        end else begin
                            Error('Payment Method Code is not defined for online Payment');
                        end;
                    end;
                }
                action(ApplyPayment)
                {
                    ApplicationArea = all;

                    trigger OnAction()
                    begin
                        DPTLE.Reset;
                        DPTLE.SetRange("Document Type", DPTLE."Document Type"::Order);
                        DPTLE.SetRange("Document No.", Rec."No.");
                        DPTLE.SetRange(DPTLE."Transaction Status", DPTLE."Transaction Status"::Captured);
                        if DPTLE.Find('-') then
                            PostBalanceEntry(DPTLE."Entry No.");
                    end;
                }
            }

            group(Stax)
            {
                Caption = 'Stax';

                action(CreatePayLink)
                {
                    ApplicationArea = All;
                    Caption = 'Create Payment Link';
                    Image = SetupPayment;

                    trigger OnAction()
                    var
                        StaxPaymentMgmt: Codeunit "TLI Stax Payment Handler";
                    begin
                        Clear(StaxPaymentMgmt);
                        if StaxPaymentMgmt.PaymentLinkIsEmpty(2, Rec."No.") then begin
                            if StaxPaymentMgmt.GeneratePaymentLink(2, Rec."No.", 0) then
                                Message('Payment link created.');
                        end else
                            error('Payment link already exist.');
                    end;
                }
                action(PaymentLink)
                {
                    ApplicationArea = All;
                    Image = ElectronicPayment;
                    Caption = 'Payment Link';

                    RunObject = page "TLI Stax Payment Links";
                    RunPageLink = "Document Type" = filter(2), "Document No." = field("No.");
                    RunPageMode = View;
                }
            }
        }

    }

    trigger OnOpenPage()
    begin
        SRSetup.Get();
        ShowProjectInfo := SRSetup."Show Project Info";

        IF Rec."Commission Override" THEN
            blnOverride := TRUE
        ELSE
            blnOverride := FALSE;
    end;

    trigger OnAfterGetRecord()
    begin
        IF Rec."Commission Override" THEN
            blnOverride := TRUE
        ELSE
            blnOverride := FALSE;
    end;

    var
        SRSetup: Record "Sales & Receivables Setup";
        ShowProjectInfo: Boolean;
        recCLE: Record "Cust. Ledger Entry";
        recSalesLine: Record "Sales Line";
        AuthenticationID: Text[30];
        DPTLE: Record "DO Payment Trans. Log Entry";
        EntryNo: Integer;
        SalesPost: Codeunit "Sales-Post";
        decAmount: Decimal;
        DataText: BigText;
        //EncryptionMgt: Codeunit "Encryption Management";
        IntLength: Integer;
        Authentication: Text[1024];
        DOPaymentMgt: Codeunit "DO Payment Mgt.";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        blnOverride: Boolean;

    local procedure PostBalanceEntry(TransactionLogEntryNo: Integer)
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        DOPaymentMgt: Codeunit "DO Payment Mgt.";
        CrCardDocumentType: Option Payment,Refund;
    begin
        //WITH SalesHeader2 DO BEGIN
        CustLedgEntry.Reset;
        CustLedgEntry.SetRange("Document No.", Rec."No.");
        CustLedgEntry.SetRange("Document Type", CustLedgEntry."Document Type"::Invoice);
        CustLedgEntry.SetRange("Customer No.", Rec."Bill-to Customer No.");
        CustLedgEntry.SetRange("Posting Date", Rec."Posting Date");
        if CustLedgEntry.Find('-') then begin


            GenJnlLine.Init;
            GenJnlLine."Posting Date" := Rec."Posting Date";
            GenJnlLine."Document Date" := Rec."Document Date";
            GenJnlLine.Description := Rec."Posting Description";
            GenJnlLine."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
            GenJnlLine."Dimension Set ID" := Rec."Dimension Set ID";
            GenJnlLine."Reason Code" := Rec."Reason Code";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
            GenJnlLine."Account No." := Rec."Bill-to Customer No.";
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No." := Rec."No.";
            GenJnlLine."External Document No." := Rec."External Document No.";
            if Rec."Bal. Account Type" = Rec."Bal. Account Type"::"Bank Account" then
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
            GenJnlLine."Bal. Account No." := Rec."Bal. Account No.";
            GenJnlLine."Currency Code" := Rec."Currency Code";
            CustLedgEntry.CalcFields(Amount);
            GenJnlLine.Amount := -CustLedgEntry.Amount;
            ;
            GenJnlLine."Source Currency Code" := Rec."Currency Code";
            GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
            GenJnlLine.Correction := Rec.Correction;

            GenJnlLine."Amount (LCY)" := -Round(CustLedgEntry.Amount / CustLedgEntry."Adjusted Currency Factor");


            if Rec."Currency Code" = '' then
                GenJnlLine."Currency Factor" := 1
            else
                GenJnlLine."Currency Factor" := Rec."Currency Factor";
            GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
            GenJnlLine."Applies-to Doc. No." := Rec."No.";
            GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
            GenJnlLine."Source No." := Rec."Bill-to Customer No.";
            GenJnlLine."Source Code" := Rec."Source Code"
            ;
            //GenJnlLine."Posting No. Series" := "Posting No. Series";
            //GenJnlLine."IC Partner Code" := "Sell-to IC Partner Code";
            GenJnlLine."Salespers./Purch. Code" := Rec."Salesperson Code";
            GenJnlLine."Allow Zero-Amount Posting" := true;
            GenJnlPostLine.RunWithCheck(GenJnlLine);

            if TransactionLogEntryNo <> 0 then begin
                if
                  GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment then
                    CrCardDocumentType := CrCardDocumentType::Payment
                else
                    CrCardDocumentType := CrCardDocumentType::Refund;
                //END;
                DOPaymentMgt.UpdateTransactEntryAfterPost(TransactionLogEntryNo, CustLedgEntry."Entry No.", CrCardDocumentType);
            end;
        end;
    end;
}
