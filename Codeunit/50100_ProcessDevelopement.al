codeunit 50100 ProcessDevelopment
{
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
    //Code for Table sales header 36
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCopyShipToCustomerAddressFieldsFromCustomer', '', false, false)]
    local procedure OnAfterCopyShipToCustomerAddressFieldsFromCustomer(var SalesHeader: Record "Sales Header"; SellToCustomer: Record Customer)
    begin
        SalesHeader."Payment Terms Code" := SellToCustomer."Payment Terms Code"; //Ashwini
        SalesHeader.Residential := SellToCustomer.Residential; //Ravi
        SalesHeader.AddressValidated := SellToCustomer.AddressValidated;//Ravi
        SalesHeader."Customer Price Group" := SellToCustomer."Customer Price Group";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCheckSellToCust', '', false, false)]
    local procedure OnAfterCheckSellToCust(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; Customer: Record Customer; CurrentFieldNo: Integer)
    begin
        SalesHeader."PI Contact" := Customer."PI Contact";//Meghna
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCopySellToCustomerAddressFieldsFromCustomer', '', false, false)]
    local procedure OnAfterCopySellToCustomerAddressFieldsFromCustomer(var SalesHeader: Record "Sales Header"; SellToCustomer: Record Customer; CurrentFieldNo: Integer; var SkipBillToContact: Boolean)
    begin
        //Handheld BEGIn
        IF (SellToCustomer."Shipping Account No." <> '') OR (SellToCustomer."UPS Account No." <> '') THEN
            SalesHeader."Charges Pay By" := SalesHeader."Charges Pay By"::RECEIVER
        ELSE
            SalesHeader."Charges Pay By" := SalesHeader."Charges Pay By"::SENDER;


        SalesHeader."No insurance" := SellToCustomer."No insurance";
        //Handheld END

        SalesHeader.Residential := SellToCustomer.Residential;//Ravi
        SalesHeader.AddressValidated := SellToCustomer.AddressValidated; //Ravi
        SalesHeader."Sell-to Country/Region Code" := SellToCustomer."Country/Region Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnValidateSellToCustomerNoOnBeforeRecallModifyAddressNotification', '', false, false)]
    local procedure OnValidateSellToCustomerNoOnBeforeRecallModifyAddressNotification(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header")
    var
        recShiptoAdd: Record "Ship-to Address";
    begin
        IF (xSalesHeader."Sell-to Customer No." <> SalesHeader."Sell-to Customer No.") THEN BEGIN
            recShiptoAdd.RESET;
            recShiptoAdd.SETRANGE("Customer No.", SalesHeader."Sell-to Customer No.");
            recShiptoAdd.SETRANGE("Use Default", TRUE);
            IF recShiptoAdd.FIND('-') THEN BEGIN
                SalesHeader.VALIDATE("Ship-to Code", recShiptoAdd.Code)
            END;
        END;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCopyShipToCustomerAddressFieldsFromShipToAddr', '', false, false)]
    local procedure OnAfterCopyShipToCustomerAddressFieldsFromShipToAddr(var SalesHeader: Record "Sales Header"; ShipToAddress: Record "Ship-to Address")
    var
        Cust: Record Customer;
    begin
        //>>Ashwini
        IF ShipToAddress."Payment Terms Code" = '' THEN BEGIN
            Cust.GET(SalesHeader."Sell-to Customer No.");
            SalesHeader."Payment Terms Code" := Cust."Payment Terms Code";
        END ELSE
            SalesHeader."Payment Terms Code" := ShipToAddress."Payment Terms Code";

        SalesHeader.Residential := ShipToAddress.Residential; //Ravi
        SalesHeader.AddressValidated := ShipToAddress.AddressValidated; //Ravi
        IF ShipToAddress."Customer Price Group" <> '' THEN
            SalesHeader."Customer Price Group" := ShipToAddress."Customer Price Group";
        //<<Ashwini
    end;

    //Code for table sales line 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeCheckPromisedDeliveryDate', '', false, false)]

    local procedure OnBeforeCheckPromisedDeliveryDate(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;
    //Code for table purchase line 39
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeUpdateDirectUnitCost', '', false, false)]
    local procedure OnBeforeUpdateDirectUnitCost(var PurchLine: Record "Purchase Line"; xPurchLine: Record "Purchase Line"; CalledByFieldNo: Integer; CurrFieldNo: Integer; var Handled: Boolean)
    begin
        IF CurrFieldNo = 50001 THEN
            CurrFieldNo := 15;
    end;

    //Code for Table 83 Item journal line
    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromPurchHeader', '', false, false)]
    local procedure OnAfterCopyItemJnlLineFromPurchHeader(var ItemJnlLine: Record "Item Journal Line"; PurchHeader: Record "Purchase Header")
    begin
        ItemJnlLine."ETA Date" := PurchHeader."ETA Date";//Ashwini

    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromPurchLine', '', false, false)]
    local procedure OnAfterCopyItemJnlLineFromPurchLine(var ItemJnlLine: Record "Item Journal Line"; PurchLine: Record "Purchase Line")
    begin
        ItemJnlLine."ETA Date" := ItemJnlLine."ETA Date";//Ashwini

    end;

    //Code for Table sales shipment line
    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine', '', false, false)]
    local procedure OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; var NextLineNo: Integer; var Handled: Boolean)
    var
        SalesShptHeader: Record "Sales Shipment Header";
    begin
        //>>SPD AK 11022015
        IF SalesShptHeader.GET(SalesShptLine."Document No.") THEN
            SalesLine.Description := 'PO# ' + SalesShptHeader."External Document No." + ' Shipment# ' + SalesShptLine."Document No."
        //LanguageManagement.SetGlobalLanguageByCode(SalesInvHeader."Language Code");
    end;

    //code for Table 336 Tracking specification
    [EventSubscriber(ObjectType::Table, Database::"Tracking Specification", 'OnBeforeCheckSerialNoQty', '', false, false)]
    local procedure OnBeforeCheckSerialNoQty(var TrackingSpecification: Record "Tracking Specification"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    //Code for table 5744 Transfer shipment Header
    [EventSubscriber(ObjectType::Table, Database::"Transfer Shipment Header", 'OnAfterCopyFromTransferHeader', '', false, false)]
    local procedure OnAfterCopyFromTransferHeader(var TransferShipmentHeader: Record "Transfer Shipment Header"; TransferHeader: Record "Transfer Header")
    begin
        TransferShipmentHeader."Ship Via" := TransferHeader."Ship Via";   //SKNAV11.00
        TransferShipmentHeader."Consignment No." := TransferHeader."Consignment No.";   //SKNAV11.00
    end;

    //Code for table 5745 Transfer shipment Line
    [EventSubscriber(ObjectType::Table, Database::"Transfer Shipment Line", 'OnAfterCopyFromTransferLine', '', false, false)]
    local procedure OnAfterCopyFromTransferLine(var TransferShipmentLine: Record "Transfer Shipment Line"; TransferLine: Record "Transfer Line")
    begin
        TransferShipmentLine."Purchase Receipt No." := TransferLine."Purchase Receipt No.";   //SKNAV11.00
        TransferShipmentLine."Purchase Receipt Line No." := TransferLine."Purchase Receipt Line No.";   //SKNAV11.00
    end;

    //Code for table 5746 Transfer Receipt Header
    [EventSubscriber(ObjectType::Table, Database::"Transfer Receipt Header", 'OnAfterCopyFromTransferHeader', '', false, false)]
    local procedure OnAfterCopyFromTransferHeaderReceipt(var TransferReceiptHeader: Record "Transfer Receipt Header"; TransferHeader: Record "Transfer Header")
    begin
        TransferReceiptHeader."Ship Via" := TransferHeader."Ship Via";   //SKNAV11.00
        TransferReceiptHeader."Consignment No." := TransferHeader."Consignment No.";   //SKNAV11.00
    end;
    //Code for table 5747 Transfer Receipt Line
    [EventSubscriber(ObjectType::Table, Database::"Transfer Receipt line", 'OnAfterCopyFromTransferLine', '', false, false)]
    local procedure OnAfterCopyFromTransferLineReceipt(var TransferReceiptline: Record "Transfer Receipt Line"; TransferLine: Record "Transfer Line")
    begin
        TransferReceiptline."Purchase Receipt No." := TransferLine."Purchase Receipt No.";   //SKNAV11.00
        TransferReceiptline."Purchase Receipt Line No." := TransferLine."Purchase Receipt Line No.";   //SKNAV11.00

    end;

    //Code for table 5767 Warehouse Activity Line
    [EventSubscriber(ObjectType::Table, Database::"Warehouse Activity Line", 'OnBeforeReNumberWhseActivityLines', '', false, false)]
    local procedure OnBeforeReNumberWhseActivityLines(var NewWarehouseActivityLine: Record "Warehouse Activity Line"; var WarehouseActivityLine: Record "Warehouse Activity Line"; var NewLineNo: Integer; var LineSpacing: Integer; var sHandled: Boolean)
    begin
        IF NewWarehouseActivityLine.FIND('>') THEN BEGIN
            IF (WarehouseActivityLine."Line No." MOD 10000 <> 9999) THEN
                LineSpacing := 10002
            ELSE
                LineSpacing :=
                  (NewWarehouseActivityLine."Line No." - WarehouseActivityLine."Line No.") DIV 2;
        END ELSE
            LineSpacing := 10000;

        if LineSpacing = 0 then
            sHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Activity Line", 'OnBeforeInsertNewWhseActivLine', '', false, false)]
    local procedure OnBeforeInsertNewWhseActivLine(var NewWarehouseActivityLine: Record "Warehouse Activity Line"; var WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        IF WarehouseActivityLine."Ref. Line No." <> 0 THEN
            NewWarehouseActivityLine."Ref. Line No." := WarehouseActivityLine."Ref. Line No."
        ELSE
            NewWarehouseActivityLine."Ref. Line No." := WarehouseActivityLine."Line No.";
        IF (NewWarehouseActivityLine."Activity Type" = NewWarehouseActivityLine."Activity Type"::Pick) THEN BEGIN
            NewWarehouseActivityLine."Qty. to Handle" := 0;
            NewWarehouseActivityLine."Qty. to Handle (Base)" := 0;
            NewWarehouseActivityLine."Zone Code" := WarehouseActivityLine."Zone Code";
            NewWarehouseActivityLine."Bin Code" := WarehouseActivityLine."Bin Code";
            NewWarehouseActivityLine."Lot No." := '';
        END;
    end;

    //Code for table 7321 Warehouse Shipment Line
    [EventSubscriber(ObjectType::Table, Database::"Warehouse Shipment Line", 'OnCheckSourceDocLineQtyOnBeforeFieldError', '', false, false)]
    local procedure OnCheckSourceDocLineQtyOnBeforeFieldError(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; WhseQtyOutstandingBase: Decimal; var QtyOutstandingBase: Decimal; QuantityBase: Decimal; var IsHandled: Boolean)
    var
        WhseQtyOutstanding: Decimal;
        SalesRelease: Codeunit "Release Sales Document";
        recSalesHeader: Record "Sales Header";
        decVarianceQuantity: Decimal;
        SalesLine: Record "Sales Line";
        WhseShptLine: Record "Warehouse Shipment Line";
    begin
        WhseShptLine.SetSourceFilter(WarehouseShipmentLine."Source Type", WarehouseShipmentLine."Source Subtype", WarehouseShipmentLine."Source No.", WarehouseShipmentLine."Source Line No.", TRUE);
        WhseShptLine.CALCSUMS("Qty. Outstanding (Base)");
        WhseShptLine.CALCSUMS("Qty. Outstanding");
        IF WhseShptLine.FIND('-') THEN
            REPEAT
                IF (WhseShptLine."No." <> WarehouseShipmentLine."No.") OR
                   (WhseShptLine."Line No." <> WarehouseShipmentLine."Line No.")
                THEN BEGIN
                    //WhseQtyOutstandingBase := WhseQtyOutstandingBase + WhseShptLine."Qty. Outstanding (Base)";
                    //SPDSAUQV001 BEGIN
                    WhseQtyOutstanding := WhseQtyOutstanding + WhseShptLine."Qty. Outstanding";
                END;
            //SPDSAUQV001 End
            UNTIL WhseShptLine.NEXT = 0;
        //SPDSAUQV001 BEGIN 
        if WarehouseShipmentLine."Source Type" = Database::"Sales Line" then begin
            recSalesHeader.GET(WarehouseShipmentLine."Source Subtype", WarehouseShipmentLine."Source No.");
            //SalesRelease.Reopen(recSalesHeader);
            recSalesHeader.Status := recSalesHeader.Status::Open;
            recSalesHeader.Modify();
            SalesLine.GET(WarehouseShipmentLine."Source Subtype", WarehouseShipmentLine."Source No.", WarehouseShipmentLine."Source Line No.");
            IF ABS(SalesLine."Outstanding Quantity") < WhseQtyOutstanding + WarehouseShipmentLine.Quantity THEN BEGIN
                decVarianceQuantity := SalesLine."Original Quantity" - SalesLine."Outstanding Quantity";
                IF (decVarianceQuantity + SalesLine."Outstanding Quantity" + (SalesLine."Original Quantity" * SalesLine."Quantity Variance %" / 100)) < WhseQtyOutstanding + WarehouseShipmentLine.Quantity THEN
                    ERROR('Quantity Is Greater');
                SalesLine.VALIDATE(Quantity, WhseQtyOutstanding + WarehouseShipmentLine.Quantity);
                SalesLine.MODIFY;
            END;
            recSalesHeader.Status := recSalesHeader.Status::Released;
            recSalesHeader.Modify();
            //SalesRelease.RUN(recSalesHeader);
            //SPDSAUQV001 END
        end;
    end;

    //Code for Page 6510 Item Tracking Lines
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnBeforeUpdateUndefinedQty', '', false, false)]
    local procedure OnBeforeUpdateUndefinedQty(var TrackingSpecification: Record "Tracking Specification"; var TotalItemTrackingSpecification: Record "Tracking Specification"; var UndefinedQtyArray: array[3] of Decimal; var SourceQuantityArray: array[5] of Decimal; var ReturnValue: Boolean; var IsHandled: Boolean)
    var
        ProdOrderLineHandling: Boolean;
        WhseActivLine: Record "Warehouse Activity Line";
        ItemTrackingLinePage: Page "Item Tracking Lines";
    begin

        //SPDSAUACCQTYSALE Begin
        ItemTrackingLinePage.CheckActualQuantity(TotalItemTrackingSpecification);

        //decVarianceQuantity:=CheckSalesLineQuantity(Rec); Uncomment IfSales Order Qty will be calculated on Variance
        IF TotalItemTrackingSpecification."Source Type" = 37 THEN begin
            ReturnValue := true;
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterEntriesAreIdentical', '', false, false)]
    local procedure OnAfterEntriesAreIdentical(ReservEntry1: Record "Reservation Entry"; ReservEntry2: Record "Reservation Entry"; var IdenticalArray: array[2] of Boolean)
    begin
        IdenticalArray[1] := (ReservEntry1."Quality Grade" = ReservEntry2."Quality Grade") AND
                             (ReservEntry1."Dylot No." = ReservEntry2."Dylot No.");
        IdenticalArray[2] := (ReservEntry1."Quality Grade" = ReservEntry2."Quality Grade") AND
                            (ReservEntry1."Dylot No." = ReservEntry2."Dylot No.");

    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnRegisterChangeOnAfterCreateReservEntry', '', false, false)]
    local procedure OnRegisterChangeOnAfterCreateReservEntry(var ReservEntry: Record "Reservation Entry"; TrackingSpecification: Record "Tracking Specification"; OldTrackingSpecification: Record "Tracking Specification")
    begin
        ReservEntry."Quality Grade" := OldTrackingSpecification."Quality Grade";
        ReservEntry."Dylot No." := OldTrackingSpecification."Dylot No.";
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterMoveFields', '', false, false)]
    local procedure OnAfterMoveFields(var TrkgSpec: Record "Tracking Specification"; var ReservEntry: Record "Reservation Entry")
    begin
        ReservEntry."Quality Grade" := TrkgSpec."Quality Grade";
        ReservEntry."Dylot No." := TrkgSpec."Dylot No.";
    end;

    [EventSubscriber(ObjectType::table, Database::"Tracking Specification", 'OnAfterSetTrackingFilterFromTrackingSpec', '', false, false)]
    local procedure OnAfterSetTrackingFilterFromTrackingSpec(var TrackingSpecification: Record "Tracking Specification"; FromTrackingSpecification: Record "Tracking Specification")
    var
        Itemtrackingpage: Page "Item Tracking Lines";
    begin
        Itemtrackingpage.CheckActualUnitPrice(FromTrackingSpecification);                  //SPD_AG
        Itemtrackingpage.UpdateActualUnitPrice(FromTrackingSpecification);                 //SPD_AG
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales Line-Reserve", 'OnCallItemTrackingOnBeforeItemTrackingLinesRunModal', '', false, false)]
    local procedure OnCallItemTrackingOnBeforeItemTrackingLinesRunModal(var SalesLine: Record "Sales Line"; var ItemTrackingLines: Page "Item Tracking Lines")
    begin
        Commit();
    end;

    // [EventSubscriber(ObjectType::Codeunit, codeunit::"Price Calculation Buffer Mgt.", 'OnBeforeConvertAmount', '', false, false)]
    // local procedure OnBeforeConvertAmount(AmountType: Enum "Price Amount Type"; var PriceListLine: Record "Price List Line"; PriceCalculationBuffer: Record "Price Calculation Buffer"; var IsHandled: Boolean)
    // begin
    //     Message(PriceListLine."Asset No.");
    // end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales Line - Price", 'OnAfterFillBuffer', '', false, false)]
    local procedure OnAfterFillBuffer(
           var PriceCalculationBuffer: Record "Price Calculation Buffer"; SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line")
    var
        ItemCategory: Record "Item Category";
    begin
        // PriceCalculationBuffer."Item Category" := SalesLine."Item Category Code";
        if PriceCalculationBuffer."Asset Type" = PriceCalculationBuffer."Asset Type"::"Item Category" then begin
            PriceCalculationBuffer."Variant Code" := SalesLine."Variant Code";
            PriceCalculationBuffer."Asset No." := SalesLine."Item Category Code";
            ItemCategory.Get(PriceCalculationBuffer."Asset No.");
            //PriceCalculationBuffer."Unit Price" := Item."Unit Price";
            //PriceCalculationBuffer."Item Disc. Group" := Item."Item Disc. Group";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales Line - Price", 'OnAfterGetAssetType', '', false, false)]
    local procedure OnAfterGetAssetType(SalesLine: Record "Sales Line"; var AssetType: Enum "Price Asset Type")
    var
        PriceListLine: Record "Price List Line";
    begin
        if SalesLine.Type = SalesLine.Type::Item then begin
            PriceListLine.Reset();
            PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
            PriceListLine.SetRange("Asset No.", SalesLine."No.");
            PriceListLine.SetRange(Status, PriceListLine.Status::Active);
            PriceListLine.SetRange("Price Type", PriceListLine."Price Type"::Sale);
            PriceListLine.SetFilter("Amount Type", '%1', PriceListLine."Amount Type"::Any);
            PriceListLine.SetFilter("Ending Date", '%1|>=%2', 0D, GetDocumentDate(SalesLine));
            PriceListLine.SetRange("Starting Date", 0D, GetDocumentDate(SalesLine));
            PriceListLine.SetFilter("Currency Code", '%1|%2', SalesLine."Currency Code", '');
            if SalesLine."Unit of Measure Code" <> '' then
                PriceListLine.SetFilter("Unit of Measure Code", '%1|%2', salesLine."Unit of Measure Code", '');
            if not PriceListLine.FindFirst() then
                AssetType := AssetType::"Item Category";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purchase Line - Price", 'OnAfterFillBuffer', '', false, false)]
    local procedure OnAfterFillBufferPurch(
               var PriceCalculationBuffer: Record "Price Calculation Buffer"; PurchaseHeader: Record "Purchase Header"; PurchaseLine: Record "Purchase Line")
    var
        ItemCategory: Record "Item Category";
    begin
        // PriceCalculationBuffer."Item Category" := SalesLine."Item Category Code";
        if PriceCalculationBuffer."Asset Type" = PriceCalculationBuffer."Asset Type"::"Item Category" then begin
            PriceCalculationBuffer."Variant Code" := PurchaseLine."Variant Code";
            PriceCalculationBuffer."Asset No." := PurchaseLine."Item Category Code";
            ItemCategory.Get(PriceCalculationBuffer."Asset No.");
            //PriceCalculationBuffer."Unit Price" := Item."Unit Price";
            //PriceCalculationBuffer."Item Disc. Group" := Item."Item Disc. Group";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purchase Line - Price", 'OnAfterGetAssetType', '', false, false)]
    local procedure OnAfterGetAssetTypePurch(PurchaseLine: Record "Purchase Line"; var AssetType: Enum "Price Asset Type")
    var
        PriceListLine: Record "Price List Line";
    begin
        if PurchaseLine.Type = PurchaseLine.Type::Item then begin
            PriceListLine.Reset();
            PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
            PriceListLine.SetRange("Asset No.", PurchaseLine."No.");
            PriceListLine.SetRange(Status, PriceListLine.Status::Active);
            PriceListLine.SetRange("Price Type", PriceListLine."Price Type"::Purchase);
            PriceListLine.SetFilter("Amount Type", '%1', PriceListLine."Amount Type"::Any);
            PriceListLine.SetFilter("Ending Date", '%1|>=%2', 0D, GetDocumentDatePurchase(PurchaseLine));
            PriceListLine.SetRange("Starting Date", 0D, GetDocumentDatePurchase(PurchaseLine));
            PriceListLine.SetFilter("Currency Code", '%1|%2', PurchaseLine."Currency Code", '');
            if PurchaseLine."Unit of Measure Code" <> '' then
                PriceListLine.SetFilter("Unit of Measure Code", '%1|%2', PurchaseLine."Unit of Measure Code", '');
            if not PriceListLine.FindFirst() then
                AssetType := AssetType::"Item Category";
        end;
    end;

    // [EventSubscriber(ObjectType::Codeunit, codeunit::"Price Calculation Buffer Mgt.", 'OnAfterSetFilters', '', false, false)]
    // local procedure OnAfterSetFilters(var PriceListLine: Record "Price List Line"; AmountType: Enum "Price Amount Type"; var PriceCalculationBuffer: Record "Price Calculation Buffer"; ShowAll: Boolean)
    // begin
    //     Message('%1', PriceListLine.Count);
    //     if PriceListLine.FindFirst() then
    //         exit;
    //     if PriceListLine.Count = 0 then begin
    //         PriceCalculationBuffer."Asset Type" := PriceCalculationBuffer."Asset Type"::"Item Category";
    //         PriceCalculationBuffer."Asset No." := PriceCalculationBuffer."Item Category";
    //         PriceCalculationBuffer.Modify();

    //         PriceListLine.SetRange(Status, PriceListLine.Status::Active);
    //         PriceListLine.SetRange("Price Type", PriceCalculationBuffer."Price Type");
    //         PriceListLine.SetFilter("Amount Type", '%1|%2', AmountType, PriceListLine."Amount Type"::Any);

    //         PriceListLine.SetFilter("Ending Date", '%1|>=%2', 0D, PriceCalculationBuffer."Document Date");
    //         if not ShowAll then begin
    //             PriceListLine.SetFilter("Currency Code", '%1|%2', PriceCalculationBuffer."Currency Code", '');
    //             if PriceCalculationBuffer."Unit of Measure Code" <> '' then
    //                 PriceListLine.SetFilter("Unit of Measure Code", '%1|%2', PriceCalculationBuffer."Unit of Measure Code", '');
    //             PriceListLine.SetRange("Starting Date", 0D, PriceCalculationBuffer."Document Date");
    //         end;
    //     end;
    // end;

    local procedure GetDocumentDate(SalesLine: Record "Sales Line") DocumentDate: Date;
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.");
        if SalesHeader."No." = '' then
            DocumentDate := SalesLine."Posting Date"
        else
            if SalesHeader."Document Type" in
                [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::"Credit Memo"]
            then
                DocumentDate := SalesHeader."Posting Date"
            else
                DocumentDate := SalesHeader."Order Date";
        if DocumentDate = 0D then
            DocumentDate := WorkDate();
        // OnAfterGetDocumentDate(DocumentDate, SalesHeader, SalesLine);
    end;

    local procedure GetDocumentDatePurchase(PurchaseLine: Record "Purchase Line") DocumentDate: Date;
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader.get(PurchaseLine."Document Type", PurchaseLine."Document No.");
        if PurchaseHeader."Document Type" in
            [PurchaseHeader."Document Type"::Invoice, PurchaseHeader."Document Type"::"Credit Memo"]
        then
            DocumentDate := PurchaseHeader."Posting Date"
        else
            DocumentDate := PurchaseHeader."Order Date";
        if DocumentDate = 0D then
            DocumentDate := WorkDate();
        // OnAfterGetDocumentDate(DocumentDate, PurchaseHeader, PurchaseLine);
    end;

    [EventSubscriber(ObjectType::Report, report::"Get Source Documents", 'OnBeforeWhseShptHeaderInsert', '', false, false)]
    local procedure OnBeforeWhseShptHeaderInsert(var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; var WarehouseRequest: Record "Warehouse Request"; SalesLine: Record "Sales Line"; TransferLine: Record "Transfer Line"; SalesHeader: Record "Sales Header")
    var
        UserSetup: Record "User Setup";
        WarehouseEmployee: Record "Warehouse Employee";
    begin
        //Handheld Fix BEGIN
        IF WarehouseRequest."Shipping Agent Code" = 'STAMPS' THEN
            WarehouseShipmentHeader."Charges Pay By" := WarehouseShipmentHeader."Charges Pay By"::SENDER
        ELSE
            WarehouseShipmentHeader."Charges Pay By" := WarehouseRequest."Charges Pay By";
        //Handheld Fix END
        WarehouseShipmentHeader.VALIDATE("Shipping Account No.", WarehouseRequest."Shipping Account No.");
        //WarehouseShipmentHeader.VALIDATE("Third Party","Warehouse Request"."Third Party");
        WarehouseShipmentHeader."Third Party" := WarehouseRequest."Third Party";   //SPD MS 070815
        WarehouseShipmentHeader.VALIDATE("Third Party Account No.", WarehouseRequest."Third Party Account No.");
        WarehouseShipmentHeader.VALIDATE("Track On Header", TRUE); //Ashwini
        if UserSetup.get(UserId) then
            WarehouseShipmentHeader.VALIDATE("Assigned User ID", USERID)  //; //Ashwini
        else begin
            WarehouseEmployee.Reset();
            WarehouseEmployee.SetRange("Location Code", SalesHeader."Location Code");
            if WarehouseEmployee.FindFirst() then
                WarehouseShipmentHeader.VALIDATE("Assigned User ID", WarehouseEmployee."User ID");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Whse. Jnl.-Register Line", 'OnInitWhseEntryCopyFromWhseJnlLine', '', false, false)]
    local procedure OnInitWhseEntryCopyFromWhseJnlLine(var WarehouseEntry: Record "Warehouse Entry"; var WarehouseJournalLine: Record "Warehouse Journal Line"; OnMovement: Boolean; Sign: Integer; Location: Record Location; BinCode: Code[20]; var IsHandled: Boolean)
    var
        ToBinContent: Record "Bin Content";
        WhseJnlRegisterLine: Codeunit "Whse. Jnl.-Register Line";
    begin
        if Sign > 0 then begin
            if BinCode <> Location."Adjustment Bin Code" then begin
                if not ToBinContent.Get(
                        WarehouseJournalLine."Location Code", BinCode, WarehouseJournalLine."Item No.", WarehouseJournalLine."Variant Code", WarehouseJournalLine."Unit of Measure Code")
                then
                    InsertToBinContent(WarehouseEntry, Location)
                else
                    if Location."Default Bin Selection" = Location."Default Bin Selection"::"Last-Used Bin" then
                        WhseJnlRegisterLine.UpdateDefaultBinContent(WarehouseJournalLine."Item No.", WarehouseJournalLine."Variant Code", WarehouseJournalLine."Location Code", BinCode);
            end;
            IsHandled := true;
        end;
    end;

    local procedure InsertToBinContent(WhseEntry: Record "Warehouse Entry"; Location: Record Location)
    var
        BinContent: Record "Bin Content";
        WhseIntegrationMgt: Codeunit "Whse. Integration Management";
        bin: Record Bin;
    begin
        //with WhseEntry do begin
        //GetBinForBinContent(WhseEntry);
        Bin.Get(WhseEntry."Location Code", WhseEntry."Bin Code");
        BinContent.Init();
        BinContent."Location Code" := WhseEntry."Location Code";
        BinContent."Zone Code" := WhseEntry."Zone Code";
        BinContent."Bin Code" := WhseEntry."Bin Code";
        BinContent.Dedicated := Bin.Dedicated;
        BinContent."Bin Type Code" := Bin."Bin Type Code";
        BinContent."Block Movement" := Bin."Block Movement";
        BinContent."Bin Ranking" := Bin."Bin Ranking";
        BinContent."Cross-Dock Bin" := Bin."Cross-Dock Bin";
        BinContent."Warehouse Class Code" := Bin."Warehouse Class Code";
        BinContent."Item No." := WhseEntry."Item No.";
        BinContent."Variant Code" := WhseEntry."Variant Code";
        BinContent."Unit of Measure Code" := WhseEntry."Unit of Measure Code";
        BinContent."Qty. per Unit of Measure" := WhseEntry."Qty. per Unit of Measure";
        //BinContent.Fixed := WhseIntegrationMgt.IsOpenShopFloorBin(WhseEntry."Location Code", WhseEntry."Bin Code");
        if not Location."Directed Put-away and Pick" then begin
            CheckDefaultBin(WhseEntry, BinContent, Location);
            BinContent.Fixed := BinContent.Default;
        end;
        BinContent.Insert();
        //end;
    end;

    local procedure CheckDefaultBin(WhseEntry: Record "Warehouse Entry"; var BinContent: Record "Bin Content"; var Location: Record Location)
    var
        WMSMgt: Codeunit "WMS Management";
    begin
        //with WhseEntry do
        if WMSMgt.CheckDefaultBin(WhseEntry."Item No.", WhseEntry."Variant Code", WhseEntry."Location Code", WhseEntry."Bin Code") then begin
            if Location."Default Bin Selection" = Location."Default Bin Selection"::"Last-Used Bin" then begin
                DeleteDefaultBinContent(WhseEntry."Item No.", WhseEntry."Variant Code", WhseEntry."Location Code");
                BinContent.Default := true;
            end
        end else
            BinContent.Default := true;
    end;

    local procedure DeleteDefaultBinContent(ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10])
    var
        BinContent: Record "Bin Content";
    begin
        BinContent.SetCurrentKey(Default);
        BinContent.SetRange(Default, true);
        BinContent.SetRange("Location Code", LocationCode);
        BinContent.SetRange("Item No.", ItemNo);
        BinContent.SetRange("Variant Code", VariantCode);
        if BinContent.FindFirst() then begin
            BinContent.Default := false;
            BinContent.Modify();
        end;
    end;

    //OnBeforeInheritCompanyToPersonData
    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnBeforeInheritCompanyToPersonData', '', false, false)]
    local procedure OnBeforeInheritCompanyToPersonData(var Contact: Record Contact; var NewCompanyContact: Record Contact; xContact: Record Contact; var IsHandled: Boolean)
    var
        MyCont: Record Contact;
        ContBussRel: Record "Contact Business Relation";
    begin
        if NewCompanyContact."Customer No." <> '' then
            Contact."Customer No." := NewCompanyContact."Customer No."
        else begin
            ContBussRel.SetRange("Link to Table", ContBussRel."Link to Table"::Customer);
            ContBussRel.SetRange("Contact No.", NewCompanyContact."No.");
            if ContBussRel.FindFirst() then
                Contact."Customer No." := ContBussRel."No.";
        end;
    end;
}