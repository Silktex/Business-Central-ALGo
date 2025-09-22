report 60002 "Calculate Whse. Ajst Handheld"
{
    Caption = 'Calculate Whse. Adjustment';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Location Filter", "Variant Filter";
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

                trigger OnAfterGetRecord()
                var
                    ReservationEntry: Record "Reservation Entry";
                    SNLotNumbersByBin: Query "Lot Numbers by Bin";
                begin
                    WITH AdjmtBinQuantityBuffer DO BEGIN
                        Location.RESET;
                        Item.COPYFILTER("Location Filter", Location.Code);
                        Location.SETRANGE("Directed Put-away and Pick", TRUE);
                        IF Location.FINDSET THEN
                            REPEAT
                                SNLotNumbersByBin.SETRANGE(Location_Code, Location.Code);
                                SNLotNumbersByBin.SETRANGE(Bin_Code, Location."Adjustment Bin Code");
                                SNLotNumbersByBin.SETRANGE(Item_No, Item."No.");
                                SNLotNumbersByBin.SETFILTER(Variant_Code, Item.GETFILTER("Variant Filter"));
                                SNLotNumbersByBin.SETFILTER(Lot_No, Item.GETFILTER("Lot No. Filter"));
                                SNLotNumbersByBin.SETFILTER(Serial_No, Item.GETFILTER("Serial No. Filter"));
                                SNLotNumbersByBin.OPEN;

                                WHILE SNLotNumbersByBin.READ DO BEGIN
                                    INIT;
                                    "Item No." := SNLotNumbersByBin.Item_No;
                                    "Variant Code" := SNLotNumbersByBin.Variant_Code;
                                    "Location Code" := SNLotNumbersByBin.Location_Code;
                                    "Bin Code" := SNLotNumbersByBin.Bin_Code;
                                    "Unit of Measure Code" := SNLotNumbersByBin.Unit_of_Measure_Code;
                                    "Base Unit of Measure" := Item."Base Unit of Measure";
                                    "Lot No." := SNLotNumbersByBin.Lot_No;
                                    "Serial No." := SNLotNumbersByBin.Serial_No;
                                    "Qty. to Handle (Base)" := SNLotNumbersByBin.Sum_Qty_Base;
                                    INSERT;
                                END;
                            UNTIL Location.NEXT = 0;

                        RESET;
                        ReservationEntry.RESET;
                        ReservationEntry.SETCURRENTKEY("Source ID");
                        ItemJnlLine.RESET;
                        ItemJnlLine.SETCURRENTKEY("Item No.");
                        IF FINDSET THEN BEGIN
                            REPEAT
                                ItemJnlLine.RESET;
                                ItemJnlLine.SETCURRENTKEY("Item No.");
                                ItemJnlLine.SETRANGE("Journal Template Name", ItemJnlLine."Journal Template Name");
                                ItemJnlLine.SETRANGE("Journal Batch Name", ItemJnlLine."Journal Batch Name");
                                ItemJnlLine.SETRANGE("Item No.", "Item No.");
                                ItemJnlLine.SETRANGE("Location Code", "Location Code");
                                ItemJnlLine.SETRANGE("Unit of Measure Code", "Unit of Measure Code");
                                ItemJnlLine.SETRANGE("Warehouse Adjustment", TRUE);
                                IF ItemJnlLine.FINDSET THEN
                                    REPEAT
                                        ReservationEntry.SETRANGE("Source Type", DATABASE::"Item Journal Line");
                                        ReservationEntry.SETRANGE("Source ID", ItemJnlLine."Journal Template Name");
                                        ReservationEntry.SETRANGE("Source Batch Name", ItemJnlLine."Journal Batch Name");
                                        ReservationEntry.SETRANGE("Source Ref. No.", ItemJnlLine."Line No.");
                                        IF "Lot No." <> '' THEN
                                            ReservationEntry.SETRANGE("Lot No.", "Lot No.");
                                        IF "Serial No." <> '' THEN
                                            ReservationEntry.SETRANGE("Serial No.", "Serial No.");
                                        ReservationEntry.CALCSUMS("Qty. to Handle (Base)");
                                        IF ReservationEntry."Qty. to Handle (Base)" <> 0 THEN BEGIN
                                            "Qty. to Handle (Base)" += ReservationEntry."Qty. to Handle (Base)";
                                            MODIFY;
                                        END;
                                    UNTIL ItemJnlLine.NEXT = 0;
                            UNTIL NEXT = 0;
                        END;
                    END;
                end;

                trigger OnPostDataItem()
                var
                    QtyInUOM: Decimal;
                begin
                    WITH AdjmtBinQuantityBuffer DO BEGIN
                        RESET;
                        IF FINDSET THEN
                            REPEAT
                                SETRANGE("Location Code", "Location Code");
                                SETRANGE("Variant Code", "Variant Code");
                                SETRANGE("Unit of Measure Code", "Unit of Measure Code");

                                SETFILTER("Qty. to Handle (Base)", '>0');
                                CALCSUMS("Qty. to Handle (Base)");
                                QtyInUOM := UOMMgt.CalcQtyFromBase(-"Qty. to Handle (Base)", UOMMgt.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code"));
                                IF QtyInUOM <> 0 THEN
                                    InsertItemJnlLine(AdjmtBinQuantityBuffer, QtyInUOM, -"Qty. to Handle (Base)", "Unit of Measure Code", 1);

                                SETFILTER("Qty. to Handle (Base)", '<0');
                                CALCSUMS("Qty. to Handle (Base)");
                                QtyInUOM := UOMMgt.CalcQtyFromBase(-"Qty. to Handle (Base)", UOMMgt.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code"));
                                IF QtyInUOM <> 0 THEN
                                    InsertItemJnlLine(AdjmtBinQuantityBuffer, QtyInUOM, -"Qty. to Handle (Base)", "Unit of Measure Code", 0);

                                // rounding residue
                                SETRANGE("Qty. to Handle (Base)");
                                CALCSUMS("Qty. to Handle (Base)");
                                QtyInUOM := UOMMgt.CalcQtyFromBase(-"Qty. to Handle (Base)", UOMMgt.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code"));
                                IF (QtyInUOM = 0) AND ("Qty. to Handle (Base)" > 0) THEN
                                    InsertItemJnlLine(AdjmtBinQuantityBuffer, -"Qty. to Handle (Base)", -"Qty. to Handle (Base)", "Base Unit of Measure", 1);

                                FINDLAST;
                                SETRANGE("Location Code");
                                SETRANGE("Variant Code");
                                SETRANGE("Unit of Measure Code");
                            UNTIL NEXT = 0;
                        RESET;
                        DELETEALL;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    CLEAR(Location);
                    WhseEntry.RESET;
                    WhseEntry.SETCURRENTKEY("Item No.", "Bin Code", "Location Code", "Variant Code");
                    WhseEntry.SETRANGE("Item No.", Item."No.");
                    Item.COPYFILTER("Variant Filter", WhseEntry."Variant Code");
                    Item.COPYFILTER("Lot No. Filter", WhseEntry."Lot No.");
                    Item.COPYFILTER("Serial No. Filter", WhseEntry."Serial No.");

                    IF WhseEntry.ISEMPTY THEN
                        CurrReport.BREAK;

                    FillProspectReservationEntryBuffer(Item, ItemJnlLine."Journal Template Name", ItemJnlLine."Journal Batch Name");

                    AdjmtBinQuantityBuffer.RESET;
                    AdjmtBinQuantityBuffer.DELETEALL;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF NOT HideValidationDialog THEN
                    Window.UPDATE;
            end;

            trigger OnPostDataItem()
            begin
                IF NOT HideValidationDialog THEN
                    Window.CLOSE;
            end;

            trigger OnPreDataItem()
            var
                ItemJnlTemplate: Record "Item Journal Template";
                ItemJnlBatch: Record "Item Journal Batch";
            begin
                PostingDate := TODAY;
                SETRANGE("No.", ItemNo);

                ItemJnlTemplate.GET(ItemJnlLine."Journal Template Name");
                ItemJnlBatch.GET(ItemJnlLine."Journal Template Name", ItemJnlLine."Journal Batch Name");
                NextDocNo := NoSeriesMgt.GetNextNo(ItemJnlBatch."No. Series", PostingDate, FALSE);
                ItemJnlLine.INIT;

                NextLineNo := 0;

                IF NOT HideValidationDialog THEN
                    Window.OPEN(Text002, "No.");
            end;
        }
    }

    requestpage
    {
        Caption = 'Calculate Inventory';
        SaveValues = true;

        layout
        {
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            IF PostingDate = 0D THEN
                PostingDate := WORKDATE;
            ValidatePostingDate;
        end;
    }

    labels
    {
    }

    var
        Text000: Label 'Enter the posting date.';
        Text001: Label 'Enter the document no.';
        Text002: Label 'Processing items    #1##########';
        ItemJnlBatch: Record "Item Journal Batch";
        ItemJnlLine: Record "Item Journal Line";
        WhseEntry: Record "Warehouse Entry";
        Location: Record Location;
        SourceCodeSetup: Record "Source Code Setup";
        AdjmtBinQuantityBuffer: Record "Bin Content Buffer" temporary;
        TempReservationEntryBuffer: Record "Reservation Entry" temporary;
        NoSeriesMgt: Codeunit "No. Series";
        UOMMgt: Codeunit "Unit of Measure Management";
        Window: Dialog;
        PostingDate: Date;
        NextDocNo: Code[20];
        NextLineNo: Integer;
        HideValidationDialog: Boolean;
        ItemNo: Code[20];

    procedure SetItemJnlLine(var NewItemJnlLine: Record "Item Journal Line")
    begin
        ItemJnlLine := NewItemJnlLine;
    end;

    local procedure ValidatePostingDate()
    begin
        ItemJnlBatch.GET(ItemJnlLine."Journal Template Name", ItemJnlLine."Journal Batch Name");
        IF ItemJnlBatch."No. Series" = '' THEN
            NextDocNo := ''
        ELSE BEGIN
            NextDocNo := NoSeriesMgt.GetNextNo(ItemJnlBatch."No. Series", PostingDate, FALSE);
            CLEAR(NoSeriesMgt);
        END;
    end;

    local procedure InsertItemJnlLine(var TempBinContentBuffer: Record "Bin Content Buffer" temporary; Quantity2: Decimal; QuantityBase2: Decimal; UOM2: Code[10]; EntryType2: Option "Negative Adjmt.","Positive Adjmt.")
    begin
        WITH ItemJnlLine DO BEGIN
            IF NextLineNo = 0 THEN BEGIN
                LOCKTABLE;
                RESET;
                SETRANGE("Journal Template Name", "Journal Template Name");
                SETRANGE("Journal Batch Name", "Journal Batch Name");
                IF FIND('+') THEN
                    NextLineNo := "Line No.";

                SourceCodeSetup.GET;
            END;
            NextLineNo := NextLineNo + 10000;

            IF QuantityBase2 <> 0 THEN BEGIN
                INIT;
                "Line No." := NextLineNo;
                VALIDATE("Posting Date", PostingDate);
                IF QuantityBase2 > 0 THEN
                    VALIDATE("Entry Type", "Entry Type"::"Positive Adjmt.")
                ELSE BEGIN
                    VALIDATE("Entry Type", "Entry Type"::"Negative Adjmt.");
                    Quantity2 := -Quantity2;
                    QuantityBase2 := -QuantityBase2;
                END;
                VALIDATE("Document No.", NextDocNo);
                VALIDATE("Item No.", TempBinContentBuffer."Item No.");
                VALIDATE("Variant Code", TempBinContentBuffer."Variant Code");
                VALIDATE("Location Code", TempBinContentBuffer."Location Code");
                VALIDATE("Source Code", SourceCodeSetup."Item Journal");
                VALIDATE("Unit of Measure Code", UOM2);
                "Posting No. Series" := ItemJnlBatch."Posting No. Series";

                VALIDATE(Quantity, Quantity2);
                "Quantity (Base)" := QuantityBase2;
                "Invoiced Qty. (Base)" := QuantityBase2;
                "Warehouse Adjustment" := TRUE;
                INSERT(TRUE);
                OnAfterInsertItemJnlLine(ItemJnlLine);

                CreateReservationEntry(ItemJnlLine, TempBinContentBuffer, EntryType2, UOM2);
            END;
        END;
    end;

    procedure InitializeRequest(NewPostingDate: Date; DocNo: Code[20])
    begin
        PostingDate := NewPostingDate;
        NextDocNo := DocNo;
    end;

    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    local procedure FillProspectReservationEntryBuffer(var Item: Record Item; JournalTemplateName: Code[10]; JournalBatchName: Code[10])
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        TempReservationEntryBuffer.RESET;
        TempReservationEntryBuffer.DELETEALL;
        ReservationEntry.RESET;
        ReservationEntry.SETRANGE("Source Type", DATABASE::"Item Journal Line");
        ReservationEntry.SETRANGE("Source ID", JournalTemplateName);
        ReservationEntry.SETRANGE("Source Batch Name", JournalBatchName);
        ReservationEntry.SETRANGE("Reservation Status", ReservationEntry."Reservation Status"::Prospect);
        ReservationEntry.SETRANGE("Item No.", Item."No.");
        ReservationEntry.SETFILTER("Variant Code", Item."Variant Filter");

        IF ReservationEntry.FINDSET THEN
            REPEAT
                TempReservationEntryBuffer := ReservationEntry;
                TempReservationEntryBuffer.INSERT;
            UNTIL ReservationEntry.NEXT = 0;
    end;

    local procedure CreateReservationEntry(var ItemJournalLine: Record "Item Journal Line"; var TempBinContentBuffer: Record "Bin Content Buffer" temporary; EntryType: Option "Negative Adjmt.","Positive Adjmt."; UOMCode: Code[10])
    var
        WarehouseEntry: Record "Warehouse Entry";
        WarehouseEntry2: Record "Warehouse Entry";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        OrderLineNo: Integer;
        ForReservationEntry: Record "Reservation Entry";
    begin
        TempBinContentBuffer.FINDSET;
        REPEAT
            WarehouseEntry.SETCURRENTKEY(
              "Item No.", "Bin Code", "Location Code", "Variant Code", "Unit of Measure Code", "Lot No.", "Serial No.", "Entry Type");
            WarehouseEntry.SETRANGE("Item No.", TempBinContentBuffer."Item No.");
            WarehouseEntry.SETRANGE("Bin Code", TempBinContentBuffer."Bin Code");
            WarehouseEntry.SETRANGE("Location Code", TempBinContentBuffer."Location Code");
            WarehouseEntry.SETRANGE("Variant Code", TempBinContentBuffer."Variant Code");
            WarehouseEntry.SETRANGE("Unit of Measure Code", UOMCode);
            WarehouseEntry.SETRANGE("Lot No.", TempBinContentBuffer."Lot No.");
            WarehouseEntry.SETRANGE("Serial No.", TempBinContentBuffer."Serial No.");
            WarehouseEntry.SETFILTER("Entry Type", '%1|%2', EntryType, WarehouseEntry."Entry Type"::Movement);
            IF NOT WarehouseEntry.FINDFIRST THEN
                EXIT;

            TempReservationEntryBuffer.RESET;
            WarehouseEntry.CALCSUMS("Qty. (Base)", Quantity);
            UpdateWarehouseEntryQtyByReservationEntryBuffer(
              WarehouseEntry, WarehouseEntry."Lot No.", WarehouseEntry."Serial No.");

            WarehouseEntry2.COPYFILTERS(WarehouseEntry);
            CASE EntryType OF
                EntryType::"Positive Adjmt.":
                    WarehouseEntry2.SETRANGE("Entry Type", WarehouseEntry2."Entry Type"::"Negative Adjmt.");
                EntryType::"Negative Adjmt.":
                    WarehouseEntry2.SETRANGE("Entry Type", WarehouseEntry2."Entry Type"::"Positive Adjmt.");
            END;
            WarehouseEntry2.CALCSUMS("Qty. (Base)", Quantity);
            UpdateWarehouseEntryQtyByReservationEntryBuffer(
              WarehouseEntry2, WarehouseEntry."Lot No.", WarehouseEntry."Serial No.");

            IF ABS(WarehouseEntry2."Qty. (Base)") > ABS(WarehouseEntry."Qty. (Base)") THEN BEGIN
                WarehouseEntry."Qty. (Base)" := 0;
                WarehouseEntry.Quantity := 0;
            END ELSE BEGIN
                WarehouseEntry."Qty. (Base)" += WarehouseEntry2."Qty. (Base)";
                WarehouseEntry.Quantity += WarehouseEntry2.Quantity;
            END;

            IF WarehouseEntry."Qty. (Base)" <> 0 THEN BEGIN
                IF ItemJournalLine."Order Type" = ItemJournalLine."Order Type"::Production THEN
                    OrderLineNo := ItemJournalLine."Order Line No.";

                ForReservationEntry."Lot No." := WarehouseEntry."Lot No.";
                ForReservationEntry."Serial No." := WarehouseEntry."Serial No.";

                CreateReservEntry.CreateReservEntryFor(
                  DATABASE::"Item Journal Line", ItemJournalLine."Entry Type".AsInteger(), ItemJournalLine."Journal Template Name",
                  ItemJournalLine."Journal Batch Name", OrderLineNo, ItemJournalLine."Line No.", ItemJournalLine."Qty. per Unit of Measure",
                  ABS(WarehouseEntry.Quantity), ABS(WarehouseEntry."Qty. (Base)"), ForReservationEntry);
                //WarehouseEntry."Serial No.", WarehouseEntry."Lot No.");

                IF WarehouseEntry."Qty. (Base)" < 0 THEN
                    CreateReservEntry.SetDates(WarehouseEntry."Warranty Date", WarehouseEntry."Expiration Date");

                CreateReservEntry.CreateEntry(
                  ItemJournalLine."Item No.", ItemJournalLine."Variant Code", ItemJournalLine."Location Code", ItemJournalLine.Description,
                  0D, 0D, 0, TempReservationEntryBuffer."Reservation Status"::Prospect);
            END;
        UNTIL TempBinContentBuffer.NEXT = 0;
    end;

    local procedure UpdateWarehouseEntryQtyByReservationEntryBuffer(var WarehouseEntry: Record "Warehouse Entry"; LotNo: Code[50]; SerialNo: Code[50])
    begin
        IF WarehouseEntry."Qty. (Base)" = 0 THEN
            EXIT;

        IF LotNo <> '' THEN
            TempReservationEntryBuffer.SETRANGE("Lot No.", LotNo);
        IF SerialNo <> '' THEN
            TempReservationEntryBuffer.SETRANGE("Serial No.", SerialNo);

        TempReservationEntryBuffer.SETRANGE(Positive, WarehouseEntry."Qty. (Base)" < 0);
        TempReservationEntryBuffer.CALCSUMS("Quantity (Base)", Quantity);

        WarehouseEntry."Qty. (Base)" += TempReservationEntryBuffer."Quantity (Base)";
        WarehouseEntry.Quantity += TempReservationEntryBuffer.Quantity;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertItemJnlLine(var ItemJournalLine: Record "Item Journal Line")
    begin
    end;

    procedure SetItemNo(NewItemNo: Code[20])
    begin
        ItemNo := NewItemNo;
    end;
}

