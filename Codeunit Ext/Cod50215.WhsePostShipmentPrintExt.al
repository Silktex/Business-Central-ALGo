codeunit 50215 "Whse.-Post Shipment Print_Ext"
{

    var
        WhseShptLine: Record "Warehouse Shipment Line";
        WhsePostShipment: Codeunit "Whse.-Post Shipment";
        Selection: Integer;
        ShipInvoiceQst: Label '&Ship,Ship &and Invoice';
        Text001: Label '&Ship';

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Whse.-Post Shipment + Print", 'OnBeforeCode', '', false, false)]
    local procedure OnBeforeCode(var WhseShptLine: Record "Warehouse Shipment Line"; var HideDialog: Boolean; var Invoice: Boolean; var IsPosted: Boolean; var Selection: Integer)
    begin
        // with WhseShptLine do begin
        if WhseShptLine.Find then
            if not HideDialog then begin
                Selection := StrMenu(Text001, 1);
                if Selection = 0 then
                    exit;
                Invoice := (Selection = 2);
            end;


        WhsePostShipment.SetPostingSettings(Invoice);
        WhsePostShipment.SetPrint(true);
        WhsePostShipment.Run(WhseShptLine);
        WhsePostShipment.GetResultMessage;
        Clear(WhsePostShipment);

        IsPosted := true;
    end;
}
