//VR codeunit not in use
// codeunit 50007 "Integration Handheld"
// {
//     Permissions = TableData "Sales Shipment Header" = rimd;

//     trigger OnRun()
//     begin
//     end;

//     var
//         Xmlhttp: Automation;
//         Result: Boolean;
//         locautXmlDoc: Automation;
//         Result1: Boolean;
//         ResultNode: Automation;
//         DecodeXSLT: Automation;
//         locautXmlDoc1: Automation;
//         getAllResponseHeaders: Text;
//         Position: Integer;
//         Position1: Integer;
//         data: Text[1000];
//         data1: Text[1000];
//         int: Integer;
//         text001: Label '10.10.1.39';
//         ImportXmlFile: File;
//         XmlINStream: InStream;
//         Xmlhttp1: Automation;
//         recSH: Record "Sales Header";
//         xmlHttpre: Automation;
//         responseStream: Text[250];
//         Picture: BigText;
//         Picture1: BigText;
//         Bytes: DotNet Array;
//         Convert: DotNet Convert;
//         MemoryStream: DotNet MemoryStream;
//         OStream: OutStream;
//         text1: Text[30];
//         Stream: Automation;
//         abpAutBytes: DotNet Array;
//         abpAutMemoryStream: DotNet MemoryStream;
//         abpOutStream: OutStream;
//         abpAutConvertBase64: DotNet Convert;
//         abpRecTempBlob: Record TempBlob temporary;
//         recCompeny: Record "Company Information";
//         recLocation: Record Location;
//         recCompanyInfo: Record "Company Information";
//         IStream: InStream;
//         "Key": Label 'c4LvuJL5jnMaQA2C';
//         Password: Label 'GtJhVpwzFs1IczW7a1Rrqoxbi';
//         AccountNo2: Label '122898849';
//         MeterNo: Label '107459103';
//         recItem: Record Item;
//         AccountNo: Label '122898849';
//         Key1: Label 'K43TcvGLqW7cyltY';
//         Password1: Label 'MyLPw6Mk4n2snENVB9Ls9vC9q';
//         AccountNo1: Label '510087704';
//         MeterNo1: Label '118631944';
//         TotalAmount: Decimal;
//         TotalAmount1: Text;
//         SpecialService: BigText;
//         CompanyName: Text[80];
//         RateText01: Label 'http://wwwapps.ups.com/ctc/htmlTool?accept_UPS_license_agreement=yes&UPS_HTML_License=7BAF5EAE471A8706&10_action=4&14_origCountry=US&origCity=Syosset&15_origPostal=11791&billToUPS=yes&47_rate_chart=%20Regular%20Daily%20Pickup&';
//         txtSignature: Text[30];
//         intLen: Integer;
//         intCount: Integer;
//         txtDeliveryAcceptance: Text[250];
//         txtCodAmount: Text[30];
//         txtInsurance: Text[250];
//         txtInsuredAmount: Text[100];
//         decInsuredAmount: Decimal;
//         SpecialService1: Text[1000];
//         txtInsurance1: Text[1000];
//         Pos: Integer;
//         Pos1: Integer;
//         txtAmountString: Text[1024];
//         blnGenerateNote: Boolean;
//         webserverIP: Label '192.168.1.228:51212';
//         RocketShipIP: Label 'localhost:59999';
//         WhseActivLine: Record "Warehouse Activity Line";
//         cuNOPPoratal: Codeunit "Whse.-Act.-RegisterWe (Yes/No)";


//     procedure PickUpRequest()
//     begin
//         IF ISCLEAR(Xmlhttp) THEN
//             Result := CREATE(Xmlhttp, TRUE, TRUE);
//         //ELSE
//         //Result:=Create(Xmlhttp,TRUE);
//         Xmlhttp.open('POST', ' https://wsbeta.fedex.com:443/web-services', 0);//'https://wsbeta.fedex.com:443/web-services',0);
//         //Xmlhttp.setRequestHeader('Content-Type', 'text/xml; charset=utf-8');
//         //Xmlhttp.setRequestHeader('SOAPAction', 'RunJob');



//         Xmlhttp.send('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v3="http://fedex.com/ws/pickup/v3">' +
//            '<soapenv:Header/>' +
//            '<soapenv:Body>' +
//               '<v3:CreatePickupRequest>' +
//                  '<v3:WebAuthenticationDetail>' +
//                     '<v3:UserCredential>' +
//                        '<v3:Key>K43TcvGLqW7cyltY</v3:Key>' +
//                        '<v3:Password>MyLPw6Mk4n2snENVB9Ls9vC9q</v3:Password>' +
//                     '</v3:UserCredential>' +
//                  '</v3:WebAuthenticationDetail>' +
//                  '<v3:ClientDetail>' +
//                     '<v3:AccountNumber>510087704</v3:AccountNumber>' +
//                     '<v3:MeterNumber>118631944</v3:MeterNumber>' +
//                     '<v3:Localization>' +
//                        '<v3:LanguageCode>EN</v3:LanguageCode>' +
//                        '<v3:LocaleCode>EN</v3:LocaleCode>' +
//                     '</v3:Localization>' +
//                  '</v3:ClientDetail>' +
//                  '<v3:TransactionDetail>' +
//                     '<v3:CustomerTransactionId>CreatePickup_v3</v3:CustomerTransactionId>' +
//                  '</v3:TransactionDetail>' +
//                  '<v3:Version>' +
//                     '<v3:ServiceId>disp</v3:ServiceId>' +
//                     '<v3:Major>3</v3:Major>' +
//                     '<v3:Intermediate>0</v3:Intermediate>' +
//                     '<v3:Minor>0</v3:Minor>' +
//                  '</v3:Version>' +
//                  '<v3:OriginDetail>' +
//                     '<v3:UseAccountAddress>0</v3:UseAccountAddress>' +
//                     '<v3:PickupLocation>' +
//                        '<v3:Contact>' +
//                           '<v3:PersonName>Andrew Marsh</v3:PersonName>' +
//                           '<v3:CompanyName>SILK CRAFTS INC.</v3:CompanyName>' +
//                           '<v3:PhoneNumber>2128689280</v3:PhoneNumber>' +
//                           '<v3:EMailAddress>sales@silk-crafts.com</v3:EMailAddress>' +
//                        '</v3:Contact>' +
//                        '<v3:Address>' +
//                           //'<v3:StreetLines>4 TAYLOR STREET</v3:StreetLines>'+
//                           //'<v3:City>MILLBURN</v3:City>'+
//                           //'<v3:StateOrProvinceCode>NJ</v3:StateOrProvinceCode>'+
//                           //'<v3:PostalCode>07041</v3:PostalCode>'+
//                           //'<v3:CountryCode>US</v3:CountryCode>'+
//                           '<v3:StreetLines>145 Michael Drive</v3:StreetLines>' +
//                           '<v3:City>Syosset</v3:City>' +
//                           '<v3:StateOrProvinceCode>NY</v3:StateOrProvinceCode>' +
//                           '<v3:PostalCode>11791</v3:PostalCode>' +
//                          ' <v3:CountryCode>US</v3:CountryCode>' +
//                        '</v3:Address>' +
//                     '</v3:PickupLocation>' +
//                     '<v3:ReadyTimestamp>2015-01-05T17:00:00</v3:ReadyTimestamp>' +
//                     '<v3:CompanyCloseTime>21:00:00</v3:CompanyCloseTime>' +
//                  '</v3:OriginDetail>' +
//                  '<v3:PackageCount>1</v3:PackageCount>' +
//                  '<v3:TotalWeight>' +
//                     '<v3:Units>KG</v3:Units>' +
//                     '<v3:Value>1.0</v3:Value>' +
//                  '</v3:TotalWeight>' +
//                  '<v3:CarrierCode>FDXE</v3:CarrierCode>' +
//                  '<v3:OversizePackageCount>1</v3:OversizePackageCount>' +
//                  '<v3:Remarks>Test Pick up Please ignore </v3:Remarks>' +
//                  '<v3:CommodityDescription>Freight</v3:CommodityDescription>' +
//                  '<v3:CountryRelationship>INTERNATIONAL</v3:CountryRelationship>' +
//               '</v3:CreatePickupRequest>' +
//            '</soapenv:Body>' +
//         '</soapenv:Envelope>');
//         IF ISCLEAR(locautXmlDoc1) THEN
//             Result1 := CREATE(locautXmlDoc1, TRUE, TRUE);

//         locautXmlDoc1.load(Xmlhttp.responseXML);
//         Position := STRPOS(Xmlhttp.responseText(), '<v6:CustomerTransactionId>');
//         //ResultNode := locautXmlDoc.selectNodes('soapenv:Envelope');
//         Position := Position + 26;
//         Position1 := STRPOS(Xmlhttp.responseText(), '</v6:CustomerTransactionId>');
//         //getAllResponseHeaders := COPYSTR(Xmlhttp.responseText(), Position, Position1-Position);

//         locautXmlDoc1.save('C:\Users\Admin\Desktop\FXO_Advanced_cs\XMLResponse1.txt');
//         MESSAGE('%1', Xmlhttp.responseText());
//     end;


//     procedure TrackingRequest(recSalesHeader: Record "Sales Shipment Header")
//     begin
//         IF ISCLEAR(Xmlhttp) THEN
//             Result := CREATE(Xmlhttp, TRUE, TRUE);
//         //ELSE
//         //Result:=Create(Xmlhttp,TRUE);
//         Xmlhttp.open('POST', ' https://wsbeta.fedex.com:443/web-services', 0);//'https://wsbeta.fedex.com:443/web-services',0);




//         Xmlhttp.send('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v6="http://fedex.com/ws/track/v6">' +
//            '<soapenv:Header/>' +
//            '<soapenv:Body>' +
//               '<v6:TrackRequest>' +
//                  '<v6:WebAuthenticationDetail>' +
//                     '<v6:UserCredential>' +
//                        '<v6:Key>' + Key + '</v6:Key>' +
//                        '<v6:Password>' + Password + '</v6:Password>' +
//                     '</v6:UserCredential>' +
//                  '</v6:WebAuthenticationDetail>' +
//                  '<v6:ClientDetail>' +
//                     '<v6:AccountNumber>' + AccountNo + '</v6:AccountNumber>' +
//                     '<v6:MeterNumber>' + MeterNo + '</v6:MeterNumber>' +
//                  '</v6:ClientDetail>' +
//                  '<v6:TransactionDetail>' +
//                     '<v6:CustomerTransactionId>Customer tracking</v6:CustomerTransactionId>' +
//                  '</v6:TransactionDetail>' +
//                  '<v6:Version>' +
//                     '<v6:ServiceId>trck</v6:ServiceId>' +
//                     '<v6:Major>6</v6:Major>' +
//                     '<v6:Intermediate>0</v6:Intermediate>' +
//                     '<v6:Minor>0</v6:Minor>' +
//                  '</v6:Version>' +
//                  '<v6:CarrierCode>FDXE</v6:CarrierCode>' +
//                  '<v6:PackageIdentifier>' +
//                     '<v6:Value>' + recSalesHeader."Tracking No." + '</v6:Value>' +
//                     '<v6:Type>TRACKING_NUMBER_OR_DOORTAG</v6:Type>' +//TRACKING_NUMBER_OR_DOORTAG
//                  '</v6:PackageIdentifier>' +
//                  '<v6:IncludeDetailedScans>true</v6:IncludeDetailedScans>' +
//                  '</v6:TrackRequest>' +
//            '</soapenv:Body>' +
//         '</soapenv:Envelope>');


//         IF ISCLEAR(locautXmlDoc1) THEN
//             Result1 := CREATE(locautXmlDoc1, TRUE, TRUE);

//         locautXmlDoc1.load(Xmlhttp.responseXML);
//         Position := STRPOS(Xmlhttp.responseText(), '<Severity>');
//         //ResultNode := locautXmlDoc.selectNodes('soapenv:Envelope');
//         Position := Position + 10;
//         Position1 := STRPOS(Xmlhttp.responseText(), '</Severity>');
//         getAllResponseHeaders := COPYSTR(Xmlhttp.responseText(), Position, Position1 - Position);
//         locautXmlDoc1.save('C:\Users\Admin\Desktop\FXO_Advanced_cs\TrackingResponse.xml');
//         MESSAGE('%1', Xmlhttp.responseText());
//         recSalesHeader."Tracking Status" := getAllResponseHeaders;
//         recSalesHeader.MODIFY(FALSE);
//     end;


//     procedure CashOnDelivery(SalesHeader: Record "Sales Header")
//     var
//         recSalesHeader: Record "Sales Header";
//         recLocation: Record Location;
//         recSalesLine: Record "Sales Line";
//     begin
//         recSalesHeader := SalesHeader;
//         IF ISCLEAR(Xmlhttp) THEN
//             Result := CREATE(Xmlhttp, TRUE, TRUE);
//         //ELSE
//         //Result:=Create(Xmlhttp,TRUE);
//         Xmlhttp.open('POST', ' https://wsbeta.fedex.com:443/web-services', 0);//'https://wsbeta.fedex.com:443/web-services',0);
//         Xmlhttp.send('<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns="http://fedex.com/ws/ship/v12">' +
//         '<SOAP-ENV:Header/>' +
//         '<SOAP-ENV:Body>' +
//         '<ProcessShipmentRequest>' +
//         '<WebAuthenticationDetail>' +
//         '<UserCredential>' +
//         '<Key>K43TcvGLqW7cyltY</Key>' +
//         '<Password>MyLPw6Mk4n2snENVB9Ls9vC9q</Password>' +
//         '</UserCredential>' +
//         '</WebAuthenticationDetail>' +
//         '<ClientDetail>' +
//         '<AccountNumber>510087704</AccountNumber>' +
//         '<MeterNumber>118631944</MeterNumber>' +
//         '</ClientDetail>' +
//         '<TransactionDetail>' +
//         '<CustomerTransactionId>Ship_International_basic</CustomerTransactionId>' +
//         '</TransactionDetail>' +
//         '<Version>' +
//         '<ServiceId>ship</ServiceId>' +
//         '<Major>12</Major>' +
//         '<Intermediate>1</Intermediate>' +
//         '<Minor>0</Minor>' +
//         '</Version>' +
//         '<RequestedShipment>' +
//         '<ShipTimestamp>2015-01-05T09:30:47-05:00</ShipTimestamp>' +
//         '<DropoffType>REGULAR_PICKUP</DropoffType>' +
//         '<ServiceType>STANDARD_OVERNIGHT</ServiceType>' +
//         '<PackagingType>YOUR_PACKAGING</PackagingType>' +
//         '<Shipper>' +
//         '<AccountNumber>510087704</AccountNumber>' +
//         '<Contact>' +
//         '<PersonName>Abhay</PersonName>' +
//         '<CompanyName>Syntel</CompanyName>' +
//         '<PhoneNumber>9822280721</PhoneNumber>' +
//         '<EMailAddress>abhay_palaskar@syntelinc.com</EMailAddress>' +
//         '</Contact>' +
//         '<Address>' +
//         '<StreetLines>Test Sender Address Line1</StreetLines>' +
//         '<City>PUNE</City>' +
//         '<StateOrProvinceCode>MH</StateOrProvinceCode>' +
//         '<PostalCode>411011</PostalCode>' +
//         '<CountryCode>IN</CountryCode>' +
//         '</Address>' +
//         '</Shipper>' +
//         '<Recipient>' +
//         '<AccountNumber>150067600</AccountNumber>' +
//         '<Contact>' +
//         '<PersonName>Abhay_shipper</PersonName>' +
//         '<CompanyName>Syntel</CompanyName>' +
//         '<PhoneNumber>9822280721</PhoneNumber>' +
//         '<EMailAddress>abhay_palaskar@syntelinc.com</EMailAddress>' +
//         '</Contact>' +
//         '<Address>' +
//         '<StreetLines>Recipient Address Line1</StreetLines>' +
//         '<City>NEWDELHI</City>' +
//         '<StateOrProvinceCode>DL</StateOrProvinceCode>' +
//         '<PostalCode>110010</PostalCode>' +
//         '<CountryCode>IN</CountryCode>' +
//         '</Address>' +
//         '</Recipient>' +
//         '<ShippingChargesPayment>' +
//         '<PaymentType>SENDER</PaymentType>' +
//         '<Payor>' +
//         '<ResponsibleParty>' +
//         '<AccountNumber>510087704</AccountNumber>' +
//         '<Contact>' +
//         '<PersonName>Abhay_Recipient</PersonName>' +
//         '<EMailAddress>abhay_palaskar@syntelinc.com</EMailAddress>' +
//         '</Contact>' +
//         '</ResponsibleParty>' +
//         '</Payor>' +
//         '</ShippingChargesPayment>' +
//         '<SpecialServicesRequested>' +
//         '<SpecialServiceTypes>COD</SpecialServiceTypes>' +
//         '<SpecialServiceTypes>DELIVERY_ON_INVOICE_ACCEPTANCE</SpecialServiceTypes>' +
//         '<CodDetail>' +
//         '<CodCollectionAmount>' +
//         '<Currency>INR</Currency>' +
//         '<Amount>100.00</Amount>' +
//         '</CodCollectionAmount>' +
//         '<CollectionType>CASH</CollectionType>' +
//         '<FinancialInstitutionContactAndAddress>' +
//         '<Contact>' +
//         '<PersonName>Radhika</PersonName>' +
//         '<CompanyName>SYNTEL</CompanyName>' +
//         '<PhoneNumber>9922184679</PhoneNumber>' +
//         '</Contact>' +
//         '<Address>' +
//         '<StreetLines>Recipient Address Line1</StreetLines>' +
//         '<City>NEWDELHI</City>' +
//         '<StateOrProvinceCode>DL</StateOrProvinceCode>' +
//         '<PostalCode>110010</PostalCode>' +
//         '<CountryCode>IN</CountryCode>' +
//         '</Address>' +
//         '</FinancialInstitutionContactAndAddress>' +
//         '<RemitToName>Sachin</RemitToName>' +
//         '</CodDetail>' +
//         '<DeliveryOnInvoiceAcceptanceDetail>' +
//         '<Recipient>' +
//         '<AccountNumber>150067600</AccountNumber>' +
//         '<Contact>' +
//         '<PersonName>RECIPIENT</PersonName>' +
//         '<CompanyName>KCORP</CompanyName>' +
//         '<PhoneNumber>9412491533</PhoneNumber>' +
//         '</Contact>' +
//         '<Address>' +
//         '<StreetLines>Recipient Address Line1</StreetLines>' +
//         '<City>NEWDELHI</City>' +
//         '<StateOrProvinceCode>DL</StateOrProvinceCode>' +
//         '<PostalCode>110010</PostalCode>' +
//         '<CountryCode>IN</CountryCode>' +
//         '</Address>' +
//         '</Recipient>' +
//         '</DeliveryOnInvoiceAcceptanceDetail>' +
//         '</SpecialServicesRequested>' +
//         '<CustomsClearanceDetail>' +
//         '<DutiesPayment>' +
//         '<PaymentType>SENDER</PaymentType>' +
//         '<Payor>' +
//         '<ResponsibleParty>' +
//         '<AccountNumber>756942735</AccountNumber>' +
//         '<Tins>' +
//         '<TinType>PERSONAL_STATE</TinType>' +
//         '<Number>1057</Number>' +
//         '<Usage>ShipperTinsUsage</Usage>' +
//         '</Tins>' +
//         '<Contact>' +
//         '<ContactId>RBB1057</ContactId>' +
//         '<PersonName>ALPHA AND BRAVO BUILDINGS</PersonName>' +
//         '<Title>abc</Title>' +
//         '<CompanyName>Fedex</CompanyName>' +
//         '<PhoneNumber>9762308621</PhoneNumber>' +
//         '<PhoneExtension>02033469</PhoneExtension>' +
//         '<PagerNumber>9762308621</PagerNumber>' +
//         '<FaxNumber>9762308621</FaxNumber>' +
//         '<EMailAddress>Radhika_Margam@syntelinc.com</EMailAddress>' +
//         '</Contact>' +
//         '<Address>' +
//         '<StreetLines>Test Sender Address Line1</StreetLines>' +
//         '<City>PUNE</City>' +
//         '<StateOrProvinceCode>MH</StateOrProvinceCode>' +
//         '<PostalCode>411011</PostalCode>' +
//         '<CountryCode>IN</CountryCode>' +
//         '</Address>' +
//         '</ResponsibleParty>' +
//         '</Payor>' +
//         '</DutiesPayment>' +
//         '<DocumentContent>NON_DOCUMENTS</DocumentContent>' +
//         '<CustomsValue>' +
//         '<Currency>INR</Currency>' +
//         '<Amount>100.000000</Amount>' +
//         '</CustomsValue>' +
//         '<CommercialInvoice>' +
//         '<Purpose>SOLD</Purpose>' +
//         '<CustomerReferences>' +
//         '<CustomerReferenceType>CUSTOMER_REFERENCE</CustomerReferenceType>' +
//         '<Value>1234</Value>' +
//         '</CustomerReferences>' +
//         '</CommercialInvoice>' +
//         '<Commodities>' +
//         '<Name>String</Name>' +
//         '<NumberOfPieces>1</NumberOfPieces>' +
//         '<Description>ABCD</Description>' +
//         '<CountryOfManufacture>US</CountryOfManufacture>' +
//         '<Weight>' +
//         '<Units>LB</Units>' +
//         '<Value>10.0</Value>' +
//         '</Weight>' +
//         '<Quantity>1</Quantity>' +
//         '<QuantityUnits>EA</QuantityUnits>' +
//         '<UnitPrice>' +
//         '<Currency>INR</Currency>' +
//         '<Amount>1.000000</Amount>' +
//         '</UnitPrice>' +
//         '<CustomsValue>' +
//         '<Currency>INR</Currency>' +
//         '<Amount>100.000000</Amount>' +
//         '</CustomsValue>' +
//         '</Commodities>' +
//         '</CustomsClearanceDetail>' +
//         '<LabelSpecification>' +
//         '<LabelFormatType>COMMON2D</LabelFormatType>' +
//         '<ImageType>PNG</ImageType>' +
//         '</LabelSpecification>' +
//         '<RateRequestTypes>ACCOUNT</RateRequestTypes>' +
//         '<PackageCount>1</PackageCount>' +
//         '<RequestedPackageLineItems>' +
//         '<SequenceNumber>1</SequenceNumber>' +
//         '<Weight>' +
//         '<Units>LB</Units>' +
//         '<Value>10</Value>' +
//         '</Weight>' +
//         '<Dimensions>' +
//         '<Length>5</Length>' +
//         '<Width>5</Width>' +
//         '<Height>5</Height>' +
//         '<Units>IN</Units>' +
//         '</Dimensions>' +
//         '<PhysicalPackaging>BAG</PhysicalPackaging>' +
//         '<ItemDescription>Book</ItemDescription>' +
//         '<CustomerReferences>' +
//         '<CustomerReferenceType>CUSTOMER_REFERENCE</CustomerReferenceType>' +
//         '<Value>NAFTA_COO</Value>' +
//         '</CustomerReferences>' +
//         '</RequestedPackageLineItems>' +
//         '</RequestedShipment>' +
//         '</ProcessShipmentRequest>' +
//         '</SOAP-ENV:Body>' +
//         '</SOAP-ENV:Envelope>');
//         IF ISCLEAR(locautXmlDoc1) THEN
//             Result1 := CREATE(locautXmlDoc1, TRUE, TRUE);

//         locautXmlDoc1.load(Xmlhttp.responseXML);
//         Position := STRPOS(Xmlhttp.responseText(), '<v12:Image>');
//         //ResultNode := locautXmlDoc.selectNodes('soapenv:Envelope');
//         Position := Position + 26;
//         Position1 := STRPOS(Xmlhttp.responseText(), '</v12:Image>');
//         //getAllResponseHeaders := COPYSTR(Xmlhttp.responseText(), Position, Position1-Position);
//         //responseStream:=Xmlhttp.responseStream;
//         Picture1.ADDTEXT(Xmlhttp.responseText());
//         Picture.GETSUBTEXT(Picture1, Position, Position1 - Position);
//         //Picture.GETSUBTEXT(Xmlhttp.responseText(), Position, Position1-Position);
//         //Company.GET;
//         //Bytes:=Convert.FromBase64String(Picture);
//         //Company.Description.CREATEOUTSTREAM(OStream);
//         //MemoryStream.WriteTo(OStream);

//         locautXmlDoc1.save('C:\Users\Admin\Desktop\FXO_Advanced_cs\XMLResponse1.txt');
//         MESSAGE('%1', Xmlhttp.responseText());
//         //MESSAGE('%1',responseStream);
//     end;


//     procedure RateRequest(recSalesHeader: Record "Sales Header")
//     var
//         recCustomer: Record Customer;
//         txtPaymentType: Text[30];
//         ResponsibleCountry: Code[10];
//         ResponsiblePost: Code[20];
//         ResponsibleState: Code[20];
//         ResponsibleCity: Code[20];
//         ResponsibleAddress: Text[50];
//         ResponsiblePhone: Text[30];
//         ResponsibleCompany: Text[50];
//         ResponsibleEmail: Text[30];
//         ResponsiblePerson: Text[30];
//         ResponsibleAccNo: Text[30];
//         decNetWeigh: Decimal;
//         recSalesLine: Record "Sales Line";
//         decAmount: Decimal;
//         txtAmount: Text[25];
//     begin
//         recCompanyInfo.GET;
//         recCustomer.GET(recSalesHeader."Sell-to Customer No.");
//         recLocation.GET(recSalesHeader."Location Code");
//         recSalesLine.RESET;
//         recSalesLine.SETRANGE("Document No.", recSalesHeader."No.");
//         IF recSalesLine.FIND('-') THEN BEGIN
//             REPEAT
//                 decNetWeigh += recSalesLine.Quantity;
//             UNTIL recSalesLine.NEXT = 0;
//         END;
//         IF ISCLEAR(Xmlhttp) THEN
//             Result := CREATE(Xmlhttp, TRUE, TRUE);

//         IF recSalesHeader."Charges Pay By" = recSalesHeader."Charges Pay By"::SENDER THEN BEGIN
//             ResponsibleAccNo := '510087704';
//             ResponsiblePerson := recLocation.Contact;
//             ResponsibleEmail := recLocation."E-Mail";
//             ResponsibleCompany := recCompanyInfo.Name;
//             ResponsiblePhone := recLocation."Phone No.";
//             ResponsibleAddress := recLocation.Address;
//             ResponsibleCity := recLocation.City;
//             ResponsibleState := recLocation.County;
//             ResponsiblePost := recLocation."Post Code";
//             ResponsibleCountry := recLocation."Country/Region Code";
//         END ELSE BEGIN
//             ResponsibleAccNo := '510087704';
//             ResponsiblePerson := recCustomer.Contact;
//             ResponsibleEmail := recCustomer."E-Mail";
//             ResponsibleCompany := recCustomer.Name;
//             ResponsiblePhone := recCustomer."Phone No.";
//             ResponsibleAddress := recCustomer.Address;
//             ResponsibleCity := recCustomer.City;
//             ResponsibleState := recCustomer.County;
//             ResponsiblePost := recCustomer."Post Code";
//             ResponsibleCountry := recCustomer."Country/Region Code";
//         END;
//         //ELSE
//         //Result:=Create(Xmlhttp,TRUE);
//         txtPaymentType := FORMAT(recSalesHeader."Charges Pay By");
//         Xmlhttp.open('POST', ' https://wsbeta.fedex.com:443/web-services', 0);//'https://wsbeta.fedex.com:443/web-services',0);



//         Xmlhttp.send('<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"' +
//         'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://fedex.com/ws/rate/v13">' +
//            '<SOAP-ENV:Body>' +
//               '<RateRequest>' +
//                  '<WebAuthenticationDetail>' +
//                     '<UserCredential>' +
//                        '<Key>' + Key + '</Key>' +
//                        '<Password>' + Password + '</Password>' +
//                     '</UserCredential>' +
//                  '</WebAuthenticationDetail>' +
//                  '<ClientDetail>' +
//                   '<AccountNumber>' + AccountNo + '</AccountNumber>' +
//                   '<MeterNumber>' + MeterNo + '</MeterNumber>' +
//                  '</ClientDetail>' +
//                  '<TransactionDetail>' +
//                     '<CustomerTransactionId>TC21_USUS_E20011_Serpk_Curr+_POS</CustomerTransactionId>' +
//                  '</TransactionDetail>' +
//                  '<Version>' +
//                     '<ServiceId>crs</ServiceId>' +
//                     '<Major>13</Major>' +
//                     '<Intermediate>0</Intermediate>' +
//                     '<Minor>0</Minor>' +
//                  '</Version>' +
//                  '<RequestedShipment>' +
//                     '<ShipTimestamp>2013-08-19T09:30:47-05:00</ShipTimestamp>' +
//                     '<DropoffType>REGULAR_PICKUP</DropoffType>' +
//                     '<ServiceType>STANDARD_OVERNIGHT</ServiceType>' +
//                     '<PackagingType>YOUR_PACKAGING</PackagingType>' +
//                     '<TotalWeight>' +
//                        '<Units>KG</Units>' +
//                        '<Value>1</Value>' +
//                     '</TotalWeight>' +
//                     '<Shipper>' +
//                        '<AccountNumber>510087860</AccountNumber>' +
//                        '<Contact>' +
//                           '<CompanyName>Bluegarage</CompanyName>' +
//                           '<PhoneNumber>1234567890</PhoneNumber>' +
//                        '</Contact>' +
//                        '<Address>' +
//                           '<StreetLines>Test Sender Address Line1</StreetLines>' +
//                           '<City>Bangalore</City>' +
//                           '<StateOrProvinceCode>KA</StateOrProvinceCode>' +
//                           '<PostalCode>560001</PostalCode>' +
//                           '<CountryCode>IN</CountryCode>' +
//                        '</Address>' +
//                     '</Shipper>' +
//                     '<Recipient>' +
//                        '<AccountNumber>510087860</AccountNumber>' +
//                        '<Contact>' +
//                           '<PersonName>Recipient Contact</PersonName>' +
//                           '<PhoneNumber>1234567890</PhoneNumber>' +
//                        '</Contact>' +
//                        '<Address>' +
//                           '<StreetLines>Recipient Address Line1</StreetLines>' +
//                           '<City>Bangalore</City>' +
//                           '<StateOrProvinceCode>KA</StateOrProvinceCode>' +
//                           '<PostalCode>560024</PostalCode>' +
//                           '<CountryCode>IN</CountryCode>' +
//                        '</Address>' +
//                     '</Recipient>' +
//                     '<ShippingChargesPayment>' +
//                        '<PaymentType>SENDER</PaymentType>' +
//                        '<Payor>' +
//                           '<ResponsibleParty>' +
//                              '<AccountNumber>510087860</AccountNumber>' +
//                              '<Tins>' +
//                                 '<TinType>BUSINESS_STATE</TinType>' +
//                                 '<Number>123456</Number>' +
//                              '</Tins>' +
//                           '</ResponsibleParty>' +
//                        '</Payor>' +
//                     '</ShippingChargesPayment>' +
//                     '<CustomsClearanceDetail>' +
//                        '<DutiesPayment>' +
//                           '<PaymentType>SENDER</PaymentType>' +
//                           '<Payor>' +
//                              '<ResponsibleParty>' +
//                                 '<AccountNumber>510087860</AccountNumber>' +
//                                 '<Tins>' +
//                                    '<TinType>PERSONAL_STATE</TinType>' +
//                                    '<Number>1057</Number>' +
//                                    '<Usage>ShipperTinsUsage</Usage>' +
//                                 '</Tins>' +
//                                 '<Contact>' +
//                                    '<ContactId>RBB1057</ContactId>' +
//                                    '<PersonName>ALPHA AND BRAVO BUILDINGS</PersonName>' +
//                                    '<Title>abc</Title>' +
//                                    '<CompanyName>Fedex</CompanyName>' +
//                                    '<PhoneNumber>9762308621</PhoneNumber>' +
//                                    '<PhoneExtension>02033469</PhoneExtension>' +
//                                    '<PagerNumber>9762308621</PagerNumber>' +
//                                    '<FaxNumber>9762308621</FaxNumber>' +
//                                    '<EMailAddress>468906@fedex.com</EMailAddress>' +
//                                 '</Contact>' +
//                                 '<Address>' +
//                                    '<StreetLines>Test Sender Address Line1</StreetLines>' +
//                                    '<City>Bangalore</City>' +
//                                    '<StateOrProvinceCode>KA</StateOrProvinceCode>' +
//                                    '<PostalCode>560024</PostalCode>' +
//                                    '<CountryCode>IN</CountryCode>' +
//                                 '</Address>' +
//                              '</ResponsibleParty>' +
//                           '</Payor>' +
//                        '</DutiesPayment>' +
//                        '<DocumentContent>NON_DOCUMENTS</DocumentContent>' +
//                        '<CustomsValue>' +
//                           '<Currency>INR</Currency>' +
//                           '<Amount>100.000000</Amount>' +
//                        '</CustomsValue>' +
//                        '<CommercialInvoice>' +
//                           '<Purpose>SOLD</Purpose>' +
//                        '</CommercialInvoice>' +
//                        '<Commodities>' +
//                           '<Name>String</Name>' +
//                           '<NumberOfPieces>1</NumberOfPieces>' +
//                           '<Description>ABCD</Description>' +
//                           '<CountryOfManufacture>US</CountryOfManufacture>' +
//                           '<Weight>' +
//                              '<Units>KG</Units>' +
//                              '<Value>1.0</Value>' +
//                           '</Weight>' +
//                           '<Quantity>1</Quantity>' +
//                           '<QuantityUnits>EA</QuantityUnits>' +
//                           '<UnitPrice>' +
//                              '<Currency>INR</Currency>' +
//                              '<Amount>1.000000</Amount>' +
//                           '</UnitPrice>' +
//                           '<CustomsValue>' +
//                              '<Currency>INR</Currency>' +
//                              '<Amount>100.000000</Amount>' +
//                           '</CustomsValue>' +
//                        '</Commodities>' +
//                     '</CustomsClearanceDetail>' +
//                     '<RateRequestTypes>ACCOUNT</RateRequestTypes>' +
//                     '<PackageCount>1</PackageCount>' +
//                     '<RequestedPackageLineItems>' +
//                        '<SequenceNumber>1</SequenceNumber>' +
//                        '<GroupNumber>1</GroupNumber>' +
//                        '<GroupPackageCount>1</GroupPackageCount>' +
//                        '<Weight>' +
//                           '<Units>KG</Units>' +
//                           '<Value>1.0</Value>' +
//                        '</Weight>' +
//                        '<Dimensions>' +
//                           '<Length>12</Length>' +
//                           '<Width>12</Width>' +
//                           '<Height>12</Height>' +
//                           '<Units>IN</Units>' +
//                        '</Dimensions>' +
//                        '<ContentRecords>' +
//                           '<PartNumber>123445</PartNumber>' +
//                           '<ItemNumber>kjdjalsro1262739827</ItemNumber>' +
//                           '<ReceivedQuantity>12</ReceivedQuantity>' +
//                           '<Description>ContentDescription</Description>' +
//                        '</ContentRecords>' +
//                     '</RequestedPackageLineItems>' +
//                  '</RequestedShipment>' +
//               '</RateRequest>' +
//            '</SOAP-ENV:Body>' +
//         '</SOAP-ENV:Envelope>');
//         IF ISCLEAR(locautXmlDoc1) THEN
//             Result1 := CREATE(locautXmlDoc1, TRUE, TRUE);
//         MESSAGE('%1', Xmlhttp.responseText());
//         locautXmlDoc1.load(Xmlhttp.responseXML);
//         Position := STRPOS(Xmlhttp.responseText(), '<v12:Image>');
//         //ResultNode := locautXmlDoc.selectNodes('soapenv:Envelope');
//         Position := Position + 11;
//         Position1 := STRPOS(Xmlhttp.responseText(), '</v12:Image>');
//         CLEAR(Picture1);
//         Picture1.ADDTEXT(Xmlhttp.responseText());
//         Picture1.GETSUBTEXT(Picture1, Position, Position1 - Position);
//         //text1:='HelloSandeep';

//         locautXmlDoc1.save('C:\Users\Admin\Desktop\FXO_Advanced_cs\XMLResponse.xml');

//         Position := STRPOS(Xmlhttp.responseText(), '<v12:TotalNetFedExCharge>');
//         //ResultNode := locautXmlDoc.selectNodes('soapenv:Envelope');
//         Position := Position + 69;
//         Position1 := STRPOS(Xmlhttp.responseText(), '</v12:Amount></v12:TotalNetFedExCharge>');
//         txtAmount := COPYSTR(Xmlhttp.responseText(), Position, Position1 - Position);
//         EVALUATE(decAmount, txtAmount);
//         recSalesHeader."Tracking No." := txtAmount;
//         recSalesHeader.MODIFY;
//     end;


//     procedure StandardOverNight1(recWhsShipHeader: Record "Warehouse Shipment Header")
//     var
//         recCustomer: Record Customer;
//         txtPaymentType: Text[30];
//         ResponsibleCountry: Code[10];
//         ResponsiblePost: Code[20];
//         ResponsibleState: Code[20];
//         ResponsibleCity: Code[20];
//         ResponsibleAddress: Text[50];
//         ResponsiblePhone: Text[30];
//         ResponsibleCompany: Text[50];
//         ResponsibleEmail: Text[50];
//         ResponsiblePerson: Text[50];
//         ResponsibleAccNo: Text[30];
//         decNetWeigh: Decimal;
//         recSalesLine: Record "Sales Line";
//         decAmount: Decimal;
//         txtAmount: Text[25];
//         recSalesHeader: Record "Sales Header";
//         recWhseShipLine: Record "Warehouse Shipment Line";
//         recBoxMaster: Record "Box Master";
//         txtPackageDetail: BigText;
//         intNo: Integer;
//         txtPackagedet: array[5] of Text[1000];
//         intLength: Integer;
//         SalesRelease: Codeunit "Release Sales Document";
//         txtMessage: Text[500];
//         txtYear: Text[10];
//         txtMonth: Text[10];
//         txtDate: Text[10];
//         intDate: Integer;
//         intMonth: Integer;
//         intYear: Integer;
//         recShipAgentService: Record "Shipping Agent Services";
//         txtShipService: Text[100];
//         recShiptoAddress: Record "Ship-to Address";
//         ShiptoName: Text[50];
//         ShiptoAddress: Text[50];
//         ShiptoAddress2: Text[50];
//         ShiptoEmail: Text[50];
//         ShiptoPhone: Text[30];
//         ShiptoState: Text[30];
//         ShiptoCountry: Text[30];
//         ShiptoPostCode: Text[30];
//         ShiptoContact: Text[50];
//         ShiptoAccount: Code[20];
//         ShiptoCity: Text[30];
//         txtShipTime: Text[50];
//         intLineNo: Integer;
//         recSalesShipHeader: Record "Sales Shipment Header";
//         WhseSetup: Record "Warehouse Setup";
//         SpecialServiceTxt: array[10] of Text[1000];
//     begin
//         //recSalesHeader:=SalesHeader;
//         //recSalesHeader;


//         IF recWhsShipHeader."Track On Header" THEN BEGIN
//             recWhseShipLine.RESET;
//             recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
//             IF recWhseShipLine.FIND('-') THEN;
//             intDate := DATE2DMY(recWhsShipHeader."Shipment Date", 1);
//             intMonth := DATE2DMY(recWhsShipHeader."Shipment Date", 2);
//             intYear := DATE2DMY(recWhsShipHeader."Shipment Date", 3);
//             txtDate := FORMAT(intDate);
//             txtMonth := FORMAT(intMonth);
//             txtYear := FORMAT(intYear);
//             IF intYear < 100 THEN
//                 txtYear := '20' + txtYear;
//             IF STRLEN(txtMonth) < 2 THEN
//                 txtMonth := '0' + txtMonth;
//             IF STRLEN(txtDate) < 2 THEN
//                 txtDate := '0' + txtDate;
//             recSalesHeader.RESET;
//             IF recSalesHeader.GET(recWhseShipLine."Source Subtype", recWhseShipLine."Source No.") THEN;
//             recCompanyInfo.GET;
//             IF recSalesHeader."Ship-to Code" <> '' THEN BEGIN

//                 recCustomer.GET(recSalesHeader."Sell-to Customer No.");
//                 recShiptoAddress.GET(recSalesHeader."Sell-to Customer No.", recSalesHeader."Ship-to Code");
//                 ShiptoName := recShiptoAddress.Name;
//                 ShiptoAddress := recShiptoAddress.Address;
//                 ShiptoAddress2 := recShiptoAddress."Address 2";
//                 ShiptoCity := recShiptoAddress.City;
//                 ShiptoState := recShiptoAddress.County;
//                 ShiptoAccount := recShiptoAddress."Shipping Account No.";
//                 IF ShiptoAccount = '' THEN
//                     ShiptoAccount := recCustomer."Shipping Account No.";
//                 IF recShiptoAddress."Third Party" THEN
//                     txtPaymentType := 'THIRD_PARTY';
//                 ShiptoPostCode := recShiptoAddress."Post Code";

//                 ShiptoCountry := recShiptoAddress."Country/Region Code";
//                 ShiptoEmail := recShiptoAddress."E-Mail";
//                 ShiptoContact := recShiptoAddress.Contact;
//                 ShiptoPhone := recShiptoAddress."Phone No.";

//             END ELSE BEGIN
//                 recCustomer.GET(recSalesHeader."Sell-to Customer No.");
//                 ShiptoName := recCustomer.Name;
//                 ShiptoAddress := recCustomer.Address;
//                 ShiptoAddress2 := recCustomer."Address 2";
//                 ShiptoCity := recCustomer.City;
//                 ShiptoState := recCustomer.County;
//                 ShiptoAccount := recCustomer."Shipping Account No.";
//                 ShiptoPostCode := recCustomer."Post Code";

//                 ShiptoCountry := recCustomer."Country/Region Code";
//                 ShiptoEmail := recCustomer."E-Mail";
//                 ShiptoContact := recCustomer.Contact;
//                 ShiptoPhone := recCustomer."Phone No.";

//             END;
//             recLocation.GET(recSalesHeader."Location Code");
//             /*recSalesLine.RESET;
//             recSalesLine.SETRANGE("Document No.",recSalesHeader."No.");
//             IF recSalesLine.FIND('-') THEN BEGIN
//               REPEAT
//                decNetWeigh+=recSalesLine.Quantity;
//               UNTIL recSalesLine.NEXT=0;
//              END;*/
//             CLEAR(txtPackageDetail);
//             recShipAgentService.GET(recWhsShipHeader."Shipping Agent Code", recWhsShipHeader."Shipping Agent Service Code");
//             txtShipService := recShipAgentService.Description;
//             recBoxMaster.RESET;
//             IF recBoxMaster.GET(recWhsShipHeader."Box Code") THEN;

//             decNetWeigh := 0;
//             intNo := 0;
//             TotalAmount := 0;
//             recWhseShipLine.RESET;
//             recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
//             recWhseShipLine.SETFILTER("Qty. to Ship", '<>%1', 0);
//             IF recWhseShipLine.FIND('-') THEN BEGIN
//                 REPEAT
//                     recItem.GET(recWhseShipLine."Item No.");
//                     decNetWeigh := decNetWeigh + recWhseShipLine."Qty. to Ship" * recItem.Weight;
//                     intNo += 1;
//                     recSalesLine.RESET;
//                     recSalesLine.SETRANGE("Document No.", recWhseShipLine."Source No.");
//                     recSalesLine.SETRANGE("Line No.", recWhseShipLine."Source Line No.");

//                     IF recSalesLine.FIND('-') THEN BEGIN
//                         REPEAT
//                             TotalAmount := TotalAmount + recWhseShipLine."Qty. to Ship" * recSalesLine."Unit Price";

//                         UNTIL recSalesLine.NEXT = 0;
//                     END;
//                 UNTIL recWhseShipLine.NEXT = 0;
//             END;
//             TotalAmount1 := '';

//             TotalAmount1 := FORMAT(TotalAmount);
//             IF recWhsShipHeader."COD Amount" <> 0 THEN
//                 TotalAmount1 := FORMAT(recWhsShipHeader."COD Amount");
//             TotalAmount1 := DELCHR(TotalAmount1, '=', ',');



//             IF recWhsShipHeader."Cash On Delivery" THEN BEGIN
//                 IF recWhsShipHeader."Signature Required" THEN
//                     txtDeliveryAcceptance := 'DELIVERY_ON_INVOICE_ACCEPTANCE'
//                 ELSE
//                     txtDeliveryAcceptance := '';
//                 CLEAR(SpecialService);

//                 IF recWhsShipHeader."Signature Required" THEN BEGIN
//                     SpecialService.ADDTEXT('<SpecialServicesRequested>' +
//                     '<SpecialServiceTypes>COD</SpecialServiceTypes>' +
//                     '<SpecialServiceTypes>DELIVERY_ON_INVOICE_ACCEPTANCE</SpecialServiceTypes>' +
//                     '<CodDetail>' +
//                     '<CodCollectionAmount>' +
//                     '<Currency>USD</Currency>' +
//                     '<Amount>' + TotalAmount1 + '</Amount>' +
//                     '</CodCollectionAmount>' +
//                     '<CollectionType>ANY</CollectionType>' +
//                     '<FinancialInstitutionContactAndAddress>' +
//                     '<Contact>' +
//                     '<PersonName>' + ShiptoContact + '</PersonName>' +
//                     '<CompanyName>' + ShiptoName + '</CompanyName>' +
//                     '<PhoneNumber>' + ShiptoPhone + '</PhoneNumber>' +
//                     '</Contact>' +
//                     '<Address>' +
//                     '<StreetLines>' + ShiptoAddress + ' ' + ShiptoAddress2 + '</StreetLines>' +
//                     '<City>' + ShiptoCity + '</City>' +
//                     '<StateOrProvinceCode>' + ShiptoState + '</StateOrProvinceCode>' +
//                     '<PostalCode>' + ShiptoPostCode + '</PostalCode>' +
//                     '<CountryCode>' + ShiptoCountry + '</CountryCode>' +
//                     '</Address>' +
//                     '</FinancialInstitutionContactAndAddress>' +
//                     '<RemitToName>' + ShiptoContact + '</RemitToName>' +
//                     '</CodDetail>' +
//                     '<DeliveryOnInvoiceAcceptanceDetail>' +
//                     '<Recipient>' +
//                     '<AccountNumber>' + ShiptoAccount + '</AccountNumber>' +
//                     '<Contact>' +
//                     '<PersonName>' + ShiptoContact + '</PersonName>' +
//                     '<CompanyName>' + COMPANYNAME + '</CompanyName>' +
//                     '<PhoneNumber>' + ShiptoPhone + '</PhoneNumber>' +
//                     '</Contact>' +
//                     '<Address>' +
//                     '<StreetLines>' + ShiptoAddress + ' ' + ShiptoAddress2 + '</StreetLines>' +
//                     '<City>' + ShiptoCity + '</City>' +
//                     '<StateOrProvinceCode>' + ShiptoState + '</StateOrProvinceCode>' +
//                     '<PostalCode>' + ShiptoPostCode + '</PostalCode>' +
//                     '<CountryCode>' + ShiptoCountry + '</CountryCode>' +
//                     '</Address>' +
//                     '</Recipient>' +
//                     '</DeliveryOnInvoiceAcceptanceDetail>' +
//                     '</SpecialServicesRequested>');
//                 END ELSE BEGIN
//                     SpecialService.ADDTEXT('<SpecialServicesRequested>' +
//                     '<SpecialServiceTypes>COD</SpecialServiceTypes>' +
//                     '<CodDetail>' +
//                     '<CodCollectionAmount>' +
//                     '<Currency>USD</Currency>' +
//                     '<Amount>' + TotalAmount1 + '</Amount>' +
//                     '</CodCollectionAmount>' +
//                     '<CollectionType>CASH</CollectionType>' +
//                     '<FinancialInstitutionContactAndAddress>' +
//                     '<Contact>' +
//                     '<PersonName>' + ShiptoContact + '</PersonName>' +
//                     '<CompanyName>' + ShiptoName + '</CompanyName>' +
//                     '<PhoneNumber>' + ShiptoPhone + '</PhoneNumber>' +
//                     '</Contact>' +
//                     '<Address>' +
//                     '<StreetLines>' + ShiptoAddress + ' ' + ShiptoAddress2 + '</StreetLines>' +
//                     '<City>' + ShiptoCity + '</City>' +
//                     '<StateOrProvinceCode>' + ShiptoState + '</StateOrProvinceCode>' +
//                     '<PostalCode>' + ShiptoPostCode + '</PostalCode>' +
//                     '<CountryCode>' + ShiptoCountry + '</CountryCode>' +
//                     '</Address>' +
//                     '</FinancialInstitutionContactAndAddress>' +
//                     '<RemitToName>' + ShiptoContact + '</RemitToName>' +
//                     '</CodDetail>' +
//                     '<DeliveryOnInvoiceAcceptanceDetail>' +
//                     '<Recipient>' +
//                     '<AccountNumber>' + ShiptoAccount + '</AccountNumber>' +
//                     '<Contact>' +
//                     '<PersonName>' + ShiptoContact + '</PersonName>' +
//                     '<CompanyName>' + COMPANYNAME + '</CompanyName>' +
//                     '<PhoneNumber>' + ShiptoPhone + '</PhoneNumber>' +
//                     '</Contact>' +
//                     '<Address>' +
//                     '<StreetLines>' + ShiptoAddress + ' ' + ShiptoAddress2 + '</StreetLines>' +
//                     '<City>' + ShiptoCity + '</City>' +
//                     '<StateOrProvinceCode>' + ShiptoState + '</StateOrProvinceCode>' +
//                     '<PostalCode>' + ShiptoPostCode + '</PostalCode>' +
//                     '<CountryCode>' + ShiptoCountry + '</CountryCode>' +
//                     '</Address>' +
//                     '</Recipient>' +
//                     '</DeliveryOnInvoiceAcceptanceDetail>' +
//                     '</SpecialServicesRequested>');

//                 END;
//             END;

//             intLen := SpecialService.LENGTH;
//             //Rahul
//             FOR intCount := 1 TO 10 DO BEGIN
//                 SpecialServiceTxt[intCount] := '';
//             END;
//             IF intLen <> 0 THEN
//                 SpecialService.GETSUBTEXT(SpecialServiceTxt[1], 1, 1000);
//             IF intLen > 1000 THEN
//                 SpecialService.GETSUBTEXT(SpecialServiceTxt[2], 1001, 2000);
//             IF intLen > 2000 THEN
//                 SpecialService.GETSUBTEXT(SpecialServiceTxt[3], 2001, 3000);
//             IF intLen > 3000 THEN
//                 SpecialService.GETSUBTEXT(SpecialServiceTxt[4], 3001, 4000);
//             IF intLen > 4000 THEN
//                 SpecialService.GETSUBTEXT(SpecialServiceTxt[5], 4001, 5000);
//             IF intLen > 5000 THEN
//                 SpecialService.GETSUBTEXT(SpecialServiceTxt[6], 5001, 6000);
//             IF intLen > 6000 THEN
//                 SpecialService.GETSUBTEXT(SpecialServiceTxt[7], 6001, 7000);
//             IF intLen > 7000 THEN
//                 SpecialService.GETSUBTEXT(SpecialServiceTxt[8], 7001, 8000);
//             IF intLen > 8000 THEN
//                 SpecialService.GETSUBTEXT(SpecialServiceTxt[9], 8001, 9000);
//             IF intLen > 9000 THEN
//                 SpecialService.GETSUBTEXT(SpecialServiceTxt[10], 9001, 10000);


//             intLength := 0;
//             intLength := txtPackageDetail.LENGTH;
//             IF intLength <> 0 THEN
//                 txtPackageDetail.GETSUBTEXT(txtPackagedet[1], 1, 1000);
//             IF intLength > 1000 THEN
//                 txtPackageDetail.GETSUBTEXT(txtPackagedet[2], 1001, 2000);
//             IF intLength > 2000 THEN
//                 txtPackageDetail.GETSUBTEXT(txtPackagedet[3], 2001, 3000);
//             IF intLength > 3000 THEN
//                 txtPackageDetail.GETSUBTEXT(txtPackagedet[4], 3001, 4000);
//             IF intLength > 4000 THEN
//                 txtPackageDetail.GETSUBTEXT(txtPackagedet[5], 4001, 5000);

//             IF ISCLEAR(Xmlhttp) THEN
//                 Result := CREATE(Xmlhttp, TRUE, TRUE);

//             IF recWhsShipHeader."Charges Pay By" = recWhsShipHeader."Charges Pay By"::SENDER THEN BEGIN
//                 ResponsibleAccNo := AccountNo;
//                 ResponsiblePerson := recLocation.Contact;
//                 ResponsibleEmail := recLocation."E-Mail";
//                 ResponsibleCompany := recCompanyInfo.Name;
//                 ResponsiblePhone := recLocation."Phone No.";
//                 ResponsibleAddress := recLocation.Address;
//                 ResponsibleCity := recLocation.City;
//                 ResponsibleState := recLocation.County;
//                 ResponsiblePost := recLocation."Post Code";
//                 ResponsibleCountry := recLocation."Country/Region Code";
//                 txtPaymentType := 'SENDER';
//             END ELSE BEGIN

//                 ResponsibleAccNo := recCustomer."Shipping Account No.";
//                 ResponsiblePerson := recCustomer.Contact;
//                 ResponsibleEmail := recCustomer."E-Mail";
//                 ResponsibleCompany := recCustomer.Name;
//                 ResponsiblePhone := recCustomer."Phone No.";
//                 ResponsibleAddress := recCustomer.Address;
//                 ResponsibleCity := recCustomer.City;
//                 ResponsibleState := recCustomer.County;
//                 ResponsiblePost := recCustomer."Post Code";
//                 ResponsibleCountry := recCustomer."Country/Region Code";
//                 IF txtPaymentType <> 'THIRD_PARTY' THEN
//                     txtPaymentType := 'RECIPIENT';
//             END;
//             decInsuredAmount := recWhsShipHeader."Insurance Amount";
//             IF decInsuredAmount <> 0 THEN
//                 txtInsuredAmount := DELCHR(FORMAT(decInsuredAmount), '=', ',')
//             ELSE
//                 txtInsuredAmount := '';
//             IF recWhsShipHeader."Insurance Amount" > 0 THEN BEGIN
//                 txtInsurance :=
//                 '<TotalInsuredValue>' +
//                         '<Currency>USD</Currency>' +
//                         '<Amount>' + (txtInsuredAmount) + '</Amount>' +
//                 '</TotalInsuredValue>'
//             END ELSE BEGIN
//                 txtInsurance := '';
//             END;
//             txtShipTime := FORMAT(recWhsShipHeader."Shipment Time", 8, '<Hours24,2>:<Minutes,2>:<Seconds,2>');
//             //ELSE
//             //Result:=Create(Xmlhttp,TRUE);
//             //txtPaymentType:=FORMAT(recSalesHeader."Charges Pay By");

//             Xmlhttp.open('POST', ' https://ws.fedex.com:443/web-services', 0);//'https://wsbeta.fedex.com:443/web-services',0);
//             Xmlhttp.send('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://fedex.com/ws/ship/v13">' +
//             '<soapenv:Body>' +
//             '<ProcessShipmentRequest xmlns="http://fedex.com/ws/ship/v13">' +
//             '<WebAuthenticationDetail>' +
//             '<UserCredential>' +
//             '<Key>' + Key + '</Key>' +
//             '<Password>' + Password + '</Password>' +
//             '</UserCredential>' +
//             '</WebAuthenticationDetail>' +
//             '<ClientDetail>' +
//             '<AccountNumber>' + AccountNo + '</AccountNumber>' +
//             '<MeterNumber>' + MeterNo + '</MeterNumber>' +
//             '</ClientDetail>' +
//             '<TransactionDetail>' +
//             '<CustomerTransactionId>' + recSalesHeader."No." + '</CustomerTransactionId>' +
//             '</TransactionDetail>' +
//             '<Version>' +
//             '<ServiceId>ship</ServiceId>' +
//             '<Major>13</Major>' +
//             '<Intermediate>0</Intermediate>' +
//             '<Minor>0</Minor>' +
//             '</Version>' +
//             '<RequestedShipment>' +
//             '<ShipTimestamp>' + txtYear + '-' + txtMonth + '-' + txtDate + 'T' + txtShipTime + '-05:00</ShipTimestamp>' +
//             '<DropoffType>REGULAR_PICKUP</DropoffType>' +
//             '<ServiceType>' + txtShipService + '</ServiceType>' +
//             '<PackagingType>YOUR_PACKAGING</PackagingType>' +
//             //'<TotalInsuredValue>'+
//             //      '<Currency>USD</Currency>'+
//             //    '<Amount>'+(TotalAmount1)+'</Amount>'+
//             txtInsurance +
//             // '<Amount>'+FORMAT(recWhsShipHeader."Insurance Charges")+'</Amount>'+


//             '<Shipper>' +
//             '<AccountNumber>' + AccountNo + '</AccountNumber>' +
//             '<Contact>' +
//             '<PersonName>' + recLocation.Contact + '</PersonName>' +
//             '<CompanyName>' + recCompeny.Name + '</CompanyName>' +
//             '<PhoneNumber>' + recLocation."Phone No." + '</PhoneNumber>' +
//             '<EMailAddress>' + recLocation."E-Mail" + '</EMailAddress>' +
//             '</Contact>' +
//             '<Address>' +
//             '<StreetLines>' + recLocation.Address + '</StreetLines>' +
//             '<City>' + recLocation.City + '</City>' +
//             '<StateOrProvinceCode>' + recLocation.County + '</StateOrProvinceCode>' +
//             '<PostalCode>' + recLocation."Post Code" + '</PostalCode>' +
//             '<CountryCode>' + recLocation."Country/Region Code" + '</CountryCode>' +
//             '</Address>' +
//             '</Shipper>' +
//             '<Recipient>' +
//             '<AccountNumber>' + ShiptoAccount + '</AccountNumber>' +
//             '<Contact>' +
//             '<PersonName>' + ShiptoContact + '</PersonName>' +
//             '<CompanyName>' + ShiptoName + '</CompanyName>' +
//             '<PhoneNumber>' + ShiptoPhone + '</PhoneNumber>' +
//             '<EMailAddress>' + ShiptoEmail + '</EMailAddress>' +
//             '</Contact>' +
//             '<Address>' +
//             '<StreetLines>' + ShiptoAddress + ' ' + ShiptoAddress2 + '</StreetLines>' +
//             '<City>' + ShiptoCity + '</City>' +
//             '<StateOrProvinceCode>' + ShiptoState + '</StateOrProvinceCode>' +
//             '<PostalCode>' + ShiptoPostCode + '</PostalCode>' +
//             '<CountryCode>' + ShiptoCountry + '</CountryCode>' +
//             '</Address>' +
//             '</Recipient>' +
//             '<ShippingChargesPayment>' +

//             '<PaymentType>' + txtPaymentType + '</PaymentType>' +
//             '<Payor>' +
//             '<ResponsibleParty>' +
//             '<AccountNumber>' + ResponsibleAccNo + '</AccountNumber>' +
//             '<Contact>' +
//             '<PersonName>' + ResponsiblePerson + '</PersonName>' +
//             '<EMailAddress>' + ResponsibleEmail + '</EMailAddress>' +
//             '</Contact>' +
//             '</ResponsibleParty>' +
//             '</Payor>' +
//             '</ShippingChargesPayment>' +
//             SpecialServiceTxt[1] + SpecialServiceTxt[2] + SpecialServiceTxt[3] + SpecialServiceTxt[4] + SpecialServiceTxt[5] +
//             SpecialServiceTxt[6] + SpecialServiceTxt[7] + SpecialServiceTxt[8] + SpecialServiceTxt[9] + SpecialServiceTxt[10] +
//             /*'<CustomsClearanceDetail>'+
//             '<DutiesPayment>'+
//             '<PaymentType>SENDER</PaymentType>'+
//             '<Payor>'+
//             '<ResponsibleParty>'+
//             '<AccountNumber>'+ResponsibleAccNo+'</AccountNumber>'+
//             '<Tins>'+
//             '<TinType>PERSONAL_STATE</TinType>'+
//             '<Number>1057</Number>'+
//             '<Usage>ShipperTinsUsage</Usage>'+
//             '</Tins>'+
//             '<Contact>'+
//             '<ContactId>RBB1057</ContactId>'+
//             '<PersonName>'+ResponsiblePerson+'</PersonName>'+
//             '<Title>abc</Title>'+
//             '<CompanyName>'+ResponsibleCompany+'</CompanyName>'+
//             '<PhoneNumber>'+ResponsiblePhone+'</PhoneNumber>'+
//             //'<PhoneExtension>02033469</PhoneExtension>'+
//             //'<PagerNumber>9900066979</PagerNumber>'+
//             //'<FaxNumber>9900066979</FaxNumber>'+
//             '<EMailAddress>'+ResponsibleEmail+'</EMailAddress>'+
//             '</Contact>'+
//             '<Address>'+
//             '<StreetLines>'+ResponsibleAddress+'</StreetLines>'+
//             '<City>'+ResponsibleCity+'</City>'+
//             '<StateOrProvinceCode>'+ResponsibleState+'</StateOrProvinceCode>'+
//             '<PostalCode>'+ResponsiblePost+'</PostalCode>'+
//             '<CountryCode>'+ResponsibleCountry+'</CountryCode>'+
//             '</Address>'+
//             '</ResponsibleParty>'+
//             '</Payor>'+
//             '</DutiesPayment>'+
//             '<DocumentContent>NON_DOCUMENTS</DocumentContent>'+
//             '<CustomsValue>'+
//             '<Currency>INR</Currency>'+
//             '<Amount>100.000000</Amount>'+
//             '</CustomsValue>'+
//             '<CommercialInvoice>'+
//             '<Purpose>SOLD</Purpose>'+
//             '<CustomerReferences>'+
//             '<CustomerReferenceType>CUSTOMER_REFERENCE</CustomerReferenceType>'+
//             '<Value>1234</Value>'+
//             '</CustomerReferences>'+
//             '</CommercialInvoice>'+
//             '<Commodities>'+
//             '<Name>String</Name>'+
//             '<NumberOfPieces>1</NumberOfPieces>'+
//             '<Description>ABCD</Description>'+
//             '<CountryOfManufacture>IN</CountryOfManufacture>'+
//             '<Weight>'+
//             '<Units>KG</Units>'+
//             '<Value>10.0</Value>'+
//             '</Weight>'+
//             '<Quantity>1</Quantity>'+
//             '<QuantityUnits>EA</QuantityUnits>'+
//             '<UnitPrice>'+
//             '<Currency>INR</Currency>'+
//             '<Amount>1.000000</Amount>'+
//             '</UnitPrice>'+
//             '<CustomsValue>'+
//             '<Currency>INR</Currency>'+
//             '<Amount>100.000000</Amount>'+
//             '</CustomsValue>'+
//             '</Commodities>'+
//             '</CustomsClearanceDetail>'+*/
//             '<LabelSpecification>' +

//             '<LabelFormatType>COMMON2D</LabelFormatType>' +
//             '<ImageType>ZPLII</ImageType>' +
//             '<LabelStockType>STOCK_4X6</LabelStockType>' +
//             '</LabelSpecification>' +
//             '<RateRequestTypes>LIST</RateRequestTypes>' +
//             /*'<CustomerSpecifiedDetail>'+
//             '<DocTabContent>'+
//             '<DocTabContentType>ZONE001</q0:DocTabContentType>'+
//             '<Zone001>'+
//             '<DocTabZoneSpecifications>'+
//             '<ZoneNumber>1</ZoneNumber>'+
//             '<Header>REF</Header>'+
//             '<DataField>REQUEST/PACKAGE/CustomerReferences[CustomerReferenceType="CUSTOMER_REFERENCE"]/value</DataField>'+
//             '<Justification>LEFT</Justification>'+
//             '<DocTabZoneSpecifications>'+
//             '<DocTabZoneSpecifications>'+
//             '<ZoneNumber>5</ZoneNumber>'+
//             '<Header>WHT</Header>'+
//             '<DataField>REQUEST/PACKAGE/weight/Value</DataField>'+

//             '<Justification>LEFT</Justification>'+
//             '</DocTabZoneSpecifications>'+

//             '<DocTabZoneSpecifications>'+
//             '<ZoneNumber>6</ZoneNumber>'+
//             '<Header>INS</Header>'+
//             '<DataField>REQUEST/PACKAGE/InsuredValue/Amount</DataField>'+
//             '<Justification>LEFT</Justification>'+
//             '</DocTabZoneSpecifications>'+

//             '<DocTabZoneSpecifications>'+
//             '<ZoneNumber>7</ZoneNumber>'+
//             '<Header>COD</Header>'+
//             '<DataField>REQUEST/SHIPMENT/SpecialServicesRequested/CodDetail/CodCollectionAmount/Amount</DataField>'+
//             '<Justification>LEFT</Justification>'+
//             '</DocTabZoneSpecifications>'+

//             '<DocTabZoneSpecifications>'+
//             '<ZoneNumber>9</ZoneNumber>'+
//             '<Header>BASE</Header>'+
//             '<DataField>REPLY/PACKAGE/RATE/ACTUAL/BaseCharge/Amount</DataField>'+
//             '<Justification>LEFT</Justification>'+
//             '</DocTabZoneSpecifications>'+

//             '<DocTabZoneSpecifications>'+
//             '<ZoneNumber>12</ZoneNumber>'+
//             '<Header>NETCHG</Header>'+
//             '<DataField>REPLY/PACKAGE/RATE/ACTUAL/NetCharge/Amount</DataField>'+
//             '<Justification>LEFT</Justification>'+
//             '</DocTabZoneSpecifications>'+
//             '</Zone001>'+
//             '</DocTabContent>'+
//             '<MaskedData>SHIPPER_ACCOUNT_NUMBER</MaskedData>'+
//             '</CustomerSpecifiedDetail>'+
//             '</LabelSpecification>'+      */

//             '<PackageCount>' + FORMAT(recWhsShipHeader."No. of Boxes") + '</PackageCount>' +

//             //'<InsuranceCharges>'+FORMAT(Rahu)+'</InsuranceCharges>'+   Rahul
//             '<RequestedPackageLineItems>' +
//             '<SequenceNumber>1</SequenceNumber>' +
//              '<Weight>' +
//              '<Units>LB</Units>' +
//              '<Value>' + FORMAT(recWhsShipHeader."Gross Weight") + '</Value>' +
//              '</Weight>' +
//              '<Dimensions>' +
//              '<Length>' + FORMAT(recBoxMaster.Length) + '</Length>' +
//              '<Width>' + FORMAT(recBoxMaster.Width) + '</Width>' +
//              '<Height>' + FORMAT(recBoxMaster.Height) + '</Height>' +
//              '<Units>IN</Units>' +
//              '</Dimensions>' +
//              '<PhysicalPackaging>BOX</PhysicalPackaging>' +
//              '<ItemDescription>' + recWhseShipLine.Description + '</ItemDescription>' +
//              '<CustomerReferences>' +
//              '<CustomerReferenceType>CUSTOMER_REFERENCE</CustomerReferenceType>' +
//              '<Value>' + recWhsShipHeader."External Document No." + '</Value>' +
//              '</CustomerReferences>' +

//             '</RequestedPackageLineItems>' +
//             '</RequestedShipment>' +
//             '</ProcessShipmentRequest>' +
//             '</soapenv:Body>' +
//             '</soapenv:Envelope>');

//             IF ISCLEAR(locautXmlDoc1) THEN
//                 Result1 := CREATE(locautXmlDoc1, TRUE, TRUE);

//             //MESSAGE('%1',Xmlhttp.responseText());
//             IF Xmlhttp.status <> 200 THEN BEGIN
//                 //locautXmlDoc1.load(Xmlhttp.responseXML);
//                 Position := STRPOS(Xmlhttp.responseText(), '<con1:message>');
//                 //ResultNode := locautXmlDoc.selectNodes('soapenv:Envelope');
//                 Position := Position + 14;
//                 Position1 := STRPOS(Xmlhttp.responseText(), '</con1:message>');
//                 //txtMessage:=COPYSTR(Xmlhttp.responseText(),Position,Position1);
//                 MESSAGE('%1', Xmlhttp.responseText());

//             END ELSE BEGIN

//                 MESSAGE('%1', Xmlhttp.responseText());
//                 locautXmlDoc1.load(Xmlhttp.responseXML);
//                 //locautXmlDoc1.save(recWhsShipHeader.Path+recWhsShipHeader."No."+'xml.xml');
//                 Position := STRPOS(Xmlhttp.responseText(), '<v13:Image>');
//                 //ResultNode := locautXmlDoc.selectNodes('soapenv:Envelope');
//                 Position := Position + 11;
//                 Position1 := STRPOS(Xmlhttp.responseText(), '</v13:Image>');
//                 CLEAR(Picture1);
//                 Picture1.ADDTEXT(Xmlhttp.responseText());
//                 Picture1.GETSUBTEXT(Picture1, Position, Position1 - Position);
//                 //text1:='HelloSandeep';

//                 Bytes := Convert.FromBase64String(Picture1);
//                 MemoryStream := MemoryStream.MemoryStream(Bytes);
//                 recWhsShipHeader.Picture.CREATEOUTSTREAM(OStream);
//                 MemoryStream.WriteTo(OStream);
//                 WhseSetup.GET();
//                 /*recSalesShipHeader.RESET;
//                 recSalesShipHeader.SETFILTER(Path,'C:\Users\spdynamics\Desktop\Fedex\'+recWhsShipHeader."No."+'.txt');
//                 IF NOT recSalesShipHeader.FIND('-') THEN BEGIN
//                 recWhsShipHeader.Picture.EXPORT(WhseSetup."Image Path"+recWhsShipHeader."No."+'.txt');
//                 recWhsShipHeader.Path:=WhseSetup."Image Path"+recWhsShipHeader."No."+'.txt';
//                 END ELSE BEGIN
//                 recWhsShipHeader.Picture.EXPORT(WhseSetup."Image Path"+recWhsShipHeader."No."+'1.txt');
//                 recWhsShipHeader.Path:=WhseSetup."Image Path"+recWhsShipHeader."No."+'1.txt';

//                 END;
//                  */
//                 IF txtPaymentType = 'SENDER' THEN BEGIN
//                     Position := STRPOS(Xmlhttp.responseText(), '<v13:TotalNetFedExCharge>');
//                     //ResultNode := locautXmlDoc.selectNodes('soapenv:Envelope');
//                     Position := Position + 69;
//                     Position1 := STRPOS(Xmlhttp.responseText(), '</v13:Amount></v13:TotalNetFedExCharge>');
//                     txtAmount := COPYSTR(Xmlhttp.responseText(), Position, Position1 - Position);
//                     EVALUATE(decAmount, txtAmount);

//                 END;
//                 Position := STRPOS(Xmlhttp.responseText(), '<v13:TrackingNumber>');
//                 Position := Position + 20;
//                 Position1 := STRPOS(Xmlhttp.responseText(), '</v13:TrackingNumber>');
//                 txtAmount := COPYSTR(Xmlhttp.responseText(), Position, Position1 - Position);
//                 //EVALUATE(decAmount,txtAmount);


//                 recWhsShipHeader."Tracking No." := txtAmount;
//                 recWhsShipHeader.MODIFY(FALSE);

//                 SalesRelease.Reopen(recSalesHeader);
//                 recSalesHeader.SetHideValidationDialog(TRUE);
//                 //recSalesHeader.VALIDATE("Posting Date",WhseShptHeader."Posting Date");
//                 recSalesHeader.VALIDATE("Charges Pay By", recWhsShipHeader."Charges Pay By");
//                 recSalesHeader.VALIDATE("Tracking No.", recWhsShipHeader."Tracking No.");
//                 recSalesHeader.VALIDATE("Tracking Status", recWhsShipHeader."Tracking Status");
//                 recSalesHeader.VALIDATE("Box Code", recWhsShipHeader."Box Code");
//                 recSalesHeader.VALIDATE("No. of Boxes", recWhsShipHeader."No. of Boxes");
//                 //ModifyHeader := TRUE;
//                 IF txtPaymentType = 'SENDER' THEN BEGIN
//                     recSalesLine.RESET;
//                     recSalesLine.SETRANGE("Document Type", recSalesLine."Document Type"::Order);
//                     recSalesLine.SETRANGE("Document No.", recSalesHeader."No.");
//                     IF recSalesLine.FIND('+') THEN BEGIN
//                         intLineNo := recSalesLine."Line No.";
//                         recSalesLine.INIT;
//                         recSalesLine.VALIDATE("Document Type", recSalesHeader."Document Type");
//                         recSalesLine.VALIDATE("Document No.", recSalesHeader."No.");
//                         recSalesLine.VALIDATE(Type, recSalesLine.Type::Resource);
//                         recSalesLine.VALIDATE("Line No.", intLineNo + 10000);
//                         recSalesLine.VALIDATE("No.", 'FREIGHT');
//                         recSalesLine.VALIDATE(Description, 'Against Warehouse shipment No. ' + recWhsShipHeader."No.");
//                         recSalesLine.VALIDATE(Quantity, 1);
//                         recSalesLine.VALIDATE("Unit Price", decAmount + recWhsShipHeader."Handling Charges" + recWhsShipHeader."Insurance Charges");
//                         recSalesLine.INSERT;
//                     END;
//                     //END;
//                 END;
//                 recSalesHeader.MODIFY;
//                 SalesRelease.RUN(recSalesHeader);



//             END;
//         END;

//     end;


//     procedure EncodeAndDecodeBase64()
//     begin
//         recCompanyInfo.GET();
//         recCompanyInfo.Picture.CREATEINSTREAM(IStream);
//         recCompanyInfo.CALCFIELDS(Picture);
//         MemoryStream := MemoryStream.MemoryStream();
//         COPYSTREAM(MemoryStream, IStream);
//         Bytes := MemoryStream.GetBuffer();

//         CLEAR(Picture1);
//         Picture1.ADDTEXT(Convert.ToBase64String(Bytes));
//         MemoryStream.Close();
//         MemoryStream.Dispose();

//         Bytes := Convert.FromBase64String(Picture1);
//         MemoryStream := MemoryStream.MemoryStream(Bytes);

//         abpRecTempBlob.Blob.CREATEOUTSTREAM(MemoryStream);
//         MemoryStream.WriteTo(OStream);
//         abpRecTempBlob.Blob.EXPORT('C:\Users\Admin\Desktop\FXO_Advanced_cs\test.png');
//     end;


//     procedure StandardOverNightLine(recWhsShipHeader: Record "Warehouse Shipment Header")
//     var
//         recCustomer: Record Customer;
//         txtPaymentType: Text[30];
//         ResponsibleCountry: Code[10];
//         ResponsiblePost: Code[20];
//         ResponsibleState: Code[20];
//         ResponsibleCity: Code[20];
//         ResponsibleAddress: Text[50];
//         ResponsiblePhone: Text[30];
//         ResponsibleCompany: Text[50];
//         ResponsibleEmail: Text[30];
//         ResponsiblePerson: Text[30];
//         ResponsibleAccNo: Text[30];
//         decNetWeigh: Decimal;
//         recSalesLine: Record "Sales Line";
//         decAmount: Decimal;
//         txtAmount: Text[25];
//         recSalesHeader: Record "Sales Header";
//         recWhseShipLine: Record "Warehouse Shipment Line";
//         recBoxMaster: Record "Box Master";
//         txtPackageDetail: BigText;
//         intNo: Integer;
//         txtPackagedet: array[5] of Text[1000];
//         intLength: Integer;
//         SalesRelease: Codeunit "Release Sales Document";
//         txtMessage: Text[500];
//         txtYear: Text[10];
//         txtMonth: Text[10];
//         txtDate: Text[10];
//         intDate: Integer;
//         intMonth: Integer;
//         intYear: Integer;
//     begin
//         //recSalesHeader:=SalesHeader;
//         //recSalesHeader;
//         /*  decNetWeigh:=0;
//           intNo:=0;
//           intDate:=DATE2DMY(recWhsShipHeader."Shipment Date",1);
//           intMonth:=DATE2DMY(recWhsShipHeader."Shipment Date",2);
//           intYear:=DATE2DMY(recWhsShipHeader."Shipment Date",3);
//           txtDate:=FORMAT(intDate);
//           txtMonth:=FORMAT(intMonth);
//           txtYear:=FORMAT(intYear);
//           IF intYear < 100 THEN
//              txtYear:='20'+txtYear;
//           IF STRLEN(txtMonth)<2 THEN
//              txtMonth:='0'+txtMonth;
//            IF STRLEN(txtDate)<2 THEN
//               txtDate:='0'+txtDate;

//           recWhseShipLine.RESET;
//           recWhseShipLine.SETRANGE("No.",recWhsShipHeader."No.");
//           recWhseShipLine.SETFILTER("Qty. to Ship",'<>%1',0);
//           IF recWhseShipLine.FIND('-') THEN BEGIN
//          REPEAT

//           recSalesHeader.RESET;
//           IF recSalesHeader.GET(recWhseShipLine."Source Subtype",recWhseShipLine."Source No.") THEN;
//             recCompanyInfo.GET;
//             recCustomer.GET(recSalesHeader."Sell-to Customer No.");
//             recLocation.GET(recSalesHeader."Location Code");
//             {recSalesLine.RESET;
//             recSalesLine.SETRANGE("Document No.",recSalesHeader."No.");
//             IF recSalesLine.FIND('-') THEN BEGIN
//               REPEAT
//                decNetWeigh+=recSalesLine.Quantity;
//               UNTIL recSalesLine.NEXT=0;
//              END;}
//           CLEAR(txtPackageDetail);

//         recBoxMaster.RESET;
//         IF recBoxMaster.GET(recWhseShipLine."Box Code") THEN;

//               recItem.GET(recWhseShipLine."Item No.");
//               decNetWeigh:=recWhseShipLine."Qty. to Ship";
//               intNo+=1;



//         intLength:=0;
//         intLength:= txtPackageDetail.LENGTH;
//         IF intLength<>0 THEN
//          txtPackageDetail.GETSUBTEXT(txtPackagedet[1],1,1000);
//         IF intLength>1000 THEN
//            txtPackageDetail.GETSUBTEXT(txtPackagedet[2],1001,2000);
//         IF intLength>2000 THEN
//            txtPackageDetail.GETSUBTEXT(txtPackagedet[3],2001,3000);
//         IF intLength>3000 THEN
//            txtPackageDetail.GETSUBTEXT(txtPackagedet[4],3001,4000);
//         IF intLength>4000 THEN
//            txtPackageDetail.GETSUBTEXT(txtPackagedet[5],4001,5000);

//         IF ISCLEAR(Xmlhttp) THEN
//            Result:=CREATE(Xmlhttp,TRUE,TRUE);

//         IF recSalesHeader."Charges Pay By"=recSalesHeader."Charges Pay By"::SENDER THEN BEGIN
//            ResponsibleAccNo:='510087704';
//            ResponsiblePerson:=recLocation.Contact;
//            ResponsibleEmail:=recLocation."E-Mail";
//            ResponsibleCompany:=recCompanyInfo.Name;
//            ResponsiblePhone:=recLocation."Phone No.";
//            ResponsibleAddress:=recLocation.Address;
//            ResponsibleCity:=recLocation.City;
//            ResponsibleState:=recLocation."State Code";
//            ResponsiblePost:=recLocation."Post Code";
//            ResponsibleCountry:=recLocation."Country/Region Code";
//         END ELSE BEGIN
//            ResponsibleAccNo:='510087704';
//            ResponsiblePerson:=recCustomer.Contact;
//            ResponsibleEmail:=recCustomer."E-Mail";
//            ResponsibleCompany:=recCustomer.Name;
//            ResponsiblePhone:=recCustomer."Phone No.";
//            ResponsibleAddress:=recCustomer.Address;
//            ResponsibleCity:=recCustomer.City;
//            ResponsibleState:=recCustomer."State Code";
//            ResponsiblePost:=recCustomer."Post Code";
//            ResponsibleCountry:=recCustomer."Country/Region Code";
//          END;
//            //ELSE
//            //Result:=Create(Xmlhttp,TRUE);
//         txtPaymentType:=FORMAT(recSalesHeader."Charges Pay By");
//         Xmlhttp.open('POST',' https://wsbeta.fedex.com:443/web-services',0);//'https://wsbeta.fedex.com:443/web-services',0);

//         Xmlhttp.send('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://fedex.com/ws/ship/v12">'+
//         '<soapenv:Body>'+
//         '<ProcessShipmentRequest xmlns="http://fedex.com/ws/ship/v12">'+
//         '<WebAuthenticationDetail>'+
//         '<UserCredential>'+
//         '<Key>'+Key+'</Key>'+
//         '<Password>'+Password+'</Password>'+
//         '</UserCredential>'+
//         '</WebAuthenticationDetail>'+
//         '<ClientDetail>'+
//         '<AccountNumber>'+AccountNo+'</AccountNumber>'+
//         '<MeterNumber>'+MeterNo+'</MeterNumber>'+
//         '</ClientDetail>'+
//         '<TransactionDetail>'+
//         '<CustomerTransactionId>'+recSalesHeader."No."+'</CustomerTransactionId>'+
//         '</TransactionDetail>'+
//         '<Version>'+
//         '<ServiceId>ship</ServiceId>'+
//         '<Major>12</Major>'+
//         '<Intermediate>1</Intermediate>'+
//         '<Minor>0</Minor>'+
//         '</Version>'+
//         '<RequestedShipment>'+
//         '<ShipTimestamp>'+txtYear+'-'+txtMonth+'-'+txtDate+'T'+FORMAT(recWhsShipHeader."Shipment Time")+'-05:00</ShipTimestamp>'+
//         '<DropoffType>REGULAR_PICKUP</DropoffType>'+
//         '<ServiceType>STANDARD_OVERNIGHT</ServiceType>'+
//         '<PackagingType>YOUR_PACKAGING</PackagingType>'+
//         '<Shipper>'+
//         '<AccountNumber>510087704</AccountNumber>'+
//         '<Contact>'+
//         '<PersonName>'+recLocation.Contact+'</PersonName>'+
//         '<CompanyName>'+recCompeny.Name+'</CompanyName>'+
//         '<PhoneNumber>'+recLocation."Phone No."+'</PhoneNumber>'+
//         '<EMailAddress>'+recLocation."E-Mail"+'</EMailAddress>'+
//         '</Contact>'+
//         '<Address>'+
//         '<StreetLines>'+recLocation.Address+'</StreetLines>'+
//         '<City>'+recLocation.City+'</City>'+
//         '<StateOrProvinceCode>'+recLocation."State Code"+'</StateOrProvinceCode>'+
//         '<PostalCode>'+recLocation."Post Code"+'</PostalCode>'+
//         '<CountryCode>'+recLocation."Country/Region Code"+'</CountryCode>'+
//         '</Address>'+
//         '</Shipper>'+
//         '<Recipient>'+
//         '<AccountNumber>'+recCustomer."Shipping Account No."+'</AccountNumber>'+
//         '<Contact>'+
//         '<PersonName>'+recCustomer.Contact+'</PersonName>'+
//         '<CompanyName>'+recCustomer.Name+'</CompanyName>'+
//         '<PhoneNumber>'+recCustomer."Phone No."+'</PhoneNumber>'+
//         '<EMailAddress>'+recCustomer."E-Mail"+'</EMailAddress>'+
//         '</Contact>'+
//         '<Address>'+
//         '<StreetLines>'+recCustomer.Address+' '+recCustomer."Address 2"+'</StreetLines>'+
//         '<City>'+recCustomer.City+'</City>'+
//         '<StateOrProvinceCode>'+recCustomer."State Code"+'</StateOrProvinceCode>'+
//         '<PostalCode>'+recCustomer."Post Code"+'</PostalCode>'+
//         '<CountryCode>'+recCustomer."Country/Region Code"+'</CountryCode>'+
//         '</Address>'+
//         '</Recipient>'+
//         '<ShippingChargesPayment>'+

//         '<PaymentType>'+'SENDER'+'</PaymentType>'+
//         '<Payor>'+
//         '<ResponsibleParty>'+
//         '<AccountNumber>'+ResponsibleAccNo+'</AccountNumber>'+
//         '<Contact>'+
//         '<PersonName>'+ResponsiblePerson+'</PersonName>'+
//         '<EMailAddress>'+ResponsibleEmail+'</EMailAddress>'+
//         '</Contact>'+
//         '</ResponsibleParty>'+
//         '</Payor>'+
//         '</ShippingChargesPayment>'+
//         {'<CustomsClearanceDetail>'+
//         '<DutiesPayment>'+
//         '<PaymentType>SENDER</PaymentType>'+
//         '<Payor>'+
//         '<ResponsibleParty>'+
//         '<AccountNumber>'+ResponsibleAccNo+'</AccountNumber>'+
//         '<Tins>'+
//         '<TinType>PERSONAL_STATE</TinType>'+
//         '<Number>1057</Number>'+
//         '<Usage>ShipperTinsUsage</Usage>'+
//         '</Tins>'+
//         '<Contact>'+
//         '<ContactId>RBB1057</ContactId>'+
//         '<PersonName>'+ResponsiblePerson+'</PersonName>'+
//         '<Title>abc</Title>'+
//         '<CompanyName>'+ResponsibleCompany+'</CompanyName>'+
//         '<PhoneNumber>'+ResponsiblePhone+'</PhoneNumber>'+
//         //'<PhoneExtension>02033469</PhoneExtension>'+
//         //'<PagerNumber>9900066979</PagerNumber>'+
//         //'<FaxNumber>9900066979</FaxNumber>'+
//         '<EMailAddress>'+ResponsibleEmail+'</EMailAddress>'+
//         '</Contact>'+
//         '<Address>'+
//         '<StreetLines>'+ResponsibleAddress+'</StreetLines>'+
//         '<City>'+ResponsibleCity+'</City>'+
//         '<StateOrProvinceCode>'+ResponsibleState+'</StateOrProvinceCode>'+
//         '<PostalCode>'+ResponsiblePost+'</PostalCode>'+
//         '<CountryCode>'+ResponsibleCountry+'</CountryCode>'+
//         '</Address>'+
//         '</ResponsibleParty>'+
//         '</Payor>'+
//         '</DutiesPayment>'+
//         '<DocumentContent>NON_DOCUMENTS</DocumentContent>'+
//         '<CustomsValue>'+
//         '<Currency>INR</Currency>'+
//         '<Amount>100.000000</Amount>'+
//         '</CustomsValue>'+
//         '<CommercialInvoice>'+
//         '<Purpose>SOLD</Purpose>'+
//         '<CustomerReferences>'+
//         '<CustomerReferenceType>CUSTOMER_REFERENCE</CustomerReferenceType>'+
//         '<Value>1234</Value>'+
//         '</CustomerReferences>'+
//         '</CommercialInvoice>'+
//         '<Commodities>'+
//         '<Name>String</Name>'+
//         '<NumberOfPieces>1</NumberOfPieces>'+
//         '<Description>ABCD</Description>'+
//         '<CountryOfManufacture>IN</CountryOfManufacture>'+
//         '<Weight>'+
//         '<Units>KG</Units>'+
//         '<Value>10.0</Value>'+
//         '</Weight>'+
//         '<Quantity>1</Quantity>'+
//         '<QuantityUnits>EA</QuantityUnits>'+
//         '<UnitPrice>'+
//         '<Currency>INR</Currency>'+
//         '<Amount>1.000000</Amount>'+
//         '</UnitPrice>'+
//         '<CustomsValue>'+
//         '<Currency>INR</Currency>'+
//         '<Amount>100.000000</Amount>'+
//         '</CustomsValue>'+
//         '</Commodities>'+
//         '</CustomsClearanceDetail>'+}
//         '<LabelSpecification>'+
//         '<LabelFormatType>COMMON2D</LabelFormatType>'+
//         '<ImageType>PNG</ImageType>'+
//         '</LabelSpecification>'+
//         '<RateRequestTypes>ACCOUNT</RateRequestTypes>'+
//         '<PackageCount>'+FORMAT(recWhsShipHeader."No. of Boxes")+'</PackageCount>'+
//         '<RequestedPackageLineItems>'+
//         '<SequenceNumber>1</SequenceNumber>'+
//         '<Weight>'+
//         '<Units>LB</Units>'+
//         '<Value>'+FORMAT(recItem.Weight*decNetWeigh)+'</Value>'+
//         '</Weight>'+
//         '<Dimensions>'+
//         '<Length>'+FORMAT(recBoxMaster.Length)+'</Length>'+
//         '<Width>'+FORMAT(recBoxMaster.Width)+'</Width>'+
//         '<Height>'+FORMAT(recBoxMaster.Height)+'</Height>'+
//         '<Units>IN</Units>'+
//         '</Dimensions>'+
//         '<PhysicalPackaging>BOX</PhysicalPackaging>'+
//         '<ItemDescription>'+recWhseShipLine.Description+'</ItemDescription>'+
//         '<CustomerReferences>'+
//         '<CustomerReferenceType>CUSTOMER_REFERENCE</CustomerReferenceType>'+
//         '<Value>'+recWhseShipLine.Description+'</Value>'+
//         '</CustomerReferences>'+
//         '</RequestedPackageLineItems>'+
//         '</RequestedShipment>'+
//         '</ProcessShipmentRequest>'+
//         '</soapenv:Body>'+
//         '</soapenv:Envelope>');
//         IF ISCLEAR(locautXmlDoc1) THEN
//            Result1:=CREATE(locautXmlDoc1,TRUE,TRUE);
//         //MESSAGE('%1',Xmlhttp.responseText());
//         IF Xmlhttp.status<>200 THEN BEGIN
//         //locautXmlDoc1.load(Xmlhttp.responseXML);
//         Position := STRPOS(Xmlhttp.responseText(), '<con1:message>');
//         //ResultNode := locautXmlDoc.selectNodes('soapenv:Envelope');
//         Position:=Position+14;
//         Position1:=STRPOS(Xmlhttp.responseText(),'</con1:message>');
//         txtMessage:=COPYSTR(Xmlhttp.responseText(),Position,Position1);
//         MESSAGE('%1',txtMessage);

//         END ELSE BEGIN
//         locautXmlDoc1.load(Xmlhttp.responseXML);
//         Position := STRPOS(Xmlhttp.responseText(), '<v12:Image>');
//         //ResultNode := locautXmlDoc.selectNodes('soapenv:Envelope');
//         Position:=Position+11;
//         Position1:=STRPOS(Xmlhttp.responseText(),'</v12:Image>');
//         CLEAR(Picture1);
//         Picture1.ADDTEXT(Xmlhttp.responseText());
//         Picture1.GETSUBTEXT(Picture1, Position, Position1-Position);
//         //text1:='HelloSandeep';

//         Bytes:=Convert.FromBase64String(Picture1);
//         MemoryStream:=MemoryStream.MemoryStream(Bytes);
//         abpRecTempBlob.Blob.CREATEOUTSTREAM(OStream);
//         MemoryStream.WriteTo(OStream);
//         abpRecTempBlob.Blob.EXPORT('E:\Fedex Image\'+recWhsShipHeader."No."+'.png');


//         {
//         abpAutBytes:=abpAutConvertBase64.FromBase64String(Picture1);
//         abpAutMemoryStream:=abpAutMemoryStream.MemoryStream(abpAutBytes);
//         abpRecTempBlob.Blob.CREATEOUTSTREAM(abpOutStream);
//         abpAutMemoryStream.WriteTo(abpOutStream);
//         abpRecTempBlob.Blob.EXPORT('C:\Users\Admin\Desktop\FXO_Advanced_cs\test.png');
//         }
//         locautXmlDoc1.save('C:\Users\Admin\Desktop\FXO_Advanced_cs\'+recWhsShipHeader."No."+'.xml');

//         //MESSAGE('%1',Picture1);
//         //MESSAGE('%1',responseStream);
//         Position := STRPOS(Xmlhttp.responseText(), '<v12:TotalNetFedExCharge>');
//         //ResultNode := locautXmlDoc.selectNodes('soapenv:Envelope');
//         Position:=Position+69;
//         Position1:=STRPOS(Xmlhttp.responseText(),'</v12:Amount></v12:TotalNetFedExCharge>');
//         txtAmount:=COPYSTR(Xmlhttp.responseText(),Position ,Position1-Position);
//         EVALUATE(decAmount,txtAmount);

//         StrOrderLineDetails.RESET;
//         StrOrderLineDetails.SETCURRENTKEY("Document Type","Document No.",Type);
//         StrOrderLineDetails.SETRANGE("Document Type",recSalesHeader."Document Type");
//         StrOrderLineDetails.SETRANGE("Document No.",recSalesHeader."No.");
//         StrOrderLineDetails.SETRANGE(Type,StrOrderLineDetails.Type::"2");
//         //StrOrderLineDetails.SETRANGE("Item No.","No.");
//         //StrOrderLineDetails.SETRANGE("Line No.","Line No.");
//         IF StrOrderLineDetails.FIND('-') THEN BEGIN
//            StrOrderLineDetails.VALIDATE("Calculation Value",StrOrderLineDetails."Calculation Value"+decAmount);
//            StrOrderLineDetails.MODIFY;
//         END;

//         Position := STRPOS(Xmlhttp.responseText(), '<v12:TrackingNumber>');
//         Position:=Position+20;
//         Position1:=STRPOS(Xmlhttp.responseText(),'</v12:TrackingNumber>');
//         txtAmount:=COPYSTR(Xmlhttp.responseText(),Position ,Position1-Position);
//         //EVALUATE(decAmount,txtAmount);

//         recWhsShipHeader."Tracking No.":= txtAmount;
//         recWhsShipHeader.MODIFY(FALSE);
//            recSalesLine.RESET;
//            recSalesLine.SETRANGE("Document Type",recSalesHeader."Document Type");
//            recSalesLine.SETRANGE("Document No.",recSalesHeader."No.");
//            recSalesLine.SETRANGE("Line No.",recWhseShipLine."Source Line No.");
//            IF recSalesLine.FIND('-') THEN BEGIN
//              REPEAT
//           //recSalesHeader.VALIDATE("Posting Date",WhseShptHeader."Posting Date");
//               recSalesLine.VALIDATE("Charges Pay By",recWhsShipHeader."Charges Pay By");
//               recSalesLine.VALIDATE("Tracking No.",recWhsShipHeader."Tracking No.");
//               recSalesLine.VALIDATE("Tracking Status",recWhsShipHeader."Tracking Status");
//               recSalesLine.VALIDATE("Box Code",recWhsShipHeader."Box Code");
//               recSalesLine.VALIDATE("No. of Boxes",recWhsShipHeader."No. of Boxes");
//               //Sales.RUN(recSalesHeader);
//               recSalesLine.MODIFY(FALSE);
//              UNTIL recSalesLine.NEXT=0;
//             END;

//          END;
//         UNTIL recWhseShipLine.NEXT=0;
//         END;
//          */

//     end;


//     procedure StandardOverNight_New(recWhsShipHeader: Record "Warehouse Shipment Header")
//     var
//         recCustomer: Record Customer;
//         txtPaymentType: Text[30];
//         ResponsibleCountry: Code[10];
//         ResponsiblePost: Code[20];
//         ResponsibleState: Code[20];
//         ResponsibleCity: Code[20];
//         ResponsibleAddress: Text[50];
//         ResponsiblePhone: Text[30];
//         ResponsibleCompany: Text[50];
//         ResponsibleEmail: Text[50];
//         ResponsiblePerson: Text[50];
//         ResponsibleAccNo: Text[30];
//         decNetWeigh: Decimal;
//         recSalesLine: Record "Sales Line";
//         decAmount: Decimal;
//         txtAmount: Text[25];
//         recSalesHeader: Record "Sales Header";
//         recWhseShipLine: Record "Warehouse Shipment Line";
//         txtPackageDetail: BigText;
//         intNo: Integer;
//         txtPackagedet: array[5] of Text[1000];
//         intLength: Integer;
//         SalesRelease: Codeunit "Release Sales Document";
//         txtMessage: Text[500];
//         txtYear: Text[10];
//         txtMonth: Text[10];
//         txtDate: Text[10];
//         intDate: Integer;
//         intMonth: Integer;
//         intYear: Integer;
//         recShipAgentService: Record "Shipping Agent Services";
//         txtShipService: Text[100];
//         recShiptoAddress: Record "Ship-to Address";
//         ShiptoName: Text[50];
//         ShiptoAddress: Text[50];
//         ShiptoAddress2: Text[50];
//         ShiptoEmail: Text[50];
//         ShiptoPhone: Text[30];
//         ShiptoState: Text[30];
//         ShiptoCountry: Text[30];
//         ShiptoPostCode: Text[30];
//         ShiptoContact: Text[50];
//         ShiptoAccount: Code[20];
//         ShiptoCity: Text[30];
//         txtShipTime: Text[50];
//         intLineNo: Integer;
//         recSalesShipHeader: Record "Sales Shipment Header";
//         WhseSetup: Record "Warehouse Setup";
//     begin






//         /*
//         //recSalesHeader:=SalesHeader;
//         //recSalesHeader;
//         IF recWhsShipHeader."Track On Header" THEN BEGIN
//           recWhseShipLine.RESET;
//           recWhseShipLine.SETRANGE("No.",recWhsShipHeader."No.");
//           IF recWhseShipLine.FIND('-') THEN;
//           intDate:=DATE2DMY(recWhsShipHeader."Shipment Date",1);
//           intMonth:=DATE2DMY(recWhsShipHeader."Shipment Date",2);
//           intYear:=DATE2DMY(recWhsShipHeader."Shipment Date",3);
//           txtDate:=FORMAT(intDate);
//           txtMonth:=FORMAT(intMonth);
//           txtYear:=FORMAT(intYear);
//           IF intYear < 100 THEN
//              txtYear:='20'+txtYear;
//           IF STRLEN(txtMonth)<2 THEN
//              txtMonth:='0'+txtMonth;
//            IF STRLEN(txtDate)<2 THEN
//               txtDate:='0'+txtDate;
//           recSalesHeader.RESET;
//           IF recSalesHeader.GET(recWhseShipLine."Source Subtype",recWhseShipLine."Source No.") THEN;
//             recCompanyInfo.GET;
//             IF recSalesHeader."Ship-to Code"<>'' THEN BEGIN

//                recCustomer.GET(recSalesHeader."Sell-to Customer No.");
//                recShiptoAddress.GET(recSalesHeader."Sell-to Customer No.",recSalesHeader."Ship-to Code");
//                ShiptoName:=recShiptoAddress.Name;
//                ShiptoAddress:=recShiptoAddress.Address;
//                ShiptoAddress2:=recShiptoAddress."Address 2";
//                ShiptoCity:=recShiptoAddress.City;
//                ShiptoState:=recShiptoAddress.County;
//                ShiptoAccount:=recShiptoAddress."Shipping Account No.";
//                IF ShiptoAccount='' THEN
//                  ShiptoAccount:=recCustomer."Shipping Account No.";
//                IF recWhseShipHeader."Third Party" THEN
//                   txtPaymentType:='THIRD_PARTY';
//                ShiptoPostCode:=recShiptoAddress."Post Code";

//                ShiptoCountry:=recShiptoAddress."Country/Region Code";
//                ShiptoEmail:=recShiptoAddress."E-Mail";
//                ShiptoContact:=recShiptoAddress.Contact;
//                ShiptoPhone:=recShiptoAddress."Phone No.";

//              END ELSE BEGIN
//             recCustomer.GET(recSalesHeader."Sell-to Customer No.");
//                ShiptoName:=recCustomer.Name;
//                ShiptoAddress:=recCustomer.Address;
//                ShiptoAddress2:=recCustomer."Address 2";
//                ShiptoCity:=recCustomer.City;
//                ShiptoState:=recCustomer.County;
//                ShiptoAccount:=recCustomer."Shipping Account No.";
//                ShiptoPostCode:=recCustomer."Post Code";

//                ShiptoCountry:=recCustomer."Country/Region Code";
//                ShiptoEmail:=recCustomer."E-Mail";
//                ShiptoContact:=recCustomer.Contact;
//                ShiptoPhone:=recCustomer."Phone No.";

//             END;
//             recLocation.GET(recSalesHeader."Location Code");
//             {recSalesLine.RESET;
//             recSalesLine.SETRANGE("Document No.",recSalesHeader."No.");
//             IF recSalesLine.FIND('-') THEN BEGIN
//               REPEAT
//                decNetWeigh+=recSalesLine.Quantity;
//               UNTIL recSalesLine.NEXT=0;
//              END;}
//           CLEAR(txtPackageDetail);
//            recShipAgentService.GET(recWhsShipHeader."Shipping Agent Code",recWhsShipHeader."Shipping Agent Service Code");
//            txtShipService:=recShipAgentService.Description;
//         recBoxMaster.RESET;
//         IF recBoxMaster.GET(recWhsShipHeader."Box Code") THEN;

//           decNetWeigh:=0;
//           intNo:=0;
//           recWhseShipLine.RESET;
//           recWhseShipLine.SETRANGE("No.",recWhsShipHeader."No.");
//           recWhseShipLine.SETFILTER("Qty. to Ship",'<>%1',0);
//           IF recWhseShipLine.FIND('-') THEN BEGIN
//              REPEAT
//                recItem.GET(recWhseShipLine."Item No.");
//               decNetWeigh:=decNetWeigh+recWhseShipLine."Qty. to Ship"*recItem.Weight;
//               intNo+=1;




//              UNTIL recWhseShipLine.NEXT=0;
//            END;
//         intLength:=0;
//         intLength:= txtPackageDetail.LENGTH;
//         IF intLength<>0 THEN
//          txtPackageDetail.GETSUBTEXT(txtPackagedet[1],1,1000);
//         IF intLength>1000 THEN
//            txtPackageDetail.GETSUBTEXT(txtPackagedet[2],1001,2000);
//         IF intLength>2000 THEN
//            txtPackageDetail.GETSUBTEXT(txtPackagedet[3],2001,3000);
//         IF intLength>3000 THEN
//            txtPackageDetail.GETSUBTEXT(txtPackagedet[4],3001,4000);
//         IF intLength>4000 THEN
//            txtPackageDetail.GETSUBTEXT(txtPackagedet[5],4001,5000);

//         IF ISCLEAR(Xmlhttp) THEN
//            Result:=CREATE(Xmlhttp,TRUE,TRUE);

//         IF recWhsShipHeader."Charges Pay By"=recWhsShipHeader."Charges Pay By"::"1" THEN BEGIN
//            ResponsibleAccNo:=AccountNo;
//            ResponsiblePerson:=recLocation.Contact;
//            ResponsibleEmail:=recLocation."E-Mail";
//            ResponsibleCompany:=recCompanyInfo.Name;
//            ResponsiblePhone:=recLocation."Phone No.";
//            ResponsibleAddress:=recLocation.Address;
//            ResponsibleCity:=recLocation.City;
//            ResponsibleState:=recLocation.County;
//            ResponsiblePost:=recLocation."Post Code";
//            ResponsibleCountry:=recLocation."Country/Region Code";
//            txtPaymentType:='SENDER';
//         END ELSE BEGIN
//            IF txtPaymentType='THIRD_PARTY' THEN
//            ResponsibleAccNo:=recWhseShipHeader."Third Party Account No."
//            ELSE
//            ResponsibleAccNo:=recCustomer."Shipping Account No.";
//            ResponsiblePerson:=recCustomer.Contact;
//            ResponsibleEmail:=recCustomer."E-Mail";
//            ResponsibleCompany:=recCustomer.Name;
//            ResponsiblePhone:=recCustomer."Phone No.";
//            ResponsibleAddress:=recCustomer.Address;
//            ResponsibleCity:=recCustomer.City;
//            ResponsibleState:=recCustomer.County;
//            ResponsiblePost:=recCustomer."Post Code";
//            ResponsibleCountry:=recCustomer."Country/Region Code";
//            IF txtPaymentType<>'THIRD_PARTY' THEN
//            txtPaymentType:='RECIPIENT';
//          END;

//         txtShipTime:=FORMAT(recWhsShipHeader."Shipment Time",8, '<Hours24,2>:<Minutes,2>:<Seconds,2>');

//         If recWhsShipHeader."Residential address" TRUE THEN
//         */



//         //ELSE
//         //Result:=Create(Xmlhttp,TRUE);
//         //txtPaymentType:=FORMAT(recSalesHeader."Charges Pay By");

//         //if
//         Xmlhttp.open('POST', ' https://ws.fedex.com:443/web-services', 0);//'https://wsbeta.fedex.com:443/web-services',0);


//         Xmlhttp.send('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://fedex.com/ws/ship/v13">' +

//         '<v13:soapenv:Body>' +
//         '<v13:ProcessShipmentRequest xmlns="http://fedex.com/ws/ship/v13">' +
//         '<v13:WebAuthenticationDetail>' +
//         '<v13:UserCredential>' +
//         '<v13:Key>' + Key + '</v13:Key>' +
//         '<v13:Password>' + Password + '</v13:Password>' +
//         '</v13:UserCredential>' +
//         '</v13:WebAuthenticationDetail>' +
//         '<v13:ClientDetail>' +
//         '<v13:AccountNumber>' + AccountNo + '</v13:AccountNumber>' +
//         '<v13:MeterNumber>' + MeterNo + '</v13:MeterNumber>' +
//         '</v13:ClientDetail>' +
//         '<v13:TransactionDetail>' +
//         '<v13:CustomerTransactionId>' + recSalesHeader."No." + '</v13:CustomerTransactionId>' +

//         '<AddressValidationRequest xml:lang="en-US">' +
//            '<Request>' +
//               '<TransactionReference>' +
//                  '<CustomerContext>Customer Data</CustomerContext>' +
//                  '<XpciVersion>1.0001</XpciVersion>' +
//               '</TransactionReference>' +
//               '<RequestAction>AV</RequestAction>' +
//            '</Request>' +
//            '<Address>' +
//               '<City>+MIAMI</City>' +
//               '<StateProvinceCode>us</StateProvinceCode>' +
//            '</Address>' +
//         '</AddressValidationRequest>' +

//         '<AddressValidationResponse>' +
//            '<Response>' +
//               '<TransactionReference>' +
//                  '<XpciVersion>1.0001</XpciVersion>' +
//               '</TransactionReference>' +

//               '<ResponseStatusCode>1</ResponseStatusCode>' +
//               '<ResponseStatusDescription>Success</ResponseStatusDescription>' +
//            '</Response>' +
//            '<AddressValidationResult>' +
//               '<Rank>1</Rank>' +
//               '<Quality>1.0</Quality>' +
//               '<Address>' +
//                  '<City>TIMONIUM</City>' +
//                  '<StateProvinceCode>MD</StateProvinceCode>' +
//               '</Address>' +
//               '<PostalCodeLowEnd>21093</PostalCodeLowEnd>' +
//               '<PostalCodeHighEnd>21094</PostalCodeHighEnd>' +
//            '</AddressValidationResult>' +
//         '</AddressValidationResponse>' +
//         '</soapenv:Body>' +
//         '</soapenv:Envelope>');

//         MESSAGE('%1', Xmlhttp.responseText());

//     end;


//     procedure UPSRequest(recWhsShipHeader: Record "Warehouse Shipment Header")
//     var
//         UPSUSERNAME: Label 'silktex';
//         UPSPASSWORD: Label 'Crafts12';
//         UPSLICENCE: Label 'ACE923D1E3142AC6';
//         CustNo: Code[20];
//         recSalesHeader: Record "Sales Header";
//         recWhseShipLine: Record "Warehouse Shipment Line";
//         ReturnString: BigText;
//         recSalesLine: Record "Sales Line";
//         txtInsurance: Text[10];
//         txtCOD: Text[10];
//         TotalAmount: Decimal;
//     begin
//         CLEAR(Xmlhttp);
//         IF ISCLEAR(Xmlhttp) THEN
//             Result := CREATE(Xmlhttp, TRUE, TRUE);
//         Position := 0;
//         TotalAmount := 0;
//         TotalAmount := 0;
//         recWhseShipLine.RESET;
//         recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
//         recWhseShipLine.SETFILTER("Qty. to Ship", '<>%1', 0);
//         recWhseShipLine.SETRANGE("Source Type", 37);
//         recWhseShipLine.SETRANGE("Source Subtype", 1);
//         IF recWhseShipLine.FIND('-') THEN BEGIN
//             REPEAT
//                 recSalesLine.RESET;
//                 recSalesLine.SETRANGE("Document No.", recWhseShipLine."Source No.");
//                 recSalesLine.SETRANGE("Line No.", recWhseShipLine."Source Line No.");

//                 IF recSalesLine.FIND('-') THEN BEGIN
//                     REPEAT
//                         TotalAmount := TotalAmount + recWhseShipLine."Qty. to Ship" * recSalesLine."Unit Price";
//                     UNTIL recSalesLine.NEXT = 0;
//                 END;
//             UNTIL recWhseShipLine.NEXT = 0;
//         END;
//         IF recWhsShipHeader."Insurance Amount" <> 0 THEN
//             txtInsurance := 'Yes'
//         ELSE
//             txtInsurance := 'No';


//         IF recWhsShipHeader."Cash On Delivery" THEN
//             txtCOD := 'Yes'
//         ELSE
//             txtCOD := 'No';
//         IF recWhsShipHeader."Signature Required" THEN
//             txtSignature := 'Yes'
//         ELSE
//             txtSignature := 'No';
//         recWhseShipLine.RESET;
//         recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
//         IF recWhseShipLine.FIND('-') THEN;
//         recSalesHeader.RESET;
//         IF recSalesHeader.GET(recWhseShipLine."Source Subtype", recWhseShipLine."Source No.") THEN;
//         CustNo := recSalesHeader."Sell-to Customer No.";
//         TotalAmount1 := FORMAT(recWhsShipHeader."Insurance Amount");
//         TotalAmount1 := DELCHR(TotalAmount1, '=', ',');
//         txtCodAmount := FORMAT(TotalAmount);
//         IF recWhsShipHeader."COD Amount" <> 0 THEN
//             txtCodAmount := FORMAT(recWhsShipHeader."COD Amount");

//         txtCodAmount := DELCHR(txtCodAmount, '=', ',');

//         Xmlhttp.open('POST', 'http://' + webserverIP + '/UPSShipping.ashx?Action=SaveShipping&userName=' + UPSUSERNAME + '&password=' + UPSPASSWORD + '&licenseNo=' + UPSLICENCE + '&wSNo=' + recWhsShipHeader."No." + '&custNo=' + CustNo +
//         '&Insu=' + txtInsurance + '&InsuAmount=' + TotalAmount1 + '&COD=' + txtCOD + '&CODAmount=' + txtCodAmount + '&ServiceCode=' + recWhsShipHeader."Shipping Agent Service Code" + '&Signature=' + txtSignature, 0);
//         Xmlhttp.send('');
//         //MESSAGE('%1',Xmlhttp.responseText);
//         CLEAR(ReturnString);
//         ReturnString.ADDTEXT(Xmlhttp.responseText);

//         Position := STRPOS(Xmlhttp.responseText(), 'created successfully:');
//         //IF Position=0 THEN
//         //MESSAGE('%1',Xmlhttp.responseText)
//         //ELSE
//         //MESSAGE('Shipment created Successfully');
//     end;


//     procedure UPSTracking(WhseCode: Code[20]; TrackingNo: Text[30]; Image: BigText)
//     var
//         recTrackingNo: Record "Tracking No.";
//         recPackingHeader: Record "Packing Header";
//         recPackingLine: Record "Packing Line";
//     begin
//         recPackingHeader.RESET;
//         recPackingHeader.SETRANGE("Source Document Type", recPackingHeader."Source Document Type"::"Warehouse Shipment");
//         recPackingHeader.SETRANGE("Source Document No.", WhseCode);
//         IF recPackingHeader.FINDFIRST THEN BEGIN
//             //recPackingHeader."Freight Amount":= decAmount;
//             recPackingHeader."Tracking No." := TrackingNo;
//             //recPackingHeader."Sales Order No.":=recSalesHeader."No.";
//             recPackingHeader."Service Name" := 'FEDEX';
//             //recPackingHeader."Handling Charges":=recWhsShipHeader."Handling Charges";
//             //recPackingHeader."Insurance Charges":=recWhsShipHeader."Insurance Charges";
//             //recPackingHeader."Cash On Delivery":=recWhsShipHeader."Cash On Delivery";
//             //recPackingHeader."Signature Required":=recWhsShipHeader."Signature Required";
//             //recPackingHeader."Shipping Agent Service Code":=recWhsShipHeader."Shipping Agent Service Code";
//             //recPackingHeader."Shipping Account No":=ShiptoAccount;
//             //recPackingHeader."COD Amount":=recWhsShipHeader."COD Amount";
//             recPackingHeader.MODIFY;

//             //i :=1;
//             //WHILE (i <= TotPkg) DO BEGIN
//             recPackingLine.RESET;
//             recPackingLine.SETRANGE("Source Document Type", recPackingLine."Source Document Type"::"Warehouse Shipment");
//             recPackingLine.SETRANGE("Source Document No.", WhseCode);
//             recPackingLine.SETRANGE("Packing No.", recPackingHeader."Packing No.");
//             //recPackingLine.SETRANGE("Line No.",PkgLineNo[i]);
//             IF recPackingLine.FINDFIRST THEN BEGIN
//                 recPackingLine."Sales Order No." := recPackingHeader."Sales Order No.";
//                 recPackingLine."Shipping Agent Service Code" := recPackingHeader."Shipping Agent Service Code";
//                 recPackingLine."Tracking No." := TrackingNo;
//                 Bytes := Convert.FromBase64String(Image);
//                 MemoryStream := MemoryStream.MemoryStream(Bytes);
//                 recPackingLine.Image.CREATEOUTSTREAM(OStream);
//                 MemoryStream.WriteTo(OStream);
//                 recPackingLine.MODIFY;
//             END;
//             //i := i+1;
//         END;


//         /*
//         recTrackingNo.RESET;
//         recTrackingNo.SETRANGE(recTrackingNo."Warehouse Shipment No",WhseCode);
//         recTrackingNo.SETRANGE("Tracking No.",TrackingNo);
//         IF NOT recTrackingNo.FIND('-') THEN BEGIN
//             recTrackingNo.INIT;
//             recTrackingNo."Warehouse Shipment No":=WhseCode;
//             recTrackingNo."Tracking No.":=TrackingNo;
//             Bytes:=Convert.FromBase64String(Image);
//             MemoryStream:=MemoryStream.MemoryStream(Bytes);
//             recTrackingNo.Image.CREATEOUTSTREAM(OStream);
//             MemoryStream.WriteTo(OStream);
//             recTrackingNo.INSERT;
//         END;
//         */

//     end;


//     procedure UPSAdress(recWhsShipHeader: Record "Warehouse Shipment Header")
//     var
//         CustNo: Code[20];
//         recSalesHeader: Record "Sales Header";
//         recWhseShipLine: Record "Warehouse Shipment Line";
//         ReturnString: BigText;
//         txtRate: Text[500];
//         txtString: Text[1024];
//     begin
//         IF ISCLEAR(Xmlhttp) THEN
//             Result := CREATE(Xmlhttp, TRUE, TRUE);
//         //ELSE
//         //Result:=Create(Xmlhttp,TRUE);
//         Position := 0;
//         recWhseShipLine.RESET;
//         recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
//         IF recWhseShipLine.FIND('-') THEN;
//         recSalesHeader.RESET;
//         IF recSalesHeader.GET(recWhseShipLine."Source Subtype", recWhseShipLine."Source No.") THEN;


//         Xmlhttp.open('POST', 'http://uniapple.net/usaddress/address.php?address1=' + recSalesHeader."Ship-to Address" + ' ' + recSalesHeader."Ship-to Address 2" + '&city=' + recSalesHeader."Ship-to City" +
//             '&state=' + recSalesHeader."Ship-to County" + '&zipcode=' + recSalesHeader."Ship-to Post Code" + '&country=' + recSalesHeader."Ship-to Country/Region Code" + '&returntype=json');
//         Xmlhttp.send('');
//         //
//         Position := STRPOS(Xmlhttp.responseText(), '<body>');
//         //IF Position<>0 THEN
//         txtString := COPYSTR(Xmlhttp.responseText(), Position + 6);
//         MESSAGE(txtString);

//         Position := STRPOS(txtString, '"description"');

//         Position := Position + 20;

//         Position1 := STRPOS(txtString, '"},"address"');
//         Position1 := Position1;
//         IF (Position <> 0) THEN
//             IF (Position1 <> 0) THEN BEGIN
//                 txtString := COPYSTR(txtString, Position, Position1 - Position);
//                 MESSAGE(txtString);
//             END;
//     end;


//     procedure UPSRate(recWhsShipHeader: Record "Warehouse Shipment Header")
//     var
//         UPSUSERNAME: Label 'silktex';
//         UPSPASSWORD: Label 'Crafts12';
//         UPSLICENCE: Label 'ACE923D1E3142AC6';
//         CustNo: Code[20];
//         recSalesHeader: Record "Sales Header";
//         recWhseShipLine: Record "Warehouse Shipment Line";
//         ReturnString: BigText;
//         txtRate: Text[500];
//         recBoxMaster: Record "Box Master";
//     begin
//         /*IF ISCLEAR(Xmlhttp) THEN
//            Result:=CREATE(Xmlhttp,TRUE,TRUE);*/
//         //ELSE
//         //Result:=Create(Xmlhttp,TRUE);
//         /*Position:=0; */
//         recWhseShipLine.RESET;
//         recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
//         IF recWhseShipLine.FIND('-') THEN;
//         recSalesHeader.RESET;
//         IF recSalesHeader.GET(recWhseShipLine."Source Subtype", recWhseShipLine."Source No.") THEN;
//         //recCompanyInfo.GET;
//         //IF recSalesHeader."Ship-to Code"<>'' THEN BEGIN
//         CustNo := recSalesHeader."Sell-to Customer No.";
//         IF recBoxMaster.GET(recWhsShipHeader."Box Code") THEN;

//         HYPERLINK(RateText01 + '48_container=00&25_length=' + FORMAT(recBoxMaster.Length) + '&26_width=' + FORMAT(recBoxMaster.Width) + '&27_height=' + FORMAT(recBoxMaster.Height) +
//         '&22_destCountry=' + recSalesHeader."Ship-to Country/Region Code" + '&23_weight=' +
//         FORMAT(recWhsShipHeader."Gross Weight") + '&weight_std=lbs.&49_residential=' + '0' + '&19_destPostal=' + recSalesHeader."Ship-to Post Code" + '&20_destCity=' + recSalesHeader."Ship-to City");


//         /*Xmlhttp.open('POST','http://'+webserverIP+'/UPSShipping.ashx?Action=ShippingRate&userName='+UPSUSERNAME+'&password='+UPSPASSWORD+'&licenseNo='+UPSLICENCE+'&wSNo='+recWhsShipHeader."No."+'&custNo='+CustNo,0);
//         //'https://wsbeta.fedex.com:443/web-services',0);
//         Xmlhttp.send('');
//           // MESSAGE('%1',Xmlhttp.responseText);

//         Position := STRPOS(Xmlhttp.responseText(), 'Successfully requested');
//         IF Position=0 THEN
//            MESSAGE('%1',Xmlhttp.responseText)
//         ELSE
//            MESSAGE('Rate Successfully Requested');

//         txtRate:=COPYSTR(Xmlhttp.responseText(),Position+24);
//         //MESSAGE(txtRate);
//         EVALUATE(recWhsShipHeader.Rate,txtRate);
//         MESSAGE(txtRate);
//         recWhsShipHeader.MODIFY;
//         //decRate
//         */

//     end;


//     procedure EndiciaRequest(recWhsShipHeader: Record "Warehouse Shipment Header"; cdPickingNo: Code[20])
//     var
//         UPSUSERNAME: Label 'silktex';
//         UPSPASSWORD: Label 'Crafts12';
//         UPSLICENCE: Label 'ACE923D1E3142AC6';
//         CustNo: Code[20];
//         recSalesHeader: Record "Sales Header";
//         recWhseShipLine: Record "Warehouse Shipment Line";
//         ReturnString: BigText;
//         recSalesLine: Record "Sales Line";
//         txtInsurance: Text[10];
//         txtCOD: Text[10];
//         TotalAmount: Decimal;
//         IsDomestic: Boolean;
//     begin
//         CLEAR(Xmlhttp);
//         IF ISCLEAR(Xmlhttp) THEN
//             Result := CREATE(Xmlhttp, TRUE, TRUE);
//         Position := 0;
//         TotalAmount := 0;
//         TotalAmount := 0;
//         recWhseShipLine.RESET;
//         recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
//         recWhseShipLine.SETFILTER("Qty. to Ship", '<>%1', 0);
//         recWhseShipLine.SETRANGE("Source Type", 37);
//         recWhseShipLine.SETRANGE("Source Subtype", 1);
//         IF recWhseShipLine.FIND('-') THEN BEGIN
//             REPEAT
//                 recSalesLine.RESET;
//                 recSalesLine.SETRANGE("Document No.", recWhseShipLine."Source No.");
//                 recSalesLine.SETRANGE("Line No.", recWhseShipLine."Source Line No.");
//                 IF recSalesLine.FIND('-') THEN BEGIN
//                     REPEAT
//                         TotalAmount := TotalAmount + recWhseShipLine."Qty. to Ship" * recSalesLine."Unit Price";
//                     UNTIL recSalesLine.NEXT = 0;
//                 END;
//             UNTIL recWhseShipLine.NEXT = 0;
//         END;
//         IF recWhsShipHeader."Insurance Amount" <> 0 THEN
//             txtInsurance := 'Yes'
//         ELSE
//             txtInsurance := 'No';


//         IF recWhsShipHeader."Cash On Delivery" THEN
//             txtCOD := 'Yes'
//         ELSE
//             txtCOD := 'No';
//         IF recWhsShipHeader."Signature Required" THEN
//             txtSignature := 'Yes'
//         ELSE
//             txtSignature := 'No';
//         recWhseShipLine.RESET;
//         recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
//         IF recWhseShipLine.FIND('-') THEN;
//         recSalesHeader.RESET;
//         IF recSalesHeader.GET(recWhseShipLine."Source Subtype", recWhseShipLine."Source No.") THEN;
//         CustNo := recSalesHeader."Sell-to Customer No.";
//         TotalAmount1 := FORMAT(recWhsShipHeader."Insurance Amount");
//         TotalAmount1 := DELCHR(TotalAmount1, '=', ',');
//         txtCodAmount := FORMAT(TotalAmount);
//         IF recWhsShipHeader."COD Amount" <> 0 THEN
//             txtCodAmount := FORMAT(recWhsShipHeader."COD Amount");

//         txtCodAmount := DELCHR(txtCodAmount, '=', ',');

//         IF recWhsShipHeader."Label Type" = recWhsShipHeader."Label Type"::Domestic THEN BEGIN
//             Xmlhttp.open('POST', 'http://silk4:47471/EndeciaHandler.ashx?Action=SaveShipping&COD=' + txtCOD + '&CODAmount=' + txtCodAmount + '&wSNo=' + recWhsShipHeader."No." + '&Insu=' + txtInsurance + '&InsuAmount=' + TotalAmount1 +
//               '&custNo=' + CustNo + '&AdultSign=' + txtSignature + '&MailClass=' + recWhsShipHeader."Shipping Agent Service Code", 0);

//         END ELSE
//             IF recWhsShipHeader."Label Type" = recWhsShipHeader."Label Type"::International THEN BEGIN
//                 Xmlhttp.open('POST', 'http://silk4:54444/EndeciaInternational.ashx?Action=SaveShipping&COD=' + txtCOD + '&CODAmount=' + txtCodAmount + '&wSNo=' + recWhsShipHeader."No." + '&Insu=' + txtInsurance + '&InsuAmount=' + TotalAmount1 +
//                   '&custNo=' + CustNo + '&AdultSign=' + txtSignature + '&MailClass=' + recWhsShipHeader."Shipping Agent Service Code" + '&packNo=' + cdPickingNo);
//             END;
//         Xmlhttp.send('');
//         MESSAGE('%1', Xmlhttp.responseText);
//         CLEAR(ReturnString);
//         ReturnString.ADDTEXT(Xmlhttp.responseText);

//         Position := STRPOS(Xmlhttp.responseText(), 'created successfully:');
//         //IF Position=0 THEN
//         // MESSAGE('%1',Xmlhttp.responseText)
//         //ELSE
//         // MESSAGE('Shipment created Successfully');
//     end;


//     procedure RefundEndiciaPayment(TrackingNo: Text[30]; TransactionId: Text[30])
//     begin
//         CLEAR(Xmlhttp);
//         IF ISCLEAR(Xmlhttp) THEN
//             Result := CREATE(Xmlhttp, TRUE, TRUE);

//         Xmlhttp.open('POST', 'http://192.168.1.228:47471/EndeciaHandler.ashx?Action=RefundShipping&PicNo=' + TrackingNo + '&TraId=' + TransactionId, 0);
//         Xmlhttp.send('');
//         MESSAGE('%1', Xmlhttp.responseText);
//     end;


//     procedure StandardOverNight(recWhsShipHeader: Record "Warehouse Shipment Header")
//     var
//         recCustomer: Record Customer;
//         txtPaymentType: Text[30];
//         ResponsibleCountry: Code[10];
//         ResponsiblePost: Code[20];
//         ResponsibleState: Code[20];
//         ResponsibleCity: Code[20];
//         ResponsibleAddress: Text[50];
//         ResponsiblePhone: Text[30];
//         ResponsibleCompany: Text[50];
//         ResponsibleEmail: Text[50];
//         ResponsiblePerson: Text[50];
//         ResponsibleAccNo: Text[30];
//         decNetWeigh: Decimal;
//         recSalesLine: Record "Sales Line";
//         decAmount: Decimal;
//         txtAmount: Text[25];
//         recSalesHeader: Record "Sales Header";
//         recWhseShipLine: Record "Warehouse Shipment Line";
//         recBoxMaster: Record "Box Master";
//         txtPackageDetail: BigText;
//         intNo: Integer;
//         txtPackagedet: array[5] of Text[1000];
//         intLength: Integer;
//         SalesRelease: Codeunit "Release Sales Document";
//         txtMessage: Text[500];
//         txtYear: Text[10];
//         txtMonth: Text[10];
//         txtDate: Text[10];
//         intDate: Integer;
//         intMonth: Integer;
//         intYear: Integer;
//         recShipAgentService: Record "Shipping Agent Services";
//         txtShipService: Text[100];
//         recShiptoAddress: Record "Ship-to Address";
//         ShiptoName: Text[50];
//         ShiptoAddress: Text[50];
//         ShiptoAddress2: Text[50];
//         ShiptoEmail: Text[50];
//         ShiptoPhone: Text[30];
//         ShiptoState: Text[30];
//         ShiptoCountry: Text[30];
//         ShiptoPostCode: Text[30];
//         ShiptoContact: Text[50];
//         ShiptoAccount: Code[20];
//         ShiptoCity: Text[30];
//         txtShipTime: Text[50];
//         intLineNo: Integer;
//         recSalesShipHeader: Record "Sales Shipment Header";
//         WhseSetup: Record "Warehouse Setup";
//         SpecialServiceTxt: array[10] of Text[1000];
//         outFile: File;
//         outStream1: OutStream;
//         streamWriter: DotNet StreamWriter;
//         encoding: DotNet Encoding;
//         recTrackingNo: Record "Tracking No.";
//         ShiptoResidential: Text[5];
//         recPackingHeader: Record "Packing Header";
//         recPackingLine: Record "Packing Line";
//         i: Integer;
//     begin

//         //recSalesHeader:=SalesHeader;
//         //recSalesHeader;


//         IF recWhsShipHeader."Track On Header" THEN BEGIN
//             recWhseShipLine.RESET;
//             recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
//             IF recWhseShipLine.FIND('-') THEN;
//             intDate := DATE2DMY(recWhsShipHeader."Shipment Date", 1);
//             intMonth := DATE2DMY(recWhsShipHeader."Shipment Date", 2);
//             intYear := DATE2DMY(recWhsShipHeader."Shipment Date", 3);
//             txtDate := FORMAT(intDate);
//             txtMonth := FORMAT(intMonth);
//             txtYear := FORMAT(intYear);
//             IF intYear < 100 THEN
//                 txtYear := '20' + txtYear;
//             IF STRLEN(txtMonth) < 2 THEN
//                 txtMonth := '0' + txtMonth;
//             IF STRLEN(txtDate) < 2 THEN
//                 txtDate := '0' + txtDate;
//             recSalesHeader.RESET;
//             IF recSalesHeader.GET(recWhseShipLine."Source Subtype", recWhseShipLine."Source No.") THEN;
//             recCompanyInfo.GET;
//             IF recSalesHeader."Ship-to Code" <> '' THEN BEGIN

//                 recCustomer.GET(recSalesHeader."Sell-to Customer No.");
//                 recShiptoAddress.GET(recSalesHeader."Sell-to Customer No.", recSalesHeader."Ship-to Code");
//                 ShiptoName := recShiptoAddress.Name;
//                 ShiptoAddress := recShiptoAddress.Address;
//                 ShiptoAddress2 := recShiptoAddress."Address 2";
//                 ShiptoCity := recShiptoAddress.City;
//                 ShiptoState := recShiptoAddress.County;
//                 ShiptoAccount := recShiptoAddress."Shipping Account No.";
//                 IF ShiptoAccount = '' THEN
//                     ShiptoAccount := recCustomer."Shipping Account No.";
//                 IF recShiptoAddress."Third Party" THEN
//                     txtPaymentType := 'THIRD_PARTY';
//                 ShiptoPostCode := recShiptoAddress."Post Code";

//                 ShiptoCountry := recShiptoAddress."Country/Region Code";
//                 ShiptoEmail := recShiptoAddress."E-Mail";
//                 ShiptoContact := recShiptoAddress.Contact;
//                 ShiptoPhone := recShiptoAddress."Phone No.";
//                 ShiptoResidential := 'false';
//                 IF recShiptoAddress.Residential THEN
//                     ShiptoResidential := 'true';
//             END ELSE BEGIN
//                 recCustomer.GET(recSalesHeader."Sell-to Customer No.");
//                 ShiptoName := recCustomer.Name;
//                 ShiptoAddress := recCustomer.Address;
//                 ShiptoAddress2 := recCustomer."Address 2";
//                 ShiptoCity := recCustomer.City;
//                 ShiptoState := recCustomer.County;
//                 ShiptoAccount := recCustomer."Shipping Account No.";
//                 ShiptoPostCode := recCustomer."Post Code";

//                 ShiptoCountry := recCustomer."Country/Region Code";
//                 ShiptoEmail := recCustomer."E-Mail";
//                 ShiptoContact := recCustomer.Contact;
//                 ShiptoPhone := recCustomer."Phone No.";
//                 ShiptoResidential := 'false';
//                 IF recCustomer.Residential THEN
//                     ShiptoResidential := 'true';
//             END;
//             ShiptoName := AttributetoString(ShiptoName);
//             ShiptoAddress := AttributetoString(ShiptoAddress);
//             ShiptoAddress2 := AttributetoString(ShiptoAddress2);
//             ShiptoEmail := AttributetoString(ShiptoEmail);
//             ShiptoContact := AttributetoString(ShiptoContact);


//             recLocation.GET(recSalesHeader."Location Code");
//             CLEAR(txtPackageDetail);
//             recShipAgentService.GET(recWhsShipHeader."Shipping Agent Code", recWhsShipHeader."Shipping Agent Service Code");
//             txtShipService := recShipAgentService.Description;

//             recPackingHeader.RESET;
//             recPackingHeader.SETRANGE("Source Document Type", recPackingHeader."Source Document Type"::"Warehouse Shipment");
//             recPackingHeader.SETRANGE("Source Document No.", recWhsShipHeader."No.");
//             IF recPackingHeader.FINDFIRST THEN
//                 recPackingHeader.CALCFIELDS("Gross Weight");
//             recPackingHeader.CALCFIELDS("No. of Boxes");
//             recPackingLine.RESET;
//             recPackingLine.SETRANGE("Source Document Type", recPackingLine."Source Document Type"::"Warehouse Shipment");
//             recPackingLine.SETRANGE("Source Document No.", recWhsShipHeader."No.");
//             recPackingLine.SETRANGE("Packing No.", recPackingHeader."Packing No.");
//             IF recPackingLine.FINDFIRST THEN
//                 recBoxMaster.RESET;
//             IF recBoxMaster.GET(recPackingLine."Box Code") THEN;

//             decNetWeigh := 0;
//             intNo := 0;
//             TotalAmount := 0;
//             recWhseShipLine.RESET;
//             recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
//             recWhseShipLine.SETFILTER("Qty. to Ship", '<>%1', 0);
//             IF recWhseShipLine.FIND('-') THEN BEGIN
//                 REPEAT
//                     recItem.GET(recWhseShipLine."Item No.");
//                     decNetWeigh := decNetWeigh + recWhseShipLine."Qty. to Ship" * recItem.Weight;
//                     intNo += 1;
//                     recSalesLine.RESET;
//                     recSalesLine.SETRANGE("Document No.", recWhseShipLine."Source No.");
//                     recSalesLine.SETRANGE("Line No.", recWhseShipLine."Source Line No.");

//                     IF recSalesLine.FIND('-') THEN BEGIN
//                         REPEAT
//                             TotalAmount := TotalAmount + recWhseShipLine."Qty. to Ship" * recSalesLine."Unit Price";

//                         UNTIL recSalesLine.NEXT = 0;
//                     END;
//                 UNTIL recWhseShipLine.NEXT = 0;
//             END;
//             TotalAmount1 := '';

//             TotalAmount1 := FORMAT(TotalAmount);
//             IF recWhsShipHeader."COD Amount" <> 0 THEN
//                 TotalAmount1 := FORMAT(recWhsShipHeader."COD Amount");
//             TotalAmount1 := DELCHR(TotalAmount1, '=', ',');



//             IF recWhsShipHeader."Cash On Delivery" THEN BEGIN
//                 IF recWhsShipHeader."Signature Required" THEN
//                     txtDeliveryAcceptance := 'DELIVERY_ON_INVOICE_ACCEPTANCE'
//                 ELSE
//                     txtDeliveryAcceptance := '';
//                 CLEAR(SpecialService);
//                 SpecialService1 := '';
//                 IF recWhsShipHeader."Signature Required" THEN BEGIN
//                     SpecialService.ADDTEXT('<SpecialServicesRequested>' +
//                     '<SpecialServiceTypes>COD</SpecialServiceTypes>' +
//                     '<SpecialServiceTypes>DELIVERY_ON_INVOICE_ACCEPTANCE</SpecialServiceTypes>' +
//                     '<CodDetail>' +
//                     '<CodCollectionAmount>' +
//                     '<Currency>USD</Currency>' +
//                     '<Amount>' + TotalAmount1 + '</Amount>' +
//                     '</CodCollectionAmount>' +
//                     '<CollectionType>ANY</CollectionType>' +
//                     '<FinancialInstitutionContactAndAddress>' +
//                     '<Contact>' +
//                     '<PersonName>' + ShiptoContact + '</PersonName>' +
//                     '<CompanyName>' + ShiptoName + '</CompanyName>' +
//                     '<PhoneNumber>' + ShiptoPhone + '</PhoneNumber>' +
//                     '</Contact>' +
//                     '<Address>' +
//                     '<StreetLines>' + ShiptoAddress + ' ' + ShiptoAddress2 + '</StreetLines>' +
//                     '<City>' + ShiptoCity + '</City>' +
//                     '<StateOrProvinceCode>' + ShiptoState + '</StateOrProvinceCode>' +
//                     '<PostalCode>' + ShiptoPostCode + '</PostalCode>' +
//                     '<CountryCode>' + ShiptoCountry + '</CountryCode>' +
//                     '<Residential>' + ShiptoResidential + '</Residential>' +
//                     '</Address>' +
//                     '</FinancialInstitutionContactAndAddress>' +
//                     '<RemitToName>' + ShiptoContact + '</RemitToName>' +
//                     '</CodDetail>' +
//                     '<DeliveryOnInvoiceAcceptanceDetail>' +
//                     '<Recipient>' +
//                     '<AccountNumber>' + ShiptoAccount + '</AccountNumber>' +
//                     '<Contact>' +
//                     '<PersonName>' + ShiptoContact + '</PersonName>' +
//                     '<CompanyName>' + COMPANYNAME + '</CompanyName>' +
//                     '<PhoneNumber>' + ShiptoPhone + '</PhoneNumber>' +
//                     '</Contact>' +
//                     '<Address>' +
//                     '<StreetLines>' + ShiptoAddress + ' ' + ShiptoAddress2 + '</StreetLines>' +
//                     '<City>' + ShiptoCity + '</City>' +
//                     '<StateOrProvinceCode>' + ShiptoState + '</StateOrProvinceCode>' +
//                     '<PostalCode>' + ShiptoPostCode + '</PostalCode>' +
//                     '<CountryCode>' + ShiptoCountry + '</CountryCode>' +
//                     '<Residential>' + ShiptoResidential + '</Residential>' +
//                     '</Address>' +
//                     '</Recipient>' +
//                     '</DeliveryOnInvoiceAcceptanceDetail>' +
//                     '</SpecialServicesRequested>');
//                 END ELSE BEGIN
//                     SpecialService.ADDTEXT('<SpecialServicesRequested>' +
//                     '<SpecialServiceTypes>COD</SpecialServiceTypes>' +
//                     '<CodDetail>' +
//                     '<CodCollectionAmount>' +
//                     '<Currency>USD</Currency>' +
//                     '<Amount>' + TotalAmount1 + '</Amount>' +
//                     '</CodCollectionAmount>' +
//                     '<CollectionType>ANY</CollectionType>' +
//                     '</CodDetail>' +
//                     '</SpecialServicesRequested>');
//                     SpecialService1 := '<SpecialServicesRequested>' +
//                     '<SpecialServiceTypes>COD</SpecialServiceTypes>' +
//                     '<CodDetail>' +
//                     '<CodCollectionAmount>' +
//                     '<Currency>USD</Currency>' +
//                     '<Amount>' + TotalAmount1 + '</Amount>' +
//                     '</CodCollectionAmount>' +
//                     '<CollectionType>ANY</CollectionType>' +
//                     '</CodDetail>' +
//                     '</SpecialServicesRequested>';
//                 END;
//             END;

//             intLen := SpecialService.LENGTH;
//             FOR intCount := 1 TO 10 DO BEGIN
//                 SpecialServiceTxt[intCount] := '';
//             END;
//             IF intLen <> 0 THEN
//                 SpecialService.GETSUBTEXT(SpecialServiceTxt[1], 1, 1000);
//             IF intLen > 1000 THEN
//                 SpecialService.GETSUBTEXT(SpecialServiceTxt[2], 1001, 2000);
//             IF intLen > 2000 THEN
//                 SpecialService.GETSUBTEXT(SpecialServiceTxt[3], 2001, 3000);
//             IF intLen > 3000 THEN
//                 SpecialService.GETSUBTEXT(SpecialServiceTxt[4], 3001, 4000);
//             IF intLen > 4000 THEN
//                 SpecialService.GETSUBTEXT(SpecialServiceTxt[5], 4001, 5000);
//             IF intLen > 5000 THEN
//                 SpecialService.GETSUBTEXT(SpecialServiceTxt[6], 5001, 6000);
//             IF intLen > 6000 THEN
//                 SpecialService.GETSUBTEXT(SpecialServiceTxt[7], 6001, 7000);
//             IF intLen > 7000 THEN
//                 SpecialService.GETSUBTEXT(SpecialServiceTxt[8], 7001, 8000);
//             IF intLen > 8000 THEN
//                 SpecialService.GETSUBTEXT(SpecialServiceTxt[9], 8001, 9000);
//             IF intLen > 9000 THEN
//                 SpecialService.GETSUBTEXT(SpecialServiceTxt[10], 9001, 10000);


//             intLength := 0;
//             intLength := txtPackageDetail.LENGTH;
//             IF intLength <> 0 THEN
//                 txtPackageDetail.GETSUBTEXT(txtPackagedet[1], 1, 1000);
//             IF intLength > 1000 THEN
//                 txtPackageDetail.GETSUBTEXT(txtPackagedet[2], 1001, 2000);
//             IF intLength > 2000 THEN
//                 txtPackageDetail.GETSUBTEXT(txtPackagedet[3], 2001, 3000);
//             IF intLength > 3000 THEN
//                 txtPackageDetail.GETSUBTEXT(txtPackagedet[4], 3001, 4000);
//             IF intLength > 4000 THEN
//                 txtPackageDetail.GETSUBTEXT(txtPackagedet[5], 4001, 5000);

//             IF ISCLEAR(Xmlhttp) THEN
//                 Result := CREATE(Xmlhttp, TRUE, TRUE);

//             IF recPackingHeader."Charges Pay By" = 'SENDER' THEN BEGIN
//                 ResponsibleAccNo := AccountNo;
//                 ResponsiblePerson := recLocation.Contact;
//                 ResponsibleEmail := recLocation."E-Mail";
//                 ResponsibleCompany := recCompanyInfo.Name;
//                 ResponsiblePhone := recLocation."Phone No.";
//                 ResponsibleAddress := recLocation.Address;
//                 ResponsibleCity := recLocation.City;
//                 ResponsibleState := recLocation.County;
//                 ResponsiblePost := recLocation."Post Code";
//                 ResponsibleCountry := recLocation."Country/Region Code";
//                 txtPaymentType := 'SENDER';
//             END ELSE BEGIN

//                 ResponsibleAccNo := recCustomer."Shipping Account No.";
//                 ResponsiblePerson := recCustomer.Contact;
//                 ResponsibleEmail := recCustomer."E-Mail";
//                 ResponsibleCompany := recCustomer.Name;
//                 ResponsiblePhone := recCustomer."Phone No.";
//                 ResponsibleAddress := recCustomer.Address;
//                 ResponsibleCity := recCustomer.City;
//                 ResponsibleState := recCustomer.County;
//                 ResponsiblePost := recCustomer."Post Code";
//                 ResponsibleCountry := recCustomer."Country/Region Code";
//                 IF txtPaymentType <> 'THIRD_PARTY' THEN
//                     txtPaymentType := 'RECIPIENT';
//             END;

//             ResponsiblePerson := AttributetoString(ResponsiblePerson);
//             ResponsibleCompany := AttributetoString(ResponsibleCompany);
//             ResponsibleAddress := AttributetoString(ResponsibleAddress);
//             ResponsibleEmail := AttributetoString(ResponsibleEmail);


//             decInsuredAmount := recWhsShipHeader."Insurance Amount";
//             IF decInsuredAmount <> 0 THEN
//                 txtInsuredAmount := DELCHR(FORMAT(decInsuredAmount), '=', ',')
//             ELSE
//                 txtInsuredAmount := '';
//             IF recWhsShipHeader."Insurance Amount" > 0 THEN BEGIN
//                 txtInsurance1 :=
//                 '<TotalInsuredValue>' +
//                         '<Currency>USD</Currency>' +
//                         '<Amount>' + (txtInsuredAmount) + '</Amount>' +
//                 '</TotalInsuredValue>';

//                 txtInsurance :=
//                 '<GroupPackageCount>1</GroupPackageCount>' +
//                 '<InsuredValue>' +
//                         '<Currency>USD</Currency>' +
//                         '<Amount>' + (txtInsuredAmount) + '</Amount>' +
//                 '</InsuredValue>';


//             END ELSE BEGIN
//                 txtInsurance := '';
//                 txtInsurance1 := '';
//             END;
//             txtShipTime := FORMAT(recWhsShipHeader."Shipment Time", 0, '<Hours24,2><Filler Character,0>:<Minutes,2>:<Seconds,2>');
//             IF blnGenerateNote THEN BEGIN
//                 //outFile.CREATE('C:\ProgramData\Microsoft\Microsoft Dynamics NAV\71\Server\MicrosoftDynamicsNavServer$SC\temp'+'\'+recWhsShipHeader."No."+'.txt');
//                 outFile.CREATE('C:\ProgramData\Microsoft\Microsoft Dynamics NAV\71\Server\MicrosoftDynamicsNavServer$SC_Live_170830\temp' + '\' + recWhsShipHeader."No." + '.txt');
//                 outFile.CREATEOUTSTREAM(outStream1);
//                 streamWriter := streamWriter.StreamWriter(outStream1, encoding.UTF8);

//                 streamWriter.WriteLine('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://fedex.com/ws/ship/v13">');
//                 streamWriter.WriteLine('<soapenv:Body>');
//                 streamWriter.WriteLine('<ProcessShipmentRequest xmlns="http://fedex.com/ws/ship/v13">');
//                 streamWriter.WriteLine('<WebAuthenticationDetail>');
//                 streamWriter.WriteLine('<UserCredential>');
//                 streamWriter.WriteLine('<Key>' + Key + '</Key>');
//                 streamWriter.WriteLine('<Password>' + Password + '</Password>');
//                 streamWriter.WriteLine('</UserCredential>');
//                 streamWriter.WriteLine('</WebAuthenticationDetail>');
//                 streamWriter.WriteLine('<ClientDetail>');
//                 streamWriter.WriteLine('<AccountNumber>' + AccountNo + '</AccountNumber>');
//                 streamWriter.WriteLine('<MeterNumber>' + MeterNo + '</MeterNumber>');
//                 streamWriter.WriteLine('</ClientDetail>');
//                 streamWriter.WriteLine('<TransactionDetail>');
//                 streamWriter.WriteLine('<CustomerTransactionId>' + recSalesHeader."No." + '</CustomerTransactionId>');
//                 streamWriter.WriteLine('</TransactionDetail>');
//                 streamWriter.WriteLine('<Version>');
//                 streamWriter.WriteLine('<ServiceId>ship</ServiceId>');
//                 streamWriter.WriteLine('<Major>13</Major>');
//                 streamWriter.WriteLine('<Intermediate>0</Intermediate>');
//                 streamWriter.WriteLine('<Minor>0</Minor>');
//                 streamWriter.WriteLine('</Version>');
//                 streamWriter.WriteLine('<RequestedShipment>');
//                 streamWriter.WriteLine('<ShipTimestamp>' + txtYear + '-' + txtMonth + '-' + txtDate + 'T' + txtShipTime + '-05:00</ShipTimestamp>');
//                 streamWriter.WriteLine('<DropoffType>REGULAR_PICKUP</DropoffType>');
//                 streamWriter.WriteLine('<ServiceType>' + txtShipService + '</ServiceType>');
//                 streamWriter.WriteLine('<PackagingType>YOUR_PACKAGING</PackagingType>');
//                 streamWriter.WriteLine(txtInsurance1);
//                 streamWriter.WriteLine('<Shipper>');
//                 streamWriter.WriteLine('<AccountNumber>' + AccountNo + '</AccountNumber>');
//                 streamWriter.WriteLine('<Contact>');
//                 streamWriter.WriteLine('<PersonName>' + recLocation.Contact + '</PersonName>');
//                 streamWriter.WriteLine('<CompanyName>' + recCompeny.Name + '</CompanyName>');
//                 streamWriter.WriteLine('<PhoneNumber>' + recLocation."Phone No." + '</PhoneNumber>');
//                 streamWriter.WriteLine('<EMailAddress>' + recLocation."E-Mail" + '</EMailAddress>');
//                 streamWriter.WriteLine('</Contact>');
//                 streamWriter.WriteLine('<Address>');
//                 streamWriter.WriteLine('<StreetLines>' + recLocation.Address + '</StreetLines>');
//                 streamWriter.WriteLine('<City>' + recLocation.City + '</City>');
//                 streamWriter.WriteLine('<StateOrProvinceCode>' + recLocation.County + '</StateOrProvinceCode>');
//                 streamWriter.WriteLine('<PostalCode>' + recLocation."Post Code" + '</PostalCode>');
//                 streamWriter.WriteLine('<CountryCode>' + recLocation."Country/Region Code" + '</CountryCode>');
//                 streamWriter.WriteLine('</Address>');
//                 streamWriter.WriteLine('</Shipper>');
//                 streamWriter.WriteLine('<Recipient>');
//                 streamWriter.WriteLine('<AccountNumber>' + ShiptoAccount + '</AccountNumber>');
//                 streamWriter.WriteLine('<Contact>');
//                 streamWriter.WriteLine('<PersonName>' + ShiptoContact + '</PersonName>');
//                 streamWriter.WriteLine('<CompanyName>' + ShiptoName + '</CompanyName>');
//                 streamWriter.WriteLine('<PhoneNumber>' + ShiptoPhone + '</PhoneNumber>');
//                 streamWriter.WriteLine('<EMailAddress>' + ShiptoEmail + '</EMailAddress>');
//                 streamWriter.WriteLine('</Contact>');
//                 streamWriter.WriteLine('<Address>');
//                 streamWriter.WriteLine('<StreetLines>' + ShiptoAddress + ' ' + ShiptoAddress2 + '</StreetLines>');
//                 streamWriter.WriteLine('<City>' + ShiptoCity + '</City>');
//                 streamWriter.WriteLine('<StateOrProvinceCode>' + ShiptoState + '</StateOrProvinceCode>');
//                 streamWriter.WriteLine('<PostalCode>' + ShiptoPostCode + '</PostalCode>');
//                 streamWriter.WriteLine('<CountryCode>' + ShiptoCountry + '</CountryCode>');
//                 streamWriter.WriteLine('<Residential>' + ShiptoResidential + '</Residential>');
//                 streamWriter.WriteLine('</Address>');
//                 streamWriter.WriteLine('</Recipient>');
//                 streamWriter.WriteLine('<ShippingChargesPayment>');
//                 streamWriter.WriteLine('<PaymentType>' + txtPaymentType + '</PaymentType>');
//                 streamWriter.WriteLine('<Payor>');
//                 streamWriter.WriteLine('<ResponsibleParty>');
//                 streamWriter.WriteLine('<AccountNumber>' + ResponsibleAccNo + '</AccountNumber>');
//                 streamWriter.WriteLine('<Contact>');
//                 streamWriter.WriteLine('<PersonName>' + ResponsiblePerson + '</PersonName>');
//                 streamWriter.WriteLine('<EMailAddress>' + ResponsibleEmail + '</EMailAddress>');
//                 streamWriter.WriteLine('</Contact>');
//                 streamWriter.WriteLine('</ResponsibleParty>');
//                 streamWriter.WriteLine('</Payor>');
//                 streamWriter.WriteLine('</ShippingChargesPayment>');
//                 streamWriter.WriteLine(SpecialServiceTxt[1] + SpecialServiceTxt[2] + SpecialServiceTxt[3] + SpecialServiceTxt[4] + SpecialServiceTxt[5]);
//                 streamWriter.WriteLine(SpecialServiceTxt[6] + SpecialServiceTxt[7] + SpecialServiceTxt[8] + SpecialServiceTxt[9] + SpecialServiceTxt[10]);
//                 streamWriter.WriteLine('<LabelSpecification>');
//                 streamWriter.WriteLine('<LabelFormatType>COMMON2D</LabelFormatType>');
//                 streamWriter.WriteLine('<ImageType>ZPLII</ImageType>');
//                 streamWriter.WriteLine('<LabelStockType>STOCK_4X8</LabelStockType>');
//                 streamWriter.WriteLine('</LabelSpecification>');
//                 streamWriter.WriteLine('<RateRequestTypes>LIST</RateRequestTypes>');
//                 streamWriter.WriteLine('<PackageCount>' + FORMAT(recPackingHeader."No. of Boxes") + '</PackageCount>');
//                 streamWriter.WriteLine('<RequestedPackageLineItems>');
//                 streamWriter.WriteLine('<SequenceNumber>1</SequenceNumber>');
//                 streamWriter.WriteLine('<Weight>');
//                 streamWriter.WriteLine('<Units>LB</Units>');
//                 streamWriter.WriteLine('<Value>' + FORMAT(recPackingHeader."Gross Weight") + '</Value>');
//                 streamWriter.WriteLine('</Weight>');
//                 streamWriter.WriteLine('<Dimensions>');
//                 streamWriter.WriteLine('<Length>' + FORMAT(recBoxMaster.Length) + '</Length>');
//                 streamWriter.WriteLine('<Width>' + FORMAT(recBoxMaster.Width) + '</Width>');
//                 streamWriter.WriteLine('<Height>' + FORMAT(recBoxMaster.Height) + '</Height>');
//                 streamWriter.WriteLine('<Units>IN</Units>');
//                 streamWriter.WriteLine('</Dimensions>');
//                 streamWriter.WriteLine('<PhysicalPackaging>BOX</PhysicalPackaging>');
//                 streamWriter.WriteLine('<ItemDescription>' + recWhseShipLine.Description + '</ItemDescription>');
//                 streamWriter.WriteLine('<CustomerReferences>');
//                 streamWriter.WriteLine('<CustomerReferenceType>CUSTOMER_REFERENCE</CustomerReferenceType>');
//                 streamWriter.WriteLine('<Value>' + recWhsShipHeader."External Document No." + '</Value>');
//                 streamWriter.WriteLine('</CustomerReferences>');
//                 streamWriter.WriteLine('</RequestedPackageLineItems>');
//                 streamWriter.WriteLine('</RequestedShipment>');
//                 streamWriter.WriteLine('</ProcessShipmentRequest>');
//                 streamWriter.WriteLine('</soapenv:Body>');
//                 streamWriter.WriteLine('</soapenv:Envelope>');

//                 streamWriter.Close();
//                 outFile.CLOSE();
//             END;

//             Xmlhttp.open('POST', ' https://ws.fedex.com:443/web-services', 0);//'https://wsbeta.fedex.com:443/web-services',0);
//             Xmlhttp.send('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://fedex.com/ws/ship/v13">' +
//             '<soapenv:Body>' +
//             '<ProcessShipmentRequest xmlns="http://fedex.com/ws/ship/v13">' +
//             '<WebAuthenticationDetail>' +
//             '<UserCredential>' +
//             '<Key>' + Key + '</Key>' +
//             '<Password>' + Password + '</Password>' +
//             '</UserCredential>' +
//             '</WebAuthenticationDetail>' +
//             '<ClientDetail>' +
//             '<AccountNumber>' + AccountNo + '</AccountNumber>' +
//             '<MeterNumber>' + MeterNo + '</MeterNumber>' +
//             '</ClientDetail>' +
//             '<TransactionDetail>' +
//             '<CustomerTransactionId>' + recSalesHeader."No." + '</CustomerTransactionId>' +
//             '</TransactionDetail>' +
//             '<Version>' +
//             '<ServiceId>ship</ServiceId>' +
//             '<Major>13</Major>' +
//             '<Intermediate>0</Intermediate>' +
//             '<Minor>0</Minor>' +
//             '</Version>' +
//             '<RequestedShipment>' +
//             '<ShipTimestamp>' + txtYear + '-' + txtMonth + '-' + txtDate + 'T' + txtShipTime + '-05:00</ShipTimestamp>' +
//             '<DropoffType>REGULAR_PICKUP</DropoffType>' +
//             '<ServiceType>' + txtShipService + '</ServiceType>' +
//             '<PackagingType>YOUR_PACKAGING</PackagingType>' +
//             txtInsurance1 +
//             '<Shipper>' +
//             '<AccountNumber>' + AccountNo + '</AccountNumber>' +
//             '<Contact>' +
//             '<PersonName>' + recLocation.Contact + '</PersonName>' +
//             '<CompanyName>' + recCompeny.Name + '</CompanyName>' +
//             '<PhoneNumber>' + recLocation."Phone No." + '</PhoneNumber>' +
//             '<EMailAddress>' + recLocation."E-Mail" + '</EMailAddress>' +
//             '</Contact>' +
//             '<Address>' +
//             '<StreetLines>' + recLocation.Address + '</StreetLines>' +
//             '<City>' + recLocation.City + '</City>' +
//             '<StateOrProvinceCode>' + recLocation.County + '</StateOrProvinceCode>' +
//             '<PostalCode>' + recLocation."Post Code" + '</PostalCode>' +
//             '<CountryCode>' + recLocation."Country/Region Code" + '</CountryCode>' +
//             '</Address>' +
//             '</Shipper>' +
//             '<Recipient>' +
//             '<AccountNumber>' + ShiptoAccount + '</AccountNumber>' +
//             '<Contact>' +
//             '<PersonName>' + ShiptoContact + '</PersonName>' +
//             '<CompanyName>' + ShiptoName + '</CompanyName>' +
//             '<PhoneNumber>' + ShiptoPhone + '</PhoneNumber>' +
//             '<EMailAddress>' + ShiptoEmail + '</EMailAddress>' +
//             '</Contact>' +
//             '<Address>' +
//             '<StreetLines>' + ShiptoAddress + ' ' + ShiptoAddress2 + '</StreetLines>' +
//             '<City>' + ShiptoCity + '</City>' +
//             '<StateOrProvinceCode>' + ShiptoState + '</StateOrProvinceCode>' +
//             '<PostalCode>' + ShiptoPostCode + '</PostalCode>' +
//             '<CountryCode>' + ShiptoCountry + '</CountryCode>' +
//             '<Residential>' + ShiptoResidential + '</Residential>' +
//             '</Address>' +
//             '</Recipient>' +
//             '<ShippingChargesPayment>' +

//             '<PaymentType>' + txtPaymentType + '</PaymentType>' +
//             '<Payor>' +
//             '<ResponsibleParty>' +
//             '<AccountNumber>' + ResponsibleAccNo + '</AccountNumber>' +
//             '<Contact>' +
//             '<PersonName>' + ResponsiblePerson + '</PersonName>' +
//             '<EMailAddress>' + ResponsibleEmail + '</EMailAddress>' +
//             '</Contact>' +
//             '</ResponsibleParty>' +
//             '</Payor>' +
//             '</ShippingChargesPayment>' +
//             '<LabelSpecification>' +

//             '<LabelFormatType>COMMON2D</LabelFormatType>' +
//             '<ImageType>ZPLII</ImageType>' +
//             '<LabelStockType>STOCK_4X6</LabelStockType>' +
//             '</LabelSpecification>' +
//             '<RateRequestTypes>LIST</RateRequestTypes>' +
//             '<PackageCount>' + FORMAT(recPackingHeader."No. of Boxes") + '</PackageCount>' +
//             '<RequestedPackageLineItems>' +
//             '<SequenceNumber>1</SequenceNumber>' +
//             txtInsurance +
//              '<Weight>' +
//              '<Units>LB</Units>' +
//              '<Value>' + FORMAT(recPackingHeader."Gross Weight") + '</Value>' +
//              '</Weight>' +
//              '<Dimensions>' +
//              '<Length>' + FORMAT(recBoxMaster.Length) + '</Length>' +
//              '<Width>' + FORMAT(recBoxMaster.Width) + '</Width>' +
//              '<Height>' + FORMAT(recBoxMaster.Height) + '</Height>' +
//              '<Units>IN</Units>' +
//              '</Dimensions>' +
//              '<PhysicalPackaging>BOX</PhysicalPackaging>' +
//              '<ItemDescription>' + recWhseShipLine.Description + '</ItemDescription>' +
//              '<CustomerReferences>' +
//              '<CustomerReferenceType>CUSTOMER_REFERENCE</CustomerReferenceType>' +
//              '<Value>' + recWhsShipHeader."External Document No." + '</Value>' +
//              '</CustomerReferences>' +
//             SpecialServiceTxt[1] + SpecialServiceTxt[2] + SpecialServiceTxt[3] + SpecialServiceTxt[4] + SpecialServiceTxt[5] +
//             SpecialServiceTxt[6] + SpecialServiceTxt[7] + SpecialServiceTxt[8] + SpecialServiceTxt[9] + SpecialServiceTxt[10] +
//             '</RequestedPackageLineItems>' +
//             '</RequestedShipment>' +
//             '</ProcessShipmentRequest>' +
//             '</soapenv:Body>' +
//             '</soapenv:Envelope>');


//             IF ISCLEAR(locautXmlDoc1) THEN
//                 Result1 := CREATE(locautXmlDoc1, TRUE, TRUE);

//             //MESSAGE('%1',Xmlhttp.responseText());
//             IF Xmlhttp.status <> 200 THEN BEGIN
//                 Position := STRPOS(Xmlhttp.responseText(), '<Message>');
//                 Position := Position + 9;
//                 Position1 := STRPOS(Xmlhttp.responseText(), '</Message>');
//                 //txtMessage:=COPYSTR(Xmlhttp.responseText(),Position,Position1);
//                 //MESSAGE('%1',Xmlhttp.responseText());
//             END ELSE BEGIN
//                 //MESSAGE('%1',Xmlhttp.responseText());
//                 locautXmlDoc1.load(Xmlhttp.responseXML);
//                 Position := STRPOS(Xmlhttp.responseText(), '<Image>');
//                 Position := Position + 7;
//                 Position1 := STRPOS(Xmlhttp.responseText(), '</Image>');
//                 CLEAR(Picture1);
//                 Picture1.ADDTEXT(Xmlhttp.responseText());
//                 Picture1.GETSUBTEXT(Picture1, Position, Position1 - Position);
//                 Bytes := Convert.FromBase64String(Picture1);
//                 MemoryStream := MemoryStream.MemoryStream(Bytes);
//                 recWhsShipHeader.Picture.CREATEOUTSTREAM(OStream);
//                 MemoryStream.WriteTo(OStream);
//                 WhseSetup.GET();
//                 IF txtPaymentType = 'SENDER' THEN BEGIN
//                     IF STRPOS(Xmlhttp.responseText(), '<RateType>PAYOR_LIST_PACKAGE</RateType>') > 0 THEN BEGIN
//                         Pos := STRPOS(Xmlhttp.responseText(), '<RateType>PAYOR_LIST_PACKAGE</RateType>');
//                         Pos1 := Pos + 1000;
//                         txtAmountString := COPYSTR(Xmlhttp.responseText(), Pos, Pos1 - Pos);
//                         Position := STRPOS(txtAmountString, '<TotalNetFedExCharge>');
//                         Position := Position + 53;
//                         Position1 := STRPOS(txtAmountString, '</Amount></TotalNetFedExCharge>');
//                         txtAmount := COPYSTR(txtAmountString, Position, Position1 - Position);

//                         txtAmount := COPYSTR(txtAmountString, Position, Position1 - Position);
//                         EVALUATE(decAmount, txtAmount);
//                     END ELSE BEGIN
//                         Position := STRPOS(Xmlhttp.responseText(), '<TotalNetFedExCharge>');
//                         Position := Position + 53;
//                         Position1 := STRPOS(Xmlhttp.responseText(), '</Amount></TotalNetFedExCharge>');
//                         txtAmount := COPYSTR(Xmlhttp.responseText(), Position, Position1 - Position);
//                         EVALUATE(decAmount, txtAmount);
//                     END;
//                 END;
//                 Position := STRPOS(Xmlhttp.responseText(), '<TrackingNumber>');
//                 Position := Position + 16;
//                 Position1 := STRPOS(Xmlhttp.responseText(), '</TrackingNumber>');
//                 txtAmount := COPYSTR(Xmlhttp.responseText(), Position, Position1 - Position);
//                 recWhsShipHeader."Tracking No." := txtAmount;
//                 recWhsShipHeader.MODIFY(FALSE);

//                 SalesRelease.Reopen(recSalesHeader);
//                 recSalesHeader.SetHideValidationDialog(TRUE);
//                 //recSalesHeader.VALIDATE("Charges Pay By",recPackingHeader."Charges Pay By");
//                 recSalesHeader.VALIDATE("Tracking No.", recWhsShipHeader."Tracking No.");
//                 recSalesHeader.VALIDATE("Tracking Status", recWhsShipHeader."Tracking Status");
//                 //recSalesHeader.VALIDATE("Box Code",recPackingHeader."Box Code");
//                 recSalesHeader.VALIDATE("No. of Boxes", recPackingHeader."No. of Boxes");
//                 IF txtPaymentType = 'SENDER' THEN BEGIN
//                     recSalesLine.RESET;
//                     recSalesLine.SETRANGE("Document Type", recSalesLine."Document Type"::Order);
//                     recSalesLine.SETRANGE("Document No.", recSalesHeader."No.");
//                     IF recSalesLine.FIND('+') THEN BEGIN
//                         intLineNo := recSalesLine."Line No.";
//                         recSalesLine.INIT;
//                         recSalesLine.VALIDATE("Document Type", recSalesHeader."Document Type");
//                         recSalesLine.VALIDATE("Document No.", recSalesHeader."No.");
//                         recSalesLine.VALIDATE(Type, recSalesLine.Type::Resource);
//                         recSalesLine.VALIDATE("Line No.", intLineNo + 10000);
//                         recSalesLine.VALIDATE("No.", 'FREIGHT');
//                         recSalesLine.VALIDATE(Description, 'Against Warehouse shipment No. ' + recWhsShipHeader."No.");
//                         recSalesLine.VALIDATE(Quantity, 1);
//                         recSalesLine.VALIDATE("Unit Price", decAmount + recWhsShipHeader."Handling Charges" + recWhsShipHeader."Insurance Charges");
//                         recSalesLine.INSERT;
//                     END;
//                 END;
//                 recSalesHeader.MODIFY;
//                 SalesRelease.RUN(recSalesHeader);

//                 recPackingHeader.RESET;
//                 recPackingHeader.SETRANGE("Source Document Type", recPackingHeader."Source Document Type"::"Warehouse Shipment");
//                 recPackingHeader.SETRANGE("Source Document No.", recWhsShipHeader."No.");
//                 IF recPackingHeader.FINDFIRST THEN BEGIN
//                     recPackingHeader."Freight Amount" := decAmount;
//                     recPackingHeader."Tracking No." := txtAmount;
//                     recPackingHeader."Sales Order No." := recSalesHeader."No.";
//                     recPackingHeader."Service Name" := 'FEDEX';
//                     recPackingHeader."Charges Pay By" := txtPaymentType;
//                     recPackingHeader."Handling Charges" := recWhsShipHeader."Handling Charges";
//                     recPackingHeader."Insurance Charges" := recWhsShipHeader."Insurance Charges";
//                     recPackingHeader."Cash On Delivery" := recWhsShipHeader."Cash On Delivery";
//                     recPackingHeader."Signature Required" := recWhsShipHeader."Signature Required";
//                     recPackingHeader."Shipping Agent Service Code" := recWhsShipHeader."Shipping Agent Service Code";
//                     recPackingHeader."Shipping Account No" := ShiptoAccount;
//                     recPackingHeader."COD Amount" := recWhsShipHeader."COD Amount";
//                     recPackingHeader.MODIFY;

//                     //i :=1;
//                     //WHILE (i <= TotPkg) DO BEGIN
//                     recPackingLine.RESET;
//                     recPackingLine.SETRANGE("Source Document Type", recPackingLine."Source Document Type"::"Warehouse Shipment");
//                     recPackingLine.SETRANGE("Source Document No.", recWhsShipHeader."No.");
//                     recPackingLine.SETRANGE("Packing No.", recPackingHeader."Packing No.");
//                     //recPackingLine.SETRANGE("Line No.",PkgLineNo[i]);
//                     IF recPackingLine.FINDFIRST THEN BEGIN
//                         recPackingLine."Sales Order No." := recSalesHeader."No.";
//                         recPackingLine."Shipping Agent Service Code" := recWhsShipHeader."Shipping Agent Service Code";
//                         recPackingLine."Tracking No." := txtAmount;
//                         Bytes := Convert.FromBase64String(Picture1);
//                         MemoryStream := MemoryStream.MemoryStream(Bytes);
//                         recPackingLine.Image.CREATEOUTSTREAM(OStream);
//                         MemoryStream.WriteTo(OStream);
//                         recPackingLine.MODIFY;
//                     END;
//                     //i := i+1;
//                 END;

//             END;
//         END;
//     end;


//     procedure ReplaceString(String: Text[250]; FindWhat: Text[250]; ReplaceWith: Text[250]): Text[250]
//     begin
//         IF STRPOS(String, FindWhat) > 0 THEN BEGIN
//             IF FindWhat = '&' THEN BEGIN
//                 // strPosition:=STRPOS(String,FindWhat);
//                 String := DELSTR(String, STRPOS(String, FindWhat)) + ReplaceWith + COPYSTR(String, STRPOS(String, FindWhat) + STRLEN(FindWhat))
//             END ELSE BEGIN

//                 WHILE STRPOS(String, FindWhat) > 0 DO
//                     String := DELSTR(String, STRPOS(String, FindWhat)) + ReplaceWith + COPYSTR(String, STRPOS(String, FindWhat) + STRLEN(FindWhat));
//             END;
//         END;
//         EXIT(String);
//     end;


//     procedure AttributetoString(txtString: Text[250]): Text[250]
//     var
//         text001: Label '''';
//     begin
//         txtString := ReplaceString(txtString, '&', '&amp;');
//         txtString := ReplaceString(txtString, '<', '&lt;');
//         txtString := ReplaceString(txtString, '>', '&gt;');
//         txtString := ReplaceString(txtString, '"', '&quot;');
//         txtString := ReplaceString(txtString, 'text001', '&apos;');
//         EXIT(txtString);
//     end;
// }

