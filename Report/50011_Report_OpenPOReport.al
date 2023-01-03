report 50011 "Open PO Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50011_Report_OpenPOReport.rdlc';
    EnableHyperlinks = true;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") ORDER(Ascending) WHERE("Document Type" = FILTER(Order));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Purchase Order';
            column(BuyfromVendorNo_PurchaseHeader; "Purchase Header"."Buy-from Vendor No.")
            {
            }
            column(No_PurchaseHeader; "Purchase Header"."No.")
            {
            }
            column(VendorOrderNo_PurchaseHeader; "Purchase Header"."Vendor Order No.")
            {
            }
            column(BuyfromVendorName_PurchaseHeader; "Purchase Header"."Buy-from Vendor Name")
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                dataitemtableview = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE(Type = FILTER(Item), Quantity = FILTER(<> 0), "Outstanding Quantity" = FILTER(<> 0), "Document No." = FILTER(<> 'P02277'));
                RequestFilterFields = "Order Date", "Pay-to Vendor No.";
                column(LineNo_PurchaseLine; "Purchase Line"."Line No.")
                {
                }
                column(DueDate_PurchaseHeader; "Purchase Line"."Requested Receipt Date")
                {
                }
                column(OrderDate_PurchaseHeader; "Purchase Header"."Order Date")
                {
                }
                column(DocumentNo_PurchaseLine; "Purchase Line"."Document No.")
                {
                }
                column(No_PurchaseLine; "Purchase Line"."No.")
                {
                }
                column(Description_PurchaseLine; "Purchase Line".Description + StrText)
                {
                }
                column(UnitofMeasureCode_PurchaseLine; "Purchase Line"."Unit of Measure Code")
                {
                }
                column(QtyRcdNotInvoiced_PurchaseLine; "Purchase Line"."Qty. Rcd. Not Invoiced")
                {
                }
                column(Quantity_PurchaseLine; POQuantity)
                {
                }
                column(QuantityReceived_PurchaseLine; POQuantityRec)
                {
                }
                column(OutstandingQuantity_PurchaseLine; POQuantityBkOrder)
                {
                }
                column(QtyOnHand; SYOSSETQTY + GASTONIAQTY + ACFQTY)
                {
                }
                column(SOQty; SOQty)
                {
                }
                column(ItemDesc; ItemDesc + StrText)
                {
                }
                column(TRANSIT; TRANSITQTY)
                {
                }
                column(ReadyGoodsQty; "Ready Goods Qty")
                {
                }
                column(ETD; FORMAT("Purchase Line"."Expected Receipt Date"))
                {
                }
                column(ShippedAir; DecShippedAir)
                {
                }
                column(ShippedBoat; DecShippedBoat)
                {
                }
                column(RGL_Update_Date; FORMAT("Purchase Line"."Last Change"))
                {
                }
                column(ReadyGoodsComment; "Purchase Line"."Ready Goods Comment")
                {
                }
                column(NegativeQty; (TRANSITQTY + SYOSSETQTY + SAMPLINGQTY + GASTONIAQTY + ACFQTY) - SalesOrderQty)
                {
                }
                column(ThreeM_REQ_Qty; (SYOSSETQTY + SAMPLINGQTY + GASTONIAQTY + ACFQTY + TRANSITQTY + ItemQtyOnPO("Purchase Line") - (SalesOrderQty) - (SalesOrderQty + ((-1 * (MonthSales0To6)) + MasMonthSales0To6))) / 2)
                {
                }
                column(PromisedReceiptDate_PurchaseLine; FORMAT("Promised Receipt Date"))
                {
                }
                column(PriorityQty_PurchaseLine; "Priority Qty")
                {
                }
                column(PriorityDate_PurchaseLine; FORMAT("Priority Date"))
                {
                }
                column(ThreeM_REQ_Qty1; (((SYOSSETQTY + SAMPLINGQTY + GASTONIAQTY + ACFQTY + TRANSITQTY + ItemQtyOnPO("Purchase Line") - SalesOrderQty) - (SalesOrderQty + ((-1 * (MonthSales0To6)) + MasMonthSales0To6))) / 2))
                {
                }
                column(TotalAvailQty; (SYOSSETQTY + SAMPLINGQTY + GASTONIAQTY + ACFQTY + TRANSITQTY + ItemQtyOnPO("Purchase Line") - SalesOrderQty))
                {
                }
                column(SOLast3Month; (SalesOrderQty + ((-1 * (MonthSales0To6)) + MasMonthSales0To6)))
                {
                }
                column(ItemCrossReferenceNo; ItemCrossReferenceNo)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ///

                    SYOSSETQTY := 0;
                    GASTONIAQTY := 0;
                    DAMAGEDSYQTY := 0;
                    ShortPcs := 0;
                    SAMPLINGQTY := 0;
                    ACFQTY := 0;

                    IF recItem1.GET("No.") then;

                    ILE1.RESET;
                    ILE1.SETCURRENTKEY("Item No.", "Entry Type");
                    ILE1.SETRANGE(ILE1."Item No.", "No.");
                    ILE1.SETFILTER(ILE1."Remaining Quantity", '>%1', 0);
                    IF ILE1.FINDFIRST THEN
                        REPEAT
                            IF NOT (ILE1."Quality Grade" IN [ILE1."Quality Grade"::B, ILE1."Quality Grade"::C, ILE1."Quality Grade"::D]) THEN BEGIN
                                IF ILE1."Remaining Quantity" >= recItem1."Short Piece" THEN BEGIN
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


                            END;
                        UNTIL ILE1.NEXT = 0;

                    TRANSITQTY1 := 0;
                    ILE.RESET;
                    ILE.SETRANGE("Item No.", "No.");
                    ILE.SETFILTER(ILE."Remaining Quantity", '>%1', 0);
                    ILE.SETRANGE(ILE."Location Code", 'TRANSIT2');
                    IF ILE.FIND('-') THEN
                        REPEAT
                            TRANSITQTY1 += ILE."Remaining Quantity";
                        UNTIL ILE.NEXT = 0;

                    ACFQTY := ACFQTY - TRANSITQTY1;


                    ///


                    IF recItem.GET("No.") THEN
                        ItemDesc := recItem.Description;
                    //IF ExpShortPcs THEN
                    //QtyOnHand := QtyInHand1("No.","Variant Code","Location Code")
                    //ELSE
                    // QtyOnHand := QtyInHand("No.","Variant Code","Location Code");

                    SOQty := QuantityOnSO("No.", "Variant Code");
                    //POQuantity := QuantityOnPO("Document No.","No.","Variant Code","Location Code");
                    POQuantity := Quantity;
                    POQuantityRec := QuantityOnPORec("Document No.", "No.", "Variant Code", "Location Code");
                    POQuantityBkOrder := "Outstanding Quantity";//QuantityOnPOBkOrd("Document No.","No.","Variant Code","Location Code");
                    RedyGoodsQty := RedyGoods("Document No.", "Line No.", "No.");

                    decShipQty := 0;
                    decAirQty := 0;

                    recTransferLine.RESET;
                    recTransferLine.SETFILTER("Transfer-from Code", 'INTRANSIT2');
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


                    TRANSITQTY := 0;
                    recILE.RESET;
                    recILE.SETRANGE("Item No.", "Purchase Line"."No.");
                    //recILE.SETRANGE("Dylot No.", "Purchase Line"."Document No.");
                    recILE.SETFILTER("Remaining Quantity", '<>%1', 0);
                    recILE.SETFILTER("Location Code", '%1|%2', 'TRANSIT', 'TRANSIT2');
                    IF recILE.FIND('-') THEN
                        REPEAT
                            TRANSITQTY += recILE."Remaining Quantity";
                        UNTIL recILE.NEXT = 0;
                    //>>Ashwini07272016
                    //DecReadyGoodsQty :=0;
                    DecShippedAir := 0;
                    DecShippedBoat := 0;
                    PurchLine.RESET;
                    PurchLine.SETRANGE(PurchLine."Document Type", PurchLine."Document Type"::Order);
                    PurchLine.SETRANGE(PurchLine.Type, PurchLine.Type::Item);
                    PurchLine.SETRANGE(PurchLine."No.", "No.");
                    IF PurchLine.FINDFIRST THEN
                        REPEAT
                            //DecReadyGoodsQty :=DecReadyGoodsQty + PurchLine."Ready Goods Qty";
                            DecShippedAir := DecShippedAir + PurchLine."Shipped Air";
                            DecShippedBoat := DecShippedBoat + PurchLine."Shipped Boat";
                        UNTIL PurchLine.NEXT = 0;
                    //<<Ashwini 07272016

                    SalesOrderQty := 0;
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

                    MonthSales0To6 := 0;
                    ILE.RESET;
                    //ILE.SETCURRENTKEY("Item No.","Entry Type");
                    ILE.SETRANGE(ILE."Item No.", "No.");
                    ILE.SETRANGE(ILE."Entry Type", ILE."Entry Type"::Sale);
                    ILE.SETRANGE(ILE."Posting Date", CALCDATE('<-6M>', WORKDATE), WORKDATE);
                    ILE.SETFILTER(ILE."Location Code", '<>%1', 'DAMAGED SY');
                    ILE.CALCSUMS(ILE.Quantity);
                    MonthSales0To6 := ILE.Quantity;
                    //IF ILE.FINDFIRST THEN
                    // REPEAT
                    //IF ILE."Posting Date" >= CALCDATE('<-6M>',WORKDATE) THEN
                    //MonthSales0To6 += ILE.Quantity;
                    //UNTIL ILE.NEXT=0;
                    MasMonthSales0To6 := 0;
                    // Mas2YrSales.RESET;
                    // Mas2YrSales.SETRANGE(Mas2YrSales."Item No.", "No.");
                    // Mas2YrSales.SETRANGE(Mas2YrSales."Posting Date", CALCDATE('<-6M>', WORKDATE), WORKDATE);
                    // Mas2YrSales.CALCSUMS(Mas2YrSales.Quantity);
                    // MasMonthSales0To6 := Mas2YrSales.Quantity;
                    //IF Mas2YrSales.FINDFIRST THEN
                    // REPEAT
                    //IF Mas2YrSales."Posting Date" >= CALCDATE('<-6M>',WORKDATE) THEN
                    // MasMonthSales0To6 += Mas2YrSales.Quantity;
                    // UNTIL Mas2YrSales.NEXT =0;

                    StrText := '';
                    recSalesLine.RESET;
                    recSalesLine.SETCURRENTKEY("Document Type", Type, "No.");
                    recSalesLine.SETRANGE(recSalesLine."Document Type", recSalesLine."Document Type"::Order);
                    recSalesLine.SETRANGE(recSalesLine.Type, recSalesLine.Type::Item);
                    recSalesLine.SETRANGE(recSalesLine."No.", "No.");
                    recSalesLine.SETFILTER(recSalesLine."Outstanding Quantity", '<>%1', 0);
                    recSalesLine.SETFILTER(recSalesLine.Comments, '<>%1', '');
                    IF recSalesLine.FINDFIRST THEN
                        StrText := ' ***';


                    ItemCrossReferenceNo := '';
                    ItemCrossReference.RESET;
                    ItemCrossReference.SETRANGE("Item No.", "Purchase Line"."No.");
                    ItemCrossReference.SETRANGE("Reference Type", ItemCrossReference."Reference Type"::Vendor);
                    ItemCrossReference.SETRANGE("Reference Type No.", "Purchase Line"."Buy-from Vendor No.");
                    IF ItemCrossReference.FINDFIRST THEN
                        ItemCrossReferenceNo := ItemCrossReference."Reference No.";
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Vendor.GET("Purchase Header"."Buy-from Vendor No.");
            end;

            trigger OnPreDataItem()
            begin
                //SETRANGE("Purchase Header"."Document Type",DocType);
                SETFILTER("Purchase Header"."No.", '<>%1', 'PO2277');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Filter")
                {
                    Caption = 'Designer Resource';
                    field(Explocation; Explocation)
                    {
                        Caption = 'Exp Location';
                        TableRelation = Location.Code;
                        ApplicationArea = all;
                    }
                    field(ExpShortPcs; ExpShortPcs)
                    {
                        Caption = 'Exp Short Pcs';
                        ApplicationArea = all;
                    }
                    field(DocType; DocType)
                    {
                        Caption = 'Document Type';
                        Visible = false;
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            ExpShortPcs := TRUE;
            Explocation := 'DAMAGED SY';
        end;
    }

    labels
    {
        OrderNoCap = 'PO No.';
        PoDateCap = 'PO Date';
        DueDateCap = 'Due Date';
        ItemNoCap = 'Item Number';
        ItemDescCap = 'Item Description';
        OrderedCap = 'Ordered';
        ReceivedCap = 'Received';
        QTYOnHandCap = 'Quantity on Hand';
        SOQtyCap = 'Qty on Sales Order';
        BackOrderCap = 'Back Order';
        VendorNoCap = 'Vendor No';
        VendorNameCap = 'Vendor Name';
        VendorOrderNo = 'Vendor Order No.';
        QtyRcdNotInvoiced = 'Qty Rcd Not Invoiced';
        RedyGoodsQtyCap = 'Ready Goods Qty';
        lblNegative = 'Negative';
        lbl3mreq = '3M Req.';
        lblAir = 'Air';
        lblBoat = 'Boat';
        lblHold = 'Hold';
        lblPromisedReceiptDate = 'Promised Receipt Date';
        lblPriorityQty = 'Priority Qty';
        iblPriorityDate = 'Priority Date';
    }

    var
        Vendor: Record Vendor;
        recItem: Record Item;
        QtyOnHand: Decimal;
        SOQty: Decimal;
        POQuantity: Decimal;
        POQuantityRec: Decimal;
        POQuantityBkOrder: Decimal;
        ItemDesc: Text[100];
        Explocation: Code[50];
        ExpShortPcs: Boolean;
        RedyGoodsQty: Decimal;
        decShipQty: Decimal;
        decAirQty: Decimal;
        recTransferHeader: Record "Transfer Header";
        recTransferLine: Record "Transfer Line";
        TRANSITQTY: Decimal;
        recILE: Record "Item Ledger Entry";
        SYOSSETQTY: Decimal;
        GASTONIAQTY: Decimal;
        DAMAGEDSYQTY: Decimal;
        ShortPcs: Decimal;
        SAMPLINGQTY: Decimal;
        ACFQTY: Decimal;
        ILE1: Record "Item Ledger Entry";
        ILE: Record "Item Ledger Entry";
        TRANSITQTY1: Decimal;
        recItem1: Record Item;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        SalesOrderQty: Decimal;
        recSalesLine: Record "Sales Line";
        MonthSales0To6: Decimal;
        MasMonthSales0To6: Decimal;
        // Mas2YrSales: Record "MAS 2yr sales";
        PurchLine: Record "Purchase Line";
        DecReadyGoodsQty: Decimal;
        DecShippedAir: Decimal;
        DecShippedBoat: Decimal;
        StrText: Text[5];
        ItemCrossReference: Record "Item Reference";
        ItemCrossReferenceNo: Code[20];


    procedure QuantityOnPO(PoNo: Code[20]; ItemNo: Code[20]; VarrientCode: Code[20]; LocationCode: Code[20]): Decimal
    var
        recPurchaseLine: Record "Purchase Line";
        PurchQty: Decimal;
    begin
        PurchQty := 0;
        recPurchaseLine.RESET;
        recPurchaseLine.SETCURRENTKEY("Document Type", Type, "No.");
        recPurchaseLine.SETRANGE(recPurchaseLine."Document Type", recPurchaseLine."Document Type"::Order);
        recPurchaseLine.SETRANGE(recPurchaseLine."Document No.", PoNo);
        recPurchaseLine.SETRANGE(recPurchaseLine.Type, recPurchaseLine.Type::Item);
        recPurchaseLine.SETRANGE(recPurchaseLine."No.", ItemNo);
        recPurchaseLine.SETRANGE(recPurchaseLine."Variant Code", VarrientCode);
        recPurchaseLine.SETRANGE(recPurchaseLine."Location Code", LocationCode);
        IF recPurchaseLine.FINDFIRST THEN
            REPEAT
                PurchQty += recPurchaseLine.Quantity;
            UNTIL recPurchaseLine.NEXT = 0;
        EXIT(PurchQty);
    end;


    procedure QuantityOnPORec(PoNo: Code[20]; ItemNo: Code[20]; VarrientCode: Code[20]; LocationCode: Code[20]): Decimal
    var
        recPurchaseLine: Record "Purchase Line";
        PurchQty: Decimal;
    begin
        PurchQty := 0;
        recPurchaseLine.RESET;
        recPurchaseLine.SETCURRENTKEY("Document Type", Type, "No.");
        recPurchaseLine.SETRANGE(recPurchaseLine."Document Type", recPurchaseLine."Document Type"::Order);
        recPurchaseLine.SETRANGE(recPurchaseLine."Document No.", PoNo);
        recPurchaseLine.SETRANGE(recPurchaseLine.Type, recPurchaseLine.Type::Item);
        recPurchaseLine.SETRANGE(recPurchaseLine."No.", ItemNo);
        recPurchaseLine.SETRANGE(recPurchaseLine."Variant Code", VarrientCode);
        recPurchaseLine.SETRANGE(recPurchaseLine."Location Code", LocationCode);
        IF recPurchaseLine.FINDFIRST THEN
            REPEAT
                PurchQty += recPurchaseLine."Quantity Received";
            UNTIL recPurchaseLine.NEXT = 0;
        EXIT(PurchQty);
    end;


    procedure QuantityOnPOBkOrd(PoNo: Code[20]; ItemNo: Code[20]; VarrientCode: Code[20]; LocationCode: Code[20]): Decimal
    var
        recPurchaseLine: Record "Purchase Line";
        PurchQty: Decimal;
    begin
        PurchQty := 0;
        recPurchaseLine.RESET;
        recPurchaseLine.SETCURRENTKEY("Document Type", Type, "No.");
        recPurchaseLine.SETRANGE(recPurchaseLine."Document Type", recPurchaseLine."Document Type"::Order);
        recPurchaseLine.SETRANGE(recPurchaseLine."Document No.", PoNo);
        recPurchaseLine.SETRANGE(recPurchaseLine.Type, recPurchaseLine.Type::Item);
        recPurchaseLine.SETRANGE(recPurchaseLine."No.", ItemNo);
        recPurchaseLine.SETRANGE(recPurchaseLine."Variant Code", VarrientCode);
        recPurchaseLine.SETRANGE(recPurchaseLine."Location Code", LocationCode);
        IF recPurchaseLine.FINDFIRST THEN
            REPEAT
                PurchQty += recPurchaseLine."Outstanding Quantity";
            UNTIL recPurchaseLine.NEXT = 0;
        EXIT(PurchQty);
    end;


    procedure QtyInHand(ItemNo: Code[20]; VarientCode: Code[20]; LocationCode: Code[20]): Decimal
    var
        recILE: Record "Item Ledger Entry";
        ILEQty: Decimal;
    begin
        ILEQty := 0;
        recILE.RESET;
        recILE.SETCURRENTKEY("Item No.", "Variant Code", "Location Code");
        recILE.SETRANGE(recILE."Item No.", ItemNo);
        recILE.SETRANGE(recILE."Variant Code", VarientCode);
        recILE.SETRANGE(recILE."Location Code", LocationCode);
        recILE.SETFILTER(recILE."Remaining Quantity", '<>%1', 0);
        IF Explocation <> '' THEN
            recILE.SETFILTER(recILE."Location Code", '<>%1', Explocation);
        IF recILE.FINDFIRST THEN
            REPEAT
                ILEQty += recILE.Quantity;
            UNTIL recILE.NEXT = 0;
        EXIT(ILEQty);
    end;


    procedure QtyInHand1(ItemNo: Code[20]; VarientCode: Code[20]; LocationCode: Code[20]): Decimal
    var
        recILE: Record "Item Ledger Entry";
        ILEQty: Decimal;
        Itemrec: Record Item;
    begin
        ILEQty := 0;
        recILE.RESET;
        recILE.SETCURRENTKEY("Item No.", "Variant Code", "Location Code");
        recILE.SETRANGE(recILE."Item No.", ItemNo);
        recILE.SETRANGE(recILE."Variant Code", VarientCode);
        recILE.SETRANGE(recILE."Location Code", LocationCode);
        recILE.SETFILTER(recILE."Remaining Quantity", '<>%1', 0);
        IF Explocation <> '' THEN
            recILE.SETFILTER(recILE."Location Code", '<>%1', Explocation);
        IF Itemrec.GET(recILE."Item No.") THEN;
        IF recILE.FINDFIRST THEN
            REPEAT
                IF recItem."Short Piece" < recILE."Remaining Quantity" THEN
                    ILEQty += recILE."Remaining Quantity";
            UNTIL recILE.NEXT = 0;
        EXIT(ILEQty);
    end;


    procedure QuantityOnSO(ItemNo: Code[20]; VarrientCode: Code[20]): Decimal
    var
        recSalesLine: Record "Sales Line";
        SoQty: Decimal;
    begin
        SoQty := 0;
        recSalesLine.RESET;
        recSalesLine.SETCURRENTKEY("Document Type", Type, "No.");
        recSalesLine.SETRANGE(recSalesLine."Document Type", recSalesLine."Document Type"::Order);
        recSalesLine.SETRANGE(recSalesLine.Type, recSalesLine.Type::Item);
        recSalesLine.SETRANGE(recSalesLine."No.", ItemNo);
        recSalesLine.SETRANGE(recSalesLine."Variant Code", VarrientCode);
        IF recSalesLine.FINDFIRST THEN
            REPEAT
                SoQty += recSalesLine."Outstanding Quantity";
            UNTIL recSalesLine.NEXT = 0;
        EXIT(SoQty);
    end;


    procedure RedyGoods(OrdNo: Code[20]; LineNo: Integer; ItemNo: Code[20]): Decimal
    var
        ReservationEntry: Record "Reservation Entry";
        redyGoodsQuantity: Decimal;
    begin
        redyGoodsQuantity := 0;
        ReservationEntry.RESET;
        ReservationEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Item No.");
        ReservationEntry.SETRANGE(ReservationEntry."Source ID", OrdNo);
        ReservationEntry.SETRANGE(ReservationEntry."Source Ref. No.", LineNo);
        ReservationEntry.SETRANGE(ReservationEntry."Item No.", ItemNo);
        IF ReservationEntry.FINDFIRST THEN
            REPEAT
                redyGoodsQuantity += ReservationEntry."Qty. to Handle (Base)";
            UNTIL ReservationEntry.NEXT = 0;
        EXIT(redyGoodsQuantity);
    end;


    procedure ItemQtyOnPO(PurchLine: Record "Purchase Line"): Decimal
    var
        L_PurchaseLine: Record "Purchase Line";
    begin
        L_PurchaseLine.RESET;
        L_PurchaseLine.SETRANGE(L_PurchaseLine."Document Type", PurchLine."Document Type");
        L_PurchaseLine.SETRANGE(L_PurchaseLine.Type, PurchLine.Type);
        //L_PurchaseLine.SETRANGE(L_PurchaseLine."Document No.",PurchLine."Document No.");
        L_PurchaseLine.SETRANGE(L_PurchaseLine."No.", PurchLine."No.");
        L_PurchaseLine.SETRANGE(L_PurchaseLine."Shortcut Dimension 1 Code", PurchLine."Shortcut Dimension 1 Code");
        L_PurchaseLine.SETRANGE(L_PurchaseLine."Shortcut Dimension 2 Code", PurchLine."Shortcut Dimension 2 Code");
        L_PurchaseLine.SETRANGE(L_PurchaseLine."Location Code", PurchLine."Location Code");
        L_PurchaseLine.CALCSUMS(L_PurchaseLine."Outstanding Qty. (Base)");
        EXIT(L_PurchaseLine."Outstanding Qty. (Base)");
    end;
}

