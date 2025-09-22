// codeunit 50012 "Address Validation Testing GA"
// {

//     trigger OnRun()
//     begin
//         USAddressValidationJson();
//     end;

//     var
//         Result: Boolean;
//         Xmlhttp: Automation;
//         locautXmlDoc: Automation;
//         textRequest: Text;
//         DotNetXmlHttp: DotNet XMLHTTPRequestClass;
//         DotNetXmlDoc: DotNet DOMDocumentClass;
//         XMLNodeList: DotNet XmlNodeList;
//         DotNetXmlNodeList: DotNet IXMLDOMNodeList;
//         DotNetXmlNode: DotNet IXMLDOMNode;
//         XMLDoc: DotNet XmlDocument;
//         ReturnNode: DotNet XmlNode;
//         DOMNode: DotNet XmlNode;
//         NodeType: Text;
//         NodeName: Text;
//         NodeValue: Text;
//         ParentKey: Label '4eMl4PrCTfRqa3Hm';
//         ParentPassword: Label 'r97nNKS6b2GB0oL33qddOthaL';
//         UserKey: Label '4eMl4PrCTfRqa3Hm';
//         UserPassword: Label 'r97nNKS6b2GB0oL33qddOthaL';
//         AccountNumber: Label '359071817';
//         MeterNumber: Label '251397204';


//     procedure USAddressValidationJson()
//     var
//         tempText: Text;
//         tempText1: Text;
//         txtBlank: Text;
//         City: Text[30];
//         StateOrProvinceCode: Text[30];
//         PostalCode: Text[20];
//         CountryCode: Text[10];
//         ContactId: Code[20];
//         PersonName: Text[50];
//         CompanyName: Text[50];
//         PhoneNumber: Text[30];
//         EMailAddress: Text[80];
//         StreetLines: Text[50];
//         UrbanizationCode: Text;
//         I: Integer;
//         NodeCount: Integer;
//     begin
//         ContactId := 'C0000002';
//         PersonName := 'CONNIE RITSICK';
//         CompanyName := 'RITSICK DESIGN ASSOCIATES';
//         PhoneNumber := '(703) 286-5555';
//         EMailAddress := 'critsick@ritsickdesign.com';
//         StreetLines := '5300 WESTVIEW DR SUITE 308';
//         City := 'FREDERICK';
//         StateOrProvinceCode := 'MD';
//         PostalCode := '21703';
//         UrbanizationCode := '';
//         CountryCode := 'US';


//         IF ISNULL(DotNetXmlHttp) THEN
//             DotNetXmlHttp := DotNetXmlHttp.XMLHTTPRequestClass();

//         IF ISNULL(DotNetXmlDoc) THEN
//             DotNetXmlDoc := DotNetXmlDoc.DOMDocumentClass;

//         DotNetXmlHttp.open('POST', 'https://ws.fedex.com/web-services', 0, 0, 0);
//         textRequest := '<?xml version="1.0" encoding="utf-8"?>' +
//         '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v4="http://fedex.com/ws/addressvalidation/v4">' +
//            '<soapenv:Header/>' +
//            '<soapenv:Body>' +
//               '<v4:AddressValidationRequest>' +
//                  '<v4:WebAuthenticationDetail>' +
//                     '<v4:ParentCredential>' +
//                        '<v4:Key>' + ParentKey + '</v4:Key>' +
//                        '<v4:Password>' + ParentPassword + '</v4:Password>' +
//                     '</v4:ParentCredential>' +
//                     '<v4:UserCredential>' +
//                        '<v4:Key>' + UserKey + '</v4:Key>' +
//                        '<v4:Password>' + UserPassword + '</v4:Password>' +
//                     '</v4:UserCredential>' +
//                  '</v4:WebAuthenticationDetail>' +
//                  '<v4:ClientDetail>' +
//                     '<v4:AccountNumber>' + AccountNumber + '</v4:AccountNumber>' +
//                     '<v4:MeterNumber>' + MeterNumber + '</v4:MeterNumber>' +
//                     '<v4:Localization>' +
//                        '<v4:LanguageCode>EN</v4:LanguageCode>' +
//                        '<v4:LocaleCode>US</v4:LocaleCode>' +
//                     '</v4:Localization>' +
//                  '</v4:ClientDetail>' +
//                  '<v4:TransactionDetail>' +
//                     '<v4:CustomerTransactionId>AddressValidationRequest_v4</v4:CustomerTransactionId>' +
//                     '<v4:Localization>' +
//                        '<v4:LanguageCode>EN</v4:LanguageCode>' +
//                        '<v4:LocaleCode>US</v4:LocaleCode>' +
//                     '</v4:Localization>' +
//                  '</v4:TransactionDetail>' +
//                  '<v4:Version>' +
//                     '<v4:ServiceId>aval</v4:ServiceId>' +
//                     '<v4:Major>4</v4:Major>' +
//                     '<v4:Intermediate>0</v4:Intermediate>' +
//                     '<v4:Minor>0</v4:Minor>' +
//                  '</v4:Version>' +
//                  '<v4:InEffectAsOfTimestamp>2015-03-09T01:21:14+05:30</v4:InEffectAsOfTimestamp>' +
//                  '<v4:AddressesToValidate>' +
//                     '<v4:ClientReferenceId>ac vinclis et</v4:ClientReferenceId>' +
//                     '<v4:Contact>' +
//                        '<v4:ContactId>' + ContactId + '</v4:ContactId>' +
//                        '<v4:PersonName>' + PersonName + '</v4:PersonName>' +
//                        '<v4:CompanyName>' + CompanyName + '</v4:CompanyName>' +
//                        '<v4:PhoneNumber>' + PhoneNumber + '</v4:PhoneNumber>' +
//                        '<v4:EMailAddress>' + EMailAddress + '</v4:EMailAddress>' +
//                     '</v4:Contact>' +
//                     '<v4:Address>' +
//                        '<v4:StreetLines>' + StreetLines + '</v4:StreetLines>' +
//                        '<v4:City>' + City + '</v4:City>' +
//                        '<v4:StateOrProvinceCode>' + StateOrProvinceCode + '</v4:StateOrProvinceCode>' +
//                        '<v4:PostalCode>' + PostalCode + '</v4:PostalCode>' +
//                        '<v4:UrbanizationCode>' + UrbanizationCode + '</v4:UrbanizationCode>' +
//                        '<v4:CountryCode>' + CountryCode + '</v4:CountryCode>' +
//                        '<v4:Residential>0</v4:Residential>' +
//                     '</v4:Address>' +
//                  '</v4:AddressesToValidate>' +
//               '</v4:AddressValidationRequest>' +
//            '</soapenv:Body>' +
//         '</soapenv:Envelope>';//);
//         DotNetXmlHttp.send(textRequest);

//         MESSAGE('%1', textRequest);

//         //IF DotNetXmlHttp.status = 200 THEN
//         MESSAGE('%1', DotNetXmlHttp.responseText());
//     end;

//     trigger XMLDoc::NodeInserting(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
//     begin
//     end;

//     trigger XMLDoc::NodeInserted(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
//     begin
//     end;

//     trigger XMLDoc::NodeRemoving(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
//     begin
//     end;

//     trigger XMLDoc::NodeRemoved(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
//     begin
//     end;

//     trigger XMLDoc::NodeChanging(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
//     begin
//     end;

//     trigger XMLDoc::NodeChanged(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
//     begin
//     end;

//     trigger DotNetXmlDoc::XMLDOMDocumentEvents_Event_ondataavailable()
//     begin
//     end;

//     trigger DotNetXmlDoc::XMLDOMDocumentEvents_Event_onreadystatechange()
//     begin
//     end;
// }

