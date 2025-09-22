codeunit 60004 "DO Payment Trans. Log Mgt."
{
    Permissions = TableData "DO Payment Trans. Log Entry" = im;

    trigger OnRun()
    begin
    end;

    var
        DOPaymentMgt: Codeunit "DO Payment Mgt.";
        Text065: Label 'Credit card %1 has already been performed for this %2, but posting failed. You must complete posting of %2 %3.';
        Text066: Label 'The operation cannot be performed because %1 %2 has already been authorized on %3, and authorization is not expired.';
        Text069: Label '%1 %2 has already been authorized on %3, and authorization is not expired. You must void the previous authorization before you can delete this %1.';
        Text001: Label '"Error Code = %1; Message = %2"';
        Text002: Label 'Payment transaction has been performed successfully.';
        Text003: Label 'Payment transaction has not been performed.';
        Text004: Label 'Payment transaction has been initialized but has not been completed.';
        Text005: Label 'A capture of %1 %2 has already been performed for Document No. %3 on %4.';


    procedure ValidateCanDeleteDocument(PaymentMethodCode: Code[10]; DocumentType: Integer; DocumentTypeName: Text[30]; DocumentNo: Code[20])
    var
        DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
    begin
        IF DOPaymentMgt.IsValidPaymentMethod(PaymentMethodCode) THEN BEGIN
            IF FindPostingNotFinishedEntry(DocumentType, DocumentNo, DOPaymentTransLogEntry) THEN
                ERROR(Text065, DOPaymentTransLogEntry."Transaction Type", DocumentTypeName, DocumentNo);

            IF FindValidAuthorizationEntry(DocumentType, DocumentNo, DOPaymentTransLogEntry) THEN
                ERROR(Text069, DocumentTypeName, DocumentNo, DOPaymentTransLogEntry."Transaction Date-Time");
        END;
    end;


    procedure ValidateHasNoValidTransactions(DocumentType: Integer; DocumentTypeName: Text[30]; DocumentNo: Code[20])
    var
        DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
    begin
        IF FindPostingNotFinishedEntry(DocumentType, DocumentNo, DOPaymentTransLogEntry) THEN
            ERROR(Text065, DOPaymentTransLogEntry."Transaction Type", DocumentTypeName, DocumentNo);

        IF FindValidAuthorizationEntry(DocumentType, DocumentNo, DOPaymentTransLogEntry) THEN
            ERROR(Text066, DocumentTypeName, DocumentNo, DOPaymentTransLogEntry."Transaction Date-Time");
    end;


    procedure UpdateExpirationInAuthEntries(DocumentType: Integer; DocumentNo: Code[20])
    var
        DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
        DOPaymentSetup: Record "DO Payment Setup";
    begin
        IF DOPaymentSetup.GET THEN
            IF DOPaymentSetup."Days Before Authoriz. Expiry" <> 0 THEN
                //WITH DOPaymentTransLogEntry DO BEGIN
                DOPaymentTransLogEntry.SETCURRENTKEY("Document Type", "Document No.", "Transaction Type", "Transaction Result", "Transaction Status");
        DOPaymentTransLogEntry.SETRANGE("Document Type", DocumentType);
        DOPaymentTransLogEntry.SETRANGE("Document No.", DocumentNo);
        DOPaymentTransLogEntry.SETRANGE("Transaction Type", DOPaymentTransLogEntry."Transaction Type"::Authorization);
        DOPaymentTransLogEntry.SETRANGE("Transaction Result", DOPaymentTransLogEntry."Transaction Result"::Success);
        DOPaymentTransLogEntry.SETRANGE("Transaction Status", DOPaymentTransLogEntry."Transaction Status"::" ");
        IF DOPaymentTransLogEntry.FINDSET THEN
            REPEAT
                IF DT2DATE(CURRENTDATETIME) -
                   DT2DATE(DOPaymentTransLogEntry."Transaction Date-Time") > DOPaymentSetup."Days Before Authoriz. Expiry"
                THEN BEGIN
                    DOPaymentTransLogEntry."Transaction Status" := DOPaymentTransLogEntry."Transaction Status"::Expired;
                    DOPaymentTransLogEntry.MODIFY;
                END;
            UNTIL DOPaymentTransLogEntry.NEXT = 0;
        //END;
    end;


    procedure FindValidAuthorizationEntry(DocumentType: Integer; DocumentNo: Code[20]; var DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"): Boolean
    begin
        UpdateExpirationInAuthEntries(DocumentType, DocumentNo);
        //WITH DOPaymentTransLogEntry DO BEGIN
        DOPaymentTransLogEntry.RESET;
        DOPaymentTransLogEntry.SETCURRENTKEY("Document Type", "Document No.", "Transaction Type", "Transaction Result", "Transaction Status");
        DOPaymentTransLogEntry.SETRANGE("Document Type", DocumentType);
        DOPaymentTransLogEntry.SETRANGE("Document No.", DocumentNo);
        DOPaymentTransLogEntry.SETRANGE("Transaction Type", DOPaymentTransLogEntry."Transaction Type"::Authorization);
        DOPaymentTransLogEntry.SETRANGE("Transaction Result", DOPaymentTransLogEntry."Transaction Result"::Success);
        DOPaymentTransLogEntry.SETRANGE("Transaction Status", DOPaymentTransLogEntry."Transaction Status"::" ");
        EXIT(DOPaymentTransLogEntry.FINDFIRST);
        //END;
    end;


    procedure FindPostingNotFinishedEntry(DocumentType: Integer; DocumentNo: Code[20]; var DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"): Boolean
    begin
        //WITH DOPaymentTransLogEntry DO BEGIN
        DOPaymentTransLogEntry.RESET;
        DOPaymentTransLogEntry.SETCURRENTKEY("Document Type", "Document No.", "Transaction Type", "Transaction Result", "Transaction Status");
        DOPaymentTransLogEntry.SETRANGE("Document Type", DocumentType);
        DOPaymentTransLogEntry.SETRANGE("Document No.", DocumentNo);
        DOPaymentTransLogEntry.SETFILTER("Transaction Type", '%1', DOPaymentTransLogEntry."Transaction Type"::Capture);
        DOPaymentTransLogEntry.SETRANGE("Transaction Result", DOPaymentTransLogEntry."Transaction Result"::Success);
        DOPaymentTransLogEntry.SETRANGE("Transaction Status", DOPaymentTransLogEntry."Transaction Status"::Captured);
        EXIT(DOPaymentTransLogEntry.FINDFIRST);
        //END;
    end;


    procedure FindCapturedButNotFinishedEntr(CustomerNo: Code[20]; DocumentNo: Code[20]; PaidAmount: Decimal; CurrencyCode: Code[10]; CreditCardNo: Code[20]; var DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"): Boolean
    begin
        //WITH DOPaymentTransLogEntry DO BEGIN
        DOPaymentTransLogEntry.RESET;
        DOPaymentTransLogEntry.SETCURRENTKEY("Document No.", "Customer No.", "Transaction Status");
        DOPaymentTransLogEntry.SETRANGE("Document No.", DocumentNo);
        DOPaymentTransLogEntry.SETRANGE("Customer No.", CustomerNo);
        DOPaymentTransLogEntry.SETRANGE("Transaction Status", DOPaymentTransLogEntry."Transaction Status"::"Posting Not Finished");
        DOPaymentTransLogEntry.SETRANGE("Credit Card No.", CreditCardNo);
        CurrencyCode := DOPaymentMgt.FindCurrencyCode(CurrencyCode);
        DOPaymentTransLogEntry.SETRANGE("Currency Code", CurrencyCode);
        DOPaymentTransLogEntry.SETRANGE("Transaction Type", DOPaymentTransLogEntry."Transaction Type"::Capture);
        DOPaymentTransLogEntry.SETRANGE("Transaction Result", DOPaymentTransLogEntry."Transaction Result"::Success);

        IF NOT DOPaymentTransLogEntry.FINDFIRST THEN
            EXIT(FALSE);

        IF DOPaymentTransLogEntry.Amount <> PaidAmount THEN
            ERROR(Text005, DOPaymentTransLogEntry.Amount, CurrencyCode, DocumentNo, FORMAT(DT2DATE(DOPaymentTransLogEntry."Transaction Date-Time"), 0, 4));

        EXIT(TRUE);
        //END;
    end;


    // procedure CompleteTransLogEntry(var DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"; TransactionResult: DotNet ITransactionResult)
    // begin
    //     IF NOT TransactionResult.IsSuccess THEN BEGIN
    //         DOPaymentTransLogEntry."Transaction Result" := DOPaymentTransLogEntry."Transaction Result"::Failed;
    //         DOPaymentTransLogEntry."Transaction Description" :=
    //           COPYSTR(STRSUBSTNO(Text001, TransactionResult.LastErrorCode, TransactionResult.
    //               LastErrorMessage), 1, MAXSTRLEN(DOPaymentTransLogEntry."Transaction Description"));
    //         IF DOPaymentTransLogEntry."Transaction Description" = '' THEN
    //             DOPaymentTransLogEntry."Transaction Description" := Text003;
    //     END ELSE BEGIN
    //         DOPaymentTransLogEntry."Transaction Result" := DOPaymentTransLogEntry."Transaction Result"::Success;
    //         DOPaymentTransLogEntry."Transaction Description" := COPYSTR(TransactionResult.Description, 1, MAXSTRLEN(DOPaymentTransLogEntry.
    //               "Transaction Description"));
    //         IF DOPaymentTransLogEntry."Transaction Description" = '' THEN
    //             DOPaymentTransLogEntry."Transaction Description" := Text002;
    //         DOPaymentTransLogEntry.Amount := ROUND(TransactionResult.Amount, 0.01, '=');
    //         DOPaymentTransLogEntry."Transaction GUID" := TransactionResult.TransactionId;
    //         DOPaymentTransLogEntry."Transaction ID" := TransactionResult.TransactionIdentifier;
    //         DOPaymentTransLogEntry."Currency Code" := TransactionResult.CurrencyCode;
    //     END;
    //     DOPaymentTransLogEntry."Transaction Date-Time" := CURRENTDATETIME;
    //     DOPaymentTransLogEntry."User ID" := USERID;
    //     DOPaymentTransLogEntry.MODIFY;
    // end;


    procedure CompleTransLogEntryWithError(var DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"; ErrorMessage: Text[250])
    begin
        DOPaymentTransLogEntry."Transaction Result" := DOPaymentTransLogEntry."Transaction Result"::Failed;
        DOPaymentTransLogEntry."Transaction Description" := ErrorMessage;
        IF DOPaymentTransLogEntry."Transaction Description" = '' THEN
            DOPaymentTransLogEntry."Transaction Description" := Text003;
        DOPaymentTransLogEntry."Transaction Date-Time" := CURRENTDATETIME;
        DOPaymentTransLogEntry."User ID" := USERID;
        DOPaymentTransLogEntry.MODIFY;
    end;


    procedure InitializeTransactionLogEntry(var DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"; CreditCardNo: Code[20]; SourceType: Option " ","Order",Invoice; SourceNo: Code[20]; CustomerNo: Code[20]; TransactionType: Option; var ParentDOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"): Integer
    var
        NewDOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
    begin
        NewDOPaymentTransLogEntry.INIT;
        NewDOPaymentTransLogEntry."Document Type" := SourceType;
        NewDOPaymentTransLogEntry."Document No." := SourceNo;
        NewDOPaymentTransLogEntry."Customer No." := CustomerNo;
        NewDOPaymentTransLogEntry."Credit Card No." := CreditCardNo;
        NewDOPaymentTransLogEntry."Transaction Type" := TransactionType;
        NewDOPaymentTransLogEntry."Transaction Result" := NewDOPaymentTransLogEntry."Transaction Result"::Failed;
        NewDOPaymentTransLogEntry."Transaction Description" := Text004;
        NewDOPaymentTransLogEntry."Transaction Date-Time" := CURRENTDATETIME;
        NewDOPaymentTransLogEntry."User ID" := USERID;
        NewDOPaymentTransLogEntry."Reference GUID" := CREATEGUID;
        IF NOT ParentDOPaymentTransLogEntry.ISEMPTY THEN
            NewDOPaymentTransLogEntry."Parent Entry No." := ParentDOPaymentTransLogEntry."Entry No.";
        NewDOPaymentTransLogEntry.INSERT;

        DOPaymentTransLogEntry := NewDOPaymentTransLogEntry;
        EXIT(NewDOPaymentTransLogEntry."Entry No.");
    end;


    procedure FindPostingNotFinishedEntryNew(DocumentType: Integer; DocumentNo: Code[20]; var DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"): Boolean
    begin
        //WITH DOPaymentTransLogEntry DO BEGIN
        DOPaymentTransLogEntry.RESET;
        DOPaymentTransLogEntry.SETCURRENTKEY("Document Type", "Document No.", "Transaction Type", "Transaction Result", "Transaction Status");
        DOPaymentTransLogEntry.SETRANGE("Document Type", DocumentType);
        DOPaymentTransLogEntry.SETRANGE("Document No.", DocumentNo);
        //SETFILTER("Transaction Type",'%1|%2',"Transaction Type"::Void,"Transaction Type"::Refund);
        DOPaymentTransLogEntry.SETRANGE("Transaction Result", DOPaymentTransLogEntry."Transaction Result"::Success);
        DOPaymentTransLogEntry.SETRANGE("Transaction Status", DOPaymentTransLogEntry."Transaction Status"::Captured);
        EXIT(DOPaymentTransLogEntry.FINDFIRST);
        //END;
    end;


    procedure FindPostingNotFinishedEntryNew1(DocumentType: Integer; DocumentNo: Code[20]; var DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"): Boolean
    begin
        //WITH DOPaymentTransLogEntry DO BEGIN
        DOPaymentTransLogEntry.RESET;
        DOPaymentTransLogEntry.SETCURRENTKEY("Document Type", "Document No.", "Transaction Type", "Transaction Result", "Transaction Status");
        DOPaymentTransLogEntry.SETRANGE("Document Type", DocumentType);
        DOPaymentTransLogEntry.SETRANGE("Document No.", DocumentNo);
        //SETFILTER("Transaction Type",'%1|%2',"Transaction Type"::Void,"Transaction Type"::Refund);
        DOPaymentTransLogEntry.SETRANGE("Transaction Result", DOPaymentTransLogEntry."Transaction Result"::Success);
        DOPaymentTransLogEntry.SETRANGE("Transaction Status", DOPaymentTransLogEntry."Transaction Status"::Refunded);
        EXIT(DOPaymentTransLogEntry.FINDFIRST);
        //END;
    end;
}

