// table 50024 "NOP Prod. Attribute Value"
// {
//     DrillDownPageID = 50047;
//     LookupPageID = 50047;

//     fields
//     {
//         field(1; "Entry No."; Integer)
//         {
//             AutoIncrement = true;
//             Editable = false;
//         }
//         field(2; "Prod. Attribute Entry No."; Integer)
//         {
//             Editable = false;
//             TableRelation = "NOP Product Attrribute";
//         }
//         field(3; "Prod. Attibute Name"; Text[30])
//         {
//             CalcFormula = Lookup("NOP Product Attrribute".Name WHERE("Entry No." = FIELD("Prod. Attribute Entry No.")));
//             Editable = false;
//             FieldClass = FlowField;
//         }
//         field(4; Name; Text[30])
//         {
//         }
//         field(5; ColorSquaresRgb; Text[7])
//         {
//         }
//     }

//     keys
//     {
//         key(Key1; "Entry No.", "Prod. Attribute Entry No.")
//         {
//             Clustered = true;
//         }
//     }

//     fieldgroups
//     {
//     }
// }

