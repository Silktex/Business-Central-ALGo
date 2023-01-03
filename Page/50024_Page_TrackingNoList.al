// page 50024 "Tracking No. List"
// {
//     PageType = Card;
//     SourceTable = "Packing Header";

//     layout
//     {
//         area(content)
//         {
//             group("TrackingNo.")
//             {
//                 Caption = 'Tracking No.';
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
//                 field("Sales Order No."; Rec."Sales Order No.")
//                 {
//                     ApplicationArea = All;
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
//                 field("COD Amount"; Rec."COD Amount")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Gross Weight"; Rec."Gross Weight")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Status; Rec.Status)
//                 {
//                     ApplicationArea = All;
//                 }
//             }
//             part(PackingSlipLine; "Packing List Subform")
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

//                 trigger OnAction()
//                 begin
//                     cuPack.ReleasePacking(Rec);
//                 end;
//             }
//             action(Reopen)
//             {
//                 ApplicationArea = All;

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

