codeunit 50006 "Whse.-Act.-RegisterWe (Yes/No)"
{
    TableNo = "Warehouse Activity Line";

    trigger OnRun()
    begin
        WhseActivLine.COPY(Rec);
        Code;
        Rec.COPY(WhseActivLine);
    end;

    var
        Text001: Label 'Do you want to register the %1 Document?';
        WhseActivLine: Record "Warehouse Activity Line";
        WhseActivityRegister: Codeunit "Whse.-Activity-Register";
        WMSMgt: Codeunit "WMS Management";
        Text002: Label 'The document %1 is not supported.';
        HHUsr: Code[50];

    local procedure "Code"()
    begin
        //WITH WhseActivLine DO BEGIN
        IF (WhseActivLine."Activity Type" = WhseActivLine."Activity Type"::"Invt. Movement") AND
           NOT (WhseActivLine."Source Document" IN [WhseActivLine."Source Document"::" ",
                                      WhseActivLine."Source Document"::"Prod. Consumption",
                                      WhseActivLine."Source Document"::"Assembly Consumption"])
        THEN
            ERROR(Text002, WhseActivLine."Source Document");

        WMSMgt.CheckBalanceQtyToHandle(WhseActivLine);

        //IF NOT CONFIRM(Text001,FALSE,"Activity Type") THEN
        //EXIT;
        //WhseActivityRegister.GetHHUsrId(HHUsr);
        WhseActivityRegister.ShowHideDialog(true);
        WhseActivityRegister.RUN(WhseActivLine);
        CLEAR(WhseActivityRegister);
        //END;
    end;


    procedure HHUsrId(UsrId: Code[50])
    begin
        HHUsr := UsrId;
    end;
}

