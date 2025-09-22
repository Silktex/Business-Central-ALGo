codeunit 50204 "Sales-Quote to Order_Ext"
{
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Quote to Order", 'OnBeforeModifySalesOrderHeader', '', false, false)]
    local procedure OnBeforeModifySalesOrderHeader(var SalesOrderHeader: Record "Sales Header"; SalesQuoteHeader: Record "Sales Header")
    begin
        SalesOrderHeader."External Document No." := SalesQuoteHeader."External Document No."; //SPD MS 040815
        SalesOrderHeader."Expiry Date" := SalesQuoteHeader."Expiry Date"; //SPD MS 050815
    end;
}
