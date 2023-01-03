page 50067 "Whse. Pick Subform Handheld"
{
    AutoSplitKey = true;
    Caption = 'Whse. Pick Subform Handheld';
    DelayedInsert = true;
    InsertAllowed = false;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "Warehouse Activity Line";
    SourceTableView = WHERE("Activity Type" = CONST(Pick),
                            "Action Type" = FILTER(Take));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Action Type"; Rec."Action Type")
                {
                    ApplicationArea = All;
                }
                field("Source Document"; Rec."Source Document")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    //OptionCaption = ',Sales Order,,,Sales Return Order,Purchase Order,,,Purchase Return Order,,Outbound Transfer,Prod. Consumption,,,,,,,Service Order,,Assembly Consumption';
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        SerialNoOnAfterValidate;
                    end;
                }
                field("Serial No. Blocked"; Rec."Serial No. Blocked")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        LotNoOnAfterValidate;
                    end;
                }
                field("Lot No. Blocked"; Rec."Lot No. Blocked")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Zone Code"; Rec."Zone Code")
                {
                    ApplicationArea = All;
                    Editable = "Zone CodeEditable";
                    Visible = false;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                    Editable = "Bin CodeEditable";
                    Visible = false;

                    trigger OnValidate()
                    begin
                        BinCodeOnAfterValidate;
                    end;
                }
                field("Shelf No."; Rec."Shelf No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Original Quantity"; Rec."Original Quantity")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Qty. (Base)"; Rec."Qty. (Base)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Qty. to Handle"; Rec."Qty. to Handle")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        QtytoHandleOnAfterValidate;
                    end;
                }
                field("Qty. Handled"; Rec."Qty. Handled")
                {
                    ApplicationArea = All;
                    Visible = true;
                }
                field("Qty. to Handle (Base)"; Rec."Qty. to Handle (Base)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Qty. Handled (Base)"; Rec."Qty. Handled (Base)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Qty. Outstanding"; Rec."Qty. Outstanding")
                {
                    ApplicationArea = All;
                    Visible = true;
                }
                field("Qty. Outstanding (Base)"; Rec."Qty. Outstanding (Base)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Shipping Advice"; Rec."Shipping Advice")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Destination Type"; Rec."Destination Type")
                {
                    ApplicationArea = All;
                }
                field("Destination No."; Rec."Destination No.")
                {
                    ApplicationArea = All;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Whse. Document Type"; Rec."Whse. Document Type")
                {
                    ApplicationArea = All;
                    //OptionCaption = ' ,,Shipment,,Internal Pick,Production,,,Assembly';
                    Visible = false;
                }
                field("Whse. Document No."; Rec."Whse. Document No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Whse. Document Line No."; Rec."Whse. Document Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Special Equipment Code"; Rec."Special Equipment Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Assemble to Order"; Rec."Assemble to Order")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Split Line")
                {
                    ApplicationArea = All;
                    Caption = '&Split Line';
                    Image = Split;
                    ShortCutKey = 'Ctrl+F11';

                    trigger OnAction()
                    var
                        WhseActivLine: Record "Warehouse Activity Line";
                    begin
                        WhseActivLine.Copy(Rec);
                        Rec.SplitLine(WhseActivLine);
                        CurrPage.Update(false);
                    end;
                }
                action(ChangeUnitOfMeasure)
                {
                    ApplicationArea = All;
                    Caption = '&Change Unit Of Measure';
                    Ellipsis = true;
                    Image = UnitConversions;

                    trigger OnAction()
                    begin
                        ChangeUOM;
                    end;
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Source &Document Line")
                {
                    ApplicationArea = All;
                    Caption = 'Source &Document Line';
                    Image = SourceDocLine;

                    trigger OnAction()
                    begin
                        ShowSourceLine;
                    end;
                }
                action("Whse. Document Line")
                {
                    ApplicationArea = All;
                    Caption = 'Whse. Document Line';
                    Image = Line;

                    trigger OnAction()
                    begin
                        ShowWhseLine;
                    end;
                }
                action("Bin Contents List")
                {
                    ApplicationArea = All;
                    Caption = 'Bin Contents List';
                    Image = BinContent;

                    trigger OnAction()
                    begin
                        ShowBinContents;
                    end;
                }
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    Image = ItemAvailability;
                    action("Event")
                    {
                        ApplicationArea = All;
                        Caption = 'Event';
                        Image = "Event";

                        trigger OnAction()
                        begin
                            ItemAvailability(ItemAvailFormsMgt.ByEvent);
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = All;
                        Caption = 'Period';
                        Image = Period;

                        trigger OnAction()
                        begin
                            ItemAvailability(ItemAvailFormsMgt.ByPeriod);
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = All;
                        Caption = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            ItemAvailability(ItemAvailFormsMgt.ByVariant);
                        end;
                    }
                    action(Location)
                    {
                        ApplicationArea = All;
                        Caption = 'Location';
                        Image = Warehouse;

                        trigger OnAction()
                        begin
                            ItemAvailability(ItemAvailFormsMgt.ByLocation);
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        EnableZoneBin;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.Update(false);
    end;

    trigger OnInit()
    begin
        "Bin CodeEditable" := true;
        "Zone CodeEditable" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Activity Type" := xRec."Activity Type";
    end;

    var
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        WMSMgt: Codeunit "WMS Management";
        [InDataSet]
        "Zone CodeEditable": Boolean;
        [InDataSet]
        "Bin CodeEditable": Boolean;


    procedure ShowSourceLine()
    begin
        WMSMgt.ShowSourceDocLine(
          Rec."Source Type", Rec."Source Subtype", Rec."Source No.", Rec."Source Line No.", Rec."Source Subline No.");
    end;

    procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin,"Event",BOM)
    begin
        ItemAvailFormsMgt.ShowItemAvailFromWhseActivLine(Rec, AvailabilityType);
    end;

    procedure AutofillQtyToHandle()
    var
        WhseActivLine: Record "Warehouse Activity Line";
    begin
        WhseActivLine.Copy(Rec);
        Rec.AutofillQtyToHandle(WhseActivLine);
    end;


    procedure DeleteQtyToHandle()
    var
        WhseActivLine: Record "Warehouse Activity Line";
    begin
        WhseActivLine.Copy(Rec);
        Rec.DeleteQtyToHandle(WhseActivLine);
    end;

    procedure ChangeUOM()
    var
        WhseActLine: Record "Warehouse Activity Line";
        WhseChangeOUM: Report "Whse. Change Unit of Measure";
    begin
        Rec.TestField("Action Type");
        Rec.TestField("Breakbulk No.", 0);
        Rec.TestField("Action Type", 1);
        WhseChangeOUM.DefWhseActLine(Rec);
        WhseChangeOUM.RunModal;
        if WhseChangeOUM.ChangeUOMCode(WhseActLine) = true then
            Rec.ChangeUOMCode(Rec, WhseActLine);
        Clear(WhseChangeOUM);
        CurrPage.Update(false);
    end;

    procedure RegisterActivityYesNo()
    var
        WhseActivLine: Record "Warehouse Activity Line";
        WhseRegisterActivityYesNo: Codeunit "Whse.-Act.-Register (Yes/No)";
    begin
        WhseActivLine.Copy(Rec);
        WhseActivLine.FilterGroup(3);
        WhseActivLine.SetRange(Breakbulk);
        WhseActivLine.FilterGroup(0);
        WhseRegisterActivityYesNo.Run(WhseActivLine);
        Rec.Reset;
        Rec.SetCurrentKey("Activity Type", "No.", "Sorting Sequence No.");
        Rec.FilterGroup(4);
        Rec.SetRange("Activity Type", Rec."Activity Type");
        Rec.SetRange("No.", Rec."No.");
        Rec.FilterGroup(3);
        Rec.SetRange(Breakbulk, false);
        Rec.FilterGroup(0);
        CurrPage.Update(false);
    end;

    procedure ShowBinContents()
    var
        BinContent: Record "Bin Content";
    begin
        BinContent.ShowBinContents(Rec."Location Code", Rec."Item No.", Rec."Variant Code", '')
    end;

    procedure ShowWhseLine()
    begin
        WMSMgt.ShowWhseDocLine(
         Rec."Whse. Document Type".AsInteger(), Rec."Whse. Document No.", Rec."Whse. Document Line No.");
    end;

    local procedure EnableZoneBin()
    begin
        "Zone CodeEditable" :=
          (Rec."Action Type" = Rec."Action Type"::Take) or (Rec."Breakbulk No." <> 0);
        "Bin CodeEditable" :=
          (Rec."Action Type" = Rec."Action Type"::Take) or (Rec."Breakbulk No." <> 0);
    end;

    local procedure SerialNoOnAfterValidate()
    var
        ExpDate: Date;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        EntriesExist: Boolean;
        ItemTrackingSetup: Record "Item Tracking Setup";
    begin
        if Rec."Serial No." <> '' then begin
            ItemTrackingSetup."Serial No." := Rec."Serial No.";
            ItemTrackingSetup."Lot No." := Rec."Lot No.";
            ExpDate := ItemTrackingMgt.ExistingExpirationDate(Rec."Item No.", Rec."Variant Code",
                ItemTrackingSetup, false, EntriesExist);
        end;
        if ExpDate <> 0D then
            Rec."Expiration Date" := ExpDate;
    end;

    local procedure LotNoOnAfterValidate()
    var
        ExpDate: Date;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        EntriesExist: Boolean;
        ItemTrackingSetup: Record "Item Tracking Setup";
    begin
        if Rec."Lot No." <> '' then begin
            ItemTrackingSetup."Serial No." := Rec."Serial No.";
            ItemTrackingSetup."Lot No." := Rec."Lot No.";
            ExpDate := ItemTrackingMgt.ExistingExpirationDate(Rec."Item No.", Rec."Variant Code",
                ItemTrackingSetup, false, EntriesExist);
        end;
        if ExpDate <> 0D then
            Rec."Expiration Date" := ExpDate;
    end;

    local procedure BinCodeOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure QtytoHandleOnAfterValidate()
    begin
        CurrPage.SaveRecord;
    end;
}

