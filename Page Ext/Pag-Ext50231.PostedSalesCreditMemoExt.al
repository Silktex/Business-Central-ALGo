pageextension 50231 "Posted Sales Credit Memo_Ext" extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("No. Printed")
        {
            field("Commission Override"; Rec."Commission Override")
            {
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    IF Rec."Commission Override" THEN
                        IF NOT CONFIRM('Do you want to override commision Amount', TRUE) THEN
                            ERROR('Commision Override must be no');

                    IF Rec."Commission Override" THEN
                        blnOverride := TRUE
                    ELSE
                        blnOverride := FALSE;
                END;
            }
            field("Commision %"; Rec."Commision %")
            {
                Editable = blnOverride;
                ApplicationArea = all;
            }
        }
    }
    trigger OnOpenPage()
    begin
        IF Rec."Commission Override" THEN
            blnOverride := TRUE
        ELSE
            blnOverride := FALSE;
    end;

    trigger OnAfterGetRecord()
    begin
        IF Rec."Commission Override" THEN
            blnOverride := TRUE
        ELSE
            blnOverride := FALSE;
    end;

    var
        blnOverride: Boolean;
}
