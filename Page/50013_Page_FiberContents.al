// page 50013 "Fiber Contents"
// {
//     PageType = ListPart;
//     SourceTable = "Spec Sheet Fiber Contents";

//     layout
//     {
//         area(content)
//         {
//             repeater(Group)
//             {
//                 field("Code"; Rec.Code)
//                 {
//                     ApplicationArea = All;
//                     Editable = true;
//                 }
//                 field("Fiber Contents Code"; Rec."Fiber Contents Code")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Fiber Contents %"; Rec."Fiber Contents %")
//                 {
//                     ApplicationArea = All;

//                     trigger OnValidate()
//                     begin
//                         decFC := 0;
//                         recFC.Reset;
//                         recFC.SetRange(recFC.Code, Rec.Code);
//                         recFC.SetFilter("Fiber Contents Code", '<>%1', Rec."Fiber Contents Code");
//                         if recFC.Find('-') then begin
//                             repeat
//                                 decFC += recFC."Fiber Contents %";
//                             until recFC.Next = 0;
//                         end;
//                         decFC := decFC + Rec."Fiber Contents %";
//                         if decFC > 100 then
//                             Error('Fiber Contents % %1 not be greater then 100', decFC);
//                     end;
//                 }
//                 field("If Staple % Carded"; Rec."If Staple % Carded")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("If Staple % Combed"; Rec."If Staple % Combed")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("If Filament %Flat"; Rec."If Filament %Flat")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("If Filament % Textured"; Rec."If Filament % Textured")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("If Filament % Non-Textured"; Rec."If Filament % Non-Textured")
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
//         decFC: Decimal;
//         recFC: Record "Spec Sheet Fiber Contents";
// }

