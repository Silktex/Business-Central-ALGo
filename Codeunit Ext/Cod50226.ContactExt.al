codeunit 50226 ContactExt
{
    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnBeforeUpdateCompanyNo', '', false, false)]
    local procedure ContactOnBeforeUpdateCompanyNo(var Contact: Record Contact; xContact: Record Contact)
    var
        ContBusRel: Record "Contact Business Relation";
    begin
        if xContact."Company No." <> Contact."Company No." then
            if Contact."Company No." <> '' then begin
                ContBusRel.Reset();
                ContBusRel.SetCurrentKey("Link to Table", "Contact No.");
                ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
                ContBusRel.SetRange("Contact No.", Contact."Company No.");
                if ContBusRel.FindFirst() then
                    if Contact."Customer No." <> ContBusRel."No." then
                        Contact."Customer No." := ContBusRel."No.";
            end;
    end;
}
