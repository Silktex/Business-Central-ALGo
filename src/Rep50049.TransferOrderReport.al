report 50049 "Transfer Order Report"
{
    ApplicationArea = All;
    Caption = 'Transfer Order Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Report/TransferOrderReport.rdlc';

    dataset
    {
        dataitem(TransferHeader; "Transfer Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(No; "No.")
            {
            }
            column(OrderBarcode; EncodedText)
            {
            }
            column(PostingDate; DT2Date(SystemCreatedAt))
            {
            }
            column(ShipVia; "Ship Via")
            {
            }
            column(ShipmentDate; "Shipment Date")
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
            column(LocContact; Loc.Contact)
            {
            }
            column(LocPhone; Loc."Phone No.")
            {
            }
            column(LocEmail; Loc."E-Mail")
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
            dataitem(TempTransferLine; "Transfer Line")
            {
                DataItemTableView = sorting("Sales Order No.", "Sales Order Line No.");
                DataItemLink = "Document No." = field("No.");
                UseTemporary = true;

                column(ItemNo; Description) //"Item No.")
                {
                }
                column(Description; Description)
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
                column(SalesOrderLineNo; "Line No.") //"Sales Order Line No.")
                {
                }
                column(CustomerNo; CustomerNo)
                {
                }
                column(CustomerName; CustomerName)
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
                column(StandardCommentLines; StandardCommentLines)
                {
                }
                column(CommentLinesText; CommentLinesText)
                {
                }

                trigger OnAfterGetRecord()
                var
                    StandardComment: Record "Sales Comment New";
                    SalesLineComment: Record "Sales Comment Line";
                begin
                    CustomerNo := '';
                    CustomerName := '';
                    Treatment := '';
                    ReqQty := 0;
                    MOQ := 0;
                    CommentLinesText := '';

                    if "Line No." < 900000000 then begin
                        StandardCommentLines := '';



                        if ("Sales Order No." <> '') and ("Sales Order Line No." <> 0) then
                            if SalesLine.get(SalesLine."Document Type"::Order, "Sales Order No.", "Sales Order Line No.") then begin
                                SalesOrder.get(SalesOrder."Document Type"::Order, "Sales Order No.");
                                CustomerNo := SalesOrder."Sell-to Customer No.";
                                CustomerName := SalesOrder."Sell-to Customer Name";
                                Treatment := "SLK Instructions";
                                ReqQty := Quantity;
                                MOQ := SalesLine."Minimum Qty";

                                AvailQty := 0;
                                Item.Reset;
                                Item.SetRange("No.", "Item No.");
                                Item.SetRange("Location Filter", "Transfer-from Code");
                                if Item.FindFirst() then begin
                                    item.CalcFields(Inventory);
                                    AvailQty := Item.Inventory;
                                end;

                                Bins := '';
                                BinContent.Reset();
                                BinContent.SetRange("Location Code", "Transfer-from Code");
                                BinContent.SetRange("Item No.", "Item No.");
                                if BinContent.FindSet() then
                                    repeat
                                        BinContent.CalcFields("Quantity (Base)");
                                        if BinContent."Quantity (Base)" <> 0 then
                                            if Bins = '' then
                                                bins := BinContent."Bin Code"
                                            else
                                                Bins := Bins + ',' + BinContent."Bin Code";
                                    until BinContent.Next() = 0;

                                if IncludeStandardCmt and ("Line No." < 900000000) then begin
                                    GetStandardComments(SalesOrder, SalesLine);
                                end;

                                SalesLineComment.Reset();
                                SalesLineComment.SetRange("Document Type", SalesLineComment."Document Type"::Order);
                                SalesLineComment.SetRange("No.", SalesLine."Document No.");
                                SalesLineComment.SetRange("Document Line No.", SalesLine."Line No.");
                                if SalesLineComment.FindSet() then
                                    repeat
                                        if CommentLinesText = '' then
                                            CommentLinesText := '- ' + SalesLineComment.Comment
                                        else
                                            CommentLinesText := CommentLinesText + Format(CR) + Format(LF) + '- ' + SalesLineComment.Comment;
                                    until SalesLineComment.Next() = 0;
                            end;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            var
                SONo: Code[20];
                PrevTransLine: Record "Transfer Line";
                LNo: Integer;
                BarcodeString: Text;
                Base64Convert: Codeunit "Base64 Convert";
                InStr: InStream;
                cduBarcodeMgt: Codeunit "SLK Barcode Management";
                TempBlob: Codeunit "Temp Blob";
            begin
                TempTransferLine.DeleteAll();

                Loc.GET("Transfer-to Code");

                TotItemCount := 0;
                TotReqQty := 0;
                TotAvailQty := 0;
                SONo := '';
                LNo := 900000000;

                BarcodeString := "No.";
                cduBarcodeMgt.EncodeCode128128(BarcodeString, 1, false, TempBlob);
                TempBlob.CreateInStream(InStr);
                EncodedText := Base64Convert.ToBase64(InStr);

                TransLine.SetCurrentKey("Sales Order No.", "Sales Order Line No.");
                TransLine.SetRange("Document No.", "No.");
                //TransLine.SetFilter(Quantity, '<>0');
                TransLine.SetRange("Transfer-from Code", "Transfer-from Code");
                if TransLine.FindSet() then begin
                    repeat
                        TotItemCount += 1;
                        TotReqQty += TransLine.Quantity;

                        Item.Reset;
                        Item.SetRange("No.", TransLine."Item No.");
                        Item.SetRange("Location Filter", "Transfer-from Code");
                        if Item.FindFirst() then begin
                            item.CalcFields(Inventory);
                            TotAvailQty += Item.Inventory;
                        end;

                        TempTransferLine.Init();
                        TempTransferLine := TransLine;
                        TempTransferLine.Insert();

                        if SONo = '' then
                            SONo := TransLine."Sales Order No."
                        else
                            if SONo <> TransLine."Sales Order No." then begin
                                LNo += 1;
                                TempTransferLine.init();
                                TempTransferLine."Document No." := TransLine."Document No.";
                                TempTransferLine."Line No." := LNo;
                                TempTransferLine."Sales Order No." := SONo;
                                TempTransferLine."Sales Order Line No." := 99999;
                                TempTransferLine.Insert();
                            end;
                        SONo := TransLine."Sales Order No.";
                    until TransLine.Next() = 0;

                    LNo += 1;
                    TempTransferLine.init();
                    TempTransferLine."Document No." := TransLine."Document No.";
                    TempTransferLine."Line No." := LNo;
                    TempTransferLine."Sales Order No." := SONo;
                    TempTransferLine."Sales Order Line No." := 99999;
                    if not TempTransferLine.Insert() then;
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
                    field(IncludeStandardCmt; IncludeStandardCmt)
                    {
                        Caption = 'Include Standard Comment';
                        ApplicationArea = All;
                    }
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
        CR := 10;
        LF := 13;
    end;

    var
        CompanyInfo: Record "Company Information";
        Loc: Record Location;
        SalesOrder: Record "Sales Header";
        SalesLine: Record "Sales Line";
        BinContent: Record "Bin Content";
        TransLine: Record "Transfer Line";
        Item: Record Item;
        BarcodeProvider: Codeunit "QR Code Management";
        IncludeStandardCmt: Boolean;
        EncodedText: Text;
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
        CommentLinesText: Text;
        StandardCommentLines: Text;
        CR: Char;
        LF: Char;
        intLineCount: Integer;
        txtProductGroup: Code[20];
        recStandardComment: Record "Standard Comment";
        txtComment: array[256] of Text[250];
        intCommentLine: Integer;
        recSalesHeader: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        OrderNo: Code[20];

    local procedure GetStandardComments(recSalesHeader: Record "Sales Header"; recSalesLine: Record "Sales Line")
    begin
        txtProductGroup := '';

        if recSalesLine.Quantity - recSalesLine."Quantity Shipped" > 0 then
            if recSalesLine."Item Category Code" <> '' then begin
                recStandardComment.Reset;
                recStandardComment.SetRange("Product Code", recSalesLine."Item Category Code");
                recStandardComment.SetFilter(recStandardComment."From Date", '%1|<%2', 0D, recSalesHeader."Posting Date");
                recStandardComment.SetRange(recStandardComment."Sales Type", recStandardComment."Sales Type"::Customer);
                recStandardComment.SetRange(recStandardComment."Sales Code", recSalesHeader."Sell-to Customer No.");
                if recStandardComment.Find('-') then begin
                    if recStandardComment.Comment <> '' then begin
                        if StandardCommentLines = '' then
                            StandardCommentLines := '- ' + recStandardComment.Comment
                        else
                            StandardCommentLines := StandardCommentLines + Format(CR) + Format(LF) + '- ' + recStandardComment.Comment;
                    end;
                    if recStandardComment."Comment 2" <> '' then begin
                        if StandardCommentLines = '' then
                            StandardCommentLines := '- ' + recStandardComment."Comment 2"
                        else
                            StandardCommentLines := StandardCommentLines + Format(CR) + Format(LF) + '- ' + recStandardComment."Comment 2";
                    end;
                    if recStandardComment."Comment 3" <> '' then begin
                        if StandardCommentLines = '' then
                            StandardCommentLines := '- ' + recStandardComment."Comment 3"
                        else
                            StandardCommentLines := StandardCommentLines + Format(CR) + Format(LF) + '- ' + recStandardComment."Comment 3";
                    end;
                    if recStandardComment."Comment 4" <> '' then begin
                        if StandardCommentLines = '' then
                            StandardCommentLines := '- ' + recStandardComment."Comment 4"
                        else
                            StandardCommentLines := StandardCommentLines + Format(CR) + Format(LF) + '- ' + recStandardComment."Comment 4";
                    end;
                    if recStandardComment."Comment 5" <> '' then begin
                        if StandardCommentLines = '' then
                            StandardCommentLines := '- ' + recStandardComment."Comment 5"
                        else
                            StandardCommentLines := StandardCommentLines + Format(CR) + Format(LF) + '- ' + recStandardComment."Comment 5";
                    end;
                    txtProductGroup := recSalesLine."Item Category Code";
                end else begin
                    Clear(txtComment);
                    recStandardComment.Reset;
                    recStandardComment.SetRange("Product Code", recSalesLine."Item Category Code");
                    recStandardComment.SetFilter(recStandardComment."From Date", '%1|<%2', 0D, recSalesHeader."Posting Date");
                    recStandardComment.SetRange(recStandardComment."Sales Type", recStandardComment."Sales Type"::"All Customer");
                    //recStandardComment.SETRANGE(recStandardComment."Sales Code","Sell-to Customer No.");
                    if recStandardComment.Find('-') then begin
                        if recStandardComment.Comment <> '' then begin
                            if StandardCommentLines = '' then
                                StandardCommentLines := '- ' + recStandardComment.Comment
                            else
                                StandardCommentLines := StandardCommentLines + Format(CR) + Format(LF) + '- ' + recStandardComment.Comment;
                        end;
                        if recStandardComment."Comment 2" <> '' then begin
                            if StandardCommentLines = '' then
                                StandardCommentLines := '- ' + recStandardComment."Comment 2"
                            else
                                StandardCommentLines := StandardCommentLines + Format(CR) + Format(LF) + '- ' + recStandardComment."Comment 2";
                        end;
                        if recStandardComment."Comment 3" <> '' then begin
                            if StandardCommentLines = '' then
                                StandardCommentLines := '- ' + recStandardComment."Comment 3"
                            else
                                StandardCommentLines := StandardCommentLines + Format(CR) + Format(LF) + '- ' + recStandardComment."Comment 3";
                        end;
                        if recStandardComment."Comment 4" <> '' then begin
                            if StandardCommentLines = '' then
                                StandardCommentLines := '- ' + recStandardComment."Comment 4"
                            else
                                StandardCommentLines := StandardCommentLines + Format(CR) + Format(LF) + '- ' + recStandardComment."Comment 4";
                        end;
                        if recStandardComment."Comment 5" <> '' then begin
                            if StandardCommentLines = '' then
                                StandardCommentLines := '- ' + recStandardComment."Comment 5"
                            else
                                StandardCommentLines := StandardCommentLines + Format(CR) + Format(LF) + '- ' + recStandardComment."Comment 5";
                        end;
                        txtProductGroup := recSalesLine."Item Category Code";
                    end else begin
                        recStandardComment.Reset;
                        recStandardComment.SetRange("Product Code", recSalesLine."Item Category Code");
                        recStandardComment.SetFilter(recStandardComment."From Date", '%1|<%2', 0D, recSalesHeader."Posting Date");
                        recStandardComment.SetRange(recStandardComment."Sales Type", recStandardComment."Sales Type"::"Customer Price Group");
                        recStandardComment.SetRange(recStandardComment."Sales Code", recSalesHeader."Customer Price Group");
                        if recStandardComment.Find('-') then begin
                            if recStandardComment.Comment <> '' then begin
                                if StandardCommentLines = '' then
                                    StandardCommentLines := '- ' + recStandardComment.Comment
                                else
                                    StandardCommentLines := StandardCommentLines + Format(CR) + Format(LF) + '- ' + recStandardComment.Comment;
                            end;
                            if recStandardComment."Comment 2" <> '' then begin
                                if StandardCommentLines = '' then
                                    StandardCommentLines := '- ' + recStandardComment."Comment 2"
                                else
                                    StandardCommentLines := StandardCommentLines + Format(CR) + Format(LF) + '- ' + recStandardComment."Comment 2";
                            end;
                            if recStandardComment."Comment 3" <> '' then begin
                                if StandardCommentLines = '' then
                                    StandardCommentLines := '- ' + recStandardComment."Comment 3"
                                else
                                    StandardCommentLines := StandardCommentLines + Format(CR) + Format(LF) + '- ' + recStandardComment."Comment 3";
                            end;
                            if recStandardComment."Comment 4" <> '' then begin
                                if StandardCommentLines = '' then
                                    StandardCommentLines := '- ' + recStandardComment."Comment 4"
                                else
                                    StandardCommentLines := StandardCommentLines + Format(CR) + Format(LF) + '- ' + recStandardComment."Comment 4";
                            end;
                            if recStandardComment."Comment 5" <> '' then begin
                                if StandardCommentLines = '' then
                                    StandardCommentLines := '- ' + recStandardComment."Comment 5"
                                else
                                    StandardCommentLines := StandardCommentLines + Format(CR) + Format(LF) + '- ' + recStandardComment."Comment 5";
                            end;
                            txtProductGroup := recSalesLine."Item Category Code";
                        end;
                    end;
                end;
            end;

        recStandardComment.Reset;
        recStandardComment.SetFilter("Product Code", '');
        recStandardComment.SetFilter(recStandardComment."From Date", '%1|<%2', 0D, recSalesHeader."Posting Date");
        recStandardComment.SetRange(recStandardComment."Sales Type", recStandardComment."Sales Type"::Customer);
        recStandardComment.SetRange(recStandardComment."Sales Code", recSalesHeader."Sell-to Customer No.");
        if recStandardComment.Find('-') then begin
            if recStandardComment.Comment <> '' then begin
                if StandardCommentLines = '' then
                    StandardCommentLines := '- ' + recStandardComment.Comment
                else
                    StandardCommentLines := StandardCommentLines + Format(CR) + Format(LF) + '- ' + recStandardComment.Comment;
            end;
            if recStandardComment."Comment 2" <> '' then begin
                if StandardCommentLines = '' then
                    StandardCommentLines := '- ' + recStandardComment."Comment 2"
                else
                    StandardCommentLines := StandardCommentLines + Format(CR) + Format(LF) + '- ' + recStandardComment."Comment 2";
            end;
            if recStandardComment."Comment 3" <> '' then begin
                if StandardCommentLines = '' then
                    StandardCommentLines := '- ' + recStandardComment."Comment 3"
                else
                    StandardCommentLines := StandardCommentLines + Format(CR) + Format(LF) + '- ' + recStandardComment."Comment 3";
            end;
            if recStandardComment."Comment 4" <> '' then begin
                if StandardCommentLines = '' then
                    StandardCommentLines := '- ' + recStandardComment."Comment 4"
                else
                    StandardCommentLines := StandardCommentLines + Format(CR) + Format(LF) + '- ' + recStandardComment."Comment 4";
            end;
            if recStandardComment."Comment 5" <> '' then begin
                if StandardCommentLines = '' then
                    StandardCommentLines := '- ' + recStandardComment."Comment 5"
                else
                    StandardCommentLines := StandardCommentLines + Format(CR) + Format(LF) + '- ' + recStandardComment."Comment 5";
            end;
        end;

    end;


}
