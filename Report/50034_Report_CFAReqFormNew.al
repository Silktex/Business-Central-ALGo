report 50034 "CFA Req. Form New"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50034_Report_CFAReqFormNew.rdlc';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") ORDER(Ascending) WHERE("Document Type" = FILTER(Quote));
            RequestFilterFields = "No.";
            column(ExternalDocumentNo_SalesHeader; "Sales Header"."External Document No.")
            {
            }
            column(SelltoCustomerNo_SalesHeader; "Sales Header"."Sell-to Customer No.")
            {
            }
            column(No_SalesHeader; "Sales Header"."No.")
            {
            }
            column(BilltoCustomerNo_SalesHeader; "Sales Header"."Bill-to Customer No.")
            {
            }
            column(PromisedDeliveryDate_SalesHeader; "Sales Header"."Promised Delivery Date")
            {
            }
            column(RequestedDeliveryDate_SalesHeader; "Sales Header"."Requested Delivery Date")
            {
            }
            column(ShippingAgentCode_SalesHeader; "Sales Header"."Shipping Agent Code")
            {
            }
            column(OrderDate_SalesHeader; "Sales Header"."Order Date")
            {
            }
            column(BilltoContact_SalesHeader; "Sales Header"."Bill-to Contact")
            {
            }
            column(ShiptoContact_SalesHeader; "Sales Header"."Ship-to Contact")
            {
            }
            column(SelltoContact_SalesHeader; "Sales Header"."Sell-to Contact")
            {
            }
            column(CmpnyName; CmpInfo.Name)
            {
            }
            column(CmpnyAdd; CmpInfo.Address)
            {
            }
            column(CmpInfoPic; CmpInfo.Picture)
            {
            }
            column(CmpnyAdd2; CmpInfo."Address 2")
            {
            }
            column(CmpnyPhNo; CmpInfo."Phone No.")
            {
            }
            dataitem("Sales Comment Line"; "Sales Comment Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("No.");
                column(Comment_SalesCommentLine; "Sales Comment Line".Comment)
                {
                }
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                column(DocumentNo_SalesLine; "Sales Line"."Document No.")
                {
                }
                column(No_SalesLine; "Sales Line"."No.")
                {
                }
                column(Quantity_SalesLine; "Sales Line".Quantity)
                {
                }
                column(Description_SalesLine; "Sales Line".Description)
                {
                }
                column(OutstandingQuantity_SalesLine; "Sales Line"."Outstanding Quantity")
                {
                }
                column(QtytoInvoice_SalesLine; "Sales Line"."Qty. to Invoice")
                {
                }
                column(QtytoShip_SalesLine; "Sales Line"."Qty. to Ship")
                {
                }
            }

            trigger OnPreDataItem()
            begin
                CmpInfo.GET;
                CmpInfo.CALCFIELDS(CmpInfo.Picture);
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
        CmpInfo: Record "Company Information";
}

