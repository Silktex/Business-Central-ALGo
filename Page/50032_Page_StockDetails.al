page 50032 "Stock Details"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    Permissions = TableData Item = rimd;
    RefreshOnActivate = true;
    SourceTable = Item;
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            group(Control1000000012)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sales (Qty.)"; Rec."Sales (Qty.)")
                {
                    ApplicationArea = All;
                }
                field(SalesOrdQty1; SalesOrdQty)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Order Qty';

                    // trigger OnLookup(var Text: Text): Boolean
                    // var
                    //     recSalesLine: Record "Sales Line";
                    // begin
                    //     recSalesLine.Reset;
                    //     recSalesLine.SetCurrentKey("Document Type", Type, "No.");
                    //     recSalesLine.SetRange(recSalesLine."Document Type", recSalesLine."Document Type"::Order);
                    //     recSalesLine.SetRange(recSalesLine.Type, recSalesLine.Type::Item);
                    //     recSalesLine.SetRange(recSalesLine."No.", Rec."No.");
                    //     recSalesLine.SetFilter(recSalesLine."Location Code", '<>%1', 'DAMAGED SY');
                    //     recSalesLine.SetFilter(recSalesLine."Outstanding Quantity", '<>%1', 0);
                    //     PAGE.Run(PAGE::"Sales Lines", recSalesLine);
                    // end;

                    trigger OnDrillDown()
                    var
                        recSalesLine: Record "Sales Line";
                    begin
                        recSalesLine.Reset;
                        recSalesLine.SetCurrentKey("Document Type", Type, "No.");
                        recSalesLine.SetRange(recSalesLine."Document Type", recSalesLine."Document Type"::Order);
                        recSalesLine.SetRange(recSalesLine.Type, recSalesLine.Type::Item);
                        recSalesLine.SetRange(recSalesLine."No.", Rec."No.");
                        recSalesLine.SetFilter(recSalesLine."Location Code", '<>%1', 'DAMAGED SY');
                        recSalesLine.SetFilter(recSalesLine."Outstanding Quantity", '<>%1', 0);
                        PAGE.Run(PAGE::"Sales Lines", recSalesLine);
                    end;
                }
                field(BinCode1; BinCode)
                {
                    ApplicationArea = All;
                    Caption = 'Bin Code';

                    trigger OnDrillDown()
                    var
                        recBinContent: Record "Bin Content";
                    begin
                        recBinContent.Reset;
                        recBinContent.SetRange("Item No.", Rec."No.");
                        PAGE.Run(PAGE::"Bin Content", recBinContent);
                    end;
                }
                field(CFAQty1; CFAQty)
                {
                    ApplicationArea = All;
                    Caption = 'CFA Qty';

                    trigger OnDrillDown()
                    var
                        recSalesLine: Record "Sales Line";
                    begin
                        recSalesLine.Reset;
                        recSalesLine.SetCurrentKey("Document Type", Type, "No.");
                        recSalesLine.SetRange(recSalesLine."Document Type", recSalesLine."Document Type"::Quote);
                        recSalesLine.SetRange(recSalesLine.Type, recSalesLine.Type::Item);
                        recSalesLine.SetRange(recSalesLine."No.", Rec."No.");
                        recSalesLine.SetFilter(recSalesLine."Outstanding Quantity", '<>%1', 0);
                        recSalesLine.SetFilter(recSalesLine."Location Code", '<>%1', 'DAMAGED SY');
                        PAGE.Run(PAGE::"Sales Lines", recSalesLine);
                    end;
                }
                field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
                {
                    ApplicationArea = All;
                }
                field(LocTRANSIT1; LocTRANSIT)
                {
                    ApplicationArea = All;
                    Caption = 'Transit Qty';

                    trigger OnDrillDown()
                    var
                        ILE: Record "Item Ledger Entry";
                    begin
                        ILE.Reset;
                        ILE.SetCurrentKey("Item No.", "Entry Type");
                        ILE.SetRange(ILE."Item No.", Rec."No.");
                        ILE.SetFilter(ILE."Remaining Quantity", '>%1', 0);
                        ILE.SetRange(ILE."Location Code", 'TRANSIT2');
                        PAGE.Run(PAGE::"Item Ledger Entries", ILE);
                    end;
                }
                field(ReadyGoodsQty1; ReadyGoodsQty)
                {
                    ApplicationArea = All;
                    Caption = 'Ready Goods';

                    trigger OnDrillDown()
                    var
                        RecPurchline: Record "Purchase Line";
                    begin
                        RecPurchline.Reset;
                        RecPurchline.SetRange(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
                        RecPurchline.SetRange(RecPurchline."No.", Rec."No.");
                        RecPurchline.SetFilter(RecPurchline."Ready Goods Qty", '<>%1', 0);
                        RecPurchline.SetFilter(RecPurchline."Outstanding Quantity", '<>%1', 0);
                        PAGE.Run(PAGE::"Purchase Lines", RecPurchline);
                    end;
                }
                field(ShippedAir1; ShippedAir)
                {
                    ApplicationArea = All;
                    Caption = 'Air';

                    trigger OnDrillDown()
                    var
                        RecPurchline: Record "Purchase Line";
                    begin
                        RecPurchline.Reset;
                        RecPurchline.SetRange(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
                        RecPurchline.SetRange(RecPurchline."No.", Rec."No.");
                        RecPurchline.SetFilter(RecPurchline."Outstanding Quantity", '<>%1', 0);
                        RecPurchline.SetFilter(RecPurchline."Shipped Air", '<>%1', 0);
                        PAGE.Run(PAGE::"Purchase Lines", RecPurchline);
                    end;
                }
                field(ShippedBoat1; ShippedBoat)
                {
                    ApplicationArea = All;
                    Caption = 'Sea';

                    trigger OnDrillDown()
                    var
                        RecPurchline: Record "Purchase Line";
                    begin
                        RecPurchline.Reset;
                        RecPurchline.SetRange(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
                        RecPurchline.SetRange(RecPurchline."No.", Rec."No.");
                        RecPurchline.SetFilter(RecPurchline."Outstanding Quantity", '<>%1', 0);
                        RecPurchline.SetFilter(RecPurchline."Shipped Boat", '<>%1', 0);
                        PAGE.Run(PAGE::"Purchase Lines", RecPurchline);
                    end;
                }
                field(Hold1; Hold)
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    var
                        RecPurchline: Record "Purchase Line";
                    begin
                        RecPurchline.Reset;
                        RecPurchline.SetRange(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
                        RecPurchline.SetRange(RecPurchline."No.", Rec."No.");
                        RecPurchline.SetFilter(RecPurchline."Outstanding Quantity", '<>%1', 0);
                        RecPurchline.SetFilter(RecPurchline."Shipping Hold", '<>%1', 0);
                        PAGE.Run(PAGE::"Purchase Lines", RecPurchline);
                    end;
                }
                field(LocSYOSSET1; LocSYOSSET)
                {
                    ApplicationArea = All;
                    Caption = 'SYOSSET';

                    trigger OnDrillDown()
                    var
                        ILE: Record "Item Ledger Entry";
                    begin
                        ILE.Reset;
                        ILE.SetCurrentKey("Item No.", "Entry Type");
                        ILE.SetRange(ILE."Item No.", Rec."No.");
                        if Rec."Short Piece" <> 0 then
                            ILE.SetFilter(ILE."Remaining Quantity", '>=%1', Rec."Short Piece")
                        else
                            ILE.SetFilter(ILE."Remaining Quantity", '>%1', 0);
                        ILE.SetRange(ILE."Location Code", 'SYOSSET');
                        PAGE.Run(PAGE::"Item Ledger Entries", ILE);
                    end;
                }
                field(LocDAMAGEDSY1; LocDAMAGEDSY)
                {
                    ApplicationArea = All;
                    Caption = 'DAMAGEDSY';

                    trigger OnDrillDown()
                    var
                        ILE: Record "Item Ledger Entry";
                    begin
                        ILE.Reset;
                        ILE.SetCurrentKey("Item No.", "Entry Type");
                        ILE.SetRange(ILE."Item No.", Rec."No.");
                        ILE.SetFilter(ILE."Remaining Quantity", '>%1', 0);
                        ILE.SetRange(ILE."Location Code", 'DAMAGED SY');
                        PAGE.Run(PAGE::"Item Ledger Entries", ILE);
                    end;
                }
                field(LocGASTONIA1; LocGASTONIA)
                {
                    ApplicationArea = All;
                    Caption = 'GASTONIA';

                    trigger OnDrillDown()
                    var
                        ILE: Record "Item Ledger Entry";
                    begin
                        ILE.Reset;
                        ILE.SetCurrentKey("Item No.", "Entry Type");
                        ILE.SetRange(ILE."Item No.", Rec."No.");
                        ILE.SetFilter(ILE."Remaining Quantity", '>%1', 0);
                        ILE.SetRange(ILE."Location Code", 'GASTONIA');
                        PAGE.Run(PAGE::"Item Ledger Entries", ILE);
                    end;
                }
                field(BACKINGQTY; LocACF + LocPFI)
                {
                    ApplicationArea = All;
                    Caption = 'BACKING QTY';

                    trigger OnDrillDown()
                    var
                        ILE: Record "Item Ledger Entry";
                    begin
                        ILE.Reset;
                        ILE.SetCurrentKey("Item No.", "Entry Type");
                        ILE.SetRange(ILE."Item No.", Rec."No.");
                        ILE.SetFilter(ILE."Remaining Quantity", '>%1', 0);
                        ILE.SetFilter(ILE."Location Code", '%1|%2', 'ACF', 'PFI');
                        PAGE.Run(PAGE::"Item Ledger Entries", ILE);
                    end;
                }
                field(ActualQty; SYOSSETQTY + SAMPLINGQTY + GASTONIAQTY + ACFQTY + Rec."Qty. on Purch. Order" + TRANSITQTY - SalesOrderQty)
                {
                    ApplicationArea = All;
                    Caption = 'Actual Qty';
                }
                field(MonthSales7To12; (-1 * (MonthSales7To12)) + MasMonthSales7To12)
                {
                    ApplicationArea = All;
                    Caption = '7 To 12';
                }
                field(MonthSale13to24; (-1 * (MonthSale13to24)) + MasMonthSale13to24)
                {
                    ApplicationArea = All;
                    Caption = '13 To 24';
                }
                field(T6MonthSale; SalesOrderQty + (-1 * (MonthSales0To6)) + MasMonthSales0To6)
                {
                    ApplicationArea = All;
                    Caption = 'T 6M';
                }
            }
            part(SalesLine; "Sales Lines New")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
                SubPageView = WHERE("Document Type" = CONST(Order),
                                    "Outstanding Quantity" = FILTER(<> 0));
            }
            part(PurchaseLine; "Purchase Lines New")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
                SubPageView = WHERE("Document Type" = CONST(Order),
                                    "Outstanding Quantity" = FILTER(<> 0));
            }
            part(SalesInvLine; "Sales Invoice Line New")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
            }
        }
    }

    actions
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

        DReadyGoodsQty := ReadyGoodsQty1Trigger(Rec."No.");
        DShippedAir := ShippedAir;//("No.");
        DShippedBoat := ShippedBoat;//("No.");
        DBalanceQty := BalanceQty(Rec."No.");
        DShippingHold := ShippingHold(Rec."No.");
        DPriorityQty := PriorityQty(Rec."No.");



        if recVendor.Get(Rec."Vendor No.") then
            VendorName := recVendor."Name 2";

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




        ILE.Reset;
        ILE.SetCurrentKey("Item No.", "Entry Type");
        ILE.SetRange(ILE."Item No.", Rec."No.");
        ILE.SetRange(ILE."Entry Type", ILE."Entry Type"::Sale);
        ILE.SetFilter(ILE."Location Code", '<>%1', 'DAMAGED SY');
        if ILE.FindFirst then
            repeat
                if ILE."Posting Date" >= CalcDate('<-6M>', WorkDate) then
                    MonthSales0To6 += ILE.Quantity
                else
                    if ((ILE."Posting Date" >= CalcDate('<-1Y>', WorkDate)) and (ILE."Posting Date" < CalcDate('<-6M+1D>', WorkDate))) then
                        MonthSales7To12 += ILE.Quantity
                    else
                        if ((ILE."Posting Date" >= CalcDate('<-2Y>', WorkDate)) and (ILE."Posting Date" < CalcDate('<-1Y+1D>', WorkDate))) then
                            MonthSale13to24 += ILE.Quantity;
            until ILE.Next = 0;

        SYOSSETQTY := 0;
        GASTONIAQTY := 0;
        DAMAGEDSYQTY := 0;
        ShortPcs := 0;
        SAMPLINGQTY := 0;
        //TRANSITQTY:=0;
        ACFQTY := 0;
        ILE1.Reset;
        ILE1.SetCurrentKey("Item No.", "Entry Type");
        ILE1.SetRange(ILE1."Item No.", Rec."No.");
        ILE1.SetFilter(ILE1."Remaining Quantity", '>%1', 0);
        if ILE1.FindFirst then
            repeat
                //    IF NOT (ILE1."Quality Grade" IN [ILE1."Quality Grade"::B,ILE1."Quality Grade"::C,ILE1."Quality Grade"::D]) THEN BEGIN //sushant
                if ILE1."Remaining Quantity" >= Rec."Short Piece" then begin
                    if ILE1."Location Code" = 'SYOSSET' then
                        SYOSSETQTY += ILE1."Remaining Quantity"
                    else
                        if ILE1."Location Code" = 'GASTONIA' then
                            GASTONIAQTY += ILE1."Remaining Quantity"
                        else
                            if ILE1."Location Code" = 'DAMAGED SY' then
                                DAMAGEDSYQTY += ILE1."Remaining Quantity"

                            else
                                if ILE1."Location Code" = 'SAMPLING' then
                                    SAMPLINGQTY += ILE1."Remaining Quantity"

                                else
                                    ACFQTY += ILE1."Remaining Quantity";

                end else
                    if ILE1."Location Code" <> 'DAMAGED SY' then
                        ShortPcs += ILE1."Remaining Quantity";


            //END;  sushant comment this
            until ILE1.Next = 0;

        TRANSITQTY := 0;
        ILE.Reset;
        ILE.SetRange("Item No.", Rec."No.");
        ILE.SetFilter(ILE."Remaining Quantity", '>%1', 0);
        ILE.SetFilter(ILE."Location Code", '%1|%2', 'TRANSIT', 'TRANSIT2');
        if ILE.Find('-') then
            repeat
                TRANSITQTY += ILE."Remaining Quantity";
            until ILE.Next = 0;

        ACFQTY := ACFQTY - TRANSITQTY;

        // Mas2YrSales.Reset;
        // Mas2YrSales.SetRange(Mas2YrSales."Item No.", Rec."No.");
        // if Mas2YrSales.FindFirst then
        //     repeat
        //         if Mas2YrSales."Posting Date" >= CalcDate('<-6M>', WorkDate) then
        //             MasMonthSales0To6 += Mas2YrSales.Quantity
        //         else
        //             if ((Mas2YrSales."Posting Date" >= CalcDate('<-1Y>', WorkDate)) and (Mas2YrSales."Posting Date" < CalcDate('<-6M+1D>', WorkDate))) then
        //                 MasMonthSales7To12 += Mas2YrSales.Quantity
        //             else
        //                 if ((Mas2YrSales."Posting Date" >= CalcDate('<-2Y>', WorkDate)) and (Mas2YrSales."Posting Date" < CalcDate('<-1Y+1D>', WorkDate))) then
        //                     MasMonthSale13to24 += Mas2YrSales.Quantity;
        //     until Mas2YrSales.Next = 0;
        decShipQty := 0;
        decAirQty := 0;

        recTransferLine.Reset;
        recTransferLine.SetRange("Document No.", Rec."No.");
        recTransferLine.SetRange("Item No.", Rec."No.");
        if recTransferLine.Find('-') then begin
            repeat
                recTransferHeader.Get(recTransferLine."Document No.");
                if recTransferHeader."Ship Via" = 'SHIP' then
                    decShipQty += recTransferLine.Quantity - recTransferLine."Quantity Received"
                else
                    if recTransferHeader."Ship Via" = 'AIR' then
                        decAirQty += recTransferLine.Quantity - recTransferLine."Quantity Received"
            until recTransferLine.Next = 0;
        end;
        StrText := '';
        recSalesLine.Reset;
        recSalesLine.SetRange(recSalesLine."No.", Rec."No.");
        recSalesLine.SetFilter(recSalesLine.Comments, '<>%1', '');
        if recSalesLine.FindFirst then
            StrText := '  ~'//' ***';
    end;

    var
        //recProductGroup: Record "Product Group";
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
        recSalesLine.SetFilter(recSalesLine."Outstanding Quantity", '<>%1', 0);
        recSalesLine.SetFilter(recSalesLine."Location Code", '<>%1', 'DAMAGED SY');
        if recSalesLine.FindFirst then
            repeat
                SalesOrderQty += recSalesLine."Outstanding Quantity";
            until recSalesLine.Next = 0;
        exit(SalesOrderQty);
    end;

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

    procedure ReadyGoodsQty(): Decimal
    var
        RecPurchline: Record "Purchase Line";
        DecReadyGoodQty: Decimal;
    begin
        DecReadyGoodQty := 0;
        RecPurchline.Reset;
        RecPurchline.SetRange(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
        RecPurchline.SetRange(RecPurchline."No.", Rec."No.");
        RecPurchline.SetFilter(RecPurchline."Outstanding Quantity", '<>%1', 0);
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
        RecPurchline.SetFilter(RecPurchline."Outstanding Quantity", '<>%1', 0);
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
        RecPurchline.SetFilter(RecPurchline."Outstanding Quantity", '<>%1', 0);
        RecPurchline.SetFilter(RecPurchline."Shipped Boat", '<>%1', 0);
        if RecPurchline.FindFirst then
            repeat
                DecShippedBoatQty := DecShippedBoatQty + RecPurchline."Shipped Boat";
            until RecPurchline.Next = 0;
        exit(DecShippedBoatQty);
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

    procedure LocPFI(): Decimal
    var
        ILE: Record "Item Ledger Entry";
        ACFQTY: Decimal;
    begin
        ACFQTY := 0;
        ILE.Reset;
        ILE.SetRange("Item No.", Rec."No.");
        ILE.SetFilter(ILE."Remaining Quantity", '>%1', 0);
        ILE.SetFilter(ILE."Location Code", 'PFI');
        if ILE.Find('-') then
            repeat
                ACFQTY += ILE."Remaining Quantity";
            until ILE.Next = 0;
        exit(ACFQTY);
    end;

    procedure CFAQty(): Decimal
    var
        recSalesLine: Record "Sales Line";
        CFAQty: Decimal;
    begin
        CFAQty := 0;
        recSalesLine.Reset;
        recSalesLine.SetCurrentKey("Document Type", Type, "No.");
        recSalesLine.SetRange(recSalesLine."Document Type", recSalesLine."Document Type"::Quote);
        recSalesLine.SetRange(recSalesLine.Type, recSalesLine.Type::Item);
        recSalesLine.SetRange(recSalesLine."No.", Rec."No.");
        recSalesLine.SetFilter(recSalesLine."Outstanding Quantity", '<>%1', 0);
        recSalesLine.SetFilter(recSalesLine."Location Code", '<>%1', 'DAMAGED SY');
        if recSalesLine.FindFirst then
            repeat
                CFAQty += recSalesLine."Outstanding Qty. (Base)";
            until recSalesLine.Next = 0;
        exit(CFAQty);
    end;

    procedure Hold(): Decimal
    var
        RecPurchline: Record "Purchase Line";
        DecShippingHoldQty: Decimal;
    begin
        DecShippingHoldQty := 0;
        RecPurchline.Reset;
        RecPurchline.SetRange(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
        RecPurchline.SetRange(RecPurchline."No.", Rec."No.");
        RecPurchline.SetFilter(RecPurchline."Outstanding Quantity", '<>%1', 0);
        RecPurchline.SetFilter(RecPurchline."Shipping Hold", '<>%1', 0);
        if RecPurchline.FindFirst then
            repeat
                DecShippingHoldQty := DecShippingHoldQty + RecPurchline."Shipping Hold";
            until RecPurchline.Next = 0;
        exit(DecShippingHoldQty);
    end;

    procedure ReadyGoodsQty1Trigger(ItemNo: Code[20]): Decimal
    var
        RecPurchline: Record "Purchase Line";
        DecReadyGoodQty: Decimal;
    begin
        DecReadyGoodQty := 0;
        RecPurchline.Reset;
        RecPurchline.SetRange(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
        RecPurchline.SetRange(RecPurchline."No.", ItemNo);
        RecPurchline.SetFilter(RecPurchline."Ready Goods Qty", '<>%1', 0);
        if RecPurchline.FindFirst then
            repeat
                DecReadyGoodQty := DecReadyGoodQty + RecPurchline."Ready Goods Qty";
            until RecPurchline.Next = 0;
        exit(DecReadyGoodQty);
    end;

    procedure BalanceQty(ItemNo: Code[20]): Decimal
    var
        RecPurchline: Record "Purchase Line";
        DecBalanceQty: Decimal;
    begin
        DecBalanceQty := 0;
        RecPurchline.Reset;
        RecPurchline.SetRange(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
        RecPurchline.SetRange(RecPurchline."No.", ItemNo);
        RecPurchline.SetFilter(RecPurchline."Balance Qty", '<>%1', 0);
        if RecPurchline.FindFirst then
            repeat
                DecBalanceQty := DecBalanceQty + RecPurchline."Balance Qty";
            until RecPurchline.Next = 0;
        exit(DecBalanceQty);
    end;

    procedure ShippingHold(ItemNo: Code[20]): Decimal
    var
        RecPurchline: Record "Purchase Line";
        DecShippingHoldQty: Decimal;
    begin
        DecShippingHoldQty := 0;
        RecPurchline.Reset;
        RecPurchline.SetRange(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
        RecPurchline.SetRange(RecPurchline."No.", ItemNo);
        RecPurchline.SetFilter(RecPurchline."Shipping Hold", '<>%1', 0);
        if RecPurchline.FindFirst then
            repeat
                DecShippingHoldQty := DecShippingHoldQty + RecPurchline."Shipping Hold";
            until RecPurchline.Next = 0;
        exit(DecShippingHoldQty);
    end;

    procedure PriorityQty(ItemNo: Code[20]): Decimal
    var
        RecPurchline: Record "Purchase Line";
        DecPriorityQty: Decimal;
    begin
        DecPriorityQty := 0;
        RecPurchline.Reset;
        RecPurchline.SetRange(RecPurchline."Document Type", RecPurchline."Document Type"::Order);
        RecPurchline.SetRange(RecPurchline."No.", ItemNo);
        RecPurchline.SetFilter(RecPurchline."Priority Qty", '<>%1', 0);
        if RecPurchline.FindFirst then
            repeat
                DecPriorityQty := DecPriorityQty + RecPurchline."Priority Qty";
            until RecPurchline.Next = 0;
        exit(DecPriorityQty);
    end;

    procedure BinCode(): Code[20]
    var
        BinContent: Record "Bin Content";
        BinCode: Code[20];
    begin
        BinCode := '';
        BinContent.Reset;
        BinContent.SetRange("Item No.", Rec."No.");
        if BinContent.FindFirst then
            BinCode := BinContent."Bin Code";
        exit(BinCode);
    end;
}

