pageextension 50212 ItemList_Ext extends "Item List"
{
    layout
    {
        addafter(Description)
        {
            field(Backing; Rec.Backing)
            {
                ApplicationArea = all;
            }
        }
        // addafter("Substitutes Exist")
        // {
        //     field("Description 2"; Rec."Description 2")
        //     {
        //         ApplicationArea = all;
        //     }
        // }
        modify("Search Description")
        {
            Visible = false;
        }
        addafter("Shelf No.")
        {
            field(Customer; Rec.Customer)
            {
                ApplicationArea = all;
            }
        }
        addafter("Unit Price")
        {
            field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
            {
                ApplicationArea = all;
            }
            field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
            {
                ApplicationArea = all;
            }
            field("Qty. on Sales Quote"; Rec."Qty. on Sales Quote")
            {
                Caption = 'CFA Qty.';
                ApplicationArea = all;
            }
        }
        addafter("Vendor No.")
        {
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = all;
            }
        }
        addafter("Item Category Code")
        {
            field("Product Line"; Rec."Product Line")
            {
                ApplicationArea = all;
            }
        }
        addafter("Item Tracking Code")
        {
            field("ReOrder Tab"; Rec."ReOrder Tab")
            {
                ApplicationArea = all;
            }
            field("Short Piece"; Rec."Short Piece")
            {
                ApplicationArea = all;
                Importance = Additional;
            }
        }
        addafter("Default Deferral Template Code")
        {
            field("Reorder Calculation Year"; Rec."Reorder Calculation Year")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addbefore("Item Expiration - Quantity")
        {
            action(ReorderReport)
            {
                Caption = 'Reorder Report';
                Description = 'Reorder Report';
                Visible = ShowSilkReport;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Reorder Report New";
                ToolTip = 'Reorder Report';
                ApplicationArea = all;
            }

            action(ReorderReportPOSH)
            {
                Caption = 'Reorder Report POSH';
                Description = 'Reorder Report POSh';
                Visible = ShowPoshReport;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Reorder Report New POSH";
                ToolTip = 'Reorder Report';
                ApplicationArea = all;
            }
            action("Reorder Page")
            {
                Caption = 'Reorder Page';
                Ellipsis = true;
                Image = Register;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Reorder List";
                ApplicationArea = all;
            }
            action(ItemSalesByMonth)
            {
                Caption = 'Item Sales By Month';
                Ellipsis = true;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Item Sales By Month";
                ApplicationArea = all;
            }
            action(LotReport)
            {
                Caption = 'Lot Report';
                Description = 'Lot Report';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Lot Report";
                ToolTip = 'Lot Report';
                ApplicationArea = all;
            }
            action(StockReportLotBinwise)
            {
                Caption = 'Stock Report Lot & Bin wise';
                Description = 'Stock Report Lot & Bin wise';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Stock Report Lot & Bin wise";
                ToolTip = 'Stock Report Lot & Bin wise';
                ApplicationArea = all;
            }
            action(BackOrderFillReport)
            {
                Caption = 'Back Order Fill Report';
                Ellipsis = true;
                Image = "Report";
                Visible = ShowSilkReport;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Back Order Fill Report New";
                ApplicationArea = all;
            }
            action(BackOrderFillReportPOSH)
            {
                Caption = 'Back Order Fill Report POSH';
                Ellipsis = true;
                Visible = ShowPoshReport;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Back Order Fill Report POSH";
                ApplicationArea = all;

                // trigger OnAction()
                // var
                //     BackOrder: Report "Back Order Fill Report POSH";
                //     tempblob: Codeunit "Temp Blob";
                // begin
                //     BackOrder.SaveAs('',ReportFormat::Excel)
                // end;
            }
            action(StockDetails)
            {
                Caption = 'Stock Details';
                Ellipsis = true;
                Image = Status;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    recItem: Record Item;
                begin
                    if recItem.Get(Rec."No.") then
                        PAGE.Run(PAGE::"Stock Details", recItem);
                end;
            }
            action(ItemPriceContinuityReport)
            {
                Caption = 'Item Price & Continuity Report';
                Description = 'Item Price & Continuity Report';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Customer Price & Continuity Re";
                ToolTip = 'Item Price & Continuity Report';
                ApplicationArea = all;
            }
        }
        addbefore("Items b&y Location")
        {
            action(LocationNew)
            {
                ApplicationArea = Advanced;
                Caption = 'Location';
                Ellipsis = true;
                Image = Warehouse;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Item Availability by Location";
                RunPageLink = "No." = FIELD("No."),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                  "Location Filter" = FIELD("Location Filter"),
                                  "Drop Shipment Filter" = FIELD("Drop Shipment Filter"),
                                  "Variant Filter" = FIELD("Variant Filter");
                ToolTip = 'View the actual and projected quantity of the item per location.';
            }

        }
        addafter(Attributes)
        {
            action(FilterByAttributes1)
            {
                Caption = 'Filter by Attributes';
                Image = EditFilter;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Find items that match specific attributes.';
                ApplicationArea = all;

                trigger OnAction()
                var
                    ItemAttributeManagement: Codeunit "Item Attribute Management";
                    FilterText: Text;
                    FilterPageID: Integer;
                begin
                    FilterPageID := PAGE::"Filter Items by Attribute";
                    //Ravi Item Attribute BEGIN
                    //IF CURRENTCLIENTTYPE = CLIENTTYPE::Phone THEN
                    //FilterPageID := PAGE::"Filter Items by Att. Phone";
                    //Ravi Item Attribute END

                    if PAGE.RunModal(FilterPageID, TempFilterItemAttributesBuffer) = ACTION::LookupOK then begin
                        Rec.FilterGroup(0);
                        FilterText := ItemAttributeManagement.FindItemsByAttribute(TempFilterItemAttributesBuffer);
                        Rec.SetFilter("No.", FilterText);
                    end;
                end;
            }
            action(ClearAttributes1)
            {
                Caption = 'Clear Attributes Filter';
                Image = RemoveFilterLines;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Remove the filter for specific item attributes.';
                ApplicationArea = all;

                trigger OnAction()
                begin
                    TempFilterItemAttributesBuffer.Reset;
                    TempFilterItemAttributesBuffer.DeleteAll;
                    Rec.FilterGroup(0);
                    Rec.SetRange("No.");
                end;
            }
        }
        addafter(Sales_Prices)
        {
            action("<Page Item Customer Catalog>")
            {
                Caption = 'Cust&omers';
                Image = Vendor;
                RunObject = Page "Item Customer Catalog";
                RunPageLink = "Item No." = FIELD("No.");
                ApplicationArea = all;
            }
        }
        addafter("Return Orders")
        {
            action(ItemCustomerReOrder)
            {
                Caption = 'Item Customer Re-Order';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Item Customer Re-Order";
                ApplicationArea = all;
            }
            action(PageItemCustomerRelation)
            {
                Caption = 'Item Customer Re-Order Relation';
                Image = Confirm;
                RunObject = Page "Item Customer Re-Order";
                RunPageLink = "Item No." = FIELD("No.");
                ApplicationArea = all;
            }
        }
    }
    trigger OnOpenPage()
    var
        compInfo: Record "Company Information";
    begin

        compInfo.get();
        IF compInfo."Report Selection" = compInfo."Report Selection"::Slik then
            ShowSilkReport := true;
        IF compInfo."Report Selection" = compInfo."Report Selection"::POSH then
            ShowPoshReport := true;
    end;

    trigger OnAfterGetRecord()
    var
        compInfo: Record "Company Information";
    begin

        compInfo.get();
        IF compInfo."Report Selection" = compInfo."Report Selection"::Slik then
            ShowSilkReport := true;
        IF compInfo."Report Selection" = compInfo."Report Selection"::POSH then
            ShowPoshReport := true;

    end;

    var
        TempFilterItemAttributesBuffer: Record "Filter Item Attributes Buffer" temporary;
        ShowSilkReport: Boolean;
        ShowPoshReport: Boolean;
}
