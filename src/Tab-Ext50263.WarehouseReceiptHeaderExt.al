tableextension 50263 "Warehouse Receipt Header_Ext" extends "Warehouse Receipt Header"
{
    fields
    {
        field(50000; "ETA Date"; Date)
        {

            trigger OnValidate()
            var
                recWhseRecptLine: Record "Warehouse Receipt Line";
            begin
                recWhseRecptLine.RESET;
                recWhseRecptLine.SETRANGE(recWhseRecptLine."No.", "No.");
                IF recWhseRecptLine.FINDFIRST THEN
                    REPEAT
                        recWhseRecptLine."ETA Date" := "ETA Date";
                        recWhseRecptLine.MODIFY(TRUE);
                    UNTIL recWhseRecptLine.NEXT = 0;
            end;
        }
    }
}
