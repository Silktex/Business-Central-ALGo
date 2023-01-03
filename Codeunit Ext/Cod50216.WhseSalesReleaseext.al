codeunit 50216 "Whse.-Sales Release_ext"
{

    var
        recCustomer: Record Customer;
        recLoc: Record Location;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Whse.-Sales Release", 'OnBeforeCreateWhseRequest', '', false, false)]
    local procedure OnBeforeCreateWhseRequest(var WhseRqst: Record "Warehouse Request"; var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; WhseType: Option Inbound,Outbound)
    begin
        WhseRqst."Shipping Agent Service Code" := SalesHeader."Shipping Agent Service Code";
        WhseRqst."Third Party Account No." := SalesHeader."Third Party Account No.";
        WhseRqst."Third Party" := SalesHeader."Third Party";
        //WhseRqst."Charges Pay By":=
        IF recCustomer.GET(SalesHeader."Sell-to Customer No.") THEN
            //Handheld Fix BEGIN
            /*
            IF WhseRqst."Shipping Agent Code"='FEDEX' THEN
             WhseRqst."Shipping Account No.":=recCustomer."Shipping Account No."
            ELSE
            IF WhseRqst."Shipping Agent Code"='UPS' THEN
             WhseRqst."Shipping Account No.":=recCustomer."UPS Account No."
            ELSE
             WhseRqst."Shipping Account No.":=''
            ELSE
             WhseRqst."Shipping Account No.":='';
         IF WhseRqst."Shipping Account No."='' THEN
          WhseRqst."Charges Pay By":=WhseRqst."Charges Pay By"::SENDER
         ELSE
          WhseRqst."Charges Pay By":=WhseRqst."Charges Pay By"::RECEIVER;
           */
            IF recLoc.GET(WhseRqst."Location Code") THEN;
        WhseRqst."Charges Pay By" := SalesHeader."Charges Pay By";
        IF SalesHeader."Charges Pay By" = SalesHeader."Charges Pay By"::SENDER THEN BEGIN
            IF WhseRqst."Shipping Agent Code" = 'FEDEX' THEN
                WhseRqst."Shipping Account No." := recLoc."FedEx Account";
            IF WhseRqst."Shipping Agent Code" = 'UPS' THEN
                WhseRqst."Shipping Account No." := recLoc."UPS Account";
        END ELSE BEGIN
            IF SalesHeader."Charges Pay By" = SalesHeader."Charges Pay By" THEN BEGIN
                IF WhseRqst."Shipping Agent Code" = 'FEDEX' THEN
                    WhseRqst."Shipping Account No." := recCustomer."Shipping Account No.";
                IF WhseRqst."Shipping Agent Code" = 'UPS' THEN
                    WhseRqst."Shipping Account No." := recCustomer."UPS Account No.";
            END;
        END;
        //Handheld Fix END

    end;
}
