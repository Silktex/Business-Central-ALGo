report 50035 "Back Order Transfer Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50035_Report_BackOrderTransferReport.rdlc';

    dataset
    {
        dataitem("Transfer Receipt Line"; "Transfer Receipt Line")
        {
            DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending) WHERE(Quantity = FILTER(<> 0));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Receipt Date", "Document No.", "Transfer-to Code";
            column(No_PurchRcptLine; "Transfer Receipt Line"."Item No.")
            {
            }
            column(LineNo_PurchRcptLine; "Transfer Receipt Line"."Line No.")
            {
            }
            column(ItemDescription; ItemDescription)
            {
            }
            column(UnitofMeasure_PurchRcptLine; "Transfer Receipt Line"."Unit of Measure")
            {
            }
            column(Quantity_PurchRcptLine; "Transfer Receipt Line".Quantity)
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "No." = FIELD("Item No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE("Outstanding Quantity" = FILTER(<> 0), Type = FILTER(Item), "Document Type" = FILTER(Order));
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
                IF recItem.GET("Item No.") THEN
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

