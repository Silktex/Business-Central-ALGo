report 50056 "Transfer Order Report 4X6"
{
    ApplicationArea = All;
    Caption = 'Transfer Order Report 4X6';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Report/TransferOrderReportLabel.rdlc';

    dataset
    {
        dataitem(TransferHeader; "Transfer Shipment Header")
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
            column(TotAvailQty; TotAvailQty)
            {
            }
            column(TotItemCount; TotItemCount)
            {
            }
            column(TotReqQty; TotReqQty)
            {
            }
            column(BarcodeText; EncodedText)
            {
            }
            dataitem(TempTransferLine; "Transfer Shipment Line")
            {
                DataItemTableView = sorting("Document No.", "Line No.") where(Quantity = filter(<> 0));
                DataItemLink = "Document No." = field("No.");
                UseTemporary = true;

                column(DocumentNo; "Document No.")
                {
                }
                column(LineNo; "Line No.")
                {
                }
                column(ItemNo; Description) // "Item No.")
                {
                }
                column(Description; "Description 2")
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(SLKInstructions; "SLK Instructions")
                {
                }
                column(SalesOrderNo; "Sales Order No.")
                {
                }
                column(SalesOrderLineNo; "Sales Order Line No.")
                {
                }
                column(CustomerNo; CustomerNo)
                {
                }
                column(CustomerName; CustomerName)
                {
                }
                column(SalesOrderAdd; SalesOrder."Sell-to Address")
                {
                }
                column(SalesOrderAdd2; SalesOrder."Sell-to Address 2")
                {
                }
                column(SalesOrderCity; SalesOrder."Sell-to City")
                {
                }
                column(SalesOrderPostCode; SalesOrder."Sell-to Post Code")
                {
                }
                column(SalesOrderEmail; SalesOrder."Sell-to E-mail")
                {
                }
                column(Treatment; Treatment)
                {
                }
                column(Bins; Bins)
                {
                }
                column(AvailQty; AvailQty)
                {
                }
                column(MOQ; MOQ)
                {
                }
                column(ReqQty; ReqQty)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CustomerNo := '';
                    CustomerName := '';
                    Treatment := '';
                    ReqQty := 0;
                    MOQ := 0;

                    if ("Sales Order No." <> '') and ("Sales Order Line No." <> 0) then
                        if SalesLine.get(SalesLine."Document Type"::Order, "Sales Order No.", "Sales Order Line No.") then begin
                            SalesOrder.get(SalesOrder."Document Type"::Order, "Sales Order No.");
                            CustomerNo := SalesOrder."Sell-to Customer No.";
                            CustomerName := SalesOrder."Sell-to Customer Name";
                            Treatment := "SLK Instructions";
                            ReqQty := ABS(Quantity);
                        end;
                end;
            }

            trigger OnAfterGetRecord()
            var
                BarcodeString: Text;
                Base64Convert: Codeunit "Base64 Convert";
                InStr: InStream;
                cduBarcodeMgt: Codeunit "SLK Barcode Management";
                TempBlob: Codeunit "Temp Blob";
            begin
                LocFrom.get("Transfer-from Code");
                LocTo.GET("Transfer-to Code");

                BarcodeString := "No.";
                cduBarcodeMgt.EncodeCode128128(BarcodeString, 1, false, TempBlob);
                TempBlob.CreateInStream(InStr);
                EncodedText := Base64Convert.ToBase64(InStr);

                TotItemCount := 0;
                TotReqQty := 0;
                TotAvailQty := 0;
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
                                TempTransferLine.Init();
                                TempTransferLine := TransShipLine;
                                TempTransferLine."Line No." := ILE."Entry No.";
                                TempTransferLine.Quantity := ILE.Quantity;
                                TempTransferLine."Description 2" := ILE."Lot No.";
                                TempTransferLine.Insert();
                            until ILE.Next() = 0;
                    until TransShipLine.Next() = 0;
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        LocFrom: Record Location;
        LocTo: Record Location;
        SalesOrder: Record "Sales Header";
        SalesLine: Record "Sales Line";
        BinContent: Record "Bin Content";
        TransShipLine: Record "Transfer Shipment Line";
        Item: Record Item;
        ILE: Record "Item Ledger Entry";
        BarcodeProvider: Codeunit "QR Code Management";
        EncodedText: text;
        CustomerNo: code[20];
        CustomerName: Text[100];
        Treatment: Text[250];
        Bins: Text[250];
        AvailQty: Decimal;
        MOQ: Decimal;
        ReqQty: Decimal;
        TotAvailQty: Decimal;
        TotItemCount: Decimal;
        TotReqQty: Decimal;

}
