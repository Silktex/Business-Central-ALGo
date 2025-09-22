report 50631 "Reorder Report New 1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50631_Report_ReorderReportNew1.rdlc';
    Caption = 'Reorder Report';
    Description = 'Reorder Report';

    dataset
    {
        dataitem(Item; Item)
        {
            column(No_Item; "No.")
            {
            }
            column(Description_Item; Description)
            {
            }
            column(Customer_Item; Customer)
            {
            }
            column(ProductGroupCode_Item; "Item Category Code")
            {
            }
            column(ProdLine; "Product Line")
            {
            }
            column(SYOSSETQTY; SYOSSETQTY)
            {
            }
            column(DAMAGEDSYQTY; DAMAGEDSYQTY)
            {
            }
            column(GASTONIAQTY; GASTONIAQTY)
            {
            }
            column(ShortPcs; ShortPcs)
            {
            }
            column(Inventory_Item; SYOSSETQTY + GASTONIAQTY)
            {
            }
            column(QtyonPurchOrder_Item; "Qty. on Purch. Order")
            {
            }
            column(QtyonSalesOrder_Item; SalesOrderQty)
            {
            }
            column(AvailQty; SYOSSETQTY + GASTONIAQTY - SalesOrderQty)
            {
            }
            column(ActualQty; SYOSSETQTY + GASTONIAQTY - SalesOrderQty + "Qty. on Purch. Order")
            {
            }
            column(VendorName; VendorName)
            {
            }
            column(MonthSale13to24; (-1 * (MonthSale13to24)) + MasMonthSale13to24)
            {
            }
            column(MonthSales7To12; (-1 * (MonthSales7To12)) + MasMonthSales7To12)
            {
            }
            column(MonthSales0To6; (-1 * (MonthSales0To6)) + MasMonthSales0To6)
            {
            }
            column(T6MonthSale; SalesOrderQty + (-1 * (MonthSales0To6)) + MasMonthSales0To6)
            {
            }
            column(ActualRequirement; (SYOSSETQTY + GASTONIAQTY - SalesOrderQty + "Qty. on Purch. Order") - (SalesOrderQty + (-1 * (MonthSales0To6)) + MasMonthSales0To6))
            {
            }
            column(SAMPLINGQTY; SAMPLINGQTY)
            {
            }
            column(Drop; Item.Drop)
            {
            }

            trigger OnAfterGetRecord()
            begin
                MonthSale13to24 := 0;
                MonthSales7To12 := 0;
                MonthSales0To6 := 0;
                MasMonthSale13to24 := 0;
                MasMonthSales7To12 := 0;
                MasMonthSales0To6 := 0;
                VendorName := '';
                SalesOrderQty := 0;
                //ProdLine := '';

                //recProductGroup.RESET;
                //recProductGroup.SETRANGE(recProductGroup.Code,"Product Group Code");
                //IF recProductGroup.FINDFIRST THEN
                //ProdLine := recProductGroup.Description;

                IF recVendor.GET("Vendor No.") THEN
                    VendorName := recVendor."Name 2";

                recSalesLine.RESET;
                recSalesLine.SETCURRENTKEY("Document Type", Type, "No.");
                recSalesLine.SETRANGE(recSalesLine."Document Type", recSalesLine."Document Type"::Order);
                recSalesLine.SETRANGE(recSalesLine.Type, recSalesLine.Type::Item);
                recSalesLine.SETRANGE(recSalesLine."No.", "No.");
                recSalesLine.SETFILTER(recSalesLine."Location Code", '<>%1', 'DAMAGED SY');
                IF recSalesLine.FINDFIRST THEN
                    REPEAT
                        SalesOrderQty += recSalesLine."Outstanding Qty. (Base)";
                    UNTIL recSalesLine.NEXT = 0;




                ILE.RESET;
                ILE.SETCURRENTKEY("Item No.", "Entry Type");
                ILE.SETRANGE(ILE."Item No.", "No.");
                ILE.SETRANGE(ILE."Entry Type", ILE."Entry Type"::Sale);
                ILE.SETFILTER(ILE."Location Code", '<>%1', 'DAMAGED SY');
                IF ILE.FINDFIRST THEN
                    REPEAT
                        IF ILE."Posting Date" >= CALCDATE('<-6M>', WORKDATE) THEN
                            MonthSales0To6 += ILE.Quantity
                        ELSE
                            IF ((ILE."Posting Date" >= CALCDATE('<-1Y>', WORKDATE)) AND (ILE."Posting Date" < CALCDATE('<-6M+1D>', WORKDATE))) THEN
                                MonthSales7To12 += ILE.Quantity
                            ELSE
                                IF ((ILE."Posting Date" >= CALCDATE('<-2Y>', WORKDATE)) AND (ILE."Posting Date" < CALCDATE('<-1Y+1D>', WORKDATE))) THEN
                                    MonthSale13to24 += ILE.Quantity;
                    UNTIL ILE.NEXT = 0;

                SYOSSETQTY := 0;
                GASTONIAQTY := 0;
                DAMAGEDSYQTY := 0;
                ShortPcs := 0;
                SAMPLINGQTY := 0;
                ILE1.RESET;
                ILE1.SETCURRENTKEY("Item No.", "Entry Type");
                ILE1.SETRANGE(ILE1."Item No.", "No.");
                ILE1.SETFILTER(ILE1."Remaining Quantity", '>%1', 0);
                IF ILE1.FINDFIRST THEN
                    REPEAT
                        IF NOT (ILE1."Quality Grade" IN [ILE1."Quality Grade"::B, ILE1."Quality Grade"::C, ILE1."Quality Grade"::D]) THEN BEGIN
                            IF ILE1."Remaining Quantity" >= "Short Piece" THEN BEGIN
                                IF ILE1."Location Code" = 'SYOSSET' THEN
                                    SYOSSETQTY += ILE1."Remaining Quantity"
                                ELSE
                                    IF ILE1."Location Code" = 'GASTONIA' THEN
                                        GASTONIAQTY += ILE1."Remaining Quantity"
                                    ELSE
                                        IF ILE1."Location Code" = 'DAMAGED SY' THEN
                                            DAMAGEDSYQTY += ILE1."Remaining Quantity"
                                        ELSE
                                            IF ILE1."Location Code" = 'SAMPLING' THEN
                                                SAMPLINGQTY += ILE1."Remaining Quantity";
                            END ELSE
                                IF ILE1."Location Code" <> 'DAMAGED SY' THEN
                                    ShortPcs += ILE1."Remaining Quantity";
                        END;
                    UNTIL ILE1.NEXT = 0;

                // Mas2YrSales.RESET;
                // Mas2YrSales.SETRANGE(Mas2YrSales."Item No.", "No.");
                // IF Mas2YrSales.FINDFIRST THEN
                //     REPEAT
                //         IF Mas2YrSales."Posting Date" >= CALCDATE('<-6M>', WORKDATE) THEN
                //             MasMonthSales0To6 += Mas2YrSales.Quantity
                //         ELSE
                //             IF ((Mas2YrSales."Posting Date" >= CALCDATE('<-1Y>', WORKDATE)) AND (Mas2YrSales."Posting Date" < CALCDATE('<-6M+1D>', WORKDATE))) THEN
                //                 MasMonthSales7To12 += Mas2YrSales.Quantity
                //             ELSE
                //                 IF ((Mas2YrSales."Posting Date" >= CALCDATE('<-2Y>', WORKDATE)) AND (Mas2YrSales."Posting Date" < CALCDATE('<-1Y+1D>', WORKDATE))) THEN
                //                     MasMonthSale13to24 += Mas2YrSales.Quantity;
                //     UNTIL Mas2YrSales.NEXT = 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        ItemNoCap = 'Item Number';
        ItemDescCap = 'Item Description';
        ItemProdLineCap = 'Product Line';
        ItemVendorCap = 'Vendor';
        ItemCustomerCap = 'Customer';
        ItemQtyOnHandCap = 'Quantity On Hand';
        ItemQtyOnPOCap = 'Quantity On PO';
        ItemQtyOnSOCap = 'Quantity On SO';
        ItemAvailQtyCap = 'Avail Quantity';
        ItemActualQtyCap = 'Actual Quantity';
        Sales0To6MonthsCap = 'Sales 0 To 6 Months';
        Sales7To12MonthsCap = 'Sales 7 To 12 Months';
        Sales13To24MonthsCap = 'Sales 13 To 24 Months';
        ItemT6MonthSaleCap = 'T 6M Sales';
        ItemActualReqCap = 'Actual Requirement';
        ItemTotalOrderCap = 'Total Order';
        LocationDAMAGEDSYCap = 'DAMAGED SY';
        LocationGASTONIACap = 'GASTONIA';
        LocationSYOSSETCap = 'SYOSSET';
        ShortPCSCap = 'Short PCS';
        GoodsinTransitSeaCap = 'Goods in Transit Sea';
        GoodsinTransitAirCap = 'Goods in Transit Air';
        ShortPiece = 'Short Piece';
    }

    var
        recProductGroup: Record "Item Category";
        ILE: Record "Item Ledger Entry";
        ILE1: Record "Item Ledger Entry";
        //Mas2YrSales: Record "MAS 2yr sales";
        recSalesLine: Record "Sales Line";
        ProdLine: Text[100];
        recVendor: Record Vendor;
        VendorName: Text[100];
        MonthSale13to24: Decimal;
        MonthSales7To12: Decimal;
        MonthSales0To6: Decimal;
        SYOSSETQTY: Decimal;
        DAMAGEDSYQTY: Decimal;
        GASTONIAQTY: Decimal;
        ShortPcs: Decimal;
        MasMonthSale13to24: Decimal;
        MasMonthSales7To12: Decimal;
        MasMonthSales0To6: Decimal;
        SalesOrderQty: Decimal;
        SAMPLINGQTY: Decimal;
}

