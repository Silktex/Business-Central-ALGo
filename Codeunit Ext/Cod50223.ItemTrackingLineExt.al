codeunit 50223 ItemTrackingLine_Ext
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Act.-Register (Yes/No)", 'OnBeforeRegisterRun', '', false, false)]
    local procedure OnBeforeRegisterRun(var WarehouseActivityLine: Record "Warehouse Activity Line"; var IsHandled: Boolean)
    var
        WhseActivityRegister: Codeunit WhseActivityRegisterNew;
    begin
        WhseActivityRegister.Run(WarehouseActivityLine);
        IsHandled := true;
    end;

}
