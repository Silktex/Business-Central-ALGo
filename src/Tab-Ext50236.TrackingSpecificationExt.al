tableextension 50236 "Tracking Specification_Ext" extends "Tracking Specification"
{
    fields
    {
        modify("Lot No.")
        {
            trigger OnAfterValidate()
            var
                recILE: Record "Item Ledger Entry";
            begin
                IF (("Source Type" = 39) AND ("Source Subtype" = 1)) THEN
                    "Dylot No." := "Source ID"
                ELSE BEGIN
                    recILE.RESET;
                    recILE.SETRANGE("Entry Type", recILE."Entry Type"::Purchase);
                    recILE.SETRANGE("Document Type", recILE."Document Type"::"Purchase Receipt");
                    recILE.SETRANGE("Lot No.", "Lot No.");
                    IF recILE.FIND('-') THEN
                        "Dylot No." := recILE."Dylot No.";
                END;
            end;
        }
        field(50000; "Quality Grade"; Option)
        {
            OptionCaption = ' ,A,B,C,D,E,F,X';
            OptionMembers = " ",A,B,C,D,E,F,X;
        }
        field(50001; "Dylot No."; Code[20])
        {
        }
    }
}
