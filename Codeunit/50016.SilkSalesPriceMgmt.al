codeunit 50016 "Silk Sales Price Mgmt."
{

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterUpdateUnitPrice', '', false, false)]
    local procedure CustomSalesPriceCalcMgmt(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CalledByFieldNo: Integer; CurrFieldNo: Integer)
    var
        SalesRecSetup: Record "Sales & Receivables Setup";
        SalesPriceList: Record "Price List Line";
        UnitPrice: Decimal;
        PriceFound: Boolean;
    begin
        SalesRecSetup.Get();
        if not SalesRecSetup."Custom Price Mgmt. Enabled" then
            exit;

        PriceFound := false;
        if SalesLine.Type = SalesLine.Type::Item then begin
            SalesLine.CalcFields("Posting Date");

            //Priority 1
            SalesPriceList.Reset();
            SalesPriceList.SetRange("Source Type", SalesPriceList."Source Type"::Customer);
            SalesPriceList.SetRange("Source No.", SalesLine."Sell-to Customer No.");
            SalesPriceList.SetRange("Asset Type", SalesPriceList."Asset Type"::Item);
            SalesPriceList.SetRange("Asset No.", SalesLine."No.");
            SalesPriceList.SetFilter("Ending Date", '%1|>=%2', 0D, SalesLine."Posting Date");
            SalesPriceList.SetRange("Starting Date", 0D, SalesLine."Posting Date");
            if SalesPriceList.FindLast() then begin
                UnitPrice := SalesPriceList."Unit Price";
                PriceFound := true;
            end;

            //Priority 2
            if not PriceFound then begin
                SalesPriceList.Reset();
                SalesPriceList.SetRange("Source Type", SalesPriceList."Source Type"::Customer);
                SalesPriceList.SetRange("Source No.", SalesLine."Sell-to Customer No.");
                SalesPriceList.SetRange("Asset Type", SalesPriceList."Asset Type"::"Item Category");
                SalesPriceList.SetRange("Asset No.", SalesLine."Item Category Code");
                SalesPriceList.SetFilter("Ending Date", '%1|>=%2', 0D, SalesLine."Posting Date");
                SalesPriceList.SetRange("Starting Date", 0D, SalesLine."Posting Date");
                if SalesPriceList.FindLast() then begin
                    UnitPrice := SalesPriceList."Unit Price";
                    PriceFound := true;
                end;
            end;

            //Priority 3
            if not PriceFound then begin
                SalesPriceList.Reset();
                SalesPriceList.SetRange("Source Type", SalesPriceList."Source Type"::"Customer Price Group");
                SalesPriceList.SetRange("Source No.", SalesLine."Customer Price Group");
                SalesPriceList.SetRange("Asset Type", SalesPriceList."Asset Type"::Item);
                SalesPriceList.SetRange("Asset No.", SalesLine."No.");
                SalesPriceList.SetFilter("Ending Date", '%1|>=%2', 0D, SalesLine."Posting Date");
                SalesPriceList.SetRange("Starting Date", 0D, SalesLine."Posting Date");
                if SalesPriceList.FindLast() then begin
                    UnitPrice := SalesPriceList."Unit Price";
                    PriceFound := true;
                end;
            end;

            //Priority 4
            if not PriceFound then begin
                SalesPriceList.Reset();
                SalesPriceList.SetRange("Source Type", SalesPriceList."Source Type"::"Customer Price Group");
                SalesPriceList.SetRange("Source No.", SalesLine."Customer Price Group");
                SalesPriceList.SetRange("Asset Type", SalesPriceList."Asset Type"::"Item Category");
                SalesPriceList.SetRange("Asset No.", SalesLine."Item Category Code");
                SalesPriceList.SetFilter("Ending Date", '%1|>=%2', 0D, SalesLine."Posting Date");
                SalesPriceList.SetRange("Starting Date", 0D, SalesLine."Posting Date");
                if SalesPriceList.FindLast() then begin
                    UnitPrice := SalesPriceList."Unit Price";
                    PriceFound := true;
                end;
            end;

            //Priority 5
            if not PriceFound then begin
                SalesPriceList.Reset();
                SalesPriceList.SetRange("Source Type", SalesPriceList."Source Type"::"All Customers");
                SalesPriceList.SetRange("Source No.");
                SalesPriceList.SetRange("Asset Type", SalesPriceList."Asset Type"::Item);
                SalesPriceList.SetRange("Asset No.", SalesLine."No.");
                SalesPriceList.SetFilter("Ending Date", '%1|>=%2', 0D, SalesLine."Posting Date");
                SalesPriceList.SetRange("Starting Date", 0D, SalesLine."Posting Date");
                if SalesPriceList.FindLast() then begin
                    UnitPrice := SalesPriceList."Unit Price";
                    PriceFound := true;
                end;
            end;

            //Priority 6
            if not PriceFound then begin
                SalesPriceList.Reset();
                SalesPriceList.SetRange("Source Type", SalesPriceList."Source Type"::"All Customers");
                SalesPriceList.SetRange("Source No.");
                SalesPriceList.SetRange("Asset Type", SalesPriceList."Asset Type"::"Item Category");
                SalesPriceList.SetRange("Asset No.", SalesLine."Item Category Code");
                SalesPriceList.SetFilter("Ending Date", '%1|>=%2', 0D, SalesLine."Posting Date");
                SalesPriceList.SetRange("Starting Date", 0D, SalesLine."Posting Date");
                if SalesPriceList.FindLast() then begin
                    UnitPrice := SalesPriceList."Unit Price";
                    PriceFound := true;
                end;
            end;

            if PriceFound then
                SalesLine.Validate("Unit Price", UnitPrice);
        end;
    end;
}
