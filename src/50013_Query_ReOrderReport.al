query 50013 ReportReport
{
    Caption = 'ReOrder Report';
    QueryType = Normal;

    elements
    {
        dataitem(Item; Item)
        {
            column(No_Item; "No.") { }
            column(Item_Category_Code; "Item Category Code") { }
            column(Vendor_No; "Vendor No.") { }

            column(Description_Item; Description) { }
            column(Customer_Item; Customer) { }
            column(ProductGroupCode_Item; "Item Category Code") { }
            //column(ProdGroupDescription; ProdGroupDescription) { }
            column(Inventory_Item; Inventory) { }
            column(QtyonPurchOrder_Item; "Qty. on Purch. Order") { }
            column(QtyonSalesOrder_Item; "Qty. on Sales Order") { }
            //column(AvailQty; (Inventory - "Qty. on Sales Order")){ }
            //column(ActualQty; (Inventory + "Qty. on Sales Order" + "Qty. on Purch. Order")){ }
            //column(VendorName; VendorName) { }
            //column(MonthSales12; ABS(MonthSales12)){ }
            //column(MonthSales6; ABS(MonthSales6)){ }
            //column(T6MonthSale; "Qty. on Sales Order" + ABS(MonthSales6)){ }
            //column(ActualRequirement; (Inventory + "Qty. on Sales Order" + "Qty. on Purch. Order") - ("Qty. on Sales Order" + ABS(MonthSales6))){ }
            //column(DROP; Item.Drop){ }


            // trigger OnPreDataItem()
            // begin
            //     MDate12 := CALCDATE('<-1Y>', WORKDATE);
            //     MDate6 := CALCDATE('<-6M>', WORKDATE);
            // end;

        }

    }

    trigger OnBeforeOpen()
    begin
        MonthSales12 := 0;
        MonthSales6 := 0;
        VendorName := '';
        ProdGroupDescription := '';

        MDate12 := CALCDATE('<-1Y>', WORKDATE);
        MDate6 := CALCDATE('<-6M>', WORKDATE);

        recProductGroup.RESET;
        recProductGroup.SETRANGE(recProductGroup.Code, Item_Category_Code);
        IF recProductGroup.FINDFIRST THEN
            ProdGroupDescription := recProductGroup.Description;

        IF recVendor.GET(Vendor_No) THEN
            VendorName := recVendor.Name;
        ILE.RESET;
        ILE.SETRANGE(ILE."Item No.", No_Item);
        ILE.SETRANGE(ILE."Entry Type", ILE."Entry Type"::Sale);
        IF ILE.FINDFIRST THEN
            REPEAT
                IF ILE."Posting Date" >= MDate12 THEN
                    MonthSales12 += ILE.Quantity;

                IF ILE."Posting Date" >= MDate6 THEN
                    MonthSales6 += ILE.Quantity;
            UNTIL ILE.NEXT = 0;
    end;

    var
        recProductGroup: Record "Item Category";
        ILE: Record "Item Ledger Entry";
        ProdGroupDescription: Text[100];
        recVendor: Record Vendor;
        VendorName: Text[100];
        MonthSales12: Decimal;
        MonthSales6: Decimal;
        MDate12: Date;
        MDate6: Date;
}