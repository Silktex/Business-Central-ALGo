codeunit 60002 "DO Payment Integration Mgt."
{
    Permissions = TableData "DO Payment Connection Details" = rimd,
                  TableData "DO Payment Credit Card Number" = r,
                  TableData "DO Payment Trans. Log Entry" = m;

    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'Error Code = %1; Message = %2.';
        Text002: Label 'Failed to read parent transaction ID.';
        Text003: Label 'You must complete Microsoft Dynamics ERP Payment Services Connection Setup before you use Payment Services.';
        Text004: Label 'Microsoft Dynamics ERP Payment Services has not been enabled.';
        Text005: Label 'Credit card authorization in progress...';
        Text006: Label 'Failed to refresh the transaction status.\';
        Text007: Label 'Microsoft Dynamics ERP Payment Services Signup was canceled.';
        Text008: Label 'Sign-up process must be completed before you can select a service.';
        Text009: Label 'Sign-up process succeeded. Select a valid service ID.';
        CreateKeyBeforeSignupError: Label 'You must create an encryption key before starting sign-up process.';
        DOPaymentTransLogMgt: Codeunit "DO Payment Trans. Log Mgt.";


    // procedure AuthorizePayment(var ParentDOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"; CreditCardNo: Code[20]; var PaymentInfo: DotNet IBasicPaymentInfo; SourceType: Option " ","Order",Invoice,Payment,Refund; SourceNo: Code[20]): Integer
    // begin
    //     EXIT(
    //       CreatePayment(
    //         ParentDOPaymentTransLogEntry,
    //         CreditCardNo,
    //         PaymentInfo,
    //         SourceType,
    //         SourceNo,
    //         ParentDOPaymentTransLogEntry."Transaction Type"::Authorization));
    // end;


    // procedure VoidPayment(var DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"; CreditCardNo: Code[20]; var PaymentInfo: DotNet IBasicPaymentInfo; SourceType: Option " ","Order",Invoice,Payment,Refund; SourceNo: Code[20]): Integer
    // begin
    //     EXIT(
    //       CreatePayment(
    //         DOPaymentTransLogEntry,
    //         CreditCardNo,
    //         PaymentInfo,
    //         SourceType,
    //         SourceNo,
    //         DOPaymentTransLogEntry."Transaction Type"::Void));
    // end;


    // procedure CapturePayment(var DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"; CreditCardNo: Code[20]; var PaymentInfo: DotNet IBasicPaymentInfo; SourceType: Option " ","Order",Invoice,Payment,Refund; SourceNo: Code[20]): Integer
    // begin
    //     EXIT(
    //       CreatePayment(
    //         DOPaymentTransLogEntry,
    //         CreditCardNo,
    //         PaymentInfo,
    //         SourceType,
    //         SourceNo,
    //         DOPaymentTransLogEntry."Transaction Type"::Capture));
    // end;


    // procedure RefundPayment(var ParentDOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"; CreditCardNo: Code[20]; var PaymentInfo: DotNet IBasicPaymentInfo; SourceType: Option " ","Order",Invoice,Payment,Refund; SourceNo: Code[20]): Integer
    // begin
    //     EXIT(
    //       CreatePayment(
    //         ParentDOPaymentTransLogEntry,
    //         CreditCardNo,
    //         PaymentInfo,
    //         SourceType,
    //         SourceNo,
    //         ParentDOPaymentTransLogEntry."Transaction Type"::Refund));
    // end;

    // local procedure CreateProxyContext(var ProxyContext: DotNet IProxyContext)
    // var
    //     DOPaymentConnectionSetup: Record "DO Payment Connection Setup";
    // begin
    //     IF NOT DOPaymentConnectionSetup.GET THEN
    //         ERROR(Text003);
    //     IF NOT DOPaymentConnectionSetup.Active THEN
    //         ERROR(Text004);
    //     IF NOT CreateNewProxyContext(DOPaymentConnectionSetup, ProxyContext) THEN
    //         ERROR(Text003);
    // end;


    // procedure RefreshTransactionStatus(var DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry")
    // var
    //     TransactionResult: DotNet ITransactionResult;
    //     ProxyContext: DotNet IProxyContext;
    //     PaymentHandler: DotNet Payment;
    // begin
    //     IF DOPaymentTransLogEntry.ISEMPTY THEN
    //         DOPaymentTransLogEntry.FIELDERROR("Transaction GUID");

    //     CreateProxyContext(ProxyContext);

    //     PaymentHandler := PaymentHandler.Payment;

    //     TransactionResult := PaymentHandler.RetrieveTransactionResult(FORMAT(DOPaymentTransLogEntry."Transaction GUID"), ProxyContext);

    //     IF NOT TransactionResult.IsSuccess THEN
    //         ERROR(Text006 + FORMAT(Text001, TransactionResult.LastErrorCode, COPYSTR(TransactionResult.LastErrorMessage, 1, 250)));

    //     IF TransactionResult.IsRefunded THEN
    //         DOPaymentTransLogEntry."Transaction Status" := DOPaymentTransLogEntry."Transaction Status"::Refunded;

    //     IF TransactionResult.IsCaptured THEN
    //         DOPaymentTransLogEntry."Transaction Status" := DOPaymentTransLogEntry."Transaction Status"::Captured;

    //     IF TransactionResult.IsVoided THEN
    //         DOPaymentTransLogEntry."Transaction Status" := DOPaymentTransLogEntry."Transaction Status"::Voided;

    //     DOPaymentTransLogEntry.MODIFY;
    // end;

    // local procedure CreateCreditCardObject(CreditCardNo: Code[20]; var CreditCardInfo: DotNet ICreditCardInfo)
    // var
    //     DOPaymentCreditCard: Record "DO Payment Credit Card";
    //     DOPaymentCreditCardNo: Record "DO Payment Credit Card Number";
    //     Contact: Record Contact;
    //     NewCreditCardInfo: DotNet CreditCardInfo;
    //     Int: Integer;
    // begin
    //     DOPaymentCreditCard.GET(CreditCardNo);
    //     DOPaymentCreditCardNo.GET(CreditCardNo);
    //     Contact.GET(DOPaymentCreditCard."Contact No.");

    //     NewCreditCardInfo := NewCreditCardInfo.CreditCardInfo;
    //     CreditCardInfo := NewCreditCardInfo;
    //     CreditCardInfo.AccountholderName := DOPaymentCreditCard."Card Holder Name";
    //     CreditCardInfo.AccountNumber := DOPaymentCreditCardNo.GetData;
    //     CreditCardInfo.CardVerificationValue := FORMAT(DOPaymentCreditCard."Cvc No.");

    //     EVALUATE(Int, COPYSTR(DOPaymentCreditCard."Expiry Date", 1, 2));
    //     CreditCardInfo.ExpirationMonth := Int;
    //     EVALUATE(Int, COPYSTR(DOPaymentCreditCard."Expiry Date", 3, 2));
    //     CreditCardInfo.ExpirationYear := Int;

    //     CreditCardInfo.StreetAddress := Contact.Address;
    //     CreditCardInfo.PostalCode := Contact."Post Code";
    //     CreditCardInfo.City := Contact.City;
    //     CreditCardInfo.CountryOrRegion := Contact."Country/Region Code";
    // end;


    // procedure CreateBasicPaymentInfo(var PaymentInfo: DotNet IBasicPaymentInfo; CustomerId: Code[20]; Description: Text[1024]; InvoiceNo: Code[20]; CurrencyCode: Code[10]; Amount: Decimal)
    // var
    //     NewBasicPaymentInfo: DotNet BasicPaymentInfo;
    // begin
    //     NewBasicPaymentInfo := NewBasicPaymentInfo.BasicPaymentInfo;
    //     NewBasicPaymentInfo.CustomerId := CustomerId;
    //     NewBasicPaymentInfo.Description := Description;
    //     NewBasicPaymentInfo.InvoiceNumber := InvoiceNo;
    //     NewBasicPaymentInfo.CurrencyCode := CurrencyCode;
    //     NewBasicPaymentInfo.Amount := Amount;
    //     PaymentInfo := NewBasicPaymentInfo;
    // end;

    // local procedure CreatePayment(var ParentDOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry"; CreditCardNo: Code[20]; PaymentInfo: DotNet IBasicPaymentInfo; SourceType: Option " ","Order",Invoice,Payment,Refund; SourceNo: Code[20]; TransactionType: Option Authorization,Void,Capture,Refund): Integer
    // var
    //     DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
    //     TransactionResult: DotNet ITransactionResult;
    //     CreditCardInfo: DotNet ICreditCardInfo;
    //     ProxyContext: DotNet IProxyContext;
    //     PaymentHandler: DotNet Payment;
    //     Window: Dialog;
    //     TransactionLogEntryNo: Integer;
    //     ParentTransGuid: Guid;
    // begin
    //     IF NOT ParentDOPaymentTransLogEntry.ISEMPTY THEN
    //         ParentTransGuid := ParentDOPaymentTransLogEntry."Transaction GUID";

    //     TransactionLogEntryNo :=
    //       DOPaymentTransLogMgt.InitializeTransactionLogEntry(
    //         DOPaymentTransLogEntry,
    //         CreditCardNo,
    //         SourceType,
    //         SourceNo,
    //         PaymentInfo.CustomerId,
    //         TransactionType,
    //         ParentDOPaymentTransLogEntry);

    //     CreateProxyContext(ProxyContext);

    //     CreateCreditCardObject(CreditCardNo, CreditCardInfo);
    //     PaymentInfo.ReferenceId := DOPaymentTransLogEntry."Reference GUID";

    //     PaymentHandler := PaymentHandler.Payment;

    //     CASE TransactionType OF
    //         TransactionType::Authorization:
    //             BEGIN
    //                 Window.OPEN(Text005);
    //                 TransactionResult := PaymentHandler.Authorize(PaymentInfo, CreditCardInfo, ProxyContext);
    //                 Window.CLOSE;
    //             END;
    //         TransactionType::Capture:
    //             TransactionResult := PaymentHandler.Capture(PaymentInfo, FORMAT(ParentTransGuid), ProxyContext);
    //         TransactionType::Void:
    //             BEGIN
    //                 IF ISNULLGUID(ParentTransGuid) THEN
    //                     ERROR(Text002);
    //                 TransactionResult := PaymentHandler.VoidAuthorization(PaymentInfo, FORMAT(ParentTransGuid), ProxyContext);
    //             END;
    //         TransactionType::Refund:
    //             TransactionResult := PaymentHandler.Refund(PaymentInfo, ParentTransGuid, CreditCardInfo, ProxyContext);
    //     END;

    //     DOPaymentTransLogMgt.CompleteTransLogEntry(DOPaymentTransLogEntry, TransactionResult);

    //     // Fix to keep amount when voiding and amount
    //     IF DOPaymentTransLogEntry.Amount = 0 THEN BEGIN
    //         DOPaymentTransLogEntry.Amount := PaymentInfo.Amount;
    //         DOPaymentTransLogEntry.MODIFY;
    //     END;

    //     EXIT(TransactionLogEntryNo);
    // end;


    procedure ServiceBoarding()
    begin
        // var
        //     DOPaymentConnectionSetup: Record "DO Payment Connection Setup";
        //     DOPaymentConnectionDetails: Record "DO Payment Connection Details";
        //     Languagemgmt: Record "Windows Language";
        //     EncryptionMgt: Codeunit "Encryption Management";
        //     [RunOnClient]
        //     UserManagement: DotNet UserManagement;
        //     [RunOnClient]
        //     ClientBoardingResult: DotNet IBoardingResult;
        //     ServerBoardingResult: DotNet IBoardingResult;
        //     [RunOnClient]
        //     ClientProxyContext: DotNet ProxyContext;
        //     ServerProxyContext: DotNet IProxyContext;
        //     UserNameInS: InStream;
        // begin
        //     //IF NOT EncryptionMgt.HasKey THEN
        //     IF NOT EncryptionMgt.IsEncryptionEnabled() THEN
        //         ERROR(CreateKeyBeforeSignupError);

        //     Language.GET(WINDOWSLANGUAGE);
        //     DOPaymentConnectionSetup.GET;
        //     // Server Side creation
        //     CreateNewProxyContext(DOPaymentConnectionSetup, ServerProxyContext);
        //     // Serialize data to the client
        //     ClientProxyContext := ServerProxyContext;

        //     UserManagement := UserManagement.UserManagement;
        //     ClientBoardingResult :=
        //       UserManagement.ServiceOnBoarding(COMPANYNAME, 'PaymentService', Language."Abbreviated Name", SERIALNUMBER, ClientProxyContext);

        //     // Serialize data to the server
        //     ServerBoardingResult := ClientBoardingResult;

        //     IF ServerBoardingResult.IsSuccess THEN BEGIN
        //         IF NOT DOPaymentConnectionSetup.GET THEN
        //             DOPaymentConnectionSetup.CreateDefaultSetup;
        //         IF NOT DOPaymentConnectionDetails.GET THEN BEGIN
        //             DOPaymentConnectionDetails.INIT;
        //             DOPaymentConnectionDetails."Primary Key" := DOPaymentConnectionSetup."Primary Key";
        //             DOPaymentConnectionDetails.INSERT;
        //         END;

        //         DOPaymentConnectionSetup.OrganizationId := ServerBoardingResult.OrganizationId;
        //         DOPaymentConnectionSetup.ServiceGroupId := ServerBoardingResult.ServiceGroupId;
        //         DOPaymentConnectionSetup.MODIFY;

        //         DOPaymentConnectionDetails.UserName.CREATEINSTREAM(UserNameInS);
        //         ServerBoardingResult.WriteUserName(UserNameInS);

        //         DOPaymentConnectionDetails.SetPasswordData(ServerBoardingResult.Password);

        //         DOPaymentConnectionDetails.MODIFY;
        //     END ELSE BEGIN
        //         IF ServerBoardingResult.LastErrorCode = 1000000 THEN
        //             ERROR(Text007);
        //         ERROR(Text001, ServerBoardingResult.LastErrorCode, COPYSTR(ServerBoardingResult.LastErrorMessage, 1, 250));
        //     END;

        //     MESSAGE(Text009);
    end;


    procedure Disassociate()
    begin
        // var
        //     DOPaymentConnectionSetup: Record "DO Payment Connection Setup";
        //     UserManagement: DotNet UserManagement;
        //     ProxyContext: DotNet IProxyContext;
        //     DisassociateResult: DotNet ISimpleResult;
        // begin
        //     IF NOT DOPaymentConnectionSetup.GET THEN
        //         ERROR(Text003);
        //     IF NOT CreateNewProxyContext(DOPaymentConnectionSetup, ProxyContext) THEN
        //         ERROR(Text003);

        //     UserManagement := UserManagement.UserManagement;
        //     DisassociateResult := UserManagement.Unassociate(COMPANYNAME, ProxyContext);
        //     IF DisassociateResult.IsSuccess THEN BEGIN
        //         DOPaymentConnectionSetup.DELETEALL(TRUE);
        //         DOPaymentConnectionSetup.CreateDefaultSetup
        //     END ELSE
        //         ERROR(Text001, DisassociateResult.LastErrorCode, DisassociateResult.LastErrorMessage);
    end;


    procedure SelectServiceId(var ServiceId: Guid)
    begin
        // var
        //     NameValueBuffer: Record "Name/Value Buffer";
        //     DOPaymentConnectionSetup: Record "DO Payment Connection Setup";
        //     NameValueLookup: Page "Name/Value Lookup";
        //     ProxyContext: DotNet IProxyContext;
        //     UserManagement: DotNet UserManagement;
        //     Enumerator: DotNet ServiceSubscriptionDetailsList;
        //     ServiceDetails: DotNet IServiceSubscriptionDetails;
        //     SubscriptionDetailsResult: DotNet ISubscriptionDetailsResult;
        // begin
        //     IF NOT DOPaymentConnectionSetup.GET THEN
        //         ERROR(Text003);
        //     IF NOT CreateNewProxyContext(DOPaymentConnectionSetup, ProxyContext) THEN
        //         ERROR(Text003);
        //     IF NOT (ProxyContext.Password <> '') THEN
        //         ERROR(Text008);
        //     UserManagement := UserManagement.UserManagement;
        //     SubscriptionDetailsResult := UserManagement.GetServiceIds(ProxyContext, 'PaymentService');

        //     IF NOT SubscriptionDetailsResult.IsSuccess THEN
        //         ERROR(Text001, SubscriptionDetailsResult.LastErrorCode, SubscriptionDetailsResult.LastErrorMessage);

        //     Enumerator := SubscriptionDetailsResult.SubscriptionDetails;
        //     IF NOT ISNULL(Enumerator) THEN BEGIN
        //         Enumerator.Reset;
        //         WHILE Enumerator.MoveNext DO BEGIN
        //             ServiceDetails := Enumerator.Current;
        //             IF NOT ISNULL(ServiceDetails) THEN
        //                 IF ServiceDetails.ServiceGroupId = DOPaymentConnectionSetup.ServiceGroupId THEN BEGIN
        //                     NameValueLookup.AddItem(
        //                       COPYSTR(ServiceDetails.Name, 1, MAXSTRLEN(NameValueBuffer.Name)),
        //                       '{' + COPYSTR(ServiceDetails.SubscriptionId, 1, MAXSTRLEN(NameValueBuffer.Value) - 2) + '}');
        //                     IF ServiceDetails.SubscriptionId = FORMAT(ServiceId) THEN BEGIN
        //                         NameValueBuffer.Name := COPYSTR(ServiceDetails.Name, 1, MAXSTRLEN(NameValueBuffer.Name));
        //                         NameValueBuffer.Value := '{' + COPYSTR(ServiceDetails.SubscriptionId, 1, MAXSTRLEN(NameValueBuffer.Value) - 2) + '}';
        //                     END;
        //                 END;
        //         END;

        //         NameValueLookup.SETRECORD(NameValueBuffer);
        //         NameValueLookup.LOOKUPMODE := TRUE;
        //         IF NameValueLookup.RUNMODAL = ACTION::LookupOK THEN BEGIN
        //             NameValueLookup.GETRECORD(NameValueBuffer);
        //             IF NameValueBuffer.Value <> '' THEN
        //                 EVALUATE(ServiceId, NameValueBuffer.Value);
        //         END;
        //     END;
    end;

    // local procedure CreateNewProxyContext(var DOPaymentConnectionSetup: Record "DO Payment Connection Setup"; var ProxyContext: DotNet IProxyContext) IncludesDetails: Boolean
    // var
    //     DOPaymentConnectionDetails: Record "DO Payment Connection Details";
    //     NewProxyContext: DotNet ProxyContext;
    //     UserNameInS: InStream;
    // begin
    //     NewProxyContext := NewProxyContext.ProxyContext;
    //     NewProxyContext.ApplicationName := 'Microsoft Dynamics NAV';
    //     NewProxyContext.EnvironmentName := DOPaymentConnectionSetup.Environment;
    //     NewProxyContext.RunInTestMode := DOPaymentConnectionSetup."Run in Test Mode";
    //     NewProxyContext.ServiceIdentifier := DOPaymentConnectionSetup."Service ID";
    //     NewProxyContext.OrganizationId := DOPaymentConnectionSetup.OrganizationId;
    //     NewProxyContext.ServiceGroupId := DOPaymentConnectionSetup.ServiceGroupId;

    //     IncludesDetails := FALSE;
    //     IF DOPaymentConnectionDetails.GET THEN BEGIN
    //         DOPaymentConnectionDetails.CALCFIELDS(UserName);
    //         DOPaymentConnectionDetails.CALCFIELDS(Password);
    //         IF DOPaymentConnectionDetails.UserName.HASVALUE THEN BEGIN
    //             DOPaymentConnectionDetails.UserName.CREATEINSTREAM(UserNameInS);
    //             NewProxyContext.ReadUserName(UserNameInS);
    //             IncludesDetails := TRUE;
    //         END;
    //         NewProxyContext.Password := DOPaymentConnectionDetails.GetPasswordData;
    //     END;

    //     ProxyContext := NewProxyContext;
    // end;
}

