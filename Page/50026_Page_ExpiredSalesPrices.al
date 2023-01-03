page 50026 "Expired Sales Prices"
{
    Caption = 'Expired Prices';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Price List Line";
    SourceTableView = WHERE(Expired = FILTER(true));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(SalesTypeFilter; SalesTypeFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Type Filter';
                    OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign,None';

                    trigger OnValidate()
                    begin
                        SalesTypeFilterOnAfterValidate;
                    end;
                }
                field(SalesCodeFilterCtrl; SalesCodeFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Code Filter';
                    Enabled = SalesCodeFilterCtrlEnable;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CustList: Page "Customer List";
                        CustPriceGrList: Page "Customer Price Groups";
                        CampaignList: Page "Campaign List";
                    begin
                        if SalesTypeFilter = SalesTypeFilter::"All Customers" then
                            exit;

                        case SalesTypeFilter of
                            SalesTypeFilter::Customer:
                                begin
                                    CustList.LookupMode := true;
                                    if CustList.RunModal = ACTION::LookupOK then
                                        Text := CustList.GetSelectionFilter
                                    else
                                        exit(false);
                                end;
                            SalesTypeFilter::"Customer Price Group":
                                begin
                                    CustPriceGrList.LookupMode := true;
                                    if CustPriceGrList.RunModal = ACTION::LookupOK then
                                        Text := CustPriceGrList.GetSelectionFilter
                                    else
                                        exit(false);
                                end;
                            SalesTypeFilter::Campaign:
                                begin
                                    CampaignList.LookupMode := true;
                                    if CampaignList.RunModal = ACTION::LookupOK then
                                        Text := CampaignList.GetSelectionFilter
                                    else
                                        exit(false);
                                end;
                        end;

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        SalesCodeFilterOnAfterValidate;
                        /*
                   IF "Sales Type"="Sales Type"::"Customer Price Group" THEN BEGIN
                       IF recCustPrice.GET(SalesCodeFilter) THEN
                         txtSalesCodeDesc:=recCustPrice.Description
                        ELSE
                         txtSalesCodeDesc:='';

                     END ELSE BEGIN
                       IF "Sales Type"="Sales Type"::Customer THEN BEGIN
                          IF recCustomer.GET(SalesCodeFilter) THEN
                             txtSalesCodeDesc:=recCustomer.Name
                           ELSE
                            txtSalesCodeDesc:='';
                     END ELSE BEGIN
                        IF "Sales Type"="Sales Type"::Campaign THEN BEGIN
                          IF recCampaign.GET(SalesCodeFilter) THEN
                             txtSalesCodeDesc:=recCampaign.Description
                           ELSE
                            txtSalesCodeDesc:='';
                      END;
                     END;
                    END;
                   */

                    end;
                }
                field(ItemNoFilterCtrl; ItemNoFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Item No. Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemList: Page "Item List";
                    begin
                        ItemList.LookupMode := true;
                        if ItemList.RunModal = ACTION::LookupOK then
                            Text := ItemList.GetSelectionFilter
                        else
                            exit(false);

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        ItemNoFilterOnAfterValidate;
                    end;
                }
                field(StartingDateFilter; StartingDateFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Starting Date Filter';

                    trigger OnValidate()
                    var
                        FilterTokens: Codeunit "Filter Tokens";
                    begin
                        FilterTokens.MakeDateFilter(StartingDateFilter);
                        StartingDateFilterOnAfterValid;
                    end;
                }
                field(SalesCodeFilterCtrl2; CurrencyCodeFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Currency Code Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CurrencyList: Page Currencies;
                    begin
                        CurrencyList.LookupMode := true;
                        if CurrencyList.RunModal = ACTION::LookupOK then
                            Text := CurrencyList.GetSelectionFilter
                        else
                            exit(false);

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        CurrencyCodeFilterOnAfterValid;
                    end;
                }
            }
            repeater(Control1)
            {
                ShowCaption = false;
                // field("Sales Type"; Rec."Sales Type")
                // {
                //     ApplicationArea = All;
                // }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                    Caption = 'Assign-to Type';
                    //Visible = not IsJobGroup and AllowUpdatingDefaults;
                }
                field("Sales Code"; Rec."Source No.")
                {
                    ApplicationArea = All;
                    Editable = "Sales CodeEditable";
                }
                field(txtSalesCodeDesc; txtSalesCodeDesc)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Code Description';
                    Editable = false;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Asset No.")
                {
                    ApplicationArea = All;
                    Caption = 'Product Code';
                }
                field("Special Price"; Rec."Special Price")
                {
                    ApplicationArea = All;
                    Caption = 'Special Price';
                }
                field("Special Price Comments"; Rec."Special Price Comments")
                {
                    ApplicationArea = All;
                    Caption = 'Special Price Comments';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Minimum Quantity"; Rec."Minimum Quantity")
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                }
                field("Price Includes VAT"; Rec."Price Includes VAT")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Allow Line Disc."; Rec."Allow Line Disc.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("VAT Bus. Posting Gr. (Price)"; Rec."VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(txtProductdes; txtProductdes)
                {
                    ApplicationArea = All;
                    Caption = 'Product Group Type';
                }
                field(decStandardPrice; decStandardPrice)
                {
                    ApplicationArea = All;
                    Caption = 'Product Group Price';
                }
                field(Discontinued; Rec.Discontinued)
                {
                    ApplicationArea = All;
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ApplicationArea = All;
                }
                field("Last Modified User"; Rec."Last Modified User")
                {
                    ApplicationArea = All;
                }
                field(ContinuityStartDate; ContinuityStartDate)
                {
                    ApplicationArea = All;
                    Caption = 'Continuity Start Date';
                }
                field(ContinuityEndDate; ContinuityEndDate)
                {
                    ApplicationArea = All;
                    Caption = 'Continuity End Date';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        //UpdateSourceType();
        "Sales CodeEditable" := rec."Source Type" <> rec."Source Type"::"All Customers"
    end;

    trigger OnAfterGetRecord()
    begin
        //UpdateSourceType();
        txtSalesCodeDesc := '';
        if rec."Source Type" = rec."Source Type"::"Customer Price Group" then begin
            if recCustPrice.Get(Rec."Source No.") then
                txtSalesCodeDesc := recCustPrice.Description
            else
                txtSalesCodeDesc := '';

        end else begin
            if rec."Source Type" = rec."Source Type"::Customer then begin
                if recCustomer.Get(Rec."Source No.") then
                    txtSalesCodeDesc := recCustomer.Name
                else
                    txtSalesCodeDesc := '';
            end else begin
                if rec."Source Type" = rec."Source Type"::Campaign then begin
                    if recCampaign.Get(Rec."Source No.") then
                        txtSalesCodeDesc := recCampaign.Description
                    else
                        txtSalesCodeDesc := '';
                end;
            end;
        end;

        txtProductdes := '';
        decStandardPrice := 0;
        if rec."Source Type" = rec."Source Type"::Customer then begin
            recCust.Get(Rec."Source No.");
            recSalesPrice.Reset;
            recSalesPrice.SetRange("Source Type", recSalesPrice."Source Type"::"Customer Price Group");
            recSalesPrice.SetRange("Source No.", recCust."Customer Price Group");
            //recSalesPrice.SETRANGE("Product Type",recSalesPrice."Product Type"::"Product Group");
            recSalesPrice.SetRange("Asset No.", Rec."Asset No.");
            recSalesPrice.SetRange("Price Type", recSalesPrice."Price Type"::Sale);
            if recSalesPrice.FindSet then begin
                repeat
                    txtProductdes := recSalesPrice."Source No.";
                    decStandardPrice := recSalesPrice."Unit Price";
                until recSalesPrice.Next = 0;
            end;
        end;

        //A/17.04.2019/SCST000002
        ContinuityStartDate := 0D;
        ContinuityEndDate := 0D;
        if Rec."Product Type" = Rec."Product Type"::Item then begin
            ItemCrossReference.Reset;
            ItemCrossReference.SetRange(ItemCrossReference."Item No.", Rec."Asset No.");
            if ItemCrossReference.FindFirst then begin
                ContinuityStartDate := ItemCrossReference."Palcement Start Date";
                ContinuityEndDate := ItemCrossReference."Placement End Date";
            end;
        end;

        if Rec."Product Type" = Rec."Product Type"::"Item Category" then begin
            recItem.Reset;
            recItem.SetRange("Item Category Code", Rec."Asset No.");
            if recItem.FindSet then begin
                ItemCrossReference.Reset;
                ItemCrossReference.SetRange("Item No.", recItem."No.");
                if ItemCrossReference.FindFirst then begin
                    ContinuityStartDate := ItemCrossReference."Palcement Start Date";
                    ContinuityEndDate := ItemCrossReference."Placement End Date";
                end;
                repeat
                    ItemCrossReference1.Reset;
                    ItemCrossReference1.SetRange("Item No.", recItem."No.");
                    if ItemCrossReference1.FindFirst then begin
                        if (ItemCrossReference1."Placement End Date" <> 0D) and (ItemCrossReference1."Placement End Date" < ContinuityEndDate) then begin
                            ContinuityStartDate := ItemCrossReference1."Palcement Start Date";
                            ContinuityEndDate := ItemCrossReference1."Placement End Date";
                        end;
                    end;
                until recItem.Next = 0;
            end;
        end;
        //E/17.04.2019/SCST000002
    end;

    trigger OnInit()
    begin
        SalesCodeFilterCtrlEnable := true;
        "Sales CodeEditable" := true;
    end;

    trigger OnOpenPage()
    begin
        GetRecFilters;
        SetRecFilters;
        Rec.SetRange(Discontinued, 0);
    end;

    var
        Cust: Record Customer;
        CustPriceGr: Record "Customer Price Group";
        Campaign: Record Campaign;
        SalesTypeFilter: Option Customer,"Customer Price Group","All Customers",Campaign,"None";
        SalesCodeFilter: Text[250];
        ItemNoFilter: Text[250];
        StartingDateFilter: Text[30];
        CurrencyCodeFilter: Text[250];
        Text000: Label 'All Customers';
        Text001: Label 'No %1 within the filter %2.';
        [InDataSet]
        "Sales CodeEditable": Boolean;
        [InDataSet]
        SalesCodeFilterCtrlEnable: Boolean;
        txtSalesCodeDesc: Text[50];
        recCustPrice: Record "Customer Price Group";
        recCampaign: Record Campaign;
        recCustomer: Record Customer;
        decStandardPrice: Decimal;
        recCust: Record Customer;
        recSalesPrice: Record "Price List Line";
        dtSTDStartDate: Date;
        txtProductdes: Text[50];
        ContinuityStartDate: Date;
        ContinuityEndDate: Date;
        ItemCrossReference: Record "Item Reference";
        recItem: Record Item;
        RecordFound: Boolean;
        ItemCrossReference1: Record "Item Reference";
        SourceType: Enum "Sales Price Source Type";

    procedure GetRecFilters()
    begin
        if Rec.GetFilters <> '' then begin
            if Rec.GetFilter("Source Type") <> '' then
                SalesTypeFilter := GetSalesTypeFilter
            else
                SalesTypeFilter := SalesTypeFilter::None;

            SalesCodeFilter := Rec.GetFilter("Source No.");
            ItemNoFilter := Rec.GetFilter("Asset No.");
            CurrencyCodeFilter := Rec.GetFilter("Currency Code");
        end;

        Evaluate(StartingDateFilter, Rec.GetFilter("Starting Date"));
    end;

    procedure SetRecFilters()
    begin
        SalesCodeFilterCtrlEnable := true;
        if SalesTypeFilter <> SalesTypeFilter::None then
            Rec.SetRange("Source Type", SalesTypeFilter)
        else
            Rec.SetRange("Source Type");

        if SalesTypeFilter in [SalesTypeFilter::"All Customers", SalesTypeFilter::None] then begin
            SalesCodeFilterCtrlEnable := false;
            SalesCodeFilter := '';
        end;

        if SalesCodeFilter <> '' then
            Rec.SetFilter("Source No.", SalesCodeFilter)
        else
            Rec.SetRange("Source No.");

        if StartingDateFilter <> '' then
            Rec.SetFilter("Starting Date", StartingDateFilter)
        else
            Rec.SetRange("Starting Date");

        if ItemNoFilter <> '' then begin
            Rec.SetFilter("Asset No.", ItemNoFilter);
        end else
            Rec.SetRange("Asset No.");

        if CurrencyCodeFilter <> '' then begin
            Rec.SetFilter("Currency Code", CurrencyCodeFilter);
        end else
            Rec.SetRange("Currency Code");

        case SalesTypeFilter of
            SalesTypeFilter::Customer:
                CheckFilters(DATABASE::Customer, SalesCodeFilter);
            SalesTypeFilter::"Customer Price Group":
                CheckFilters(DATABASE::"Customer Price Group", SalesCodeFilter);
            SalesTypeFilter::Campaign:
                CheckFilters(DATABASE::Campaign, SalesCodeFilter);
        end;
        CheckFilters(DATABASE::Item, ItemNoFilter);
        CheckFilters(DATABASE::Currency, CurrencyCodeFilter);

        CurrPage.Update(false);
    end;

    procedure GetCaption(): Text[250]
    var
        ObjTransl: Record "Object Translation";
        SourceTableName: Text[100];
        SalesSrcTableName: Text[100];
        Description: Text[250];
    begin
        GetRecFilters;
        "Sales CodeEditable" := SourceType <> SourceType::"All Customers";

        SourceTableName := '';
        if ItemNoFilter <> '' then
            SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 27);

        SalesSrcTableName := '';
        case SalesTypeFilter of
            SalesTypeFilter::Customer:
                begin
                    SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 18);
                    Cust."No." := SalesCodeFilter;
                    if Cust.Find then
                        Description := Cust.Name;
                end;
            SalesTypeFilter::"Customer Price Group":
                begin
                    SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 6);
                    CustPriceGr.Code := SalesCodeFilter;
                    if CustPriceGr.Find then
                        Description := CustPriceGr.Description;
                end;
            SalesTypeFilter::Campaign:
                begin
                    SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 5071);
                    Campaign."No." := SalesCodeFilter;
                    if Campaign.Find then
                        Description := Campaign.Description;
                end;
            SalesTypeFilter::"All Customers":
                begin
                    SalesSrcTableName := Text000;
                    Description := '';
                end;
        end;

        if SalesSrcTableName = Text000 then
            exit(StrSubstNo('%1 %2 %3', SalesSrcTableName, SourceTableName, ItemNoFilter));
        exit(StrSubstNo('%1 %2 %3 %4 %5', SalesSrcTableName, SalesCodeFilter, Description, SourceTableName, ItemNoFilter));
    end;

    procedure CheckFilters(TableNo: Integer; FilterTxt: Text[250])
    var
        FilterRecordRef: RecordRef;
        FilterFieldRef: FieldRef;
    begin
        if FilterTxt = '' then
            exit;
        Clear(FilterRecordRef);
        Clear(FilterFieldRef);
        FilterRecordRef.Open(TableNo);
        FilterFieldRef := FilterRecordRef.Field(1);
        FilterFieldRef.SetFilter(FilterTxt);
        if FilterRecordRef.IsEmpty then
            Error(Text001, FilterRecordRef.Caption, FilterTxt);
    end;

    local procedure SalesCodeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure SalesTypeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SalesCodeFilter := '';
        SetRecFilters;
    end;

    local procedure StartingDateFilterOnAfterValid()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure ItemNoFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure CurrencyCodeFilterOnAfterValid()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure GetSalesTypeFilter(): Integer
    begin
        case Rec.GetFilter("Source Type") of
            Format(Rec."Source Type"::Customer):
                exit(0);
            Format(Rec."Source Type"::"Customer Price Group"):
                exit(1);
            Format(Rec."Source Type"::"All Customers"):
                exit(2);
            Format(Rec."Source Type"::Campaign):
                exit(3);
        end;
    end;

    // local procedure UpdateSourceType()
    // var
    //     PriceSource: Record "Price Source";
    //     PriceListHeader: Record "Price List Header";
    // begin
    //     case PriceListHeader."Source Group" of
    //         "Price Source Group"::Customer:
    //             begin
    //                 // IsJobGroup := false;
    //                 // SourceType := "Sales Price Source Type".FromInteger(Rec."Source Type".AsInteger());
    //             end;
    //         "Price Source Group"::Job:
    //             begin
    //                 // IsJobGroup := true;
    //                 // JobSourceType := "Job Price Source Type".FromInteger(Rec."Source Type".AsInteger());
    //             end;
    //     end;
    //     PriceSource."Source Type" := Rec."Source Type";
    //     // IsParentAllowed := PriceSource.IsParentSourceAllowed();
    // end;
}

