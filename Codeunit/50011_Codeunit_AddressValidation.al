codeunit 50011 "Address Validation"
{
    TableNo = Customer;

    trigger OnRun()
    begin
        //USAddressValidationJson(Rec);
    end;

    var
        Result: Boolean;
        RequestMsg: HttpRequestMessage;
        ContentHeaders: HttpHeaders;
        HttpWebClient: HttpClient;
        HttpWebContent: HttpContent;
        HttpWebResponse: HttpResponseMessage;
        WebClientURL: Text[250];
        WebString: Text;
        tempText: Text;
        // DotNetXmlHttp: DotNet XMLHTTPRequestClass;
        // DotNetXmlDoc: DotNet DOMDocumentClass;
        // XMLNodeList: DotNet XmlNodeList;
        // DotNetXmlNodeList: DotNet IXMLDOMNodeList;
        // DotNetXmlNode: DotNet IXMLDOMNode;
        // XMLDoc: DotNet XmlDocument;
        XMLNodeList: XmlNodeList;
        XMLDoc: XmlDocument;
        ReturnNode: XmlNode;
        DOMNode: XmlNode;
        TempCust: Record "Address Validation" temporary;
        NodeType: Text;
        NodeName: Text;
        NodeValue: Text;
        textRequest: Text;
        ParentKey: Label '4eMl4PrCTfRqa3Hm';
        ParentPassword: Label 'r97nNKS6b2GB0oL33qddOthaL';
        UserKey: Label '4eMl4PrCTfRqa3Hm';
        UserPassword: Label 'r97nNKS6b2GB0oL33qddOthaL';
        AccountNumber: Label '359071817';
        MeterNumber: Label '251397204';
        XmlText: XmlText;
        xmlNodeListDoc: XmlNodeList;
        Root: XmlElement;
        Records: XmlNodeList;
        Node: XmlNode;
        e: XmlElement;
        fieldnode: XmlNode;
        field: XmlElement;
        Subfield: XmlElement;
        Ref: RecordRef;
        FieldRef: FieldRef;
        NodeList2: XmlNodeList;
        Node2: XmlNode;
        NodeList3: XmlNodeList;
        Node3: XmlNode;
        NodeList4: XmlNodeList;
        Node4: XmlNode;
        NodeList5: XmlNodeList;
        Node5: XmlNode;
        NodeList6: XmlNodeList;
        Node6: XmlNode;
        NodeList7: XmlNodeList;
        Node7: XmlNode;
        compinfo: Record "Company Information";

    procedure USAddressValidationJsonCustomer(var Customer: Record Customer; SalesOrderNo: Code[20])
    var
        tempText: Text;
        tempText1: Text;
        txtBlank: Text;
        City: Text[30];
        StateOrProvinceCode: Text[30];
        PostalCode: Text[20];
        CountryCode: Text[10];
        ContactId: Code[20];
        PersonName: Text[50];
        CompanyName: Text[50];
        PhoneNumber: Text[30];
        EMailAddress: Text[80];
        StreetLines: Text[50];
        UrbanizationCode: Text;
        I: Integer;
        NodeCount: Integer;
    begin
        compinfo.get();
        ContactId := Customer."No."; //'C0000002';
        PersonName := Customer.Contact; //'CONNIE RITSICK';
        CompanyName := Customer.Name; //'RITSICK DESIGN ASSOCIATES';
        PhoneNumber := Customer."Phone No."; //'(703) 286-5555';
        EMailAddress := Customer."E-Mail"; //'critsick@ritsickdesign.com';

        StreetLines := '';
        IF Customer.Address <> '' THEN BEGIN
            StreetLines := Customer.Address;
            IF Customer."Address 2" <> '' THEN
                StreetLines := Customer.Address + ' ' + Customer."Address 2";
        END ELSE
            IF Customer."Address 2" <> '' THEN
                StreetLines := Customer."Address 2";

        City := Customer.City; //'FREDERICK';
        StateOrProvinceCode := Customer.County; //'MD';
        PostalCode := Customer."Post Code"; //'21703';
        UrbanizationCode := '';
        CountryCode := Customer."Country/Region Code"; //'US';
        //DotNetXmlHttp.open('POST', 'https://ws.fedex.com/web-services', 0, 0, 0); //VR

        //WebClientURL := 'https://ws.fedex.com/web-services';
        WebClientURL := compinfo."Address Validation URL";
        textRequest := '<?xml version="1.0" encoding="utf-8"?>' +
        '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v4="http://fedex.com/ws/addressvalidation/v4">' +
           '<soapenv:Header/>' +
           '<soapenv:Body>' +
              '<v4:AddressValidationRequest>' +
                 '<v4:WebAuthenticationDetail>' +
                    '<v4:ParentCredential>' +
                       '<v4:Key>' + ParentKey + '</v4:Key>' +
                       '<v4:Password>' + ParentPassword + '</v4:Password>' +
                    '</v4:ParentCredential>' +
                    '<v4:UserCredential>' +
                       '<v4:Key>' + UserKey + '</v4:Key>' +
                       '<v4:Password>' + UserPassword + '</v4:Password>' +
                    '</v4:UserCredential>' +
                 '</v4:WebAuthenticationDetail>' +
                 '<v4:ClientDetail>' +
                    '<v4:AccountNumber>' + AccountNumber + '</v4:AccountNumber>' +
                    '<v4:MeterNumber>' + MeterNumber + '</v4:MeterNumber>' +
                    '<v4:Localization>' +
                       '<v4:LanguageCode>EN</v4:LanguageCode>' +
                       '<v4:LocaleCode>US</v4:LocaleCode>' +
                    '</v4:Localization>' +
                 '</v4:ClientDetail>' +
                 '<v4:TransactionDetail>' +
                    '<v4:CustomerTransactionId>AddressValidationRequest_v4</v4:CustomerTransactionId>' +
                    '<v4:Localization>' +
                       '<v4:LanguageCode>EN</v4:LanguageCode>' +
                       '<v4:LocaleCode>US</v4:LocaleCode>' +
                    '</v4:Localization>' +
                 '</v4:TransactionDetail>' +
                 '<v4:Version>' +
                    '<v4:ServiceId>aval</v4:ServiceId>' +
                    '<v4:Major>4</v4:Major>' +
                    '<v4:Intermediate>0</v4:Intermediate>' +
                    '<v4:Minor>0</v4:Minor>' +
                 '</v4:Version>' +
                 '<v4:InEffectAsOfTimestamp>2015-03-09T01:21:14+05:30</v4:InEffectAsOfTimestamp>' +
                 '<v4:AddressesToValidate>' +
                    '<v4:ClientReferenceId>ac vinclis et</v4:ClientReferenceId>' +
                    '<v4:Contact>' +
                       '<v4:ContactId>' + ContactId + '</v4:ContactId>' +
                       '<v4:PersonName>' + PersonName + '</v4:PersonName>' +
                       '<v4:CompanyName>' + CompanyName + '</v4:CompanyName>' +
                       '<v4:PhoneNumber>' + PhoneNumber + '</v4:PhoneNumber>' +
                       '<v4:EMailAddress>' + EMailAddress + '</v4:EMailAddress>' +
                    '</v4:Contact>' +
                    '<v4:Address>' +
                       '<v4:StreetLines>' + StreetLines + '</v4:StreetLines>' +
                       '<v4:City>' + City + '</v4:City>' +
                       '<v4:StateOrProvinceCode>' + StateOrProvinceCode + '</v4:StateOrProvinceCode>' +
                       '<v4:PostalCode>' + PostalCode + '</v4:PostalCode>' +
                       '<v4:UrbanizationCode>' + UrbanizationCode + '</v4:UrbanizationCode>' +
                       '<v4:CountryCode>' + CountryCode + '</v4:CountryCode>' +
                       '<v4:Residential>0</v4:Residential>' +
                    '</v4:Address>' +
                 '</v4:AddressesToValidate>' +
              '</v4:AddressValidationRequest>' +
           '</soapenv:Body>' +
        '</soapenv:Envelope>';//);

        //DotNetXmlHttp.send(textRequest); //VR
        // Add the payload to the content
        HttpWebContent.WriteFrom(textRequest);

        // Retrieve the contentHeaders associated with the content
        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        //RequestMsg.GetHeaders(contentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/xml');
        RequestMsg.Content := HttpWebContent;
        RequestMsg.SetRequestUri(WebClientURL);
        RequestMsg.Method := 'POST';
        HttpWebClient.Send(RequestMsg, HttpWebResponse);

        // Read the response content as json.
        HttpWebResponse.Content().ReadAs(tempText);

        //MESSAGE(tempText);
        IF HttpWebResponse.HttpStatusCode = 200 THEN BEGIN
            ///MESSAGE('%1',DotNetXmlHttp.responseText());
            TempCust.DELETEALL;
            TempCust.TRANSFERFIELDS(Customer);
            TempCust.INSERT;
            IF SalesOrderNo <> '' THEN
                TempCust."Sales Order No" := SalesOrderNo;
            TempCust.MODIFY;

            IF XmlDocument.ReadFrom(tempText, XMLDoc) then begin
                XmlDoc.GetRoot(Root);
                NodeList2 := XMLDoc.GetChildNodes();
                // Records := Root.GetChildElements(); //SOAP-ENV:Envelope
                //foreach Node in Records do begin
                foreach Node in NodeList2 do begin
                    e := Node.AsXmlElement();
                    NodeList3 := e.GetChildElements();
                    foreach Node3 in nodelist3 do begin
                        //Message(Node3.AsXmlAttribute().Name);
                        if Node3.AsXmlElement().Name = 'SOAP-ENV:Body' then begin
                            e := Node3.AsXmlElement();
                            NodeList4 := e.GetChildElements();
                            foreach Node4 in nodelist4 do begin
                                if Node4.AsXmlElement().Name = ':AddressValidationReply' then begin
                                    e := Node4.AsXmlElement();
                                    NodeList5 := e.GetChildElements();
                                    foreach node5 in nodelist5 do begin
                                        e := Node5.AsXmlElement();
                                        case e.Name of
                                            ':HighestSeverity':
                                                TempCust.HighestSeverity := e.InnerText;
                                            ':Notifications':
                                                begin
                                                    NodeList6 := e.GetChildElements();
                                                    foreach node6 in nodelist6 do begin
                                                        field := Node6.AsXmlElement();
                                                        case field.Name of
                                                            ':Severity':
                                                                TempCust.Severity := field.InnerText;
                                                            ':Message':
                                                                TempCust.Message := field.InnerText;
                                                        end;
                                                    end;
                                                end;
                                            ':AddressResults':
                                                begin
                                                    NodeList6 := e.GetChildElements();
                                                    foreach node6 in nodelist6 do begin
                                                        field := Node6.AsXmlElement();
                                                        case field.Name of
                                                            ':State':
                                                                TempCust."Address State" := field.InnerText;
                                                            ':Classification':
                                                                TempCust.Classification := field.InnerText;
                                                            ':EffectiveAddress':
                                                                begin
                                                                    NodeList7 := field.GetChildElements();
                                                                    foreach Node7 in nodelist7 do begin
                                                                        Subfield := node7.AsXmlElement();
                                                                        case Subfield.Name of
                                                                            ':StreetLines':
                                                                                TempCust."StreetLines 2" := Subfield.InnerText;
                                                                            ':City':
                                                                                TempCust.City := Subfield.InnerText;
                                                                            ':PostalCode':
                                                                                TempCust.PostalCode := Subfield.InnerText;
                                                                            ':StateOrProvinceCode':
                                                                                TempCust.StateOrProvinceCode := Subfield.InnerText;
                                                                            ':UrbanizationCode':
                                                                                TempCust.UrbanizationCode := Subfield.InnerText;
                                                                            ':CountryCode':
                                                                                TempCust.CountryCode := Subfield.InnerText;
                                                                        end;
                                                                    end;
                                                                end;
                                                            ':Attributes':
                                                                begin
                                                                    case field.InnerText of
                                                                        'DPVtrue':
                                                                            TempCust.DPV := TRUE;
                                                                        'DPVfalse':
                                                                            TempCust.DPV := FALSE;
                                                                        'EncompassingZIPtrue':
                                                                            TempCust.EncompassingZIP := TRUE;
                                                                        'InterpolatedStreetAddresstrue':
                                                                            TempCust.InterpolatedStreetAddress := TRUE;
                                                                        'MultipleMatchestrue':
                                                                            TempCust.MultipleMatches := TRUE;
                                                                        'OrganizationValidatedtrue':
                                                                            TempCust.OrganizationValidated := TRUE;
                                                                        'PostalValidatedtrue':
                                                                            TempCust.PostalValidated := TRUE;
                                                                        'StreetAddresstrue':
                                                                            TempCust.StreetAddress := TRUE;
                                                                        'Resolvedtrue':
                                                                            TempCust.Resolved := TRUE;
                                                                        'EncompassingZIPfalse':
                                                                            TempCust.EncompassingZIP := FALSE;
                                                                        'InterpolatedStreetAddressfalse':
                                                                            TempCust.InterpolatedStreetAddress := FALSE;
                                                                        'MultipleMatchesfalse':
                                                                            TempCust.MultipleMatches := FALSE;
                                                                        'OrganizationValidatedfalse':
                                                                            TempCust.OrganizationValidated := FALSE;
                                                                        'PostalValidatedfalse':
                                                                            TempCust.PostalValidated := FALSE;
                                                                        'StreetAddressfalse':
                                                                            TempCust.StreetAddress := FALSE;
                                                                        'Resolvedfalse':
                                                                            TempCust.Resolved := FALSE;
                                                                    end;
                                                                end;
                                                        end;
                                                    end;
                                                end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
                TempCust.MODIFY;
            END;
            //END;
        END ELSE
            ERROR('Connection Failed. Http Status %1', FORMAT(HttpWebResponse.HttpStatusCode));

        TempCust.RESET;
        IF TempCust.FINDFIRST THEN
            PAGE.RUN(PAGE::"Address Validation", TempCust);
    end;


    procedure USAddressValidationJsonShiptoAdd(var ShiptoAddress: Record "Ship-to Address"; SalesOrderNo: Code[20])
    var
        tempText: Text;
        tempText1: Text;
        txtBlank: Text;
        City: Text[30];
        StateOrProvinceCode: Text[30];
        PostalCode: Text[20];
        CountryCode: Text[10];
        ContactId: Code[20];
        PersonName: Text[50];
        CompanyName: Text[50];
        PhoneNumber: Text[30];
        EMailAddress: Text[80];
        StreetLines: Text[50];
        UrbanizationCode: Text;
        I: Integer;
        NodeCount: Integer;
    begin
        compinfo.get();
        ContactId := ShiptoAddress."Customer No.";
        PersonName := ShiptoAddress.Contact;
        CompanyName := ShiptoAddress.Name;
        PhoneNumber := ShiptoAddress."Phone No.";
        EMailAddress := ShiptoAddress."E-Mail";

        StreetLines := '';
        IF ShiptoAddress.Address <> '' THEN BEGIN
            StreetLines := ShiptoAddress.Address;
            IF ShiptoAddress."Address 2" <> '' THEN
                StreetLines := ShiptoAddress.Address + ' ' + ShiptoAddress."Address 2";
        END ELSE
            IF ShiptoAddress."Address 2" <> '' THEN
                StreetLines := ShiptoAddress."Address 2";

        City := ShiptoAddress.City;
        StateOrProvinceCode := ShiptoAddress.County;
        PostalCode := ShiptoAddress."Post Code";
        UrbanizationCode := '';
        CountryCode := ShiptoAddress."Country/Region Code";

        //DotNetXmlHttp.open('POST', 'https://ws.fedex.com/web-services', 0, 0, 0);
        //WebClientURL := 'https://ws.fedex.com/web-services';
        WebClientURL := compinfo."Address Validation URL";
        textRequest := '<?xml version="1.0" encoding="utf-8"?>' +
        '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v4="http://fedex.com/ws/addressvalidation/v4">' +
           '<soapenv:Header/>' +
           '<soapenv:Body>' +
              '<v4:AddressValidationRequest>' +
                 '<v4:WebAuthenticationDetail>' +
                    '<v4:ParentCredential>' +
                       '<v4:Key>' + ParentKey + '</v4:Key>' +
                       '<v4:Password>' + ParentPassword + '</v4:Password>' +
                    '</v4:ParentCredential>' +
                    '<v4:UserCredential>' +
                       '<v4:Key>' + UserKey + '</v4:Key>' +
                       '<v4:Password>' + UserPassword + '</v4:Password>' +
                    '</v4:UserCredential>' +
                 '</v4:WebAuthenticationDetail>' +
                 '<v4:ClientDetail>' +
                    '<v4:AccountNumber>' + AccountNumber + '</v4:AccountNumber>' +
                    '<v4:MeterNumber>' + MeterNumber + '</v4:MeterNumber>' +
                    '<v4:Localization>' +
                       '<v4:LanguageCode>EN</v4:LanguageCode>' +
                       '<v4:LocaleCode>US</v4:LocaleCode>' +
                    '</v4:Localization>' +
                 '</v4:ClientDetail>' +
                 '<v4:TransactionDetail>' +
                    '<v4:CustomerTransactionId>AddressValidationRequest_v4</v4:CustomerTransactionId>' +
                    '<v4:Localization>' +
                       '<v4:LanguageCode>EN</v4:LanguageCode>' +
                       '<v4:LocaleCode>US</v4:LocaleCode>' +
                    '</v4:Localization>' +
                 '</v4:TransactionDetail>' +
                 '<v4:Version>' +
                    '<v4:ServiceId>aval</v4:ServiceId>' +
                    '<v4:Major>4</v4:Major>' +
                    '<v4:Intermediate>0</v4:Intermediate>' +
                    '<v4:Minor>0</v4:Minor>' +
                 '</v4:Version>' +
                 '<v4:InEffectAsOfTimestamp>2015-03-09T01:21:14+05:30</v4:InEffectAsOfTimestamp>' +
                 '<v4:AddressesToValidate>' +
                    '<v4:ClientReferenceId>ac vinclis et</v4:ClientReferenceId>' +
                    '<v4:Contact>' +
                       '<v4:ContactId>' + ContactId + '</v4:ContactId>' +
                       '<v4:PersonName>' + PersonName + '</v4:PersonName>' +
                       '<v4:CompanyName>' + CompanyName + '</v4:CompanyName>' +
                       '<v4:PhoneNumber>' + PhoneNumber + '</v4:PhoneNumber>' +
                       '<v4:EMailAddress>' + EMailAddress + '</v4:EMailAddress>' +
                    '</v4:Contact>' +
                    '<v4:Address>' +
                       '<v4:StreetLines>' + StreetLines + '</v4:StreetLines>' +
                       '<v4:City>' + City + '</v4:City>' +
                       '<v4:StateOrProvinceCode>' + StateOrProvinceCode + '</v4:StateOrProvinceCode>' +
                       '<v4:PostalCode>' + PostalCode + '</v4:PostalCode>' +
                       '<v4:UrbanizationCode>' + UrbanizationCode + '</v4:UrbanizationCode>' +
                       '<v4:CountryCode>' + CountryCode + '</v4:CountryCode>' +
                       '<v4:Residential>0</v4:Residential>' +
                    '</v4:Address>' +
                 '</v4:AddressesToValidate>' +
              '</v4:AddressValidationRequest>' +
           '</soapenv:Body>' +
        '</soapenv:Envelope>';//);
                              // DotNetXmlHttp.send(textRequest); //VR
                              // Add the payload to the content

        HttpWebContent.WriteFrom(textRequest);

        // Retrieve the contentHeaders associated with the content
        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        //RequestMsg.GetHeaders(contentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/xml');
        RequestMsg.Content := HttpWebContent;
        RequestMsg.SetRequestUri(WebClientURL);
        RequestMsg.Method := 'POST';
        HttpWebClient.Send(RequestMsg, HttpWebResponse);

        // Read the response content as json.
        HttpWebResponse.Content().ReadAs(tempText);

        //MESSAGE('%1',textRequest);

        //IF DotNetXmlHttp.status = 200 THEN BEGIN //VR
        IF HttpWebResponse.HttpStatusCode = 200 THEN BEGIN
            TempCust.DELETEALL;
            TempCust.INIT;
            TempCust."Customer No." := ShiptoAddress."Customer No.";
            TempCust."Ship-To Code" := ShiptoAddress.Code;
            TempCust."Customer Name" := ShiptoAddress.Name;
            TempCust."Customer Name 2" := ShiptoAddress."Name 2";
            TempCust."Customer Address" := ShiptoAddress.Address;
            TempCust."Customer Address 2" := ShiptoAddress."Address 2";
            TempCust."Customer City" := ShiptoAddress.City;
            TempCust."Customer Phone No." := ShiptoAddress."Phone No.";
            TempCust."Customer Country/Region Code" := ShiptoAddress."Country/Region Code";
            TempCust."Customer Post Code" := ShiptoAddress."Post Code";
            TempCust."Customer County" := ShiptoAddress.County;
            TempCust."Customer E-Mail" := ShiptoAddress."E-Mail";
            IF SalesOrderNo <> '' THEN
                TempCust."Sales Order No" := SalesOrderNo;
            //TempCust.TRANSFERFIELDS(ShiptoAddress);
            TempCust.INSERT;

            //DotNetXmlDoc.load(DotNetXmlHttp.responseBody); //VR

            // XMLDoc := XMLDoc.XmlDocument();
            // XMLDoc.LoadXml(DotNetXmlHttp.responseText());

            IF XmlDocument.ReadFrom(tempText, XMLDoc) then begin
                XmlDoc.GetRoot(Root);
                NodeList2 := XMLDoc.GetChildNodes();
                // Records := Root.GetChildElements(); //SOAP-ENV:Envelope
                //foreach Node in Records do begin
                foreach Node in NodeList2 do begin
                    e := Node.AsXmlElement();
                    NodeList3 := e.GetChildElements();
                    foreach Node3 in nodelist3 do begin
                        //Message(Node3.AsXmlAttribute().Name);
                        if Node3.AsXmlElement().Name = 'SOAP-ENV:Body' then begin
                            e := Node3.AsXmlElement();
                            NodeList4 := e.GetChildElements();
                            foreach Node4 in nodelist4 do begin
                                if Node4.AsXmlElement().Name = ':AddressValidationReply' then begin
                                    e := Node4.AsXmlElement();
                                    NodeList5 := e.GetChildElements();
                                    foreach node5 in nodelist5 do begin
                                        e := Node5.AsXmlElement();
                                        case e.Name of
                                            ':HighestSeverity':
                                                TempCust.HighestSeverity := e.InnerText;
                                            ':Notifications':
                                                begin
                                                    NodeList6 := e.GetChildElements();
                                                    foreach node6 in nodelist6 do begin
                                                        field := Node6.AsXmlElement();
                                                        case field.Name of
                                                            ':Severity':
                                                                TempCust.Severity := field.InnerText;
                                                            ':Message':
                                                                TempCust.Message := field.InnerText;
                                                        end;
                                                    end;
                                                end;
                                            ':AddressResults':
                                                begin
                                                    NodeList6 := e.GetChildElements();
                                                    foreach node6 in nodelist6 do begin
                                                        field := Node6.AsXmlElement();
                                                        case field.Name of
                                                            ':State':
                                                                TempCust."Address State" := field.InnerText;
                                                            ':Classification':
                                                                TempCust.Classification := field.InnerText;
                                                            ':EffectiveAddress':
                                                                begin
                                                                    NodeList7 := field.GetChildElements();
                                                                    foreach Node7 in nodelist7 do begin
                                                                        Subfield := node7.AsXmlElement();
                                                                        case Subfield.Name of
                                                                            ':StreetLines':
                                                                                TempCust."StreetLines 2" := Subfield.InnerText;
                                                                            ':City':
                                                                                TempCust.City := Subfield.InnerText;
                                                                            ':PostalCode':
                                                                                TempCust.PostalCode := Subfield.InnerText;
                                                                            ':StateOrProvinceCode':
                                                                                TempCust.StateOrProvinceCode := Subfield.InnerText;
                                                                            ':UrbanizationCode':
                                                                                TempCust.UrbanizationCode := Subfield.InnerText;
                                                                            ':CountryCode':
                                                                                TempCust.CountryCode := Subfield.InnerText;
                                                                        end;
                                                                    end;
                                                                end;
                                                            ':Attributes':
                                                                begin
                                                                    case field.InnerText of
                                                                        'DPVtrue':
                                                                            TempCust.DPV := TRUE;
                                                                        'DPVfalse':
                                                                            TempCust.DPV := FALSE;
                                                                        'EncompassingZIPtrue':
                                                                            TempCust.EncompassingZIP := TRUE;
                                                                        'InterpolatedStreetAddresstrue':
                                                                            TempCust.InterpolatedStreetAddress := TRUE;
                                                                        'MultipleMatchestrue':
                                                                            TempCust.MultipleMatches := TRUE;
                                                                        'OrganizationValidatedtrue':
                                                                            TempCust.OrganizationValidated := TRUE;
                                                                        'PostalValidatedtrue':
                                                                            TempCust.PostalValidated := TRUE;
                                                                        'StreetAddresstrue':
                                                                            TempCust.StreetAddress := TRUE;
                                                                        'Resolvedtrue':
                                                                            TempCust.Resolved := TRUE;
                                                                        'EncompassingZIPfalse':
                                                                            TempCust.EncompassingZIP := FALSE;
                                                                        'InterpolatedStreetAddressfalse':
                                                                            TempCust.InterpolatedStreetAddress := FALSE;
                                                                        'MultipleMatchesfalse':
                                                                            TempCust.MultipleMatches := FALSE;
                                                                        'OrganizationValidatedfalse':
                                                                            TempCust.OrganizationValidated := FALSE;
                                                                        'PostalValidatedfalse':
                                                                            TempCust.PostalValidated := FALSE;
                                                                        'StreetAddressfalse':
                                                                            TempCust.StreetAddress := FALSE;
                                                                        'Resolvedfalse':
                                                                            TempCust.Resolved := FALSE;
                                                                    end;
                                                                end;
                                                        end;
                                                    end;
                                                end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
                TempCust.MODIFY;
            END;
            //END;
        END ELSE
            ERROR('Connection Failed. Http Status %1', FORMAT(HttpWebResponse.HttpStatusCode));

        TempCust.RESET;
        IF TempCust.FINDFIRST THEN
            PAGE.RUN(PAGE::"Address Validation", TempCust);
    end;


    procedure USAddressValidationJsonSalesOrder(var SalesHeader: Record "Sales Header")
    var
        tempText: Text;
        tempText1: Text;
        txtBlank: Text;
        City: Text[30];
        StateOrProvinceCode: Text[30];
        PostalCode: Text[20];
        CountryCode: Text[10];
        ContactId: Code[20];
        PersonName: Text[50];
        CompanyName: Text[50];
        PhoneNumber: Text[30];
        EMailAddress: Text[80];
        StreetLines: Text[50];
        UrbanizationCode: Text;
        I: Integer;
        NodeCount: Integer;
        Customer: Record Customer;
        ShiptoAddress: Record "Ship-to Address";
    begin
        IF SalesHeader."Sell-to Customer No." <> '' THEN BEGIN
            IF Customer.GET(SalesHeader."Sell-to Customer No.") THEN BEGIN
                IF ((Customer."Country/Region Code" = 'US') OR (Customer."Country/Region Code" = 'CA')) AND (NOT Customer.AddressValidated) THEN
                    USAddressValidationJsonCustomer(Customer, SalesHeader."No.");
            END;
        END;

        IF SalesHeader."Ship-to Code" <> '' THEN BEGIN
            IF ShiptoAddress.GET(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code") THEN BEGIN
                IF ((ShiptoAddress."Country/Region Code" = 'US') OR (ShiptoAddress."Country/Region Code" = 'CA')) AND (NOT ShiptoAddress.AddressValidated) THEN
                    USAddressValidationJsonShiptoAdd(ShiptoAddress, SalesHeader."No.");
            END;
        END;
    end;
}

