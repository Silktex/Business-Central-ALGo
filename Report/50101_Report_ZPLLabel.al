// report 50101 "ZPL Label"
// {
//     DefaultLayout = RDLC;
//     RDLCLayout = './Report/50101_Report_ZPLLabel.rdlc';

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
//         ZebraTCPConnection: DotNet TcpConnection;
//         ZebraConnection: DotNet Connection;
//         Bytes: Byte;

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
//         txtSend := ('^XA' +
//                    '^MMT' +
//                    '^PW477' +
//                    '^LL0203' +
//                    '^LS0' +
//                    '^FO5,10^BX,10,200' +
//                    '^FD' + LotNo + '^FS' +
//                    '^BCN,50,Y,N,N' +
//                    '^FT180,0^A0N,34,33^FH\^FD' + LotNo + '^FS' +
//                    '^FT10,180^A0N,34,31^FH\^FD' + 'ABC' + '^FS' +
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
//         MESSAGE(Base64String);

//         ZebraConnection := ZebraTCPConnection.TcpConnection('192.168.1.178', 9100);
//         ZebraConnection.Open();
//         Bytes := Convert.FromBase64String(Base64String);
//         ZebraConnection.Write(Bytes);
//     end;
// }

