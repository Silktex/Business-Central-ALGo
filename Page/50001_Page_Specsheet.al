// page 50001 "Spec sheet"
// {
//     CardPageID = "Spec sheet Card";
//     Editable = false;
//     PageType = List;
//     SourceTable = "Spec sheet";

//     layout
//     {
//         area(content)
//         {
//             repeater(Group)
//             {
//                 field("Mill Code"; Rec."Mill Code")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Product Group Code"; Rec."Product Group Code")
//                 {
//                     ApplicationArea = All;
//                 }
//             }
//         }
//     }

//     actions
//     {
//     }

//     trigger OnAfterGetRecord()
//     begin
//         if Rec."Fabric Embroidery" then
//             EnableWidth := true
//         else
//             EnableWidth := false;
//     end;

//     trigger OnOpenPage()
//     begin
//         if Rec."Fabric Embroidery" then
//             EnableWidth := true
//         else
//             EnableWidth := false;
//     end;

//     var
//         EnableWidth: Boolean;
//         EnableTestVal: Boolean;
// }

