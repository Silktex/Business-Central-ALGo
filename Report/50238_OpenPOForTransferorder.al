report 50238 "Open PO For Transfer order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50238_OpenPOForTransferorder.rdlc';
    EnableHyperlinks = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;


    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") ORDER(Ascending) WHERE("Document Type" = FILTER(Order));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Consignment No.";
            RequestFilterHeading = 'Purchase Order';
            column(No_PurchaseHeader; "Purchase Header"."No.")
            {
            }
            column(VendorNo; "Purchase Header"."Buy-from Vendor No.")
            {
            }
            column(VendorName; "Purchase Header"."Pay-to Name")
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE(Type = FILTER(Item), Quantity = FILTER(<> 0), "Outstanding Quantity" = FILTER(<> 0));
                column(No_PurchaseLine; "Purchase Line"."No.")
                {
                }
                column(LineNo_PurchaseLine; "Purchase Line"."Line No.")
                {
                }
                column(Description_PurchaseLine; "Purchase Line".Description)
                {
                }
                column(UnitofMeasureCode_PurchaseLine; "Purchase Line"."Unit of Measure Code")
                {
                }
                column(Quantity_PurchaseLine; "Purchase Line".Quantity)
                {
                }
                column(QuantityReceived_PurchaseLine; "Purchase Line"."Quantity Received")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    POQuantity := Quantity;
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
        OrderNoCap = 'PO No.';
        PoDateCap = 'PO Date';
        DueDateCap = 'Due Date';
        ItemNoCap = 'Item Number';
        ItemDescCap = 'Item Description';
        OrderedCap = 'Ordered';
        ReceivedCap = 'Received';
        QTYOnHandCap = 'Quantity on Hand';
        SOQtyCap = 'Qty on Sales Order';
        BackOrderCap = 'Back Order';
        VendorNoCap = 'Vendor No';
        VendorNameCap = 'Vendor Name';
        VendorOrderNo = 'Vendor Order No.';
        QtyRcdNotInvoiced = 'Qty Rcd Not Invoiced';
        RedyGoodsQtyCap = 'Ready Goods Qty';
        lblNegative = 'Negative';
        lbl3mreq = '3M Req.';
        lblAir = 'Air';
        lblBoat = 'Boat';
        lblHold = 'Hold';
        lblPromisedReceiptDate = 'Promised Receipt Date';
        lblPriorityQty = 'Priority Qty';
        iblPriorityDate = 'Priority Date';
    }

    var
        POQuantity: Decimal;
}

