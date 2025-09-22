tableextension 50213 "Purchase Header_Ext" extends "Purchase Header"
{
    fields
    {
        field(50027; "ETA Date"; Date)
        {

            trigger OnValidate()
            var
                recPurchLine: Record "Purchase Line";
            begin
                //>>Ashwini
                IF "ETA Date" <> xRec."ETA Date" THEN BEGIN
                    recPurchLine.RESET;
                    recPurchLine.SETRANGE(recPurchLine."Document Type", "Document Type");
                    recPurchLine.SETRANGE(recPurchLine."Document No.", "No.");
                    IF recPurchLine.FIND('-') THEN
                        REPEAT
                            recPurchLine."ETA Date" := "ETA Date";
                            recPurchLine.MODIFY(TRUE);
                        UNTIL recPurchLine.NEXT = 0;
                END;
                //<<Ashwini
            end;
        }
        field(50050; "Short Close"; Boolean)
        {
        }
        field(50051; "Ship Via"; Code[20])
        {
        }
        field(50052; "Consignment No."; Text[30])
        {
        }
        field(50053; "File No."; Text[50])
        {
            Description = 'SPD MS 270815';
        }

    }
    var
        cuArchiveManagement: Codeunit ArchiveManagement;

    trigger OnBeforeDelete()
    begin
        cuArchiveManagement.StorePurchDocument(Rec, FALSE);
    end;
}
