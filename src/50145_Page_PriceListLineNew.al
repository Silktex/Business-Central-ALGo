page 50145 "Price List Line New"
{
    ApplicationArea = All;
    Caption = 'Price List Line New';
    PageType = List;
    SourceTable = "Price List Line";
    SourceTableView = where(Discontinued = filter(0));
    UsageCategory = Lists;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Source Type"; Rec."Source Type")
                {
                    ToolTip = 'Specifies the type of the entity that offers the price or the line discount on the product.';
                    ApplicationArea = All;
                }
                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the unique identifier of the source of the price on the price list line.';
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the currency code of the price.';
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the date from which the price or the line discount is valid.';
                    ApplicationArea = All;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ToolTip = 'Specifies the date to which the price or the line discount is valid.';
                    ApplicationArea = All;
                }
                field("Asset Type"; Rec."Asset Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the product.';

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }
                field("Asset No."; Rec."Asset No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the identifier of the product. If no product is selected, the price and discount values will apply to all products of the selected product type for which those values are not specified. For example, if you choose Item as the product type but do not specify a specific item, the price will apply to all items for which a price is not specified.';
                    Style = Attention;
                    StyleExpr = LineToVerify;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the product.';
                    Style = Attention;
                    StyleExpr = LineToVerify;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    Enabled = ItemAsset;
                    Editable = ItemAsset;
                    ToolTip = 'Specifies the item variant.';
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    ApplicationArea = All;
                    Enabled = ResourceAsset;
                    Editable = ResourceAsset;
                    ToolTip = 'Specifies the work type code for the resource.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    Enabled = UOMEditable;
                    Editable = UOMEditable;
                    ToolTip = 'Specifies the unit of measure for the product.';
                }
                field("Minimum Quantity"; Rec."Minimum Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the minimum quantity of the product.';
                }
                field("Amount Type"; Rec."Amount Type")
                {
                    ApplicationArea = All;
                    Importance = Standard;
                    Visible = AmountTypeIsVisible;
                    Editable = AmountTypeIsEditable;
                    ToolTip = 'Specifies whether the price list line defines prices, discounts, or both.';
                    trigger OnValidate()
                    begin
                        SetMandatoryAmount();
                    end;
                }
                field("Unit Price"; Rec."Unit Price")
                {

                    ApplicationArea = All;

                    ToolTip = 'Specifies the unit price of the product.';
                }

                field("Cost Factor"; Rec."Cost Factor")
                {
                    AccessByPermission = tabledata "Sales Price Access" = R;
                    ApplicationArea = All;
                    Editable = AmountEditable;
                    Enabled = PriceMandatory;
                    Visible = IsJobGroup and PriceVisible;
                    StyleExpr = PriceStyle;
                    ToolTip = 'Specifies the unit cost factor for job-related prices, if you have agreed with your customer that he should pay certain item usage by cost value plus a certain percent value to cover your overhead expenses.';
                }
                field("Allow Line Disc."; Rec."Allow Line Disc.")
                {
                    ApplicationArea = All;
                    Visible = PriceVisible;
                    Enabled = PriceMandatory;
                    Editable = PriceMandatory;
                    ToolTip = 'Specifies if a line discount will be calculated when the price is offered.';
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    AccessByPermission = tabledata "Sales Discount Access" = R;
                    ApplicationArea = All;
                    Visible = DiscountVisible;
                    Enabled = DiscountMandatory;
                    Editable = DiscountMandatory;
                    StyleExpr = DiscountStyle;
                    ToolTip = 'Specifies the line discount percentage for the product.';
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = All;
                    Visible = PriceVisible;
                    Enabled = PriceMandatory;
                    Editable = PriceMandatory;
                    ToolTip = 'Specifies if an invoice discount will be calculated when the price is offered.';
                }
                field(PriceIncludesVAT; Rec."Price Includes VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the if prices include VAT.';
                }
                field(VATBusPostingGrPrice; Rec."VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = All;
                    Visible = AllowUpdatingDefaults;
                    ToolTip = 'Specifies the default VAT business posting group code.';
                }
                field("Special Price"; Rec."Special Price")
                {
                    ApplicationArea = all;
                }
                field("Special Price Comments"; Rec."Special Price Comments")
                {
                    ApplicationArea = all;
                }
                // }
                // addafter("VAT Bus. Posting Gr. (Price)")
                // {
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                }
                field(txtSalesCodeDesc; txtSalesCodeDesc)
                {
                    Caption = 'Sales Code Description';
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = all;
                }
                field(txtProductdes; txtProductdes)
                {
                    Caption = 'Product Group Type';
                    ApplicationArea = all;
                }
                field(decStandardPrice; decStandardPrice)
                {
                    Caption = 'Product Group Price';
                    ApplicationArea = all;
                }
                field(Discontinued; Rec.Discontinued)
                {
                    ApplicationArea = all;
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Last Modified User"; Rec."Last Modified User")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(ContinuityStartDate; ContinuityStartDate)
                {
                    Caption = 'Continuity Start Date';
                    ApplicationArea = all;
                }
                field(ContinuityEndDate; ContinuityEndDate)
                {
                    Caption = 'Continuity End Date';
                    ApplicationArea = all;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        UpdateSourceType();
        LineToVerify := Rec.IsLineToVerify();
        SetMandatoryAmount();

        IF Rec."Source Type" = Rec."Source Type"::"Customer Price Group" THEN BEGIN
            IF recCustPrice.GET(Rec."Source No.") THEN
                txtSalesCodeDesc := recCustPrice.Description
            ELSE
                txtSalesCodeDesc := '';

        END ELSE BEGIN
            IF Rec."Source Type" = Rec."Source Type"::Customer THEN BEGIN
                IF recCustomer.GET(Rec."Source No.") THEN
                    txtSalesCodeDesc := recCustomer.Name
                ELSE
                    txtSalesCodeDesc := '';
            END ELSE BEGIN
                IF Rec."Source Type" = Rec."Source Type"::Campaign THEN BEGIN
                    IF recCampaign.GET(Rec."Source No.") THEN
                        txtSalesCodeDesc := recCampaign.Description
                    ELSE
                        txtSalesCodeDesc := '';
                END;
            END;
        END;

        txtProductdes := '';
        decStandardPrice := 0;
        IF Rec."Source Type" = Rec."Source Type"::Customer THEN BEGIN
            recCust.GET(Rec."Source No.");
            recSalesPrice.RESET;
            recSalesPrice.SETRANGE("Source Type", recSalesPrice."Source Type"::"Customer Price Group");
            recSalesPrice.SETRANGE("Source No.", recCust."Customer Price Group");
            //recSalesPrice.SETRANGE("Asset Type",recSalesPrice."Product Type"::"Product Group");
            recSalesPrice.SETRANGE("Asset No.", Rec."Asset No.");
            recSalesPrice.SETFILTER("Starting Date", '<=%1', WORKDATE);
            recSalesPrice.SETFILTER("Ending Date", '>=%1', WORKDATE);
            IF recSalesPrice.FINDSET THEN BEGIN
                REPEAT
                    txtProductdes := recSalesPrice."Source No.";
                    decStandardPrice := recSalesPrice."Unit Price";
                UNTIL recSalesPrice.NEXT = 0;
            END;
        END;

        //A/17.04.2019/SCST000001
        ContinuityStartDate := 0D;
        ContinuityEndDate := 0D;
        IF Rec."Asset Type".AsInteger() = Rec."Asset Type"::Item THEN BEGIN
            ItemCrossReference.RESET;
            ItemCrossReference.SETRANGE(ItemCrossReference."Item No.", Rec."Asset No.");
            IF ItemCrossReference.FINDFIRST THEN BEGIN
                ContinuityStartDate := ItemCrossReference."Palcement Start Date";
                ContinuityEndDate := ItemCrossReference."Placement End Date";
            END;
        END;

        IF Rec."Asset Type".AsInteger() = Rec."Asset Type"::"Item Category" THEN BEGIN
            recItem.RESET;
            //recItem.SETRANGE("Product Group Code","Item No.");
            recItem.SETRANGE("Item Category Code", Rec."Asset No.");
            IF recItem.FINDSET THEN BEGIN
                ItemCrossReference.RESET;
                ItemCrossReference.SETRANGE("Item No.", recItem."No.");

                IF ItemCrossReference.FINDSET THEN BEGIN
                    IF (ItemCrossReference."Palcement Start Date" <> 0D) AND (ItemCrossReference."Placement End Date" <> 0D) THEN BEGIN
                        ContinuityStartDate := ItemCrossReference."Palcement Start Date";
                        ContinuityEndDate := ItemCrossReference."Placement End Date";
                    END;
                    REPEAT
                        ItemCrossReference1.RESET;
                        ItemCrossReference1.SETRANGE("Item No.", recItem."No.");
                        IF ItemCrossReference1.FINDFIRST THEN BEGIN
                            IF (ItemCrossReference1."Placement End Date" <> 0D) AND (ItemCrossReference1."Placement End Date" < ContinuityEndDate) THEN BEGIN
                                ContinuityStartDate := ItemCrossReference1."Palcement Start Date";
                                ContinuityEndDate := ItemCrossReference1."Placement End Date";
                            END;
                        END;
                    UNTIL recItem.NEXT = 0;
                END;
            END;
        END;
        //E/17.04.2019/SCST000001
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetEditable();
        UpdateSourceType();
        LineToVerify := Rec.IsLineToVerify();
        SetMandatoryAmount();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if not GetHeader() then
            exit;
        if PriceListHeader."Allow Updating Defaults" then begin
            Rec.CopySourceFrom(PriceListHeader);
            if Rec."Starting Date" = 0D then
                Rec."Starting Date" := PriceListHeader."Starting Date";
            if Rec."Ending Date" = 0D then
                Rec."Ending Date" := PriceListHeader."Ending Date";
            if Rec."Currency Code" = '' then
                Rec."Currency Code" := PriceListHeader."Currency Code";
        end;
        Rec.Validate("Asset Type", xRec."Asset Type");
        UpdateSourceType();
        Rec."Amount Type" := ViewAmountType;
    end;

    local procedure GetHeader(): Boolean
    begin
        if Rec."Price List Code" = '' then
            exit(false);
        if PriceListHeader.Code = Rec."Price List Code" then
            exit(true);
        exit(PriceListHeader.Get(Rec."Price List Code"));
    end;

    var
        JobSourceType: Enum "Job Price Source Type";
        SourceType: Enum "Sales Price Source Type";
        SourceNoEnabled: Boolean;

    protected var
        PriceListHeader: Record "Price List Header";
        PriceType: Enum "Price Type";
        ViewAmountType: Enum "Price Amount Type";
        AllowUpdatingDefaults: Boolean;
        AmountEditable: Boolean;
        AmountTypeIsEditable: Boolean;
        AmountTypeIsVisible: Boolean;
        DiscountStyle: Text;
        DiscountMandatory: Boolean;
        DiscountVisible: Boolean;
        IsJobGroup: Boolean;
        IsParentAllowed: Boolean;
        ItemAsset: Boolean;
        PriceStyle: Text;
        PriceMandatory: Boolean;
        PriceVisible: Boolean;
        ResourceAsset: Boolean;
        LineToVerify: Boolean;
        UOMEditable: Boolean;
        txtSalesCodeDesc: Text[50];
        recCustPrice: Record "Customer Price Group";
        recCampaign: Record Campaign;
        recCustomer: Record Customer;
        recSalesPrice: Record "Price List Line";
        txtProductdes: Text[50];
        decStandardPrice: Decimal;
        recCust: Record Customer;
        Expired: Boolean;
        ContinuityStartDate: Date;
        ContinuityEndDate: Date;
        ItemCrossReference: Record "Item Reference";
        recItem: Record Item;
        RecordFound: Boolean;
        ItemCrossReference1: Record "Item Reference";


    local procedure GetStyle(Mandatory: Boolean): Text;
    begin
        if LineToVerify and Mandatory then
            exit('Attention');
        if Mandatory then
            exit('Strong');
        exit('Subordinate');
    end;

    local procedure SetEditable()
    begin
        AmountTypeIsEditable := Rec."Asset Type" <> Rec."Asset Type"::"Item Discount Group";
        AmountEditable := Rec.IsAmountSupported();
        UOMEditable := Rec.IsUOMSupported();
        ItemAsset := Rec.IsAssetItem();
        ResourceAsset := Rec.IsAssetResource();
    end;

    local procedure SetMandatoryAmount()
    begin
        DiscountMandatory := Rec.IsAmountMandatory(Rec."Amount Type"::Discount);
        DiscountStyle := GetStyle(DiscountMandatory);
        PriceMandatory := Rec.IsAmountMandatory(Rec."Amount Type"::Price);
        PriceStyle := GetStyle(PriceMandatory);
    end;

    local procedure UpdateColumnVisibility()
    begin
        AllowUpdatingDefaults := PriceListHeader."Allow Updating Defaults";
        AmountTypeIsVisible := ViewAmountType = ViewAmountType::Any;
        DiscountVisible := ViewAmountType in [ViewAmountType::Any, ViewAmountType::Discount];
        PriceVisible := ViewAmountType in [ViewAmountType::Any, ViewAmountType::Price];
    end;

    procedure SetHeader(NewPriceListHeader: Record "Price List Header")
    begin
        PriceListHeader := NewPriceListHeader;
        // Rec.SetHeader(PriceListHeader);
        SetSubFormLinkFilter(PriceListHeader."Amount Type");
    end;

    procedure SetPriceType(NewPriceType: Enum "Price Type")
    begin
        PriceType := NewPriceType;
        PriceListHeader."Price Type" := NewPriceType;
    end;

    procedure SetSubFormLinkFilter(NewViewAmountType: Enum "Price Amount Type")
    begin
        ViewAmountType := NewViewAmountType;
        Rec.FilterGroup(2);
        if ViewAmountType = ViewAmountType::Any then
            Rec.SetRange("Amount Type")
        else
            Rec.SetFilter("Amount Type", '%1|%2', ViewAmountType, ViewAmountType::Any);
        Rec.FilterGroup(0);
        UpdateColumnVisibility();
        CurrPage.Update(false);
        CurrPage.Activate(true);
    end;

    local procedure UpdateSourceType()
    var
        PriceSource: Record "Price Source";
    begin
        case PriceListHeader."Source Group" of
            "Price Source Group"::Customer:
                begin
                    IsJobGroup := false;
                    SourceType := "Sales Price Source Type".FromInteger(Rec."Source Type".AsInteger());
                end;
            "Price Source Group"::Job:
                begin
                    IsJobGroup := true;
                    JobSourceType := "Job Price Source Type".FromInteger(Rec."Source Type".AsInteger());
                end;
        //else
        // OnUpdateSourceTypeOnCaseElse(PriceListHeader, SourceType, IsJobGroup);
        end;
        PriceSource."Source Type" := Rec."Source Type";
        IsParentAllowed := PriceSource.IsParentSourceAllowed();
    end;

    local procedure SetSourceNoEnabled()
    begin
        SourceNoEnabled := Rec.IsSourceNoAllowed();
    end;

    local procedure ValidateSourceType(SourceType: Integer)
    begin
        Rec.Validate("Source Type", SourceType);
        SetSourceNoEnabled();
        CurrPage.Update(true);
    end;

}
