page 50019 "Voided Tracking No (ShipReq.)"
{
    Editable = false;
    PageType = List;
    SourceTable = "Tracking No.";
    SourceTableView = WHERE("Void Entry" = FILTER(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Warehouse Shipment No"; Rec."Warehouse Shipment No")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Tracking No."; Rec."Tracking No.")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Source Document No."; Rec."Source Document No.")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(PostedWhShipment)
            {
                ApplicationArea = All;
                Caption = 'Posted Wh Shipment';
                Ellipsis = true;
                Image = Warehouse;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PostedWhseShiptHdr: Record "Posted Whse. Shipment Header";
                begin
                    PostedWhseShiptHdr.Reset;
                    PostedWhseShiptHdr.SetRange(PostedWhseShiptHdr."Whse. Shipment No.", Rec."Warehouse Shipment No");
                    if PostedWhseShiptHdr.FindFirst then
                        PAGE.Run(PAGE::"Posted Whse. Shipment", PostedWhseShiptHdr);
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if cdDoc1 <> '' then
            Rec."Source Document No." := cdDoc1;
    end;

    var
        cdDoc1: Code[20];

    procedure Init(cdDocNo: Code[20])
    begin
        cdDoc1 := cdDocNo;
    end;
}

