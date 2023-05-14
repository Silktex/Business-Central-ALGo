// report 50049 UpdateItemReferenceData
// {
//     ProcessingOnly = true;
//     Caption = 'Update ItemReference Data';
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = all;

//     dataset
//     {
//         dataitem("Item Reference"; "Item Reference")
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
//                 ItemRef."Item No." := "Item Reference"."Item No.";
//                 ItemRef."Variant Code" := "Item Reference"."Variant Code";
//                 Itemref."Unit of Measure" := "Item Reference"."Unit of Measure";
//                 ItemRef."Reference Type" := "Item Reference"."Item Reference Type";
//                 ItemRef."Reference Type No." := "Item Reference"."Item Reference Type No.";
//                 ItemRef."Reference No." := "Item Reference"."Item Reference No.";
//                 ItemRef.Description := "Item Reference".Description;
//                 ItemRef."Description 2" := "Item Reference"."Description 2";
//                 ItemRef."Palcement Start Date" := "Item Reference"."Palcement Start Date";
//                 itemref."Placement End Date" := "Item Reference"."Placement End Date";
//                 //ItemRef."Discontinue Bar Code" := "Item Reference"."Discontinue Bar Code";
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

