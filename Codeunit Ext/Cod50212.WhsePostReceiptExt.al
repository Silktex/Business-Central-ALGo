codeunit 50212 "Whse.-Post Receipt_Ext"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnInitSourceDocumentLinesOnAfterSourcePurchLineFound', '', false, false)]
    local procedure OnInitSourceDocumentLinesOnAfterSourcePurchLineFound(var PurchaseLine: Record "Purchase Line"; WhseRcptLine: Record "Warehouse Receipt Line"; ModifyLine: Boolean; WhseRcptHeader: Record "Warehouse Receipt Header")
    begin
        //>>Ashwini
        IF PurchaseLine."ETA Date" <> WhseRcptLine."ETA Date" THEN BEGIN
            PurchaseLine."ETA Date" := WhseRcptLine."ETA Date";
            ModifyLine := TRUE;
        END;
        //<<Ashwini
    end;
}
