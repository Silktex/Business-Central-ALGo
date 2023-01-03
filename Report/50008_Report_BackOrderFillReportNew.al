report 50008 "Back Order Fill Report New"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50008_Report_BackOrderFillReportNew.rdlc';

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING("Item No.", "Posting Date") ORDER(Ascending) WHERE("Remaining Quantity" = FILTER(<> 0));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Item No.", "Posting Date", "Location Code", "ETA Date";
            column(ItemNo_ItemLedgerEntry; "Item No.")
            {
            }
            column(ItemDesc; ItemDesc)
            {
            }
            column(LocationCode_ItemLedgerEntry; "Location Code")
            {
            }
            column(UnitofMeasureCode_ItemLedgerEntry; "Unit of Measure Code")
            {
            }
            column(RemainingQuantity_ItemLedgerEntry; "Remaining Quantity")
            {
            }
            column(ILETotal; ILETotal)
            {
            }
            column(SOLTotal; SOLTotal)
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "No." = FIELD("Item No."), "Variant Code" = FIELD("Variant Code");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE("Document Type" = FILTER(Quote | Order), Type = CONST(Item), "Outstanding Quantity" = FILTER(<> 0));
                column(DocumentType_SalesLine; "Document Type")
                {
                }
                column(DocumentNo_SalesLine; "Document No.")
                {
                }
                column(No_SalesLine; "No.")
                {
                }
                column(LineNo_SalesLine; "Line No.")
                {
                }
                column(PostingDate_SalesLine; "Posting Date")
                {
                }
                column(BilltoCustomerNo_SalesLine; "Bill-to Customer No.")
                {
                }
                column(CustName; CustName)
                {
                }
                column(OutstandingQuantity_SalesLine; "Outstanding Quantity")
                {
                }
                column(Priority_SalesLine; Priority)
                {
                }
                column(Order_Date; recSH."Order Date")
                {
                }
                column(Promised_Delivery_Date; recSH."Promised Delivery Date")
                {
                }
                column(Physical_Order_Location; recSH."Physical Order Loc")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CustName := '';
                    IF recCustomer.GET("Bill-to Customer No.") THEN
                        CustName := recCustomer.Name;

                    recSH.RESET;
                    recSH.SETRANGE(recSH."No.", "Sales Line"."Document No.");
                    IF recSH.FIND('-') THEN;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ItemDesc := '';
                IF recItem.GET("Item No.") THEN
                    ItemDesc := recItem.Description;

                recILE.RESET();
                recILE.SETRANGE(recILE."Item No.", "Item No.");
                recILE.SETRANGE(recILE."Posting Date", GETRANGEMIN("Posting Date"), GETRANGEMAX("Posting Date"));
                recILE.SETRANGE(recILE."Location Code", "Location Code");
                recILE.SETRANGE(recILE."ETA Date", "ETA Date");
                recILE.SETFILTER(recILE."Remaining Quantity", '<>%1', 0);
                IF recILE.FINDFIRST THEN BEGIN
                    ILETotal := 0;
                    REPEAT
                        ILETotal := ILETotal + recILE."Remaining Quantity";
                    UNTIL recILE.NEXT = 0;
                END;

                recSalesLine.RESET;
                recSalesLine.SETRANGE(recSalesLine."Document Type", recSalesLine."Document Type"::Order);
                recSalesLine.SETRANGE(recSalesLine."No.", "Item No.");
                recSalesLine.SETFILTER(recSalesLine."Outstanding Quantity", '<>%1', 0);
                IF recSalesLine.FINDFIRST THEN BEGIN
                    SOLTotal := 0;
                    REPEAT
                        SOLTotal := SOLTotal + recSalesLine."Outstanding Quantity";
                    UNTIL recSalesLine.NEXT = 0;
                END;
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
        lblOrderNo = 'Sales Order No.';
        lblDate = 'Date';
        lblCustNo = 'Cust. No.';
        lblCustName = 'Cust. Name';
        lblUOM = 'UOM';
        lblQtyReq = 'Qty. Required';
        lblQtyRec = 'Qty. Received';
        lblPriority = 'Priority';
        lblTotal = 'Total';
    }

    var
        recItem: Record Item;
        recCustomer: Record Customer;
        recSalesLine: Record "Sales Line";
        recILE: Record "Item Ledger Entry";
        ItemDesc: Text[100];
        CustName: Text[100];
        ILETotal: Decimal;
        SOLTotal: Decimal;
        recSH: Record "Sales Header";
}

