report 50010 "Purchase Order2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/PurchaseOrder2.rdl';
    Caption = 'Purchase Order';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Buy-from Vendor No.", "Pay-to Vendor No.", "No. Printed";
            column(No_PurchaseHeader; "No.")
            {
            }
            column(CompanyInformation_PhoneNo; Company."Phone No.")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(CompanyAddress1; CompanyAddress[1])
                    {
                    }
                    column(CompanyAddress2; CompanyAddress[2])
                    {
                    }
                    column(CompanyAddress3; CompanyAddress[3])
                    {
                    }
                    column(CompanyAddress4; CompanyAddress[4])
                    {
                    }
                    column(CompanyAddress5; CompanyAddress[5])
                    {
                    }
                    column(CompanyAddress6; CompanyAddress[6])
                    {
                    }
                    column(CopyTxt; CopyTxt)
                    {
                    }
                    column(BuyFromAddress1; BuyFromAddress[1])
                    {
                    }
                    column(BuyFromAddress2; BuyFromAddress[2])
                    {
                    }
                    column(BuyFromAddress3; BuyFromAddress[3])
                    {
                    }
                    column(BuyFromAddress4; BuyFromAddress[4])
                    {
                    }
                    column(BuyFromAddress5; BuyFromAddress[5])
                    {
                    }
                    column(BuyFromAddress6; BuyFromAddress[6])
                    {
                    }
                    column(BuyFromAddress7; BuyFromAddress[7])
                    {
                    }
                    column(ExptRecptDt_PurchaseHeader; "Purchase Header"."Expected Receipt Date")
                    {
                    }
                    column(ShipToAddress1; ShipToAddress[1])
                    {
                    }
                    column(ShipToAddress2; ShipToAddress[2])
                    {
                    }
                    column(ShipToAddress3; ShipToAddress[3])
                    {
                    }
                    column(ShipToAddress4; ShipToAddress[4])
                    {
                    }
                    column(ShipToAddress5; ShipToAddress[5])
                    {
                    }
                    column(ShipToAddress6; ShipToAddress[6])
                    {
                    }
                    column(ShipToAddress7; ShipToAddress[7])
                    {
                    }
                    column(BuyfrVendNo_PurchaseHeader; "Purchase Header"."Buy-from Vendor No.")
                    {
                    }
                    column(YourRef_PurchaseHeader; "Purchase Header"."Your Reference")
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(No1_PurchaseHeader; "Purchase Header"."No.")
                    {
                    }
                    column(OrderDate_PurchaseHeader; "Purchase Header"."Order Date")
                    {
                    }
                    column(CompanyAddress7; CompanyAddress[7])
                    {
                    }
                    column(CompanyAddress8; CompanyAddress[8])
                    {
                    }
                    column(BuyFromAddress8; BuyFromAddress[8])
                    {
                    }
                    column(ShipToAddress8; ShipToAddress[8])
                    {
                    }
                    column(ShipmentMethodDescription; ShipmentMethod.Description)
                    {
                    }
                    column(PaymentTermsDescription; PaymentTerms.Description)
                    {
                    }
                    column(CompanyInformationPhoneNo; CompanyInformation."Phone No.")
                    {
                    }
                    column(CopyNo; CopyNo)
                    {
                    }
                    column(VendTaxIdentificationType; Format(Vend."Tax Identification Type"))
                    {
                    }
                    column(ToCaption; ToCaptionLbl)
                    {
                    }
                    column(ReceiveByCaption; ReceiveByCaptionLbl)
                    {
                    }
                    column(VendorIDCaption; VendorIDCaptionLbl)
                    {
                    }
                    column(ConfirmToCaption; ConfirmToCaptionLbl)
                    {
                    }
                    column(ContactToLbl_CAption; ContactToLbl)
                    {
                    }
                    column(BuyerCaption; BuyerCaptionLbl)
                    {
                    }
                    column(ShipCaption; ShipCaptionLbl)
                    {
                    }
                    column(ToCaption1; ToCaption1Lbl)
                    {
                    }
                    column(PurchOrderCaption; PurchOrderCaptionLbl)
                    {
                    }
                    column(PurchOrderNumCaption; PurchOrderNumCaptionLbl)
                    {
                    }
                    column(PurchOrderDateCaption; PurchOrderDateCaptionLbl)
                    {
                    }
                    column(PageCaption; PageCaptionLbl)
                    {
                    }
                    column(ShipViaCaption; ShipViaCaptionLbl)
                    {
                    }
                    column(TermsCaption; TermsCaptionLbl)
                    {
                    }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption; TaxIdentTypeCaptionLbl)
                    {
                    }
                    column(recLocation_Name; recLocation.Name)
                    {
                    }
                    column(recLocation_Address; recLocation.Address)
                    {
                    }
                    column(recLocation_Address_2; recLocation."Address 2")
                    {
                    }
                    column(recLocation_City; recLocation.City)
                    {
                    }
                    column(recLocation_Post_Code; recLocation."Post Code")
                    {
                    }
                    column(recCountry_Name; recCountry.Name)
                    {
                    }
                    column(CompanyInformation_Picture; CompanyInformation.Picture)
                    {
                    }
                    column(recVendor_Contact; recVendor.Contact)
                    {
                    }
                    column(recVendor_Name; "Purchase Header"."Buy-from Vendor Name")
                    {
                    }
                    column(recVendor_Address; "Purchase Header"."Buy-from Address")
                    {
                    }
                    column(recVendor_Address2; "Purchase Header"."Buy-from Address 2")
                    {
                    }
                    column(recVendor_City; "Purchase Header"."Buy-from City")
                    {
                    }
                    column(recVendor_County; "Purchase Header"."Buy-from County")
                    {
                    }
                    column(recVendor_PostCode; "Purchase Header"."Buy-from Post Code")
                    {
                    }
                    column(recCountry2_Name; recCountry2.Name)
                    {
                    }
                    dataitem("Purchase Line"; "Purchase Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Purchase Header";
                        DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE("Document Type" = CONST(Order), "Outstanding Quantity" = FILTER(<> 0));
                        column(LineNo_PurchaseLine; "Purchase Line"."Line No.")
                        {
                        }
                        column(AmountExclInvDisc; AmountExclInvDisc)
                        {
                        }
                        column(OutstanQty; "Purchase Line"."Outstanding Quantity")
                        {
                        }
                        column(AmountTotal; AmountTotal)
                        {
                        }
                        column(ItemNumberToPrint; ItemNumberToPrint)
                        {
                        }
                        column(UnitofMeasure_PurchaseLine; "Unit of Measure")
                        {
                        }
                        column(PriorityQty; "Purchase Line"."Priority Qty")
                        {
                        }
                        column(PriorityDate; "Purchase Line"."Priority Date")
                        {
                        }
                        column(Quantity_PurchaseLine; Quantity)
                        {
                        }
                        column(UnitPriceToPrint; UnitPriceToPrint)
                        {
                            DecimalPlaces = 2 : 5;
                        }
                        column(Description_PurchaseLine; Description)
                        {
                        }
                        column(VendorItemNo_PurchaseLine; "Purchase Line"."Vendor Item No.")
                        {
                        }
                        column(ExpectedReceiptDate_PurchaseLine; "Purchase Line"."Expected Receipt Date")
                        {
                        }
                        column(Description2_PurchaseLine; "Purchase Line"."Description 2")
                        {
                        }
                        column(QuantityReceived_PurchaseLine; "Purchase Line"."Quantity Received")
                        {
                        }
                        column(PrintFooter; PrintFooter)
                        {
                        }
                        column(InvDiscountAmt_PurchaseLine; "Inv. Discount Amount")
                        {
                        }
                        column(TaxAmount; TaxAmount)
                        {
                        }
                        column(LineAmtTaxAmtInvDiscountAmt; "Line Amount" + TaxAmount - "Inv. Discount Amount")
                        {
                        }
                        column(TotalTaxLabel; TotalTaxLabel)
                        {
                        }
                        column(BreakdownTitle; BreakdownTitle)
                        {
                        }
                        column(BreakdownLabel1; BreakdownLabel[1])
                        {
                        }
                        column(BreakdownAmt1; BreakdownAmt[1])
                        {
                        }
                        column(BreakdownLabel2; BreakdownLabel[2])
                        {
                        }
                        column(BreakdownAmt2; BreakdownAmt[2])
                        {
                        }
                        column(BreakdownLabel3; BreakdownLabel[3])
                        {
                        }
                        column(BreakdownAmt3; BreakdownAmt[3])
                        {
                        }
                        column(BreakdownAmt4; BreakdownAmt[4])
                        {
                        }
                        column(BreakdownLabel4; BreakdownLabel[4])
                        {
                        }
                        column(DocumentNo_PurchaseLine; "Document No.")
                        {
                        }
                        column(ItemNoCaption; ItemNoCaptionLbl)
                        {
                        }
                        column(UnitCaption; UnitCaptionLbl)
                        {
                        }
                        column(DescriptionCaption; DescriptionCaptionLbl)
                        {
                        }
                        column(QuantityCaption; QuantityCaptionLbl)
                        {
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(TotalPriceCaption; TotalPriceCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(InvDiscCaption; InvDiscCaptionLbl)
                        {
                        }
                        column(TotalCaption; TotalCaptionLbl)
                        {
                        }
                        column(ExpectedDateCap; ExpectedDateCap)
                        {
                        }
                        column(ReceivedCap; ReceivedCap)
                        {
                        }
                        column(LineDiscountAmt; "Purchase Line"."Line Discount Amount")
                        {
                        }
                        dataitem("Purch. Comment Line"; "Purch. Comment Line")
                        {
                            DataItemLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("Document No."), "Document Line No." = FIELD("Line No.");
                            DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.");
                            column(Comment_PurchCommentLine; "Purch. Comment Line".Comment)
                            {
                            }
                            column(DocumentLineNo_PurchCommentLine; "Purch. Comment Line"."Document Line No.")
                            {
                            }
                            column(LineCmtBold; (strpos("Purch. Comment Line".Comment, '~') <> 0))
                            {
                            }
                        }

                        trigger OnAfterGetRecord()
                        begin
                            OnLineNumber := OnLineNumber + 1;

                            if ("Purchase Header"."Tax Area Code" <> '') and not UseExternalTaxEngine then
                                SalesTaxCalc.AddPurchLine("Purchase Line");

                            if "Vendor Item No." <> '' then
                                ItemNumberToPrint := "Vendor Item No."
                            else
                                ItemNumberToPrint := "No.";

                            if Type.AsInteger() = 0 then begin
                                ItemNumberToPrint := '';
                                "Unit of Measure" := '';
                                "Line Amount" := 0;
                                "Inv. Discount Amount" := 0;
                                Quantity := 0;
                            end;

                            AmountExclInvDisc := "Line Amount";
                            AmountTotal := AmountTotal + "Line Amount";//Ashwini
                            if Quantity = 0 then
                                UnitPriceToPrint := 0 // so it won't print
                            else
                                UnitPriceToPrint := Round(AmountExclInvDisc / Quantity, 0.00001);

                            if OnLineNumber = NumberOfLines then begin
                                PrintFooter := true;

                                if "Purchase Header"."Tax Area Code" <> '' then begin
                                    if UseExternalTaxEngine then
                                        SalesTaxCalc.CallExternalTaxEngineForPurch("Purchase Header", true)
                                    else
                                        SalesTaxCalc.EndSalesTaxCalculation(UseDate);
                                    SalesTaxCalc.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);
                                    BrkIdx := 0;
                                    PrevPrintOrder := 0;
                                    PrevTaxPercent := 0;
                                    TaxAmount := 0;
                                    with TempSalesTaxAmtLine do begin
                                        Reset;
                                        SetCurrentKey("Print Order", "Tax Area Code for Key", "Tax Jurisdiction Code");
                                        if Find('-') then
                                            repeat
                                                if ("Print Order" = 0) or
                                                   ("Print Order" <> PrevPrintOrder) or
                                                   ("Tax %" <> PrevTaxPercent)
                                                then begin
                                                    BrkIdx := BrkIdx + 1;
                                                    if BrkIdx > 1 then begin
                                                        if TaxArea."Country/Region" = TaxArea."Country/Region"::CA then
                                                            BreakdownTitle := Text006
                                                        else
                                                            BreakdownTitle := Text003;
                                                    end;
                                                    if BrkIdx > ArrayLen(BreakdownAmt) then begin
                                                        BrkIdx := BrkIdx - 1;
                                                        BreakdownLabel[BrkIdx] := Text004;
                                                    end else
                                                        BreakdownLabel[BrkIdx] := StrSubstNo("Print Description", "Tax %");
                                                end;
                                                BreakdownAmt[BrkIdx] := BreakdownAmt[BrkIdx] + "Tax Amount";
                                                TaxAmount := TaxAmount + "Tax Amount";
                                            until Next = 0;
                                    end;
                                    if BrkIdx = 1 then begin
                                        Clear(BreakdownLabel);
                                        Clear(BreakdownAmt);
                                    end;
                                end;
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.CreateTotals(AmountExclInvDisc, "Line Amount", "Inv. Discount Amount");
                            NumberOfLines := Count;
                            OnLineNumber := 0;
                            PrintFooter := false;
                        end;
                    }

                    dataitem(PurchHeaderComments; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(CmtLine; Number)
                        {
                        }
                        column(CommentText; txtComment[Number])
                        {
                        }
                        column(HdrCmtBold; (strpos(txtComment[Number], '~') <> 0))
                        {
                        }
                        trigger OnAfterGetRecord()
                        begin

                        end;

                        trigger OnPreDataItem()
                        var
                            PLine: Record "Purchase Line";
                            TempItemCat: Record "Item Category" temporary;
                        begin
                            intLineCount := 0;
                            TempPurchHeaderComments.DeleteAll();
                            TempItemCat.DeleteAll();

                            PLine.Reset();
                            PLine.SetRange("Document Type", "Purchase Header"."Document Type");
                            PLine.SetRange("Document No.", "Purchase Header"."No.");
                            PLine.SetRange(Type, PLine.Type::Item);
                            PLine.SetFilter(Quantity, '<>0');
                            if PLine.FindSet() then
                                repeat
                                    if PLine."Item Category Code" <> '' then begin
                                        TempItemCat.Init();
                                        TempItemCat.Code := PLine."Item Category Code";
                                        if not TempItemCat.Insert() then;
                                    end;
                                until PLine.Next() = 0;

                            TempItemCat.Reset();
                            if TempItemCat.FindSet() then
                                repeat
                                    recStandardComment.RESET;
                                    recStandardComment.SetRange("Product Code", TempItemCat.Code);
                                    recStandardComment.SETFILTER(recStandardComment."From Date", '%1|<%2', 0D, "Purchase Header"."Posting Date");
                                    recStandardComment.SETRANGE(recStandardComment."Sales Type", recStandardComment."Sales Type"::Vendor);
                                    recStandardComment.SETRANGE(recStandardComment."Sales Code", "Purchase Header"."Buy-from Vendor No.");
                                    IF recStandardComment.FIND('-') THEN BEGIN
                                        IF recStandardComment.Comment <> '' THEN BEGIN
                                            intLineCount := intLineCount + 1;
                                            txtComment[intLineCount] := recStandardComment.Comment;
                                        END;
                                        IF recStandardComment."Comment 2" <> '' THEN BEGIN
                                            intLineCount := intLineCount + 1;
                                            txtComment[intLineCount] := recStandardComment."Comment 2";
                                        END;
                                        IF recStandardComment."Comment 3" <> '' THEN BEGIN
                                            intLineCount := intLineCount + 1;
                                            txtComment[intLineCount] := recStandardComment."Comment 3";
                                        END;
                                        IF recStandardComment."Comment 4" <> '' THEN BEGIN
                                            intLineCount := intLineCount + 1;
                                            txtComment[intLineCount] := recStandardComment."Comment 4";
                                        END;
                                        IF recStandardComment."Comment 5" <> '' THEN BEGIN
                                            intLineCount := intLineCount + 1;
                                            txtComment[intLineCount] := recStandardComment."Comment 5";
                                        END;
                                    END;

                                    recStandardComment.RESET;
                                    recStandardComment.SetRange("Product Code", TempItemCat.Code);
                                    recStandardComment.SETFILTER(recStandardComment."From Date", '%1|<%2', 0D, "Purchase Header"."Posting Date");
                                    recStandardComment.SETRANGE(recStandardComment."Sales Type", recStandardComment."Sales Type"::"All Vendor");
                                    recStandardComment.SETRANGE(recStandardComment."Sales Code");
                                    IF recStandardComment.FIND('-') THEN BEGIN
                                        IF recStandardComment.Comment <> '' THEN BEGIN
                                            intLineCount := intLineCount + 1;
                                            txtComment[intLineCount] := recStandardComment.Comment;
                                        END;
                                        IF recStandardComment."Comment 2" <> '' THEN BEGIN
                                            intLineCount := intLineCount + 1;
                                            txtComment[intLineCount] := recStandardComment."Comment 2";
                                        END;
                                        IF recStandardComment."Comment 3" <> '' THEN BEGIN
                                            intLineCount := intLineCount + 1;
                                            txtComment[intLineCount] := recStandardComment."Comment 3";
                                        END;
                                        IF recStandardComment."Comment 4" <> '' THEN BEGIN
                                            intLineCount := intLineCount + 1;
                                            txtComment[intLineCount] := recStandardComment."Comment 4";
                                        END;
                                        IF recStandardComment."Comment 5" <> '' THEN BEGIN
                                            intLineCount := intLineCount + 1;
                                            txtComment[intLineCount] := recStandardComment."Comment 5";
                                        END;
                                    END;
                                until TempItemCat.Next() = 0;

                            recPurchHeaderComments.SETRANGE(recPurchHeaderComments."Document Type", "Purchase Header"."Document Type");
                            recPurchHeaderComments.SETRANGE(recPurchHeaderComments."No.", "Purchase Header"."No.");
                            recPurchHeaderComments.SETRANGE(recPurchHeaderComments."Document Line No.", 0);
                            if recPurchHeaderComments.FindSet() then
                                repeat
                                    intLineCount += 1;
                                    txtComment[intLineCount] := recPurchHeaderComments.Comment;
                                until recPurchHeaderComments.Next() = 0;

                            recStandardComment.RESET;
                            recStandardComment.SetRange("Product Code", '');
                            recStandardComment.SETFILTER(recStandardComment."From Date", '%1|<%2', 0D, "Purchase Header"."Posting Date");
                            recStandardComment.SETRANGE(recStandardComment."Sales Type", recStandardComment."Sales Type"::Vendor);
                            recStandardComment.SETRANGE(recStandardComment."Sales Code", "Purchase Header"."Buy-from Vendor No.");
                            IF recStandardComment.FIND('-') THEN BEGIN
                                IF recStandardComment.Comment <> '' THEN BEGIN
                                    intLineCount := intLineCount + 1;
                                    txtComment[intLineCount] := recStandardComment.Comment;
                                END;
                                IF recStandardComment."Comment 2" <> '' THEN BEGIN
                                    intLineCount := intLineCount + 1;
                                    txtComment[intLineCount] := recStandardComment."Comment 2";
                                END;
                                IF recStandardComment."Comment 3" <> '' THEN BEGIN
                                    intLineCount := intLineCount + 1;
                                    txtComment[intLineCount] := recStandardComment."Comment 3";
                                END;
                                IF recStandardComment."Comment 4" <> '' THEN BEGIN
                                    intLineCount := intLineCount + 1;
                                    txtComment[intLineCount] := recStandardComment."Comment 4";
                                END;
                                IF recStandardComment."Comment 5" <> '' THEN BEGIN
                                    intLineCount := intLineCount + 1;
                                    txtComment[intLineCount] := recStandardComment."Comment 5";
                                END;
                            END;

                            recStandardComment.RESET;
                            recStandardComment.SetRange("Product Code", '');
                            recStandardComment.SETFILTER(recStandardComment."From Date", '%1|<%2', 0D, "Purchase Header"."Posting Date");
                            recStandardComment.SETRANGE(recStandardComment."Sales Type", recStandardComment."Sales Type"::"All Vendor");
                            recStandardComment.SETRANGE(recStandardComment."Sales Code");
                            IF recStandardComment.FIND('-') THEN BEGIN
                                IF recStandardComment.Comment <> '' THEN BEGIN
                                    intLineCount := intLineCount + 1;
                                    txtComment[intLineCount] := recStandardComment.Comment;
                                END;
                                IF recStandardComment."Comment 2" <> '' THEN BEGIN
                                    intLineCount := intLineCount + 1;
                                    txtComment[intLineCount] := recStandardComment."Comment 2";
                                END;
                                IF recStandardComment."Comment 3" <> '' THEN BEGIN
                                    intLineCount := intLineCount + 1;
                                    txtComment[intLineCount] := recStandardComment."Comment 3";
                                END;
                                IF recStandardComment."Comment 4" <> '' THEN BEGIN
                                    intLineCount := intLineCount + 1;
                                    txtComment[intLineCount] := recStandardComment."Comment 4";
                                END;
                                IF recStandardComment."Comment 5" <> '' THEN BEGIN
                                    intLineCount := intLineCount + 1;
                                    txtComment[intLineCount] := recStandardComment."Comment 5";
                                END;
                            END;

                            SETRANGE(Number, 1, intLineCount);
                        end;
                    }

                }

                trigger OnAfterGetRecord()
                begin
                    CurrReport.PageNo := 1;
                    if CopyNo = NoLoops then begin
                        if not CurrReport.Preview then
                            PurchasePrinted.Run("Purchase Header");
                        CurrReport.Break;
                    end;
                    CopyNo := CopyNo + 1;
                    if CopyNo = 1 then // Original
                        Clear(CopyTxt)
                    else
                        CopyTxt := Text000;
                    TaxAmount := 0;

                    Clear(BreakdownTitle);
                    Clear(BreakdownLabel);
                    Clear(BreakdownAmt);
                    TotalTaxLabel := Text008;
                    TaxRegNo := '';
                    TaxRegLabel := '';
                    if "Purchase Header"."Tax Area Code" <> '' then begin
                        TaxArea.Get("Purchase Header"."Tax Area Code");
                        case TaxArea."Country/Region" of
                            TaxArea."Country/Region"::US:
                                TotalTaxLabel := Text005;
                            TaxArea."Country/Region"::CA:
                                begin
                                    TotalTaxLabel := Text007;
                                    TaxRegNo := CompanyInformation."VAT Registration No.";
                                    TaxRegLabel := CompanyInformation.FieldCaption("VAT Registration No.");
                                end;
                        end;
                        UseExternalTaxEngine := TaxArea."Use External Tax Engine";
                        SalesTaxCalc.StartSalesTaxCalculation;
                    end;
                    //VK-SPDSPL
                    if "Purchase Header"."Location Code" <> '' then
                        recLocation.Get("Purchase Header"."Location Code");
                    if recLocation."Country/Region Code" <> '' then
                        recCountry.Get(recLocation."Country/Region Code");
                    AmountTotal := 0;//Ashwini
                end;

                trigger OnPreDataItem()
                begin
                    NoLoops := 1 + Abs(NoCopies);
                    if NoLoops <= 0 then
                        NoLoops := 1;
                    CopyNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Company.Get();

                if PrintCompany then begin
                    if RespCenter.Get("Responsibility Center") then begin
                        FormatAddress.RespCenter(CompanyAddress, RespCenter);
                        CompanyInformation."Phone No." := RespCenter."Phone No.";
                        CompanyInformation."Fax No." := RespCenter."Fax No.";
                    end;
                end;

                if "Language Code" <> '' then
                    CurrReport.Language := Language.GetLanguageID("Language Code");

                //VK-SPDSPL

                recVendor.Get("Purchase Header"."Buy-from Vendor No.");
                if ("Buy-from Country/Region Code" <> '') and ("Buy-from Country/Region Code" <> 'US') then
                    recCountry2.Get("Buy-from Country/Region Code");


                //VK-SPDSPL

                if "Purchaser Code" = '' then
                    Clear(SalesPurchPerson)
                else
                    SalesPurchPerson.Get("Purchaser Code");

                if "Payment Terms Code" = '' then
                    Clear(PaymentTerms)
                else
                    PaymentTerms.Get("Payment Terms Code");

                if "Shipment Method Code" = '' then
                    Clear(ShipmentMethod)
                else
                    ShipmentMethod.Get("Shipment Method Code");

                FormatAddress.PurchHeaderBuyFrom(BuyFromAddress, "Purchase Header");
                FormatAddress.PurchHeaderShipTo(ShipToAddress, "Purchase Header");

                if not CurrReport.Preview then begin
                    if ArchiveDocument then
                        ArchiveManagement.StorePurchDocument("Purchase Header", LogInteraction);

                    if LogInteraction then begin
                        CalcFields("No. of Archived Versions");
                        SegManagement.LogDocument(
                          13, "No.", "Doc. No. Occurrence", "No. of Archived Versions", DATABASE::Vendor, "Buy-from Vendor No.",
                          "Purchaser Code", '', "Posting Description", '');
                    end;
                end;

                if "Posting Date" <> 0D then
                    UseDate := "Posting Date"
                else
                    UseDate := WorkDate;
            end;

            trigger OnPreDataItem()
            begin
                Company.Get();

                PrintCompany := true;//VK SPDSPL-23-01-15
                if PrintCompany then
                    FormatAddress.Company(CompanyAddress, CompanyInformation)
                else
                    Clear(CompanyAddress);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NumberOfCopies; NoCopies)
                    {
                        Caption = 'Number of Copies';
                        ApplicationArea = all;
                    }
                    field(PrintCompanyAddress; PrintCompany)
                    {
                        Caption = 'Print Company Address';
                        ApplicationArea = all;
                    }
                    field(ArchiveDocument; ArchiveDocument)
                    {
                        Caption = 'Archive Document';
                        Enabled = ArchiveDocumentEnable;
                        ApplicationArea = all;

                        trigger OnValidate()
                        begin
                            if not ArchiveDocument then
                                LogInteraction := false;
                        end;
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ApplicationArea = all;

                        trigger OnValidate()
                        begin
                            if LogInteraction then
                                ArchiveDocument := ArchiveDocumentEnable;
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
            ArchiveDocumentEnable := true;
        end;

        trigger OnOpenPage()
        begin
            ArchiveDocument := ArchiveManagement.PurchaseDocArchiveGranule;
            LogInteraction := SegManagement.FindInteractTmplCode(13) <> '';

            ArchiveDocumentEnable := ArchiveDocument;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInformation.Get('');
        CompanyInformation.CalcFields(CompanyInformation.Picture);
    end;

    var
        UnitPriceToPrint: Decimal;
        AmountExclInvDisc: Decimal;
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        RespCenter: Record "Responsibility Center";
        recPurchHeaderComments: Record "Purch. Comment Line";
        TempPurchHeaderComments: Record "Purch. Comment Line" temporary;
        recStandardComment: Record "Standard Comment";
        intLineCount: Integer;
        txtComment: array[256] of Text[250];
        Language: Codeunit Language;
        TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
        TaxArea: Record "Tax Area";
        Vend: Record Vendor;
        CompanyAddress: array[8] of Text[50];
        BuyFromAddress: array[8] of Text[50];
        ShipToAddress: array[8] of Text[50];
        CopyTxt: Text[10];
        ItemNumberToPrint: Text[20];
        PrintCompany: Boolean;
        PrintFooter: Boolean;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        PurchasePrinted: Codeunit "Purch.Header-Printed";
        FormatAddress: Codeunit "Format Address";
        SalesTaxCalc: Codeunit "Sales Tax Calculate";
        ArchiveManagement: Codeunit ArchiveManagement;
        SegManagement: Codeunit SegManagement;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        TaxAmount: Decimal;
        TaxRegNo: Text[30];
        TaxRegLabel: Text[30];
        TotalTaxLabel: Text[30];
        BreakdownTitle: Text[30];
        BreakdownLabel: array[4] of Text[30];
        BreakdownAmt: array[4] of Decimal;
        BrkIdx: Integer;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
        UseDate: Date;
        Text000: Label 'COPY';
        Text003: Label 'Sales Tax Breakdown:';
        Text004: Label 'Other Taxes';
        Text005: Label 'Total Sales Tax:';
        Text006: Label 'Tax Breakdown:';
        Text007: Label 'Total Tax:';
        Text008: Label 'Tax:';
        UseExternalTaxEngine: Boolean;
        [InDataSet]
        ArchiveDocumentEnable: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        ToCaptionLbl: Label 'Vendor :';
        ReceiveByCaptionLbl: Label 'Receive By';
        VendorIDCaptionLbl: Label 'Vendor ID';
        ConfirmToCaptionLbl: Label 'Confirm To';
        BuyerCaptionLbl: Label 'Buyer';
        ShipCaptionLbl: Label 'Ship';
        ToCaption1Lbl: Label 'To:';
        PurchOrderCaptionLbl: Label 'PURCHASE ORDER';
        PurchOrderNumCaptionLbl: Label 'P.O. Number:';
        PurchOrderDateCaptionLbl: Label 'Order Date:';
        PageCaptionLbl: Label 'Page:';
        ShipViaCaptionLbl: Label 'Ship Via';
        TermsCaptionLbl: Label 'Terms';
        PhoneNoCaptionLbl: Label 'Phone No.';
        TaxIdentTypeCaptionLbl: Label 'Tax Ident. Type';
        ItemNoCaptionLbl: Label 'Code';
        UnitCaptionLbl: Label 'Unit';
        DescriptionCaptionLbl: Label 'Item';
        QuantityCaptionLbl: Label 'Ordered';
        UnitPriceCaptionLbl: Label 'Unit Price';
        TotalPriceCaptionLbl: Label 'Total Price';
        SubtotalCaptionLbl: Label 'Subtotal:';
        InvDiscCaptionLbl: Label 'Invoice Discount:';
        TotalCaptionLbl: Label 'Total:';
        "-----VK------": Integer;
        recLocation: Record Location;
        recCountry: Record "Country/Region";
        ExpectedDateCap: Label 'Expected Date';
        ReceivedCap: Label 'Received';
        recVendor: Record Vendor;
        recCountry2: Record "Country/Region";
        Company: Record "Company Information";
        ContactToLbl: Label 'Contact To.';
        AmountTotal: Decimal;
}

