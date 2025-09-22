// page 50146 "Price List Lines-Modify"
// {
//     AutoSplitKey = true;
//     Caption = 'Lines';
//     DelayedInsert = true;
//     LinksAllowed = false;
//     MultipleNewLines = true;
//     PageType = List;
//     SourceTable = "Price List Line";
//     UsageCategory = Administration;
//     ApplicationArea = all;
//     Editable = true;

//     layout
//     {
//         area(content)
//         {
//             repeater(Control1)
//             {
//                 field("Line No."; rec."Line No.")
//                 {
//                     ApplicationArea = all;
//                 }

//                 field(SourceType; rec."Source Type")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Assign-to Type';

//                 }
//                 field("Source No."; rec."Source No.")
//                 {
//                     ApplicationArea = all;
//                 }

//                 field(ParentSourceNo; Rec."Parent Source No.")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Assign-to Job No.';

//                 }
//                 field(AssignToParentNo; Rec."Assign-to Parent No.")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Assign-to Job No.';

//                 }
//                 field(SourceNo; Rec."Source No.")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field(AssignToNo; Rec."Assign-to No.")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field(CurrencyCode; Rec."Currency Code")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field(StartingDate; Rec."Starting Date")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field(EndingDate; Rec."Ending Date")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field("Asset Type"; Rec."Asset Type")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field("Asset No."; Rec."Asset No.")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field("Product No."; Rec."Product No.")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field(Description; rec.Description)
//                 {
//                     ApplicationArea = All;

//                 }


//                 field("Unit of Measure Code Lookup"; Rec."Unit of Measure Code Lookup")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Minimum Quantity"; Rec."Minimum Quantity")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Amount Type"; Rec."Amount Type")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field("Unit Price"; Rec."Unit Price")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field("Cost Factor"; Rec."Cost Factor")
//                 {
//                     ApplicationArea = All;

//                 }

//             }

//         }
//     }
// }