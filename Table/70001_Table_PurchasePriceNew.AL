table 70001 "Purchase Price New"
{
    Caption = 'Purchase Price';
    LookupPageID = "Purchase Prices SC";

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            NotBlank = true;
            TableRelation = IF ("Product Type" = CONST(Item)) Item ELSE
            IF ("Product Type" = CONST("Item Category")) "Item Category".Code;

            trigger OnValidate()
            begin
                if "Item No." <> xRec."Item No." then begin
                    "Unit of Measure Code" := '';
                    "Variant Code" := '';
                end;
            end;
        }
        field(2; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            NotBlank = false;
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                if Vend.Get("Vendor No.") then
                    "Currency Code" := Vend."Currency Code";
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
            end;
        }
        field(5; "Direct Unit Cost"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
            MinValue = 0;
        }
        field(14; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(15; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                Validate("Starting Date");
            end;
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
        field(50000; "Purchase Type"; Option)
        {
            Caption = 'Purchase Type';
            OptionCaption = 'Vendor,All Vendors';
            OptionMembers = Vendor,"All Vendors";

            trigger OnValidate()
            begin
                /*
                IF "Purchase Type" <> xRec."Purchase Type" THEN BEGIN
                  VALIDATE("Vendor No.",'');
                  UpdateValuesFromItem;
                END;
                 */

            end;
        }
        field(50001; "Product Type"; Option)
        {
            OptionCaption = ',Item,Item Category';
            OptionMembers = ,Item,"Item Category";
        }
    }

    keys
    {
        key(Key1; "Item No.", "Vendor No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
        {
            Clustered = true;
        }
        key(Key2; "Vendor No.", "Item No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Item No.", "Vendor No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
        {
        }
    }

    trigger OnInsert()
    begin
        IF "Purchase Type" = "Purchase Type"::"All Vendors" THEN
            "Vendor No." := ''
        ELSE
            TestField("Vendor No.");
        TestField("Item No.");
    end;

    trigger OnRename()
    begin
        IF "Purchase Type" = "Purchase Type"::"All Vendors" THEN
            TestField("Vendor No.");
        TestField("Item No.");
    end;

    var
        Vend: Record Vendor;
        Text000: Label '%1 cannot be after %2';


    procedure CopyPurchPriceToVendorsPurchPrice(var PurchPrice: Record "Purchase Price New"; VendNo: Code[20])
    var
        NewPurchasePrice: Record "Purchase Price New";
    begin
        if PurchPrice.FindSet then
            repeat
                NewPurchasePrice := PurchPrice;
                NewPurchasePrice."Vendor No." := VendNo;
                if NewPurchasePrice.Insert() then;
            until PurchPrice.Next() = 0;
    end;


}

