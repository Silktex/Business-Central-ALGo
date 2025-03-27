codeunit 50015 "TLI Stax Payment Handler"
{
    procedure GeneratePaymentLink(DocumentType: Option " ","Order",Invoice,Payment,Refund; DocumentNo: code[20]): Boolean
    var
        StaxPaymentSetup: Record "TLI Stax Payment Setup";
        StaxPaymentLink: Record "TLI Stax Payment Link";
        SalesHeader: Record "Sales Header";
        SalesInvoice: Record "Sales Invoice Header";
        HttpWebClient: HttpClient;
        HttpWebContent: HttpContent;
        ContentHeaders: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        JArray: JsonArray;
        JChildObj: JsonObject;
        JObject: JsonObject;
        JToken: JsonToken;
        ReqPayload: Text;
        Authoriztion: Text;
        JsonResponse: Text;
        ResponseCode: Text[10];
        ReqAmount: Decimal;
        MemoText: Text[250];
        ConnectionMsg: Label 'The web service returned an error message:\\Status code: %1\Description: %2';
    begin
        StaxPaymentSetup.Get();
        if not StaxPaymentSetup.Enabled then
            exit(false);

        StaxPaymentSetup.TestField("Auth Token / Password");
        StaxPaymentSetup.TestField("Base URL");
        StaxPaymentSetup.TestField("Payment Link API");
        StaxPaymentSetup.TestField("Payment Token");

        Clear(JObject);
        Clear(JChildObj);
        Clear(ReqAmount);
        Clear(MemoText);

        case DocumentType of
            DocumentType::Order:
                begin
                    SalesHeader.get(SalesHeader."Document Type"::Order, DocumentNo);
                    MemoText := 'Advance Payment against Order No. ' + DocumentNo;
                    SalesHeader.CalcFields("Amount Including VAT");
                    ReqAmount := SalesHeader."Amount Including VAT";
                end;
            DocumentType::Invoice:
                begin
                    SalesInvoice.get(DocumentNo);
                    MemoText := 'Payment against Invoice No. ' + DocumentNo;
                    SalesInvoice.CalcFields("Amount Including VAT");
                    ReqAmount := SalesInvoice."Amount Including VAT";
                end;
            else
                Error('Not Applicable.');
        end;

        if ReqAmount = 0 then
            exit(false);

        JObject.Add('url', 'https://app.staxpayments.com/#/pay/' + StaxPaymentSetup."Payment Token");
        JChildObj.Add('total', ReqAmount);
        JChildObj.Add('memo', MemoText);
        JChildObj.Add('isTotalEditable', false);
        JObject.Add('link_meta', JChildObj);
        JObject.Add('common_name', 'Payment Link ' + DocumentNo);
        JObject.Add('amount', ReqAmount);

        JObject.WriteTo(ReqPayload);
        if StrLen(ReqPayload) > 3 then begin
            if GuiAllowed then
                if StaxPaymentSetup."Show Payload" then
                    Message(ReqPayload);

            HttpWebContent.WriteFrom(ReqPayload);
            HttpWebContent.GetHeaders(ContentHeaders);
            ContentHeaders.Clear();
            Authoriztion := 'Bearer ' + StaxPaymentSetup."Auth Token / Password";
            if Authoriztion <> '' then begin
                ContentHeaders.Add('Content-Type', 'application/json');
                HttpWebClient.DefaultRequestHeaders().Add('Authorization', Authoriztion);
                RequestMessage.Content := HttpWebContent;
                RequestMessage.SetRequestUri(StaxPaymentSetup."Base URL" + StaxPaymentSetup."Payment Link API");
                RequestMessage.Method := 'POST';
                HttpWebClient.Send(RequestMessage, ResponseMessage);

                if not ResponseMessage.IsSuccessStatusCode then
                    error(ConnectionMsg,
                          ResponseMessage.HttpStatusCode,
                          ResponseMessage.ReasonPhrase);
                HttpWebContent := ResponseMessage.Content;

                HttpWebContent.ReadAs(JsonResponse);

                //CreateAPILogs('Invoice Details', ReqPayload, JsonResponse);

                Clear(JArray);
                Clear(JObject);
                Clear(JChildObj);

                if GuiAllowed then
                    if StaxPaymentSetup."Show Payload" then
                        Message(JsonResponse);

                JObject.ReadFrom(JsonResponse);
                if JObject.SelectToken('status', JToken) then
                    ResponseCode := JToken.AsValue().AsText();

                if Uppercase(ResponseCode) = '201' then begin
                    StaxPaymentLink.Init();
                    StaxPaymentLink."Document Type" := DocumentType;
                    StaxPaymentLink."Document No." := DocumentNo;
                    StaxPaymentLink.Amount := ReqAmount;
                    StaxPaymentLink."Common Name" := 'Payment Link ' + DocumentNo;
                    if JObject.SelectToken('message', JToken) then
                        StaxPaymentLink.Message := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(StaxPaymentLink.Message));
                    if JObject.SelectToken('body.id', JToken) then
                        StaxPaymentLink."Payment Link Id" := JToken.AsValue().AsText();
                    if JObject.SelectToken('body.tinyurl', JToken) then
                        StaxPaymentLink."Tiny Url" := JToken.AsValue().AsText();
                    StaxPaymentLink.Status := StaxPaymentLink.Status::Generated;
                    if not StaxPaymentLink.Insert() then
                        StaxPaymentLink.Modify();
                    exit(true);
                end else
                    exit(false);

            end else
                Error('Authorization failed.');
        end;

        exit(false);
    end;

    procedure GetPaymentLinkInfo(var StaxPaymentLink: Record "TLI Stax Payment Link"): Boolean
    var
        StaxPaymentSetup: Record "TLI Stax Payment Setup";
        Client: HttpClient;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        RequestHeaders: HttpHeaders;
        ResponseMessage: HttpResponseMessage;
        APIUrl: Text;
        JArray: JsonArray;
        JChildObj: JsonObject;
        JObject: JsonObject;
        JToken: JsonToken;
        Authoriztion: Text;
        JsonResponse: Text;
        ResponseCode: Text[10];
        ReqAmount: Decimal;
        MemoText: Text[250];
        ConnectionMsg: Label 'The web service returned an error message:\\Status code: %1\Description: %2';
        PaidByClientLbl: Label 'Paid by client.', Locked = true;
    begin
        StaxPaymentSetup.Get();
        if not StaxPaymentSetup.Enabled then
            exit(false);

        StaxPaymentSetup.TestField("Auth Token / Password");
        StaxPaymentSetup.TestField("Base URL");
        StaxPaymentSetup.TestField("Payment Link API");
        StaxPaymentSetup.TestField("Payment Token");

        Clear(JObject);
        Clear(JChildObj);
        Clear(ReqAmount);
        Clear(MemoText);

        Authoriztion := 'Bearer ' + StaxPaymentSetup."Auth Token / Password";
        APIUrl := StaxPaymentSetup."Base URL" + StaxPaymentSetup."Payment Link API" + '/' + StaxPaymentLink."Payment Link Id";
        if Authoriztion <> '' then begin
            Content.GetHeaders(ContentHeaders);
            ContentHeaders.Clear();
            ContentHeaders.Add('Content-Type', 'application/json');
            //ContentHeaders.Add('Authorization', Authoriztion);
            Client.DefaultRequestHeaders().Add('Authorization', Authoriztion);
            RequestMessage.GetHeaders(RequestHeaders);
            RequestHeaders.Add('Accept', 'application/json');
            RequestHeaders.Add('Accept-Encoding', 'utf-8');
            RequestHeaders.Add('Connection', 'Keep-alive');

            RequestMessage.SetRequestUri(APIUrl);
            RequestMessage.Method('GET');
            Client.Send(RequestMessage, ResponseMessage);

            if not ResponseMessage.IsSuccessStatusCode then
                error(ConnectionMsg,
                      ResponseMessage.HttpStatusCode,
                      ResponseMessage.ReasonPhrase);
            Content := ResponseMessage.Content;

            Content.ReadAs(JsonResponse);

            //CreateAPILogs('Invoice Details', ReqPayload, JsonResponse);

            Clear(JArray);
            Clear(JObject);
            Clear(JChildObj);

            if GuiAllowed then
                if StaxPaymentSetup."Show Payload" then
                    Message(JsonResponse);

            JObject.ReadFrom(JsonResponse);
            if JObject.SelectToken('data.active', JToken) then
                ResponseCode := Format(JToken.AsValue().AsText());

            if Uppercase(ResponseCode) <> '' then begin
                if ResponseCode = '1' then
                    StaxPaymentLink.Active := true
                else
                    StaxPaymentLink.Active := false;
                if JObject.SelectToken('data.total_sales', JToken) then
                    StaxPaymentLink."Total Sales" := JToken.AsValue().AsDecimal();
                if JObject.SelectToken('data.total_transactions', JToken) then
                    StaxPaymentLink."Total Transactions" := JToken.AsValue().AsDecimal();
                StaxPaymentLink.Modify();
                exit(true);
            end else
                exit(false);

        end else
            Error('Authorization failed.');

        exit(false);
    end;

    procedure PaymentLinkIsEmpty(DocumentType: Option " ","Order",Invoice,Payment,Refund; DocumentNo: code[20]): Boolean
    var
        StaxPaymentLink: Record "TLI Stax Payment Link";
    begin
        StaxPaymentLink.SetRange("Document Type", DocumentType);
        StaxPaymentLink.SetRange("Document No.", DocumentNo);
        exit(StaxPaymentLink.IsEmpty);
    end;
}
