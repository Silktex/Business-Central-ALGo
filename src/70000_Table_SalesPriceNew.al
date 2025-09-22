table 70000 "Sales Price New"
{
    Caption = 'Sales Price';
    LookupPageID = "Sales Prices SC";

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            NotBlank = true;
            TableRelation = IF ("Product Type" = CONST(Item)) Item ELSE
            IF ("Product Type" = CONST("Item Category")) "Item Category".Code;


            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;
                if IsHandled then
                    exit;
                IF "Product Type" = "Product Type"::Item THEN BEGIN
                    if "Item No." <> xRec."Item No." then begin
                        Item.Get("Item No.");
                        "Unit of Measure Code" := Item."Sales Unit of Measure";
                        "Variant Code" := '';
                    end;
                end;
                if "Sales Type" = "Sales Type"::"Customer Price Group" then
                    if CustPriceGr.Get("Sales Code") and
                       (CustPriceGr."Allow Invoice Disc." = "Allow Invoice Disc.")
                    then
                        exit;

                UpdateValuesFromItem;
            end;
        }
        field(2; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            TableRelation = IF ("Sales Type" = CONST("Customer Price Group")) "Customer Price Group"
            ELSE
            IF ("Sales Type" = CONST(Customer)) Customer
            ELSE
            IF ("Sales Type" = CONST(Campaign)) Campaign;

            trigger OnValidate()
            begin
                if "Sales Code" <> '' then
                    case "Sales Type" of
                        "Sales Type"::"All Customers":
                            Error(Text001, FieldCaption("Sales Code"));
                        "Sales Type"::"Customer Price Group":
                            begin
                                CustPriceGr.Get("Sales Code");
                                "Price Includes VAT" := CustPriceGr."Price Includes VAT";
                                "VAT Bus. Posting Gr. (Price)" := CustPriceGr."VAT Bus. Posting Gr. (Price)";
                                "Allow Line Disc." := CustPriceGr."Allow Line Disc.";
                                "Allow Invoice Disc." := CustPriceGr."Allow Invoice Disc.";
                            end;
                        "Sales Type"::Customer:
                            begin
                                Cust.Get("Sales Code");
                                "Currency Code" := Cust."Currency Code";
                                "Price Includes VAT" := Cust."Prices Including VAT";
                                "VAT Bus. Posting Gr. (Price)" := Cust."VAT Bus. Posting Group";
                                "Allow Line Disc." := Cust."Allow Line Disc.";
                            end;
                        "Sales Type"::Campaign:
                            begin
                                Campaign.Get("Sales Code");
                                "Starting Date" := Campaign."Starting Date";
                                "Ending Date" := Campaign."Ending Date";
                            end;
                    end;
            end;
        }
        field(3; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(4; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                if ("Starting Date" > "Ending Date") and ("Ending Date" <> 0D) then
                    Error(Text000, FieldCaption("Starting Date"), FieldCaption("Ending Date"));

                if CurrFieldNo = 0 then
                    exit;

                if "Starting Date" <> 0D then
                    if "Sales Type" = "Sales Type"::Campaign then
                        Error(Text002, "Sales Type");
            end;
        }
        field(5; "Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;

            trigger OnValidate()
            begin
                "Last Modified Date" := TODAY;
                "Last Modified User" := USERID;
                "Update Price NOP" := TRUE;
            end;
        }
        field(7; "Price Includes VAT"; Boolean)
        {
            Caption = 'Price Includes VAT';
        }
        field(10; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(11; "VAT Bus. Posting Gr. (Price)"; Code[20])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            TableRelation = "VAT Business Posting Group";
        }
        field(13; "Sales Type"; Enum "Sales Price Type")
        {
            Caption = 'Sales Type';

            trigger OnValidate()
            begin
                if "Sales Type" <> xRec."Sales Type" then begin
                    Validate("Sales Code", '');
                    UpdateValuesFromItem;
                end;
            end;
        }
        field(14; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                "Last Modified Date" := TODAY;
                "Last Modified User" := USERID;
                "Update Price NOP" := TRUE;
            end;
        }
        field(15; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                if CurrFieldNo = 0 then
                    exit;

                Validate("Starting Date");

                if "Ending Date" <> 0D then
                    if "Sales Type" = "Sales Type"::Campaign then
                        Error(Text002, "Sales Type");
            end;
        }
        field(720; "Coupled to CRM"; Boolean)
        {
            Caption = 'Coupled to Dynamics 365 Sales';
            Editable = false;
        }
        field(5400; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(5700; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(7001; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(50000; "Product Type"; Option)
        {
            OptionCaption = ',Item,Item Category';
            OptionMembers = ,Item,"Item Category";
        }
        field(50001; "Location Code"; Code[10])
        {
            TableRelation = Location;
        }
        field(50002; Expired; Boolean)
        {
        }
        field(50003; Discontinued; Option)
        {
            InitValue = Active;
            OptionCaption = 'Active,Inactive,Discontinued';
            OptionMembers = Active,Inactive,Discontinued;
        }
        field(50004; "Last Modified Date"; Date)
        {
        }
        field(50005; "Last Modified User"; Code[50])
        {
        }
        field(50006; "Update Price NOP"; Boolean)
        {
            Description = 'NOP';
        }
        field(50007; "Customer Posting Group"; Code[20])
        {
            CalcFormula = Lookup(Customer."Customer Posting Group" WHERE("No." = FIELD("Sales Code")));
            Caption = 'Customer Posting Group';
            FieldClass = FlowField;
            NotBlank = false;
            TableRelation = "Customer Posting Group";
        }
        field(50008; "Special Price"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Special Price Comments"; Text[200])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Item No.", "Sales Type", "Sales Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
        {
            Clustered = true;
        }
        key(Key2; "Sales Type", "Sales Code", "Item No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
        {
        }
        key(Key3; SystemModifiedAt)
        {
        }
        key(Key4; "Coupled to CRM")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(Brick; "Sales Type", "Sales Code", "Item No.", "Starting Date", "Unit Price", "Ending Date")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Sales Type" = "Sales Type"::"All Customers" then
            "Sales Code" := ''
        else
            TestField("Sales Code");
        TestField("Item No.");
        "Last Modified Date" := TODAY;
        "Last Modified User" := USERID;
        "Update Price NOP" := TRUE;
    end;

    trigger OnModify()
    begin
        "Last Modified Date" := TODAY;
        "Last Modified User" := USERID;
        "Update Price NOP" := TRUE;
    end;

    trigger OnRename()
    begin
        if "Sales Type" <> "Sales Type"::"All Customers" then
            TestField("Sales Code");
        TestField("Item No.");
    end;

    var
        Text001: Label '%1 must be blank.';
        CustPriceGr: Record "Customer Price Group";
        Cust: Record Customer;
        Campaign: Record Campaign;
        Item: Record Item;
        Text000: Label '%1 cannot be after %2';
        Text002: Label 'If Sales Type = %1, then you can only change Starting Date and Ending Date from the Campaign Card.';


    local procedure UpdateValuesFromItem()
    begin
        if Item.Get("Item No.") then begin
            "Allow Invoice Disc." := Item."Allow Invoice Disc.";
            if "Sales Type" = "Sales Type"::"All Customers" then begin
                "Price Includes VAT" := Item."Price Includes VAT";
                "VAT Bus. Posting Gr. (Price)" := Item."VAT Bus. Posting Gr. (Price)";
            end;
        end;
    end;

    procedure CopySalesPriceToCustomersSalesPrice(var SalesPrice: Record "Sales Price New"; CustNo: Code[20])
    var
        NewSalesPrice: Record "Sales Price New";
    begin
        if SalesPrice.FindSet then
            repeat
                NewSalesPrice := SalesPrice;
                NewSalesPrice."Sales Type" := NewSalesPrice."Sales Type"::Customer;
                NewSalesPrice."Sales Code" := CustNo;
                if NewSalesPrice.Insert() then;
            until SalesPrice.Next() = 0;
    end;

}

