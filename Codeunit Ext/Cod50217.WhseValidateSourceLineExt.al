codeunit 50217 "Whse. Validate Source Line_Ext"
{
    var
        recSalesSetup: Record "Sales & Receivables Setup";
        recPurchSetup: Record "Purchases & Payables Setup";
        WhseValidateSourceLine: Codeunit "Whse. Validate Source Line";
        TableCaptionValue: Text[100];
        Text000: Label 'must not be changed when a %1 for this %2 exists: ';

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Validate Source Line", 'OnBeforeSalesLineVerifyChange', '', false, false)]
    local procedure OnBeforeSalesLineVerifyChange(var NewSalesLine: Record "Sales Line"; var OldSalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
        recSalesSetup.Get();
        if not WhseLinesExist(
             DATABASE::"Sales Line", NewSalesLine."Document Type".AsInteger(), NewSalesLine."Document No.", NewSalesLine."Line No.", 0,
             NewSalesLine.Quantity)
        then
            exit;

        IF (recSalesSetup."Allow Quantity Variance") AND (recSalesSetup."Define % for Variance") THEN
            IF NewSalesLine.Quantity > OldSalesLine.Quantity + (OldSalesLine.Quantity * OldSalesLine."Quantity Variance %" / 100) THEN
                NewSalesLine.FIELDERROR(
                  Quantity,
                  STRSUBSTNO(Text000,
                    TableCaptionValue,
                    NewSalesLine.TABLECAPTION));
    end;

    procedure WhseLinesExist(SourceType: Integer; SourceSubType: Option; SourceNo: Code[20]; SourceLineNo: Integer; SourceSublineNo: Integer; SourceQty: Decimal) Result: Boolean
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
        WhseShptLine: Record "Warehouse Shipment Line";
        WhseManagement: Codeunit "Whse. Management";
        IsHandled: Boolean;
        WhseActivLine: Record "Warehouse Activity Line";

    begin
        if ((SourceType = DATABASE::"Purchase Line") and (SourceSubType = 1) and (SourceQty >= 0)) or
           ((SourceType = DATABASE::"Purchase Line") and (SourceSubType = 5) and (SourceQty < 0)) or
           ((SourceType = DATABASE::"Sales Line") and (SourceSubType = 1) and (SourceQty < 0)) or
           ((SourceType = DATABASE::"Sales Line") and (SourceSubType = 5) and (SourceQty >= 0)) or
           ((SourceType = DATABASE::"Transfer Line") and (SourceSubType = 1))
        then begin
            WhseManagement.SetSourceFilterForWhseRcptLine(WhseRcptLine, SourceType, SourceSubType, SourceNo, SourceLineNo, true);
            if not WhseRcptLine.IsEmpty() then begin
                TableCaptionValue := WhseRcptLine.TableCaption;
                exit(true);
            end;
        end;

        if ((SourceType = DATABASE::"Purchase Line") and (SourceSubType = 1) and (SourceQty < 0)) or
           ((SourceType = DATABASE::"Purchase Line") and (SourceSubType = 5) and (SourceQty >= 0)) or
           ((SourceType = DATABASE::"Sales Line") and (SourceSubType = 1) and (SourceQty >= 0)) or
           ((SourceType = DATABASE::"Sales Line") and (SourceSubType = 5) and (SourceQty < 0)) or
           ((SourceType = DATABASE::"Transfer Line") and (SourceSubType = 0)) or
           ((SourceType = DATABASE::"Service Line") and (SourceSubType = 1))
        then begin
            WhseShptLine.SetSourceFilter(SourceType, SourceSubType, SourceNo, SourceLineNo, true);
            if not WhseShptLine.IsEmpty() then begin
                TableCaptionValue := WhseShptLine.TableCaption;
                exit(true);
            end;
        end;

        WhseActivLine.SetSourceFilter(SourceType, SourceSubType, SourceNo, SourceLineNo, SourceSublineNo, true);
        if not WhseActivLine.IsEmpty() then begin
            TableCaptionValue := WhseActivLine.TableCaption;
            exit(true);
        end;

        TableCaptionValue := '';
        exit(false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Validate Source Line", 'OnBeforeVerifyFieldNotChanged', '', false, false)]
    local procedure OnBeforeVerifyFieldNotChanged(NewRecRef: RecordRef; OldRecRef: RecordRef; FieldNumber: Integer; var IsHandled: Boolean)
    Var
        RecrodID: RecordId;
    begin
        RecrodID := NewRecRef.RecordId;
        NewRecRef.Get(RecrodID);
        IF RecrodID.TableNo = 37 then
            if FieldNumber = 15 then begin
                recSalesSetup.Get();
                if recSalesSetup."Allow Quantity Variance" then
                    IsHandled := true;
            end;

        IF RecrodID.TableNo = 39 then
            if FieldNumber = 15 then begin
                recPurchSetup.GET();
                IF recPurchSetup."Allow Quantity Variance" THEN
                    IsHandled := true;
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Validate Source Line", 'OnBeforePurchaseLineVerifyChange', '', false, false)]
    local procedure OnBeforePurchaseLineVerifyChange(var NewPurchLine: Record "Purchase Line"; var OldPurchLine: Record "Purchase Line"; var IsHandled: Boolean)
    begin
        if not WhseLinesExist(
                     DATABASE::"Purchase Line", NewPurchLine."Document Type".AsInteger(), NewPurchLine."Document No.",
                     NewPurchLine."Line No.", 0, NewPurchLine.Quantity)
                then
            exit;

        IF NewPurchLine.Quantity > OldPurchLine.Quantity + (OldPurchLine.Quantity * OldPurchLine."Quantity Variance %" / 100) THEN
            NewPurchLine.FIELDERROR(
             NewPurchLine.Quantity,
              STRSUBSTNO(Text000,
                TableCaptionValue,
               NewPurchLine.TABLECAPTION));
        //SPDSAUQV001 END Old
        //SPDSAUQV001 Begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnBeforeValidateTransferLineQtyToShip', '', false, false)]
    local procedure SLKOnBeforeValidateTransferLineQtyToShip(var TransferLine: Record "Transfer Line"; WarehouseShipmentLine: Record "Warehouse Shipment Line"; var IsHandled: Boolean)
    var
        UOMMgt: Codeunit "Unit of Measure Management";
    begin
        if WarehouseShipmentLine."Qty. to Ship" > TransferLine."Outstanding Quantity" then begin
            TransferLine.Quantity := UOMMgt.RoundAndValidateQty((WarehouseShipmentLine."Qty. to Ship" + TransferLine."Quantity Shipped"), TransferLine."Qty. Rounding Precision", TransferLine.FieldCaption(Quantity));
            TransferLine."Quantity (Base)" := UOMMgt.CalcBaseQty(TransferLine."Item No.", TransferLine."Variant Code", TransferLine."Unit of Measure Code", WarehouseShipmentLine."Qty. to Ship", TransferLine."Qty. per Unit of Measure", TransferLine."Qty. Rounding Precision (Base)", TransferLine.FieldCaption("Qty. Rounding Precision"), TransferLine.FieldCaption(Quantity), TransferLine.FieldCaption("Quantity (Base)"));
            TransferLine.InitQtyInTransit();
            TransferLine.InitOutstandingQty();
            TransferLine.InitQtyToShip();
            TransferLine.InitQtyToReceive();
        end;
    end;
}
