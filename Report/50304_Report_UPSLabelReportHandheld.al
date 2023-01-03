// report 50304 "UPS Label Report Handheld"
// {
//     ProcessingOnly = true;
//     UseRequestPage = false;
//     UseSystemPrinter = false;

//     dataset
//     {
//         dataitem("Packing Line"; "Packing Line")
//         {
//             RequestFilterFields = "Source Document No.";

//             trigger OnAfterGetRecord()
//             begin
//                 FOR i := 1 TO 30 DO BEGIN
//                     txtData[i] := '';
//                 END;
//                 CLEAR(DataText);
//                 CALCFIELDS(Image);
//                 IF Image.HASVALUE THEN BEGIN
//                     Image.CREATEINSTREAM(DataStream);
//                     DataText.READ(DataStream);

//                     Length := DataText.LENGTH;

//                     IF ISCLEAR(NavPrinter) THEN BEGIN
//                         Result := CREATE(NavPrinter, TRUE, TRUE);
//                         recPrinterSelection.RESET;
//                         recPrinterSelection.SETRANGE("Report ID", 50004);
//                         recPrinterSelection.SETRANGE("User ID", USERID);
//                         IF recPrinterSelection.FIND('-') THEN
//                             txtPrinterName := recPrinterSelection."Printer Name"
//                         ELSE BEGIN
//                             recPrinterSelection.RESET;
//                             recPrinterSelection.SETRANGE("Report ID", 50004);
//                             recPrinterSelection.SETRANGE("User ID", '');
//                             IF recPrinterSelection.FIND('-') THEN
//                                 txtPrinterName := recPrinterSelection."Printer Name"
//                             ELSE
//                                 txtPrinterName := '';
//                         END;
//                         NavPrinter.DirectPrint(txtPrinterName, DataText);
//                         CLEAR(DataText);
//                         //ERROR('Printed Successfully');
//                     END;
//                 END;
//             end;

//             trigger OnPreDataItem()
//             begin
//                 IF cdNo1 <> '' THEN
//                     SETRANGE("Source Document No.", cdNo1);
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
//         DataText: BigText;
//         DataStream: InStream;
//         txtData: array[30] of Text[1000];
//         Length: Integer;
//         i: Integer;
//         cdNo1: Code[20];
//         TrackingNo: Text[30];
//         Xmlhttp: Automation;
//         Result: Boolean;
//         NavPrinter: Automation;
//         recPrinterSelection: Record "Printer Selection";
//         txtPrinterName: Text[250];

//     procedure UpdateText()
//     begin
//         i := 0;
//         IF Length <> 0 THEN
//             REPEAT

//                 i += 1;
//                 IF Length > i * 1000 THEN
//                     DataText.GETSUBTEXT(txtData[i], i * 1000 - 999, 1000)
//                 ELSE
//                     DataText.GETSUBTEXT(txtData[i], i * 1000 - 999, Length);


//             UNTIL Length <= i * 1000;
//     end;

//     procedure InitVar(cdNo: Code[20]; trckNo: Text[30])
//     begin
//         cdNo1 := cdNo;
//         TrackingNo := trckNo;
//     end;
// }

