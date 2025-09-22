codeunit 50001 "Integration Fedex UPS"
{
    Permissions = TableData "Sales Shipment Header" = rimd;

    trigger OnRun()
    begin
    end;

    var
        RequestMsg: HttpRequestMessage;
        ContentHeaders: HttpHeaders;
        HttpWebClient: HttpClient;
        HttpWebContent: HttpContent;
        HttpWebResponse: HttpResponseMessage;
        WebClientURL: Text[250];
        WebString: Text;
        tempText: Text;
        //Xmlhttp: Automation;
        Result: Boolean;
        //locautXmlDoc: Automation;
        Result1: Boolean;
        //ResultNode: Automation;
        //DecodeXSLT: Automation;
        //locautXmlDoc1: Automation;
        getAllResponseHeaders: Text;
        Position: Integer;
        Position1: Integer;
        data: Text[1000];
        data1: Text[1000];
        int: Integer;
        text001: Label '10.10.1.39';
        ImportXmlFile: File;
        XmlINStream: InStream;
        // Xmlhttp1: Automation;
        recSH: Record "Sales Header";
        //xmlHttpre: Automation;
        responseStream: Text[250];
        Picture: BigText;
        Picture1: BigText;
        //Bytes: DotNet Array;
        //Convert: DotNet Convert;
        //MemoryStream: DotNet MemoryStream;
        OStream: OutStream;
        text1: Text[30];
        //Stream: Automation;
        //abpAutBytes: DotNet Array;
        //abpAutMemoryStream: DotNet MemoryStream;
        abpOutStream: OutStream;
        //abpAutConvertBase64: DotNet Convert;
        abpRecTempBlob: Codeunit "Temp Blob";
        recCompeny: Record "Company Information";
        recLocation: Record Location;
        recCompanyInfo: Record "Company Information";
        IStream: InStream;
        "Key": Label 'c4LvuJL5jnMaQA2C';
        Password: Label 'GtJhVpwzFs1IczW7a1Rrqoxbi';
        AccountNo2: Label '122898849';
        MeterNo: Label '107459103';
        recItem: Record Item;
        AccountNo: Label '122898849';
        Key1: Label 'K43TcvGLqW7cyltY';
        Password1: Label 'MyLPw6Mk4n2snENVB9Ls9vC9q';
        AccountNo1: Label '510087704';
        MeterNo1: Label '118631944';
        TotalAmount: Decimal;
        TotalAmount1: Text;
        SpecialService: BigText;
        CompanyName: Text[80];
        RateText01: Label 'http://wwwapps.ups.com/ctc/htmlTool?accept_UPS_license_agreement=yes&UPS_HTML_License=7BAF5EAE471A8706&10_action=4&14_origCountry=US&origCity=Syosset&15_origPostal=11791&billToUPS=yes&47_rate_chart=%20Regular%20Daily%20Pickup&';
        txtSignature: Text[30];
        intLen: Integer;
        intCount: Integer;
        txtDeliveryAcceptance: Text[250];
        txtCodAmount: Text[30];
        txtInsurance: Text[250];
        txtInsuredAmount: Text[100];
        decInsuredAmount: Decimal;
        SpecialService1: Text[1000];
        txtInsurance1: Text[1000];
        Pos: Integer;
        Pos1: Integer;
        txtAmountString: Text[1024];
        blnGenerateNote: Boolean;
        webserverIP: Label '192.168.1.228:51212';
        RocketShipIP: Label '192.168.1.228:59999';
        WhseActivLine: Record "Warehouse Activity Line";
        cuNOPPoratal: Codeunit ecomPortal;
        Labelbl: Boolean;
        GrossWeightLB: Decimal;
        GrossWeightOz: Decimal;
        CompInfo: Record "Company Information";

    procedure TrackingRequest(recSalesHeader: Record "Sales Shipment Header")
    begin
        // IF ISCLEAR(Xmlhttp) THEN
        //     Result := CREATE(Xmlhttp, TRUE, TRUE);
        //ELSE
        //Result:=Create(Xmlhttp,TRUE);

        //HttpWebContent.WriteFrom(reqText);
        //Xmlhttp.open('POST', ' https://wsbeta.fedex.com:443/web-services', 0);//'https://wsbeta.fedex.com:443/web-services',0);
        WebClientURL := 'https://wsbeta.fedex.com:443/web-services';


        // Add the payload to the content
        HttpWebContent.WriteFrom('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v6="http://fedex.com/ws/track/v6">' +
           '<soapenv:Header/>' +
           '<soapenv:Body>' +
              '<v6:TrackRequest>' +
                 '<v6:WebAuthenticationDetail>' +
                    '<v6:UserCredential>' +
                       '<v6:Key>' + Key + '</v6:Key>' +
                       '<v6:Password>' + Password + '</v6:Password>' +
                    '</v6:UserCredential>' +
                 '</v6:WebAuthenticationDetail>' +
                 '<v6:ClientDetail>' +
                    '<v6:AccountNumber>' + AccountNo + '</v6:AccountNumber>' +
                    '<v6:MeterNumber>' + MeterNo + '</v6:MeterNumber>' +
                 '</v6:ClientDetail>' +
                 '<v6:TransactionDetail>' +
                    '<v6:CustomerTransactionId>Customer tracking</v6:CustomerTransactionId>' +
                 '</v6:TransactionDetail>' +
                 '<v6:Version>' +
                    '<v6:ServiceId>trck</v6:ServiceId>' +
                    '<v6:Major>6</v6:Major>' +
                    '<v6:Intermediate>0</v6:Intermediate>' +
                    '<v6:Minor>0</v6:Minor>' +
                 '</v6:Version>' +
                 '<v6:CarrierCode>FDXE</v6:CarrierCode>' +
                 '<v6:PackageIdentifier>' +
                    '<v6:Value>' + recSalesHeader."Tracking No." + '</v6:Value>' +
                    '<v6:Type>TRACKING_NUMBER_OR_DOORTAG</v6:Type>' +//TRACKING_NUMBER_OR_DOORTAG
                 '</v6:PackageIdentifier>' +
                 '<v6:IncludeDetailedScans>true</v6:IncludeDetailedScans>' +
                 '</v6:TrackRequest>' +
           '</soapenv:Body>' +
        '</soapenv:Envelope>');

        // Retrieve the contentHeaders associated with the content
        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        RequestMsg.GetHeaders(contentHeaders);
        ContentHeaders.Add('content-type', 'application/xml');
        RequestMsg.Content := HttpWebContent;
        RequestMsg.SetRequestUri(WebClientURL);
        RequestMsg.Method := 'POST';
        HttpWebClient.Send(RequestMsg, HttpWebResponse);

        // IF ISCLEAR(locautXmlDoc1) THEN
        //     Result1 := CREATE(locautXmlDoc1, TRUE, TRUE);

        // Read the response content as json.        
        HttpWebResponse.Content().ReadAs(tempText);
        Position := STRPOS(tempText, '<Severity>');
        // locautXmlDoc1.load(Xmlhttp.responseXML);
        // Position := STRPOS(Xmlhttp.responseText(), '<Severity>');
        //ResultNode := locautXmlDoc.selectNodes('soapenv:Envelope');
        Position := Position + 10;
        //Position1 := STRPOS(Xmlhttp.responseText(), '</Severity>');
        //getAllResponseHeaders := COPYSTR(Xmlhttp.responseText(), Position, Position1 - Position);
        Position1 := STRPOS(tempText, '</Severity>');
        getAllResponseHeaders := COPYSTR(tempText, Position, Position1 - Position);
        //locautXmlDoc1.save('C:\Users\Admin\Desktop\FXO_Advanced_cs\TrackingResponse.xml');
        //MESSAGE('%1', Xmlhttp.responseText());
        //MESSAGE('%1', tempText);
        recSalesHeader."Tracking Status" := getAllResponseHeaders;
        recSalesHeader.MODIFY(FALSE);
    end;

    procedure UPSRequest(recWhsShipHeader: Record "Warehouse Shipment Header")
    var
        UPSUSERNAME: Label 'silktex';
        UPSPASSWORD: Label 'Crafts12';
        UPSLICENCE: Label 'ACE923D1E3142AC6';
        CustNo: Code[20];
        recSalesHeader: Record "Sales Header";
        recWhseShipLine: Record "Warehouse Shipment Line";
        ReturnString: BigText;
        recSalesLine: Record "Sales Line";
        txtInsurance: Text[10];
        txtCOD: Text[10];
        TotalAmount: Decimal;
    begin
        //VR code not in use 

        // CLEAR(Xmlhttp);
        // IF ISCLEAR(Xmlhttp) THEN
        //     Result := CREATE(Xmlhttp, TRUE, TRUE);
        // //ELSE
        // //Result:=Create(Xmlhttp,TRUE);
        // Position := 0;
        // TotalAmount := 0;
        // TotalAmount := 0;
        // recWhseShipLine.RESET;
        // recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
        // recWhseShipLine.SETFILTER("Qty. to Ship", '<>%1', 0);
        // recWhseShipLine.SETRANGE("Source Type", 37);
        // recWhseShipLine.SETRANGE("Source Subtype", 1);
        // IF recWhseShipLine.FIND('-') THEN BEGIN
        //     REPEAT
        //         //recItem.GET(recWhseShipLine."Item No.");
        //         //decNetWeigh:=decNetWeigh+recWhseShipLine."Qty. to Ship"*recItem.Weight;
        //         //intNo+=1;
        //         recSalesLine.RESET;
        //         recSalesLine.SETRANGE("Document No.", recWhseShipLine."Source No.");
        //         recSalesLine.SETRANGE("Line No.", recWhseShipLine."Source Line No.");
        //         //recSalesLine.SETRANGE("Source Type",37);
        //         //recSalesLine.SETRANGE("Source Subtype",1);

        //         IF recSalesLine.FIND('-') THEN BEGIN
        //             REPEAT
        //                 TotalAmount := TotalAmount + recWhseShipLine."Qty. to Ship" * recSalesLine."Unit Price";
        //             //IF TotalAmount > 1000
        //             //THEN
        //             //recWhsShipHeader."Insurance Amount" := TotalAmount;
        //             UNTIL recSalesLine.NEXT = 0;
        //         END;
        //     UNTIL recWhseShipLine.NEXT = 0;
        // END;
        // IF recWhsShipHeader."Insurance Amount" <> 0 THEN
        //     txtInsurance := 'Yes'
        // ELSE
        //     txtInsurance := 'No';


        // IF recWhsShipHeader."Cash On Delivery" THEN
        //     txtCOD := 'Yes'
        // ELSE
        //     txtCOD := 'No';
        // IF recWhsShipHeader."Signature Required" THEN
        //     txtSignature := 'Yes'
        // ELSE
        //     txtSignature := 'No';
        // recWhseShipLine.RESET;
        // recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
        // IF recWhseShipLine.FIND('-') THEN;
        // recSalesHeader.RESET;
        // IF recSalesHeader.GET(recWhseShipLine."Source Subtype", recWhseShipLine."Source No.") THEN;
        // //recCompanyInfo.GET;
        // //IF recSalesHeader."Ship-to Code"<>'' THEN BEGIN
        // CustNo := recSalesHeader."Sell-to Customer No.";
        // TotalAmount1 := FORMAT(recWhsShipHeader."Insurance Amount");
        // TotalAmount1 := DELCHR(TotalAmount1, '=', ',');
        // txtCodAmount := FORMAT(TotalAmount);
        // IF recWhsShipHeader."COD Amount" <> 0 THEN
        //     txtCodAmount := FORMAT(recWhsShipHeader."COD Amount");

        // txtCodAmount := DELCHR(txtCodAmount, '=', ',');

        // /*MESSAGE('http://'+webserverIP+'/UPSShipping.ashx?Action=SaveShipping&userName=%1 &password=%2 &licenseNo=%3'+
        // '&wSNo=%4&custNo=%5'+
        // '&Insu=%6&InsuAmount=%7&COD=%8'+
        // '&CODAmount=%9&ServiceCode=%10'+
        // '&Signature=%11',UPSUSERNAME,UPSPASSWORD,UPSLICENCE,recWhsShipHeader."No.",CustNo,txtInsurance,FORMAT(recWhsShipHeader."Insurance Amount"),txtCOD,FORMAT(TotalAmount),recWhsShipHeader."Shipping Agent Service Code");//,txtSignature);
        // */
        // Xmlhttp.open('POST', 'http://' + webserverIP + '/UPSShipping.ashx?Action=SaveShipping&userName=' + UPSUSERNAME + '&password=' + UPSPASSWORD + '&licenseNo=' + UPSLICENCE + '&wSNo=' + recWhsShipHeader."No." + '&custNo=' + CustNo +
        // '&Insu=' + txtInsurance + '&InsuAmount=' + TotalAmount1 + '&COD=' + txtCOD + '&CODAmount=' + txtCodAmount + '&ServiceCode=' + recWhsShipHeader."Shipping Agent Service Code" + '&Signature=' + txtSignature, 0);
        // //'https://wsbeta.fedex.com:443/web-services',0);
        // Xmlhttp.send('');
        // MESSAGE('%1', Xmlhttp.responseText);
        // CLEAR(ReturnString);
        // ReturnString.ADDTEXT(Xmlhttp.responseText);

        // Position := STRPOS(Xmlhttp.responseText(), 'created successfully:');
        // IF Position = 0 THEN
        //     MESSAGE('%1', Xmlhttp.responseText)
        // ELSE
        //     MESSAGE('Shipment created Successfully');

    end;


    procedure UPSTracking(WhseCode: Code[20]; TrackingNo: Text[30]; Image: BigText)
    var
        recTrackingNo: Record "Tracking No.";
        Tempblob: Codeunit "Temp Blob";
    begin

        recTrackingNo.RESET;
        recTrackingNo.SETRANGE(recTrackingNo."Warehouse Shipment No", WhseCode);
        recTrackingNo.SETRANGE("Tracking No.", TrackingNo);
        IF NOT recTrackingNo.FIND('-') THEN BEGIN
            recTrackingNo.INIT;
            recTrackingNo."Warehouse Shipment No" := WhseCode;
            recTrackingNo."Tracking No." := TrackingNo;
            // Bytes := Convert.FromBase64String(Image);
            // MemoryStream := MemoryStream.MemoryStream(Bytes);
            // recTrackingNo.Image.CREATEOUTSTREAM(OStream);
            // MemoryStream.WriteTo(OStream);
            recTrackingNo.Image.CreateOutStream(OStream);
            Image.Write(OStream);
            recTrackingNo.INSERT;
        END;
    end;

    procedure EndiciaRequest(recWhsShipHeader: Record "Warehouse Shipment Header"; cdPickingNo: Code[20])
    var
        UPSUSERNAME: Label 'silktex';
        UPSPASSWORD: Label 'Crafts12';
        UPSLICENCE: Label 'ACE923D1E3142AC6';
        CustNo: Code[20];
        recSalesHeader: Record "Sales Header";
        recWhseShipLine: Record "Warehouse Shipment Line";
        ReturnString: BigText;
        recSalesLine: Record "Sales Line";
        txtInsurance: Text[10];
        txtCOD: Text[10];
        TotalAmount: Decimal;
        IsDomestic: Boolean;
    begin
        //VR code not in use
        // CLEAR(Xmlhttp);
        // IF ISCLEAR(Xmlhttp) THEN
        //     Result := CREATE(Xmlhttp, TRUE, TRUE);
        // //ELSE
        // //Result:=Create(Xmlhttp,TRUE);
        // Position := 0;
        // TotalAmount := 0;
        // TotalAmount := 0;
        // recWhseShipLine.RESET;
        // recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
        // recWhseShipLine.SETFILTER("Qty. to Ship", '<>%1', 0);
        // recWhseShipLine.SETRANGE("Source Type", 37);
        // recWhseShipLine.SETRANGE("Source Subtype", 1);
        // IF recWhseShipLine.FIND('-') THEN BEGIN
        //     REPEAT
        //         //recItem.GET(recWhseShipLine."Item No.");
        //         //decNetWeigh:=decNetWeigh+recWhseShipLine."Qty. to Ship"*recItem.Weight;
        //         //intNo+=1;
        //         recSalesLine.RESET;
        //         recSalesLine.SETRANGE("Document No.", recWhseShipLine."Source No.");
        //         recSalesLine.SETRANGE("Line No.", recWhseShipLine."Source Line No.");
        //         //recSalesLine.SETRANGE("Source Type",37);
        //         //recSalesLine.SETRANGE("Source Subtype",1);

        //         IF recSalesLine.FIND('-') THEN BEGIN
        //             REPEAT
        //                 TotalAmount := TotalAmount + recWhseShipLine."Qty. to Ship" * recSalesLine."Unit Price";
        //             //IF TotalAmount > 1000
        //             //THEN
        //             //recWhsShipHeader."Insurance Amount" := TotalAmount;
        //             UNTIL recSalesLine.NEXT = 0;
        //         END;
        //     UNTIL recWhseShipLine.NEXT = 0;
        // END;
        // IF recWhsShipHeader."Insurance Amount" <> 0 THEN
        //     txtInsurance := 'Yes'
        // ELSE
        //     txtInsurance := 'No';


        // IF recWhsShipHeader."Cash On Delivery" THEN
        //     txtCOD := 'Yes'
        // ELSE
        //     txtCOD := 'No';
        // IF recWhsShipHeader."Signature Required" THEN
        //     txtSignature := 'Yes'
        // ELSE
        //     txtSignature := 'No';
        // recWhseShipLine.RESET;
        // recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
        // IF recWhseShipLine.FIND('-') THEN;
        // recSalesHeader.RESET;
        // IF recSalesHeader.GET(recWhseShipLine."Source Subtype", recWhseShipLine."Source No.") THEN;
        // //recCompanyInfo.GET;
        // //IF recSalesHeader."Ship-to Code"<>'' THEN BEGIN
        // CustNo := recSalesHeader."Sell-to Customer No.";
        // TotalAmount1 := FORMAT(recWhsShipHeader."Insurance Amount");
        // TotalAmount1 := DELCHR(TotalAmount1, '=', ',');
        // txtCodAmount := FORMAT(TotalAmount);
        // IF recWhsShipHeader."COD Amount" <> 0 THEN
        //     txtCodAmount := FORMAT(recWhsShipHeader."COD Amount");

        // txtCodAmount := DELCHR(txtCodAmount, '=', ',');

        // /*MESSAGE('http://'+webserverIP+'/UPSShipping.ashx?Action=SaveShipping&userName=%1 &password=%2 &licenseNo=%3'+
        // '&wSNo=%4&custNo=%5'+
        // '&Insu=%6&InsuAmount=%7&COD=%8'+
        // '&CODAmount=%9&ServiceCode=%10'+
        // '&Signature=%11',UPSUSERNAME,UPSPASSWORD,UPSLICENCE,recWhsShipHeader."No.",CustNo,txtInsurance,FORMAT(recWhsShipHeader."Insurance Amount"),txtCOD,FORMAT(TotalAmount),recWhsShipHeader."Shipping Agent Service Code");//,txtSignature);
        // */
        // //Xmlhttp.open('POST','http://'+webserverIP+'/UPSShipping.ashx?Action=SaveShipping&userName='+UPSUSERNAME+'&password='+UPSPASSWORD+'&licenseNo='+UPSLICENCE+'&wSNo='+recWhsShipHeader."No."+'&custNo='+CustNo+
        // //'&Insu='+txtInsurance+'&InsuAmount='+TotalAmount1+'&COD='+txtCOD+'&CODAmount='+txtCodAmount+'&ServiceCode='+recWhsShipHeader."Shipping Agent Service Code"+'&Signature='+txtSignature,0);
        // //'https://wsbeta.fedex.com:443/web-services',0);
        // //ENDINT1.0
        // IF recWhsShipHeader."Label Type" = recWhsShipHeader."Label Type"::Domestic THEN BEGIN
        //     Xmlhttp.open('POST', 'http://silk4:47471/EndeciaHandler.ashx?Action=SaveShipping&COD=' + txtCOD + '&CODAmount=' + txtCodAmount + '&wSNo=' + recWhsShipHeader."No." + '&Insu=' + txtInsurance + '&InsuAmount=' + TotalAmount1 +
        //       '&custNo=' + CustNo + '&AdultSign=' + txtSignature + '&MailClass=' + recWhsShipHeader."Shipping Agent Service Code", 0);

        // END ELSE
        //     IF recWhsShipHeader."Label Type" = recWhsShipHeader."Label Type"::International THEN BEGIN
        //         Xmlhttp.open('POST', 'http://silk4:54444/EndeciaInternational.ashx?Action=SaveShipping&COD=' + txtCOD + '&CODAmount=' + txtCodAmount + '&wSNo=' + recWhsShipHeader."No." + '&Insu=' + txtInsurance + '&InsuAmount=' + TotalAmount1 +
        //           '&custNo=' + CustNo + '&AdultSign=' + txtSignature + '&MailClass=' + recWhsShipHeader."Shipping Agent Service Code" + '&packNo=' + cdPickingNo);
        //     END;
        // //ENDINT1.0
        // Xmlhttp.send('');
        // MESSAGE('%1', Xmlhttp.responseText);
        // CLEAR(ReturnString);
        // ReturnString.ADDTEXT(Xmlhttp.responseText);

        // Position := STRPOS(Xmlhttp.responseText(), 'created successfully:');
        // IF Position = 0 THEN
        //     MESSAGE('%1', Xmlhttp.responseText)
        // ELSE
        //     MESSAGE('Shipment created Successfully');

    end;

    procedure StandardOverNight(recWhsShipHeader: Record "Warehouse Shipment Header")
    var
        recCustomer: Record Customer;
        txtPaymentType: Text[30];
        ResponsibleCountry: Code[10];
        ResponsiblePost: Code[20];
        ResponsibleState: Code[20];
        ResponsibleCity: Code[20];
        ResponsibleAddress: Text[50];
        ResponsiblePhone: Text[30];
        ResponsibleCompany: Text[50];
        ResponsibleEmail: Text[50];
        ResponsiblePerson: Text[50];
        ResponsibleAccNo: Text[30];
        decNetWeigh: Decimal;
        recSalesLine: Record "Sales Line";
        decAmount: Decimal;
        txtAmount: Text[25];
        recSalesHeader: Record "Sales Header";
        recWhseShipLine: Record "Warehouse Shipment Line";
        recBoxMaster: Record "Box Master";
        txtPackageDetail: BigText;
        intNo: Integer;
        txtPackagedet: array[5] of Text[1000];
        intLength: Integer;
        SalesRelease: Codeunit "Release Sales Document";
        txtMessage: Text[500];
        txtYear: Text[10];
        txtMonth: Text[10];
        txtDate: Text[10];
        intDate: Integer;
        intMonth: Integer;
        intYear: Integer;
        recShipAgentService: Record "Shipping Agent Services";
        txtShipService: Text[100];
        recShiptoAddress: Record "Ship-to Address";
        ShiptoName: Text[50];
        ShiptoAddress: Text[50];
        ShiptoAddress2: Text[50];
        ShiptoEmail: Text[50];
        ShiptoPhone: Text[30];
        ShiptoState: Text[30];
        ShiptoCountry: Text[30];
        ShiptoPostCode: Text[30];
        ShiptoContact: Text[50];
        ShiptoAccount: Code[20];
        ShiptoCity: Text[30];
        txtShipTime: Text[50];
        intLineNo: Integer;
        recSalesShipHeader: Record "Sales Shipment Header";
        WhseSetup: Record "Warehouse Setup";
        SpecialServiceTxt: array[10] of Text[1000];
        outFile: File;
        outStream1: OutStream;
        // streamWriter: DotNet StreamWriter;
        //encoding: DotNet Encoding;
        recTrackingNo: Record "Tracking No.";
        ShiptoResidential: Text[5];
        BodyText: Text;
        Base64Convert: Codeunit "Base64 Convert";
        ResponseText: Text;
        Compinfo: Record "Company Information";
    begin
        //recSalesHeader:=SalesHeader;
        //recSalesHeader;
        Compinfo.get();
        IF recWhsShipHeader."Track On Header" THEN BEGIN
            recWhseShipLine.RESET;
            recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
            IF recWhseShipLine.FIND('-') THEN;
            intDate := DATE2DMY(recWhsShipHeader."Shipment Date", 1);
            intMonth := DATE2DMY(recWhsShipHeader."Shipment Date", 2);
            intYear := DATE2DMY(recWhsShipHeader."Shipment Date", 3);
            txtDate := FORMAT(intDate);
            txtMonth := FORMAT(intMonth);
            txtYear := FORMAT(intYear);
            IF intYear < 100 THEN
                txtYear := '20' + txtYear;
            IF STRLEN(txtMonth) < 2 THEN
                txtMonth := '0' + txtMonth;
            IF STRLEN(txtDate) < 2 THEN
                txtDate := '0' + txtDate;
            recSalesHeader.RESET;
            IF recSalesHeader.GET(recWhseShipLine."Source Subtype", recWhseShipLine."Source No.") THEN;
            recLocation.GET(recSalesHeader."Location Code");
            recCompanyInfo.GET;
            IF recSalesHeader."Ship-to Code" <> '' THEN BEGIN

                recCustomer.GET(recSalesHeader."Sell-to Customer No.");
                recShiptoAddress.GET(recSalesHeader."Sell-to Customer No.", recSalesHeader."Ship-to Code");
                ShiptoName := recShiptoAddress.Name;
                ShiptoAddress := recShiptoAddress.Address;
                ShiptoAddress2 := recShiptoAddress."Address 2";
                ShiptoCity := recShiptoAddress.City;
                ShiptoState := recShiptoAddress.County;
                ShiptoAccount := recShiptoAddress."Shipping Account No.";
                IF ShiptoAccount = '' THEN
                    ShiptoAccount := recCustomer."Shipping Account No.";
                IF recShiptoAddress."Third Party" THEN
                    txtPaymentType := 'THIRD_PARTY';
                ShiptoPostCode := recShiptoAddress."Post Code";

                ShiptoCountry := recShiptoAddress."Country/Region Code";
                ShiptoEmail := recShiptoAddress."E-Mail";
                ShiptoContact := recShiptoAddress.Contact;
                ShiptoPhone := recShiptoAddress."Phone No.";
                ShiptoResidential := 'false';
                IF recShiptoAddress.Residential THEN
                    ShiptoResidential := 'true';
            END ELSE BEGIN
                recCustomer.GET(recSalesHeader."Sell-to Customer No.");
                ShiptoName := recCustomer.Name;
                ShiptoAddress := recCustomer.Address;
                ShiptoAddress2 := recCustomer."Address 2";
                ShiptoCity := recCustomer.City;
                ShiptoState := recCustomer.County;
                ShiptoAccount := recCustomer."Shipping Account No.";
                ShiptoPostCode := recCustomer."Post Code";

                ShiptoCountry := recCustomer."Country/Region Code";
                ShiptoEmail := recCustomer."E-Mail";
                ShiptoContact := recCustomer.Contact;
                ShiptoPhone := recCustomer."Phone No.";
                ShiptoResidential := 'false';
                IF recCustomer.Residential THEN
                    ShiptoResidential := 'true';
            END;
            ShiptoName := AttributetoString(ShiptoName);
            ShiptoAddress := AttributetoString(ShiptoAddress);
            ShiptoAddress2 := AttributetoString(ShiptoAddress2);
            ShiptoEmail := AttributetoString(ShiptoEmail);
            ShiptoContact := AttributetoString(ShiptoContact);
            ShiptoAccount := AttributetoString(ShiptoAccount);

            CLEAR(txtPackageDetail);
            recShipAgentService.GET(recWhsShipHeader."Shipping Agent Code", recWhsShipHeader."Shipping Agent Service Code");
            txtShipService := recShipAgentService.Description;
            recBoxMaster.RESET;
            IF recBoxMaster.GET(recWhsShipHeader."Box Code") THEN;

            decNetWeigh := 0;
            intNo := 0;
            TotalAmount := 0;
            recWhseShipLine.RESET;
            recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
            recWhseShipLine.SETFILTER("Qty. to Ship", '<>%1', 0);
            IF recWhseShipLine.FIND('-') THEN BEGIN
                REPEAT
                    recItem.GET(recWhseShipLine."Item No.");
                    decNetWeigh := decNetWeigh + recWhseShipLine."Qty. to Ship" * recItem.Weight;
                    intNo += 1;
                    recSalesLine.RESET;
                    recSalesLine.SETRANGE("Document No.", recWhseShipLine."Source No.");
                    recSalesLine.SETRANGE("Line No.", recWhseShipLine."Source Line No.");

                    IF recSalesLine.FIND('-') THEN BEGIN
                        REPEAT
                            TotalAmount := TotalAmount + recWhseShipLine."Qty. to Ship" * recSalesLine."Unit Price";

                        UNTIL recSalesLine.NEXT = 0;
                    END;
                UNTIL recWhseShipLine.NEXT = 0;
            END;
            TotalAmount1 := '';

            TotalAmount1 := FORMAT(TotalAmount);
            IF recWhsShipHeader."COD Amount" <> 0 THEN
                TotalAmount1 := FORMAT(recWhsShipHeader."COD Amount");
            TotalAmount1 := DELCHR(TotalAmount1, '=', ',');



            IF recWhsShipHeader."Cash On Delivery" THEN BEGIN
                IF recWhsShipHeader."Signature Required" THEN
                    txtDeliveryAcceptance := 'DELIVERY_ON_INVOICE_ACCEPTANCE'
                ELSE
                    txtDeliveryAcceptance := '';
                CLEAR(SpecialService);
                SpecialService1 := '';
                IF recWhsShipHeader."Signature Required" THEN BEGIN
                    SpecialService.ADDTEXT('<SpecialServicesRequested>' +
                    '<SpecialServiceTypes>COD</SpecialServiceTypes>' +
                    '<SpecialServiceTypes>DELIVERY_ON_INVOICE_ACCEPTANCE</SpecialServiceTypes>' +
                    '<CodDetail>' +
                    '<CodCollectionAmount>' +
                    '<Currency>USD</Currency>' +
                    '<Amount>' + TotalAmount1 + '</Amount>' +
                    '</CodCollectionAmount>' +
                    '<CollectionType>ANY</CollectionType>' +
                    '<FinancialInstitutionContactAndAddress>' +
                    '<Contact>' +
                    '<PersonName>' + ShiptoContact + '</PersonName>' +
                    '<CompanyName>' + ShiptoName + '</CompanyName>' +
                    '<PhoneNumber>' + ShiptoPhone + '</PhoneNumber>' +
                    '</Contact>' +
                    '<Address>' +
                    '<StreetLines>' + ShiptoAddress + ' ' + ShiptoAddress2 + '</StreetLines>' +
                    '<City>' + ShiptoCity + '</City>' +
                    '<StateOrProvinceCode>' + ShiptoState + '</StateOrProvinceCode>' +
                    '<PostalCode>' + ShiptoPostCode + '</PostalCode>' +
                    '<CountryCode>' + ShiptoCountry + '</CountryCode>' +
                    '<Residential>' + ShiptoResidential + '</Residential>' +
                    '</Address>' +
                    '</FinancialInstitutionContactAndAddress>' +
                    '<RemitToName>' + ShiptoContact + '</RemitToName>' +
                    '</CodDetail>' +
                    '<DeliveryOnInvoiceAcceptanceDetail>' +
                    '<Recipient>' +
                    '<AccountNumber>' + ShiptoAccount + '</AccountNumber>' +
                    '<Contact>' +
                    '<PersonName>' + ShiptoContact + '</PersonName>' +
                    '<CompanyName>' + COMPANYNAME + '</CompanyName>' +
                    '<PhoneNumber>' + ShiptoPhone + '</PhoneNumber>' +
                    '</Contact>' +
                    '<Address>' +
                    '<StreetLines>' + ShiptoAddress + ' ' + ShiptoAddress2 + '</StreetLines>' +
                    '<City>' + ShiptoCity + '</City>' +
                    '<StateOrProvinceCode>' + ShiptoState + '</StateOrProvinceCode>' +
                    '<PostalCode>' + ShiptoPostCode + '</PostalCode>' +
                    '<CountryCode>' + ShiptoCountry + '</CountryCode>' +
                    '<Residential>' + ShiptoResidential + '</Residential>' +
                    '</Address>' +
                    '</Recipient>' +
                    '</DeliveryOnInvoiceAcceptanceDetail>' +
                    '</SpecialServicesRequested>');
                END ELSE BEGIN
                    SpecialService.ADDTEXT('<SpecialServicesRequested>' +
                    '<SpecialServiceTypes>COD</SpecialServiceTypes>' +
                    '<CodDetail>' +
                    '<CodCollectionAmount>' +
                    '<Currency>USD</Currency>' +
                    '<Amount>' + TotalAmount1 + '</Amount>' +
                    '</CodCollectionAmount>' +
                    '<CollectionType>ANY</CollectionType>' +

                    //'<ReferenceIndicator>TRACKING</ReferenceIndicator>'+
                    '</CodDetail>' +


                    '</SpecialServicesRequested>');
                    SpecialService1 := '<SpecialServicesRequested>' +
                    '<SpecialServiceTypes>COD</SpecialServiceTypes>' +
                    '<CodDetail>' +
                    '<CodCollectionAmount>' +
                    '<Currency>USD</Currency>' +
                    '<Amount>' + TotalAmount1 + '</Amount>' +
                    '</CodCollectionAmount>' +
                    '<CollectionType>ANY</CollectionType>' +
                    //'<ReferenceIndicator>TRACKING</ReferenceIndicator>'+
                    '</CodDetail>' +
                    '</SpecialServicesRequested>';


                END;
            END;

            intLen := SpecialService.LENGTH;
            //Rahul
            FOR intCount := 1 TO 10 DO BEGIN
                SpecialServiceTxt[intCount] := '';
            END;
            IF intLen <> 0 THEN
                SpecialService.GETSUBTEXT(SpecialServiceTxt[1], 1, 200);
            IF intLen > 200 THEN
                SpecialService.GETSUBTEXT(SpecialServiceTxt[2], 201, 400);
            IF intLen > 400 THEN
                SpecialService.GETSUBTEXT(SpecialServiceTxt[3], 401, 600);
            IF intLen > 600 THEN
                SpecialService.GETSUBTEXT(SpecialServiceTxt[4], 601, 800);
            IF intLen > 800 THEN
                SpecialService.GETSUBTEXT(SpecialServiceTxt[5], 801, 1000);
            IF intLen > 1000 THEN
                SpecialService.GETSUBTEXT(SpecialServiceTxt[6], 1001, 1200);
            IF intLen > 1200 THEN
                SpecialService.GETSUBTEXT(SpecialServiceTxt[7], 1201, 1400);
            IF intLen > 1400 THEN
                SpecialService.GETSUBTEXT(SpecialServiceTxt[8], 1401, 1600);
            IF intLen > 1600 THEN
                SpecialService.GETSUBTEXT(SpecialServiceTxt[9], 1601, 1800);
            IF intLen > 1800 THEN
                SpecialService.GETSUBTEXT(SpecialServiceTxt[10], 1801, 2000);


            intLength := 0;
            intLength := txtPackageDetail.LENGTH;
            IF intLength <> 0 THEN
                txtPackageDetail.GETSUBTEXT(txtPackagedet[1], 1, 1000);
            IF intLength > 1000 THEN
                txtPackageDetail.GETSUBTEXT(txtPackagedet[2], 1001, 2000);
            IF intLength > 2000 THEN
                txtPackageDetail.GETSUBTEXT(txtPackagedet[3], 2001, 3000);
            IF intLength > 3000 THEN
                txtPackageDetail.GETSUBTEXT(txtPackagedet[4], 3001, 4000);
            IF intLength > 4000 THEN
                txtPackageDetail.GETSUBTEXT(txtPackagedet[5], 4001, 5000);

            // IF ISCLEAR(Xmlhttp) THEN
            //     Result := CREATE(Xmlhttp, TRUE, TRUE);

            IF recWhsShipHeader."Charges Pay By" = recWhsShipHeader."Charges Pay By"::SENDER THEN BEGIN
                //ResponsibleAccNo:=AccountNo;
                ResponsibleAccNo := recLocation."FedEx Account";
                ResponsiblePerson := recLocation.Contact;
                ResponsibleEmail := recLocation."E-Mail";
                ResponsibleCompany := recCompanyInfo.Name;
                ResponsiblePhone := recLocation."Phone No.";
                ResponsibleAddress := recLocation.Address;
                ResponsibleCity := recLocation.City;
                ResponsibleState := recLocation.County;
                ResponsiblePost := recLocation."Post Code";
                ResponsibleCountry := recLocation."Country/Region Code";
                txtPaymentType := 'SENDER';
            END ELSE BEGIN

                ResponsibleAccNo := recCustomer."Shipping Account No.";
                //ResponsibleAccNo:=ShiptoAccount;
                ResponsiblePerson := recCustomer.Contact;
                ResponsibleEmail := recCustomer."E-Mail";
                ResponsibleCompany := recCustomer.Name;
                ResponsiblePhone := recCustomer."Phone No.";
                ResponsibleAddress := recCustomer.Address;
                ResponsibleCity := recCustomer.City;
                ResponsibleState := recCustomer.County;
                ResponsiblePost := recCustomer."Post Code";
                ResponsibleCountry := recCustomer."Country/Region Code";
                IF txtPaymentType <> 'THIRD_PARTY' THEN
                    txtPaymentType := 'RECIPIENT';
            END;

            ResponsiblePerson := AttributetoString(ResponsiblePerson);
            ResponsibleCompany := AttributetoString(ResponsibleCompany);
            ResponsibleAddress := AttributetoString(ResponsibleAddress);
            ResponsibleEmail := AttributetoString(ResponsibleEmail);


            decInsuredAmount := recWhsShipHeader."Insurance Amount";
            IF decInsuredAmount <> 0 THEN
                txtInsuredAmount := DELCHR(FORMAT(decInsuredAmount), '=', ',')
            ELSE
                txtInsuredAmount := '';
            IF recWhsShipHeader."Insurance Amount" > 0 THEN BEGIN
                txtInsurance1 :=
                '<TotalInsuredValue>' +
                        '<Currency>USD</Currency>' +
                        '<Amount>' + (txtInsuredAmount) + '</Amount>' +
                '</TotalInsuredValue>';

                txtInsurance :=
                /*
                <GroupPackageCount>1</GroupPackageCount>
                <InsuredValue>
                <Currency>USD</Currency>
                <Amount>350.00</Amount>
                </InsuredValue>

                 */
                '<GroupPackageCount>1</GroupPackageCount>' +
                '<InsuredValue>' +
                        '<Currency>USD</Currency>' +
                        '<Amount>' + (txtInsuredAmount) + '</Amount>' +
                '</InsuredValue>';


            END ELSE BEGIN
                txtInsurance := '';
                txtInsurance1 := '';
            END;
            //txtShipTime:=FORMAT(recWhsShipHeader."Shipment Time",8, '<Hours24,2>:<Minutes,2>:<Seconds,2>');
            txtShipTime := FORMAT(recWhsShipHeader."Shipment Time", 0, '<Hours24,2><Filler Character,0>:<Minutes,2>:<Seconds,2>');
            //ELSE
            //Result:=Create(Xmlhttp,TRUE);
            //txtPaymentType:=FORMAT(recSalesHeader."Charges Pay By");

            //WebClientURL := 'https://wsbeta.fedex.com:443/web-services';//'https://ws.fedex.com:443/web-services';
            //Xmlhttp.open('POST', ' https://ws.fedex.com:443/web-services', 0);//'https://wsbeta.fedex.com:443/web-services',0);
            WebClientURL := recLocation."Fedex URL";
            //Xmlhttp.send('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://fedex.com/ws/ship/v13">' +

            // Add the payload to the content
            //HttpWebContent.WriteFrom(
            BodyText := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://fedex.com/ws/ship/v13">' +
            '<soapenv:Body>' +
            '<ProcessShipmentRequest xmlns="http://fedex.com/ws/ship/v13">' +
            '<WebAuthenticationDetail>' +
            '<UserCredential>' +
            //'<Key>'+Key+'</Key>'+
            '<Key>' + recLocation."Certificate Number" + '</Key>' +
            //'<Password>'+Password+'</Password>'+
            '<Password>' + recLocation."Fedex Password" + '</Password>' +
            '</UserCredential>' +
            '</WebAuthenticationDetail>' +
            '<ClientDetail>' +
            //'<AccountNumber>'+AccountNo+'</AccountNumber>'+
            '<AccountNumber>' + recLocation."FedEx Account" + '</AccountNumber>' +
            //'<MeterNumber>'+MeterNo+'</MeterNumber>'+
            '<MeterNumber>' + recLocation."Fedex Meter No" + '</MeterNumber>' +
            '</ClientDetail>' +
            '<TransactionDetail>' +
            '<CustomerTransactionId>' + recSalesHeader."No." + '</CustomerTransactionId>' +
            '</TransactionDetail>' +
            '<Version>' +
            '<ServiceId>ship</ServiceId>' +
            '<Major>13</Major>' +
            '<Intermediate>0</Intermediate>' +
            '<Minor>0</Minor>' +
            '</Version>' +
            '<RequestedShipment>' +
            '<ShipTimestamp>' + txtYear + '-' + txtMonth + '-' + txtDate + 'T' + txtShipTime + '-05:00</ShipTimestamp>' +
            '<DropoffType>REGULAR_PICKUP</DropoffType>' +
            '<ServiceType>' + txtShipService + '</ServiceType>' +
            '<PackagingType>YOUR_PACKAGING</PackagingType>' +
            //'<TotalInsuredValue>'+
            //      '<Currency>USD</Currency>'+
            //    '<Amount>'+(TotalAmount1)+'</Amount>'+
            txtInsurance1 +
            // '<Amount>'+FORMAT(recWhsShipHeader."Insurance Charges")+'</Amount>'+


            '<Shipper>' +
            //'<AccountNumber>'+AccountNo+'</AccountNumber>'+
            '<AccountNumber>' + recLocation."FedEx Account" + '</AccountNumber>' +
            '<Contact>' +
            '<PersonName>' + recLocation.Contact + '</PersonName>' +
            '<CompanyName>' + recCompeny.Name + '</CompanyName>' +
            '<PhoneNumber>' + recLocation."Phone No." + '</PhoneNumber>' +
            '<EMailAddress>' + recLocation."E-Mail" + '</EMailAddress>' +
            '</Contact>' +
            '<Address>' +
            '<StreetLines>' + recLocation.Address + '</StreetLines>' +
            '<City>' + recLocation.City + '</City>' +
            '<StateOrProvinceCode>' + recLocation.County + '</StateOrProvinceCode>' +
            '<PostalCode>' + recLocation."Post Code" + '</PostalCode>' +
            '<CountryCode>' + recLocation."Country/Region Code" + '</CountryCode>' +
            '</Address>' +
            '</Shipper>' +
            '<Recipient>' +
            '<AccountNumber>' + ShiptoAccount + '</AccountNumber>' +
            '<Contact>' +
            '<PersonName>' + ShiptoContact + '</PersonName>' +
            '<CompanyName>' + ShiptoName + '</CompanyName>' +
            '<PhoneNumber>' + ShiptoPhone + '</PhoneNumber>' +
            '<EMailAddress>' + ShiptoEmail + '</EMailAddress>' +
            '</Contact>' +
            '<Address>' +
            '<StreetLines>' + ShiptoAddress + ' ' + ShiptoAddress2 + '</StreetLines>' +
            '<City>' + ShiptoCity + '</City>' +
            '<StateOrProvinceCode>' + ShiptoState + '</StateOrProvinceCode>' +
            '<PostalCode>' + ShiptoPostCode + '</PostalCode>' +
            '<CountryCode>' + ShiptoCountry + '</CountryCode>' +
            '<Residential>' + ShiptoResidential + '</Residential>' +
            '</Address>' +
            '</Recipient>' +
            '<ShippingChargesPayment>' +

            '<PaymentType>' + txtPaymentType + '</PaymentType>' +
            '<Payor>' +
            '<ResponsibleParty>' +
            '<AccountNumber>' + ResponsibleAccNo + '</AccountNumber>' +
            '<Contact>' +
            '<PersonName>' + ResponsiblePerson + '</PersonName>' +
            '<EMailAddress>' + ResponsibleEmail + '</EMailAddress>' +
            '</Contact>' +
            '</ResponsibleParty>' +
            '</Payor>' +
            '</ShippingChargesPayment>' +
            '<LabelSpecification>' +

            '<LabelFormatType>COMMON2D</LabelFormatType>' +
            '<ImageType>' + Compinfo."Fedex Lebal Type" + '</ImageType>' + //ZPLII
            //'<LabelStockType>STOCK_4X6.75_LEADING_DOC_TAB</LabelStockType>'+
            '<LabelStockType>STOCK_4X6</LabelStockType>' +
            '<LabelPrintingOrientation>BOTTOM_EDGE_OF_TEXT_FIRST</LabelPrintingOrientation>' +
            '</LabelSpecification>' +
            '<RateRequestTypes>LIST</RateRequestTypes>' +

            '<PackageCount>' + FORMAT(recWhsShipHeader."No. of Boxes") + '</PackageCount>' +

            //'<InsuranceCharges>'+FORMAT(Rahu)+'</InsuranceCharges>'+   Rahul

            '<RequestedPackageLineItems>' +
            //txtInsurance1+
            '<SequenceNumber>1</SequenceNumber>' +
            txtInsurance +
             '<Weight>' +
             '<Units>LB</Units>' +
             '<Value>' + FORMAT(recWhsShipHeader."Gross Weight") + '</Value>' +
             '</Weight>' +
             '<Dimensions>' +
             '<Length>' + FORMAT(recBoxMaster.Length) + '</Length>' +
             '<Width>' + FORMAT(recBoxMaster.Width) + '</Width>' +
             '<Height>' + FORMAT(recBoxMaster.Height) + '</Height>' +
             '<Units>IN</Units>' +
             '</Dimensions>' +

             // SpecialService1+
             '<PhysicalPackaging>BOX</PhysicalPackaging>' +
             '<ItemDescription>' + recWhseShipLine.Description + '</ItemDescription>' +
             '<CustomerReferences>' +
             '<CustomerReferenceType>CUSTOMER_REFERENCE</CustomerReferenceType>' +
             '<Value>' + recWhsShipHeader."External Document No." + '</Value>' +
             '</CustomerReferences>' +
            SpecialServiceTxt[1] + SpecialServiceTxt[2] + SpecialServiceTxt[3] + SpecialServiceTxt[4] + SpecialServiceTxt[5] +
            SpecialServiceTxt[6] + SpecialServiceTxt[7] + SpecialServiceTxt[8] + SpecialServiceTxt[9] + SpecialServiceTxt[10] +

            '</RequestedPackageLineItems>' +
            '</RequestedShipment>' +

            '</ProcessShipmentRequest>' +
            '</soapenv:Body>' +
            '</soapenv:Envelope>';//);
            HttpWebContent.WriteFrom(BodyText);
            // Message(BodyText);

            // IF ISCLEAR(locautXmlDoc1) THEN
            //     Result1 := CREATE(locautXmlDoc1, TRUE, TRUE);

            // Retrieve the contentHeaders associated with the content
            HttpWebContent.GetHeaders(ContentHeaders);
            ContentHeaders.Clear();
            //RequestMsg.GetHeaders(contentHeaders);
            ContentHeaders.Remove('content-type');
            ContentHeaders.Add('content-type', 'application/xml');
            //WinHttpService.SetRequestHeader('content-type', 'application/json');
            RequestMsg.Content := HttpWebContent;
            RequestMsg.SetRequestUri(WebClientURL);
            RequestMsg.Method := 'POST';
            HttpWebClient.Send(RequestMsg, HttpWebResponse);

            //MESSAGE('%1',Xmlhttp.responseText());
            //IF Xmlhttp.status <> 200 THEN BEGIN
            if HttpWebResponse.HttpStatusCode <> 200 then begin
                // Read the response content as json.
                HttpWebResponse.Content().ReadAs(tempText);
                //locautXmlDoc1.load(Xmlhttp.responseXML);
                //Position := STRPOS(Xmlhttp.responseText(), '<con1:message>');     SPD_AG
                // Position := STRPOS(Xmlhttp.responseText(), '<Message>'); //VR
                Position := STRPOS(tempText, '<Message>');
                //ResultNode := locautXmlDoc.selectNodes('soapenv:Envelope');
                //Position:=Position+14;
                Position := Position + 9;
                //Position1:=STRPOS(Xmlhttp.responseText(),'</con1:message>');      SPD_AG
                //Position1 := STRPOS(Xmlhttp.responseText(), '</Message>'); //VR
                Position1 := STRPOS(tempText, '</Message>');
                //txtMessage:=COPYSTR(Xmlhttp.responseText(),Position,Position1);
                //MESSAGE('%1', Xmlhttp.responseText()); //VR
                //MESSAGE('%1', tempText);

            END ELSE BEGIN
                HttpWebResponse.Content().ReadAs(tempText);
                //MESSAGE('%1', Xmlhttp.responseText()); //VR
                //MESSAGE('%1', tempText);
                Position := STRPOS(tempText, '<Image>');
                Position := Position + 7;
                Position1 := STRPOS(tempText, '</Image>');
                CLEAR(Picture1);
                //Picture1.ADDTEXT(Xmlhttp.responseText()); //VR
                Picture1.ADDTEXT(tempText);
                Picture1.GETSUBTEXT(Picture1, Position, Position1 - Position);
                ResponseText := CopyStr(tempText, Position, Position1 - Position);
                ResponseText := Base64Convert.FromBase64(ResponseText);
                //Message('Response text %1', ResponseText);

                recWhsShipHeader.Picture.CreateOutStream(OStream);
                OStream.WriteText(ResponseText);

                WhseSetup.GET();
                //END;

                IF txtPaymentType = 'SENDER' THEN BEGIN
                    //IF STRPOS(Xmlhttp.responseText(),'<v13:RateType>PAYOR_LIST_PACKAGE</v13:RateType>')>0 THEN BEGIN  SPD_AG
                    //    Pos:= STRPOS(Xmlhttp.responseText(),'<v13:RateType>PAYOR_LIST_PACKAGE</v13:RateType>');       SPD_AG
                    //IF STRPOS(Xmlhttp.responseText(), '<RateType>PAYOR_LIST_PACKAGE</RateType>') > 0 THEN BEGIN //VR
                    IF STRPOS(tempText, '<RateType>PAYOR_LIST_PACKAGE</RateType>') > 0 THEN BEGIN
                        //Pos := STRPOS(Xmlhttp.responseText(), '<RateType>PAYOR_LIST_PACKAGE</RateType>'); //VR
                        Pos := STRPOS(tempText, '<RateType>PAYOR_LIST_PACKAGE</RateType>');
                        //    Pos1:= Pos+1000;    SPD_AG
                        //IF Pos >0 THEN BEGIN //RAVI BEGIN
                        Pos1 := Pos + 1000;
                        //txtAmountString := COPYSTR(Xmlhttp.responseText(), Pos, Pos1 - Pos); //VR
                        txtAmountString := COPYSTR(tempText, Pos, Pos1 - Pos);
                        //END ELSE
                        //txtAmountString := '0';//RAVI END

                        //Position := STRPOS(txtAmountString, '<v13:TotalNetFedExCharge>');       SPD_AG
                        Position := STRPOS(txtAmountString, '<TotalNetFedExCharge>');
                        //ResultNode := locautXmlDoc.selectNodes('soapenv:Envelope');

                        //RAVI BEGIN
                        //IF Position > 0 THEN BEGIN
                        //Position:=Position+69;       SPd_AG
                        Position := Position + 53;
                        //Position1:=STRPOS(txtAmountString,'</v13:Amount></v13:TotalNetFedExCharge>');       SPD_AG
                        Position1 := STRPOS(txtAmountString, '</Amount></TotalNetFedExCharge>');
                        txtAmount := COPYSTR(txtAmountString, Position, Position1 - Position);

                        //END ELSE
                        //txtAmount:= '0';
                        //RAVI END
                        txtAmount := COPYSTR(txtAmountString, Position, Position1 - Position);
                        EVALUATE(decAmount, txtAmount);
                    END ELSE BEGIN

                        //Position := STRPOS(Xmlhttp.responseText(), '<v13:TotalNetFedExCharge>');        SPD_AG
                        //Position := STRPOS(Xmlhttp.responseText(), '<TotalNetFedExCharge>'); //VR
                        Position := STRPOS(tempText, '<TotalNetFedExCharge>');
                        //ResultNode := locautXmlDoc.selectNodes('soapenv:Envelope');

                        //RAVI BEGIN
                        //IF Position > 0 THEN BEGIN
                        //Position:=Position+69;       SPD_AG
                        Position := Position + 53;
                        //Position1:=STRPOS(Xmlhttp.responseText(),'</v13:Amount></v13:TotalNetFedExCharge>');
                        //Position1 := STRPOS(Xmlhttp.responseText(), '</Amount></TotalNetFedExCharge>');//VR
                        Position1 := STRPOS(tempText, '</Amount></TotalNetFedExCharge>');
                        //txtAmount := COPYSTR(Xmlhttp.responseText(), Position, Position1 - Position);//VR
                        txtAmount := COPYSTR(tempText, Position, Position1 - Position);
                        EVALUATE(decAmount, txtAmount);
                        //END ELSE
                        //txtAmount:= '0';
                        //RAVI END
                    END;
                END;
                //Position := STRPOS(Xmlhttp.responseText(), '<v13:TrackingNumber>');       SPD_AG
                //Position := STRPOS(Xmlhttp.responseText(), '<TrackingNumber>'); //VR
                Position := STRPOS(tempText, '<TrackingNumber>');
                //RAVI BEGIN
                //IF Position > 0 THEN BEGIN
                //Position:=Position+20;    SPD_AG
                Position := Position + 16;
                //Position1:=STRPOS(Xmlhttp.responseText(),'</v13:TrackingNumber>');        SPd_AG
                //Position1 := STRPOS(Xmlhttp.responseText(), '</TrackingNumber>'); //VR
                Position1 := STRPOS(tempText, '</TrackingNumber>');
                //txtAmount := COPYSTR(Xmlhttp.responseText(), Position, Position1 - Position); //VR
                txtAmount := COPYSTR(tempText, Position, Position1 - Position);
                //EVALUATE(decAmount,txtAmount);
                //END ELSE
                //txtAmount:= '0';
                //RAVI END

                recWhsShipHeader."Tracking No." := txtAmount;
                //recWhsShipHeader.MODIFY(FALSE);
                recWhsShipHeader.MODIFY;
                SalesRelease.Reopen(recSalesHeader);
                recSalesHeader.SetHideValidationDialog(TRUE);
                //recSalesHeader.VALIDATE("Posting Date",WhseShptHeader."Posting Date");
                recSalesHeader.VALIDATE("Charges Pay By", recWhsShipHeader."Charges Pay By");
                recSalesHeader.VALIDATE("Tracking No.", recWhsShipHeader."Tracking No.");
                recSalesHeader.VALIDATE("Tracking Status", recWhsShipHeader."Tracking Status");
                recSalesHeader.VALIDATE("Box Code", recWhsShipHeader."Box Code");
                recSalesHeader.VALIDATE("No. of Boxes", recWhsShipHeader."No. of Boxes");
                //ModifyHeader := TRUE;
                IF txtPaymentType = 'SENDER' THEN BEGIN
                    recSalesLine.RESET;
                    recSalesLine.SETRANGE("Document Type", recSalesLine."Document Type"::Order);
                    recSalesLine.SETRANGE("Document No.", recSalesHeader."No.");
                    IF recSalesLine.FIND('+') THEN BEGIN
                        intLineNo := recSalesLine."Line No.";
                        recSalesLine.INIT;
                        recSalesLine.VALIDATE("Document Type", recSalesHeader."Document Type");
                        recSalesLine.VALIDATE("Document No.", recSalesHeader."No.");
                        recSalesLine.VALIDATE(Type, recSalesLine.Type::Resource);
                        recSalesLine.VALIDATE("Line No.", intLineNo + 10000);
                        recSalesLine.VALIDATE("No.", 'FREIGHT');
                        recSalesLine.VALIDATE(Description, 'Against Warehouse shipment No. ' + recWhsShipHeader."No.");
                        recSalesLine.VALIDATE(Quantity, 1);
                        recSalesLine.VALIDATE("Unit Price", decAmount + recWhsShipHeader."Handling Charges" + recWhsShipHeader."Insurance Charges");
                        recSalesLine.INSERT;
                    END;
                    //END;
                END;
                recSalesHeader.MODIFY;
                SalesRelease.RUN(recSalesHeader);

                recTrackingNo.RESET;
                recTrackingNo.SETRANGE(recTrackingNo."Warehouse Shipment No", recWhsShipHeader."No.");
                recTrackingNo.SETRANGE("Tracking No.", txtAmount);
                IF NOT recTrackingNo.FIND('-') THEN BEGIN
                    recTrackingNo.INIT;
                    recTrackingNo."Warehouse Shipment No" := recWhsShipHeader."No.";
                    recTrackingNo."Tracking No." := txtAmount;
                    recTrackingNo."Source Document No." := recSalesHeader."No.";
                    recTrackingNo."Service Name" := 'FEDEX';

                    recTrackingNo."Charges Pay By" := txtPaymentType;
                    recTrackingNo."No. of Boxes" := recWhsShipHeader."No. of Boxes";
                    recTrackingNo."Gross Weight" := recWhsShipHeader."Gross Weight";
                    recTrackingNo."Handling Charges" := recWhsShipHeader."Handling Charges";
                    recTrackingNo."Insurance Charges" := recWhsShipHeader."Insurance Charges";
                    recTrackingNo."Cash On Delivery" := recWhsShipHeader."Cash On Delivery";
                    recTrackingNo."Signature Required" := recWhsShipHeader."Signature Required";
                    recTrackingNo."Shipping Agent Service Code" := recWhsShipHeader."Shipping Agent Service Code";
                    recTrackingNo."Box Code" := recWhsShipHeader."Box Code";
                    recTrackingNo."Shipping Account No" := ShiptoAccount;
                    recTrackingNo."COD Amount" := recWhsShipHeader."COD Amount";

                    //Bytes := Convert.FromBase64String(Picture1);//VR
                    //MemoryStream := MemoryStream.MemoryStream(Bytes); //VR
                    recTrackingNo.Image.CREATEOUTSTREAM(OStream);
                    OStream.WriteText(ResponseText);
                    //Picture1.Write(OStream);
                    recTrackingNo.INSERT;
                END;


            END;
        END;

    end;


    procedure ReplaceString(String: Text[250]; FindWhat: Text[250]; ReplaceWith: Text[250]): Text[250]
    begin
        IF STRPOS(String, FindWhat) > 0 THEN BEGIN
            IF FindWhat = '&' THEN BEGIN
                // strPosition:=STRPOS(String,FindWhat);
                String := DELSTR(String, STRPOS(String, FindWhat)) + ReplaceWith + COPYSTR(String, STRPOS(String, FindWhat) + STRLEN(FindWhat))
            END ELSE BEGIN

                WHILE STRPOS(String, FindWhat) > 0 DO
                    String := DELSTR(String, STRPOS(String, FindWhat)) + ReplaceWith + COPYSTR(String, STRPOS(String, FindWhat) + STRLEN(FindWhat));
            END;
        END;
        EXIT(String);
    end;


    procedure AttributetoString(txtString: Text[250]): Text[250]
    var
        text001: Label '''';
    begin
        txtString := ReplaceString(txtString, '&', '&amp;');
        txtString := ReplaceString(txtString, '<', '&lt;');
        txtString := ReplaceString(txtString, '>', '&gt;');
        txtString := ReplaceString(txtString, '"', '&quot;');
        txtString := ReplaceString(txtString, 'text001', '&apos;');
        EXIT(txtString);
    end;

    procedure WhseRegisterActivityYesNo(Rec: Record "Warehouse Activity Line")
    begin
        WhseActivLine.COPY(Rec);
        cuNOPPoratal.CodeHandheld(WhseActivLine."No.");
    end;

    procedure VoidStampsFedEx(recWhsShipHeader: Record "Warehouse Shipment Header"; recTrackingNo: record "Tracking No.")
    var
        BodyText: Text;
        ResponseText: Text;
        Base64Convert: Codeunit "Base64 Convert";
        PositionError: Integer;
        PositionError1: Integer;
        ErrorText: Text;
        txtYear: Text[10];
        txtMonth: Text[10];
        txtDate: Text[10];
        intDate: Integer;
        intMonth: Integer;
        intYear: Integer;
        txtShipTime: Text[50];
        recSalesLine: Record "Sales Line";
        recSalesHeader: Record "Sales Header";
        recWhseShipLine: Record "Warehouse Shipment Line";
        TrackingNo: Record "Tracking No.";
    begin
        intDate := DATE2DMY(recWhsShipHeader."Shipment Date", 1);
        intMonth := DATE2DMY(recWhsShipHeader."Shipment Date", 2);
        intYear := DATE2DMY(recWhsShipHeader."Shipment Date", 3);
        txtDate := FORMAT(intDate);
        txtMonth := FORMAT(intMonth);
        txtYear := FORMAT(intYear);
        IF intYear < 100 THEN
            txtYear := '20' + txtYear;
        IF STRLEN(txtMonth) < 2 THEN
            txtMonth := '0' + txtMonth;
        IF STRLEN(txtDate) < 2 THEN
            txtDate := '0' + txtDate;

        txtShipTime := FORMAT(recWhsShipHeader."Shipment Time", 0, '<Hours24,2><Filler Character,0>:<Minutes,2>:<Seconds,2>');
        recLocation.GET(recWhsShipHeader."Location Code");

        WebClientURL := recLocation."Fedex URL";//'https://wsbeta.fedex.com:443/web-services/ship';

        BodyText := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" ' +
        'xmlns:v28="http://fedex.com/ws/ship/v28">' +
            '<soapenv:Header/>' +
            '<soapenv:Body>' +
                '<v28:DeleteShipmentRequest>' +
                    '<v28:WebAuthenticationDetail>' +
                        '<v28:ParentCredential>' +
                            '<v28:Key>' + recLocation."Certificate Number" + '</v28:Key>' +
                            '<v28:Password>' + recLocation."Fedex Password" + '</v28:Password>' +
                        '</v28:ParentCredential>' +
                        '<v28:UserCredential>' +
                            '<v28:Key>' + recLocation."Certificate Number" + '</v28:Key>' +
                            '<v28:Password>' + recLocation."Fedex Password" + '</v28:Password>' +
                        '</v28:UserCredential>' +
                    '</v28:WebAuthenticationDetail>' +
                    '<v28:ClientDetail>' +
                        '<v28:AccountNumber>' + recLocation."FedEx Account" + '</v28:AccountNumber>' +
                        '<v28:MeterNumber>' + recLocation."Fedex Meter No" + '</v28:MeterNumber>' +
                    '</v28:ClientDetail>' +
                    '<v28:TransactionDetail>' +
                        '<v28:CustomerTransactionId>Delete Shipment</v28:CustomerTransactionId>' +
                    '</v28:TransactionDetail>' +
                    '<v28:Version>' +
                        '<v28:ServiceId>ship</v28:ServiceId>' +
                        '<v28:Major>28</v28:Major>' +
                        '<v28:Intermediate>0</v28:Intermediate>' +
                        '<v28:Minor>0</v28:Minor>' +
                    '</v28:Version>' +
                    '<v28:ShipTimestamp>' + txtYear + '-' + txtMonth + '-' + txtDate + 'T' + txtShipTime + '-05:00</v28:ShipTimestamp>' +
                    '<v28:TrackingId>' +
                        '<v28:TrackingIdType>EXPRESS</v28:TrackingIdType>' +
                        '<!-- GROUND -->' +
                        '<v28:TrackingNumber>' + recTrackingNo."Tracking No." + '</v28:TrackingNumber>' +
                    '</v28:TrackingId>' +
                    '<v28:DeletionControl>DELETE_ALL_PACKAGES</v28:DeletionControl> ' +
                    '<!-- DELETE_ONE_PACKAGE -->' +
                '</v28:DeleteShipmentRequest>' +
            '</soapenv:Body>' +
        '</soapenv:Envelope>';


        HttpWebContent.WriteFrom(BodyText);
        Message(BodyText);

        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        //ContentHeaders.Remove('content-type');
        ContentHeaders.Add('content-type', 'application/xml');
        ContentHeaders.Add('Cookie', 'siteDC=edc');
        RequestMsg.Content := HttpWebContent;
        RequestMsg.SetRequestUri(WebClientURL);
        RequestMsg.Method := 'POST';
        HttpWebClient.Send(RequestMsg, HttpWebResponse);

        if HttpWebResponse.HttpStatusCode <> 200 then begin
            HttpWebResponse.Content().ReadAs(tempText);
            Message('Response text %1', tempText);
        END ELSE BEGIN
            HttpWebResponse.Content().ReadAs(tempText);
            PositionError := STRPOS(tempText, '<HighestSeverity>');
            PositionError := PositionError + 17;
            PositionError1 := STRPOS(tempText, '</HighestSeverity>');
            ErrorText := CopyStr(tempText, PositionError, PositionError1 - PositionError);
            IF ErrorText <> 'SUCCESS' then begin
                Message('Response text %1', tempText);
            end else begin
                TrackingNo.RESET;
                TrackingNo.Setrange("Warehouse Shipment No", recWhsShipHeader."No.");
                IF TrackingNo.FindFirst THEN BEGIN
                    TrackingNo."Void Entry" := true;
                    //TrackingNo."Tracking No." := '';
                    //TrackingNo.Image := '';
                    TrackingNo.Modify();
                END;
                recWhsShipHeader."Tracking No." := '';
                //recWhsShipHeader.Picture := '';
                recWhsShipHeader.Modify();

                recWhseShipLine.RESET;
                recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
                IF recWhseShipLine.FIND('-') THEN;
                recSalesHeader.RESET;
                IF recSalesHeader.GET(recWhseShipLine."Source Subtype", recWhseShipLine."Source No.") THEN;

                recSalesHeader."Tracking No." := '';
                recSalesHeader.Modify();

                IF recWhsShipHeader."Charges Pay By" = recWhsShipHeader."Charges Pay By"::SENDER THEN BEGIN
                    recSalesLine.reset;
                    recSalesLine.SetRange("Document Type", recSalesLine."Document Type"::Order);
                    recSalesLine.SetRange("Document No.", recSalesHeader."No.");
                    recSalesLine.SetRange(Type, recSalesLine.Type::Resource);
                    recSalesLine.SetRange("No.", 'FREIGHT');
                    recSalesLine.SetRange(Description, 'Against Warehouse shipment No. ' + recWhsShipHeader."No.");
                    recSalesLine.SetRange(Quantity, 1);
                    IF recSalesLine.FindFirst then
                        recSalesLine.Delete();
                END;

                Message('Response text %1', tempText);
            end;

        end;

    END;

    //VR Code not in use
    procedure StampsEndicia(recWhsShipHeader: Record "Warehouse Shipment Header")
    var
    //     UPSUSERNAME: Label 'silktex';
    //     UPSPASSWORD: Label 'Crafts12';
    //     UPSLICENCE: Label 'ACE923D1E3142AC6';
    //     recSalesHeader: Record "Sales Header";
    //     recWhseShipLine: Record "Warehouse Shipment Line";
    //     ReturnString: BigText;
    //     recSalesLine: Record "Sales Line";
    //     TotalAmount: Decimal;
    //     recShippingAgentService: Record "Shipping Agent Services";
    //     Loc: Record Location;
    //     "----Stamps--": Integer;
    //     txtLabeljsonstring: Text;
    //     ReturnRespnceMessage: Text;
    //     LabelStamps: DotNet ShippingServices;
    //     RetCreateIndicium: DotNet RetCreateIndicium;
    //     URL: Text;
    //     Path: Text;
    //     LabelResponse: Text;
    //     LabelString: Text;
    //     Tracking_No: Text;
    //     LabelReturnMessage: Text;
    //     "---ToAddressVariable--": Integer;
    //     recShiptoAddress: Record "Ship-to Address";
    //     recCustomer: Record Customer;
    //     TOFullName: Text;
    //     TONamePrefix: Text;
    //     TOFirstName: Text;
    //     TOMiddleName: Text;
    //     TOLastName: Text;
    //     TONameSuffix: Text;
    //     TOTitle: Text;
    //     TODepartment: Text;
    //     TOCompany: Text;
    //     TOAddress1: Text;
    //     TOAddress2: Text;
    //     TOAddress3: Text;
    //     TOCity: Text;
    //     TOState: Text;
    //     TOZIPCode: Text;
    //     TOZIPCodeAddOn: Text;
    //     TODPB: Text;
    //     TOCheckDigit: Text;
    //     TOProvince: Text;
    //     TOPostalCode: Text;
    //     TOCountry: Text;
    //     TOUrbanization: Text;
    //     TOPhoneNumber: Text;
    //     TOExtension: Text;
    //     TOCleanseHash: Text;
    //     TOOverrideHash: Text;
    //     TOEmailAddress: Text;
    //     TOFullAddress: Text;
    //     ServiceType: Text;
    begin
        // CompInfo.GET();
        // TotalAmount := 0;
        // TotalAmount1 := '';
        // recWhseShipLine.RESET;
        // recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
        // ///recWhseShipLine.SETFILTER("Qty. to Ship",'<>%1',0);
        // recWhseShipLine.SETRANGE("Source Type", 37);
        // recWhseShipLine.SETRANGE("Source Subtype", 1);
        // IF recWhseShipLine.FIND('-') THEN BEGIN
        //     REPEAT
        //         recSalesLine.RESET;
        //         recSalesLine.SETRANGE("Document No.", recWhseShipLine."Source No.");
        //         recSalesLine.SETRANGE("Line No.", recWhseShipLine."Source Line No.");
        //         IF recSalesLine.FIND('-') THEN BEGIN
        //             REPEAT
        //                 TotalAmount := TotalAmount + recWhseShipLine."Qty. to Ship" * recSalesLine."Unit Price";
        //             UNTIL recSalesLine.NEXT = 0;
        //         END;
        //     UNTIL recWhseShipLine.NEXT = 0;
        // END;

        // recSalesHeader.RESET;
        // IF recSalesHeader.GET(recWhseShipLine."Source Subtype", recWhseShipLine."Source No.") THEN;
        // Loc.GET(recWhsShipHeader."Location Code");
        // recShippingAgentService.GET(recWhsShipHeader."Shipping Agent Code", recWhsShipHeader."Shipping Agent Service Code");
        // TotalAmount1 := FORMAT(recWhsShipHeader."Insurance Amount");
        // TotalAmount1 := DELCHR(TotalAmount1, '=', ',');

        // GetToken(ReturnRespnceMessage);

        // TOFullName := '';
        // TONamePrefix := '';
        // TOFirstName := '';
        // TOMiddleName := '';
        // TOLastName := '';
        // TONameSuffix := '';
        // TOTitle := '';
        // TODepartment := '';
        // TOCompany := '';
        // TOAddress1 := '';
        // TOAddress2 := '';
        // TOAddress3 := '';
        // TOCity := '';
        // TOState := '';
        // TOZIPCode := '';
        // TOZIPCodeAddOn := '';
        // TODPB := '';
        // TOCheckDigit := '';
        // TOProvince := '';
        // TOPostalCode := '';
        // TOCountry := '';
        // TOUrbanization := '';
        // TOPhoneNumber := '';
        // TOExtension := '';
        // TOCleanseHash := '';
        // TOOverrideHash := '';
        // TOEmailAddress := '';
        // TOFullAddress := '';

        // IF recSalesHeader."Ship-to Code" <> '' THEN BEGIN
        //     recCustomer.GET(recSalesHeader."Sell-to Customer No.");
        //     recShiptoAddress.GET(recSalesHeader."Sell-to Customer No.", recSalesHeader."Ship-to Code");
        //     TOFullName := recShiptoAddress.Name;
        //     TOAddress1 := recShiptoAddress.Address;
        //     TOAddress2 := recShiptoAddress."Address 2";
        //     TOCity := recShiptoAddress.City;
        //     TOState := recShiptoAddress.County;
        //     TOZIPCode := recShiptoAddress."Post Code";
        //     TOPostalCode := recShiptoAddress."Post Code";
        //     TOCountry := recShiptoAddress."Country/Region Code";
        //     TOEmailAddress := recShiptoAddress."E-Mail";
        //     TOFirstName := recShiptoAddress.Contact;
        //     TOPhoneNumber := recShiptoAddress."Phone No.";
        // END ELSE BEGIN
        //     recCustomer.GET(recSalesHeader."Sell-to Customer No.");
        //     TOFullName := recCustomer.Name;
        //     TOAddress1 := recCustomer.Address;
        //     TOAddress2 := recCustomer."Address 2";
        //     TOCity := recCustomer.City;
        //     TOState := recCustomer.County;
        //     TOZIPCode := recCustomer."Post Code";
        //     TOPostalCode := recCustomer."Post Code";
        //     TOCountry := recCustomer."Country/Region Code";
        //     TOEmailAddress := recCustomer."E-Mail";
        //     TOFirstName := recCustomer.Contact;
        //     TOPhoneNumber := recCustomer."Phone No.";
        // END;
        // IF recWhsShipHeader."Service Type" = recWhsShipHeader."Service Type"::USFC THEN BEGIN
        //     GrossWeightOz := recWhsShipHeader."Gross Weight Oz";
        //     ServiceType := 'USFC';
        // END;

        // IF recWhsShipHeader."Service Type" = recWhsShipHeader."Service Type"::USPS THEN BEGIN
        //     GrossWeightLB := recWhsShipHeader."Gross Weight LB";
        //     ServiceType := 'USPS'
        // END;

        // //Tarun BEGIN
        // txtLabeljsonstring := '{'
        //   + '"Item": "' + ReturnRespnceMessage + '",'
        //   + '"IntegratorTxID": "' + recWhsShipHeader."No." + '",'
        //   + '"TrackingNumber": "null",'
        //   + '"Rate": {'
        //     + '"From": {'
        //       + '"FullName": "' + Loc.Name + '",'
        //       + '"NamePrefix": "",'
        //       + '"FirstName": "",'
        //       + '"MiddleName": "",'
        //       + '"LastName": "",'
        //       + '"NameSuffix": "",'
        //       + '"Title": "",'
        //       + '"Department": "",'
        //       + '"Company": "'+ CompanyName +'",'//"SILK CRAFTS, INC.",'
        //       + '"Address1": "' + Loc.Address + '",'
        //       + '"Address2": "' + Loc."Address 2" + '",'
        //       + '"Address3": "",'
        //       + '"City": "' + Loc.City + '",'
        //       + '"State": "' + Loc.County + '",'
        //       + '"ZIPCode": "' + Loc."Post Code" + '",'
        //       + '"ZIPCodeAddOn": "",'
        //       + '"DPB": "",'
        //       + '"CheckDigit": "",'
        //       + '"Province": "",'
        //       + '"PostalCode": "' + Loc."Post Code" + '",'
        //       + '"Country": "' + Loc."Country/Region Code" + '",'
        //       + '"Urbanization": "",'
        //       + '"PhoneNumber": "' + Loc."Phone No." + '",'
        //       + '"Extension": "",'
        //       + '"CleanseHash": "",'
        //       + '"OverrideHash": "",'
        //       + '"EmailAddress": "' + Loc."E-Mail" + '",'
        //       + '"FullAddress": ""'
        //     + '},'
        //     + '"To": {'
        //       + '"FullName": "' + TOFullName + '",'
        //       + '"NamePrefix": "",'
        //       + '"FirstName": "",'
        //       + '"MiddleName": "",'
        //       + '"LastName": "",'
        //       + '"NameSuffix": "",'
        //       + '"Title": "",'
        //       + '"Department": "",'
        //       + '"Company": "",'
        //       + '"Address1": "' + TOAddress1 + '",'
        //       + '"Address2": "' + TOAddress2 + '",'
        //       + '"Address3": "",'
        //       + '"City": "' + TOCity + '",'
        //       + '"State": "' + TOState + '",'
        //       + '"ZIPCode": "' + TOZIPCode + '",'
        //       + '"ZIPCodeAddOn": "",'
        //       + '"DPB": "",'
        //       + '"CheckDigit": "",'
        //       + '"Province": "",'
        //       + '"PostalCode": "' + TOPostalCode + '",'
        //       + '"Country": "' + TOCountry + '",'
        //       + '"Urbanization": "",'
        //       + '"PhoneNumber": "' + TOPhoneNumber + '",'
        //       + '"Extension": "",'
        //       + '"CleanseHash": "",'
        //       + '"OverrideHash": "",'
        //       + '"EmailAddress": "' + TOEmailAddress + '",'
        //       + '"FullAddress": ""'
        //     + '},'
        //     + '"Amount": "' + FORMAT(TotalAmount1) + '",'
        //     + '"MaxAmount": 0,'
        //     + '"ServiceType": "' + ServiceType + '",'
        //     + '"ServiceDescription": "' + recShippingAgentService.Description + '",'
        //     + '"PrintLayout": null,'
        //     + '"DeliverDays": "1-1",'
        //     + '"WeightLb": "' + FORMAT(GrossWeightLB) + '",'
        //     + '"WeightOz": "' + FORMAT(GrossWeightOz) + '",'
        //     + '"PackageType": "Package",'
        //     + '"InsuredValue": "' + FORMAT(recWhsShipHeader."Insurance Amount") + '",'
        //     + '"ShipDate": "' + FORMAT(recWhsShipHeader."Shipment Date") + '"'
        //   + '},'
        //   + '"ImageType": "AZpl"'
        // + '}';
        // //Tarun END
        // MESSAGE(txtLabeljsonstring);

        // URL := CompInfo."Stamps URL";
        // Path := 'C:\Stamps\Label\';
        // LabelStamps := LabelStamps.ShippingServices();
        // RetCreateIndicium := LabelStamps.CreateIndicium(txtLabeljsonstring, URL, Path, ReturnRespnceMessage);
        // Labelbl := RetCreateIndicium.Status();
        // //MESSAGE('RetCreateIndicium.Status %1',Labelbl);
        // LabelReturnMessage := RetCreateIndicium.Message();
        // //MESSAGE('RetCreateIndicium.Message %1',LabelReturnMessage);
        // LabelResponse := RetCreateIndicium.Response();
        // MESSAGE('LabelResponse %1', LabelResponse);
        // LabelString := RetCreateIndicium.Label_Base64();
        // //MESSAGE(LabelString);
        // Tracking_No := RetCreateIndicium.Tracking_No();
        // //MESSAGE(Tracking_No);

        // StampsResponce(recWhsShipHeader, Tracking_No, LabelString);
    end;
    //VR code not in use
    local procedure GetToken(var ReturnRespnceMessage: Text)
    // var
    //     Stamps: DotNet ShippingServices;
    //     RetAuthenticateUser: DotNet RetAuthenticateUser;
    //     jsonstring: Text;
    //     ReturnMessage: Text;
    //     bl: Boolean;
    //     URL: Text;
    begin
        // CompInfo.GET();
        // jsonstring := '{'
        //   + '"Credentials":{'
        //     + '"IntegrationID":"' + CompInfo."Stamps Integration ID" + '",'
        //     + '"Username":"' + CompInfo."Stamps Username" + '",'
        //     + '"Password":"' + CompInfo."Stamps Password" + '"'
        //   + '}'
        // + '}';

        // URL := CompInfo."Stamps URL";
        // Stamps := Stamps.ShippingServices();
        // RetAuthenticateUser := Stamps.AuthenticateUser(jsonstring, URL);
        // ReturnRespnceMessage := RetAuthenticateUser.Authenticator;
        //MESSAGE('RetAuthenticateUser.Authenticator %1',ReturnRespnceMessage);
    end;

    local procedure StampsResponce(recWhsShipHeader: Record "Warehouse Shipment Header"; TrackingNo: Code[30]; Picture1: Text)
    var
        recSalesLine: Record "Sales Line";
        recSalesHeader: Record "Sales Header";
        recWhseShipLine: Record "Warehouse Shipment Line";
        recBoxMaster: Record "Box Master";
        SalesRelease: Codeunit "Release Sales Document";
        recShipAgentService: Record "Shipping Agent Services";
        recTrackingNo: Record "Tracking No.";
        intLineNo: Integer;
    begin
        recWhseShipLine.RESET;
        recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
        IF recWhseShipLine.FIND('-') THEN;
        recSalesHeader.RESET;
        IF recSalesHeader.GET(recWhseShipLine."Source Subtype", recWhseShipLine."Source No.") THEN;

        // Bytes := Convert.FromBase64String(Picture1); //VR
        // MemoryStream := MemoryStream.MemoryStream(Bytes); //VR
        recWhsShipHeader.Picture.CREATEOUTSTREAM(OStream);
        //MemoryStream.WriteTo(OStream); //VR
        OStream.WriteText(Picture1);

        recWhsShipHeader."Tracking No." := TrackingNo;
        recWhsShipHeader.MODIFY(FALSE);

        SalesRelease.Reopen(recSalesHeader);
        recSalesHeader.SetHideValidationDialog(TRUE);
        recSalesHeader.VALIDATE("Tracking No.", recWhsShipHeader."Tracking No.");
        recSalesHeader.VALIDATE("Tracking Status", recWhsShipHeader."Tracking Status");
        recSalesHeader.MODIFY;
        SalesRelease.RUN(recSalesHeader);

        recTrackingNo.RESET;
        recTrackingNo.SETRANGE("Warehouse Shipment No", recWhsShipHeader."No.");
        recTrackingNo.SETRANGE("Tracking No.", TrackingNo);
        IF NOT recTrackingNo.FIND('-') THEN BEGIN
            recTrackingNo.INIT;
            recTrackingNo."Warehouse Shipment No" := recWhsShipHeader."No.";
            recTrackingNo."Tracking No." := TrackingNo;
            recTrackingNo."Source Document No." := recSalesHeader."No.";
            recTrackingNo."Service Name" := 'STAMPS';
            recTrackingNo."Handling Charges" := recWhsShipHeader."Handling Charges";
            recTrackingNo."Shipping Agent Service Code" := recWhsShipHeader."Shipping Agent Service Code";

            // Bytes := Convert.FromBase64String(Picture1); //VR
            // MemoryStream := MemoryStream.MemoryStream(Bytes); //VR
            recTrackingNo.Image.CREATEOUTSTREAM(OStream);
            //MemoryStream.WriteTo(OStream); //VR
            OStream.WriteText(Picture1);
            recTrackingNo.INSERT;
        END;
    end;

    //VR code not in use
    procedure VoidStampsEndicia(recWhsShipHeader: Record "Warehouse Shipment Header")
    // var
    //     UPSUSERNAME: Label 'silktex';
    //     UPSPASSWORD: Label 'Crafts12';
    //     UPSLICENCE: Label 'ACE923D1E3142AC6';
    //     "----Stamps--": Integer;
    //     VoidtxtLabeljsonstring: Text;
    //     VoidLabelStamps: DotNet ShippingServices;
    //     RetCancelIndicium: DotNet RetCancelIndicium;
    //     URL: Text;
    //     VoidLabelbl: Boolean;
    //     ReturnRespnceMessage: Text;
    begin
        // CompInfo.GET();
        // GetToken(ReturnRespnceMessage);

        // //Tarun BEGIN
        // VoidtxtLabeljsonstring := '{'
        //   + '"Item": "' + ReturnRespnceMessage + '",'
        //   + '"Item1": "' + recWhsShipHeader."Tracking No." + '"'
        // + '}';
        // //Tarun END
        // MESSAGE(VoidtxtLabeljsonstring);

        // URL := CompInfo."Stamps URL";
        // VoidLabelStamps := VoidLabelStamps.ShippingServices();
        // RetCancelIndicium := VoidLabelStamps.CancelIndicium(VoidtxtLabeljsonstring, URL);
        // VoidLabelbl := RetCancelIndicium.Status();
        // MESSAGE('RetCancelIndicium.Status %1', VoidLabelbl);

        // IF VoidLabelbl THEN
        //     VoidStampsResponce(recWhsShipHeader, recWhsShipHeader."Tracking No.");
    end;

    local procedure VoidStampsResponce(recWhsShipHeader: Record "Warehouse Shipment Header"; TrackingNo: Code[30])
    var
        recSalesLine: Record "Sales Line";
        recSalesHeader: Record "Sales Header";
        recWhseShipLine: Record "Warehouse Shipment Line";
        recBoxMaster: Record "Box Master";
        SalesRelease: Codeunit "Release Sales Document";
        recShipAgentService: Record "Shipping Agent Services";
        recTrackingNo: Record "Tracking No.";
        intLineNo: Integer;
    begin
        recWhseShipLine.RESET;
        recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
        IF recWhseShipLine.FIND('-') THEN;
        recSalesHeader.RESET;
        IF recSalesHeader.GET(recWhseShipLine."Source Subtype", recWhseShipLine."Source No.") THEN;

        recWhsShipHeader.CALCFIELDS(Picture);
        CLEAR(recWhsShipHeader.Picture);
        recWhsShipHeader."Tracking No." := '';
        recWhsShipHeader.MODIFY(FALSE);

        SalesRelease.Reopen(recSalesHeader);
        recSalesHeader.SetHideValidationDialog(TRUE);
        recSalesHeader.VALIDATE("Tracking No.", '');
        recSalesHeader.VALIDATE("Tracking Status", 'Void');
        recSalesHeader.MODIFY;
        SalesRelease.RUN(recSalesHeader);

        recTrackingNo.RESET;
        recTrackingNo.SETRANGE("Warehouse Shipment No", recWhsShipHeader."No.");
        recTrackingNo.SETRANGE("Tracking No.", TrackingNo);
        IF recTrackingNo.FIND('-') THEN BEGIN
            recTrackingNo.DELETE;
        END;
    end;
}

