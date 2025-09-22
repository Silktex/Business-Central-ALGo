report 70006 "Open SO Report POSH"
{
    DefaultLayout = RDLC;
    RDLCLayout = './POSH Report/70006_Report_OpenSOReport.rdlc';
    Caption = 'Open SO Report';
    Description = 'Open SO Report';
    EnableHyperlinks = true;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") ORDER(Ascending) WHERE("Document Type" = CONST(Order));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Order Date";
            RequestFilterHeading = 'Sales Header';
            column(SalesHeader_No; "Sales Header"."No.")
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            { }
            column(SalesHeader_OrderDate; FORMAT("Sales Header"."Order Date"))
            {
            }
            column(SalesHeader_BiltoNane; "Sales Header"."Bill-to Name")
            {
            }
            column(SalesHeader_ExternalDocumentNo; "Sales Header"."External Document No.")
            {
            }
            column(SalesHeader_ShippingAgentCode; "Sales Header"."Shipping Agent Code")
            {
            }
            column(SalesHeader_CampaignNo; "Sales Header"."Campaign No.")
            {
            }
            column(SalesHeader_Priority; "Sales Header".Priority)
            {
            }
            column(Project_Name; "Sales Header"."Project Name")
            {
            }
            column(Salesperson_Code; "Sales Header"."Salesperson Code")
            {
            }
            column(Specifier_Name; SpecifierName)
            {
            }
            column(Specifier_Location_Code; SpecifierCustomerLocation)
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE(Quantity = FILTER(<> 0), "Outstanding Quantity" = FILTER(<> 0), Type = FILTER(Item));
                RequestFilterFields = "No.";
                column(SalesLine_PromiseDate; FORMAT("Sales Line"."Promised Delivery Date"))
                {
                }
                column(SalesLine_No; "Sales Line"."No.")
                {
                }
                column(SalesLine_Quantity; SOQuantity)
                {
                }
                column(SalesLine_OutstandingQty_Base; SOQuantityRem)
                {
                }
                column(TotalInv; SYOSSETQTY + GASTONIAQTY + ACFQTY + SAMPLINGQTY + PFIQty)
                {
                }
                column(InventoryQty; SYOSSETQTY + GASTONIAQTY + SAMPLINGQTY)
                {
                }
                column(FinishingQty; ACFQTY + PFIQty)
                {
                }
                column(POQuantity; POQuantity)
                {
                }
                column(Divi; Divi)
                {
                }
                column(Total; Total)
                {
                }
                column(itemDesc; itemDesc)
                {
                }
                column(SalesHeader_LocationCode; "Sales Line"."Location Code")
                {
                }
                column(TRANSITQTY; TRANSITQTY)
                {
                }
                column(Priority_SalesLine; "Sales Line".Priority)
                {
                }
                column(Comments_SalesLine; "Sales Line".Comments)
                {
                }
                column(LineNo_SalesLine; "Sales Line"."Line No.")
                {
                }
                column(SalesHeader_ExpiryDate; "Sales Header"."Expiry Date")
                {
                }
                column(Negative; ((TRANSITQTY + SYOSSETQTY + GASTONIAQTY + ACFQTY + SAMPLINGQTY + PFIQty) - QtyOS))
                {
                }
                column(Drop; blDrop)
                {
                }

                trigger OnAfterGetRecord()
                var
                    recCustomer: Record Customer;
                begin
                    ///

                    SYOSSETQTY := 0;
                    GASTONIAQTY := 0;
                    DAMAGEDSYQTY := 0;
                    ShortPcs := 0;
                    SAMPLINGQTY := 0;
                    ACFQTY := 0;
                    SOQuantity := 0;
                    SOQuantityRem := 0;
                    PFIQty := 0;

                    recItem1.GET("No.");
                    recItem1.CALCFIELDS("Qty. on Purch. Order");
                    POQuantity := recItem1."Qty. on Purch. Order";

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
                                                    IF ILE1."Location Code" = 'PFI' THEN
                                                        PFIQty += ILE1."Remaining Quantity"
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



                    //POQuantity := QuantityOnPO("No.","Variant Code","Location Code");
                    //IF ExpShortPcs THEN
                    //TotalInv := QtyInHand1("No.","Variant Code","Location Code")
                    //ELSE
                    //TotalInv := QtyInHand("No.","Variant Code","Location Code");

                    SOQuantity := QuantityOnSO("Document No.", "No.", "Line No.", "Variant Code", "Location Code");
                    SOQuantityRem := QuantityOnSORem("Document No.", "No.", "Line No.", "Variant Code", "Location Code");

                    IF recCustomer.GET("Sell-to Customer No.") THEN
                        Divi := recCustomer."Customer Posting Group";
                    IF recItem.GET("No.") THEN BEGIN
                        itemDesc := recItem.Description;
                        blDrop := recItem.Drop;
                    END;
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
                    recILE.SETRANGE("Item No.", "Sales Line"."No.");
                    recILE.SETFILTER("Remaining Quantity", '>%1', 0);
                    recILE.SETFILTER("Location Code", '%1|%2', 'TRANSIT', 'TRANSIT2');
                    IF recILE.FIND('-') THEN
                        REPEAT
                            TRANSITQTY += recILE."Remaining Quantity";
                        UNTIL recILE.NEXT = 0;


                    QtyOS := QuantityOnSORem1("No.", "Variant Code", "Location Code");

                    SpecifierCustomerLocation := '';
                    SpecifierName := '';
                    SpecifierCustomer.RESET;
                    SpecifierCustomer.SETRANGE("No.", "Sales Header".Specifier);
                    IF SpecifierCustomer.FINDFIRST THEN BEGIN
                        SpecifierCustomerLocation := SpecifierCustomer.City + ', ' + SpecifierCustomer.County;
                        SpecifierName := SpecifierCustomer.Name;
                    END;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    Caption = 'Option';
                    field(Total; Total)
                    {
                        Caption = 'Show Total';
                        ApplicationArea = all;
                    }
                    field(Explocation; Explocation)
                    {
                        Caption = 'Exclude Location';
                        TableRelation = Location.Code;
                        ApplicationArea = all;
                    }
                    field(ExpShortPcs; ExpShortPcs)
                    {
                        Caption = 'No Short Pcs';
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
            //ExpShortPcs := TRUE;
            Explocation := 'DAMAGED SY';
        end;
    }

    labels
    {
        SO = 'Sales Order';
        OrdDate = 'Order Date';
        ShipDate = 'Ship Date';
        CustName = 'Customer Name';
        ItemCode = 'Item Code';
        OrderQty = 'Ordered (Qty)';
        Balance = 'Balance';
        OnHand = 'Total Inventory';
        POQty = 'On PO (Qty.)';
        Div = 'Division';
        CustPoNo = 'Cust. PO No.';
        ShipVia = 'Ship Via';
        Whse = 'Whse';
        ItmDescrtxt = 'Description';
        lblInventory = 'Inventory';
        lblFinishing = 'Finishing';
    }

    var
        recItem: Record Item;
        TotalInv: Decimal;
        POQuantity: Decimal;
        SOQuantity: Decimal;
        SOQuantityRem: Decimal;
        Divi: Text[50];
        Detail: Boolean;
        Total: Boolean;
        Both: Boolean;
        itemDesc: Text[100];
        Explocation: Code[50];
        ExpShortPcs: Boolean;
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
        PFIQty: Decimal;
        ILE1: Record "Item Ledger Entry";
        ILE: Record "Item Ledger Entry";
        TRANSITQTY1: Decimal;
        recItem1: Record Item;
        QtyOS: Decimal;
        blDrop: Boolean;
        SpecifierCustomerLocation: Text;
        SpecifierName: Text;
        SpecifierCustomer: Record Customer;

    procedure QuantityOnPO(ItemNo: Code[20]; VarrientCode: Code[20]; LocationCode: Code[20]): Decimal
    var
        recPurchaseLine: Record "Purchase Line";
        PurchQty: Decimal;
    begin
        PurchQty := 0;
        recPurchaseLine.RESET;
        recPurchaseLine.SETCURRENTKEY("Document Type", Type, "No.");
        recPurchaseLine.SETRANGE(recPurchaseLine."Document Type", recPurchaseLine."Document Type"::Order);
        recPurchaseLine.SETRANGE(recPurchaseLine.Type, recPurchaseLine.Type::Item);
        recPurchaseLine.SETRANGE(recPurchaseLine."No.", ItemNo);
        recPurchaseLine.SETRANGE(recPurchaseLine."Variant Code", VarrientCode);
        recPurchaseLine.SETRANGE(recPurchaseLine."Location Code", LocationCode);
        IF recPurchaseLine.FINDFIRST THEN
            REPEAT
                PurchQty += recPurchaseLine."Outstanding Qty. (Base)";
            UNTIL recPurchaseLine.NEXT = 0;
        EXIT(PurchQty);
    end;


    procedure QuantityOnSO(DocNo: Code[20]; ItemNo: Code[20]; LineNo: Integer; VarrientCode: Code[20]; LocationCode: Code[20]): Decimal
    var
        recSalesLine: Record "Sales Line";
        SoQty: Decimal;
    begin
        SoQty := 0;
        recSalesLine.RESET;
        recSalesLine.SETCURRENTKEY("Document Type", Type, "No.");
        recSalesLine.SETRANGE(recSalesLine."Document Type", recSalesLine."Document Type"::Order);
        recSalesLine.SETRANGE(recSalesLine."Document No.", DocNo);
        recSalesLine.SETRANGE(recSalesLine.Type, recSalesLine.Type::Item);
        recSalesLine.SETRANGE(recSalesLine."No.", ItemNo);
        recSalesLine.SETRANGE(recSalesLine."Line No.", LineNo);
        recSalesLine.SETRANGE(recSalesLine."Variant Code", VarrientCode);
        recSalesLine.SETRANGE(recSalesLine."Location Code", LocationCode);
        IF recSalesLine.FINDFIRST THEN
            REPEAT
                SoQty += recSalesLine.Quantity;
            UNTIL recSalesLine.NEXT = 0;
        EXIT(SoQty);
    end;


    procedure QuantityOnSORem(DocNo: Code[20]; ItemNo: Code[20]; LineNo: Integer; VarrientCode: Code[20]; LocationCode: Code[20]): Decimal
    var
        recSalesLine: Record "Sales Line";
        SoQty: Decimal;
    begin
        SoQty := 0;
        recSalesLine.RESET;
        recSalesLine.SETCURRENTKEY("Document Type", Type, "No.");
        recSalesLine.SETRANGE(recSalesLine."Document Type", recSalesLine."Document Type"::Order);
        recSalesLine.SETRANGE(recSalesLine."Document No.", DocNo);
        recSalesLine.SETRANGE(recSalesLine.Type, recSalesLine.Type::Item);
        recSalesLine.SETRANGE(recSalesLine."No.", ItemNo);
        recSalesLine.SETRANGE(recSalesLine."Line No.", LineNo);
        recSalesLine.SETRANGE(recSalesLine."Variant Code", VarrientCode);
        recSalesLine.SETRANGE(recSalesLine."Location Code", LocationCode);
        IF recSalesLine.FINDFIRST THEN
            REPEAT
                SoQty += recSalesLine."Outstanding Qty. (Base)";
            UNTIL recSalesLine.NEXT = 0;
        EXIT(SoQty);
    end;


    procedure QtyInHand(ItemNo: Code[20]; VarientCode: Code[20]; LocationCode: Code[20]): Decimal
    var
        recILE: Record "Item Ledger Entry";
        ILEQty: Decimal;
    begin
        TotalInv := 0;
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
                ILEQty += recILE."Remaining Quantity";
            UNTIL recILE.NEXT = 0;
        EXIT(ILEQty);
    end;


    procedure QtyInHand1(ItemNo: Code[20]; VarientCode: Code[20]; LocationCode: Code[20]): Decimal
    var
        recILE: Record "Item Ledger Entry";
        ILEQty: Decimal;
        Itemrec: Record Item;
    begin
        TotalInv := 0;
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


    procedure QuantityOnSORem1(ItemNo: Code[20]; VarrientCode: Code[20]; LocationCode: Code[20]): Decimal
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
        //recSalesLine.SETRANGE(recSalesLine."Variant Code",VarrientCode);
        //recSalesLine.SETRANGE(recSalesLine."Location Code",LocationCode);
        IF recSalesLine.FINDFIRST THEN
            REPEAT
                SoQty += recSalesLine."Outstanding Qty. (Base)";
            UNTIL recSalesLine.NEXT = 0;
        EXIT(SoQty);
    end;
}

