codeunit 50210 "Get Source Doc. Inbound_Ext"
{
    procedure CreateFromInbndTransferOrderHandHeld(TransHeader: Record "Transfer Header")
    var
        WhseRqst: Record "Warehouse Request";
        WhseRcptHeader: Record "Warehouse Receipt Header";
        GetSourceDocuments: Report "Get Source Documents";
    begin
        // WITH TransHeader DO BEGIN
        TransHeader.TESTFIELD(Status, TransHeader.Status::Released);
        WhseRqst.SETRANGE(Type, WhseRqst.Type::Inbound);
        WhseRqst.SETRANGE("Source Type", DATABASE::"Transfer Line");
        WhseRqst.SETRANGE("Source Subtype", 1);
        WhseRqst.SETRANGE("Source No.", TransHeader."No.");
        WhseRqst.SETRANGE("Document Status", WhseRqst."Document Status"::Released);
        GetRequireReceiveRqst(WhseRqst);

        IF WhseRqst.FINDFIRST THEN BEGIN
            GetSourceDocuments.USEREQUESTPAGE(FALSE);
            GetSourceDocuments.SETTABLEVIEW(WhseRqst);
            GetSourceDocuments.RUNMODAL;
            //GetSourceDocuments.GetLastReceiptHeader(WhseRcptHeader);
            //PAGE.RUN(PAGE::"Warehouse Receipt",WhseRcptHeader);
        END;
        //END;
    end;

    local procedure GetRequireReceiveRqst(var WhseRqst: Record "Warehouse Request")
    var
        Location: Record Location;
        LocationCode: Text;
    begin
        IF WhseRqst.FINDSET THEN BEGIN
            REPEAT
                IF Location.RequireReceive(WhseRqst."Location Code") THEN
                    LocationCode += WhseRqst."Location Code" + '|';
            UNTIL WhseRqst.NEXT = 0;
            IF LocationCode <> '' THEN BEGIN
                LocationCode := COPYSTR(LocationCode, 1, STRLEN(LocationCode) - 1);
                IF LocationCode[1] = '|' THEN
                    LocationCode := '''''' + LocationCode;
            END;
            WhseRqst.SETFILTER("Location Code", LocationCode);
        END;
    end;
}
