report 50036 "Open Return PO Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50036_Report_OpenReturnPOReport.rdlc';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") ORDER(Ascending) WHERE("Document Type" = FILTER("Return Order"));
            PrintOnlyIfDetail = true;
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
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE(Quantity = FILTER(<> 0), "Outstanding Quantity" = FILTER(<> 0));
                RequestFilterFields = "Order Date";
                column(DueDate_PurchaseHeader; "Purchase Line"."Requested Receipt Date")
                {
                }
                column(OrderDate_PurchaseHeader; "Purchase Line"."Order Date")
                {
                }
                column(DocumentNo_PurchaseLine; "Purchase Line"."Document No.")
                {
                }
                column(No_PurchaseLine; "Purchase Line"."No.")
                {
                }
                column(Description_PurchaseLine; "Purchase Line".Description)
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
                column(ItemDesc; ItemDesc)
                {
                }
                column(RedyGoodsQty; ItemDesc)
                {
                }
                column(TRANSIT; TRANSITQTY)
                {
                }
                column(DirectUnitCost; "Purchase Line"."Direct Unit Cost")
                {
                }
                column(Amount; "Purchase Line".Amount)
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

                    IF recItem1.GET("No.") THEN;

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
                    ILE.SETFILTER(ILE."Location Code", '%1|%2', 'TRANSIT', 'TRANSIT2');
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

                    SOQty := QuantityOnSO("No.", "Variant Code", "Location Code");
                    POQuantity := QuantityOnPO("Document No.", "No.", "Variant Code", "Location Code");
                    POQuantityRec := QuantityOnPORec("Document No.", "No.", "Variant Code", "Location Code");
                    POQuantityBkOrder := QuantityOnPOBkOrd("Document No.", "No.", "Variant Code", "Location Code");
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
                    recILE.SETRANGE("Dylot No.", "Purchase Line"."Document No.");
                    recILE.SETFILTER("Remaining Quantity", '>%1', 0);
                    recILE.SETFILTER("Location Code", '%1|%2', 'TRANSIT', 'TRANSIT2');
                    IF recILE.FIND('-') THEN
                        REPEAT
                            TRANSITQTY += recILE."Remaining Quantity";
                        UNTIL recILE.NEXT = 0;
                end;
            }

            trigger OnPreDataItem()
            begin
                //SETRANGE("Purchase Header"."Document Type",DocType);
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
                        ApplicationArea = all;
                        Visible = false;
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
        lblUnitCost = 'Price';
        lblAmount = 'Amount';
    }

    var
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


    procedure QuantityOnPO(PoNo: Code[20]; ItemNo: Code[20]; VarrientCode: Code[20]; LocationCode: Code[20]): Decimal
    var
        recPurchaseLine: Record "Purchase Line";
        PurchQty: Decimal;
    begin
        PurchQty := 0;
        recPurchaseLine.RESET;
        recPurchaseLine.SETCURRENTKEY("Document Type", Type, "No.");
        recPurchaseLine.SETRANGE(recPurchaseLine."Document Type", recPurchaseLine."Document Type"::"Return Order");
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
        recPurchaseLine.SETRANGE(recPurchaseLine."Document Type", recPurchaseLine."Document Type"::"Return Order");
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
        recPurchaseLine.SETRANGE(recPurchaseLine."Document Type", recPurchaseLine."Document Type"::"Return Order");
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


    procedure QuantityOnSO(ItemNo: Code[20]; VarrientCode: Code[20]; LocationCode: Code[20]): Decimal
    var
        recSalesLine: Record "Sales Line";
        SoQty: Decimal;
    begin
        SoQty := 0;
        recSalesLine.RESET;
        recSalesLine.SETCURRENTKEY("Document Type", Type, "No.");
        recSalesLine.SETRANGE(recSalesLine."Document Type", recSalesLine."Document Type"::"Return Order");
        recSalesLine.SETRANGE(recSalesLine.Type, recSalesLine.Type::Item);
        recSalesLine.SETRANGE(recSalesLine."No.", ItemNo);
        recSalesLine.SETRANGE(recSalesLine."Variant Code", VarrientCode);
        recSalesLine.SETRANGE(recSalesLine."Location Code", LocationCode);
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
}

