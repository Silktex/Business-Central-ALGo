pageextension 50211 ItemCard_Ext extends "Item Card"
{
    layout
    {
        addafter(Description)
        {
            field(Backing; Rec.Backing)
            {
                ApplicationArea = all;
            }
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = all;
            }
        }
        modify("Item Category Code")
        {
            trigger OnBeforeValidate()
            begin
                Rec.TestField("ReOrder Tab");
            end;
        }
        addafter("Item Category Code")
        {
            field("Product Line"; Rec."Product Line")
            {
                ApplicationArea = all;
            }
        }
        addafter("Automatic Ext. Texts")
        {
            field("Reorder Calculation Year"; Rec."Reorder Calculation Year")
            {
                ApplicationArea = all;
            }
        }
        addafter("Search Description")
        {
            field("Short Piece"; Rec."Short Piece")
            {
                ApplicationArea = all;
            }
            field("ReOrder Tab"; Rec."ReOrder Tab")
            {
                ApplicationArea = all;
            }
        }
        addafter("Qty. on Sales Order")
        {
            field("Qty. on Sales Quote"; Rec."Qty. on Sales Quote")
            {
                ApplicationArea = all;
            }
        }
        addafter(PreventNegInventoryDefaultNo)
        {
            field(Weight; Rec.Weight)
            {
                ApplicationArea = all;
            }
            field("Quantity Variance %"; Rec."Quantity Variance %")
            {
                ApplicationArea = all;
            }
            field(Drop; Rec.Drop)
            {
                ApplicationArea = all;
            }
        }
        addafter(InventoryGrp)
        {
            group("ECOM Fields")
            {
                Caption = 'ECOM Fields';
                field(DisplayStockAvailability; Rec.DisplayStockAvailability)
                {
                    ApplicationArea = all;
                }
                field(DisplayStockQuantity; Rec.DisplayStockQuantity)
                {
                    ApplicationArea = all;
                }
                field(Published; Rec.Published)
                {
                    ApplicationArea = all;
                }
            }
        }
        addafter("Vendor No.")
        {
            field(Customer; Rec.Customer)
            {
                ApplicationArea = all;
            }
        }
        addafter("Vendor Item No.")
        {
            field("Warp Color"; Rec."Warp Color")
            {
                ApplicationArea = all;
            }
        }
        addafter("Purch. Unit of Measure")
        {
            field("ReOrder Days"; rec."ReOrder Days")
            {
                ApplicationArea = all;
            }
        }
        modify("Qty. on Prod. Order")
        {
            Visible = true;
            ApplicationArea = all;
        }
        modify("Qty. on Component Lines")
        {
            Visible = true;
            ApplicationArea = all;
        }
        modify("Qty. on Service Order")
        {
            Visible = true;
            ApplicationArea = all;
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
            ApplicationArea = all;
        }
        modify("Tax Group Code")
        {
            Visible = true;
            ApplicationArea = all;
        }
        modify("VAT Bus. Posting Gr. (Price)")
        {
            ApplicationArea = all;
            CaptionML = ENU = 'Tax Bus. Posting Gr. (Price)', ESM = 'Gr.regis. IVA negocio (precio)',
                FRC = 'Gr. reports taxes entr. (prix)', ENC = 'Tax Bus. Posting Gr. (Price)';
        }
    }
    actions
    {
        addafter(Attributes)
        {
            action(FilterByAttributes)
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
        }
        modify("Item Tracing")
        {
            Visible = true;
        }
        addafter("Item Tracing")
        {
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
        }
        modify(Translations)
        {
            Visible = true;
        }
        // addbefore(ItemsByLocation)
        // {
        //     action(SpecSheets)
        //     {
        //         Caption = 'SpecSheets';
        //         Image = "Item Group";
        //         RunObject = Page "Spec sheet";
        //         RunPageLink = "Product Group Code" = FIELD("Product Group Code");
        //         ApplicationArea = all;
        //     }
        // }
        addbefore("Prepa&yment Percentages")
        {
            action("Page Item Customer Catalog")
            {
                Caption = 'Customer Item';
                Image = Customer;
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


    var
        //Xmlhttp: Automation;
        //HttpWebResponse: DotNet WebResponse;
        RecCompanyInfo: Record "Company Information";
        Result: Boolean;
        txtURL: Text;
        recCompInfo: Record "Company Information";
        TempFilterItemAttributesBuffer: Record "Filter Item Attributes Buffer" temporary;
}
