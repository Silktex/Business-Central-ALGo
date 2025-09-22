tableextension 50209 Item_Ext extends Item
{
    fields
    {
        field(50000; Weight; Decimal)
        {
        }
        field(50006; "Quantity Variance %"; Decimal)
        {
        }
        field(50010; Customer; Text[200])
        {
            Caption = 'Customer';
            Description = 'Customer';
        }
        field(50011; "Product Line"; Text[50])
        {
            Caption = 'Product Line';
            Description = 'Product Line';
        }
        field(50012; "Short Piece"; Decimal)
        {
            Caption = 'Short Piece';
            Description = 'Short Piece';
        }
        field(50013; "ReOrder Tab"; Text[15])
        {
            Caption = 'ReOrder Tab';
            Description = 'ReOrder Tab';
        }
        field(50014; "Qty. on Sales Quote"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST(Quote), Type = CONST(Item), "No." = FIELD("No."), "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Location Code" = FIELD("Location Filter"), "Drop Shipment" = FIELD("Drop Shipment Filter"), "Variant Code" = FIELD("Variant Filter"), "Shipment Date" = FIELD("Date Filter")));
            Caption = 'Qty. on Sales Quote';
            DecimalPlaces = 0 : 5;
            Description = 'SPD MS 040815';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50015; "Warp Color"; Text[20])
        {
            Description = 'CFT RS 070716';
        }
        field(50016; Status; Option)
        {
            OptionCaption = ' ,Current,Disc,Stkr';
            OptionMembers = " ",Current,Disc,Stkr;
        }
        field(50017; "ECOM Insert"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'NOP';
        }
        field(50025; "ReOrder Days"; Integer)
        {
        }
        field(50026; Drop; Boolean)
        {
            Description = 'SCST000003';

            trigger OnValidate()
            begin

                IF xRec.Drop <> Drop THEN BEGIN
                    IF Drop = TRUE THEN BEGIN
                        "ReOrder Tab" := 'DNR';
                        MODIFY;
                    END;
                END;
            end;
        }
        field(50100; ShowOnHomePage; Boolean)
        {
            Description = 'NOP Commorce';
        }
        field(50101; DisplayStockAvailability; Boolean)
        {
            Description = 'ECOM';
        }
        field(50102; DisplayStockQuantity; Boolean)
        {
            Description = 'ECOM';
        }
        field(50103; Published; Boolean)
        {
            Description = 'ECOM';
        }
        field(50104; AdminComment; Text[30])
        {
            Description = 'NOP Commorce';
        }
        field(50105; "Vendor Name"; Text[100])
        {
            CalcFormula = Lookup(Vendor."No." WHERE(Name = FIELD("Vendor No.")));
            FieldClass = FlowField;
        }
        field(50106; Backing; Option)
        {
            Caption = 'Backing';
            OptionMembers = " ",Prebacked,"To be Backed","TO BE BACKED+C6","Alta is Required","TO BE BACKED+PILLING TREATMENT","TO BE BACKED+C0 FINISH","C0 Finish";
        }
        field(50107; "Reorder Calculation Year"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'RCY14';
        }
    }
}
