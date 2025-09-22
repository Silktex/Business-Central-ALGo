report 50023 "Reorder Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50023_Report_ReorderReport.rdlc';
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
            column(ProdLine; ProdLine)
            {
            }
            column(Inventory_Item; Inventory)
            {
            }
            column(QtyonPurchOrder_Item; "Qty. on Purch. Order")
            {
            }
            column(QtyonSalesOrder_Item; "Qty. on Sales Order")
            {
            }
            column(AvailQty; (Inventory - "Qty. on Sales Order"))
            {
            }
            column(ActualQty; (Inventory + "Qty. on Sales Order" + "Qty. on Purch. Order"))
            {
            }
            column(VendorName; VendorName)
            {
            }
            column(MonthSales12; ABS(MonthSales12))
            {
            }
            column(MonthSales6; ABS(MonthSales6))
            {
            }
            column(T6MonthSale; "Qty. on Sales Order" + ABS(MonthSales6))
            {
            }
            column(ActualRequirement; (Inventory + "Qty. on Sales Order" + "Qty. on Purch. Order") - ("Qty. on Sales Order" + ABS(MonthSales6)))
            {
            }
            column(DROP; Item.Drop)
            {
            }

            trigger OnAfterGetRecord()
            begin
                MonthSales12 := 0;
                MonthSales6 := 0;
                VendorName := '';
                ProdLine := '';

                recProductGroup.RESET;
                recProductGroup.SETRANGE(recProductGroup.Code, "Item Category Code");
                IF recProductGroup.FINDFIRST THEN
                    ProdLine := recProductGroup.Description;

                IF recVendor.GET("Vendor No.") THEN
                    VendorName := recVendor.Name;
                ILE.RESET;
                ILE.SETRANGE(ILE."Item No.", "No.");
                ILE.SETRANGE(ILE."Entry Type", ILE."Entry Type"::Sale);
                IF ILE.FINDFIRST THEN
                    REPEAT
                        IF ILE."Posting Date" >= MDate12 THEN
                            MonthSales12 += ILE.Quantity;

                        IF ILE."Posting Date" >= MDate6 THEN
                            MonthSales6 += ILE.Quantity;
                    UNTIL ILE.NEXT = 0;
            end;

            trigger OnPreDataItem()
            begin
                MDate12 := CALCDATE('<-1Y>', WORKDATE);
                MDate6 := CALCDATE('<-6M>', WORKDATE);
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
        Item12MonthSaleCap = '12 Month Sale';
        Item6MonthSaleCap = '6 Month Sale';
        ItemT6MonthSaleCap = 'T 6 Month Sale';
        ItemActualReqCap = 'Actual Requirement';
        ItemTotalOrderCap = 'Total Order';
    }

    var
        recProductGroup: Record "Item Category";
        ILE: Record "Item Ledger Entry";
        ProdLine: Text[100];
        recVendor: Record Vendor;
        VendorName: Text[100];
        MonthSales12: Decimal;
        MonthSales6: Decimal;
        MDate12: Date;
        MDate6: Date;
}

