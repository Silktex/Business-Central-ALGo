table 50013 "Packing Item List"
{

    fields
    {
        field(1; "Packing No."; Code[20])
        {
            TableRelation = "Packing Header";
        }
        field(2; "Packing Line No."; Integer)
        {
        }
        field(3; "Source Document Type"; Option)
        {
            OptionCaption = ' ,Warehouse Shipment,Sales Order,Transfer Header,Return Shipment';
            OptionMembers = "  ","Warehouse Shipment","Sales Order","Transfer Order","Return Shipment";
        }
        field(4; "Source Document No."; Code[20])
        {
        }
        field(5; "Line No."; Integer)
        {
        }
        field(6; "Item No."; Code[20])
        {
            TableRelation = Item;
        }
        field(7; Quantity; Decimal)
        {

            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(8; "Item Name"; Text[50])
        {
        }
        field(9; "Unit Price"; Decimal)
        {
        }
        field(10; "Source Document Line No."; Integer)
        {
        }
        field(11; "Lot No."; Code[20])
        {
            //TableRelation = if ("Source Document Type" = const("Warehouse Shipment")) "Registered Whse. Activity Line"."Lot No." where("Whse. Document No." = field("Source Document No."), "Whse. Document Line No." = field("Source Document Line No."));
            // trigger OnValidate()
            // var
            //     RegPickLine: Record "Registered Whse. Activity Line";
            //     LotQty: Decimal;
            // begin
            //     Rec.TestField("Source Document No.");
            //     Rec.TestField("Source Document Line No.");

            //     LotQty := 0;
            //     if Rec."Source Document Type" = Rec."Source Document Type"::"Warehouse Shipment" then begin
            //         RegPickLine.SetRange("Whse. Document No.", "Source Document No.");
            //         RegPickLine.SetRange("Whse. Document Line No.", "Source Document Line No.");
            //         RegPickLine.SetRange("Lot No.", "Lot No.");
            //         RegPickLine.SetRange("Action Type", RegPickLine."Action Type"::Place);
            //         if RegPickLine.FindSet() then
            //             repeat
            //                 LotQty += RegPickLine.Quantity;
            //             Until RegPickLine.Next() = 0;
            //     end;

            //     if LotQty <> 0 then
            //         Rec.Quantity := LotQty;
            // end;

            trigger OnLookup()
            var
                RegPickLine: Record "Registered Whse. Activity Line";
            begin
                Rec.TestField("Source Document No.");
                Rec.TestField("Source Document Line No.");

                if Rec."Source Document Type" = Rec."Source Document Type"::"Warehouse Shipment" then begin
                    RegPickLine.Reset();
                    RegPickLine.SetRange("Whse. Document Type", RegPickLine."Whse. Document Type"::Shipment);
                    RegPickLine.SetRange("Whse. Document No.", "Source Document No.");
                    RegPickLine.SetRange("Whse. Document Line No.", "Source Document Line No.");
                    RegPickLine.SetRange("Action Type", RegPickLine."Action Type"::take);
                    if RegPickLine.FindSet() then
                        if Page.RunModal(Page::"Registered Whse. Act.-Lines", RegPickLine) = Action::LookupOK then begin
                            Rec."Lot No." := RegPickLine."Lot No.";
                            Rec.Quantity := RegPickLine.Quantity;
                        end;
                end;
            end;
        }

    }

    keys
    {
        key(Key1; "Packing No.", "Packing Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF "Source Document Type" = "Source Document Type"::"Warehouse Shipment" THEN
            if recWhseShptLine.GET("Source Document No.", "Source Document Line No.") then begin
                recWhseShptLine."Quantity To Pack" := recWhseShptLine."Quantity To Pack" + Quantity;
                recWhseShptLine."Quantity Packed" := recWhseShptLine."Quantity Packed" - Quantity;
                recWhseShptLine.MODIFY(FALSE);
            END;
    end;

    trigger OnInsert()
    begin
        recPackLineList.RESET;
        recPackLineList.SETRANGE("Packing No.", "Packing No.");
        recPackLineList.SETFILTER("Line No.", '<>%1', 0);
        recPackLineList.SETRANGE("Packing Line No.", "Packing Line No.");
        IF recPackLineList.FIND('+') THEN
            "Line No." := recPackLineList."Line No." + 10000
        ELSE
            "Line No." := 10000;
    end;

    var
        recPackLineList: Record "Packing Item List";
        recWhseShptLine: Record "Warehouse Shipment Line";
        GenJnl: Record "Gen. Journal Line";


    procedure TestStatusOpen()
    var
        recPackHeader: Record "Packing Header";
    begin
        IF recPackHeader.GET("Packing No.") THEN
            IF recPackHeader.Status <> recPackHeader.Status::Open THEN
                ERROR('Status Must be Open for Packing No. %1', recPackHeader."Packing No.");
    end;
}

