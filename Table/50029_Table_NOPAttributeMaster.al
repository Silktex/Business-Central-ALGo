// table 50029 "NOP Attribute Master"
// {
//     DrillDownPageID = 50075;
//     LookupPageID = 50075;

//     fields
//     {
//         field(1; Name; Text[30])
//         {
//         }
//         field(2; "Item Category Code"; Code[10])
//         {
//             Caption = 'Item Category Code';
//             TableRelation = "Item Category";
//         }
//         field(3; "Product Group Code"; Code[10])
//         {
//             Caption = 'Product Group Code';
//             TableRelation = "Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"));
//         }
//     }

//     keys
//     {
//         key(Key1; Name)
//         {
//             Clustered = true;
//         }
//     }

//     fieldgroups
//     {
//     }
// }

