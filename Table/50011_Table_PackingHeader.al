table 50011 "Packing Header"
{

    fields
    {
        field(1; "Packing No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Packing No." <> xRec."Packing No." THEN BEGIN
                    recSalesSetup.GET;
                    NoSeriesMgt.TestManual(recSalesSetup."Packing No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Source Document Type"; Option)
        {
            OptionCaption = '  ,Warehouse Shipment,Sales Order,Transfer Order,Return Shipment';
            OptionMembers = "  ","Warehouse Shipment","Sales Order","Transfer Order","Return Shipment";

            trigger OnLookup()
            begin
                IF "Source Document Type" <> xRec."Source Document Type" THEN BEGIN
                    CheckPackLine;
                    VALIDATE("Source Document No.", '');
                END;
            end;
        }
        field(3; "Source Document No."; Code[20])
        {
            TableRelation = IF ("Source Document Type" = FILTER('Warehouse Shipment')) "Warehouse Shipment Header"."No." WHERE(Status = CONST(Released)) ELSE
            IF ("Source Document Type" = FILTER('Sales Order')) "Sales Header"."No." WHERE("Document Type" = CONST(Order), Status = CONST(Released)) ELSE
            IF ("Source Document Type" = FILTER('Return Shipment')) "Purchase Header"."No." WHERE("Document Type" = CONST("Return Order"), Status = CONST(Released)) ELSE
            IF ("Source Document Type" = FILTER('Transfer Order')) "Transfer Header"."No." WHERE(Status = CONST(Released));

            trigger OnValidate()
            begin
                IF "Source Document No." <> xRec."Source Document No." THEN
                    CheckPackLine;
                IF "Source Document No." <> '' THEN BEGIN
                    IF "Source Document Type" = "Source Document Type"::"Sales Order" THEN BEGIN
                        IF NOT recSalesHeader.GET(recSalesHeader."Document Type"::Order, "Source Document No.") THEN
                            ERROR('Order Not Find')
                        ELSE BEGIN
                            IF recSalesHeader.Status = recSalesHeader.Status::Released THEN BEGIN
                                "Location Code" := recSalesHeader."Location Code";
                                "Shipping Agent Code" := recSalesHeader."Shipping Agent Code";
                                "Shipping Agent Service Code" := recSalesHeader."Shipping Agent Service Code";
                                "Source No." := recSalesHeader."Sell-to Customer No.";
                                "Source Name" := recSalesHeader."Sell-to Customer Name";
                                "Shipment Method Code" := recSalesHeader."Shipment Method Code";
                            END ELSE BEGIN
                                ERROR('First Release Sales Order');
                            END;
                        END;
                    END ELSE BEGIN
                        IF "Source Document Type" = "Source Document Type"::"Transfer Order" THEN BEGIN
                            IF NOT recTransferHeader.GET("Source Document No.") THEN
                                ERROR('Transfer Order Not Find')
                            ELSE BEGIN
                                IF recTransferHeader.Status = recTransferHeader.Status::Released THEN BEGIN
                                    "Location Code" := recTransferHeader."Transfer-to Code";
                                    "Shipping Agent Code" := recTransferHeader."Shipping Agent Code";
                                    "Shipping Agent Service Code" := recTransferHeader."Shipping Agent Service Code";
                                    "Source No." := recTransferHeader."Transfer-from Code";
                                    "Source Name" := recTransferHeader."Transfer-from Name";
                                    "Shipment Method Code" := recTransferHeader."Shipment Method Code";
                                END ELSE BEGIN
                                    ERROR('First Release Transfer Order');
                                END;
                            END;
                        END ELSE BEGIN
                            IF "Source Document Type" = "Source Document Type"::"Warehouse Shipment" THEN BEGIN
                                IF NOT recWarehouseHeader.GET("Source Document No.") THEN
                                    ERROR('Warehouse Shipment Not Find')
                                ELSE BEGIN
                                    IF recWarehouseHeader.Status = recWarehouseHeader.Status::Released THEN BEGIN
                                        recWarehouseLine.RESET;
                                        recWarehouseLine.SETRANGE("No.", recWarehouseHeader."No.");
                                        IF recWarehouseLine.FIND('-') THEN;
                                        "Location Code" := recWarehouseLine."Location Code";
                                        "Shipping Agent Code" := recWarehouseHeader."Shipping Agent Code";
                                        "Shipping Agent Service Code" := recWarehouseHeader."Shipping Agent Service Code";
                                        "Shipment Method Code" := recWarehouseHeader."Shipment Method Code";
                                        IF (recWarehouseLine."Source Type" = 37) AND (recWarehouseLine."Source Subtype" = 1) THEN BEGIN
                                            recSalesHeader.GET(recSalesHeader."Document Type"::Order, recWarehouseLine."Source No.");
                                            "Source No." := recSalesHeader."Sell-to Customer No.";
                                            "Source Name" := recSalesHeader."Sell-to Customer Name";
                                        END;
                                    END ELSE BEGIN
                                        ERROR('First Release Warehouse Shipment');
                                    END;
                                END;
                            END;

                        END;
                    END;
                    //END;
                    //,Warehouse Shipment,Sales Order,Transfer Order,Return Shipment
                END ELSE BEGIN
                    "Location Code" := '';
                    "Shipping Agent Code" := '';
                    "Shipping Agent Service Code" := '';
                    "Source No." := '';
                    "Source Name" := '';
                    "Shipment Method Code" := '';
                END;
            end;
        }
        field(4; "Location Code"; Code[10])
        {
            TableRelation = Location;
        }
        field(5; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(6; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";

            trigger OnValidate()
            begin
                IF "Shipping Agent Code" <> xRec."Shipping Agent Code" THEN
                    VALIDATE("Shipping Agent Service Code", '');
            end;
        }
        field(7; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code WHERE("Shipping Agent Code" = FIELD("Shipping Agent Code"));
        }
        field(8; "Source No."; Code[20])
        {
        }
        field(9; "Source Name"; Text[50])
        {
        }
        field(10; Status; Option)
        {
            OptionCaption = 'Open,Release,Closed';
            OptionMembers = Open,Release,Closed;
        }
        field(11; "Posted Document No."; Code[20])
        {
        }
        field(12; "Packing Date"; Date)
        {
        }
        field(13; "Shipment Date"; Date)
        {
        }
        field(14; "Closing Date"; Date)
        {
        }
        field(15; "No. Series"; Code[10])
        {
        }
        field(16; "Tracking No."; Code[30])
        {
        }
        field(17; "Sales Order No."; Code[20])
        {
            Caption = 'Order No.';
            Description = 'TND';
        }
        field(18; "Creation Date"; Date)
        {
            Description = 'TND';
        }
        field(19; "Service Name"; Code[30])
        {
            Description = 'TND';
        }
        field(20; "Transaction No."; Code[30])
        {
            Description = 'TND';
        }
        field(21; "No. of Boxes"; Integer)
        {
            CalcFormula = Count("Packing Line" WHERE("Packing No." = FIELD("Packing No.")));
            Description = 'TND';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Shipping Account No"; Code[10])
        {
            Description = 'TND';
        }
        field(23; "Charges Pay By"; Text[10])
        {
            Description = 'TND';
        }
        field(24; "Gross Weight"; Decimal)
        {
            CalcFormula = Sum("Packing Line"."Gross Weight" WHERE("Source Document No." = FIELD("Source Document No."), "Packing No." = FIELD("Packing No.")));
            Description = 'TND';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; "Handling Charges"; Decimal)
        {
            Description = 'TND';
        }
        field(26; "Insurance Charges"; Decimal)
        {
            Description = 'TND';
        }
        field(27; "Cash On Delivery"; Boolean)
        {
            Description = 'TND';
        }
        field(28; "Signature Required"; Boolean)
        {
            Description = 'TND';
        }
        field(29; "COD Amount"; Decimal)
        {
            Description = 'TND';
        }
        field(30; "Freight Amount"; Decimal)
        {
            Description = 'NNS';
        }
        field(31; RSRateResponse; BLOB)
        {
            Description = 'NNS';
            SubType = Memo;
        }
        field(32; RSGetRatesURL; BLOB)
        {
            Description = 'NNS';
            SubType = Memo;
        }
        field(33; RSCreateShipmentURL; BLOB)
        {
            Description = 'NNS';
            SubType = Memo;
        }
        field(34; RSShipmentResponse; BLOB)
        {
            Description = 'NNS';
            SubType = Memo;
        }
        field(35; "Void Entry"; Boolean)
        {
            Description = 'Void';
        }
        field(36; "Insurance Value"; Decimal)
        {
            Description = 'Void';
        }
    }

    keys
    {
        key(Key1; "Packing No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        RecWhseShpmnt: Record "Warehouse Shipment Header";
    begin
        IF "Source Document Type" = "Source Document Type"::"Warehouse Shipment" THEN BEGIN
            RecWhseShpmnt.RESET;
            RecWhseShpmnt.SETRANGE("No.", "Source Document No.");
            IF RecWhseShpmnt.FINDFIRST THEN
                IF RecWhseShpmnt."Packing List No." = "Packing No." THEN BEGIN
                    RecWhseShpmnt."Packing List No." := '';
                    RecWhseShpmnt.MODIFY;
                END;
        END;
    end;

    trigger OnInsert()
    begin
        IF "Packing No." = '' THEN BEGIN
            recSalesSetup.GET();
            recSalesSetup.TESTFIELD("Packing No.");
            if NoSeriesMgt.AreRelated(recSalesSetup."Packing No.", xRec."No. Series") then
                "No. Series" := xRec."No. Series"
            else
                "No. Series" := recSalesSetup."Packing No.";
            "Packing No." := NoSeriesMgt.GetNextNo("No. Series");
        END;
    end;

    var
        recSalesSetup: Record "Warehouse Setup";
        NoSeriesMgt: Codeunit "No. Series";
        recPackingHeader: Record "Packing Header";
        recSalesHeader: Record "Sales Header";
        recTransferHeader: Record "Transfer Header";
        recWarehouseHeader: Record "Warehouse Shipment Header";
        recWarehouseLine: Record "Warehouse Shipment Line";
        recPackLine: Record "Packing Line";
        Employee: Record Employee;


    procedure AssistEdit(OldPackingHeader: Record "Packing Header"): Boolean
    var
        PackingHeader2: Record "Packing Header";
    begin
        //WITH recPackingHeader DO BEGIN
        COPY(Rec);
        recSalesSetup.GET;
        recSalesSetup.TESTFIELD("Packing No.");

        // IF NoSeriesMgt.SelectSeries(recSalesSetup."Packing No.", OldPackingHeader."No. Series", recPackingHeader."No. Series") THEN BEGIN
        //     NoSeriesMgt.SetSeries(recPackingHeader."Packing No.");
        //     IF PackingHeader2.GET(recPackingHeader."Packing No.") THEN
        //         ERROR('Packing No. %1 Already Exist', recPackingHeader."Packing No.");
        //     Rec := recPackingHeader;
        //     EXIT(TRUE);
        // END;

        if NoSeriesMgt.LookupRelatedNoSeries(recSalesSetup."Packing No.", xRec."No. Series", "No. Series") then begin
            "Packing No." := NoSeriesMgt.GetNextNo("No. Series");
            exit(true);
        end;
        //END;
    end;


    procedure CheckPackLine()
    begin
        recPackLine.RESET;
        recPackLine.SETRANGE("Packing No.", "Packing No.");
        IF recPackLine.FINDFIRST THEN
            ERROR('Remove Packing Line First');
    end;
}

