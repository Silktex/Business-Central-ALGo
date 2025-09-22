report 50228 "Shipped Sample Order Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50228_Report_ShippedSampleOrderReport.rdlc';
    Caption = 'Shipped Sample Order Report';
    Description = 'Open SO Report';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") ORDER(Ascending) WHERE("Document Type" = CONST(Order));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Salesperson Code", "No.", "Order Date";
            RequestFilterHeading = 'Sales Header';
            column("Filter"; 'Sample from ' + FORMAT(WORKDATE - 7) + ' to ' + FORMAT(WORKDATE - 1))
            {
            }
            column(SalesHeader_Salesperson_Code; "Sales Header"."Salesperson Code")
            {
            }
            column(Salesperson_Name; SalespersonName)
            {
            }
            column(SalesHeader_Customer_Code; "Sales Header"."Sell-to Customer No.")
            {
            }
            column(SalesHeader_Customer_Name; "Sales Header"."Sell-to Customer Name")
            {
            }
            column(SalesHeader_Order_No; "Sales Header"."No.")
            {
            }
            column(SalesHeader_Externa_Document_No; "Sales Header"."External Document No.")
            {
            }
            column(SalesHeader_Order_Date; FORMAT("Sales Header"."Order Date"))
            {
            }
            column(SalesHeader_Ship_Date; FORMAT("Sales Header"."Shipment Date"))
            {
            }
            column(SalesHeader_Tracking_No; "Sales Header"."Tracking No.")
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE(Quantity = FILTER(<> 0), "Outstanding Quantity" = FILTER(<> 0), Type = FILTER(Item));
                column(SalesLine_Order_Date; FORMAT("Sales Header"."Order Date"))
                {
                }
                column(SalesLine_Quantity; SOQuantity)
                {
                }
                column(SalesLine_OutstandingQty_Base; SOQuantityRem)
                {
                }
                column(TotalInv; TotalInv)
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
                column(Item_Code; "Sales Line"."No.")
                {
                }
                column(itemDesc; itemDesc)
                {
                }

                trigger OnAfterGetRecord()
                var
                    recCustomer: Record Customer;
                begin
                    POQuantity := QuantityOnPO("No.", "Variant Code", "Location Code");
                    IF ExpShortPcs THEN
                        TotalInv := QtyInHand1("No.", "Variant Code", "Location Code")
                    ELSE
                        TotalInv := QtyInHand("No.", "Variant Code", "Location Code");

                    SOQuantity := QuantityOnSO("Document No.", "No.", "Variant Code", "Location Code");
                    SOQuantityRem := QuantityOnSORem("Document No.", "No.", "Variant Code", "Location Code");

                    IF recCustomer.GET("Sell-to Customer No.") THEN
                        Divi := recCustomer."Customer Posting Group";
                    IF recItem.GET("No.") THEN
                        itemDesc := recItem.Description;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                SalespersonName := '';
                recSalesperson.RESET;
                recSalesperson.SETRANGE(recSalesperson.Code, "Sales Header"."Salesperson Code");
                IF recSalesperson.FINDFIRST THEN
                    SalespersonName := recSalesperson.Name;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Order Date", WORKDATE - 7, WORKDATE - 1);
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
        SO = 'Sales Order';
        OrdDate = 'Order Date';
        ShipDate = 'Ship Date';
        CustName = 'Customer Name';
        ItemCode = 'Item Code';
        OrderQty = 'Ordered (Qty)';
        Balance = 'Balance';
        OnHand = 'Inventory';
        POQty = 'On PO (Qty.)';
        Div = 'Division';
        CustPoNo = 'Cust. PO No.';
        ShipVia = 'Ship Via';
        Whse = 'Whse';
        ItmDescrtxt = 'Description';
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
        SalespersonName: Text[50];
        recSalesperson: Record "Salesperson/Purchaser";


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


    procedure QuantityOnSO(DocNo: Code[20]; ItemNo: Code[20]; VarrientCode: Code[20]; LocationCode: Code[20]): Decimal
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
        recSalesLine.SETRANGE(recSalesLine."Variant Code", VarrientCode);
        recSalesLine.SETRANGE(recSalesLine."Location Code", LocationCode);
        IF recSalesLine.FINDFIRST THEN
            REPEAT
                SoQty += recSalesLine.Quantity;
            UNTIL recSalesLine.NEXT = 0;
        EXIT(SoQty);
    end;


    procedure QuantityOnSORem(DocNo: Code[20]; ItemNo: Code[20]; VarrientCode: Code[20]; LocationCode: Code[20]): Decimal
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
}

