codeunit 50214 "Whse-Post ShipmentYes/No_Ext"
{
    TableNo = "Warehouse Shipment Line";


    var
        WhseShptLine: Record "Warehouse Shipment Line";
        WhsePostShipment: Codeunit "Whse.-Post Shipment";
        Selection: Integer;
        ShipInvoiceQst: Label '&Ship,Ship &and Invoice';
        Text001: Label '&Ship';

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment (Yes/No)", 'OnBeforeConfirmWhseShipmentPost', '', false, false)]
    local procedure OnBeforeConfirmWhseShipmentPost(var WhseShptLine: Record "Warehouse Shipment Line"; var HideDialog: Boolean; var Invoice: Boolean; var IsPosted: Boolean)
    begin
        IsPosted := true;
        // with WhseShptLine do begin
        if WhseShptLine.Find then
            if not HideDialog then begin
                Selection := StrMenu(Text001, 1);
                if Selection = 0 then
                    exit;
                Invoice := (Selection = 2);
            end;

        WhsePostShipment.SetPostingSettings(Invoice);
        WhsePostShipment.SetPrint(false);
        WhsePostShipment.Run(WhseShptLine);
        WhsePostShipment.GetResultMessage;
        Clear(WhsePostShipment);
        //end;
        IsPosted := true;
    end;

}
