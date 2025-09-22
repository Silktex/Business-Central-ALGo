report 50030 "Reorder Report New"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50030_Report_ReorderReportNew.rdlc';
    Caption = 'Reorder Report';
    Description = 'Reorder Report';
    EnableHyperlinks = true;

    dataset
    {
        dataitem(Item; Item)
        {
            column(ReOrder_Tab; Item."ReOrder Tab")
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            { }
            column(Warp_Color; Item."Warp Color")
            {
            }
            column(No_Item; "No.")
            {
            }
            column(Description_Item; Description + StrText)
            {
            }
            column(Customer_Item; Customer)
            {
            }
            column(New_Customer_Item; txtSaveData)
            {
            }
            column(ProductGroupCode_Item; "item category code")
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
            column(TRANSITQTY; TRANSITQTY)
            {
            }
            column(QuantityShip; decShipQty)
            {
            }
            column(QuantityAir; decAirQty)
            {
            }
            column(ACFQTY; ACFQTY)
            {
            }
            column(ShortPcs; ShortPcs)
            {
            }
            column(Inventory_Item; SYOSSETQTY + GASTONIAQTY + ACFQTY + SAMPLINGQTY)
            {
            }
            column(QtyonPurchOrder_Item; "Qty. on Purch. Order")
            {
            }
            column(QtyonSalesOrder_Item; SalesOrderQty)
            {
            }
            column(AvailQty; SYOSSETQTY + SAMPLINGQTY + GASTONIAQTY + ACFQTY - SalesOrderQty)
            {
            }
            column(ActualQty; SYOSSETQTY + SAMPLINGQTY + GASTONIAQTY + ACFQTY + "Qty. on Purch. Order" + TRANSITQTY - SalesOrderQty)
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
            column(ActualRequirement; (SYOSSETQTY + SAMPLINGQTY + GASTONIAQTY + ACFQTY + TRANSITQTY - SalesOrderQty + "Qty. on Purch. Order") - (SalesOrderQty + (-1 * (MonthSales0To6)) + MasMonthSales0To6))
            {
            }
            column(SAMPLINGQTY; SAMPLINGQTY)
            {
            }
            column(Priority; Priority)
            {
            }
            column(Comments; Comments)
            {
            }
            column(DReadyGoodsQty; DReadyGoodsQty)
            {
            }
            column(DShippedAir; DShippedAir)
            {
            }
            column(DShippedBoat; DShippedBoat)
            {
            }
            column(DBalanceQty; DBalanceQty)
            {
            }
            column(DShippingHold; DShippingHold)
            {
            }
            column(DPriorityQty; DPriorityQty)
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
                DReadyGoodsQty := 0;
                DShippedAir := 0;
                DShippedBoat := 0;
                DBalanceQty := 0;
                DShippingHold := 0;
                DPriorityQty := 0;
                //ProdLine := '';

                //recProductGroup.RESET;
                //recProductGroup.SETRANGE(recProductGroup.Code,"Product Group Code");
                //IF recProductGroup.FINDFIRST THEN
                //ProdLine := recProductGroup.Description;

                DReadyGoodsQty := ReadyGoodsQty("No.");
                DShippedAir := ShippedAir("No.");
                DShippedBoat := ShippedBoat("No.");
                DBalanceQty := BalanceQty("No.");
                DShippingHold := ShippingHold("No.");
                DPriorityQty := PriorityQty("No.");



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
                //TRANSITQTY:=0;
                ACFQTY := 0;
                ILE1.RESET;
                ILE1.SETCURRENTKEY("Item No.", "Entry Type");
                ILE1.SETRANGE(ILE1."Item No.", "No.");
                ILE1.SETFILTER(ILE1."Remaining Quantity", '>%1', 0);
                IF ILE1.FINDFIRST THEN
                    REPEAT
                        //    IF NOT (ILE1."Quality Grade" IN [ILE1."Quality Grade"::B,ILE1."Quality Grade"::C,ILE1."Quality Grade"::D]) THEN BEGIN //sushant
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
                                            SAMPLINGQTY += ILE1."Remaining Quantity"

                                        ELSE
                                            ACFQTY += ILE1."Remaining Quantity";

                        END ELSE
                            IF ILE1."Location Code" <> 'DAMAGED SY' THEN
                                ShortPcs += ILE1."Remaining Quantity";


                    //END;  sushant comment this
                    UNTIL ILE1.NEXT = 0;

                TRANSITQTY := 0;
                ILE.RESET;
                ILE.SETRANGE("Item No.", "No.");
                ILE.SETFILTER(ILE."Remaining Quantity", '>%1', 0);
                ILE.SETFILTER(ILE."Location Code", '%1|%2', 'TRANSIT', 'TRANSIT2');
                IF ILE.FIND('-') THEN
                    REPEAT
                        TRANSITQTY += ILE."Remaining Quantity";
                    UNTIL ILE.NEXT = 0;

                ACFQTY := ACFQTY - TRANSITQTY;

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
                decShipQty := 0;
                decAirQty := 0;

                recTransferLine.RESET;
                recTransferLine.SETRANGE("Document No.", "No.");
                recTransferLine.SETRANGE("Item No.", "No.");
                IF recTransferLine.FIND('-') THEN BEGIN
                    REPEAT
                        recTransferHeader.GET(recTransferLine."Document No.");
                        IF recTransferHeader."Ship Via" = 'SHIP' THEN
                            decShipQty += recTransferLine.Quantity - recTransferLine."Quantity Received"
                        ELSE
                            IF recTransferHeader."Ship Via" = 'AIR' THEN
                                decAirQty += recTransferLine.Quantity - recTransferLine."Quantity Received"
                    UNTIL recTransferLine.NEXT = 0;
                END;

                //RCY14 BEGIN
                txtSaveData := '';
                ItemCustomerReOrder.RESET;
                ItemCustomerReOrder.SETRANGE("Item No.", "No.");
                IF ItemCustomerReOrder.FINDFIRST THEN
                    REPEAT
                        IF txtSaveData = '' THEN
                            txtSaveData := ItemCustomerReOrder."Customer Name 2"
                        ELSE
                            txtSaveData := txtSaveData + ',' + ItemCustomerReOrder."Customer Name 2";
                    UNTIL ItemCustomerReOrder.NEXT = 0;
                //RCY14 END

                StrText := '';
                recSalesLine.RESET;
                recSalesLine.SETRANGE(recSalesLine."No.", Item."No.");
                recSalesLine.SETFILTER(recSalesLine.Comments, '<>%1', '');
                IF recSalesLine.FINDFIRST THEN
                    StrText := '  ~'//' ***';
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
        ItemNoCap = 'SKU';
        ItemDescCap = 'Item';
        ItemProdLineCap = 'PL';
        ItemVendorCap = 'Vend';
        ItemCustomerCap = 'Cust';
        ItemQtyOnHandCap = 'OH';
        ItemQtyOnPOCap = 'PO';
        ItemQtyOnSOCap = 'SO';
        ItemAvailQtyCap = 'Avail';
        ItemActualQtyCap = 'Actual';
        Sales0To6MonthsCap = '0 To 6';
        Sales7To12MonthsCap = '7 To 12';
        Sales13To24MonthsCap = '13 To 24';
        ItemT6MonthSaleCap = 'T 6M';
        ItemActualReqCap = 'Actual Req';
        ItemTotalOrderCap = 'Total Order';
        LocationDAMAGEDSYCap = 'DAMAGED SY';
        LocationGASTONIACap = 'GASTONIA';
        LocationSYOSSETCap = 'SYOSSET';
        ShortPCSCap = 'Short PCS';
        GoodsinTransitSeaCap = 'Trans Sea';
        GoodsinTransitAirCap = 'Trans Air';
        ShortPiece = 'Short';
        LocationTransitCap = 'Transit';
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
        ACFQTY: Decimal;
        TRANSITQTY: Decimal;
        recTransferHeader: Record "Transfer Header";
        recTransferLine: Record "Transfer Line";
        decShipQty: Decimal;
        decAirQty: Decimal;
        Priority: Text[10];
        Comments: Text[50];
        DReadyGoodsQty: Decimal;
        DShippedAir: Decimal;
        DShippedBoat: Decimal;
        DBalanceQty: Decimal;
        DShippingHold: Decimal;
        DPriorityQty: Decimal;
        y: Integer;
        StrText: Text[5];
        ItemCustomerReOrder: Record "Item Customer Re-Order";
        txtSaveData: Text;


    procedure ReadyGoodsQty(ItemNo: Code[20]): Decimal
    var
        RecPurchline: Record "Purchase Line";
        DecReadyGoodQty: Decimal;
    begin
        DecReadyGoodQty := 0;
        RecPurchline.RESET;
        RecPurchline.SETRANGE(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
        RecPurchline.SETRANGE(RecPurchline."No.", ItemNo);
        RecPurchline.SETFILTER(RecPurchline."Ready Goods Qty", '<>%1', 0);
        IF RecPurchline.FINDFIRST THEN
            REPEAT
                DecReadyGoodQty := DecReadyGoodQty + RecPurchline."Ready Goods Qty";
            UNTIL RecPurchline.NEXT = 0;
        EXIT(DecReadyGoodQty);
    end;


    procedure ShippedAir(ItemNo: Code[20]): Decimal
    var
        RecPurchline: Record "Purchase Line";
        DecShippedAirQty: Decimal;
    begin
        DecShippedAirQty := 0;
        RecPurchline.RESET;
        RecPurchline.SETRANGE(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
        RecPurchline.SETRANGE(RecPurchline."No.", ItemNo);
        RecPurchline.SETFILTER(RecPurchline."Shipped Air", '<>%1', 0);
        IF RecPurchline.FINDFIRST THEN
            REPEAT
                DecShippedAirQty := DecShippedAirQty + RecPurchline."Shipped Air";
            UNTIL RecPurchline.NEXT = 0;
        EXIT(DecShippedAirQty);
    end;


    procedure ShippedBoat(ItemNo: Code[20]): Decimal
    var
        RecPurchline: Record "Purchase Line";
        DecShippedBoatQty: Decimal;
    begin
        DecShippedBoatQty := 0;
        RecPurchline.RESET;
        RecPurchline.SETRANGE(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
        RecPurchline.SETRANGE(RecPurchline."No.", ItemNo);
        RecPurchline.SETFILTER(RecPurchline."Shipped Boat", '<>%1', 0);
        IF RecPurchline.FINDFIRST THEN
            REPEAT
                DecShippedBoatQty := DecShippedBoatQty + RecPurchline."Shipped Boat";
            UNTIL RecPurchline.NEXT = 0;
        EXIT(DecShippedBoatQty);
    end;


    procedure BalanceQty(ItemNo: Code[20]): Decimal
    var
        RecPurchline: Record "Purchase Line";
        DecBalanceQty: Decimal;
    begin
        DecBalanceQty := 0;
        RecPurchline.RESET;
        RecPurchline.SETRANGE(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
        RecPurchline.SETRANGE(RecPurchline."No.", ItemNo);
        RecPurchline.SETFILTER(RecPurchline."Balance Qty", '<>%1', 0);
        IF RecPurchline.FINDFIRST THEN
            REPEAT
                DecBalanceQty := DecBalanceQty + RecPurchline."Balance Qty";
            UNTIL RecPurchline.NEXT = 0;
        EXIT(DecBalanceQty);
    end;


    procedure ShippingHold(ItemNo: Code[20]): Decimal
    var
        RecPurchline: Record "Purchase Line";
        DecShippingHoldQty: Decimal;
    begin
        DecShippingHoldQty := 0;
        RecPurchline.RESET;
        RecPurchline.SETRANGE(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
        RecPurchline.SETRANGE(RecPurchline."No.", ItemNo);
        RecPurchline.SETFILTER(RecPurchline."Shipping Hold", '<>%1', 0);
        IF RecPurchline.FINDFIRST THEN
            REPEAT
                DecShippingHoldQty := DecShippingHoldQty + RecPurchline."Shipping Hold";
            UNTIL RecPurchline.NEXT = 0;
        EXIT(DecShippingHoldQty);
    end;


    procedure PriorityQty(ItemNo: Code[20]): Decimal
    var
        RecPurchline: Record "Purchase Line";
        DecPriorityQty: Decimal;
    begin
        DecPriorityQty := 0;
        RecPurchline.RESET;
        RecPurchline.SETRANGE(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
        RecPurchline.SETRANGE(RecPurchline."No.", ItemNo);
        RecPurchline.SETFILTER(RecPurchline."Priority Qty", '<>%1', 0);
        IF RecPurchline.FINDFIRST THEN
            REPEAT
                DecPriorityQty := DecPriorityQty + RecPurchline."Priority Qty";
            UNTIL RecPurchline.NEXT = 0;
        EXIT(DecPriorityQty);
    end;
}

