codeunit 50206 FormatAddress_Ext
{
    var
        recCountry: Record "Country/Region";
        recCountry2: Record "Country/Region";
        FormatAddrCU: Codeunit "Format Address";

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Format Address", 'OnBeforeCustomer', '', false, false)]
    local procedure OnBeforeCustomer(var AddrArray: array[8] of Text[100]; var Cust: Record Customer; var Handled: Boolean)
    begin
        //  with Cust do begin
        //VK-SPDSPL-BEGIN
        IF Cust."Country/Region Code" <> ' ' THEN
            recCountry.GET(Cust."Country/Region Code");

        recCountry.GET(Cust."Country/Region Code");
        FormatAddrCU.FormatAddr(
          AddrArray, Cust.Name, Cust."Name 2", Cust.Contact, Cust.Address, Cust."Address 2",
          Cust.City, Cust."Post Code", Cust.County, recCountry.Name);
        // FormatAddrCU.CreateBarCode(
        //   DATABASE::Customer, GetPosition, 0,
        //   Cust."No.", Cust."Global Dimension 1 Code", Cust."Global Dimension 2 Code");
        //end;
        Handled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Format Address", 'OnBeforeVendor', '', false, false)]
    local procedure OnBeforeVendor(var AddrArray: array[8] of Text[100]; var Vendor: Record Vendor; var Handled: Boolean)
    begin
        IF Vendor."Country/Region Code" <> ' ' THEN
            recCountry2.GET(Vendor."Country/Region Code");
        FormatAddrCU.FormatAddr(
           AddrArray, Vendor.Name, Vendor."Name 2", Vendor.Contact, Vendor.Address, Vendor."Address 2",
           Vendor.City, Vendor."Post Code", Vendor.County, recCountry2.Name);
        //CreateBarCode(
        //DATABASE::Vendor, GetPosition, 0,
        //"No.", "Global Dimension 1 Code", "Global Dimension 2 Code");
        Handled := true;
    end;
}
