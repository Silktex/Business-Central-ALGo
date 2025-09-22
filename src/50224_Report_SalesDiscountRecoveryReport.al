report 50224 "Sales Discount Recovery Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50224_Report_SalesDiscountRecoveryReport.rdlc';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "Sell-to Customer No.", "Posting Date";
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE(Quantity = FILTER(<> 0), Type = FILTER(Item));
                RequestFilterFields = "No.";
                column(CustCode; "Sales Invoice Header"."Sell-to Customer No.")
                {
                }
                column(Cust_Name; "Sales Invoice Header"."Sell-to Customer Name")
                {
                }
                column(Date; "Sales Invoice Header"."Posting Date")
                {
                }
                column(ItemCode; "Sales Invoice Line"."No.")
                {
                }
                column(ItemName; "Sales Invoice Line".Description)
                {
                }
                column(CampaginQty; CampaginQty)
                {
                }
                column(CampaginAmt; CampaginAmt)
                {
                }
                column(CampaginDiscount; CampaginDiscount)
                {
                }
                column(TotalsoldlessCampaign; TotalsoldlessCampaign)
                {
                }
                column(TotalAmountlessCampaign; TotalAmountlessCampaign)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF NOT (("Sales Invoice Line".Type = "Sales Invoice Line".Type::Item) OR
                      (("Sales Invoice Line".Type = "Sales Invoice Line".Type::Resource) AND ("Sales Invoice Line"."No." = 'MISC'))) THEN
                        EXIT;

                    CampaginQty := 0;
                    CampaginAmt := 0;
                    CampaginDiscount := 0;
                    RecSalesHeader.RESET;
                    RecSalesHeader.SETRANGE("No.", "Document No.");
                    RecSalesHeader.SETFILTER("Campaign No.", '%1|%2|%3|%4', 'PLACEMENT', 'STK PLACEMENT', 'MARKET', 'SALESMTG');
                    IF RecSalesHeader.FINDFIRST THEN BEGIN
                        RecSalesLine.RESET;
                        RecSalesLine.SETRANGE("Document No.", RecSalesHeader."No.");
                        RecSalesLine.SETRANGE(Type, RecSalesLine.Type::Item);
                        RecSalesLine.SETRANGE("No.", "No.");
                        RecSalesLine.SETFILTER(Quantity, '<>%1', 0);
                        IF RecSalesLine.FINDFIRST THEN
                            REPEAT
                                CampaginQty += RecSalesLine.Quantity;
                                CampaginAmt += RecSalesLine."Unit Price" * RecSalesLine.Quantity;
                                CampaginDiscount += RecSalesLine."Line Discount Amount";
                            UNTIL RecSalesLine.NEXT = 0;
                    END;

                    TotalsoldlessCampaign := 0;
                    TotalAmountlessCampaign := 0;
                    RecSalesHeader.RESET;
                    RecSalesHeader.SETRANGE("No.", "Document No.");
                    RecSalesHeader.SETFILTER("Campaign No.", '%1', '');
                    IF RecSalesHeader.FINDFIRST THEN BEGIN
                        RecSalesLine.RESET;
                        RecSalesLine.SETRANGE("Document No.", RecSalesHeader."No.");
                        RecSalesLine.SETRANGE(Type, RecSalesLine.Type::Item);
                        RecSalesLine.SETRANGE("No.", "No.");
                        RecSalesLine.SETFILTER(Quantity, '<>%1', 0);
                        IF RecSalesLine.FINDFIRST THEN
                            REPEAT
                                TotalsoldlessCampaign += RecSalesLine.Quantity;
                                TotalAmountlessCampaign += RecSalesLine."Unit Price" * RecSalesLine.Quantity;
                            UNTIL RecSalesLine.NEXT = 0;
                    END;
                end;
            }

            trigger OnPreDataItem()
            begin
                CampaginQty := 0;
                CampaginAmt := 0;
                CampaginDiscount := 0;
                TotalsoldlessCampaign := 0;
                TotalAmountlessCampaign := 0;
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
        RecSalesHeader: Record "Sales Invoice Header";
        RecSalesLine: Record "Sales Invoice Line";
        TotalsoldlessCampaign: Decimal;
        CampaginQty: Decimal;
        ItemCode: Code[20];
        TotalAmountlessCampaign: Decimal;
        CampaginAmt: Decimal;
        CampaginDiscount: Decimal;
}

