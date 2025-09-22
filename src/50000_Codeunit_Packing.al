codeunit 50000 Packing
{

    trigger OnRun()
    begin
    end;

    var
        SourceDocumentType: Option " ","Warehouse Shipment","Sales Shipment","Transfer Order","Return Receipt";


    procedure InsertPackingLine(recPackItemList: Record "Packing Item List"; decQuantity: Decimal; DocumentNo: Code[20]; LineNo: Integer; ItemNo: Code[20]; txtDescription: Text[50]; NextLineNo: Integer; SourceType: Option " ","Warehouse Shipment","Sales Shipment","Transfer Order","Return Shipment"; decUnitPrice: Decimal)
    var
        recPackItemList2: Record "Packing Item List";
    begin

        NextLineNo := NextLineNo + 10000;
        recPackItemList2.INIT;
        recPackItemList2."Packing No." := recPackItemList."Packing No.";
        recPackItemList2."Packing Line No." := recPackItemList."Packing Line No.";
        recPackItemList2."Source Document Type" := SourceType;
        recPackItemList2."Source Document No." := DocumentNo;
        recPackItemList2."Source Document Line No." := LineNo;
        recPackItemList2."Line No." := NextLineNo;
        recPackItemList2."Item No." := ItemNo;
        recPackItemList2."Item Name" := txtDescription;
        recPackItemList2.VALIDATE(Quantity, decQuantity);
        recPackItemList.VALIDATE("Unit Price", decUnitPrice);
        recPackItemList2.INSERT;
    end;


    procedure CreateWhsePackingLine(var FromWhseShptLine: Record "Warehouse Shipment Line"; PackItemList: Record "Packing Item List")
    var
        ItemChargeAssgntSales2: Record "Item Charge Assignment (Sales)";
        Nextline: Integer;
        PackItemList2: Record "Packing Item List";
        WhseShptLine: Record "Warehouse Shipment Line";
        recSalesLine: Record "Sales Line";
    begin
        Nextline := PackItemList."Line No.";
        PackItemList2.SETRANGE("Packing No.", PackItemList."Packing No.");
        PackItemList2.SETRANGE("Packing Line No.", PackItemList."Packing Line No.");
        REPEAT
            //PackItemList2.SETRANGE("Applies-to Doc. No.",FromSalesShptLine."Document No.");
            PackItemList2.SETRANGE("Source Document Line No.", FromWhseShptLine."Line No.");
            IF NOT PackItemList2.FINDFIRST THEN BEGIN
                recSalesLine.RESET;
                recSalesLine.SETRANGE("Document No.", FromWhseShptLine."Source No.");
                recSalesLine.SETRANGE("Line No.", FromWhseShptLine."Source Line No.");
                IF recSalesLine.FINDFIRST THEN;
                InsertPackingLine(PackItemList, FromWhseShptLine."Quantity To Pack",
                  FromWhseShptLine."No.", FromWhseShptLine."Line No.", FromWhseShptLine."Item No."
                  , FromWhseShptLine.Description, Nextline, SourceDocumentType::"Warehouse Shipment", recSalesLine."Unit Price");
                WhseShptLine := FromWhseShptLine;
                WhseShptLine."Quantity Packed" := WhseShptLine."Quantity Packed" + WhseShptLine."Quantity To Pack";
                WhseShptLine."Quantity To Pack" := WhseShptLine."Qty. to Ship" + WhseShptLine."Qty. Shipped" - WhseShptLine."Quantity Packed";
                WhseShptLine.MODIFY(FALSE);
            END;
        UNTIL FromWhseShptLine.NEXT = 0;
    end;


    procedure ReleasePacking(recPackingHeader: Record "Packing Header")
    var
        recPackingLine: Record "Packing Line";
        recPackItemLine: Record "Packing Item List";
    begin
        IF recPackingHeader.Status = recPackingHeader.Status::Release THEN
            EXIT;

        recPackingLine.RESET;
        recPackingLine.SETRANGE("Packing No.", recPackingHeader."Packing No.");
        recPackingLine.SETFILTER("Box Code", '<>%1', '');
        IF NOT recPackingLine.FIND('-') THEN
            ERROR('Nothing to release')
        ELSE BEGIN
            REPEAT
                recPackItemLine.RESET;
                recPackItemLine.SETRANGE("Packing No.", recPackingLine."Packing No.");
                recPackItemLine.SETRANGE("Packing Line No.", recPackingLine."Line No.");
                recPackItemLine.SETFILTER(Quantity, '<>0');
                IF NOT recPackItemLine.FIND('-') THEN
                    ERROR('There are no item line attached for Line No %1', recPackingLine."Line No.");
            UNTIL recPackingLine.NEXT = 0;
        END;
        recPackingHeader.Status := recPackingHeader.Status::Release;
        recPackingHeader.MODIFY;
    end;


    procedure ReopenPacking(recPackingHeader: Record "Packing Header")
    begin
        IF recPackingHeader.Status = recPackingHeader.Status::Release THEN BEGIN
            recPackingHeader.Status := recPackingHeader.Status::Open;
            recPackingHeader.MODIFY;
        END;
    end;
}

