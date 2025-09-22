// table 50023 "NOP Product Attrribute"
// {
//     DrillDownPageID = 50045;
//     LookupPageID = 50045;

//     fields
//     {
//         field(1; "Entry No."; Integer)
//         {
//             AutoIncrement = true;
//             Editable = false;
//         }
//         field(2; Name; Text[30])
//         {
//             TableRelation = "NOP Attribute Master";
//         }
//         field(3; Description; Text[50])
//         {
//         }
//         field(4; "Product Code"; Code[20])
//         {
//             TableRelation = Item;
//         }
//         field(5; "NOP Insert"; Boolean)
//         {
//             DataClassification = ToBeClassified;
//             Description = 'NOP_18';
//         }
//     }

//     keys
//     {
//         key(Key1; "Entry No.", "Product Code")
//         {
//             Clustered = true;
//         }
//     }

//     fieldgroups
//     {
//     }

//     // trigger OnDelete()
//     // begin
//     //     //NOP Commerce BEGIN
//     //     recCompInfo.GET();
//     //     IF recCompInfo."NOP Sync URL Activate" THEN BEGIN
//     //         IF ISCLEAR(Xmlhttp) THEN
//     //             Result := CREATE(Xmlhttp, TRUE, TRUE);
//     //         txtURL := recCompInfo."NOP Sync URL" + 'api/SyncSingleProduct/' + Rec."Product Code";
//     //         //txtURL :='http://localhost:80/api/SyncSingleProduct/'+Rec."Product Code";
//     //         Xmlhttp.open('GET', txtURL, FALSE);
//     //         Xmlhttp.send('');
//     //         MESSAGE('%1', Xmlhttp.responseText);
//     //     END;
//     //     //NOP Commerce END
//     // end;

//     // trigger OnModify()
//     // begin
//     //     //NOP Commerce BEGIN
//     //     recCompInfo.GET();
//     //     IF recCompInfo."NOP Sync URL Activate" THEN BEGIN
//     //         IF ISCLEAR(Xmlhttp) THEN
//     //             Result := CREATE(Xmlhttp, TRUE, TRUE);
//     //         txtURL := recCompInfo."NOP Sync URL" + 'api/SyncSingleProduct/' + Rec."Product Code";
//     //         //txtURL :='http://localhost:80/api/SyncSingleProduct/'+Rec."Product Code";
//     //         Xmlhttp.open('GET', txtURL, FALSE);
//     //         Xmlhttp.send('');
//     //         MESSAGE('%1', Xmlhttp.responseText);
//     //     END;
//     //     //NOP Commerce END
//     // end;

//     var
//         // Xmlhttp: Automation;
//         Result: Boolean;
//         txtURL: Text;
//         recCompInfo: Record "Company Information";
// }

