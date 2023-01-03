report 50009 "Item Last Sold"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50009_Report_ItemLastSold.rdlc';

    dataset
    {
        dataitem(Item; Item)
        {
            CalcFields = Inventory;
            PrintOnlyIfDetail = true;
            column(No_Item; Item."No.")
            {
            }
            column(Description_Item; Item.Description)
            {
            }
            column(CustomerNo; CustomerNo)
            {
            }
            column(CustomerName; CustomerName)
            {
            }
            column(PostingDate; FORMAT(PostingDate))
            {
            }
            column(LastSoldQty; LastSoldQty)
            {
            }
            column(LastSoldRate; LastSoldRate)
            {
            }
            column(Inventory_Item; Inventory)
            {
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = FIELD("No.");
                DataItemTableView = SORTING("Item No.", "Posting Date") ORDER(Ascending) WHERE("Remaining Quantity" = FILTER(<> 0));
                column(LocationCode_ItemLedgerEntry; "Location Code")
                {
                }
                column(LotNo_ItemLedgerEntry; "Lot No.")
                {
                }
                column(RemainingQuantity_ItemLedgerEntry; "Remaining Quantity")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                PostingDate := 0D;
                LastSoldQty := 0;
                LastSoldRate := 0;
                CustomerName := '';
                CustomerNo := '';
                ShowItemLine := FALSE;
                recSalesInvLine.RESET;
                recSalesInvLine.SETCURRENTKEY("Posting Date");
                recSalesInvLine.SETRANGE(recSalesInvLine."No.", "No.");
                recSalesInvLine.SETFILTER(recSalesInvLine.Quantity, '<>%1', 0);
                IF recSalesInvLine.FINDLAST THEN BEGIN
                    ShowItemLine := TRUE;
                    CustomerNo := recSalesInvLine."Sell-to Customer No.";
                    PostingDate := recSalesInvLine."Posting Date";
                    LastSoldQty := recSalesInvLine.Quantity;
                    LastSoldRate := recSalesInvLine."Unit Price";
                    IF recCustomer.GET(recSalesInvLine."Sell-to Customer No.") THEN
                        CustomerName := recCustomer.Name;
                END;

                IF NOT ShowItemLine THEN
                    CurrReport.SKIP;
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
        lblItemNo = 'Item No.';
        lblDescription = 'Description';
        lblCustomerNo = 'Customer No.';
        lblCustimerName = 'Customer Name';
        lblLastSoldDate = 'Last Sold Date';
        lblLastSoldQty = 'Last Sold Qty.';
        lblLastSoldRate = 'Last Sold Rate';
        lblLocationCode = 'Location Code';
        lblLotNo = 'Lot No.';
        lblQuantity = 'Quantity';
        lblTotal = 'Total';
        iblInventory = 'Inventory';
    }

    var
        recSalesInvLine: Record "Sales Invoice Line";
        recCustomer: Record Customer;
        CustomerName: Text[50];
        CustomerNo: Code[10];
        PostingDate: Date;
        LastSoldQty: Decimal;
        LastSoldRate: Decimal;
        ShowItemLine: Boolean;
}

