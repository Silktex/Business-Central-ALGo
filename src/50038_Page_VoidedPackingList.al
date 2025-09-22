//Discard Function
// page 50038 "Voided Packing List"
// {
//     Editable = false;
//     PageType = Card;
//     SourceTable = "Packing Header";
//     SourceTableView = WHERE("Void Entry" = FILTER(true));

//     layout
//     {
//         area(content)
//         {
//             group(General)
//             {
//                 field("Packing No."; Rec."Packing No.")
//                 {
//                     ApplicationArea = All;

//                     trigger OnValidate()
//                     begin
//                         if Rec.AssistEdit(xRec) then
//                             CurrPage.Update;
//                     end;
//                 }
//                 field("Source Document Type"; Rec."Source Document Type")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Source Document No."; Rec."Source Document No.")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Location Code"; Rec."Location Code")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Shipment Method Code"; Rec."Shipment Method Code")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Shipping Agent Code"; Rec."Shipping Agent Code")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Source No."; Rec."Source No.")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Source Name"; Rec."Source Name")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Status; Rec.Status)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Packing Date"; Rec."Packing Date")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Shipment Date"; Rec."Shipment Date")
//                 {
//                     ApplicationArea = All;
//                 }
//             }
//             group("TrackingNo.")
//             {
//                 Caption = 'Tracking No.';
//                 field("Sales Order No."; Rec."Sales Order No.")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Warehouse Shipment No."; Rec."Source Document No.")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Warehouse Shipment No.';
//                 }
//                 field("Tracking No."; Rec."Tracking No.")
//                 {
//                     ApplicationArea = All;

//                     trigger OnValidate()
//                     begin
//                         if Rec.AssistEdit(xRec) then
//                             CurrPage.Update;
//                     end;
//                 }
//                 field("Creation Date"; Rec."Creation Date")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Service Name"; Rec."Service Name")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Transaction No."; Rec."Transaction No.")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Shipping Account No"; Rec."Shipping Account No")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("No. of Boxes"; Rec."No. of Boxes")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Charges Pay By"; Rec."Charges Pay By")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Handling Charges"; Rec."Handling Charges")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Insurance Charges"; Rec."Insurance Charges")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Cash On Delivery"; Rec."Cash On Delivery")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Signature Required"; Rec."Signature Required")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Gross Weight"; Rec."Gross Weight")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("COD Amount"; Rec."COD Amount")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Freight Amount"; Rec."Freight Amount")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(RSCreateShipmentURL; Rec.RSCreateShipmentURL)
//                 {
//                     ApplicationArea = All;

//                     trigger OnAssistEdit()
//                     var
//                         outFile: File;
//                         Istream1: InStream;
//                         Line: Text;
//                         Text1: array[10] of Text[1024];
//                         OStream: OutStream;
//                     begin
//                         Clear(Istream1);
//                         Rec.CalcFields(RSCreateShipmentURL);
//                         Rec.RSCreateShipmentURL.CreateInStream(Istream1);
//                         outFile.Create('D:\Navneet\' + 'RSCreateShipmentURL' + '.txt');
//                         outFile.CreateOutStream(OStream);
//                         while not Istream1.EOS do begin
//                             Istream1.ReadText(Line);
//                             OStream.WriteText(Line);
//                         end;

//                         Clear(Istream1);
//                         outFile.Close();
//                         CurrPage.Update;

//                         HyperLink('D:\Navneet\' + 'RSCreateShipmentURL' + '.txt');
//                     end;
//                 }
//                 field(RSShipmentResponse; Rec.RSShipmentResponse)
//                 {
//                     ApplicationArea = All;

//                     trigger OnAssistEdit()
//                     var
//                         outFile: File;
//                         Istream1: InStream;
//                         Line: Text;
//                         OStream: OutStream;
//                     begin

//                         Clear(Istream1);
//                         Rec.CalcFields(RSShipmentResponse);
//                         Rec.RSShipmentResponse.CreateInStream(Istream1);
//                         outFile.Create('D:\Navneet\' + 'RSShipmentResponse' + '.txt');
//                         outFile.CreateOutStream(OStream);
//                         while not Istream1.EOS do begin
//                             Istream1.ReadText(Line);
//                             OStream.WriteText(Line);
//                         end;

//                         Clear(Istream1);
//                         outFile.Close();
//                         CurrPage.Update;

//                         HyperLink('D:\Navneet\' + 'RSShipmentResponse' + '.txt');
//                     end;
//                 }
//                 field(RSGetRatesURL; Rec.RSGetRatesURL)
//                 {
//                     ApplicationArea = All;

//                     trigger OnAssistEdit()
//                     var
//                         outFile: File;
//                         Istream1: InStream;
//                         Line: Text;
//                         OStream: OutStream;
//                     begin
//                         Clear(Istream1);
//                         Rec.CalcFields(RSGetRatesURL);
//                         Rec.RSGetRatesURL.CreateInStream(Istream1);
//                         outFile.Create('D:\Navneet\' + 'RSGetRatesURL' + '.txt');
//                         outFile.CreateOutStream(OStream);
//                         while not Istream1.EOS do begin
//                             Istream1.ReadText(Line);
//                             OStream.WriteText(Line);
//                         end;

//                         Clear(Istream1);
//                         outFile.Close();
//                         CurrPage.Update;

//                         HyperLink('D:\Navneet\' + 'RSGetRatesURL' + '.txt');
//                     end;
//                 }
//                 field(RSRateResponse; Rec.RSRateResponse)
//                 {
//                     ApplicationArea = All;

//                     trigger OnAssistEdit()
//                     var
//                         outFile: File;
//                         Istream1: InStream;
//                         Line: Text;
//                         OStream: OutStream;
//                     begin
//                         Clear(Istream1);
//                         Rec.CalcFields(RSRateResponse);
//                         Rec.RSRateResponse.CreateInStream(Istream1);
//                         outFile.Create('D:\Navneet\' + 'RSRateResponse' + '.txt');
//                         outFile.CreateOutStream(OStream);
//                         while not Istream1.EOS do begin
//                             Istream1.ReadText(Line);
//                             OStream.WriteText(Line);
//                         end;

//                         Clear(Istream1);
//                         outFile.Close();
//                         CurrPage.Update;

//                         HyperLink('D:\Navneet\' + 'RSRateResponse' + '.txt');
//                     end;
//                 }
//             }
//             part(PackingSlipLine; "Voided Packing List Subform")
//             {
//                 ApplicationArea = All;
//                 SubPageLink = "Packing No." = FIELD("Packing No.");
//             }
//         }
//     }

//     actions
//     {
//         area(processing)
//         {
//             action(Release)
//             {
//                 ApplicationArea = All;
//                 Visible = false;

//                 trigger OnAction()
//                 begin
//                     cuPack.ReleasePacking(Rec);
//                 end;
//             }
//             action(Reopen)
//             {
//                 ApplicationArea = All;
//                 Visible = false;

//                 trigger OnAction()
//                 begin
//                     cuPack.ReopenPacking(Rec);
//                 end;
//             }
//         }
//     }

//     var
//         cuPack: Codeunit Packing;
// }

