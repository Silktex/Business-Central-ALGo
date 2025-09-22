pageextension 50232 "Posted Purchase Receipt_Ext" extends "Posted Purchase Receipt"
{
    actions
    {
        addafter("&Navigate")
        {
            action(BackOrderFill)
            {
                Caption = 'Back Order Fill';
                Image = "Report";
                Promoted = true;
                ToolTip = 'Back Order Fill';
                ApplicationArea = all;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    PurchRcptLine.Reset;
                    PurchRcptLine.SetRange("Document No.", Rec."No.");
                    if PurchRcptLine.FindFirst then
                        REPORT.RunModal(50025, true, true, PurchRcptLine);
                end;
            }
            //Functionlity removed
            // action(PrintLabel)
            // {
            //     Caption = 'Print Label';
            //     ApplicationArea = all;

            //     trigger OnAction()
            //     begin
            //         Buffer.Reset;
            //         Buffer.DeleteAll;

            //         if NoOfCopy = 0 then
            //             NoOfCopy += 1;
            //         Cnt += 1;

            //         for C := 1 to NoOfCopy do
            //             recILE.Reset;
            //         recILE.SetRange(recILE."Document No.", Rec."No.");
            //         if recILE.Find('-') then begin
            //             repeat
            //                 if (Cnt mod 3) = 1 then begin
            //                     EntryNo += 1;
            //                     Buffer.Init;
            //                     Buffer."Entry No." := EntryNo;
            //                     Buffer.Column1 := recILE."Item No.";
            //                     if recItem.Get(recILE."Item No.") then
            //                         Buffer.Column2 := recItem.Description;
            //                     Buffer.Column3 := Format(recILE.Quantity);
            //                     Buffer.Column4 := recILE."Unit of Measure Code";
            //                     Buffer.Column5 := recILE."Lot No.";
            //                     QRCodeInput1 := Buffer.Column5;
            //                     QRCodeFileName1 := QRMgt.GetQRCode(QRCodeInput1);
            //                     QRCodeFileName1 := QRMgt.MoveToMagicPath(QRCodeFileName1);
            //                     Clear(TempBlob1);
            //                     ThreeTierMgt.BLOBImport(TempBlob1, QRCodeFileName1);
            //                     if TempBlob1.HasValue then begin
            //                         Buffer.BLOB1 := TempBlob1;
            //                         //Buffer.MODIFY;
            //                     end;

            //                     // if not IsServiceTier then
            //                     //     if Exists(QRCodeFileName1) then
            //                     //         Erase(QRCodeFileName1);

            //                     Buffer.Insert;
            //                     Cnt += 1;
            //                 end else
            //                     if (Cnt mod 3) = 2 then begin
            //                         Buffer.Reset;
            //                         Buffer."Entry No." := EntryNo;
            //                         Buffer.Column6 := recILE."Item No.";
            //                         if recItem.Get(recILE."Item No.") then
            //                             Buffer.Column7 := recItem.Description;
            //                         Buffer.Column8 := Format(recILE.Quantity);
            //                         Buffer.Column9 := recILE."Unit of Measure Code";
            //                         Buffer.Column10 := recILE."Lot No.";
            //                         QRCodeInput2 := Buffer.Column10;
            //                         QRCodeFileName2 := QRMgt.GetQRCode(QRCodeInput2);
            //                         QRCodeFileName2 := QRMgt.MoveToMagicPath(QRCodeFileName2);
            //                         Clear(TempBlob2);
            //                         ThreeTierMgt.BLOBImport(TempBlob2, QRCodeFileName2);
            //                         if TempBlob2.HasValue then begin
            //                             Buffer.BLOB2 := TempBlob2;
            //                             //Buffer.MODIFY;
            //                         end;

            //                         // if not IsServiceTier then
            //                         //     if Exists(QRCodeFileName2) then
            //                         //         Erase(QRCodeFileName2);

            //                         Buffer.Modify;
            //                         Cnt += 1;
            //                     end else begin
            //                         Buffer.Reset;
            //                         Buffer."Entry No." := EntryNo;
            //                         Buffer.Column11 := recILE."Item No.";
            //                         if recItem.Get(recILE."Item No.") then
            //                             Buffer.Column12 := recItem.Description;
            //                         Buffer.Column13 := Format(recILE.Quantity);
            //                         Buffer.Column14 := recILE."Unit of Measure Code";
            //                         Buffer.Column15 := recILE."Lot No.";
            //                         QRCodeInput3 := Buffer.Column15;
            //                         QRCodeFileName3 := QRMgt.GetQRCode(QRCodeInput3);
            //                         QRCodeFileName3 := QRMgt.MoveToMagicPath(QRCodeFileName3);
            //                         Clear(TempBlob3);
            //                         ThreeTierMgt.BLOBImport(TempBlob3, QRCodeFileName3);
            //                         if TempBlob3.HasValue then begin
            //                             Buffer.BLOB3 := TempBlob3;
            //                             //Buffer.MODIFY;
            //                         end;

            //                         // if not IsServiceTier then
            //                         //     if Exists(QRCodeFileName3) then
            //                         //         Erase(QRCodeFileName3);

            //                         Buffer.Modify;
            //                         Cnt += 1;
            //                     end;
            //             until recILE.Next = 0;
            //         end;
            //         Commit;
            //         REPORT.RunModal(50042, true, true);
            //         //recILE.RESET;
            //         //recILE.SETRANGE(recILE."Document No.","No.");
            //         //REPORT.RUNMODAL(50003,TRUE,TRUE,recILE);
            //     end;
            // }
        }
    }
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        recILE: Record "Item Ledger Entry";
        // Buffer: Record "Barcode Temp";
        recItem: Record Item;
        Cnt: Integer;
        C: Integer;
        NoOfCopy: Integer;
        EntryNo: Integer;
        QRMgt: Codeunit "QR Code Management";
        TempBlob1: Codeunit "Temp Blob";
        QRCodeInput1: Text[1024];
        QRCodeFileName1: Text[1024];
        TempBlob2: Codeunit "Temp Blob";
        QRCodeInput2: Text[1024];
        QRCodeFileName2: Text[1024];
        TempBlob3: Codeunit "Temp Blob";
        QRCodeInput3: Text[1024];
        QRCodeFileName3: Text[1024];
        ThreeTierMgt: Codeunit "File Management";
}
