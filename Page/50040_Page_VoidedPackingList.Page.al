//Discard Function
// page 50040 "Voided Packing List-"
// {
//     CardPageID = "Voided Packing List";
//     Editable = false;
//     PageType = List;
//     SourceTable = "Packing Header";
//     SourceTableView = WHERE("Void Entry" = FILTER(true));

//     layout
//     {
//         area(content)
//         {
//             repeater(Control1000000014)
//             {
//                 ShowCaption = false;
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
//             }
//         }
//     }

//     actions
//     {
//     }

//     var
//         cuPack: Codeunit Packing;
// }

