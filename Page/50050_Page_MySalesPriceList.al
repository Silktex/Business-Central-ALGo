page 50050 "My Sales Price List"
{
    Caption = 'Expired Sales Prices';
    DataCaptionExpression = 'Sales Price';
    DelayedInsert = true;
    PageType = List;
    SaveValues = true;
    SourceTable = "Price List Line";
    SourceTableView = WHERE("Source Group" = const(Customer), "Price List Code" = filter(<> ''));
    Editable = false;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                //ShowCaption = false;
                // field("Sales Type"; Rec."Sales Type")
                // {
                //     ApplicationArea = All;
                // }
                field("Price List Code"; Rec."Price List Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
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
                field(CustType; CustType)
                {
                    Caption = 'Customer Type';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(CustContact; CustContact)
                {
                    Caption = 'Contact';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(CustEmail; CustEmail)
                {
                    Caption = 'Email ADD';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Product Type"; Rec."Asset Type")
                {
                    Caption = 'Product Type';
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Asset No.")
                {
                    ApplicationArea = All;
                    Caption = 'Product Code';
                }
                field(ProductDescription; ProductDescription)
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(CountryOfOrigin; CountryOfOrigin)
                {
                    Caption = 'Country of Origin';
                    ApplicationArea = All;
                    Editable = false;
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
                field(Expired; Rec.Expired)
                {
                    ApplicationArea = All;
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
                field(BackingType; BackingType)
                {
                    Caption = 'Backing Type';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(BackingPrice; BackingPrice)
                {
                    Caption = 'Backing Price';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(TaxGroupCode; TaxGroupCode)
                {
                    Caption = 'Tax Group Code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(TexPercentage; TaxPercentage)
                {
                    Caption = 'Tax %';
                    ApplicationArea = All;
                    Editable = false;
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

    trigger OnAfterGetRecord()
    begin
        //UpdateSourceType();
        txtSalesCodeDesc := '';
        BackingType := '';
        BackingPrice := 0;
        TaxGroupCode := '';
        TaxPercentage := 0;
        CountryOfOrigin := '';

        Backing.Reset();
        if rec."Source Type" = rec."Source Type"::"Customer Price Group" then begin
            if recCustPrice.Get(Rec."Source No.") then
                txtSalesCodeDesc := recCustPrice.Description
            else
                txtSalesCodeDesc := '';


            Backing.SetRange("Customer Type", Backing."Customer Type"::"Customer Posting Group");
            Backing.SetRange("Customer Code", Rec."Source No.");

        end else begin
            if rec."Source Type" = rec."Source Type"::Customer then begin
                Backing.SetRange("Customer Type", Backing."Customer Type"::Customer);
                Backing.SetRange("Customer Code", Rec."Source No.");

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
        CustContact := '';
        CustEmail := '';
        CustType := '';
        decStandardPrice := 0;
        if rec."Source Type" = rec."Source Type"::Customer then begin
            if recCust.Get(Rec."Source No.") then begin
                CustContact := recCust.Contact;
                CustEmail := recCust."E-Mail";
                CustType := recCust."Customer Posting Group";
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
        end;

        //A/17.04.2019/SCST000002
        ProductDescription := '';
        ContinuityStartDate := 0D;
        ContinuityEndDate := 0D;
        if Rec."Asset Type" = Rec."Asset Type"::Item then begin
            Backing.SetRange("Product Type", Backing."Product Type"::Item);
            Backing.SetRange("Product Code", Rec."Asset No.");
            if Backing.FindFirst() then begin
                BackingType := Backing."Resc. Code";
                BackingPrice := Backing."Resc. Price";
            end;

            ItemCrossReference.Reset;
            ItemCrossReference.SetRange(ItemCrossReference."Item No.", Rec."Asset No.");
            if ItemCrossReference.FindFirst then begin
                ContinuityStartDate := ItemCrossReference."Palcement Start Date";
                ContinuityEndDate := ItemCrossReference."Placement End Date";
            end;
        end;


        if Rec."Asset Type" = Rec."Asset Type"::"Item Category" then begin
            Backing.SetRange("Product Type", Backing."Product Type"::"Item Category Code");
            Backing.SetRange("Product Code", Rec."Asset No.");
            if Backing.FindFirst() then begin
                BackingType := Backing."Resc. Code";
                BackingPrice := Backing."Resc. Price";
            end;

            if ItemCategory.get(Rec."Asset No.") then
                ProductDescription := ItemCategory.Description;

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

                    if TaxGroupCode = '' then begin
                        TaxGroupCode := recItem."Tax Group Code";
                        TaxDetails.Reset();
                        TaxDetails.SetRange("Tax Group Code", TaxGroupCode);
                        if TaxDetails.FindLast() then
                            TaxPercentage := TaxDetails."Tax Below Maximum";
                    end;

                    if CountryOfOrigin = '' then
                        if Country.get(recItem."Country/Region of Origin Code") then
                            CountryOfOrigin := Country.Name;

                until recItem.Next = 0;
            end;
        end;
        //E/17.04.2019/SCST000002
    end;


    var
        TaxDetails: Record "Tax Detail";
        Cust: Record Customer;
        CustPriceGr: Record "Customer Price Group";
        Campaign: Record Campaign;
        Country: Record "Country/Region";
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
        CustContact: Text[100];
        CustEmail: Text[250];
        CustType: Text[30];
        ProductDescription: Text[100];
        ItemCategory: Record "Item Category";
        Backing: Record "BACKING TABLE FOR NAV";
        BackingType: Text[100];
        Resource: Record Resource;
        BackingPrice: Decimal;
        TaxGroupCode: Text[20];
        TaxPercentage: Decimal;
        ExpiredPrices: Option " ",Yes,No;
        CountryOfOrigin: Text[100];


}

