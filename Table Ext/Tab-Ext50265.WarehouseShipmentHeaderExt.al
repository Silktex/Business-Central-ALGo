tableextension 50265 "Warehouse Shipment Header_Ext" extends "Warehouse Shipment Header"
{
    fields
    {
        modify("Shipping Agent Code")
        {
            trigger OnAfterValidate()
            begin
                "Bin Code" := '';
            end;
        }
        field(50000; "Charges Pay By"; Option)
        {
            OptionCaption = ' ,SENDER,RECEIVER';
            OptionMembers = " ",SENDER,RECEIVER;
        }
        field(50001; "Tracking No."; Text[30])
        {
            Editable = true;
        }
        field(50002; "Tracking Status"; Code[20])
        {
        }
        field(50003; "Box Code"; Code[20])
        {
            TableRelation = "Box Master"."Box Code" WHERE("Shipping Agent Service Code" = FIELD("Shipping Agent Service Code"));

            trigger OnValidate()
            begin
                IF xRec."Shipping Agent Service Code" = "Shipping Agent Service Code" THEN
                    EXIT;
                "Box Code" := '';//"Box Code" := '';
            end;
        }
        field(50004; "No. of Boxes"; Integer)
        {

            trigger OnValidate()
            begin
                CalcGrossWeight;
            end;
        }
        field(50005; "Shipment Time"; Time)
        {
        }
        field(50006; "Track On Header"; Boolean)
        {
        }
        field(50007; Picture; BLOB)
        {
        }
        field(50008; "Net Weight"; Decimal)
        {
            CalcFormula = Sum("Warehouse Shipment Line"."Net Weight" WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                CalcGrossWeight;
            end;
        }
        field(50009; "Gross Weight"; Decimal)
        {
        }
        field(50010; "Shipping Account No."; Code[20])
        {
        }
        field(50011; "Handling Charges"; Decimal)
        {
        }
        field(50012; "Insurance Charges"; Decimal)
        {
        }
        field(50013; Path; Text[100])
        {
            Editable = false;
            ExtendedDatatype = URL;
        }
        field(50014; "Insurance Amount"; Decimal)
        {
        }
        field(50015; "Cash On Delivery"; Boolean)
        {
        }
        field(50016; Residential; Boolean)
        {
        }
        field(50017; Rate; Decimal)
        {
        }
        field(50018; "Freight Amount"; Decimal)
        {
        }
        field(50019; "Signature Required"; Boolean)
        {
        }
        field(50020; "COD Amount"; Decimal)
        {
        }
        field(50021; "Packing List No."; Code[20])
        {
            CalcFormula = Lookup("Packing Header"."Packing No." WHERE("Source Document No." = FIELD("No."), "Void Entry" = FILTER(false)));
            FieldClass = FlowField;
        }
        field(50055; "Third Party"; Boolean)
        {
        }
        field(50056; "Third Party Account No."; Code[20])
        {
        }
        field(50057; "Label Type"; Option)
        {
            OptionCaption = ',Domestic,International';
            OptionMembers = ,Domestic,International;
        }
        field(50058; "RocketShip Tracking No."; Text[30])
        {
            CalcFormula = Lookup("Packing Line"."Tracking No." WHERE("Source Document Type" = FILTER("Warehouse Shipment"), "Source Document No." = FIELD("No."), "Void Entry" = FILTER(false)));
            Description = 'TND';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50059; "Gross Weight LB"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Stamps';
        }
        field(50060; "Gross Weight Oz"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Stamps';
        }
        field(50061; "Service Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Stamps';
            OptionCaption = ' ,USPS,USFC';
            OptionMembers = " ",USPS,USFC;
        }
    }

    PROCEDURE CalcGrossWeight();
    VAR
        recBoxMaster: Record "Box Master";
    BEGIN
        CALCFIELDS("Net Weight");
        IF recBoxMaster.GET("Box Code") THEN
            "Gross Weight" := "Net Weight" + "No. of Boxes" * recBoxMaster."Box Weight";
    END;
}
