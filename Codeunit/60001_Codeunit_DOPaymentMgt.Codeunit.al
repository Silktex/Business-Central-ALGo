codeunit 60001 "DO Payment Mgt."
{
    Permissions = TableData "DO Payment Trans. Log Entry" = m;

    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'There is nothing to authorize.';
        Text002: Label '%1 transaction with amount of %2 failed.\%3.';
        Text003: Label '%1 transaction failed.\%2.';
        Text004: Label '%1 on %2 %3 must correspond to %1 of %4 %5 specified for the selected %6.';
        Text005: Label 'There is no Capture transaction that is associated with the document that is specified in the %1 field on %2 %3.', Comment = '%1=caption of "Applies-to Doc. No." field in "Gen. Journal Line" table, %2="Gen. Journal Line" table caption, %3=journal line no.';
        Text006: Label '%2 %1 is already expired.';
        Text007: Label 'Test mode is enabled for the Microsoft Dynamics Online Payment Service. No payment transaction has been performed.';
        Text008: Label 'Credit card %1 has already been performed for this %2, but posting failed. You must complete posting of %2 %3.';
        Text009: Label 'Credit card %1 has already been performed for this %2. %3 on the current %2 must be %4 according to the credit card transaction performed.';
        Text010: Label 'Amount to refund must not be greater than remaining amount of %1 on the %2 transaction.';
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";
        DOPaymentIntegrationMgt: Codeunit "DO Payment Integration Mgt.";
        DOPaymentTransLogMgt: Codeunit "DO Payment Trans. Log Mgt.";
        TestMessageShown: Boolean;
        PaymentSetupLoaded: Boolean;
        Text011: Label 'The Balancing Account No. "%1" cannot be used in Microsoft Dynamics Online Payment.';


    // procedure AuthorizeGenJnlLine(GenJnlLine: Record "Gen. Journal Line"): Integer
    // var
    //     DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
    //     PaymentInfo: DotNet IBasicPaymentInfo;
    //     AmountToAuthorize: Decimal;
    //     DOPaymentTransLogEntryNo: Integer;
    // begin
    //     GenJnlLine.TESTFIELD("Credit Card No.");
    //     IF NOT IsValidBalancingAccountNo(GenJnlLine) THEN
    //         ERROR(Text011, GenJnlLine."Bal. Account No.");

    //     AmountToAuthorize :=
    //       ABS(GenJnlLine.Amount) +
    //       CalcAmountToAuthorize(
    //         ABS(GenJnlLine.Amount),
    //         GenJnlLine."Currency Code",
    //         GenJnlLine."Currency Factor",
    //         GenJnlLine."Posting Date");

    //     InitTransaction;
    //     GetBasicPaymentInfoForGenJnlLn(GenJnlLine, AmountToAuthorize, PaymentInfo);

    //     DOPaymentTransLogEntryNo :=
    //       DOPaymentIntegrationMgt.AuthorizePayment(
    //         DOPaymentTransLogEntry,
    //         GenJnlLine."Credit Card No.",
    //         PaymentInfo,
    //         DOPaymentTransLogEntry."Document Type"::Payment,
    //         GenJnlLine."Document No.");

    //     IF DOPaymentTransLogEntry.GET(DOPaymentTransLogEntryNo) THEN
    //         FinishTransaction(DOPaymentTransLogEntry);
    //     EXIT(DOPaymentTransLogEntryNo);
    // end;


    procedure AuthorizeSalesDoc(SalesHeader: Record "Sales Header"; CustLedgerEntryNo: Integer; AuthorizationRequired: Boolean): Integer
    var
        DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        // PaymentInfo: DotNet IBasicPaymentInfo;
        DOPaymentTransLogEntryNo: Integer;
        AmountToCapture: Decimal;
    begin
        IF NOT IsValidPaymentMethod(SalesHeader."Payment Method Code") THEN
            EXIT;

        CheckSalesDoc(SalesHeader);

        IF DOPaymentTransLogMgt.FindPostingNotFinishedEntry(
             SalesHeader."Document Type".AsInteger(),
             SalesHeader."No.",
             DOPaymentTransLogEntry)
        THEN
            ERROR(Text008, DOPaymentTransLogEntry."Transaction Type", SalesHeader."Document Type", SalesHeader."No.");

        CheckAssociatedDoc(SalesHeader);

        IF AuthorizationRequired THEN
            AmountToCapture := CalcSalesDocAmount(SalesHeader, AuthorizationRequired)
        ELSE BEGIN
            CustLedgEntry.GET(CustLedgerEntryNo);
            CustLedgEntry.CALCFIELDS(Amount);
            AmountToCapture := CustLedgEntry.Amount;
        END;

        IF AmountToCapture = 0 THEN
            ERROR(Text001);

        AmountToCapture :=
          AmountToCapture +
          CalcAmountToAuthorize(
            AmountToCapture,
            SalesHeader."Currency Code",
            SalesHeader."Currency Factor",
            SalesHeader."Posting Date");

        InitTransaction;
        IF DOPaymentTransLogMgt.FindValidAuthorizationEntry(
             SalesHeader."Document Type".AsInteger(),
             SalesHeader."No.",
             DOPaymentTransLogEntry)
        THEN BEGIN
            IF AmountToCapture > DOPaymentTransLogEntry.Amount THEN BEGIN
                //   VoidSalesDoc(SalesHeader, DOPaymentTransLogEntry);
                DOPaymentTransLogEntryNo := AuthorizeSalesDoc(SalesHeader, CustLedgerEntryNo, AuthorizationRequired);
            END ELSE
                DOPaymentTransLogEntryNo := DOPaymentTransLogEntry."Entry No.";
            EXIT(DOPaymentTransLogEntryNo);
        END;

        // DOPaymentIntegrationMgt.CreateBasicPaymentInfo(
        //   PaymentInfo,
        //   SalesHeader."Bill-to Customer No.",
        //   FORMAT(SalesHeader."Document Type"),
        //   SalesHeader."No.",
        //   FindCurrencyCode(SalesHeader."Currency Code"),
        //   AmountToCapture);

        // DOPaymentTransLogEntryNo := DOPaymentIntegrationMgt.AuthorizePayment(
        //     DOPaymentTransLogEntry,
        //     SalesHeader."Credit Card No.",
        //     PaymentInfo,
        //     SalesHeader."Document Type",
        //     SalesHeader."No.");

        IF DOPaymentTransLogEntry.GET(DOPaymentTransLogEntryNo) THEN
            FinishTransaction(DOPaymentTransLogEntry);
        EXIT(DOPaymentTransLogEntryNo);
    end;


    procedure CheckGenJnlLine(GenJournalLine: Record "Gen. Journal Line")
    begin
        //WITH GenJournalLine DO BEGIN
        GenJournalLine.TESTFIELD(Amount);
        GenJournalLine.TESTFIELD("Applies-to Doc. Type");
        GenJournalLine.TESTFIELD("Applies-to Doc. No.");
        IF ((GenJournalLine."Document Type" <> GenJournalLine."Document Type"::Payment) AND (GenJournalLine."Document Type" <> GenJournalLine."Document Type"::Refund)) OR
           (GenJournalLine."Document Type" = GenJournalLine."Applies-to Doc. Type")
        THEN
            GenJournalLine.FIELDERROR("Document Type");

        GenJournalLine.TESTFIELD("Account Type", GenJournalLine."Account Type"::Customer);
        // TESTFIELD("Credit Card No.");
        // CheckCreditCardData("Credit Card No.");
        //END;
    end;


    // procedure CaptureGenJnlLine(GenJnlLine: Record "Gen. Journal Line"): Integer
    // var
    //     DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
    //     PaymentInfo: DotNet IBasicPaymentInfo;
    //     AmountToCapture: Decimal;
    //     CaptureTransLogEntryNo: Integer;
    //     DOPaymentTransLogEntryNo: Integer;
    // begin
    //     GenJnlLine.TESTFIELD("Credit Card No.");
    //     IF NOT IsValidBalancingAccountNo(GenJnlLine) THEN
    //         ERROR(Text011, GenJnlLine."Bal. Account No.");

    //     AmountToCapture := ABS(GenJnlLine.Amount);
    //     IF DOPaymentTransLogMgt.FindCapturedButNotFinishedEntr(
    //          GenJnlLine."Account No.",
    //          GenJnlLine."Applies-to Doc. No.",
    //          AmountToCapture,
    //          GenJnlLine."Currency Code",
    //          GenJnlLine."Credit Card No.",
    //          DOPaymentTransLogEntry)
    //     THEN
    //         IF VerifDocAgainstAlreadPostdTran(
    //              GenJnlLine."Document Type",
    //              GenJnlLine."Currency Code",
    //              AmountToCapture,
    //              GenJnlLine."Credit Card No.",
    //              DOPaymentTransLogEntry)
    //         THEN
    //             EXIT(DOPaymentTransLogEntry."Entry No.");

    //     DOPaymentTransLogEntryNo := AuthorizeGenJnlLine(GenJnlLine);
    //     CLEAR(DOPaymentTransLogEntry);
    //     DOPaymentTransLogEntry.GET(DOPaymentTransLogEntryNo);

    //     InitTransaction;
    //     GetBasicPaymentInfoForGenJnlLn(GenJnlLine, AmountToCapture, PaymentInfo);
    //     CaptureTransLogEntryNo :=
    //       DOPaymentIntegrationMgt.CapturePayment(
    //         DOPaymentTransLogEntry,
    //         GenJnlLine."Credit Card No.",
    //         PaymentInfo,
    //         DOPaymentTransLogEntry."Document Type"::Payment,
    //         GenJnlLine."Document No.");
    //     FinalizeTransLogAfterCapt(CaptureTransLogEntryNo, DOPaymentTransLogEntryNo, DOPaymentTransLogEntry, 0);

    //     FinishTransaction(DOPaymentTransLogEntry);
    //     EXIT(CaptureTransLogEntryNo);
    // end;


    // procedure CaptureSalesDoc(SalesHeader: Record "Sales Header"; CustLedgerEntryNo: Integer): Integer
    // var
    //     DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
    //     PaymentInfo: DotNet IBasicPaymentInfo;
    //     DocNo: Code[20];
    //     AmountToCapture: Decimal;
    //     DOPaymentTransLogEntryNo: Integer;
    //     CaptureTransLogEntryNo: Integer;
    // begin
    //     IF NOT IsValidPaymentMethod(SalesHeader."Payment Method Code") THEN
    //         EXIT;

    //     CheckSalesDoc(SalesHeader);

    //     AmountToCapture := CalcPostedSalesDocAmount(CustLedgerEntryNo);

    //     IF DOPaymentTransLogMgt.FindPostingNotFinishedEntry(
    //          SalesHeader."Document Type", SalesHeader."No.", DOPaymentTransLogEntry)
    //     THEN
    //         IF VerifDocAgainstAlreadPostdTran(
    //              SalesHeader."Document Type",
    //              SalesHeader."Currency Code",
    //              AmountToCapture,
    //              SalesHeader."Credit Card No.",
    //              DOPaymentTransLogEntry)
    //         THEN
    //             EXIT(DOPaymentTransLogEntry."Entry No.");

    //     IF DOPaymentTransLogMgt.FindValidAuthorizationEntry(SalesHeader."Document Type", SalesHeader."No.", DOPaymentTransLogEntry) THEN BEGIN
    //         DOPaymentTransLogEntryNo := DOPaymentTransLogEntry."Entry No.";
    //     END ELSE BEGIN
    //         DOPaymentTransLogEntryNo := AuthorizeSalesDoc(SalesHeader, CustLedgerEntryNo, FALSE);
    //         DOPaymentTransLogEntry.GET(DOPaymentTransLogEntryNo);
    //     END;

    //     DocNo := SalesHeader."Posting No.";
    //     IF DocNo = '' THEN
    //         DocNo := SalesHeader."Last Posting No.";

    //     InitTransaction;
    //     GetBasicPaymentInfoForSalesDoc(SalesHeader, AmountToCapture, PaymentInfo);
    //     CaptureTransLogEntryNo :=
    //       DOPaymentIntegrationMgt.CapturePayment(
    //         DOPaymentTransLogEntry,
    //         SalesHeader."Credit Card No.",
    //         PaymentInfo,
    //         DOPaymentTransLogEntry."Document Type"::Invoice,
    //         DocNo);

    //     FinalizeTransLogAfterCapt(CaptureTransLogEntryNo, DOPaymentTransLogEntryNo, DOPaymentTransLogEntry, CustLedgerEntryNo);

    //     FinishTransaction(DOPaymentTransLogEntry);

    //     EXIT(CaptureTransLogEntryNo);
    // end;


    // procedure RefundGenJnlLine(GenJnlLine: Record "Gen. Journal Line"): Integer
    // var
    //     RefundDOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
    //     CaptureDOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
    //     CustLedgEntry: Record "Cust. Ledger Entry";
    //     PaymentInfo: DotNet IBasicPaymentInfo;
    //     AmountToRefund: Decimal;
    //     RemainingCapturedAmount: Decimal;
    //     RefundTransLogEntryNo: Integer;
    // begin
    //     GenJnlLine.TESTFIELD("Credit Card No.");
    //     IF NOT IsValidBalancingAccountNo(GenJnlLine) THEN
    //         ERROR(Text011, GenJnlLine."Bal. Account No.");

    //     GenJnlLine.TESTFIELD(Amount);
    //     AmountToRefund := ABS(GenJnlLine.Amount);

    //     IF DOPaymentTransLogMgt.FindPostingNotFinishedEntry(
    //          RefundDOPaymentTransLogEntry."Document Type"::Refund,
    //          GenJnlLine."Document No.",
    //          RefundDOPaymentTransLogEntry)
    //     THEN
    //         IF VerifDocAgainstAlreadPostdTran(
    //              GenJnlLine."Document Type",
    //              GenJnlLine."Currency Code",
    //              AmountToRefund,
    //              GenJnlLine."Credit Card No.",
    //              RefundDOPaymentTransLogEntry)
    //         THEN
    //             EXIT(RefundDOPaymentTransLogEntry."Entry No.");

    //     CustLedgEntry.RESET;
    //     CustLedgEntry.SETCURRENTKEY("Document No.");
    //     CustLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
    //     CustLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
    //     CustLedgEntry.SETRANGE("Customer No.", GenJnlLine."Account No.");
    //     CustLedgEntry.SETRANGE(Open, TRUE);
    //     IF NOT CustLedgEntry.FINDFIRST THEN
    //         EXIT;

    //     CaptureDOPaymentTransLogEntry.SETCURRENTKEY("Cust. Ledger Entry No.");
    //     CaptureDOPaymentTransLogEntry.SETRANGE("Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
    //     CaptureDOPaymentTransLogEntry.SETRANGE("Transaction Type", CaptureDOPaymentTransLogEntry."Transaction Type"::Capture);
    //     CaptureDOPaymentTransLogEntry.SETRANGE("Transaction Result", CaptureDOPaymentTransLogEntry."Transaction Result"::Success);
    //     CaptureDOPaymentTransLogEntry.SETFILTER(
    //       "Transaction Status",
    //       '%1|%2',
    //       CaptureDOPaymentTransLogEntry."Transaction Status"::" ",
    //       CaptureDOPaymentTransLogEntry."Transaction Status"::Refunded);

    //     IF GenJnlLine."Applies-to Doc. Type" <> GenJnlLine."Applies-to Doc. Type"::"Credit Memo" THEN BEGIN
    //         IF NOT CaptureDOPaymentTransLogEntry.FINDFIRST THEN
    //             ERROR(Text005, GenJnlLine.FIELDCAPTION("Applies-to Doc. No."), GenJnlLine.TABLECAPTION, GenJnlLine."Line No.");

    //         IF FindCurrencyCode(GenJnlLine."Currency Code") <> CaptureDOPaymentTransLogEntry."Currency Code" THEN
    //             GenJnlLine.TESTFIELD("Currency Code", RefundDOPaymentTransLogEntry."Currency Code");

    //         RemainingCapturedAmount := CalcRemainingCapturedAmount(CaptureDOPaymentTransLogEntry);
    //         IF AmountToRefund > RemainingCapturedAmount THEN
    //             ERROR(Text010, RemainingCapturedAmount, CaptureDOPaymentTransLogEntry."Transaction Type");
    //     END;

    //     InitTransaction;
    //     CLEAR(RefundDOPaymentTransLogEntry);
    //     RefundDOPaymentTransLogEntry := CaptureDOPaymentTransLogEntry;

    //     GetBasicPaymentInfoForGenJnlLn(GenJnlLine, AmountToRefund, PaymentInfo);
    //     RefundTransLogEntryNo :=
    //       DOPaymentIntegrationMgt.RefundPayment(
    //         RefundDOPaymentTransLogEntry,
    //         GenJnlLine."Credit Card No.",
    //         PaymentInfo,
    //         RefundDOPaymentTransLogEntry."Document Type"::Refund,
    //         GenJnlLine."Document No.");

    //     IF GenJnlLine."Applies-to Doc. Type" = GenJnlLine."Applies-to Doc. Type"::"Credit Memo" THEN
    //         FinalizeTransLogAfterRefu(RefundTransLogEntryNo, -1, RefundDOPaymentTransLogEntry)
    //     ELSE
    //         FinalizeTransLogAfterRefu(RefundTransLogEntryNo, CaptureDOPaymentTransLogEntry."Entry No.", RefundDOPaymentTransLogEntry);

    //     FinishTransaction(RefundDOPaymentTransLogEntry);
    //     EXIT(RefundTransLogEntryNo);
    // end;


    // procedure RefundSalesDoc(SalesHeader: Record "Sales Header"; CustLedgerEntryNo: Integer): Integer
    // var
    //     RefundDOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
    //     PaymentInfo: DotNet IBasicPaymentInfo;
    //     AmountToRefund: Decimal;
    //     RefundTransLogEntryNo: Integer;
    // begin
    //     IF NOT IsValidPaymentMethod(SalesHeader."Payment Method Code") THEN
    //         EXIT;

    //     CheckSalesDoc(SalesHeader);

    //     AmountToRefund := -CalcPostedSalesDocAmount(CustLedgerEntryNo);

    //     IF DOPaymentTransLogMgt.FindPostingNotFinishedEntry(
    //          RefundDOPaymentTransLogEntry."Document Type"::Refund,
    //          SalesHeader."No.",
    //          RefundDOPaymentTransLogEntry)
    //     THEN
    //         IF VerifDocAgainstAlreadPostdTran(
    //              SalesHeader."Document Type",
    //              SalesHeader."Currency Code",
    //              AmountToRefund,
    //              SalesHeader."Credit Card No.",
    //              RefundDOPaymentTransLogEntry)
    //         THEN
    //             EXIT(RefundDOPaymentTransLogEntry."Entry No.");

    //     InitTransaction;
    //     GetBasicPaymentInfoForSalesDoc(SalesHeader, AmountToRefund, PaymentInfo);
    //     RefundTransLogEntryNo :=
    //       DOPaymentIntegrationMgt.RefundPayment(
    //         RefundDOPaymentTransLogEntry,
    //         SalesHeader."Credit Card No.",
    //         PaymentInfo,
    //         RefundDOPaymentTransLogEntry."Document Type"::Refund,
    //         SalesHeader."No.");

    //     RefundDOPaymentTransLogEntry.GET(RefundTransLogEntryNo);
    //     RefundDOPaymentTransLogEntry."Transaction Status" := RefundDOPaymentTransLogEntry."Transaction Status"::"Posting Not Finished";
    //     RefundDOPaymentTransLogEntry.MODIFY;

    //     FinishTransaction(RefundDOPaymentTransLogEntry);

    //     EXIT(RefundTransLogEntryNo);
    // end;


    procedure CheckSalesDoc(SalesHeader: Record "Sales Header")
    var
        PaymentMethod: Record "Payment Method";
        BankAccount: Record "Bank Account";
    begin
        SalesHeader.TESTFIELD("Payment Method Code");
        PaymentMethod.GET(SalesHeader."Payment Method Code");
        PaymentMethod.TESTFIELD("Payment Processor", PaymentMethod."Payment Processor"::"Dynamics Online"); //VR
        PaymentMethod.TESTFIELD("Bal. Account Type", PaymentMethod."Bal. Account Type"::"Bank Account");
        PaymentMethod.TESTFIELD("Bal. Account No.");
        BankAccount.GET(PaymentMethod."Bal. Account No.");
        IF BankAccount."Currency Code" <> SalesHeader."Currency Code" THEN
            ERROR(
              Text004,
              SalesHeader.FIELDCAPTION("Currency Code"),
              SalesHeader."Document Type",
              SalesHeader."No.",
              BankAccount.TABLECAPTION,
              BankAccount."No.",
              PaymentMethod.TABLECAPTION);
        IF NOT SalesHeader."Multiple Payment" THEN
            SalesHeader.TESTFIELD("Credit Card No.");
        //Commennted by Saurabh
        //CheckCreditCardData(SalesHeader."Credit Card No.");
    end;


    // procedure VoidSalesDoc(var SalesHeader: Record "Sales Header"; var DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry")
    // var
    //     VoidDOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
    //     PaymentInfo: DotNet IBasicPaymentInfo;
    //     TransEntryNo: Integer;
    // begin
    //     InitTransaction;

    //     DOPaymentIntegrationMgt.CreateBasicPaymentInfo(
    //       PaymentInfo,
    //       DOPaymentTransLogEntry."Customer No.",
    //       FORMAT(DOPaymentTransLogEntry."Document Type"),
    //       DOPaymentTransLogEntry."Customer No.",
    //       DOPaymentTransLogEntry."Currency Code",
    //       DOPaymentTransLogEntry.Amount);

    //     TransEntryNo := DOPaymentIntegrationMgt.VoidPayment(
    //         DOPaymentTransLogEntry,
    //         DOPaymentTransLogEntry."Credit Card No.",
    //         PaymentInfo,
    //         SalesHeader."Document Type",
    //         SalesHeader."No.");

    //     IF VoidDOPaymentTransLogEntry.GET(TransEntryNo) THEN
    //         IF VoidDOPaymentTransLogEntry."Transaction Result" = VoidDOPaymentTransLogEntry."Transaction Result"::Success THEN BEGIN
    //             DOPaymentTransLogEntry."Transaction Status" := DOPaymentTransLogEntry."Transaction Status"::Voided;
    //             DOPaymentTransLogEntry.MODIFY;
    //         END ELSE BEGIN
    //             DOPaymentTransLogEntry."Transaction Status" := VoidDOPaymentTransLogEntry."Transaction Status"::" ";
    //             DOPaymentTransLogEntry.MODIFY;
    //         END;

    //     FinishTransaction(VoidDOPaymentTransLogEntry);
    // end;


    procedure UpdateTransactEntryAfterPost(DOPaymentTransLogEntryNo: Integer; RelatedCustLedgerEntryNo: Integer; DocumentType: Option Payment,Refund)
    var
        DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        DOPaymentTransLogEntry.GET(DOPaymentTransLogEntryNo);
        CustLedgEntry.GET(RelatedCustLedgerEntryNo);
        FindCustLedgEntryNoForPayment(CustLedgEntry, DocumentType);
        DOPaymentTransLogEntry."Cust. Ledger Entry No." := CustLedgEntry."Entry No.";
        CASE CustLedgEntry."Document Type" OF
            CustLedgEntry."Document Type"::Payment:
                DOPaymentTransLogEntry."Document Type" := DOPaymentTransLogEntry."Document Type"::Payment;
            CustLedgEntry."Document Type"::Refund:
                DOPaymentTransLogEntry."Document Type" := DOPaymentTransLogEntry."Document Type"::Refund;
        END;
        DOPaymentTransLogEntry."Document No." := CustLedgEntry."Document No.";
        //DOPaymentTransLogEntry."Transaction Status" := DOPaymentTransLogEntry."Transaction Status"::" ";
        DOPaymentTransLogEntry.MODIFY;
    end;


    procedure IsAuthorizationRequired(): Boolean
    var
        DOPaymentSetup: Record "DO Payment Setup";
    begin
        IF DOPaymentSetup.GET THEN
            EXIT(DOPaymentSetup."Authorization Required");
    end;


    procedure IsValidPaymentMethod(PaymentMethodCode: Code[10]): Boolean
    var
        PaymentMethod: Record "Payment Method";
    begin
        //VR
        IF PaymentMethod.GET(PaymentMethodCode) THEN
            EXIT(PaymentMethod."Payment Processor" = PaymentMethod."Payment Processor"::"Dynamics Online");
    end;

    local procedure IsValidBalancingAccountNo(GenJournalLine: Record "Gen. Journal Line"): Boolean
    var
        PaymentMethod: Record "Payment Method";
    begin
        IF GenJournalLine."Bal. Account Type" <> GenJournalLine."Bal. Account Type"::"Bank Account" THEN
            EXIT(FALSE);
        //VR
        //WITH PaymentMethod DO BEGIN
        PaymentMethod.SETRANGE("Payment Processor", PaymentMethod."Payment Processor"::"Dynamics Online");
        PaymentMethod.SETRANGE("Bal. Account Type", PaymentMethod."Bal. Account Type"::"Bank Account");
        PaymentMethod.SETRANGE("Bal. Account No.", GenJournalLine."Bal. Account No.");
        IF PaymentMethod.FINDFIRST THEN
            EXIT(TRUE);
        // END;

        EXIT(FALSE);
    end;


    procedure CheckCreditCardData(CreditCardNo: Code[20])
    var
        DOPaymentCreditCard: Record "DO Payment Credit Card";
        IntValue1: Integer;
        IntValue2: Integer;
    begin
        DOPaymentCreditCard.GET(CreditCardNo);
        DOPaymentCreditCard.TESTFIELD("Card Holder Name");
        DOPaymentCreditCard.TESTFIELD("Expiry Date");

        EVALUATE(IntValue1, FORMAT(TODAY, 0, '<Year>'));
        EVALUATE(IntValue2, COPYSTR(DOPaymentCreditCard."Expiry Date", 3, 2));

        IF IntValue1 > IntValue2 THEN
            ERROR(Text006, CreditCardNo, DOPaymentCreditCard.FIELDCAPTION("No."));

        IF IntValue1 = IntValue2 THEN BEGIN
            EVALUATE(IntValue1, FORMAT(TODAY, 0, '<Month>'));
            EVALUATE(IntValue2, COPYSTR(DOPaymentCreditCard."Expiry Date", 1, 2));
            IF IntValue1 > IntValue2 THEN
                ERROR(Text006, CreditCardNo, DOPaymentCreditCard.FIELDCAPTION("No."));
        END;
    end;

    local procedure CalcAmountToAuthorize(AmountBase: Decimal; CurrencyCode: Code[10]; CurrencyFactor: Decimal; PostingDate: Date): Decimal
    var
        DOPaymentSetup: Record "DO Payment Setup";
        ChargeAmount: Decimal;
        MaxChargeAmount: Decimal;
    begin
        IF AmountBase <> 0 THEN BEGIN
            DOPaymentSetup.GET;
            IF DOPaymentSetup."Charge Value" <> 0 THEN BEGIN
                IF CurrencyCode = '' THEN BEGIN
                    Currency.InitRoundingPrecision;
                    MaxChargeAmount := DOPaymentSetup."Max. Charge Amount (LCY)";
                END ELSE BEGIN
                    Currency.GET(CurrencyCode);
                    Currency.TESTFIELD("Amount Rounding Precision");
                    MaxChargeAmount := AmountToFCY(DOPaymentSetup."Max. Charge Amount (LCY)", PostingDate, CurrencyFactor)
                END;

                CASE DOPaymentSetup."Charge Type" OF
                    DOPaymentSetup."Charge Type"::Percent:
                        BEGIN
                            ChargeAmount := ROUND(AmountBase * DOPaymentSetup."Charge Value" / 100, Currency."Amount Rounding Precision");
                            IF (MaxChargeAmount > 0) AND (ChargeAmount > MaxChargeAmount) THEN
                                ChargeAmount := MaxChargeAmount;
                        END;
                    DOPaymentSetup."Charge Type"::Fixed:
                        BEGIN
                            ChargeAmount := ROUND(DOPaymentSetup."Charge Value", Currency."Amount Rounding Precision");
                            IF CurrencyCode <> '' THEN
                                ChargeAmount := AmountToFCY(ChargeAmount, PostingDate, CurrencyFactor);
                        END;
                END;
            END;
            EXIT(ChargeAmount);
        END;
    end;


    procedure CalcSalesDocAmountForPostedDoc(SalesHeader: Record "Sales Header"): Decimal
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        Amt: Decimal;
    begin
        CASE SalesHeader."Document Type" OF
            SalesHeader."Document Type"::Order:
                BEGIN
                    SalesInvoiceHeader.SETCURRENTKEY("Order No.");
                    SalesInvoiceHeader.SETRANGE("Order No.", SalesHeader."No.");
                END;
            SalesHeader."Document Type"::Invoice:
                SalesInvoiceHeader.SETRANGE("Pre-Assigned No.", SalesHeader."No.");
            ELSE
                EXIT(0);
        END;

        IF SalesInvoiceHeader.FINDSET THEN
            REPEAT
                SalesInvoiceHeader.CALCFIELDS("Amount Including VAT");
                Amt := Amt + SalesInvoiceHeader."Amount Including VAT";
            UNTIL SalesInvoiceHeader.NEXT = 0;

        EXIT(Amt);
    end;

    local procedure CalcSalesDocAmount(SalesHeader: Record "Sales Header"; AuthorizationRequired: Boolean): Decimal
    var
        TempSalesLine: Record "Sales Line" temporary;
        TempTotalSalesLine: Record "Sales Line" temporary;
        TempTotalSalesLineLCY: Record "Sales Line" temporary;
        SalesPost: Codeunit "Sales-Post";
        TempAmount: array[5] of Decimal;
        TotalAmt: Decimal;
        VAtText: Text[30];
        QtyType: Option General,Invoicing,Shipping;
    begin
        IF SalesHeader."Currency Code" = '' THEN
            Currency.InitRoundingPrecision
        ELSE BEGIN
            Currency.GET(SalesHeader."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
        END;

        SalesPost.GetSalesLines(SalesHeader, TempSalesLine, QtyType::General);
        CLEAR(SalesPost);
        SalesPost.SumSalesLinesTemp(
          SalesHeader, TempSalesLine, 0, TempTotalSalesLine, TempTotalSalesLineLCY,
          TempAmount[1], VAtText, TempAmount[2], TempAmount[3], TempAmount[4]);

        TotalAmt := TempTotalSalesLine."Amount Including VAT";
        IF AuthorizationRequired THEN
            TotalAmt := TempTotalSalesLine."Amount Including VAT" - CalcSalesDocAmountForPostedDoc(SalesHeader);

        EXIT(TotalAmt);
    end;


    procedure CalcPreviouseAuthorizedAmounts(SalesHeader: Record "Sales Header"): Decimal
    var
        DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
        DOPaymentTransLogMgt: Codeunit "DO Payment Trans. Log Mgt.";
    begin
        IF NOT DOPaymentTransLogMgt.FindValidAuthorizationEntry(
             SalesHeader."Document Type",
             SalesHeader."No.",
             DOPaymentTransLogEntry)
        THEN
            EXIT(0);

        EXIT(CalcRemainingCapturedAmount(DOPaymentTransLogEntry));
    end;

    local procedure CalcPostedSalesDocAmount(CustLedgerEntryNo: Integer): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.GET(CustLedgerEntryNo);
        CustLedgerEntry.CALCFIELDS(Amount);
        EXIT(CustLedgerEntry.Amount - CustLedgerEntry."Remaining Pmt. Disc. Possible");
    end;

    local procedure CalcRemainingCapturedAmount(var CaptureDOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"): Decimal
    var
        DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
    begin
        //WITH DOPaymentTransLogEntry DO BEGIN
        DOPaymentTransLogEntry.SETCURRENTKEY("Parent Entry No.");
        DOPaymentTransLogEntry.SETRANGE("Parent Entry No.", CaptureDOPaymentTransLogEntry."Entry No.");
        DOPaymentTransLogEntry.SETRANGE("Transaction Type", DOPaymentTransLogEntry."Transaction Type"::Refund);
        DOPaymentTransLogEntry.SETRANGE("Transaction Result", DOPaymentTransLogEntry."Transaction Result"::Success);
        DOPaymentTransLogEntry.CALCSUMS(Amount);
        EXIT(CaptureDOPaymentTransLogEntry.Amount - DOPaymentTransLogEntry.Amount);
        //END;
    end;

    local procedure AmountToFCY(AmountLCY: Decimal; PostingDate: Date; CurrencyFactor: Decimal): Decimal
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        Currency.TESTFIELD("Amount Rounding Precision");
        EXIT(
          ROUND(
            CurrExchRate.ExchangeAmtLCYToFCY(PostingDate, Currency.Code, AmountLCY, CurrencyFactor),
            Currency."Amount Rounding Precision"));
    end;

    local procedure CheckAssociatedDoc(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        SalesLine2: Record "Sales Line";
        SalesShptLine: Record "Sales Shipment Line";
        SalesHeader2: Record "Sales Header";
        DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
    begin
        IF NOT IsValidPaymentMethod(SalesHeader."Payment Method Code") THEN
            EXIT;

        CASE SalesHeader."Document Type" OF
            SalesHeader."Document Type"::Invoice:
                BEGIN
                    SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                    SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                    SalesLine.SETFILTER("Shipment No.", '<>%1', '');
                    SalesLine.SETFILTER(Type, '<>%1', SalesLine.Type::" ");
                    IF SalesLine.FINDSET THEN
                        REPEAT
                            SalesShptLine.GET(SalesLine."Shipment No.", SalesLine."Shipment Line No.");
                            IF SalesHeader2.GET(SalesHeader2."Document Type"::Order, SalesShptLine."Order No.") THEN BEGIN
                                IF DOPaymentTransLogMgt.FindPostingNotFinishedEntry(
                                     SalesHeader."Document Type", SalesHeader."No.",
                                     DOPaymentTransLogEntry)
                                THEN
                                    ERROR(
                                      Text008,
                                      DOPaymentTransLogEntry."Transaction Type",
                                      SalesHeader."Document Type",
                                      SalesHeader."No.");

                                // IF DOPaymentTransLogMgt.FindValidAuthorizationEntry(
                                //      SalesHeader."Document Type",
                                //      SalesHeader2."No.",
                                //      DOPaymentTransLogEntry)
                                // THEN
                                //     VoidSalesDoc(SalesHeader2, DOPaymentTransLogEntry);
                            END;
                        UNTIL SalesLine.NEXT = 0;
                END;
            SalesHeader."Document Type"::Order:
                BEGIN
                    SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                    SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                    SalesLine.SETFILTER(Type, '<>%1', SalesLine.Type::" ");
                    IF SalesLine.FINDSET THEN
                        REPEAT
                            SalesShptLine.SETRANGE("Order No.", SalesHeader."No.");
                            SalesShptLine.SETRANGE("Order Line No.", SalesLine."Line No.");
                            IF SalesShptLine.FINDSET THEN
                                REPEAT
                                    SalesLine2.SETRANGE("Document Type", SalesLine2."Document Type"::Invoice);
                                    SalesLine2.SETRANGE("Shipment No.", SalesShptLine."Document No.");
                                    IF SalesLine2.FINDFIRST THEN
                                        IF SalesHeader2.GET(SalesHeader2."Document Type"::Invoice, SalesLine2."Document No.") THEN BEGIN
                                            IF DOPaymentTransLogMgt.FindPostingNotFinishedEntry(
                                                 SalesHeader."Document Type",
                                                 SalesHeader."No.",
                                                 DOPaymentTransLogEntry)
                                            THEN
                                                ERROR(
                                                  Text008,
                                                  DOPaymentTransLogEntry."Transaction Type",
                                                  SalesHeader."Document Type",
                                                  SalesHeader."No.");

                                            // IF DOPaymentTransLogMgt.FindValidAuthorizationEntry(
                                            //      SalesHeader2."Document Type",
                                            //      SalesHeader2."No.",
                                            //      DOPaymentTransLogEntry)
                                            // THEN
                                            //     VoidSalesDoc(SalesHeader2, DOPaymentTransLogEntry);
                                        END;
                                UNTIL SalesShptLine.NEXT = 0;
                        UNTIL SalesLine.NEXT = 0;
                END;
        END;
    end;

    local procedure VerifDocAgainstAlreadPostdTran(DocumentType: Integer; DocumentCurrencyCode: Code[10]; AmountToVerify: Decimal; CreditCardNo: Code[20]; var DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"): Boolean
    begin
        IF DOPaymentTransLogEntry."Currency Code" <> FindCurrencyCode(DocumentCurrencyCode) THEN
            ERROR(
              Text009,
              DOPaymentTransLogEntry."Transaction Type",
              DocumentType,
              DOPaymentTransLogEntry.FIELDCAPTION("Currency Code"),
              DOPaymentTransLogEntry."Currency Code");

        /*IF DOPaymentTransLogEntry.Amount <> AmountToVerify THEN
          ERROR(
            Text009,
            DOPaymentTransLogEntry."Transaction Type",
            DocumentType,
            DOPaymentTransLogEntry.FIELDCAPTION(Amount),
            DOPaymentTransLogEntry.Amount); */

        /*IF DOPaymentTransLogEntry."Credit Card No." <> CreditCardNo THEN
          ERROR(
            Text009,
            DOPaymentTransLogEntry."Transaction Type",
            DocumentType,
            DOPaymentTransLogEntry.FIELDCAPTION("Credit Card No."),
            DOPaymentTransLogEntry."Credit Card No."); */

        EXIT(TRUE);

    end;

    // local procedure GetBasicPaymentInfoForGenJnlLn(var GenJnlLine: Record "Gen. Journal Line"; Amount: Decimal; var PaymentInfo: DotNet IBasicPaymentInfo)
    // begin
    //     DOPaymentIntegrationMgt.CreateBasicPaymentInfo(
    //       PaymentInfo,
    //       GenJnlLine."Account No.",
    //       FORMAT(GenJnlLine."Document Type"),
    //       GenJnlLine."Account No.",
    //       FindCurrencyCode(GenJnlLine."Currency Code"),
    //       Amount);
    // end;

    // local procedure GetBasicPaymentInfoForSalesDoc(SalesHeader: Record "Sales Header"; Amount: Decimal; var PaymentInfo: DotNet IBasicPaymentInfo)
    // begin
    //     DOPaymentIntegrationMgt.CreateBasicPaymentInfo(
    //       PaymentInfo,
    //       SalesHeader."Bill-to Customer No.",
    //       FORMAT(SalesHeader."Document Type"),
    //       SalesHeader."No.",
    //       FindCurrencyCode(SalesHeader."Currency Code"),
    //       Amount);
    // end;

    local procedure InitTransaction()
    var
        DOPaymentConnectionSetup: Record "DO Payment Connection Setup";
    begin
        IF PaymentSetupLoaded THEN
            EXIT;

        DOPaymentConnectionSetup.GET;
        DOPaymentConnectionSetup.TESTFIELD(Active);

        IF NOT TestMessageShown AND DOPaymentConnectionSetup."Run in Test Mode" THEN BEGIN
            MESSAGE(Text007);
            TestMessageShown := TRUE;
        END;

        PaymentSetupLoaded := TRUE;
    end;

    local procedure FinishTransaction(var DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry")
    begin
        COMMIT;
        IF DOPaymentTransLogEntry."Transaction Result" = DOPaymentTransLogEntry."Transaction Result"::Failed THEN BEGIN
            IF DOPaymentTransLogEntry.Amount <> 0 THEN
                ERROR(
                  Text002,
                  DOPaymentTransLogEntry."Transaction Type",
                  DOPaymentTransLogEntry.Amount,
                  DOPaymentTransLogEntry."Transaction Description");

            ERROR(Text003, DOPaymentTransLogEntry."Transaction Type", DOPaymentTransLogEntry."Transaction Description");
        END;
    end;


    procedure FindCurrencyCode(CurrencyCode: Code[10]): Code[10]
    begin
        IF CurrencyCode = '' THEN BEGIN
            GLSetup.GET;
            GLSetup.TESTFIELD("LCY Code");
            CurrencyCode := GLSetup."LCY Code";
            IF CurrencyCode = 'USD' THEN
                CurrencyCode := '';
        END;
        EXIT(CurrencyCode);
    end;

    local procedure FindCustLedgEntryNoForPayment(var CustLedgerEntry: Record "Cust. Ledger Entry"; DocumentType: Option Payment,Refund)
    var
        CustLedgerEntry2: Record "Cust. Ledger Entry";
    begin
        IF DocumentType = DocumentType::Payment THEN
            IF CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Payment THEN
                EXIT;

        IF DocumentType = DocumentType::Refund THEN
            IF CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Refund THEN
                EXIT;

        CustLedgerEntry2.SETRANGE("Document No.", CustLedgerEntry."Document No.");
        IF DocumentType = DocumentType::Payment THEN
            CustLedgerEntry2.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Payment)
        ELSE
            CustLedgerEntry2.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Refund);
        CustLedgerEntry2.SETRANGE("Posting Date", CustLedgerEntry."Posting Date");
        CustLedgerEntry2.FINDLAST;

        CustLedgerEntry := CustLedgerEntry2;
    end;

    local procedure FinalizeTransLogAfterCapt(TransLogEntryNo: Integer; DOPaymentTransLogEntryNo: Integer; var DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"; CustomerLedgerEntryNo: Integer)
    var
        AuthDOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
    begin
        IF DOPaymentTransLogEntry."Transaction Result" = DOPaymentTransLogEntry."Transaction Result"::Success THEN BEGIN
            DOPaymentTransLogEntry.GET(TransLogEntryNo);
            DOPaymentTransLogEntry."Transaction Status" := DOPaymentTransLogEntry."Transaction Status"::"Posting Not Finished";
            DOPaymentTransLogEntry."Cust. Ledger Entry No." := CustomerLedgerEntryNo;
            DOPaymentTransLogEntry.MODIFY;

            IF DOPaymentTransLogEntry."Transaction Result" <> DOPaymentTransLogEntry."Transaction Result"::Failed THEN
                IF AuthDOPaymentTransLogEntry.GET(DOPaymentTransLogEntryNo) THEN BEGIN
                    AuthDOPaymentTransLogEntry."Transaction Status" := AuthDOPaymentTransLogEntry."Transaction Status"::Captured;
                    AuthDOPaymentTransLogEntry.MODIFY;
                END;
        END;
    end;

    local procedure FinalizeTransLogAfterRefu(TransLogEntryNo: Integer; DOPaymentTransLogEntryNo: Integer; var DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry")
    var
        AuthDOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
    begin
        IF DOPaymentTransLogEntry."Transaction Result" = DOPaymentTransLogEntry."Transaction Result"::Success THEN BEGIN
            DOPaymentTransLogEntry.GET(TransLogEntryNo);
            DOPaymentTransLogEntry."Transaction Status" := DOPaymentTransLogEntry."Transaction Status"::"Posting Not Finished";
            DOPaymentTransLogEntry.MODIFY;

            IF AuthDOPaymentTransLogEntry."Transaction Result" <> DOPaymentTransLogEntry."Transaction Result"::Failed THEN
                IF DOPaymentTransLogEntryNo > 0 THEN BEGIN
                    AuthDOPaymentTransLogEntry.GET(DOPaymentTransLogEntryNo);
                    AuthDOPaymentTransLogEntry."Transaction Status" := AuthDOPaymentTransLogEntry."Transaction Status"::Refunded;
                    AuthDOPaymentTransLogEntry.MODIFY;
                END;
        END;
    end;


    // procedure CaptureSalesDocNew(SalesHeader: Record "Sales Header"; CustLedgerEntryNo: Integer): Integer
    // var
    //     DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
    //     PaymentInfo: DotNet IBasicPaymentInfo;
    //     DocNo: Code[20];
    //     AmountToCapture: Decimal;
    //     DOPaymentTransLogEntryNo: Integer;
    //     CaptureTransLogEntryNo: Integer;
    // begin
    //     IF NOT IsValidPaymentMethod(SalesHeader."Payment Method Code") THEN
    //         EXIT;

    //     CheckSalesDoc(SalesHeader);

    //     AmountToCapture := CalcPostedSalesDocAmount(CustLedgerEntryNo);

    //     IF DOPaymentTransLogMgt.FindPostingNotFinishedEntryNew(
    //          SalesHeader."Document Type".AsInteger(), SalesHeader."No.", DOPaymentTransLogEntry)
    //     THEN
    //         IF VerifDocAgainstAlreadPostdTran(
    //              SalesHeader."Document Type".AsInteger(),
    //              SalesHeader."Currency Code",
    //              AmountToCapture,
    //              SalesHeader."Credit Card No.",
    //              DOPaymentTransLogEntry)
    //         THEN
    //             EXIT(DOPaymentTransLogEntry."Entry No.");

    //     /*IF DOPaymentTransLogMgt.FindValidAuthorizationEntry(SalesHeader."Document Type",SalesHeader."No.",DOPaymentTransLogEntry) THEN BEGIN
    //       DOPaymentTransLogEntryNo := DOPaymentTransLogEntry."Entry No.";
    //     END ELSE BEGIN
    //       DOPaymentTransLogEntryNo := AuthorizeSalesDoc(SalesHeader,CustLedgerEntryNo,FALSE);
    //       DOPaymentTransLogEntry.GET(DOPaymentTransLogEntryNo);
    //     END;

    //     DocNo := SalesHeader."Posting No.";
    //     IF DocNo = '' THEN
    //       DocNo := SalesHeader."Last Posting No.";

    //     InitTransaction;
    //     GetBasicPaymentInfoForSalesDoc(SalesHeader,AmountToCapture,PaymentInfo);
    //     CaptureTransLogEntryNo :=
    //       DOPaymentIntegrationMgt.CapturePayment(
    //         DOPaymentTransLogEntry,
    //         SalesHeader."Credit Card No.",
    //         PaymentInfo,
    //         DOPaymentTransLogEntry."Document Type"::Invoice,
    //         DocNo);

    //     FinalizeTransLogAfterCapt(CaptureTransLogEntryNo,DOPaymentTransLogEntryNo,DOPaymentTransLogEntry,CustLedgerEntryNo);

    //     FinishTransaction(DOPaymentTransLogEntry);

    //     EXIT(CaptureTransLogEntryNo);
    //      */

    // end;


    // procedure RefundSalesDocNew(SalesHeader: Record "Sales Header"; CustLedgerEntryNo: Integer): Integer
    // var
    //     RefundDOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
    //     PaymentInfo: DotNet IBasicPaymentInfo;
    //     AmountToRefund: Decimal;
    //     RefundTransLogEntryNo: Integer;
    // begin
    //     IF NOT IsValidPaymentMethod(SalesHeader."Payment Method Code") THEN
    //         EXIT;

    //     CheckSalesDoc(SalesHeader);

    //     AmountToRefund := -CalcPostedSalesDocAmount(CustLedgerEntryNo);

    //     IF DOPaymentTransLogMgt.FindPostingNotFinishedEntryNew1(
    //          RefundDOPaymentTransLogEntry."Document Type"::Refund,
    //          SalesHeader."No.",
    //          RefundDOPaymentTransLogEntry)
    //     THEN
    //         IF VerifDocAgainstAlreadPostdTran(
    //              SalesHeader."Document Type",
    //              SalesHeader."Currency Code",
    //              AmountToRefund,
    //              SalesHeader."Credit Card No.",
    //              RefundDOPaymentTransLogEntry)
    //         THEN
    //             EXIT(RefundDOPaymentTransLogEntry."Entry No.");

    //     /*InitTransaction;
    //     GetBasicPaymentInfoForSalesDoc(SalesHeader,AmountToRefund,PaymentInfo);
    //     RefundTransLogEntryNo :=
    //       DOPaymentIntegrationMgt.RefundPayment(
    //         RefundDOPaymentTransLogEntry,
    //         SalesHeader."Credit Card No.",
    //         PaymentInfo,
    //         RefundDOPaymentTransLogEntry."Document Type"::Refund,
    //         SalesHeader."No.");

    //     RefundDOPaymentTransLogEntry.GET(RefundTransLogEntryNo);
    //     RefundDOPaymentTransLogEntry."Transaction Status" := RefundDOPaymentTransLogEntry."Transaction Status"::"Posting Not Finished";
    //     RefundDOPaymentTransLogEntry.MODIFY;

    //     FinishTransaction(RefundDOPaymentTransLogEntry);

    //     EXIT(RefundTransLogEntryNo);
    //     */

    // end;
}

