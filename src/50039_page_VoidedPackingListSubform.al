//Discard Function
// page 50039 "Voided Packing List Subform"
// {
//     Editable = false;
//     PageType = ListPart;
//     SourceTable = "Packing Line";
//     SourceTableView = WHERE("Void Entry" = FILTER(true));

//     layout
//     {
//         area(content)
//         {
//             repeater(Group)
//             {
//                 field("Box Code"; Rec."Box Code")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Height; Rec.Height)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Width; Rec.Width)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Length; Rec.Length)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Weight; Rec.Weight)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Gross Weight"; Rec."Gross Weight")
//                 {
//                     ApplicationArea = All;
//                 }
//             }
//             repeater(TrackingNo)
//             {
//                 Caption = 'Tracking No.';
//                 field("Tracking No."; Rec."Tracking No.")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Image; Rec.Image)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Billed Weight"; Rec."Billed Weight")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Total Base Charge"; Rec."Total Base Charge")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(INSURED_VALUE; Rec.INSURED_VALUE)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(SIGNATURE_OPTION; Rec.SIGNATURE_OPTION)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Total Charges"; Rec."Total Charges")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Total Discounts"; Rec."Total Discounts")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Total Surcharge"; Rec."Total Surcharge")
//                 {
//                     ApplicationArea = All;
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(processing)
//         {
//             action(PackingItemList)
//             {
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 begin
//                     Rec.ShowItemList;
//                 end;
//             }
//         }
//     }

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         Rec.CalcFields("Shipping Agent Service Code");
//     end;
// }

