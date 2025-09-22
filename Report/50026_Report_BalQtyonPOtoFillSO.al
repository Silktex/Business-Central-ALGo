report 50026 "Bal Qty on PO to Fill SO"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50026_Report_BalQtyonPOtoFillSO.rdlc';
    Caption = 'Bal Qty on PO to Fill SO';

    dataset
    {
        dataitem("Purchase Line"; "Purchase Line")
        {
            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE(Type = FILTER(Item), "Outstanding Quantity" = FILTER(0));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Document No.", "Buy-from Vendor No.";
            column(LineNo_PurchaseLine; "Purchase Line"."Line No.")
            {
            }
            column(No_PurchaseLine; "Purchase Line"."No.")
            {
            }
            column(UnitofMeasure_PurchaseLine; "Purchase Line"."Unit of Measure")
            {
            }
            column(QuantityReceived_PurchaseLine; "Purchase Line"."Quantity Received")
            {
            }
            column(ItemDescription; ItemDescription)
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE("Outstanding Quantity" = FILTER(<> 0), Type = FILTER(Item));
                column(DocumentNo_SalesLine; "Sales Line"."Document No.")
                {
                }
                column(CustomerName; CustomerName)
                {
                }
                column(PostingDate_SalesLine; "Sales Line"."Posting Date")
                {
                }
                column(SelltoCustomerNo_SalesLine; "Sales Line"."Sell-to Customer No.")
                {
                }
                column(OutstandingQuantity_SalesLine; "Sales Line"."Outstanding Quantity")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF recCustomer.GET("Sell-to Customer No.") THEN
                        CustomerName := recCustomer.Name;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF recItem.GET("No.") THEN
                    ItemDescription := recItem.Description;
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
        ItemNoCap = 'ITEM No.';
        DescriptionCap = 'DESCRIPTION';
        SalesOrderNoCap = 'SALES ORDER NO.';
        DateCap = 'DATE';
        CustomerNoCap = 'CUSTOMER NUMBER';
        NameCap = 'NAME';
        UnitMeasCap = 'UNIT MEAS';
        QtyRequiredCap = 'QUANTITY REQUIRED';
        QtyReceivedCap = 'QUANTITY RECEIVED';
        TotalCap = 'TOTAL ON BACK ORDER:';
    }

    var
        recItem: Record Item;
        recCustomer: Record Customer;
        ItemDescription: Text[100];
        CustomerName: Text[100];
}

