report 50059 "SLK Finishing Packing List"
{
    ApplicationArea = All;
    Caption = 'Finishing Packing List';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Report/Rep50059.SLKFinishingPackingList.rdlc';

    dataset
    {
        dataitem(SalesHeader; "Transfer Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";

            column(No; "No.")
            {
            }
            column(PostingDate; "Transfer Order Date")
            {
            }
            column(ShipVia; "Ship Via")
            {
            }
            column(ShipmentDate; "Shipment Date")
            {
            }
            column(TransferFromCode; "Transfer-from Code")
            {
            }
            column(TransferFromCity; "Transfer-from City")
            {
            }
            column(TransferFromName; "Transfer-from Name")
            {
            }
            column(TransferFromCounty; "Transfer-from County")
            {
            }
            column(TransferFromAddress; "Transfer-from Address")
            {
            }
            column(TransferFromAddress2; "Transfer-from Address 2")
            {
            }
            column(TransferFromPostCode; "Transfer-from Post Code")
            {
            }
            column(TransferFromContact; "Transfer-to Contact")
            {
            }
            column(LocFromEmail; LocFrom."E-Mail")
            {
            }
            column(TransfertoCode; "Transfer-to Code")
            {
            }
            column(TransfertoCity; "Transfer-to City")
            {
            }
            column(TransfertoName; "Transfer-to Name")
            {
            }
            column(TransfertoCounty; "Transfer-to County")
            {
            }
            column(TransfertoAddress; "Transfer-to Address")
            {
            }
            column(TransfertoAddress2; "Transfer-to Address 2")
            {
            }
            column(TransfertoPostCode; "Transfer-to Post Code")
            {
            }
            column(TransfertoContact; "Transfer-to Contact")
            {
            }
            column(TransfertoName2; "Transfer-to Name 2")
            {
            }
            column(LocContact; LocTo.Contact)
            {
            }
            column(LocPhone; LocTo."Phone No.")
            {
            }
            column(LocEmail; LocTo."E-Mail")
            {
            }
            column(CompanyInfoPicture; CompanyInfo.Picture)
            {
            }
            column(CompAddress; CompanyInfo.Address)
            {
            }
            column(CompAddress2; CompanyInfo."Address 2")
            {
            }
            column(CompCity; CompanyInfo.City)
            {
            }
            column(CompPostCode; CompanyInfo."Post Code")
            {
            }
            dataitem(TempRegActivityLine; "Packing Item List")
            {
                DataItemTableView = sorting("Packing No.", "Packing Line No.", "Line No.");
                UseTemporary = true;


                column(SalesOrder; SalesOrder)
                {
                }
                column(CustomerNo; CustomerNo)
                {
                }
                column(CustName; CustName)
                {
                }
                column(ItemName; "Item Name")
                {
                }
                column(LotNo; "Lot No.")
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(BackinDetails; BackinDetails)
                {
                }
                column(BoxNo; BoxNo)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    BoxNo := '';
                    BackinDetails := '';
                    SalesOrder := '';
                    CustomerNo := '';
                    CustName := '';

                    if "Unit Price" <> 1 then begin
                        PackingHeader.get("Packing No.");
                        PackingLines.get("Packing No.", "Packing Line No.");
                        BoxNo := PackingLines."Box Code";

                        PostedWhseShipLine.SetRange("Whse. Shipment No.", "Source Document No.");
                        PostedWhseShipLine.SetRange("Line No.", "Source Document Line No.");
                        if PostedWhseShipLine.FindFirst() then
                            if TransShipLine.get(PostedWhseShipLine."Posted Source No.", PostedWhseShipLine."Source Line No.") then begin
                                SalesOrder := TransShipLine."Sales Order No.";
                                if SalesLine.get(SalesLine."Document Type"::Order, TransShipLine."Sales Order No.", TransShipLine."Sales Order Line No.") then begin
                                    SalesHdr.get(SalesHdr."Document Type"::Order, TransShipLine."Sales Order No.");
                                    CustomerNo := SalesHdr."Sell-to Customer No.";
                                    CustName := SalesHdr."Sell-to Customer Name";
                                    BackinDetails := TransShipLine."SLK Instructions";
                                end;
                                if BackinDetails = '' then
                                    BackinDetails := Format(TransShipLine."SLK Instructions");
                            end;
                    end else begin
                        PackingHeader.SetRange("Source Document Type", PackingHeader."Source Document Type"::"Warehouse Shipment");
                        PackingHeader.SetRange("Source Document No.", "Source Document No.");
                        if PackingHeader.FindFirst() then begin
                            PackingLines.SetRange("Packing No.", PackingHeader."Packing No.");
                            if PackingLines.FindFirst() then
                                if PackingLines."Box Code" <> '' then
                                    BoxNo := PackingLines."Box Code";
                        end;

                        if TransShipLine.get("Packing No.", "Packing Line No.") then begin
                            SalesOrder := TransShipLine."Sales Order No.";
                            if SalesLine.get(SalesLine."Document Type"::Order, TransShipLine."Sales Order No.", TransShipLine."Sales Order Line No.") then begin
                                SalesHdr.get(SalesHdr."Document Type"::Order, TransShipLine."Sales Order No.");
                                CustomerNo := SalesHdr."Sell-to Customer No.";
                                CustName := SalesHdr."Sell-to Customer Name";
                                BackinDetails := TransShipLine."SLK Instructions";
                            end;
                            if BackinDetails = '' then
                                BackinDetails := Format(TransShipLine."SLK Instructions");
                        end;
                    end;




                end;
            }

            trigger OnAfterGetRecord()
            begin
                TempRegActivityLine.DeleteAll();
                TempPostedWhseShipLine.DeleteAll();

                PostedWhseShipLine.SetRange("Posted Source Document", PostedWhseShipLine."Posted Source Document"::"Posted Transfer Shipment");
                PostedWhseShipLine.SetRange("Posted Source No.", "No.");
                if PostedWhseShipLine.FindSet() then
                    repeat
                        TempPostedWhseShipLine.SetRange("Posted Source Document", PostedWhseShipLine."Posted Source Document");
                        TempPostedWhseShipLine.SetRange("Posted Source No.", PostedWhseShipLine."Posted Source No.");
                        TempPostedWhseShipLine.SetRange("Whse. Shipment No.", PostedWhseShipLine."Whse. Shipment No.");
                        if TempPostedWhseShipLine.IsEmpty() then begin
                            TempPostedWhseShipLine.Init();
                            TempPostedWhseShipLine := PostedWhseShipLine;
                            TempPostedWhseShipLine.Insert(false);
                        end;
                    until PostedWhseShipLine.Next() = 0;

                if TempPostedWhseShipLine.FindSet() then
                    repeat
                        PackingItemLines.SetRange("Source Document Type", PackingItemLines."Source Document Type"::"Warehouse Shipment");
                        PackingItemLines.SetRange("Source Document No.", TempPostedWhseShipLine."Whse. Shipment No.");
                        if PackingItemLines.FindSet() then begin
                            repeat
                                TempRegActivityLine.Init();
                                TempRegActivityLine := PackingItemLines;
                                TempRegActivityLine."Unit Price" := 0;
                                TempRegActivityLine.Insert();
                            until PackingItemLines.Next() = 0;
                        end else begin
                            TransShipLine.SetRange("Document No.", "No.");
                            TransShipLine.SetFilter(Quantity, '<>0');
                            if TransShipLine.FindSet() then begin
                                ILE.Reset();
                                ILE.SetCurrentKey("Document No.", "Document Type", "Document Line No.");
                                ILE.SetRange("Document No.", "No.");
                                ILE.SetRange("Document Type", ILE."Document Type"::"Transfer Shipment");
                                ILE.SetRange("Location Code", "Transfer-from Code");
                                repeat
                                    ILE.SetRange("Document Line No.", TransShipLine."Line No.");
                                    if ILE.FindSet() then
                                        repeat
                                            TempRegActivityLine.Init();
                                            TempRegActivityLine."Packing No." := ILE."Document No.";
                                            TempRegActivityLine."Packing Line No." := ILE."Document Line No.";
                                            TempRegActivityLine."Line No." := ILE."Entry No.";
                                            TempRegActivityLine."Item No." := ILE."Item No.";
                                            TempRegActivityLine."Item Name" := ile.Description;
                                            TempRegActivityLine."Source Document Type" := TempRegActivityLine."Source Document Type"::"Warehouse Shipment";
                                            TempRegActivityLine."Source Document No." := PostedWhseShipLine."Whse. Shipment No.";
                                            TempRegActivityLine."Source Document Line No." := PostedWhseShipLine."Whse Shipment Line No.";
                                            TempRegActivityLine."Lot No." := ILE."Lot No.";
                                            TempRegActivityLine.Quantity := ABS(ILE.Quantity);
                                            TempRegActivityLine."Unit Price" := 1;
                                            TempRegActivityLine.Insert();
                                        until ILE.Next() = 0;
                                until TransShipLine.Next() = 0;
                            end;
                        end;
                    until TempPostedWhseShipLine.Next() = 0;

            end;
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        WhseShipmentLine: Record "Warehouse Shipment Line";
        PostedWhseShipLine: Record "Posted Whse. Shipment Line";
        TransShipLine: Record "Transfer Shipment Line";
        SalesHdr: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CompanyInfo: Record "Company Information";
        LocFrom: Record Location;
        LocTo: Record Location;
        ILE: Record "Item Ledger Entry";
        TempPostedWhseShipLine: Record "Posted Whse. Shipment Line" temporary;
        PackingItemLines: Record "Packing Item List";
        PackingLines: Record "Packing Line";
        PackingHeader: Record "Packing Header";
        BackinDetails: Text[100];
        BoxNo: Text[30];
        SalesOrder: Code[20];
        CustomerNo: Code[20];
        CustName: Text[100];
}
