codeunit 50211 "Get Source Doc. Outbound_Ext"
{
    var
        Text003: Label 'The warehouse shipment was not created because an open warehouse shipment exists for the Sales Header and Shipping Advice is %1.\\You must add the item(s) as new line(s) to the existing warehouse shipment or change Shipping Advice to Partial.';
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";

    procedure CreateFromSalesOrderHendheld(SalesHeader: Record "Sales Header")
    var
        WhseRqst: Record "Warehouse Request";
        WareHouseShipmentLine: Record "Warehouse Shipment Line";
    begin
        // WITH SalesHeader DO BEGIN
        SalesHeader.TESTFIELD(Status, SalesHeader.Status::Released);
        IF SalesHeader.WhseShipmentConflict(SalesHeader."Document Type", SalesHeader."No.", SalesHeader."Shipping Advice") THEN
            ERROR(Text003, FORMAT(SalesHeader."Shipping Advice"));
        GetSourceDocOutbound.CheckSalesHeader(SalesHeader, TRUE);
        WhseRqst.SETRANGE(Type, WhseRqst.Type::Outbound);
        WhseRqst.SETRANGE("Source Type", DATABASE::"Sales Line");
        WhseRqst.SETRANGE("Source Subtype", SalesHeader."Document Type");
        WhseRqst.SETRANGE("Source No.", SalesHeader."No.");
        WhseRqst.SETRANGE("Document Status", WhseRqst."Document Status"::Released);
        GetRequireShipRqst(WhseRqst);
        //END;

        OpenWarehouseShipmentPageHendheld(WhseRqst, SalesHeader."No.");
    end;

    local procedure OpenWarehouseShipmentPageHendheld(var WarehouseRequest: Record "Warehouse Request"; SalesOrderNo: Code[20])
    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        GetSourceDocuments: Report "Get Source Documents";
        WhseShptLines: Record "Warehouse Shipment Line";
        PGWhseShptLines: Report "Whse.-Shipment - Create Pick";
    begin
        IF WarehouseRequest.FINDFIRST THEN BEGIN
            GetSourceDocuments.USEREQUESTPAGE(FALSE);
            GetSourceDocuments.SETTABLEVIEW(WarehouseRequest);
            GetSourceDocuments.RUNMODAL;
            GetSourceDocuments.GetLastShptHeader(WarehouseShipmentHeader);
        END;

        WhseShptLines.RESET;
        WhseShptLines.SETRANGE(WhseShptLines."Source Document", WhseShptLines."Source Document"::"Sales Order");
        WhseShptLines.SETRANGE(WhseShptLines."Source No.", SalesOrderNo);
        WhseShptLines.SETFILTER(Quantity, '>0');
        WhseShptLines.SETRANGE("Completely Picked", FALSE);
        IF WhseShptLines.FINDFIRST THEN BEGIN
            // REPEAT
            PGWhseShptLines.USEREQUESTPAGE(FALSE);
            PGWhseShptLines.SetWhseShipmentLine(WhseShptLines, WarehouseShipmentHeader);
            //PGWhseShptLines.SETTABLEVIEW(WhseShptLines,WarehouseShipmentHeader);

            PGWhseShptLines.RUNMODAL;
            CLEAR(PGWhseShptLines);
            //   UNTIL WhseShptLines.NEXT=0;
        END;
    end;


    procedure CreateFromOutbndTransferOrderHendheld(TransHeader: Record "Transfer Header")
    var
        WhseRqst: Record "Warehouse Request";
    begin
        //WITH TransHeader DO BEGIN
        TransHeader.TESTFIELD(Status, TransHeader.Status::Released);
        GetSourceDocOutbound.CheckTransferHeader(TransHeader, TRUE);
        WhseRqst.SETRANGE(Type, WhseRqst.Type::Outbound);
        WhseRqst.SETRANGE("Source Type", DATABASE::"Transfer Line");
        WhseRqst.SETRANGE("Source Subtype", 0);
        WhseRqst.SETRANGE("Source No.", TransHeader."No.");
        WhseRqst.SETRANGE("Document Status", WhseRqst."Document Status"::Released);
        GetRequireShipRqst(WhseRqst);
        // END;
        OpenTransferWarehouseShipmentPageHendheld(WhseRqst, TransHeader."No.");
    end;

    local procedure OpenTransferWarehouseShipmentPageHendheld(var WarehouseRequest: Record "Warehouse Request"; TransferOrderNo: Code[20])
    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        GetSourceDocuments: Report "Get Source Documents";
        WhseShptLines: Record "Warehouse Shipment Line";
        PGWhseShptLines: Report "Whse.-Shipment - Create Pick";
    begin
        IF WarehouseRequest.FINDFIRST THEN BEGIN
            GetSourceDocuments.USEREQUESTPAGE(FALSE);
            GetSourceDocuments.SETTABLEVIEW(WarehouseRequest);
            GetSourceDocuments.RUNMODAL;
            GetSourceDocuments.GetLastShptHeader(WarehouseShipmentHeader);
        END;

        WhseShptLines.RESET;
        WhseShptLines.SETRANGE(WhseShptLines."Source Document", WhseShptLines."Source Document"::"Outbound Transfer");
        WhseShptLines.SETRANGE(WhseShptLines."Source No.", TransferOrderNo);
        WhseShptLines.SETFILTER(Quantity, '>0');
        WhseShptLines.SETRANGE("Completely Picked", FALSE);
        IF WhseShptLines.FINDFIRST THEN BEGIN
            // REPEAT
            PGWhseShptLines.USEREQUESTPAGE(FALSE);
            PGWhseShptLines.SetWhseShipmentLine(WhseShptLines, WarehouseShipmentHeader);
            //PGWhseShptLines.SETTABLEVIEW(WhseShptLines,WarehouseShipmentHeader);

            PGWhseShptLines.RUNMODAL;
            CLEAR(PGWhseShptLines);
            //   UNTIL WhseShptLines.NEXT=0;
        END;
    end;

    local procedure GetRequireShipRqst(var WhseRqst: Record "Warehouse Request")
    var
        Location: Record Location;
        LocationCode: Text;
    begin
        IF WhseRqst.FINDSET THEN BEGIN
            REPEAT
                IF Location.RequireShipment(WhseRqst."Location Code") THEN
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
