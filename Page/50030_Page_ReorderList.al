page 50030 "Reorder List"
{
    Editable = false;
    PageType = List;
    SourceTable = Item;
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ReOrder Tab"; Rec."ReOrder Tab")
                {
                    ApplicationArea = All;
                }
                field("Warp Color"; Rec."Warp Color")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(VendorName; VendorNameTrigger)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor';
                }
                field(Customer; Rec.Customer)
                {
                    ApplicationArea = All;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                }
                field("Product Line"; Rec."Product Line")
                {
                    ApplicationArea = All;
                }
                field(LocSYOSSET1; LocSYOSSET)
                {
                    ApplicationArea = All;
                    Caption = 'SYOSSET QTY';
                }
                field(LocDAMAGEDSY1; LocDAMAGEDSY)
                {
                    ApplicationArea = All;
                    Caption = 'DAMAGEDSY QTY';
                }
                field(LocGASTONIA1; LocGASTONIA)
                {
                    ApplicationArea = All;
                    Caption = 'GASTONIA QTY';
                }
                field(LocTRANSIT1; LocTRANSIT)
                {
                    ApplicationArea = All;
                    Caption = 'TRANSIT QTY';
                }
                field(LocACF1; LocACF)
                {
                    ApplicationArea = All;
                    Caption = 'ACF QTY';
                }
                field(LocSAMPLING1; LocSAMPLING)
                {
                    ApplicationArea = All;
                    Caption = 'SAMPLING QTY';
                }
                field(Inventory_Item; LocSYOSSET + LocGASTONIA + LocACF + LocSAMPLING)
                {
                    ApplicationArea = All;
                    Caption = 'OH';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        recItemLedgerEntry: Record "Item Ledger Entry";
                    begin
                        recItemLedgerEntry.Reset;
                        recItemLedgerEntry.SetRange(recItemLedgerEntry."Item No.", Rec."No.");
                        recItemLedgerEntry.SetFilter(recItemLedgerEntry."Remaining Quantity", '<>%1', 0);
                        PAGE.Run(PAGE::"Item Ledger Entries", recItemLedgerEntry);
                    end;
                }
                field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
                {
                    ApplicationArea = All;
                }
                field(SalesOrdQty1; SalesOrdQty)
                {
                    ApplicationArea = All;
                    Caption = 'SO';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        recSalesLine: Record "Sales Line";
                    begin
                        recSalesLine.Reset;
                        recSalesLine.SetCurrentKey("Document Type", Type, "No.");
                        recSalesLine.SetRange(recSalesLine."Document Type", recSalesLine."Document Type"::Order);
                        recSalesLine.SetRange(recSalesLine.Type, recSalesLine.Type::Item);
                        recSalesLine.SetRange(recSalesLine."No.", Rec."No.");
                        recSalesLine.SetFilter(recSalesLine."Outstanding Quantity", '<>%1', 0);
                        recSalesLine.SetFilter(recSalesLine."Location Code", '<>%1', 'DAMAGED SY');
                        PAGE.Run(PAGE::"Sales Lines", recSalesLine);
                    end;
                }
                field(Avail; LocSYOSSET + LocGASTONIA + LocACF + LocSAMPLING - SalesOrdQty)
                {
                    ApplicationArea = All;
                    Caption = 'Avail';
                }
                field(Actual; LocSYOSSET + LocGASTONIA + LocACF + LocSAMPLING + Rec."Qty. on Purch. Order" + LocTRANSIT - SalesOrdQty)
                {
                    ApplicationArea = All;
                    Caption = 'Actual';
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                }
                field(MasMonthSales0To6N; (-1 * (MonthSales0To6)) + MasMonthSales0To6)
                {
                    ApplicationArea = All;
                    Caption = '0 To 6';
                }
                field(MasMonthSales7To12N; (-1 * (MonthSales7To12)) + MasMonthSales7To12)
                {
                    ApplicationArea = All;
                    Caption = '7 To 12';
                }
                field(MasMonthSale13to24N; (-1 * (MonthSale13to24)) + MasMonthSale13to24)
                {
                    ApplicationArea = All;
                    Caption = '13 To 24';
                }
                field(T6M; SalesOrderQty + (-1 * (MonthSales0To6)) + MasMonthSales0To6)
                {
                    ApplicationArea = All;
                    Caption = 'T 6M';
                    Style = Unfavorable;
                    StyleExpr = TRUE;
                }
                field(ActualReq; (LocSYOSSET + LocSAMPLING + LocGASTONIA + LocACF + LocTRANSIT - SalesOrderQty + Rec."Qty. on Purch. Order") - (SalesOrderQty + (-1 * (MonthSales0To6)) + MasMonthSales0To6))
                {
                    ApplicationArea = All;
                    Caption = 'Actual Req';
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
                field(ReadyGoodsQty1; ReadyGoodsQty)
                {
                    ApplicationArea = All;
                    Caption = 'Ready Goods Qty';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        RecPurchline: Record "Purchase Line";
                    begin
                        RecPurchline.Reset;
                        RecPurchline.SetRange(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
                        RecPurchline.SetRange(RecPurchline."No.", Rec."No.");
                        RecPurchline.SetFilter(RecPurchline."Ready Goods Qty", '<>%1', 0);
                        PAGE.Run(PAGE::"Purchase Lines", RecPurchline);
                    end;
                }
                field(ShippedAir1; ShippedAir)
                {
                    ApplicationArea = All;
                    Caption = 'Shipped Air';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        RecPurchline: Record "Purchase Line";
                    begin
                        RecPurchline.Reset;
                        RecPurchline.SetRange(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
                        RecPurchline.SetRange(RecPurchline."No.", Rec."No.");
                        RecPurchline.SetFilter(RecPurchline."Shipped Air", '<>%1', 0);
                        PAGE.Run(PAGE::"Purchase Lines", RecPurchline);
                    end;
                }
                field(ShippedBoat1; ShippedBoat)
                {
                    ApplicationArea = All;
                    Caption = 'Shipped Boat';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        RecPurchline: Record "Purchase Line";
                    begin
                        RecPurchline.Reset;
                        RecPurchline.SetRange(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
                        RecPurchline.SetRange(RecPurchline."No.", Rec."No.");
                        RecPurchline.SetFilter(RecPurchline."Shipped Boat", '<>%1', 0);
                        PAGE.Run(PAGE::"Purchase Lines", RecPurchline);
                    end;
                }
                field(BalanceQty1; BalanceQty)
                {
                    ApplicationArea = All;
                    Caption = 'Balance Qty';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        RecPurchline: Record "Purchase Line";
                    begin
                        RecPurchline.Reset;
                        RecPurchline.SetRange(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
                        RecPurchline.SetRange(RecPurchline."No.", Rec."No.");
                        RecPurchline.SetFilter(RecPurchline."Balance Qty", '<>%1', 0);
                        PAGE.Run(PAGE::"Purchase Lines", RecPurchline);
                    end;
                }
                field(ShippingHold1; ShippingHold)
                {
                    ApplicationArea = All;
                    Caption = 'Shipping Hold';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        RecPurchline: Record "Purchase Line";
                    begin
                        RecPurchline.Reset;
                        RecPurchline.SetRange(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
                        RecPurchline.SetRange(RecPurchline."No.", Rec."No.");
                        RecPurchline.SetFilter(RecPurchline."Shipping Hold", '<>%1', 0);
                        PAGE.Run(PAGE::"Purchase Lines", RecPurchline);
                    end;
                }
                field(PriorityQty1; PriorityQty)
                {
                    ApplicationArea = All;
                    Caption = 'Priority Qty';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        RecPurchline: Record "Purchase Line";
                    begin
                        RecPurchline.Reset;
                        RecPurchline.SetRange(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
                        RecPurchline.SetRange(RecPurchline."No.", Rec."No.");
                        RecPurchline.SetFilter(RecPurchline."Priority Qty", '<>%1', 0);
                        PAGE.Run(PAGE::"Purchase Lines", RecPurchline);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    procedure LocSYOSSET(): Decimal
    var
        ILE: Record "Item Ledger Entry";
        SYOSSETQTY: Decimal;
    begin
        SYOSSETQTY := 0;
        ILE.Reset;
        ILE.SetCurrentKey("Item No.", "Entry Type");
        ILE.SetRange(ILE."Item No.", Rec."No.");
        ILE.SetFilter(ILE."Remaining Quantity", '>%1', 0);
        if ILE.FindFirst then
            repeat
                if ILE."Remaining Quantity" >= Rec."Short Piece" then begin
                    if ILE."Location Code" = 'SYOSSET' then
                        SYOSSETQTY += ILE."Remaining Quantity"
                end;
            until ILE.Next = 0;
        exit(SYOSSETQTY);
    end;

    procedure LocDAMAGEDSY(): Decimal
    var
        ILE: Record "Item Ledger Entry";
        DAMAGEDSYQTY: Decimal;
    begin
        DAMAGEDSYQTY := 0;
        ILE.Reset;
        ILE.SetCurrentKey("Item No.", "Entry Type");
        ILE.SetRange(ILE."Item No.", Rec."No.");
        ILE.SetFilter(ILE."Remaining Quantity", '>%1', 0);
        if ILE.FindFirst then
            repeat
                if ILE."Remaining Quantity" >= Rec."Short Piece" then begin
                    if ILE."Location Code" = 'DAMAGED SY' then
                        DAMAGEDSYQTY += ILE."Remaining Quantity"
                end;
            until ILE.Next = 0;
        exit(DAMAGEDSYQTY);
    end;

    procedure LocGASTONIA(): Decimal
    var
        ILE: Record "Item Ledger Entry";
        GASTONIAQTY: Decimal;
    begin
        GASTONIAQTY := 0;
        ILE.Reset;
        ILE.SetCurrentKey("Item No.", "Entry Type");
        ILE.SetRange(ILE."Item No.", Rec."No.");
        ILE.SetFilter(ILE."Remaining Quantity", '>%1', 0);
        if ILE.FindFirst then
            repeat
                if ILE."Remaining Quantity" >= Rec."Short Piece" then begin
                    if ILE."Location Code" = 'GASTONIA' then
                        GASTONIAQTY += ILE."Remaining Quantity"
                end;
            until ILE.Next = 0;
        exit(GASTONIAQTY);
    end;

    procedure LocTRANSIT(): Decimal
    var
        ILE: Record "Item Ledger Entry";
        TRANSITQTY: Decimal;
    begin
        TRANSITQTY := 0;
        ILE.Reset;
        ILE.SetRange("Item No.", Rec."No.");
        ILE.SetFilter(ILE."Remaining Quantity", '>%1', 0);
        ILE.SetFilter(ILE."Location Code", '%1|%2', 'TRANSIT', 'TRANSIT2');
        if ILE.Find('-') then
            repeat
                TRANSITQTY += ILE."Remaining Quantity";
            until ILE.Next = 0;
        exit(TRANSITQTY);
    end;

    procedure LocACF(): Decimal
    var
        ILE: Record "Item Ledger Entry";
        ACFQTY: Decimal;
    begin
        ACFQTY := 0;
        ILE.Reset;
        ILE.SetRange("Item No.", Rec."No.");
        ILE.SetFilter(ILE."Remaining Quantity", '>%1', 0);
        ILE.SetFilter(ILE."Location Code", 'ACF');
        if ILE.Find('-') then
            repeat
                ACFQTY += ILE."Remaining Quantity";
            until ILE.Next = 0;
        exit(ACFQTY);
    end;

    procedure LocSAMPLING(): Decimal
    var
        ILE: Record "Item Ledger Entry";
        SAMPLINGQTY: Decimal;
    begin
        SAMPLINGQTY := 0;
        ILE.Reset;
        ILE.SetRange("Item No.", Rec."No.");
        ILE.SetFilter(ILE."Remaining Quantity", '>%1', 0);
        ILE.SetFilter(ILE."Location Code", 'SAMPLING');
        if ILE.Find('-') then
            repeat
                SAMPLINGQTY += ILE."Remaining Quantity";
            until ILE.Next = 0;
        exit(SAMPLINGQTY);
    end;

    procedure SalesOrdQty(): Decimal
    var
        recSalesLine: Record "Sales Line";
        SalesOrderQty: Decimal;
    begin
        SalesOrderQty := 0;
        recSalesLine.Reset;
        recSalesLine.SetCurrentKey("Document Type", Type, "No.");
        recSalesLine.SetRange(recSalesLine."Document Type", recSalesLine."Document Type"::Order);
        recSalesLine.SetRange(recSalesLine.Type, recSalesLine.Type::Item);
        recSalesLine.SetRange(recSalesLine."No.", Rec."No.");
        recSalesLine.SetFilter(recSalesLine."Location Code", '<>%1', 'DAMAGED SY');
        if recSalesLine.FindFirst then
            repeat
                SalesOrderQty += recSalesLine."Outstanding Qty. (Base)";
            until recSalesLine.Next = 0;
        exit(SalesOrderQty);
    end;

    procedure VendorNameTrigger(): Text
    var
        recVendor: Record Vendor;
        TxtVendorName: Text[100];
    begin
        TxtVendorName := '';
        if recVendor.Get(Rec."Vendor No.") then
            TxtVendorName := recVendor."Name 2";
        exit(TxtVendorName);
    end;

    procedure MasMonthSales0To6(): Decimal
    var
        //Mas2YrSales: Record "MAS 2yr sales";
        MasMonthSales0To6Qty: Decimal;
    begin
        MasMonthSales0To6Qty := 0;
        // Mas2YrSales.Reset;
        // Mas2YrSales.SetRange(Mas2YrSales."Item No.", Rec."No.");
        // if Mas2YrSales.FindFirst then
        //     repeat
        //         if Mas2YrSales."Posting Date" >= CalcDate('<-6M>', WorkDate) then
        //             MasMonthSales0To6Qty += Mas2YrSales.Quantity
        //     until Mas2YrSales.Next = 0;
        exit(MasMonthSales0To6Qty);
    end;

    procedure MasMonthSales7To12(): Decimal
    var
        //Mas2YrSales: Record "MAS 2yr sales";
        MasMonthSales7To12Qty: Decimal;
    begin
        MasMonthSales7To12Qty := 0;
        // Mas2YrSales.Reset;
        // Mas2YrSales.SetRange(Mas2YrSales."Item No.", Rec."No.");
        // if Mas2YrSales.FindFirst then
        //     repeat
        //         if ((Mas2YrSales."Posting Date" >= CalcDate('<-1Y>', WorkDate)) and (Mas2YrSales."Posting Date" < CalcDate('<-6M+1D>', WorkDate))) then
        //             MasMonthSales7To12Qty += Mas2YrSales.Quantity
        //     until Mas2YrSales.Next = 0;
        exit(MasMonthSales7To12Qty);
    end;

    procedure MasMonthSale13to24(): Decimal
    var
        //Mas2YrSales: Record "MAS 2yr sales";
        MasMonthSale13to24Qty: Decimal;
    begin
        MasMonthSale13to24Qty := 0;
        // Mas2YrSales.Reset;
        // Mas2YrSales.SetRange(Mas2YrSales."Item No.", Rec."No.");
        // if Mas2YrSales.FindFirst then
        //     repeat
        //         if ((Mas2YrSales."Posting Date" >= CalcDate('<-2Y>', WorkDate)) and (Mas2YrSales."Posting Date" < CalcDate('<-1Y+1D>', WorkDate))) then
        //             MasMonthSale13to24Qty += Mas2YrSales.Quantity;
        //     until Mas2YrSales.Next = 0;
        exit(MasMonthSale13to24Qty);
    end;


    procedure MonthSales0To6(): Decimal
    var
        ILE: Record "Item Ledger Entry";
        MonthSales0To6Qty: Decimal;
    begin
        MonthSales0To6Qty := 0;
        ILE.Reset;
        ILE.SetCurrentKey("Item No.", "Entry Type");
        ILE.SetRange(ILE."Item No.", Rec."No.");
        ILE.SetRange(ILE."Entry Type", ILE."Entry Type"::Sale);
        ILE.SetFilter(ILE."Location Code", '<>%1', 'DAMAGED SY');
        if ILE.FindFirst then
            repeat
                if ILE."Posting Date" >= CalcDate('<-6M>', WorkDate) then
                    MonthSales0To6Qty += ILE.Quantity
            until ILE.Next = 0;
        exit(MonthSales0To6Qty);
    end;

    procedure MonthSales7To12(): Decimal
    var
        ILE: Record "Item Ledger Entry";
        MonthSales7To12Qty: Decimal;
    begin
        MonthSales7To12Qty := 0;
        ILE.Reset;
        ILE.SetCurrentKey("Item No.", "Entry Type");
        ILE.SetRange(ILE."Item No.", Rec."No.");
        ILE.SetRange(ILE."Entry Type", ILE."Entry Type"::Sale);
        ILE.SetFilter(ILE."Location Code", '<>%1', 'DAMAGED SY');
        if ILE.FindFirst then
            repeat
                if ((ILE."Posting Date" >= CalcDate('<-1Y>', WorkDate)) and (ILE."Posting Date" < CalcDate('<-6M+1D>', WorkDate))) then
                    MonthSales7To12Qty += ILE.Quantity
            until ILE.Next = 0;
        exit(MonthSales7To12Qty);
    end;

    procedure MonthSale13to24(): Decimal
    var
        ILE: Record "Item Ledger Entry";
        MonthSale13to24Qty: Decimal;
    begin
        MonthSale13to24Qty := 0;
        ILE.Reset;
        ILE.SetCurrentKey("Item No.", "Entry Type");
        ILE.SetRange(ILE."Item No.", Rec."No.");
        ILE.SetRange(ILE."Entry Type", ILE."Entry Type"::Sale);
        ILE.SetFilter(ILE."Location Code", '<>%1', 'DAMAGED SY');
        if ILE.FindFirst then
            repeat
                if ((ILE."Posting Date" >= CalcDate('<-2Y>', WorkDate)) and (ILE."Posting Date" < CalcDate('<-1Y+1D>', WorkDate))) then
                    MonthSale13to24Qty += ILE.Quantity;
            until ILE.Next = 0;
        exit(MonthSale13to24Qty);
    end;


    procedure SalesOrderQty(): Decimal
    var
        recSalesLine: Record "Sales Line";
        decSalesOrderQty: Decimal;
    begin
        decSalesOrderQty := 0;
        recSalesLine.Reset;
        recSalesLine.SetCurrentKey("Document Type", Type, "No.");
        recSalesLine.SetRange(recSalesLine."Document Type", recSalesLine."Document Type"::Order);
        recSalesLine.SetRange(recSalesLine.Type, recSalesLine.Type::Item);
        recSalesLine.SetRange(recSalesLine."No.", Rec."No.");
        recSalesLine.SetFilter(recSalesLine."Location Code", '<>%1', 'DAMAGED SY');
        if recSalesLine.FindFirst then
            repeat
                decSalesOrderQty += recSalesLine."Outstanding Qty. (Base)";
            until recSalesLine.Next = 0;
        exit(decSalesOrderQty);
    end;


    procedure ReadyGoodsQty(): Decimal
    var
        RecPurchline: Record "Purchase Line";
        DecReadyGoodQty: Decimal;
    begin
        DecReadyGoodQty := 0;
        RecPurchline.Reset;
        RecPurchline.SetRange(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
        RecPurchline.SetRange(RecPurchline."No.", Rec."No.");
        RecPurchline.SetFilter(RecPurchline."Ready Goods Qty", '<>%1', 0);
        if RecPurchline.FindFirst then
            repeat
                DecReadyGoodQty := DecReadyGoodQty + RecPurchline."Ready Goods Qty";
            until RecPurchline.Next = 0;
        exit(DecReadyGoodQty);
    end;

    procedure ShippedAir(): Decimal
    var
        RecPurchline: Record "Purchase Line";
        DecShippedAirQty: Decimal;
    begin
        DecShippedAirQty := 0;
        RecPurchline.Reset;
        RecPurchline.SetRange(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
        RecPurchline.SetRange(RecPurchline."No.", Rec."No.");
        RecPurchline.SetFilter(RecPurchline."Shipped Air", '<>%1', 0);
        if RecPurchline.FindFirst then
            repeat
                DecShippedAirQty := DecShippedAirQty + RecPurchline."Shipped Air";
            until RecPurchline.Next = 0;
        exit(DecShippedAirQty);
    end;

    procedure ShippedBoat(): Decimal
    var
        RecPurchline: Record "Purchase Line";
        DecShippedBoatQty: Decimal;
    begin
        DecShippedBoatQty := 0;
        RecPurchline.Reset;
        RecPurchline.SetRange(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
        RecPurchline.SetRange(RecPurchline."No.", Rec."No.");
        RecPurchline.SetFilter(RecPurchline."Shipped Boat", '<>%1', 0);
        if RecPurchline.FindFirst then
            repeat
                DecShippedBoatQty := DecShippedBoatQty + RecPurchline."Shipped Boat";
            until RecPurchline.Next = 0;
        exit(DecShippedBoatQty);
    end;

    procedure BalanceQty(): Decimal
    var
        RecPurchline: Record "Purchase Line";
        DecBalanceQty: Decimal;
    begin
        DecBalanceQty := 0;
        RecPurchline.Reset;
        RecPurchline.SetRange(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
        RecPurchline.SetRange(RecPurchline."No.", Rec."No.");
        RecPurchline.SetFilter(RecPurchline."Balance Qty", '<>%1', 0);
        if RecPurchline.FindFirst then
            repeat
                DecBalanceQty := DecBalanceQty + RecPurchline."Balance Qty";
            until RecPurchline.Next = 0;
        exit(DecBalanceQty);
    end;

    procedure ShippingHold(): Decimal
    var
        RecPurchline: Record "Purchase Line";
        DecShippingHoldQty: Decimal;
    begin
        DecShippingHoldQty := 0;
        RecPurchline.Reset;
        RecPurchline.SetRange(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
        RecPurchline.SetRange(RecPurchline."No.", Rec."No.");
        RecPurchline.SetFilter(RecPurchline."Shipping Hold", '<>%1', 0);
        if RecPurchline.FindFirst then
            repeat
                DecShippingHoldQty := DecShippingHoldQty + RecPurchline."Shipping Hold";
            until RecPurchline.Next = 0;
        exit(DecShippingHoldQty);
    end;

    procedure PriorityQty(): Decimal
    var
        RecPurchline: Record "Purchase Line";
        DecPriorityQty: Decimal;
    begin
        DecPriorityQty := 0;
        RecPurchline.Reset;
        RecPurchline.SetRange(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
        RecPurchline.SetRange(RecPurchline."No.", Rec."No.");
        RecPurchline.SetFilter(RecPurchline."Priority Qty", '<>%1', 0);
        if RecPurchline.FindFirst then
            repeat
                DecPriorityQty := DecPriorityQty + RecPurchline."Priority Qty";
            until RecPurchline.Next = 0;
        exit(DecPriorityQty);
    end;
}

