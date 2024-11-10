report 50016 "Purchase Order2-Updated1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50016_Report_PurchaseOrder2Updated1.rdlc';
    Caption = 'Purchase Order';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Buy-from Vendor No.", "Pay-to Vendor No.", "No. Printed";
            column(txtComment1; txtComment[1])
            {
            }
            column(txtComment2; txtComment[2])
            {
            }
            column(txtComment3; txtComment[3])
            {
            }
            column(txtComment4; txtComment[4])
            {
            }
            column(txtComment5; txtComment[5])
            {
            }
            column(txtComment6; txtComment[6])
            {
            }
            column(txtComment7; txtComment[7])
            {
            }
            column(txtComment8; txtComment[8])
            {
            }
            column(txtComment9; txtComment[9])
            {
            }
            column(txtComment10; txtComment[10])
            {
            }
            column(CompanyName; recCompany.Name)
            {
            }
            column(No_PurchaseHeader; "No.")
            {
            }
            column(ShiptoAddress2_PurchaseHeader; "Purchase Header"."Ship-to Address 2")
            {
            }
            column(Countect_Name; venCountect)
            {
            }
            column(ShiptoAddress_PurchaseHeader; "Purchase Header"."Ship-to Address")
            {
            }
            column(ShiptoName_PurchaseHeader; "Purchase Header"."Ship-to Name")
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
                    column(ShipToCounty; "Purchase Header"."Ship-to County")
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
                    column(Ship_To_Countect; "Purchase Header"."Ship-to Contact")
                    {
                    }
                    column(VendContact; "Purchase Header"."Buy-from Contact")
                    {
                    }
                    column(AssignedUserID_PurchaseHeader; txtPurchaseName)
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
                    column(VendTaxIdentificationType; FORMAT(Vend."Tax Identification Type"))
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
                    column(BuyerCaption; BuyerCaptionLbl)
                    {
                    }
                    column(confirmtoCap; confirmtoCap)
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
                        DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE("Document Type" = CONST(Order));
                        column(LineNo_PurchaseLine; "Purchase Line"."Line No.")
                        {
                        }
                        column(txtvendoeItem; txtvendoeItem)
                        {
                        }
                        column(AmountExclInvDisc; AmountExclInvDisc)
                        {
                        }
                        column(ItemNumberToPrint; ItemNumberToPrint)
                        {
                        }
                        column(UnitofMeasure_PurchaseLine; "Unit of Measure")
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
                        dataitem("Purch. Comment Line"; "Purch. Comment Line")
                        {
                            DataItemLink = "No." = FIELD("Document No."), "Document Line No." = FIELD("Line No.");
                            DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.");
                            column(Comment_PurchCommentLine; "Purch. Comment Line".Comment)
                            {
                            }
                        }

                        trigger OnAfterGetRecord()
                        begin
                            recItemVendor.RESET;
                            recItemVendor.SETRANGE(recItemVendor."Vendor No.", "Purchase Line"."Buy-from Vendor No.");
                            recItemVendor.SETRANGE(recItemVendor."Item No.", "Purchase Line"."No.");
                            IF recItemVendor.FIND('-') THEN
                                txtvendoeItem := recItemVendor."Vendor Item No."
                            ELSE
                                txtvendoeItem := '';

                            OnLineNumber := OnLineNumber + 1;

                            IF ("Purchase Header"."Tax Area Code" <> '') AND NOT UseExternalTaxEngine THEN
                                SalesTaxCalc.AddPurchLine("Purchase Line");

                            IF "Vendor Item No." <> '' THEN
                                ItemNumberToPrint := "Vendor Item No."
                            ELSE
                                ItemNumberToPrint := "No.";

                            IF Type = 0 THEN BEGIN
                                ItemNumberToPrint := '';
                                "Unit of Measure" := '';
                                "Line Amount" := 0;
                                "Inv. Discount Amount" := 0;
                                Quantity := 0;
                            END;

                            AmountExclInvDisc := "Line Amount";

                            IF Quantity = 0 THEN
                                UnitPriceToPrint := 0 // so it won't print
                            ELSE
                                UnitPriceToPrint := ROUND(AmountExclInvDisc / Quantity, 0.01);

                            IF OnLineNumber = NumberOfLines THEN BEGIN
                                PrintFooter := TRUE;

                                IF "Purchase Header"."Tax Area Code" <> '' THEN BEGIN
                                    IF UseExternalTaxEngine THEN
                                        SalesTaxCalc.CallExternalTaxEngineForPurch("Purchase Header", TRUE)
                                    ELSE
                                        SalesTaxCalc.EndSalesTaxCalculation(UseDate);
                                    SalesTaxCalc.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);
                                    BrkIdx := 0;
                                    PrevPrintOrder := 0;
                                    PrevTaxPercent := 0;
                                    TaxAmount := 0;
                                    WITH TempSalesTaxAmtLine DO BEGIN
                                        RESET;
                                        SETCURRENTKEY("Print Order", "Tax Area Code for Key", "Tax Jurisdiction Code");
                                        IF FIND('-') THEN
                                            REPEAT
                                                IF ("Print Order" = 0) OR
                                                   ("Print Order" <> PrevPrintOrder) OR
                                                   ("Tax %" <> PrevTaxPercent)
                                                THEN BEGIN
                                                    BrkIdx := BrkIdx + 1;
                                                    IF BrkIdx > 1 THEN BEGIN
                                                        IF TaxArea."Country/Region" = TaxArea."Country/Region"::CA THEN
                                                            BreakdownTitle := Text006
                                                        ELSE
                                                            BreakdownTitle := Text003;
                                                    END;
                                                    IF BrkIdx > ARRAYLEN(BreakdownAmt) THEN BEGIN
                                                        BrkIdx := BrkIdx - 1;
                                                        BreakdownLabel[BrkIdx] := Text004;
                                                    END ELSE
                                                        BreakdownLabel[BrkIdx] := STRSUBSTNO("Print Description", "Tax %");
                                                END;
                                                BreakdownAmt[BrkIdx] := BreakdownAmt[BrkIdx] + "Tax Amount";
                                                TaxAmount := TaxAmount + "Tax Amount";
                                            UNTIL NEXT = 0;
                                    END;
                                    IF BrkIdx = 1 THEN BEGIN
                                        CLEAR(BreakdownLabel);
                                        CLEAR(BreakdownAmt);
                                    END;
                                END;
                            END;
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.CREATETOTALS(AmountExclInvDisc, "Line Amount", "Inv. Discount Amount");
                            NumberOfLines := COUNT;
                            OnLineNumber := 0;
                            PrintFooter := FALSE;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    CurrReport.PAGENO := 1;
                    IF CopyNo = NoLoops THEN BEGIN
                        IF NOT CurrReport.PREVIEW THEN
                            PurchasePrinted.RUN("Purchase Header");
                        CurrReport.BREAK;
                    END;
                    CopyNo := CopyNo + 1;
                    IF CopyNo = 1 THEN // Original
                        CLEAR(CopyTxt)
                    ELSE
                        CopyTxt := Text000;
                    TaxAmount := 0;

                    CLEAR(BreakdownTitle);
                    CLEAR(BreakdownLabel);
                    CLEAR(BreakdownAmt);
                    TotalTaxLabel := Text008;
                    TaxRegNo := '';
                    TaxRegLabel := '';
                    IF "Purchase Header"."Tax Area Code" <> '' THEN BEGIN
                        TaxArea.GET("Purchase Header"."Tax Area Code");
                        CASE TaxArea."Country/Region" OF
                            TaxArea."Country/Region"::US:
                                TotalTaxLabel := Text005;
                            TaxArea."Country/Region"::CA:
                                BEGIN
                                    TotalTaxLabel := Text007;
                                    TaxRegNo := CompanyInformation."VAT Registration No.";
                                    TaxRegLabel := CompanyInformation.FIELDCAPTION("VAT Registration No.");
                                END;
                        END;
                        UseExternalTaxEngine := TaxArea."Use External Tax Engine";
                        SalesTaxCalc.StartSalesTaxCalculation;
                    END;
                    //VK-SPDSPL
                    IF "Purchase Header"."Location Code" <> '' THEN
                        recLocation.GET("Purchase Header"."Location Code");
                    IF recLocation."Country/Region Code" <> '' THEN
                        recCountry.GET(recLocation."Country/Region Code");
                end;

                trigger OnPreDataItem()
                begin
                    NoLoops := 1 + ABS(NoCopies);
                    IF NoLoops <= 0 THEN
                        NoLoops := 1;
                    CopyNo := 0;

                    recVendor.GET("Purchase Header"."Buy-from Vendor No.");
                    venCountect := recVendor.Contact;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ////
                FOR intLineCount := 1 TO 50 DO BEGIN
                    txtComment[intLineCount] := '';
                END;
                intLineCount := 0;

                recPurchCommentLine.RESET;
                recPurchCommentLine.SETRANGE("Document Type", recPurchCommentLine."Document Type"::Order);
                recPurchCommentLine.SETRANGE("Document Line No.", 0);
                recPurchCommentLine.SETRANGE(recPurchCommentLine."No.", "No.");
                IF recPurchCommentLine.FIND('-') THEN BEGIN
                    REPEAT
                        IF recPurchCommentLine.Comment <> '' THEN BEGIN
                            intLineCount := intLineCount + 1;
                            txtComment[intLineCount] := recPurchCommentLine.Comment;
                        END;
                    UNTIL recPurchCommentLine.NEXT = 0;
                END;
                // MESSAGE('%1 %2','Text1: '+txtComment[1],'Text2: '+txtComment[2]);


                ///



                //SPD-ANI  //
                recVend.RESET;
                recVend.SETRANGE(recVend."No.", "Buy-from Vendor No.");
                IF recVend.FIND('-') THEN
                    VendContact := recVend.Contact;
                //SPD-ANI

                txtPurchaseName := '';
                recPurchaser.RESET;
                recPurchaser.SETRANGE(recPurchaser.Code, "Purchase Header"."Purchaser Code");
                IF recPurchaser.FIND('-') THEN
                    txtPurchaseName := recPurchaser.Name;

                IF PrintCompany THEN BEGIN
                    IF RespCenter.GET("Responsibility Center") THEN BEGIN
                        FormatAddress.RespCenter(CompanyAddress, RespCenter);
                        CompanyInformation."Phone No." := RespCenter."Phone No.";
                        CompanyInformation."Fax No." := RespCenter."Fax No.";
                    END;
                END;
                if "Language Code" <> '' then
                    CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                //VK-SPDSPL

                recVendor.GET("Purchase Header"."Buy-from Vendor No.");
                IF ("Buy-from Country/Region Code" <> '') AND ("Buy-from Country/Region Code" <> 'US') THEN
                    recCountry2.GET("Buy-from Country/Region Code");


                //VK-SPDSPL

                IF "Purchaser Code" = '' THEN
                    CLEAR(SalesPurchPerson)
                ELSE
                    SalesPurchPerson.GET("Purchaser Code");

                IF "Payment Terms Code" = '' THEN
                    CLEAR(PaymentTerms)
                ELSE
                    PaymentTerms.GET("Payment Terms Code");

                IF "Shipment Method Code" = '' THEN
                    CLEAR(ShipmentMethod)
                ELSE
                    ShipmentMethod.GET("Shipment Method Code");

                FormatAddress.PurchHeaderBuyFrom(BuyFromAddress, "Purchase Header");
                FormatAddress.PurchHeaderShipTo(ShipToAddress, "Purchase Header");

                IF NOT CurrReport.PREVIEW THEN BEGIN
                    IF ArchiveDocument THEN
                        ArchiveManagement.StorePurchDocument("Purchase Header", LogInteraction);

                    IF LogInteraction THEN BEGIN
                        CALCFIELDS("No. of Archived Versions");
                        SegManagement.LogDocument(
                          13, "No.", "Doc. No. Occurrence", "No. of Archived Versions", DATABASE::Vendor, "Buy-from Vendor No.",
                          "Purchaser Code", '', "Posting Description", '');
                    END;
                END;

                IF "Posting Date" <> 0D THEN
                    UseDate := "Posting Date"
                ELSE
                    UseDate := WORKDATE;
            end;

            trigger OnPreDataItem()
            begin
                PrintCompany := TRUE;//VK SPDSPL-23-01-15
                IF PrintCompany THEN
                    FormatAddress.Company(CompanyAddress, CompanyInformation)
                ELSE
                    CLEAR(CompanyAddress);
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
                            IF NOT ArchiveDocument THEN
                                LogInteraction := FALSE;
                        end;
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ApplicationArea = all;

                        trigger OnValidate()
                        begin
                            IF LogInteraction THEN
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
            LogInteractionEnable := TRUE;
            ArchiveDocumentEnable := TRUE;
        end;

        trigger OnOpenPage()
        var
            DocumentType: Enum "Interaction Log Entry Document Type";
        begin
            ArchiveDocument := ArchiveManagement.PurchaseDocArchiveGranule;
            LogInteraction := SegManagement.FindInteractionTemplateCode(DocumentType::"Purch. Ord.") <> '';

            ArchiveDocumentEnable := ArchiveDocument;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInformation.GET('');
        CompanyInformation.CALCFIELDS(CompanyInformation.Picture);
        recCompany.GET;
    end;

    var
        UnitPriceToPrint: Decimal;
        AmountExclInvDisc: Decimal;
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        RespCenter: Record "Responsibility Center";
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

        ArchiveDocumentEnable: Boolean;

        LogInteractionEnable: Boolean;
        ToCaptionLbl: Label 'Vendor :';
        ReceiveByCaptionLbl: Label 'Receive By';
        VendorIDCaptionLbl: Label 'Vendor ID';
        ConfirmToCaptionLbl: Label 'Contact To';
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
        confirmtoCap: Label 'Confirm To';
        venCountect: Text[30];
        recItemVendor: Record "Item Vendor";
        txtvendoeItem: Text[30];
        recVend: Record Vendor;
        VendContact: Text[100];
        recCompany: Record "Company Information";
        txtPurchaseName: Text[50];
        recPurchaser: Record "Salesperson/Purchaser";
        recPurchComment: Record "Purch. Comment Line";
        CommentHeader: Text[250];
        HeaderCommentList: array[10] of Text[250];
        HC: array[10] of Text;
        i: Integer;
        intLineCount: Integer;
        intCommentLine: Integer;
        txtComment: array[255] of Text[255];
        recPurchCommentLine: Record "Purch. Comment Line";
}

