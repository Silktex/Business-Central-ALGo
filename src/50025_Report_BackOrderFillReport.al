report 50025 "Back Order Fill Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50025_Report_BackOrderFillReport.rdlc';

    dataset
    {
        dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
        {
            DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending) WHERE(Type = FILTER(Item), Quantity = FILTER(<> 0));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Posting Date", "Document No.", "Buy-from Vendor No.";
            column(No_PurchRcptLine; "Purch. Rcpt. Line"."No.")
            {
            }
            column(LineNo_PurchRcptLine; "Purch. Rcpt. Line"."Line No.")
            {
            }
            column(ItemDescription; ItemDescription)
            {
            }
            column(UnitofMeasure_PurchRcptLine; "Purch. Rcpt. Line"."Unit of Measure")
            {
            }
            column(Quantity_PurchRcptLine; "Purch. Rcpt. Line".Quantity)
            {
            }
            column(Document_No; "Purch. Rcpt. Line"."Document No.")
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "No." = FIELD("No.");
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
                column(Priority; recSH.Priority)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF recCustomer.GET("Sell-to Customer No.") THEN
                        CustomerName := recCustomer.Name;

                    recSH.RESET;
                    recSH.SETRANGE(recSH."No.", "Sales Line"."Document No.");
                    IF recSH.FIND('-') THEN;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF recItem.GET("No.") THEN
                    ItemDescription := recItem.Description;

                remaningQty := 0;
                recILE.RESET;
                recILE.SETRANGE(recILE."Item No.", "No.");
                //recILE.SETRANGE(recILE."Document No.","Document No.");
                IF recILE.FIND('-') THEN
                    REPEAT
                        remaningQty += recILE."Remaining Quantity";
                    UNTIL recILE.NEXT = 0;
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
        recILE: Record "Item Ledger Entry";
        remaningQty: Decimal;
        recSH: Record "Sales Header";
}

