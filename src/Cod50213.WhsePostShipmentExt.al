codeunit 50213 "Whse.-Post Shipment_Ext"
{
    var
        SalesHeader: Record "Sales Header";
        recPaymentTerms: Record "Payment Terms";
        RecTrackingno: Record "Tracking No.";

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Whse.-Post Shipment", 'OnAfterCheckWhseShptLine', '', false, false)]
    local procedure OnAfterCheckWhseShptLine(var WarehouseShipmentLine: Record "Warehouse Shipment Line")
    begin
        //ASHWINI
        IF SalesHeader.GET(SalesHeader."Document Type"::Order, WarehouseShipmentLine."Source No.") THEN BEGIN
            IF SalesHeader."Payment Terms Code" <> '' THEN BEGIN
                IF recPaymentTerms.GET(SalesHeader."Payment Terms Code") THEN
                    IF recPaymentTerms."Dont Ship" THEN
                        ERROR('Please Check Payment Terms');
            END;
        END;
        //ASHWINI
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Whse.-Post Shipment", 'OnInitSourceDocumentHeaderOnBeforeSalesHeaderModify', '', false, false)]
    local procedure OnInitSourceDocumentHeaderOnBeforeSalesHeaderModify(var SalesHeader: Record "Sales Header"; var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; var ModifyHeader: Boolean; Invoice: Boolean; var WarehouseShipmentLine: Record "Warehouse Shipment Line")
    begin
        //Ashwini
        RecTrackingno.RESET;
        RecTrackingno.SETRANGE(RecTrackingno."Warehouse Shipment No", WarehouseShipmentHeader."No.");
        IF RecTrackingno.FINDFIRST THEN BEGIN
            SalesHeader."Package Tracking No." := RecTrackingno."Tracking No.";
            ModifyHeader := TRUE;
        END;
        /*
       IF WhseShptHeader."Tracking No." <> ''
       THEN BEGIN
     SalesHeader."Package Tracking No." := WarehouseShipmentHeader."Tracking No.";
     ModifyHeader := TRUE;
 END;
       */
        //Ashwini
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Whse.-Post Shipment", 'OnBeforePostedWhseShptHeaderInsert', '', false, false)]
    local procedure OnBeforePostedWhseShptHeaderInsert(var PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header"; WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        PostedWhseShipmentHeader."Freight Amount" := WarehouseShipmentHeader."Freight Amount";  //SKNAV11.00
        PostedWhseShipmentHeader.Picture := WarehouseShipmentHeader.Picture; //SKNAV11.00
    end;
}
