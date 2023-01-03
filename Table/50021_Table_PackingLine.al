table 50021 "Packing Line"
{

    fields
    {
        field(1; "Packing No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Source Document Type"; Option)
        {
            OptionCaption = '  ,Warehouse Shipment,Sales Order,Transfer Order,Return Shipment';
            OptionMembers = "  ","Warehouse Shipment","Sales Order","Transfer Order","Return Shipment";
        }
        field(4; "Source Document No."; Code[20])
        {
        }
        field(5; "Location Code"; Code[10])
        {
            TableRelation = Location;
        }
        field(6; "Source No."; Code[20])
        {
        }
        field(7; "Source Name"; Text[50])
        {
        }
        field(8; Status; Option)
        {
            OptionCaption = 'Open,Release,Closed';
            OptionMembers = Open,Release,Closed;
        }
        field(9; "Box Type"; Option)
        {
            OptionCaption = ',Box,Bag,Carton';
            OptionMembers = ,Box,Bag,Carton;
        }
        field(10; "Box Code"; Code[20])
        {
            TableRelation = "Box Master"."Box Code" WHERE("Shipping Agent Service Code" = FIELD("Shipping Agent Service Code"));

            trigger OnValidate()
            begin
                CheckItemLine;
                GetPackingHeader;
                "Gross Weight" := 0;
                recPackingHeader.TESTFIELD("Source Document No.");
                recPackingHeader.TESTFIELD("Source Document Type");
                "Source Document Type" := recPackingHeader."Source Document Type";
                "Source Document No." := recPackingHeader."Source Document No.";
                "Location Code" := recPackingHeader."Location Code";
                "Source No." := recPackingHeader."Source No.";
                "Source Name" := recPackingHeader."Source Name";
                Status := recPackingHeader.Status;
                recBoxMaster.GET("Box Code");
                Height := recBoxMaster.Height;
                Width := recBoxMaster.Width;
                Length := recBoxMaster.Length;
                //Weight:=recBoxMaster."Box Weight";
                //"Gross Weight" := (Length*Width*Height)/139;
            end;
        }
        field(11; Height; Decimal)
        {
        }
        field(12; Width; Decimal)
        {
        }
        field(13; Length; Decimal)
        {
        }
        field(14; Weight; Decimal)
        {
        }
        field(15; "Gross Weight"; Decimal)
        {
        }
        field(16; "Shipping Agent Service Code"; Code[20])
        {
            CalcFormula = Lookup("Packing Header"."Shipping Agent Service Code" WHERE("Packing No." = FIELD("Packing No.")));
            FieldClass = FlowField;
        }
        field(17; "Tracking No."; Text[30])
        {
            Description = 'TND';
        }
        field(18; Image; BLOB)
        {
            Description = 'TND';
        }
        field(25; "Billed Weight"; Decimal)
        {
            Description = 'TND';
        }
        field(26; "Total Base Charge"; Decimal)
        {
            Description = 'TND';
        }
        field(27; INSURED_VALUE; Decimal)
        {
            Description = 'TND';
        }
        field(28; SIGNATURE_OPTION; Decimal)
        {
            Description = 'TND';
        }
        field(29; "Total Charges"; Decimal)
        {
            Description = 'TND';
        }
        field(30; "Total Discounts"; Decimal)
        {
            Description = 'TND';
        }
        field(31; "Total Surcharge"; Decimal)
        {
            Description = 'TND';
        }
        field(32; "Sales Order No."; Code[20])
        {
            Description = 'TND';
        }
        field(33; "Void Entry"; Boolean)
        {
            Description = 'Ravi_Void';
        }
        field(34; "No. Of  Lots"; Decimal)
        {
            Description = 'Handheld';
        }
    }

    keys
    {
        key(Key1; "Packing No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        recPackItem.RESET;
        recPackItem.SETRANGE("Packing No.", "Packing No.");
        recPackItem.SETRANGE("Packing Line No.", "Line No.");
        IF recPackItem.FINDSET THEN BEGIN
            IF CONFIRM('Do you want to delete Item Lines', TRUE) THEN
                recPackItem.DELETEALL(TRUE);
        END;
    end;

    trigger OnInsert()
    begin
        //IF "Line No."<>0 THEN BEGIN
        recPackLine.RESET;
        recPackLine.SETRANGE("Packing No.", "Packing No.");
        recPackLine.SETFILTER("Line No.", '<>%1', 0);
        IF recPackLine.FIND('+') THEN
            "Line No." := recPackLine."Line No." + 10000
        ELSE
            "Line No." := 10000;
        //END;
    end;

    var
        recPackingHeader: Record "Packing Header";
        recBoxMaster: Record "Box Master";
        recPackLine: Record "Packing Line";
        recPackItem: Record "Packing Item List";


    procedure GetPackingHeader()
    begin
        //IF xRec."Packing No."<>"Packing No." THEN
        recPackingHeader.GET("Packing No.");
    end;


    procedure ShowItemList()
    var
        PackingItemList: Page "Packing Item List";
        recPackingItem: Record "Packing Item List";
    begin
        GET("Packing No.", "Line No.");
        TESTFIELD("Box Code");


        PackingItemList.InitializePackingLine(Rec);

        PackingItemList.RUNMODAL;
    end;


    procedure CheckItemLine()
    begin
        recPackItem.RESET;
        recPackItem.SETRANGE("Packing No.", "Packing No.");
        recPackItem.SETRANGE("Packing Line No.", "Line No.");
        IF recPackItem.FIND('-') THEN
            ERROR('Remove Pack Item First');
    end;


    procedure TestStatusOpen()
    var
        recPackHeader: Record "Packing Header";
    begin
        IF recPackHeader.GET("Packing No.") THEN
            IF recPackHeader.Status <> recPackHeader.Status::Open THEN
                ERROR('Status Must be Open for Packing No. %1', recPackHeader."Packing No.");
    end;
}

