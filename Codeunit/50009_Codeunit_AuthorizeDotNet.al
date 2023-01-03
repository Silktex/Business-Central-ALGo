codeunit 50009 "Authorize Dot Net."
{
    // ---DO Payment Trans. Log Entries (829)
    // ---Nav Screen Multiple Credit Card Payment (50010)
    // *********************************************
    // 1. Charge a Credit Card (Sales Order) ---
    // 2. Void a Transaction  (Sales Order)
    // 3. Refund a Transaction (Return Sales Order)


    trigger OnRun()
    begin
    end;

    var
        MerchantAuthenticationName: Label '8Dr63Uttzth';
        MerchantTransactionKey: Label '56qx96WHUdpxD35G';
        MerchantAuthenticationNameTest: Label '5KP3u95bQpv';
        MerchantTransactionKeyTest: Label '346HZ32z3fP4hTG2';
        Companyinfo: Record "Company Information";


    procedure ChargeCreditCardJson(AuthenticationID: Integer)
    var
        RequestMsg: HttpRequestMessage;
        ContentHeaders: HttpHeaders;
        HttpWebClient: HttpClient;
        HttpWebContent: HttpContent;
        HttpWebResponse: HttpResponseMessage;
        WebClientURL: Text[250];
        WebString: Text;
        // Xmlhttp: Automation;
        reqText: Text;
        //WinHttpService: Automation;
        //htttpwin: Automation;
        TempString: Text;
        String1: Text;
        String2: Text;
        String3: Text;
        String4: Text;
        String5: Text;
        tempText: Text;
        tempText1: Text;
        StrPos1: Integer;
        TransactioID: Text;
        //CurrentXMLNode: DotNet XmlNode;
        ResultCode: Text;
        AuthCode: Text;
        JsonText: Text;
        //JObject: DotNet JObject;
        DPTLE: Record "DO Payment Trans. Log Entry";
        MultiplePayment: Record "Multiple Payment";
        DPCreditCard: Record "DO Payment Credit Card";
        SalesHeader: Record "Sales Header";
        txtBlank: Text;
        decAmount: Decimal;
        txtAmount: Text;
        txtCreditCardNo: Text[20];
        txtExpiryDate: Text[4];
        txtCardCode: Text[4];
        cdSONo: Code[20];
        cdCustCode: Code[20];
        BillToCompanyName: Text[50];
        BillToAddress: Text[100];
        BillToCity: Text[30];
        BillToState: Text[30];
        BillToPostCode: Text[20];
        BillToCountry: Text[10];
        ShipToCompanyName: Text[50];
        ShipToAddress: Text[100];
        ShipToCity: Text[30];
        ShipToState: Text[30];
        ShipToPostCode: Text[20];
        ShipToCountry: Text[10];
        DPCCN: Record "DO Payment Credit Card Number";
        Contact: Record Contact;
    begin
        txtBlank := ' ';
        decAmount := 0;
        txtAmount := '';
        DPTLE.RESET;
        DPTLE.SETRANGE("Entry No.", AuthenticationID);
        IF DPTLE.FINDFIRST THEN BEGIN
            decAmount := DPTLE.Amount;
            txtAmount := DELCHR(FORMAT(decAmount), '=', ',');
        END;

        txtCreditCardNo := '';
        txtExpiryDate := '';
        txtCardCode := '';
        BillToCompanyName := '';
        BillToAddress := '';
        BillToCity := '';
        BillToState := '';
        BillToPostCode := '';
        BillToCountry := '';
        DPCreditCard.RESET;
        DPCreditCard.SETRANGE("No.", DPTLE."Credit Card No.");
        IF DPCreditCard.FINDFIRST THEN BEGIN
            DPCCN.GET(DPCreditCard."No.");
            txtCreditCardNo := DPCCN.GetDataNew(DPCCN);
            txtExpiryDate := DPCreditCard."Expiry Date";
            txtCardCode := DPCreditCard."Cvc No.";
            IF Contact.GET(DPCreditCard."Contact No.") THEN BEGIN
                BillToCompanyName := Contact.Name;
                BillToAddress := Contact.Address;
                BillToCity := Contact.City;
                BillToState := Contact.County;
                BillToPostCode := Contact."Post Code";
                BillToCountry := Contact."Country/Region Code";
            END;
        END;

        cdSONo := '';
        cdCustCode := '';
        ShipToCompanyName := '';
        ShipToAddress := '';
        ShipToCity := '';
        ShipToState := '';
        ShipToPostCode := '';
        ShipToCountry := '';
        SalesHeader.RESET;
        SalesHeader.SETRANGE("Document Type", DPTLE."Document Type"::Order);
        SalesHeader.SETRANGE("No.", DPTLE."Document No.");
        IF SalesHeader.FINDFIRST THEN BEGIN
            cdSONo := SalesHeader."No.";
            cdCustCode := SalesHeader."Bill-to Customer No.";
            ShipToCompanyName := SalesHeader."Ship-to Name";
            ShipToAddress := SalesHeader."Ship-to Address";
            ShipToCity := SalesHeader."Ship-to City";
            ShipToState := SalesHeader."Ship-to County";
            ShipToPostCode := SalesHeader."Ship-to Post Code";
            ShipToCountry := SalesHeader."Ship-to Country/Region Code";
        END;
        Companyinfo.get;
        // IF ISCLEAR(WinHttpService) THEN
        //     CREATE(WinHttpService, FALSE, TRUE);
        //WinHttpService.Open('POST','https://apitest.authorize.net/xml/v1/request.api',0);
        //WinHttpService.Open('POST', 'https://api.authorize.net/xml/v1/request.api', 0);
        //WebClientURL := 'https://apitest.authorize.net/xml/v1/request.api';
        WebClientURL := Companyinfo."Auth Dot Net URL";
        //WebClientURL := 'https://api.authorize.net/xml/v1/request.api';        
        reqText := '{'
            + '"createTransactionRequest": {'
                + '"merchantAuthentication": {'
                    + '"name": "' + Companyinfo.MerchantAuthenticationName + '",' //for testing
                    + '"transactionKey": "' + Companyinfo.MerchantTransactionKey + '"' //for testing
                + '},'
                + '"refId": "' + FORMAT(AuthenticationID) + '",'
                + '"transactionRequest": {'
                    + '"transactionType": "authCaptureTransaction",'
                    + '"amount": "' + txtAmount + '",'
                    + '"payment": {'
                        + '"creditCard": {'
                            + '"cardNumber": "' + txtCreditCardNo + '",'
                            + '"expirationDate": "' + txtExpiryDate + '",'
                            + '"cardCode": "' + txtCardCode + '"'
                        + '}'
                    + '},'
                    + '"poNumber": "' + cdSONo + '",'
                    + '"customer": {'
                        + '"id": "' + cdCustCode + '"'
                    + '},'
                    + '"billTo": {'
                        + '"firstName": "' + txtBlank + '",'
                        + '"lastName": "' + txtBlank + '",'
                        + '"company": "' + BillToCompanyName + '",'
                        + '"address": "' + BillToAddress + '",'
                        + '"city": "' + BillToCity + '",'
                        + '"state": "' + BillToState + '",'
                        + '"zip": "' + BillToPostCode + '",'
                        + '"country": "' + BillToCountry + '"'
                    + '},'
                    + '"shipTo": {'
                        + '"firstName": "' + txtBlank + '",'
                        + '"lastName": "' + txtBlank + '",'
                        + '"company": "' + ShipToCompanyName + '",'
                        + '"address": "' + ShipToAddress + '",'
                        + '"city": "' + ShipToCity + '",'
                        + '"state": "' + ShipToState + '",'
                        + '"zip": "' + ShipToPostCode + '",'
                        + '"country": "' + ShipToCountry + '"'
                    + '},'
                    + '"customerIP": "192.168.1.1",'
                    + '"transactionSettings": {'
                        + '"setting": {'
                            + '"settingName": "testRequest",'
                            + '"settingValue": "false"'
                        + '}'
                    + '},'
                    + '"userFields": {'
                        + '"userField": ['
                            + '{'
                                + '"name": "' + txtBlank + '",'
                                + '"value": "' + txtBlank + '"'
                            + '},'
                            + '{'
                                + '"name": "' + txtBlank + '",'
                                + '"value": "' + txtBlank + '"'
                            + '}'
                        + ']'
                    + '}'
                + '}'
            + '}'
        + '}';

        // Add the payload to the content
        HttpWebContent.WriteFrom(reqText);

        // Retrieve the contentHeaders associated with the content
        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        //RequestMsg.GetHeaders(contentHeaders);
        ContentHeaders.Add('content-type', 'application/json');
        //WinHttpService.SetRequestHeader('content-type', 'application/json');
        RequestMsg.Content := HttpWebContent;
        RequestMsg.SetRequestUri(WebClientURL);
        RequestMsg.Method := 'POST';
        HttpWebClient.Send(RequestMsg, HttpWebResponse);

        //WinHttpService.Send(reqText);
        //MESSAGE(reqText);
        //MESSAGE(WinHttpService.ResponseText);

        // Read the response content as json.
        HttpWebResponse.Content().ReadAs(tempText);
        //tempText := WinHttpService.ResponseText;
        tempText1 := COPYSTR(tempText, STRPOS(tempText, '"transId"'), STRPOS(tempText, '"refTransID"') - STRPOS(tempText, '"transId"'));
        IF COPYSTR(tempText1, 11, 3) <> '"0"' THEN
            TransactioID := COPYSTR(tempText1, 12, 11);

        tempText1 := COPYSTR(tempText, STRPOS(tempText, '"resultCode"'), STRPOS(tempText, '"message"') - STRPOS(tempText, '"resultCode"'));
        IF COPYSTR(tempText1, 14, 4) = '"Ok"' THEN
            ResultCode := COPYSTR(tempText1, 15, 2);

        tempText1 := COPYSTR(tempText, STRPOS(tempText, '"authCode"'), STRPOS(tempText, '"avsResultCode"') - STRPOS(tempText, '"authCode"'));
        IF COPYSTR(tempText1, 12, 2) <> '""' THEN
            AuthCode := COPYSTR(tempText1, 13, 6);

        MESSAGE('TransId is %1, ResultCode %2 and %3 ', TransactioID, ResultCode, AuthCode);


        DPTLE.RESET;
        DPTLE.SETRANGE("Entry No.", AuthenticationID);
        IF DPTLE.FINDFIRST THEN BEGIN
            DPTLE."Transaction ID" := TransactioID;
            DPTLE."Authorization Code" := AuthCode;
            DPTLE.MODIFY;
            IF (ResultCode = 'Ok') AND (AuthCode <> '') THEN BEGIN
                DPTLE.Result := DPTLE.Result::Success;
                DPTLE."Transaction Result" := DPTLE."Transaction Result"::Success;
                DPTLE."Transaction Status" := DPTLE."Transaction Status"::Captured;
                DPTLE.MODIFY;
            END ELSE BEGIN
                DPTLE.Result := DPTLE.Result::Failed;
                DPTLE."Transaction Status" := DPTLE."Transaction Status"::Captured;
                DPTLE."Transaction Result" := DPTLE."Transaction Result"::Failed;
                DPTLE.MODIFY;
            END;
        END;
    end;


    procedure VoidCreditCardJson(AuthenticationID: Integer)
    var
        RequestMsg: HttpRequestMessage;
        ContentHeaders: HttpHeaders;
        HttpWebClient: HttpClient;
        HttpWebContent: HttpContent;
        HttpWebResponse: HttpResponseMessage;
        WebClientURL: Text[250];
        WebString: Text;
        //Xmlhttp: Automation;
        reqText: Text;
        //WinHttpService: Automation;
        //htttpwin: Automation;
        TempString: Text;
        String1: Text;
        String2: Text;
        String3: Text;
        String4: Text;
        String5: Text;
        tempText: Text;
        tempText1: Text;
        StrPos1: Integer;
        TransactioID: Text;
        // CurrentXMLNode: DotNet XmlNode;
        ResultCode: Text;
        AuthCode: Text;
        JsonText: Text;
        //JObject: DotNet JObject;
        DPTLE: Record "DO Payment Trans. Log Entry";
        MultiplePayment: Record "Multiple Payment";
        DPCreditCard: Record "DO Payment Credit Card";
        SalesHeader: Record "Sales Header";
        txtBlank: Text;
        decAmount: Decimal;
        txtCreditCardNo: Text[20];
        txtExpiryDate: Text[4];
        txtCardCode: Text[4];
        cdSONo: Code[20];
        cdCustCode: Code[20];
        BillToCompanyName: Text[50];
        BillToAddress: Text[100];
        BillToCity: Text[30];
        BillToState: Text[30];
        BillToPostCode: Text[20];
        BillToCountry: Text[10];
        ShipToCompanyName: Text[50];
        ShipToAddress: Text[100];
        ShipToCity: Text[30];
        ShipToState: Text[30];
        ShipToPostCode: Text[20];
        ShipToCountry: Text[10];
        DPCCN: Record "DO Payment Credit Card Number";
    begin
        txtBlank := ' ';
        TransactioID := '';
        DPTLE.RESET;
        DPTLE.SETRANGE("Refund No.", AuthenticationID);
        IF DPTLE.FINDFIRST THEN BEGIN
            TransactioID := DPTLE."Transaction ID";
        END;
        Companyinfo.get;
        // IF ISCLEAR(WinHttpService) THEN
        //     CREATE(WinHttpService, FALSE, TRUE);
        //WinHttpService.Open('POST','https://apitest.authorize.net/xml/v1/request.api',0);
        //WinHttpService.Open('POST', 'https://api.authorize.net/xml/v1/request.api', 0);
        //WebClientURL := 'https://apitest.authorize.net/xml/v1/request.api';
        WebClientURL := Companyinfo."Auth Dot Net URL";
        //WebClientURL := 'https://api.authorize.net/xml/v1/request.api';
        //WinHttpService.SetRequestHeader('content-type', 'application/json');
        reqText := '{'
                      + '"createTransactionRequest": {'
                          + '"merchantAuthentication": {'
                              + '"name": "' + Companyinfo.MerchantAuthenticationName + '",' //for testing
                              + '"transactionKey": "' + Companyinfo.MerchantTransactionKey + '"' //for testing
                          + '},'
                          + '"refId": "' + FORMAT(AuthenticationID) + '",'
                          + '"transactionRequest": {'
                              + '"transactionType": "voidTransaction",'
                              + '"refTransId": "' + FORMAT(TransactioID) + '",'
                          + '}'
                      + '}'
                  + '}';

        // Add the payload to the content
        HttpWebContent.WriteFrom(reqText);

        // Retrieve the contentHeaders associated with the content
        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        RequestMsg.GetHeaders(contentHeaders);
        ContentHeaders.Add('content-type', 'application/json');
        //WinHttpService.SetRequestHeader('content-type', 'application/json');
        RequestMsg.Content := HttpWebContent;
        RequestMsg.SetRequestUri(WebClientURL);
        RequestMsg.Method := 'POST';
        HttpWebClient.Send(RequestMsg, HttpWebResponse);

        // WinHttpService.Send(reqText);
        //MESSAGE(reqText);
        //MESSAGE(WinHttpService.ResponseText);
        //tempText := WinHttpService.ResponseText;

        // Read the response content as json.
        HttpWebResponse.Content().ReadAs(tempText);

        tempText1 := SELECTSTR(2, tempText);
        tempText1 := COPYSTR(tempText1, STRPOS(tempText1, '":"') + 3, STRLEN(tempText1) - (STRPOS(tempText1, '":"') + 3));
        AuthCode := tempText1;

        tempText1 := SELECTSTR(6, tempText);
        tempText1 := COPYSTR(tempText1, STRPOS(tempText1, '":"') + 3, STRLEN(tempText1) - (STRPOS(tempText1, '":"') + 3));
        TransactioID := tempText1;

        tempText1 := SELECTSTR(17, tempText);
        tempText1 := COPYSTR(tempText1, STRPOS(tempText1, '":"') + 3, STRLEN(tempText1) - (STRPOS(tempText1, '":"') + 3));
        ResultCode := tempText1;

        MESSAGE('AuthCode is %1, TransactioID %2 and ResultCode %3 ', AuthCode, TransactioID, ResultCode);

        DPTLE.RESET;
        DPTLE.SETRANGE("Refund No.", AuthenticationID);
        IF DPTLE.FINDFIRST THEN BEGIN
            DPTLE."Transaction ID" := TransactioID;
            DPTLE."Authorization Code" := AuthCode;
            DPTLE.MODIFY;
            IF (ResultCode = 'Ok') AND (AuthCode <> '') THEN BEGIN
                DPTLE.Result := DPTLE.Result::Success;
                DPTLE."Transaction Result" := DPTLE."Transaction Result"::Success;
                DPTLE."Transaction Status" := DPTLE."Transaction Status"::Voided;
                DPTLE.MODIFY;
            END ELSE BEGIN
                DPTLE.Result := DPTLE.Result::Failed;
                DPTLE."Transaction Result" := DPTLE."Transaction Result"::Failed;
                DPTLE."Transaction Status" := DPTLE."Transaction Status"::Captured;
                DPTLE.MODIFY;
            END;
        END;
    end;


    procedure RefundCreditCardJson(AuthenticationID: Integer)
    var
        RequestMsg: HttpRequestMessage;
        ContentHeaders: HttpHeaders;
        HttpWebClient: HttpClient;
        HttpWebContent: HttpContent;
        HttpWebResponse: HttpResponseMessage;
        WebClientURL: Text[250];
        WebString: Text;
        //Xmlhttp: Automation;
        reqText: Text;
        //WinHttpService: Automation;
        //htttpwin: Automation;
        TempString: Text;
        String1: Text;
        String2: Text;
        String3: Text;
        String4: Text;
        String5: Text;
        tempText: Text;
        tempText1: Text;
        StrPos1: Integer;
        TransactioID: Text;
        //CurrentXMLNode: DotNet XmlNode;
        ResultCode: Text;
        AuthCode: Text;
        JsonText: Text;
        // JObject: DotNet JObject;
        DPTLE: Record "DO Payment Trans. Log Entry";
        MultiplePayment: Record "Multiple Payment";
        DPCreditCard: Record "DO Payment Credit Card";
        SalesHeader: Record "Sales Header";
        txtBlank: Text;
        decAmount: Decimal;
        txtAmount: Text;
        txtCreditCardNo: Text[20];
        txtExpiryDate: Text[4];
        txtCardCode: Text[4];
        cdSONo: Code[20];
        cdCustCode: Code[20];
        BillToCompanyName: Text[50];
        BillToAddress: Text[100];
        BillToCity: Text[30];
        BillToState: Text[30];
        BillToPostCode: Text[20];
        BillToCountry: Text[10];
        ShipToCompanyName: Text[50];
        ShipToAddress: Text[100];
        ShipToCity: Text[30];
        ShipToState: Text[30];
        ShipToPostCode: Text[20];
        ShipToCountry: Text[10];
        DPCCN: Record "DO Payment Credit Card Number";
    begin
        txtBlank := ' ';
        TransactioID := '';
        decAmount := 0;
        txtAmount := '';
        DPTLE.RESET;
        DPTLE.SETRANGE("Refund No.", AuthenticationID);
        IF DPTLE.FINDFIRST THEN BEGIN
            TransactioID := DPTLE."Transaction ID";
            decAmount := DPTLE.Amount;
            txtAmount := DELCHR(FORMAT(decAmount), '=', ',');
        END;

        txtCreditCardNo := '';
        txtExpiryDate := '';
        DPCreditCard.RESET;
        DPCreditCard.SETRANGE("No.", DPTLE."Credit Card No.");
        IF DPCreditCard.FINDFIRST THEN BEGIN
            DPCCN.GET(DPCreditCard."No.");
            txtCreditCardNo := DPCCN.GetDataNew(DPCCN);
            txtExpiryDate := DPCreditCard."Expiry Date";
        END;
        Companyinfo.get;
        // IF ISCLEAR(WinHttpService) THEN
        //     CREATE(WinHttpService, FALSE, TRUE);
        //WinHttpService.Open('POST','https://apitest.authorize.net/xml/v1/request.api',0);
        //WinHttpService.Open('POST', 'https://api.authorize.net/xml/v1/request.api', 0);
        //WinHttpService.SetRequestHeader('content-type', 'application/json');
        //WebClientURL := 'https://apitest.authorize.net/xml/v1/request.api';
        WebClientURL := Companyinfo."Auth Dot Net URL";
        //WebClientURL := 'https://api.authorize.net/xml/v1/request.api';

        reqText := '{'
                      + '"createTransactionRequest": {'
                          + '"merchantAuthentication": {'
                              + '"name": "' + Companyinfo.MerchantAuthenticationName + '",' //for testing
                              + '"transactionKey": "' + Companyinfo.MerchantTransactionKey + '"' //for testing
                          + '},'
                          + '"refId": "' + FORMAT(AuthenticationID) + '",'
                          + '"transactionRequest": {'
                              + '"transactionType": "refundTransaction",'
                              + '"amount": "' + txtAmount + '",'
                              + '"payment": {'
                                  + '"creditCard": {'
                                      + '"cardNumber": "' + txtCreditCardNo + '",'
                                      + '"expirationDate": "' + txtExpiryDate + '",'
                                  + '}'
                              + '},'
                              + '"refTransId": "' + FORMAT(TransactioID) + '",'
                          + '}'
                      + '}'
                  + '}';

        // Add the payload to the content
        HttpWebContent.WriteFrom(reqText);

        // Retrieve the contentHeaders associated with the content
        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        RequestMsg.GetHeaders(contentHeaders);
        ContentHeaders.Add('content-type', 'application/json');
        //WinHttpService.SetRequestHeader('content-type', 'application/json');
        RequestMsg.Content := HttpWebContent;
        RequestMsg.SetRequestUri(WebClientURL);
        RequestMsg.Method := 'POST';
        HttpWebClient.Send(RequestMsg, HttpWebResponse);

        // Read the response content as json.
        HttpWebResponse.Content().ReadAs(tempText);

        //WinHttpService.Send(reqText);
        //MESSAGE(reqText);
        //MESSAGE(WinHttpService.ResponseText);
        //tempText := WinHttpService.ResponseText;

        tempText1 := SELECTSTR(2, tempText);
        tempText1 := COPYSTR(tempText1, STRPOS(tempText1, '":"') + 3, STRLEN(tempText1) - (STRPOS(tempText1, '":"') + 3));
        AuthCode := tempText1;

        tempText1 := SELECTSTR(6, tempText);
        tempText1 := COPYSTR(tempText1, STRPOS(tempText1, '":"') + 3, STRLEN(tempText1) - (STRPOS(tempText1, '":"') + 3));
        TransactioID := tempText1;

        tempText1 := SELECTSTR(17, tempText);
        tempText1 := COPYSTR(tempText1, STRPOS(tempText1, '":"') + 3, STRLEN(tempText1) - (STRPOS(tempText1, '":"') + 3));
        ResultCode := tempText1;

        MESSAGE('AuthCode is %1, TransactioID %2 and ResultCode %3 ', AuthCode, TransactioID, ResultCode);

        DPTLE.RESET;
        DPTLE.SETRANGE("Entry No.", AuthenticationID);
        IF DPTLE.FINDFIRST THEN BEGIN
            DPTLE."Transaction ID" := TransactioID;
            DPTLE."Authorization Code" := AuthCode;
            IF (ResultCode = 'Ok') AND (AuthCode <> '') THEN BEGIN
                DPTLE.Result := DPTLE.Result::Success;
                DPTLE."Transaction Result" := DPTLE."Transaction Result"::Success;
                DPTLE."Transaction Status" := DPTLE."Transaction Status"::Refunded;
                DPTLE.MODIFY;
            END ELSE BEGIN
                DPTLE.Result := DPTLE.Result::Failed;
                DPTLE."Transaction Result" := DPTLE."Transaction Result"::Failed;
                DPTLE."Transaction Status" := DPTLE."Transaction Status"::Captured;
                DPTLE.MODIFY;
            END;
        END;
    end;


    procedure CaptureCreditCardJson(EntryNo: Integer)
    var
        RequestMsg: HttpRequestMessage;
        ContentHeaders: HttpHeaders;
        HttpWebClient: HttpClient;
        HttpWebContent: HttpContent;
        HttpWebResponse: HttpResponseMessage;
        WebClientURL: Text[250];
        WebString: Text;
        //Xmlhttp: Automation;
        reqText: Text;
        //WinHttpService: Automation;
        //htttpwin: Automation;
        TempString: Text;
        String1: Text;
        String2: Text;
        String3: Text;
        String4: Text;
        String5: Text;
        tempText: Text;
        tempText1: Text;
        StrPos1: Integer;
        TransactioID: Text;
        // CurrentXMLNode: DotNet XmlNode;
        ResultCode: Text;
        AuthCode: Text;
        JsonText: Text;
        //JObject: DotNet JObject;
        DPTLE: Record "DO Payment Trans. Log Entry";
        MultiplePayment: Record "Multiple Payment";
        DPCreditCard: Record "DO Payment Credit Card";
        SalesHeader: Record "Sales Header";
        txtBlank: Text;
        decAmount: Decimal;
        txtCreditCardNo: Text[20];
        txtExpiryDate: Text[4];
        txtCardCode: Text[4];
        cdSONo: Code[20];
        cdCustCode: Code[20];
        BillToCompanyName: Text[50];
        BillToAddress: Text[100];
        BillToCity: Text[30];
        BillToState: Text[30];
        BillToPostCode: Text[20];
        BillToCountry: Text[10];
        ShipToCompanyName: Text[50];
        ShipToAddress: Text[100];
        ShipToCity: Text[30];
        ShipToState: Text[30];
        ShipToPostCode: Text[20];
        ShipToCountry: Text[10];
        DPCCN: Record "DO Payment Credit Card Number";
        Amount: Decimal;
    begin
        txtBlank := ' ';
        TransactioID := '';
        Amount := 0;
        DPTLE.RESET;
        DPTLE.SETRANGE("Entry No.", EntryNo);
        IF DPTLE.FINDFIRST THEN BEGIN
            TransactioID := DPTLE."Transaction ID";
            Amount := DPTLE.Amount;
        END;
        Companyinfo.GET;
        // IF ISCLEAR(WinHttpService) THEN
        //     CREATE(WinHttpService, FALSE, TRUE);
        //WinHttpService.Open('POST', 'https://apitest.authorize.net/xml/v1/request.api', 0);
        //WinHttpService.Open('POST','https://api.authorize.net/xml/v1/request.api',0);
        //WinHttpService.SetRequestHeader('content-type', 'application/json');
        //WebClientURL := 'https://apitest.authorize.net/xml/v1/request.api';
        WebClientURL := Companyinfo."Auth Dot Net URL";
        //WebClientURL := 'https://api.authorize.net/xml/v1/request.api'; //in old system Test API open

        reqText := '{'
                      + '"createTransactionRequest": {'
                          + '"merchantAuthentication": {'
                              + '"name": "' + Companyinfo.MerchantAuthenticationName + '",'
                              + '"transactionKey": "' + Companyinfo.MerchantTransactionKey + '"'
                          + '},'
                          + '"refId": "' + FORMAT(EntryNo) + '",'
                          + '"transactionRequest": {'
                              + '"transactionType": "priorAuthCaptureTransaction",'
                              + '"amount": "' + FORMAT(Amount) + '",'
                              + '"refTransId": "' + FORMAT(TransactioID) + '"'
                          + '}'
                      + '}'
                  + '}';

        // Add the payload to the content
        HttpWebContent.WriteFrom(reqText);

        // Retrieve the contentHeaders associated with the content
        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        RequestMsg.GetHeaders(contentHeaders);
        ContentHeaders.Add('content-type', 'application/json');
        //WinHttpService.SetRequestHeader('content-type', 'application/json');
        RequestMsg.Content := HttpWebContent;
        RequestMsg.SetRequestUri(WebClientURL);
        RequestMsg.Method := 'POST';
        HttpWebClient.Send(RequestMsg, HttpWebResponse);

        // Read the response content as json.
        HttpWebResponse.Content().ReadAs(tempText);

        // WinHttpService.Send(reqText);
        // MESSAGE(reqText);
        // MESSAGE(WinHttpService.ResponseText);
        // tempText := WinHttpService.ResponseText;

        tempText1 := SELECTSTR(2, tempText);
        tempText1 := COPYSTR(tempText1, STRPOS(tempText1, '":"') + 3, STRLEN(tempText1) - (STRPOS(tempText1, '":"') + 3));
        AuthCode := tempText1;

        tempText1 := SELECTSTR(7, tempText);
        tempText1 := COPYSTR(tempText1, STRPOS(tempText1, '":"') + 3, STRLEN(tempText1) - (STRPOS(tempText1, '":"') + 3));
        TransactioID := tempText1;

        tempText1 := SELECTSTR(17, tempText);
        tempText1 := COPYSTR(tempText1, STRPOS(tempText1, '":"') + 3, STRLEN(tempText1) - (STRPOS(tempText1, '":"') + 3));
        ResultCode := tempText1;

        MESSAGE('AuthCode is %1, TransactioID %2 and ResultCode %3 ', AuthCode, TransactioID, ResultCode);

        DPTLE.RESET;
        DPTLE.SETRANGE("Entry No.", EntryNo);
        IF DPTLE.FINDFIRST THEN BEGIN
            DPTLE."Transaction ID" := TransactioID;
            DPTLE."Authorization Code" := AuthCode;
            IF (ResultCode = 'Ok') AND (AuthCode <> '') THEN BEGIN
                DPTLE.Result := DPTLE.Result::Success;
                DPTLE."Transaction Result" := DPTLE."Transaction Result"::Success;
                DPTLE."Transaction Status" := DPTLE."Transaction Status"::Voided;
                DPTLE.MODIFY;
            END ELSE BEGIN
                DPTLE.Result := DPTLE.Result::Failed;
                DPTLE."Transaction Result" := DPTLE."Transaction Result"::Failed;
                DPTLE."Transaction Status" := DPTLE."Transaction Status"::Captured;
                DPTLE.MODIFY;
            END;
        END;
    end;


    procedure ChargeCreditCardJsonHandheld(AuthenticationID: Integer)
    var
        RequestMsg: HttpRequestMessage;
        ContentHeaders: HttpHeaders;
        HttpWebClient: HttpClient;
        HttpWebContent: HttpContent;
        HttpWebResponse: HttpResponseMessage;
        WebClientURL: Text[250];
        WebString: Text;
        //Xmlhttp: Automation;
        reqText: Text;
        // WinHttpService: Automation;
        //htttpwin: Automation;
        TempString: Text;
        String1: Text;
        String2: Text;
        String3: Text;
        String4: Text;
        String5: Text;
        tempText: Text;
        tempText1: Text;
        StrPos1: Integer;
        TransactioID: Text;
        //CurrentXMLNode: DotNet XmlNode;
        ResultCode: Text;
        AuthCode: Text;
        JsonText: Text;
        //JObject: DotNet JObject;
        DPTLE: Record "DO Payment Trans. Log Entry";
        MultiplePayment: Record "Multiple Payment";
        DPCreditCard: Record "DO Payment Credit Card";
        SalesHeader: Record "Sales Header";
        txtBlank: Text;
        decAmount: Decimal;
        txtAmount: Text;
        txtCreditCardNo: Text[20];
        txtExpiryDate: Text[4];
        txtCardCode: Text[4];
        cdSONo: Code[20];
        cdCustCode: Code[20];
        BillToCompanyName: Text[50];
        BillToAddress: Text[100];
        BillToCity: Text[30];
        BillToState: Text[30];
        BillToPostCode: Text[20];
        BillToCountry: Text[10];
        ShipToCompanyName: Text[50];
        ShipToAddress: Text[100];
        ShipToCity: Text[30];
        ShipToState: Text[30];
        ShipToPostCode: Text[20];
        ShipToCountry: Text[10];
        DPCCN: Record "DO Payment Credit Card Number";
        Contact: Record Contact;
    begin
        txtBlank := ' ';
        decAmount := 0;
        txtAmount := '';
        DPTLE.RESET;
        DPTLE.SETRANGE("Entry No.", AuthenticationID);
        IF DPTLE.FINDFIRST THEN BEGIN
            decAmount := DPTLE.Amount;
            txtAmount := DELCHR(FORMAT(decAmount), '=', ',');
        END;

        txtCreditCardNo := '';
        txtExpiryDate := '';
        txtCardCode := '';
        BillToCompanyName := '';
        BillToAddress := '';
        BillToCity := '';
        BillToState := '';
        BillToPostCode := '';
        BillToCountry := '';
        DPCreditCard.RESET;
        DPCreditCard.SETRANGE("No.", DPTLE."Credit Card No.");
        IF DPCreditCard.FINDFIRST THEN BEGIN
            DPCCN.GET(DPCreditCard."No.");
            txtCreditCardNo := DPCCN.GetDataNew(DPCCN);
            txtExpiryDate := DPCreditCard."Expiry Date";
            txtCardCode := DPCreditCard."Cvc No.";
            IF Contact.GET(DPCreditCard."Contact No.") THEN BEGIN
                BillToCompanyName := Contact.Name;
                BillToAddress := Contact.Address;
                BillToCity := Contact.City;
                BillToState := Contact.County;
                BillToPostCode := Contact."Post Code";
                BillToCountry := Contact."Country/Region Code";
            END;
        END;

        cdSONo := '';
        cdCustCode := '';
        ShipToCompanyName := '';
        ShipToAddress := '';
        ShipToCity := '';
        ShipToState := '';
        ShipToPostCode := '';
        ShipToCountry := '';
        SalesHeader.RESET;
        SalesHeader.SETRANGE("Document Type", DPTLE."Document Type"::Order);
        SalesHeader.SETRANGE("No.", DPTLE."Document No.");
        IF SalesHeader.FINDFIRST THEN BEGIN
            cdSONo := SalesHeader."No.";
            cdCustCode := SalesHeader."Bill-to Customer No.";
            ShipToCompanyName := SalesHeader."Ship-to Name";
            ShipToAddress := SalesHeader."Ship-to Address";
            ShipToCity := SalesHeader."Ship-to City";
            ShipToState := SalesHeader."Ship-to County";
            ShipToPostCode := SalesHeader."Ship-to Post Code";
            ShipToCountry := SalesHeader."Ship-to Country/Region Code";
        END;
        Companyinfo.GEt();
        // IF ISCLEAR(WinHttpService) THEN
        //     CREATE(WinHttpService, FALSE, TRUE);
        //WinHttpService.Open('POST', 'https://apitest.authorize.net/xml/v1/request.api', 0);
        //WinHttpService.Open('POST','https://api.authorize.net/xml/v1/request.api',0);
        //WinHttpService.SetRequestHeader('content-type', 'application/json');
        //WebClientURL := 'https://apitest.authorize.net/xml/v1/request.api';
        WebClientURL := Companyinfo."Auth Dot Net URL";
        //WebClientURL := 'https://api.authorize.net/xml/v1/request.api'; //in old system Test API open

        reqText := '{'
            + '"createTransactionRequest": {'
                + '"merchantAuthentication": {'
                    + '"name": "' + Companyinfo.MerchantAuthenticationName + '",'
                    + '"transactionKey": "' + Companyinfo.MerchantTransactionKey + '"'
                + '},'
                + '"refId": "' + FORMAT(AuthenticationID) + '",'
                + '"transactionRequest": {'
                    + '"transactionType": "authCaptureTransaction",'
                    + '"amount": "' + txtAmount + '",'
                    + '"payment": {'
                        + '"creditCard": {'
                            + '"cardNumber": "' + txtCreditCardNo + '",'
                            + '"expirationDate": "' + txtExpiryDate + '",'
                            + '"cardCode": "' + txtCardCode + '"'
                        + '}'
                    + '},'
                    + '"poNumber": "' + cdSONo + '",'
                    + '"customer": {'
                        + '"id": "' + cdCustCode + '"'
                    + '},'
                    + '"billTo": {'
                        + '"firstName": "' + txtBlank + '",'
                        + '"lastName": "' + txtBlank + '",'
                        + '"company": "' + BillToCompanyName + '",'
                        + '"address": "' + BillToAddress + '",'
                        + '"city": "' + BillToCity + '",'
                        + '"state": "' + BillToState + '",'
                        + '"zip": "' + BillToPostCode + '",'
                        + '"country": "' + BillToCountry + '"'
                    + '},'
                    + '"shipTo": {'
                        + '"firstName": "' + txtBlank + '",'
                        + '"lastName": "' + txtBlank + '",'
                        + '"company": "' + ShipToCompanyName + '",'
                        + '"address": "' + ShipToAddress + '",'
                        + '"city": "' + ShipToCity + '",'
                        + '"state": "' + ShipToState + '",'
                        + '"zip": "' + ShipToPostCode + '",'
                        + '"country": "' + ShipToCountry + '"'
                    + '},'
                    + '"customerIP": "192.168.1.1",'
                    + '"transactionSettings": {'
                        + '"setting": {'
                            + '"settingName": "testRequest",'
                            + '"settingValue": "false"'
                        + '}'
                    + '},'
                    + '"userFields": {'
                        + '"userField": ['
                            + '{'
                                + '"name": "' + txtBlank + '",'
                                + '"value": "' + txtBlank + '"'
                            + '},'
                            + '{'
                                + '"name": "' + txtBlank + '",'
                                + '"value": "' + txtBlank + '"'
                            + '}'
                        + ']'
                    + '}'
                + '}'
            + '}'
        + '}';

        // Add the payload to the content
        HttpWebContent.WriteFrom(reqText);

        // Retrieve the contentHeaders associated with the content
        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        RequestMsg.GetHeaders(contentHeaders);
        ContentHeaders.Add('content-type', 'application/json');
        //WinHttpService.SetRequestHeader('content-type', 'application/json');
        RequestMsg.Content := HttpWebContent;
        RequestMsg.SetRequestUri(WebClientURL);
        RequestMsg.Method := 'POST';
        HttpWebClient.Send(RequestMsg, HttpWebResponse);

        // Read the response content as json.
        HttpWebResponse.Content().ReadAs(tempText);
        //WinHttpService.Send(reqText);
        //MESSAGE(reqText);
        //MESSAGE(WinHttpService.ResponseText);
        //tempText := WinHttpService.ResponseText;
        tempText1 := COPYSTR(tempText, STRPOS(tempText, '"transId"'), STRPOS(tempText, '"refTransID"') - STRPOS(tempText, '"transId"'));
        IF COPYSTR(tempText1, 11, 3) <> '"0"' THEN
            TransactioID := COPYSTR(tempText1, 12, 11);

        tempText1 := COPYSTR(tempText, STRPOS(tempText, '"resultCode"'), STRPOS(tempText, '"message"') - STRPOS(tempText, '"resultCode"'));
        IF COPYSTR(tempText1, 14, 4) = '"Ok"' THEN
            ResultCode := COPYSTR(tempText1, 15, 2);

        tempText1 := COPYSTR(tempText, STRPOS(tempText, '"authCode"'), STRPOS(tempText, '"avsResultCode"') - STRPOS(tempText, '"authCode"'));
        IF COPYSTR(tempText1, 12, 2) <> '""' THEN
            AuthCode := COPYSTR(tempText1, 13, 6);

        ///MESSAGE('TransId is %1, ResultCode %2 and %3 ',TransactioID, ResultCode,AuthCode);


        DPTLE.RESET;
        DPTLE.SETRANGE("Entry No.", AuthenticationID);
        IF DPTLE.FINDFIRST THEN BEGIN
            DPTLE."Transaction ID" := TransactioID;
            DPTLE."Authorization Code" := AuthCode;
            DPTLE.MODIFY;
            IF (ResultCode = 'Ok') AND (AuthCode <> '') THEN BEGIN
                DPTLE.Result := DPTLE.Result::Success;
                DPTLE."Transaction Result" := DPTLE."Transaction Result"::Success;
                DPTLE."Transaction Status" := DPTLE."Transaction Status"::Captured;
                DPTLE.MODIFY;
            END ELSE BEGIN
                DPTLE.Result := DPTLE.Result::Failed;
                DPTLE."Transaction Status" := DPTLE."Transaction Status"::Captured;
                DPTLE."Transaction Result" := DPTLE."Transaction Result"::Failed;
                DPTLE.MODIFY;
            END;
        END;
    end;
}

