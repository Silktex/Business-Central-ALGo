// table 50012 "Spec Sheet Fiber Contents"
// {
//     DrillDownPageID = 50013;
//     LookupPageID = 50013;

//     fields
//     {
//         field(1; "Code"; Code[20])
//         {
//             TableRelation = "Spec sheet"."Product Group Code" WHERE("Product Group Code" = FIELD(Code));
//         }
//         field(2; "Fiber Contents Code"; Code[50])
//         {
//             TableRelation = "Item Spec Contents".Code;
//         }
//         field(3; "Fiber Contents %"; Decimal)
//         {

//             trigger OnValidate()
//             begin
//                 /*
//                 decFC :=0;
//                 recFC.RESET;
//                 recFC.SETRANGE(recFC.Code,Code);
//                 IF recFC.FIND('-') THEN BEGIN
//                   REPEAT
//                    decFC += recFC."Fiber Contents %";
//                   UNTIL recFC.NEXT=0;

//                 //IF decFC > 100 THEN
//                    MESSAGE('Fiber Contents % %1 Must be 100',decFC);

//                 END;
//                    */

//             end;
//         }
//         field(4; "If Staple % Carded"; Decimal)
//         {
//         }
//         field(5; "If Staple % Combed"; Decimal)
//         {
//         }
//         field(6; "If Filament %Flat"; Decimal)
//         {
//         }
//         field(7; "If Filament % Textured"; Decimal)
//         {
//         }
//         field(8; "If Filament % Non-Textured"; Decimal)
//         {
//         }
//     }

//     keys
//     {
//         key(Key1; "Code", "Fiber Contents Code")
//         {
//             Clustered = true;
//         }
//     }

//     fieldgroups
//     {
//     }

//     var
//         recFC: Record "Spec Sheet Fiber Contents";
//         decFC: Decimal;
// }

