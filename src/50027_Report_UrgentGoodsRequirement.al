report 50027 "Urgent Goods Requirement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50027_Report_UrgentGoodsRequirement.rdlc';
    Caption = 'Urgent Goods Requirement New';
    Description = 'Urgent Goods Requirement New';

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Item Category Code";
            column(No_Item; "No.")
            {
            }
            column(ItemDescription; Description)
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE("Document Type" = FILTER(Order), Type = FILTER(Item), "Outstanding Quantity" = FILTER(<> 0));
                column(DocumentNo_PurchaseLine; "Document No.")
                {
                }
                column(BuyfromVendorNo_PurchaseLine; "Buy-from Vendor No.")
                {
                }
                column(VendorName; VendorName)
                {
                }
                column(OrderDate_PurchaseLine; FORMAT("Order Date"))
                {
                }
                column(No_PurchaseLine; "No.")
                {
                }
                column(OutstandingQuantity_PurchaseLine; "Outstanding Quantity")
                {
                }
                column(UnitofMeasure_PurchaseLine; "Unit of Measure")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF recVendor.GET("Buy-from Vendor No.") THEN
                        VendorName := recVendor.Name;
                end;
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE("Document Type" = FILTER(Order), Type = FILTER(Item), "Outstanding Quantity" = FILTER(<> 0));
                column(DocumentNo_SalesLine; "Document No.")
                {
                }
                column(ShipmentDate_SalesLine; FORMAT("Shipment Date"))
                {
                }
                column(SelltoCustomerNo_SalesLine; "Sell-to Customer No.")
                {
                }
                column(CustomerName; CustomerName)
                {
                }
                column(No_SalesLine; "Sales Line"."No.")
                {
                }
                column(OutstandingQuantity_SalesLine; "Outstanding Quantity")
                {
                }
                column(UnitofMeasure_SalesLine; "Unit of Measure")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF recCustomer.GET("Sell-to Customer No.") THEN
                        CustomerName := recCustomer.Name;
                end;
            }
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
        OrderNoCap = 'ORDER NO.';
        DateCap = 'DATE';
        NoCap = 'CUST./VENDOR NO.';
        NameCap = 'NAME';
        QtyOutstandingCap = 'OUTSTANDING QUANTITY';
        UnitMeasCap = 'UNIT MEAS';
        TotalCap = 'TOTAL';
    }

    var
        recCustomer: Record Customer;
        CustomerName: Text[100];
        recVendor: Record Vendor;
        VendorName: Text[100];
}

