codeunit 50010 "SLK Create Trans. Ord. from SO"
{
    TableNo = "Sales Header";

    trigger OnRun()
    var
        SalesLine: Record "Sales Line";
        TransHeader: Record "Transfer Header";
        PostedTransShip: Record "Transfer Shipment Header";
        TransLine: Record "Transfer Line";
        TransShipLine: Record "Transfer Shipment Line";
        ReleaseTransOrder: Codeunit "Release Transfer Document";
        TransOrdExistLbl: Label 'Transfer Order is already %1 created';
        TransOrdAddLbl: Label 'Transfer Order %1 has been created';
        TransOrdApndLbl: Label 'Transfer Order %1 has been appended';
    begin
        Rec.TestField(Status, Rec.Status::Released);

        SalesLine.Reset();
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("Outstanding Quantity", '<>0');
        if SalesLine.FindSet() then begin
            if TransferNo = '' then
                InsertTransHeader(Rec, TransHeader)
            else
                TransHeader.get(TransferNo);

            repeat
                TransLine.SetRange("Sales Order No.", SalesLine."Document No.");
                TransLine.SetRange("Sales Order Line No.", SalesLine."Line No.");
                if not TransLine.FindFirst() then begin
                    TransShipLine.SetRange("Sales Order No.", SalesLine."Document No.");
                    TransShipLine.SetRange("Sales Order Line No.", SalesLine."Line No.");
                    if not TransShipLine.FindFirst() then begin
                        if TransHeader.Status = TransHeader.Status::Released then begin
                            ReleaseTransOrder.Reopen(TransHeader);
                            Commit();
                        end;

                        InsertTransLine(SalesLine, TransHeader);
                    end;
                end;

            until SalesLine.Next() = 0;
            Commit();

            if not FromBatch then
                if GuiAllowed then
                    if TransferNo = '' then
                        Message(TransOrdAddLbl, TransHeader."No.")
                    else
                        Message(TransOrdAddLbl, TransHeader."No.");
        end;
    end;

    procedure InsertTransHeader(var SalesHeadere: Record "Sales Header"; var TransferHeader: Record "Transfer Header")
    var
        InventorySetup: Record "Inventory Setup";
        TransferRoute: Record "Transfer Route";
        IsHandled: Boolean;
    begin
        InventorySetup.Get();
        InventorySetup.TestField("Transfer Order Nos.");

        TransferRoute.Reset();
        TransferRoute.SetRange("Transfer-to Code", SalesHeadere."Location Code");
        if TransferRoute.FindFirst() then begin
            TransferRoute.TestField("Transfer-from Code");
            TransferRoute.TestField("In-Transit Code");
        end;

        TransferHeader.Init();
        TransferHeader."No." := '';
        TransferHeader."Posting Date" := WorkDate();
        TransferHeader.Insert(true);
        TransferHeader.SetHideValidationDialog(true);
        TransferHeader.Validate("Transfer-from Code", TransferRoute."Transfer-from Code");
        TransferHeader.Validate("Transfer-to Code", SalesHeadere."Location Code");
        // if SalesHeadere."Posting Date" <> 0D then begin
        //     TransferHeader.Validate("Posting Date", SalesHeadere."Posting Date");
        //     TransferHeader."Receipt Date" := SalesHeadere."Posting Date";
        //     TransferHeader."Shipment Date" := SalesHeadere."Posting Date";
        // end else begin
        TransferHeader.Validate("Posting Date", WorkDate());
        TransferHeader."Receipt Date" := WorkDate();
        TransferHeader."Shipment Date" := WorkDate();
        // end;
        //TransferHeader."Sales Order No" := SalesHeadere."No.";
        TransferHeader.Modify();
        TransOrderNo := TransferHeader."No.";

        SalesHeadere."Additional Info" := TransOrderNo;
        SalesHeadere.Modify(false);
    end;

    procedure InsertTransLine(SalesLine: Record "Sales Line"; var TransferHeader: Record "Transfer Header")
    var
        TransferLine: Record "Transfer Line";
        ResourceSLine: Record "Sales Line";
        NextLineNo: Integer;
    begin
        TransferLine.SetRange("Document No.", TransferHeader."No.");
        if TransferLine.FindLast() then
            NextLineNo := TransferLine."Line No." + 10000
        else
            NextLineNo := 10000;

        TransferLine.Init();
        TransferLine.BlockDynamicTracking(true);
        TransferLine."Document No." := TransferHeader."No.";
        TransferLine."Line No." := NextLineNo;
        TransferLine.Validate("Item No.", SalesLine."No.");
        TransferLine.Description := SalesLine.Description;
        TransferLine."Description 2" := SalesLine."Description 2";
        TransferLine.Validate("Variant Code", SalesLine."Variant Code");
        TransferLine.Validate("Transfer-from Code", TransferHeader."Transfer-from Code");
        TransferLine.Validate("Transfer-to Code", SalesLine."Location Code");
        TransferLine.Validate(Quantity, SalesLine.Quantity);
        TransferLine.Validate("Unit of Measure Code", SalesLine."Unit of Measure Code");
        TransferLine."Receipt Date" := TransferHeader."Receipt Date";
        TransferLine."Shipment Date" := TransferHeader."Posting Date";
        TransferLine."Sales Order No." := SalesLine."Document No.";
        TransferLine."Sales Order Line No." := SalesLine."Line No.";

        ResourceSLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        ResourceSLine.SetRange("Document Type", ResourceSLine."Document Type"::Order);
        ResourceSLine.SetRange("Document No.", SalesLine."Document No.");
        ResourceSLine.SetFilter("Line No.", '%1..', SalesLine."Line No.");
        ResourceSLine.SetRange(Type, ResourceSLine.Type::Resource);
        if ResourceSLine.FindFirst() then
            TransferLine."SLK Instructions" := ResourceSLine.Description;

        TransferLine.Insert();
    end;

    procedure SetTransferHeader(TransNo: Code[20]; BatchReq: Boolean)
    begin
        TransferNo := TransNo;
        FromBatch := BatchReq;
    end;

    procedure GetTransferOrderNo(): Code[20]
    begin
        exit(TransOrderNo);
    end;

    var
        TransferNo: Code[20];
        FromBatch: Boolean;
        TransOrderNo: Code[20];


}
