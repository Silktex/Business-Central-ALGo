// report 50100 "Print PHP Label"
// {
//     DefaultLayout = RDLC;
//     RDLCLayout = './Report/50100_Report_PrintPHPLabel.rdlc';

//     dataset
//     {
//         dataitem("Integer"; "Integer")
//         {
//             DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

//             trigger OnAfterGetRecord()
//             begin
//                 PrintLable('I10123-086', 'LOT12345', 25.5);
//             end;

//             trigger OnPostDataItem()
//             begin
//                 //MESSAGE('Done') ;
//             end;
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//         }

//         actions
//         {
//         }
//     }

//     labels
//     {
//     }

//     var
//         recItem: Record Item;
//         RocketShipPrinterURL: Text;
//         txtSend: Text;
//         RocketShipPrintServerIP: Text[250];
//         recPrinterSelection: Record "Printer Selection";
//         RocketShipPrinterName: Text[250];


//     procedure PrintLable(ItemCode: Code[20]; LotNo: Code[20]; Qty: Decimal)
//     var
//         DataText: BigText;
//         DataStream: InStream;
//         TrackingNo: Text[30];
//         Xmlhttp: Automation;
//         Result: Boolean;
//         SpecialService: BigText;
//         intCount: Integer;
//         txtImageText: Text[1000];
//         MemoryStream: DotNet MemoryStream;
//         Bytes: DotNet Array;
//         Convert: DotNet Convert;
//         NavPrinter: Automation;
//         Base64String: Text;
//         TempBlob: Record TempBlob temporary;
//         OStream: OutStream;
//     begin
//         recItem.GET(ItemCode);
//         txtSend := ('^XA' +
//                    '^MMT' +
//                    '^PW477' +
//                    '^LL0203' +
//                    '^LS0' +
//                    '^FO5,10^BX,10,200' +
//                    '^FD' + LotNo + '^FS' +
//                    '^BCN,50,Y,N,N' +
//                    '^FT180,0^A0N,34,33^FH\^FD' + LotNo + '^FS' +
//                    '^FT10,180^A0N,34,31^FH\^FD' + recItem.Description + '^FS' +
//                    '^FT180,110^A0N,34,33^FH\^FDQty:^FS' +
//                    '^FT240,110^A0N,34,33^FH\^FD' + FORMAT(Qty) + ' Yards^FS' +
//                    '^XZ');
//         //MESSAGE(txtSend);

//         TempBlob.INIT;
//         TempBlob.Blob.CREATEOUTSTREAM(OStream);
//         OStream.WRITETEXT(txtSend);
//         CLEAR(DataText);
//         CLEAR(DataStream);
//         TempBlob.Blob.CREATEINSTREAM(DataStream);
//         MemoryStream := MemoryStream.MemoryStream();
//         COPYSTREAM(MemoryStream, DataStream);
//         Base64String := Convert.ToBase64String(MemoryStream.ToArray);
//         DataText.ADDTEXT(Base64String);
//         //MESSAGE(Base64String);

//         recPrinterSelection.RESET;
//         recPrinterSelection.SETRANGE("Report ID", 50100);
//         recPrinterSelection.SETRANGE("User ID", '');
//         IF recPrinterSelection.FINDFIRST THEN
//             //RocketShipPrinterURL:='192.168.1.228:59999'
//             //RocketShipPrintServerIP :='192.168.1.228:8080';
//             RocketShipPrinterURL := recPrinterSelection."RocketShipIt Printer URL";
//         RocketShipPrintServerIP := recPrinterSelection."Label Printer IP";
//         RocketShipPrinterName := recPrinterSelection."RocketShip Printer Name";

//         /*
//         CLEAR(Xmlhttp);
//         IF ISCLEAR(Xmlhttp) THEN
//            Result:=CREATE(Xmlhttp,TRUE,TRUE);
//         Xmlhttp.open('POST','http://'+RocketShipPrinterURL+'/PrintLabel_XML.php', FALSE);
//         Xmlhttp.setRequestHeader('Content-Type:', 'application/xml; encoding=UTF-8');
//         Xmlhttp.send('<printLabel>'+
//         '<cmdType>label</cmdType>'+
//         '<rsServerUrl>http://'+RocketShipPrintServerIP+'</rsServerUrl>'+
//         '<base64Label>'+FORMAT(DataText)+'</base64Label>'+
//         '</printLabel>');
//         */

//         CLEAR(Xmlhttp);
//         IF ISCLEAR(Xmlhttp) THEN
//             Result := CREATE(Xmlhttp, TRUE, TRUE);
//         Xmlhttp.open('POST', 'http://' + RocketShipPrinterURL + '/PrintLabel_XML.php', FALSE);
//         Xmlhttp.setRequestHeader('Content-Type:', 'application/xml; encoding=UTF-8');
//         Xmlhttp.send('<printLabel>' +
//         '<type>printer</type>' +
//         '<printerName>' + RocketShipPrinterName + '</printerName>' +
//         '<cmdType>label</cmdType>' +
//         '<rsServerUrl>http://' + RocketShipPrintServerIP + '</rsServerUrl>' +
//         '<base64Label>' + FORMAT(DataText) + '</base64Label>' +
//         '</printLabel>');


//         MESSAGE('Printed Successfully');

//     end;
// }

