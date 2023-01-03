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
}

