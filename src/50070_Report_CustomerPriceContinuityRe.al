report 50070 "Customer Price & Continuity Re"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50070_Report_CustomerPriceContinuityRe.rdlc';
    Caption = 'Customer Price & Continuity Report';

    dataset
    {
        dataitem("Item Reference"; "Item Reference")
        {
            DataItemTableView = SORTING("Item No.", "Variant Code", "Unit of Measure", "Reference Type", "Reference Type No.", "Reference No.") WHERE("Reference Type" = FILTER(Customer));
            RequestFilterFields = "Reference Type", "Reference Type No.", "Item No.";
            column(Cross_Reference_Type; "Item Reference"."Reference Type")
            {
            }
            column(Customer_No; "Item Reference"."Reference Type No.")
            {
            }
            column(CustomerName; CustomerName)
            {
            }
            column(Description; "Item Reference".Description)
            {
            }
            column(Palcement_Start_Date; FORMAT("Item Reference"."Palcement Start Date"))
            {
            }
            column(Placement_End_Date; FORMAT("Item Reference"."Placement End Date"))
            {
            }
            column(Item_No; "Item Reference"."Item No.")
            {
            }
            column(Product_Group_Code; ProductGroupCode)
            {
            }
            column(ActualQty; SYOSSETQTY + SAMPLINGQTY + GASTONIAQTY + ACFQTY + Item."Qty. on Purch. Order" + TRANSITQTY - SalesOrderQty)
            {
            }
            column(MonthSale13to24; -1 * (MonthSale13to24))
            {
            }
            column(MonthSales7To12; -1 * (MonthSales7To12))
            {
            }
            column(MonthSales0To6; -1 * (MonthSales0To6))
            {
            }
            column(T6MonthSale; SalesOrderQty + (-1 * MonthSales0To6))
            {
            }
            column(Customer_Price; CustomerPrice)
            {
            }
            column(Cust_Group_Price; CustGroupPrice)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CustomerName := '';
                IF recCustomer.GET("Reference Type No.") THEN;
                CustomerName := recCustomer.Name;

                ProductGroupCode := '';
                IF Item.GET("Item No.") THEN;
                ProductGroupCode := Item."Item Category Code";
                Item.CALCFIELDS("Qty. on Purch. Order");

                //Price BEGIN
                // SalesPriceCalcMgt.FindSalesPrice(
                //       TempSalesPrice, "Item Reference Type No.", '',
                //       recCustomer."Customer Price Group", '', "Item No.", "Variant Code", Item."Base Unit of Measure",
                //       '', TODAY, FALSE, Item."Item Category Code", '');

                CustomerPrice := 0;
                IF TempSalesPrice.FINDFIRST THEN BEGIN
                    CustomerPrice := TempSalesPrice."Unit Price";
                END;

                CustGroupPrice := 0;
                recCust.GET("Reference Type No.");
                recSalesPrice.RESET;
                recSalesPrice.SETRANGE("Source Type", recSalesPrice."Source Type"::"Customer Price Group");
                recSalesPrice.SETRANGE("Source No.", recCust."Customer Price Group");
                recSalesPrice.SETRANGE("Asset No.", "Item Reference"."Item No.");
                IF recSalesPrice.FINDSET THEN BEGIN
                    REPEAT
                        CustGroupPrice := recSalesPrice."Unit Price";
                    UNTIL recSalesPrice.NEXT = 0;

                    IF CustGroupPrice = 0 THEN BEGIN
                        recSalesPrice.RESET;
                        recSalesPrice.SETRANGE("Source Type", recSalesPrice."Source Type"::"Customer Price Group");
                        recSalesPrice.SETRANGE("Source No.", recCust."Customer Price Group");
                        recSalesPrice.SETRANGE("Product Type", recSalesPrice."Product Type"::"Item Category");
                        recSalesPrice.SETRANGE("Asset No.", Item."Item Category Code");
                        IF recSalesPrice.FINDSET THEN BEGIN
                            REPEAT
                                CustGroupPrice := recSalesPrice."Unit Price";
                            UNTIL recSalesPrice.NEXT = 0;
                        END;
                    END;
                END;
                //Price END

                MonthSale13to24 := 0;
                MonthSales7To12 := 0;
                MonthSales0To6 := 0;
                ILE.RESET;
                ILE.SETCURRENTKEY("Item No.", "Entry Type");
                ILE.SETRANGE("Item No.", "Item Reference"."Item No.");
                ILE.SETRANGE("Entry Type", ILE."Entry Type"::Sale);
                ILE.SETFILTER("Location Code", '<>%1', 'DAMAGED SY');
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

                ACFQTY := 0;
                SYOSSETQTY := 0;
                GASTONIAQTY := 0;
                DAMAGEDSYQTY := 0;
                ShortPcs := 0;
                SAMPLINGQTY := 0;
                ILE1.RESET;
                ILE1.SETCURRENTKEY("Item No.", "Entry Type");
                ILE1.SETRANGE("Item No.", "Item Reference"."Item No.");
                ILE1.SETFILTER("Remaining Quantity", '>%1', 0);
                IF ILE1.FINDFIRST THEN
                    REPEAT
                        IF ILE1."Remaining Quantity" >= Item."Short Piece" THEN BEGIN
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
                    UNTIL ILE1.NEXT = 0;

                TRANSITQTY := 0;
                ILE.RESET;
                ILE.SETRANGE("Item No.", "Item Reference"."Item No.");
                ILE.SETFILTER("Remaining Quantity", '>%1', 0);
                ILE.SETFILTER("Location Code", '%1|%2', 'TRANSIT', 'TRANSIT2');
                IF ILE.FIND('-') THEN
                    REPEAT
                        TRANSITQTY += ILE."Remaining Quantity";
                    UNTIL ILE.NEXT = 0;
                ACFQTY := ACFQTY - TRANSITQTY;

                SalesOrderQty := 0;
                recSalesLine.RESET;
                recSalesLine.SETCURRENTKEY("Document Type", Type, "No.");
                recSalesLine.SETRANGE("Document Type", recSalesLine."Document Type"::Order);
                recSalesLine.SETRANGE(Type, recSalesLine.Type::Item);
                recSalesLine.SETRANGE("No.", "Item Reference"."Item No.");
                recSalesLine.SETFILTER("Location Code", '<>%1', 'DAMAGED SY');
                IF recSalesLine.FINDFIRST THEN
                    REPEAT
                        SalesOrderQty += recSalesLine."Outstanding Qty. (Base)";
                    UNTIL recSalesLine.NEXT = 0;
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
    }

    var
        ProductGroupCode: Code[20];
        CustomerPrice: Decimal;
        CustGroupPrice: Decimal;
        Item: Record Item;
        ILE: Record "Item Ledger Entry";
        MonthSale13to24: Decimal;
        MonthSales7To12: Decimal;
        MonthSales0To6: Decimal;
        SYOSSETQTY: Decimal;
        GASTONIAQTY: Decimal;
        DAMAGEDSYQTY: Decimal;
        SAMPLINGQTY: Decimal;
        ACFQTY: Decimal;
        ShortPcs: Decimal;
        TRANSITQTY: Decimal;
        ILE1: Record "Item Ledger Entry";
        recSalesLine: Record "Sales Line";
        SalesOrderQty: Decimal;
        CustomerName: Text;
        recCustomer: Record Customer;
        recCust: Record Customer;
        recSalesPrice: Record "Price List Line";
        AnySalesPriceFound: Boolean;
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        TempSalesPrice: Record "Price List Line" temporary;
}

