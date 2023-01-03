// report 50049 UpdateItemReferenceData
// {
//     ProcessingOnly = true;
//     Caption = 'Update ItemReference Data';
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = all;

//     dataset
//     {
//         dataitem("Item Cross Reference"; "Item Cross Reference")
//         {
//             //DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));

//             trigger OnPreDataItem()
//             begin
//                 ItemRef.DeleteAll();
//             end;


//             trigger OnAfterGetRecord()
//             begin
//                 ItemRef.Reset();
//                 //  ItemRef.DeleteAll();
//                 ItemRef.Init();
//                 ItemRef."Item No." := "Item Cross Reference"."Item No.";
//                 ItemRef."Variant Code" := "Item Cross Reference"."Variant Code";
//                 Itemref."Unit of Measure" := "Item Cross Reference"."Unit of Measure";
//                 ItemRef."Reference Type" := "Item Cross Reference"."Cross-Reference Type";
//                 ItemRef."Reference Type No." := "Item Cross Reference"."Cross-Reference Type No.";
//                 ItemRef."Reference No." := "Item Cross Reference"."Cross-Reference No.";
//                 ItemRef.Description := "Item Cross Reference".Description;
//                 ItemRef."Description 2" := "Item Cross Reference"."Description 2";
//                 ItemRef."Palcement Start Date" := "Item Cross Reference"."Palcement Start Date";
//                 itemref."Placement End Date" := "Item Cross Reference"."Placement End Date";
//                 //ItemRef."Discontinue Bar Code" := "Item Cross Reference"."Discontinue Bar Code";
//                 ItemRef.Insert();
//             end;
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//         }

//         actions
//         {
//         }
//     }

//     labels
//     {
//     }

//     var
//         CustNo: Code[20];
//         CLE: Record "Cust. Ledger Entry";
//         ItemRef: Record "Item Reference";
// }

