page 50023 "Packing Item List"
{
    PageType = List;
    SourceTable = "Packing Item List";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Source Document Type"; Rec."Source Document Type")
                {
                    ApplicationArea = All;
                }
                field("Source Document No."; Rec."Source Document No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item Name"; Rec."Item Name")
                {
                    ApplicationArea = All;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
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
            action("Select Line")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if PackingLine2."Source Document Type" = PackingLine2."Source Document Type"::"Warehouse Shipment" then begin

                        recPackItemLine.SetRange("Packing No.", Rec."Packing No.");
                        recPackItemLine.SetRange("Packing Line No.", Rec."Packing Line No.");
                        WhseShipmentLines.SetTableView(WhseShipmentLine);
                        if recPackItemLine.FindLast then
                            WhseShipmentLines.Initialize(recPackItemLine, PackingLine2."Source Document No.", 'PackLine')
                        else
                            WhseShipmentLines.Initialize(Rec, PackingLine2."Source Document No.", 'PackLine');

                        WhseShipmentLines.LookupMode(true);
                        WhseShipmentLines.RunModal;
                    end;
                end;
            }
            action("Split Line")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TestField("Source Document No.");
                    Rec.TestField("Source Document Line No.");

                    if PackingLine2."Source Document Type" = PackingLine2."Source Document Type"::"Warehouse Shipment" then begin
                        SplitLine(Rec);
                        CurrPage.Update(true);
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Packing No.", PackingLine2."Packing No.");
        Rec.SetRange("Packing Line No.", PackingLine2."Line No.");
        Rec.FilterGroup(0);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        UpdateGrossQty;
    end;

    var
        PackingLine2: Record "Packing Line";
        WhseShipmentLines: Page "Whse. Shipment Lines";
        recPackItemLine: Record "Packing Item List";
        WhseShipmentLine: Record "Warehouse Shipment Line";
        PackItemLine: Record "Packing Item List";
        decNetWeight: Decimal;
        recItem: Record Item;

    procedure InitializePackingLine(PackingLine: Record "Packing Line")
    begin
        PackingLine2 := PackingLine;
    end;

    procedure UpdateGrossQty()
    begin
        decNetWeight := 0;
        //PackingLine2
        PackItemLine.Reset;
        PackItemLine.SetRange("Packing No.", PackingLine2."Packing No.");
        PackItemLine.SetRange("Packing Line No.", PackingLine2."Line No.");
        if PackItemLine.Find('-') then
            repeat
                recItem.Get(PackItemLine."Item No.");
                decNetWeight := decNetWeight + PackItemLine.Quantity * recItem.Weight;
            until PackItemLine.Next = 0;
        PackingLine2."Gross Weight" := decNetWeight + PackingLine2.Weight;
        PackingLine2.Modify(false);
    end;

    procedure SplitLine(recPackItemList: Record "Packing Item List")
    var
        recPackItemList2: Record "Packing Item List";
        LineNo: Integer;
    begin

        recPackItemList2.SetRange("Packing No.", recPackItemList."Packing No.");
        //recPackItemList2.SetRange("Packing Line No.", recPackItemList."Packing Line No.");
        if recPackItemList2.FindLast() then
            LineNo := recPackItemList2."Line No." + 10000;

        recPackItemList2.INIT;
        recPackItemList2."Packing No." := recPackItemList."Packing No.";
        recPackItemList2."Packing Line No." := recPackItemList."Packing Line No.";
        recPackItemList2."Source Document Type" := recPackItemList."Source Document Type";
        recPackItemList2."Source Document No." := recPackItemList."Source Document No.";
        recPackItemList2."Source Document Line No." := recPackItemList."Source Document Line No.";
        recPackItemList2."Line No." := LineNo;
        recPackItemList2."Item No." := recPackItemList."Item No.";
        recPackItemList2."Item Name" := recPackItemList."Item Name";
        recPackItemList2.VALIDATE(Quantity, 0);
        recPackItemList.VALIDATE("Unit Price", recPackItemList."Unit Price");
        recPackItemList2.INSERT;
    end;
}

