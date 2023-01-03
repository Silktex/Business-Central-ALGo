tableextension 50254 "Warehouse Activity Line_Ext" extends "Warehouse Activity Line"
{
    fields
    {
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                QuantityNew := Quantity;
            end;
        }
        modify("Lot No.")
        {
            trigger OnBeforeValidate()
            begin
                CheckAvailableQuantity;
            end;

            trigger OnAfterValidate()
            begin
                IF ("Lot No." = '') AND (xRec."Lot No." <> '') THEN
                    CheckRemovableQuantity(xRec."Lot No.");
            end;
        }
        modify("Bin Code")
        {
            trigger OnAfterValidate()
            begin
                CheckAvailableQuantity;
            end;
        }
        field(50000; Scanned; Boolean)
        {
        }
        field(50001; "Original Quantity"; Decimal)
        {
        }
        field(50002; "Ref. Line No."; Integer)
        {
        }
        field(50011; "HandHeld Line Created"; Boolean)
        {
        }
        field(50012; "Hand Held Line Updated"; Boolean)
        {
        }
        field(50013; "Hand Held User Id"; Code[50])
        {
        }
        field(50020; QuantityNew; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            //Editable = false;

            trigger OnValidate()
            begin
                Validate(Quantity, QuantityNew);
            end;
        }
    }
    var
        recILE: Record "Item Ledger Entry";
        recBinContent: Record "Bin Content";
        decAvailableQuantity: Decimal;
        recWE: Record "Warehouse Entry";
        decAvailableQuantity1: Decimal;
        decQtytoUpdate: Decimal;
        WhseActLine1: Record "Warehouse Activity Line";
        decActLineQty: Decimal;
        recWSL: Record "Warehouse Shipment Line";
        decDiffQuantity: Decimal;
        decQty: Decimal;
        decQtyOut: Decimal;
        int: Integer;
        decBinQty: Decimal;
        i: Integer;

    procedure CheckAvailableQuantity()
    begin
        IF ("Activity Type" = "Activity Type"::Pick) AND ("Action Type" = "Action Type"::Take) THEN BEGIN
            IF ("Bin Code" <> '') AND ("Lot No." <> '') THEN BEGIN
                decAvailableQuantity := 0;
                recILE.RESET;
                recILE.SETRANGE("Item No.", "Item No.");
                recILE.SETFILTER("Remaining Quantity", '<>0');
                recILE.CALCFIELDS(recILE."Reserved Quantity");
                recILE.SETRANGE("Lot No.", "Lot No.");
                IF recILE.FIND('-') THEN
                    REPEAT
                        IF recILE."Remaining Quantity" - recILE."Reserved Quantity" > 0 THEN
                            decAvailableQuantity := recILE."Remaining Quantity" - recILE."Reserved Quantity";
                        decAvailableQuantity1 := 0;
                        recWE.RESET;
                        recWE.SETCURRENTKEY("Location Code", "Item No.", "Variant Code", "Zone Code", "Bin Code", "Lot No.");
                        recWE.SETRANGE("Location Code", "Location Code");
                        recWE.SETRANGE("Item No.", "Item No.");
                        recWE.SETRANGE("Variant Code", "Variant Code");
                        recWE.SETRANGE("Zone Code", "Zone Code");
                        recWE.SETRANGE("Bin Code", "Bin Code");
                        recWE.SETRANGE("Lot No.", "Lot No.");
                        IF recWE.FIND('-') THEN
                            REPEAT
                                decAvailableQuantity1 := decAvailableQuantity1 + recWE.Quantity;
                            UNTIL recWE.NEXT = 0;
                        decBinQty := 0;
                        recBinContent.RESET;
                        recBinContent.SETRANGE("Location Code", "Location Code");
                        recBinContent.SETRANGE("Item No.", "Item No.");
                        recBinContent.SETRANGE("Variant Code", "Variant Code");
                        recBinContent.SETRANGE("Bin Code", "Bin Code");
                        recBinContent.CALCFIELDS("Pick Qty.", Quantity);
                        IF recBinContent.FIND('-') THEN BEGIN
                            decBinQty := recBinContent.Quantity - recBinContent."Pick Qty.";
                        END;
                        IF decBinQty > decAvailableQuantity1 THEN
                            decAvailableQuantity1 := decBinQty;
                        IF decAvailableQuantity1 = 0 THEN
                            decAvailableQuantity := 0;
                    UNTIL (recILE.NEXT = 0) OR (decAvailableQuantity <> 0);
                IF decAvailableQuantity > decAvailableQuantity1 THEN
                    decQtytoUpdate := decAvailableQuantity1
                ELSE
                    decQtytoUpdate := decAvailableQuantity;
                IF "Original Quantity" = 0 THEN
                    "Original Quantity" := Quantity;
                IF Quantity < decQtytoUpdate THEN BEGIN
                    VALIDATE(Quantity, decQtytoUpdate + "Qty. Handled");
                    VALIDATE("Qty. (Base)", Quantity);
                END;
                VALIDATE("Qty. to Handle", decQtytoUpdate);
                "Qty. to Handle (Base)" := decQtytoUpdate;
                MODIFY;
                IF "Qty. to Handle" < "Qty. Outstanding" THEN
                    SplitLine(Rec);
                i := 0;
                WhseActLine1.RESET;
                WhseActLine1.SETRANGE("Activity Type", "Activity Type");
                WhseActLine1.SETRANGE("Action Type", "Action Type"::Place);
                WhseActLine1.SETRANGE("No.", "No.");

                WhseActLine1.SETRANGE(WhseActLine1."Source No.", "Source No.");
                WhseActLine1.SETRANGE(WhseActLine1."Source Line No.", "Source Line No.");
                IF WhseActLine1.FIND('-') THEN BEGIN
                    REPEAT
                        IF WhseActLine1."Lot No." = '' THEN BEGIN
                            i += 1;
                            IF WhseActLine1."Original Quantity" = 0 THEN
                                WhseActLine1."Original Quantity" := WhseActLine1.Quantity;
                            IF WhseActLine1.Quantity < decQtytoUpdate THEN BEGIN
                                WhseActLine1.VALIDATE(Quantity, decQtytoUpdate + WhseActLine1."Qty. Handled");
                                WhseActLine1.VALIDATE("Qty. (Base)", WhseActLine1.Quantity);
                            END;
                            WhseActLine1.VALIDATE("Qty. to Handle", decQtytoUpdate);
                            WhseActLine1."Qty. to Handle (Base)" := decQtytoUpdate;
                            WhseActLine1.VALIDATE("Lot No.", "Lot No.");
                            WhseActLine1.MODIFY;
                            IF WhseActLine1."Qty. to Handle" < WhseActLine1."Qty. Outstanding" THEN
                                SplitLine(WhseActLine1);
                        END;

                    UNTIL (WhseActLine1.NEXT = 0) OR (i > 0);

                END;
                decActLineQty := 0;
                decDiffQuantity := 0;
                recWSL.RESET;
                //recWSL.SETRANGE("Whse. Document Type",recWSL."Whse. Document Type"::Shipment);
                recWSL.SETRANGE("No.", "Whse. Document No.");
                recWSL.SETRANGE("Line No.", "Whse. Document Line No.");
                IF recWSL.FIND('-') THEN BEGIN
                    WhseActLine1.RESET;
                    WhseActLine1.SETRANGE("Activity Type", "Activity Type");
                    WhseActLine1.SETRANGE("Action Type", "Action Type"::Take);
                    WhseActLine1.SETRANGE("No.", "No.");
                    WhseActLine1.SETRANGE("Whse. Document Type", "Whse. Document Type"::Shipment);
                    WhseActLine1.SETRANGE("Whse. Document No.", "Whse. Document No.");
                    WhseActLine1.SETRANGE("Whse. Document Line No.", "Whse. Document Line No.");
                    //WhseActLine1.SETFILTER("Lot No.",'');
                    WhseActLine1.SETRANGE(WhseActLine1."Source No.", "Source No.");
                    WhseActLine1.SETRANGE(WhseActLine1."Source Line No.", "Source Line No.");
                    IF WhseActLine1.FIND('-') THEN BEGIN
                        REPEAT
                            decActLineQty := decActLineQty + WhseActLine1.Quantity;
                        UNTIL WhseActLine1.NEXT = 0;
                    END;
                    IF recWSL."Original Quantity" = 0 THEN
                        recWSL."Original Quantity" := recWSL.Quantity;
                    IF decActLineQty > (recWSL."Qty. Outstanding" - recWSL."Qty. Picked" + recWSL."Qty. Shipped") THEN BEGIN
                        decDiffQuantity := decActLineQty - (recWSL."Qty. Outstanding" - recWSL."Qty. Picked" + recWSL."Qty. Shipped");
                        recWSL.Quantity := recWSL.Quantity + decDiffQuantity;
                        recWSL."Qty. (Base)" := recWSL."Qty. (Base)" + decDiffQuantity;
                        recWSL."Qty. Outstanding" := recWSL."Qty. Outstanding" + decDiffQuantity;
                        recWSL."Qty. Outstanding (Base)" := recWSL."Qty. Outstanding (Base)" + decDiffQuantity;
                        recWSL.MODIFY;
                    END;
                    recWSL.MODIFY;

                END;
            END;
        END;
    end;

    procedure CheckRemovableQuantity(LotNo: Code[20])
    begin
        IF ("Activity Type" = "Activity Type"::Pick) AND ("Action Type" = "Action Type"::Take) THEN BEGIN
            IF ("Lot No." = '') THEN BEGIN
                decQty := 0;
                decQtyOut := 0;
                WhseActLine1.RESET;
                WhseActLine1.SETRANGE("Activity Type", "Activity Type");
                WhseActLine1.SETRANGE("Action Type", "Action Type"::Take);
                WhseActLine1.SETRANGE("No.", "No.");
                WhseActLine1.SETRANGE("Lot No.", "Lot No.");
                WhseActLine1.SETFILTER("Line No.", '<>%1', "Line No.");
                WhseActLine1.SETRANGE(WhseActLine1."Source No.", "Source No.");
                WhseActLine1.SETRANGE(WhseActLine1."Source Line No.", "Source Line No.");
                IF WhseActLine1.FIND('-') THEN BEGIN
                    REPEAT
                        //WhseActLine1.VALIDATE("Lot No.","Lot No.");
                        decQty := decQty + WhseActLine1.Quantity;
                        decQtyOut := decQtyOut + WhseActLine1."Qty. Outstanding";
                    //decQtyHandled:=decQtyHandled+WhseActLine1."Qty. Handled";
                    UNTIL WhseActLine1.NEXT = 0;
                END;
                decQty := decQty + Quantity;
                decQtyOut := decQtyOut + "Qty. Outstanding";
                int := 0;
                WhseActLine1.RESET;
                WhseActLine1.SETRANGE("Activity Type", "Activity Type");
                WhseActLine1.SETRANGE("Action Type", "Action Type"::Take);
                WhseActLine1.SETRANGE("No.", "No.");
                WhseActLine1.SETRANGE("Lot No.", "Lot No.");
                WhseActLine1.SETFILTER("Line No.", '<>%1', "Line No.");
                WhseActLine1.SETRANGE(WhseActLine1."Source No.", "Source No.");
                WhseActLine1.SETRANGE(WhseActLine1."Source Line No.", "Source Line No.");
                IF WhseActLine1.FIND('-') THEN BEGIN
                    REPEAT
                        WhseActLine1.DELETE;
                    UNTIL WhseActLine1.NEXT = 0;
                END;
                Quantity := decQty;
                "Qty. (Base)" := decQty;
                "Qty. Outstanding" := decQtyOut;
                "Qty. Outstanding (Base)" := decQtyOut;
                "Qty. to Handle" := 0;
                "Qty. to Handle (Base)" := 0;

                //MODIFY;


                WhseActLine1.RESET;
                WhseActLine1.SETRANGE("Activity Type", "Activity Type");
                WhseActLine1.SETRANGE("Action Type", "Action Type"::Place);
                WhseActLine1.SETRANGE("No.", "No.");
                WhseActLine1.SETRANGE("Lot No.", LotNo);
                WhseActLine1.SETRANGE(WhseActLine1."Source No.", "Source No.");
                WhseActLine1.SETRANGE(WhseActLine1."Source Line No.", "Source Line No.");
                IF WhseActLine1.FIND('-') THEN BEGIN
                    WhseActLine1.VALIDATE("Lot No.", "Lot No.");
                    WhseActLine1.MODIFY;
                END;
                int := 0;
                WhseActLine1.RESET;
                WhseActLine1.SETRANGE("Activity Type", "Activity Type");
                WhseActLine1.SETRANGE("Action Type", "Action Type"::Place);
                WhseActLine1.SETRANGE("No.", "No.");
                WhseActLine1.SETRANGE("Lot No.", "Lot No.");
                WhseActLine1.SETRANGE(WhseActLine1."Source No.", "Source No.");
                WhseActLine1.SETRANGE(WhseActLine1."Source Line No.", "Source Line No.");
                IF WhseActLine1.FIND('-') THEN BEGIN
                    REPEAT
                        int += 1;
                        IF int = 1 THEN BEGIN
                            WhseActLine1.Quantity := decQty;
                            WhseActLine1."Qty. (Base)" := decQty;
                            WhseActLine1."Qty. Outstanding" := decQtyOut;
                            WhseActLine1."Qty. Outstanding (Base)" := decQtyOut;
                            WhseActLine1."Qty. to Handle" := 0;
                            WhseActLine1."Qty. to Handle (Base)" := 0;
                            WhseActLine1.MODIFY;
                        END ELSE
                            WhseActLine1.DELETE;


                    UNTIL WhseActLine1.NEXT = 0;
                END;


                decActLineQty := 0;
                decDiffQuantity := 0;
                recWSL.RESET;
                //recWSL.SETRANGE("Whse. Document Type",recWSL."Whse. Document Type"::Shipment);
                recWSL.SETRANGE("No.", "Whse. Document No.");
                recWSL.SETRANGE("Line No.", "Whse. Document Line No.");
                IF recWSL.FIND('-') THEN BEGIN
                    //IF decActLineQty>(recWSL."Qty. Outstanding"-recWSL."Qty. Picked"+recWSL."Qty. Shipped") THEN BEGIN
                    decDiffQuantity := recWSL.Quantity - recWSL."Original Quantity";
                    IF decDiffQuantity > 0 THEN BEGIN
                        WhseActLine1.RESET;
                        WhseActLine1.SETRANGE("Activity Type", "Activity Type");
                        WhseActLine1.SETRANGE("Action Type", "Action Type"::Place);
                        WhseActLine1.SETRANGE("No.", "No.");
                        WhseActLine1.SETRANGE("Whse. Document Type", "Whse. Document Type"::Shipment);
                        WhseActLine1.SETRANGE("Whse. Document No.", "Whse. Document No.");
                        WhseActLine1.SETRANGE("Whse. Document Line No.", "Whse. Document Line No.");
                        WhseActLine1.SETRANGE("Lot No.", "Lot No.");
                        WhseActLine1.SETRANGE(WhseActLine1."Source No.", "Source No.");
                        WhseActLine1.SETRANGE(WhseActLine1."Source Line No.", "Source Line No.");
                        IF WhseActLine1.FIND('-') THEN BEGIN
                            REPEAT
                                decActLineQty := decActLineQty + WhseActLine1.Quantity;
                            UNTIL WhseActLine1.NEXT = 0;
                        END;
                        IF decActLineQty < decDiffQuantity THEN
                            decDiffQuantity := decActLineQty;



                        recWSL.Quantity := recWSL.Quantity - decDiffQuantity;
                        recWSL."Qty. (Base)" := recWSL."Qty. (Base)" - decDiffQuantity;
                        recWSL."Qty. Outstanding" := recWSL."Qty. Outstanding" - decDiffQuantity;
                        recWSL."Qty. Outstanding (Base)" := recWSL."Qty. Outstanding (Base)" - decDiffQuantity;
                        recWSL.MODIFY;
                        Quantity := Quantity - decDiffQuantity;
                        "Qty. (Base)" := "Qty. (Base)" - decDiffQuantity;
                        "Qty. Outstanding" := "Qty. Outstanding" - decDiffQuantity;
                        "Qty. Outstanding (Base)" := "Qty. Outstanding (Base)" - decDiffQuantity;
                        IF "Qty. Outstanding" > 0 THEN
                            MODIFY
                        ELSE
                            DELETE;
                        WhseActLine1.RESET;
                        WhseActLine1.SETRANGE("Activity Type", "Activity Type");
                        //WhseActLine1.SETRANGE("Action Type","Action Type"::Take);
                        WhseActLine1.SETRANGE("No.", "No.");
                        WhseActLine1.SETRANGE("Whse. Document Type", "Whse. Document Type"::Shipment);
                        WhseActLine1.SETRANGE("Whse. Document No.", "Whse. Document No.");
                        WhseActLine1.SETRANGE("Whse. Document Line No.", "Whse. Document Line No.");
                        WhseActLine1.SETRANGE("Lot No.", "Lot No.");
                        WhseActLine1.SETFILTER("Line No.", '<>%1', "Line No.");
                        WhseActLine1.SETRANGE(WhseActLine1."Source No.", "Source No.");
                        WhseActLine1.SETRANGE(WhseActLine1."Source Line No.", "Source Line No.");
                        IF WhseActLine1.FIND('-') THEN BEGIN
                            REPEAT
                                WhseActLine1.Quantity := WhseActLine1.Quantity - decDiffQuantity;
                                WhseActLine1."Qty. to Handle" := 0;
                                WhseActLine1."Qty. to Handle (Base)" := 0;
                                WhseActLine1."Qty. (Base)" := WhseActLine1."Qty. (Base)" - decDiffQuantity;
                                WhseActLine1."Qty. Outstanding" := WhseActLine1."Qty. Outstanding" - decDiffQuantity;
                                WhseActLine1."Qty. Outstanding (Base)" := WhseActLine1."Qty. Outstanding (Base)" - decDiffQuantity;
                                IF WhseActLine1."Qty. Outstanding" > 0 THEN
                                    WhseActLine1.MODIFY
                                ELSE
                                    WhseActLine1.DELETE;

                            UNTIL WhseActLine1.NEXT = 0;
                        END;

                    END;

                END;
            END;
        END;
    end;

}
