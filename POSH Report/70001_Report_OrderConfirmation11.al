report 70001 "Order Confirmation11 POSH"
{
    DefaultLayout = RDLC;
    RDLCLayout = './POSH Report/70001_Report_OrderConfirmation11.rdl';
    Caption = 'Order Confirmation';
    PreviewMode = PrintLayout;

    dataset
    {

        dataitem("Sales Header"; "Sales Header")
        {
            CalcFields = "Specifier Name";
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Sales Order';
            column(Companyinformation_Picture; Companyinformation.Picture)
            {
            }
            column(OrderDate_SalesHeader; "Sales Header"."Order Date")
            {
            }
            column(ShippingAgentServiceCode_SalesHeader; "Sales Header"."Shipping Agent Service Code")
            {
            }
            column(SelltoCustomerNo_SalesHeader; "Sales Header"."Sell-to Customer No.")
            {
            }
            column(PostingDate_SalesHeader; "Sales Header"."Posting Date")
            {
            }
            column(FREIGHT; Freight)
            {
            }
            column(LineAmtTot; LineAmtTot)
            {
            }
            column(LOGENTRYAMOUNT; LOGENTRYAMOUNT)
            {
            }
            column(CreditCardNo; CreditCardNo)
            {
            }
            column(CreditCardType; CreditCardType)
            {
            }
            column(OrderNo_SalesInvoiceHeader; "No.")
            {
            }
            column(PackageTrackingNo_SalesInvoiceHeader; "Package Tracking No.")
            {
            }
            column(DueDate_SalesInvoiceHeader; "Due Date")
            {
            }
            column(PostingDate_SalesInvoiceHeader; "Posting Date")
            {
            }
            column(DocumentDate_SalesInvoiceHeader; "Document Date")
            {
            }
            column(SalespersonCode_SalesInvoiceHeader; "Salesperson Code")
            {
            }
            column(OrderDate_SalesInvoiceHeader; "Order Date")
            {
            }
            column(PaymentTermsDescription; PaymentTerms.Description)
            {
            }
            column(PaymentMethodCode; "Sales Header"."Payment Method Code")
            {
            }
            column(ShipmentMethodCode_SalesInvoiceHeader; "Shipment Method Code")
            {
            }
            column(PO_Numbers; "External Document No.")
            {
            }
            column(ShippingAgentCode_SalesInvoiceHeader; "Shipping Agent Code" + ' ' + ShipAccNo)
            {
            }
            column(ShiptoName_SalesInvoiceHeader; "Ship-to Name")
            {
            }
            column(ShiptoAddress_SalesInvoiceHeader; "Ship-to Address")
            {
            }
            column(ShiptoAddress2_SalesInvoiceHeader; "Ship-to Address 2")
            {
            }
            column(ShiptoCity_SalesInvoiceHeader; "Ship-to City")
            {
            }
            column(ShiptoPostCode_SalesInvoiceHeader; "Ship-to Post Code")
            {
            }
            column(ShiptoCounty_SalesInvoiceHeader; "Ship-to County")
            {
            }
            column(ShiptoContact_SalesInvoiceHeader; "Ship-to Contact")
            {
            }
            column(ShiptoCountryRegionCode_SalesInvoiceHeader; "Ship-to Country/Region Code")
            {
            }
            column(SalesHeader_ProjOwner1; "Sales Header"."Proj Owner 1")
            {
            }
            column(SalesHeader_ProjOwner2; "Sales Header"."Proj Owner 2")
            {
            }
            column(recCustomer_Name; "Bill-to Name")
            {
            }
            column(recCustomer_Address; "Bill-to Address")
            {
            }
            column(recCustomer_Address2; "Bill-to Address 2")
            {
            }
            column(recCustomer_City; "Bill-to City")
            {
            }
            column(recCustomer_County; "Bill-to County")
            {
            }
            column(recCustomer_PostCode; "Bill-to Post Code")
            {
            }
            column(recCustomer_BilltoCountryRegionCode; "Bill-to Country/Region Code")
            {
            }
            column(ConfirmTo; "Bill-to Contact")
            {
            }
            column(BillToPhoneNo; BillToPhoneNo)
            {
            }
            column(BillToEmail; BillToEmail)
            {
            }
            column(Ship_ConfirmTo; "Sales Header"."Ship-to Contact")
            {
            }
            column(ShipToPhoneNo; ShipToPhoneNo)
            {
            }
            column(ShipToEmail; ShipToEmail)
            {
            }
            column(ShipAccNo; ShipAccNo)
            {
            }
            column(DocumentType_SalesHeader; "Document Type")
            {
            }
            column(No_SalesHeader; "No.")
            {
            }
            column(PmtTermsDescCaption; PmtTermsDescCaptionLbl)
            {
            }
            column(ShpMethodDescCaption; ShpMethodDescCaptionLbl)
            {
            }
            column(PrepmtPmtTermsDescCaption; PrepmtPmtTermsDescCaptionLbl)
            {
            }
            column(DocDateCaption; DocDateCaptionLbl)
            {
            }
            column(AllowInvDiscCaption; AllowInvDiscCaptionLbl)
            {
            }
            column(HomePageCaption; HomePageCaptionCap)
            {
            }
            column(EmailCaption; EmailCaptionLbl)
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(TexComment1; UPPERCASE(TexComment[1]))
                    {
                    }
                    column(TexComment2; UPPERCASE(TexComment[2]))
                    {
                    }
                    column(QRCode_SalesHeader; EncodedTotals)//SC-TIC-62 Begin
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoEmail; CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo3Picture; CompanyInfo3.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(OrderConfirmation; STRSUBSTNO(Text004, CopyText))
                    {
                    }
                    column(CustAddr1; CustAddr[1])
                    {
                    }
                    column(CustAddr2; CustAddr[2])
                    {
                    }
                    column(CustAddr3; CustAddr[3])
                    {
                    }
                    column(CustAddr4; CustAddr[4])
                    {
                    }
                    column(CustAddr5; CustAddr[5])
                    {
                    }
                    column(CustAddr6; CustAddr[6])
                    {
                    }
                    column(CustAddr7; CustAddr[7])
                    {
                    }
                    column(CustAddr8; CustAddr[8])
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(BilltoCustNo_SalesHeader; "Sales Header"."Bill-to Customer No.")
                    {
                    }
                    column(DocumentDate_SalesHeader; FORMAT("Sales Header"."Document Date", 0, 4))
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(VATRegistrationNo_SalesHeader; "Sales Header"."VAT Registration No.")
                    {
                    }
                    column(ShipmentDate_SalesHeader; FORMAT("Sales Header"."Shipment Date"))
                    {
                    }
                    column(SalesPersonText; SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(No1_SalesHeader; "Sales Header"."No.")
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(YourReference_SalesHeader; "Sales Header"."Your Reference")
                    {
                    }
                    column(PricesIncVAT_SalesHeader; "Sales Header"."Prices Including VAT")
                    {
                    }
                    column(PageCaption; PageCaptionCap)
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PricesInclVAT_SalesHeader; FORMAT("Sales Header"."Prices Including VAT"))
                    {
                    }
                    column(CustTaxIdentificationType; FORMAT(Cust."Tax Identification Type"))
                    {
                    }
                    column(PmtTermsDesc; PaymentTerms.Description)
                    {
                    }
                    column(ShipmentMethodDesc; ShipmentMethod.Description)
                    {
                    }
                    column(PrepmtPmtTermsDesc; PrepmtPaymentTerms.Description)
                    {
                    }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    {
                    }
                    column(GiroNoCaption; GiroNoCaptionLbl)
                    {
                    }
                    column(ReportNameCaption; ReportName)
                    {
                    }
                    column(BankNameCaption; BankNameCaptionLbl)
                    {
                    }
                    column(Specifier_Name; "Sales Header"."Specifier Name")
                    {
                    }
                    column(BankAccNoCaption; BankAccNoCaptionLbl)
                    {
                    }
                    column(ShipmentDateCaption; ShipmentDateCaptionLbl)
                    {
                    }
                    column(OrderNoCaption; OrderNoCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption; TaxIdentTypeCaptionLbl)
                    {
                    }
                    column(BilltoCustNo_SalesHeaderCaption; "Sales Header".FIELDCAPTION("Bill-to Customer No."))
                    {
                    }
                    column(PricesIncVAT_SalesHeaderCaption; "Sales Header".FIELDCAPTION("Prices Including VAT"))
                    {
                    }
                    column(SalesHeader_Project_Name; "Sales Header"."Project Name")
                    {
                    }
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(DimensionLoop1Number; Number)
                        {
                        }
                        column(HdrDimCaption; HdrDimCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF Number = 1 THEN BEGIN
                                IF NOT DimSetEntry1.FIND('-') THEN
                                    CurrReport.BREAK;
                            END ELSE
                                IF NOT Continue THEN
                                    CurrReport.BREAK;

                            CLEAR(DimText);
                            Continue := FALSE;
                            REPEAT
                                OldDimText := DimText;
                                IF DimText = '' THEN
                                    DimText := STRSUBSTNO('%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                ELSE
                                    DimText :=
                                      STRSUBSTNO(
                                        '%1, %2 %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                    DimText := OldDimText;
                                    Continue := TRUE;
                                    EXIT;
                                END;
                            UNTIL DimSetEntry1.NEXT = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF NOT ShowInternalInfo THEN
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem(SalesHeaderComment; "Sales Comment Line")
                    {
                        DataItemLink = "No." = FIELD("No.");
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = FILTER(Order), "Document Line No." = FILTER(0));
                        column(Comment_SalesHeaderComment; SalesHeaderComment.Comment)
                        {
                        }
                        column(HdrCmtBold; (strpos(SalesHeaderComment.Comment, '~') <> 0))
                        {
                        }
                        column(LineNo_SalesHeaderComment; SalesHeaderComment."Line No.")
                        {
                        }
                        column(No_SalesHeaderComment; SalesHeaderComment."No.")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            J := 1;
                            recGLE.RESET;
                            recGLE.SETRANGE("Document Type", "Document Type");
                            recGLE.SETRANGE("No.", "No.");
                            recGLE.SETRANGE("Document Line No.", 0);
                            IF recGLE.FIND('-') THEN BEGIN
                                REPEAT
                                    TexComment[J] := recGLE.Comment;
                                    J += 1;
                                UNTIL (recGLE.NEXT = 0);
                            END;
                            COMPRESSARRAY(TexComment);
                        end;

                        trigger OnPreDataItem()
                        begin
                            // IF J = int THEN
                            //     CurrReport.SHOWOUTPUT := TRUE
                            // ELSE
                            //     CurrReport.SHOWOUTPUT := FALSE;
                        end;
                    }

                    dataitem("Sales Line"; "Sales Line")
                    {
                        DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE("No." = FILTER('<> FREIGHT'), "Outstanding Quantity" = FILTER(<> 0));

                        trigger OnPreDataItem()
                        begin
                            CurrReport.BREAK;
                        end;
                    }
                    dataitem(RoundLoop; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(QuantityShipped_SalesLine; "Sales Line"."Quantity Shipped")
                        {
                        }
                        column(SalesLineLineAmount; SalesLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesLineDesc_SalesLine; "Sales Line".Description)
                        {
                        }
                        //column(NNCSalesLineLineAmt; NNC_SalesLineLineAmt)//SC-TI-53 Begin
                        column(NNCSalesLineLineAmt; TotalAmount)//SC-TI-53 Begin
                        {
                        }


                        column(NNCSalesLineInvDiscAmt; NNC_SalesLineInvDiscAmt)
                        {
                        }
                        column(TotalAmtinc; TotalAmtinc)
                        {
                        }
                        column(LineDiscAmt; LineDiscAmt)
                        {
                        }
                        column(NNC_UnitpriceL; NNC_UnitpriceL)
                        {
                        }
                        column(NNCTotalLCY; NNC_TotalLCY)
                        {
                        }
                        column(NNCTotalExclVAT; NNC_TotalExclVAT)
                        {
                        }
                        column(NNCVATAmt; NNC_VATAmt)
                        {
                        }
                        column(NNCPmtDiscOnVAT; NNC_PmtDiscOnVAT)
                        {
                        }
                        column(NNCTotalInclVAT2; NNC_TotalInclVAT2)
                        {
                        }
                        column(NNCVatAmt2; NNC_VatAmt2)
                        {
                        }
                        column(NNCTotalExclVAT2; NNC_TotalExclVAT2)
                        {
                        }
                        column(VATBaseDisc_SalesHeader; "Sales Header"."VAT Base Discount %")
                        {
                        }
                        column(SalesLine_OutstandingQuantity; "Sales Line"."Outstanding Quantity")
                        {
                        }
                        column(No2_SalesLine; "Sales Line"."No.")
                        {
                        }
                        column(Quantity_SalesLine; "Sales Line".Quantity - "Sales Line"."Quantity Shipped")
                        {
                        }
                        column(UnitofMeasure_SalesLine; "Sales Line"."Unit of Measure")
                        {
                        }
                        column(UnitPrice_SalesLine; "Sales Line"."Unit Price")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(LineDiscount_SalesLine; "Sales Line"."Line Discount %")
                        {
                        }
                        //column(LineAmt_SalesLine; "Sales Line"."Line Amount")//SC-TI-53 Begin
                        column(LineAmt_SalesLine; AmountExclInvDisc)//SC-TI-53 Begin
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(AllowInvDisc_SalesLine; "Sales Line"."Allow Invoice Disc.")
                        {
                        }
                        column(VATIdentifier_SalesLine; "Sales Line"."VAT Identifier")
                        {
                        }
                        column(Type_SalesLine; FORMAT("Sales Line".Type))
                        {
                        }
                        column(LineNo_SalesLine; "Sales Line"."Line No.")
                        {
                        }
                        column(AllwInvDiscformat_SalesLine; FORMAT("Sales Line"."Allow Invoice Disc."))
                        {
                        }
                        column(AsmInfoExistsForLine; AsmInfoExistsForLine)
                        {
                        }
                        column(SalesLineInvDiscountAmt; SalesLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalText; TotalText)
                        {
                        }
                        column(SalesLineLineAmtInvDiscAmt; SalesLine."Line Amount" - SalesLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalExclVATText; TotalExclVATText)
                        {
                        }
                        column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText)
                        {
                        }
                        column(TotalInclVATText; TotalInclVATText)
                        {
                        }
                        column(VATAmt; VATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(LineAmtInvDiscAmtVATAmt; SalesLine."Line Amount" - SalesLine."Inv. Discount Amount" + VATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATDiscountAmt; -VATDiscountAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseAmt; VATBaseAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmtInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(DiscPercentCaption; DiscPercentCaptionLbl)
                        {
                        }
                        column(AmtCaption; AmtCaptionLbl)
                        {
                        }
                        column(InvDiscAmtCaption; InvDiscAmtCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(PmtDiscOnVATCaption; PmtDiscOnVATCaptionLbl)
                        {
                        }
                        column(SalesLineDesc_SalesLineCaption; "Sales Line".FIELDCAPTION(Description))
                        {
                        }
                        column(No_SalesLineCaption; "Sales Line".FIELDCAPTION("No."))
                        {
                        }
                        column(Quantity_SalesLineCaption; "Sales Line".FIELDCAPTION(Quantity))
                        {
                        }
                        column(UnitofMeasure_SalesLineCaption; "Sales Line".FIELDCAPTION("Unit of Measure"))
                        {
                        }
                        column(AllowInvDisc_SalesLineCaption; "Sales Line".FIELDCAPTION("Allow Invoice Disc."))
                        {
                        }
                        column(VATIdentifier_SalesLineCaption; "Sales Line".FIELDCAPTION("VAT Identifier"))
                        {
                        }
                        column(txtStockStatus; txtStockStatus)
                        {
                        }
                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                            column(DimText_DimLoop2; DimText)
                            {
                            }
                            column(LineDimCaption; LineDimCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                IF Number = 1 THEN BEGIN
                                    IF NOT DimSetEntry2.FINDSET THEN
                                        CurrReport.BREAK;
                                END ELSE
                                    IF NOT Continue THEN
                                        CurrReport.BREAK;

                                CLEAR(DimText);
                                Continue := FALSE;
                                REPEAT
                                    OldDimText := DimText;
                                    IF DimText = '' THEN
                                        DimText := STRSUBSTNO('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    ELSE
                                        DimText :=
                                          STRSUBSTNO(
                                            '%1, %2 %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                        DimText := OldDimText;
                                        Continue := TRUE;
                                        EXIT;
                                    END;
                                UNTIL DimSetEntry2.NEXT = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                IF NOT ShowInternalInfo THEN
                                    CurrReport.BREAK;

                                DimSetEntry2.SETRANGE("Dimension Set ID", "Sales Line"."Dimension Set ID");
                            end;
                        }
                        dataitem("Sales Comment Line"; "Sales Comment Line")
                        {
                            DataItemLink = "No." = FIELD("Document No."), "Document Line No." = FIELD("Line No.");
                            DataItemLinkReference = "Sales Line";
                            DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = FILTER(Order));
                            column(No_SalesCommentLine; "Sales Comment Line"."No.")
                            {
                            }
                            column(LineNo_SalesCommentLine; "Sales Comment Line"."Line No.")
                            {
                            }
                            column(Comment_SalesCommentLine; "Sales Comment Line".Comment)
                            {
                            }
                            column(LineCmtBold; (strpos("Sales Comment Line".Comment, '~') <> 0))
                            {
                            }
                            column(DocumentLineNo_SalesCommentLine; "Sales Comment Line"."Document Line No.")
                            {
                            }
                        }
                        dataitem(AsmLoop; "Integer")
                        {
                            column(AsmLineUnitOfMeasureText; GetUnitOfMeasureDescr(AsmLine."Unit of Measure Code"))
                            {
                            }
                            column(AsmLineQuantity; AsmLine.Quantity)
                            {
                            }
                            column(AsmLineDescription; BlanksForIndent + AsmLine.Description)
                            {
                            }
                            column(AsmLineNo; BlanksForIndent + AsmLine."No.")
                            {
                            }
                            column(AsmLineType; AsmLine.Type)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                IF Number = 1 THEN
                                    AsmLine.FINDSET
                                ELSE
                                    AsmLine.NEXT;
                            end;

                            trigger OnPreDataItem()
                            begin
                                IF NOT DisplayAssemblyInformation THEN
                                    CurrReport.BREAK;
                                IF NOT AsmInfoExistsForLine THEN
                                    CurrReport.BREAK;
                                AsmLine.SETRANGE("Document Type", AsmHeader."Document Type");
                                AsmLine.SETRANGE("Document No.", AsmHeader."No.");
                                SETRANGE(Number, 1, AsmLine.COUNT);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF Number = 1 THEN
                                SalesLine.FIND('-')
                            ELSE
                                SalesLine.NEXT;
                            "Sales Line" := SalesLine;
                            //SC-TI-53 Begin
                            AmountExclInvDisc := 0;
                            AmountExclInvDisc := SalesLine."Line Amount";
                            //SC-TI-53 End
                            DiscountAmount := 0;//SC-TI-59 Begin
                            IF DisplayAssemblyInformation THEN
                                AsmInfoExistsForLine := SalesLine.AsmToOrderExists(AsmHeader);
                            IF NOT "Sales Header"."Prices Including VAT" AND
                               (SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Full VAT")
                            THEN
                                SalesLine."Line Amount" := 0;
                            //SC-TI-59 Begin
                            DiscountAmount += ROUND("Sales Line"."Line Discount Amount", 0.001);
                            InvDisc += DiscountAmount;
                            //SC-TI-59 End

                            //SC-TI-53 Begin
                            AmountExclInvDisc := (("Sales Line".Quantity - "Sales Line"."Quantity Shipped") * "Sales Line"."Unit Price") - "Sales Line"."Line Discount Amount";
                            TotalAmount += AmountExclInvDisc;
                            //SC-TI-53 END 


                            IF (SalesLine.Type = SalesLine.Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
                                "Sales Line"."No." := '';

                            NNC_SalesLineLineAmt += SalesLine."Line Amount";
                            NNC_SalesLineInvDiscAmt += SalesLine."Inv. Discount Amount";
                            NNC_TotalLCY := NNC_SalesLineLineAmt - NNC_SalesLineInvDiscAmt;
                            NNC_TotalExclVAT := NNC_TotalLCY;
                            NNC_VATAmt := VATAmount;
                            NNC_TotalInclVAT := NNC_TotalLCY - NNC_VATAmt;
                            NNC_PmtDiscOnVAT := -VATDiscountAmount;
                            NNC_TotalInclVAT2 := TotalAmountInclVAT;
                            NNC_VatAmt2 := VATAmount;
                            NNC_TotalExclVAT2 := VATBaseAmount;
                            decLineDiscountPer := SalesLine."Line Discount %";
                            LineDiscAmt += "Sales Line"."Line Discount Amount";
                            //TotalAmtinc := NNC_SalesLineLineAmt - LineDiscAmt;//SC-TI-53 Begin
                            TotalAmtinc := TotalAmount;//- LineDiscAmt;////SC-TI-53 Begin
                            UnitPrice := SalesLine."Unit Price";
                            RemUnitPrice := UnitPrice * decLineDiscountPer / 100;
                            IF decLineDiscountPer <> 0 THEN
                                NNC_UnitpriceL := UnitPrice - RemUnitPrice
                            ELSE
                                NNC_UnitpriceL := UnitPrice;

                            IF decLineDiscountPer = 100 THEN
                                NNC_UnitpriceL := UnitPrice;

                            //MESSAGE('%1---%2---%3',UnitPrice,decLineDiscountPer,NNC_UnitpriceL);

                            //Commented by Ravi since we don't have this line in our NAV:
                            /*
                            txtStockStatus := '';
                            recLEADTIME.RESET;
                            recLEADTIME.SETRANGE(recLEADTIME.Code,"Sales Line"."Stock Status");
                            IF recLEADTIME.FINDFIRST THEN
                               txtStockStatus := recLEADTIME.Description;
                            */



                        end;

                        trigger OnPostDataItem()
                        begin
                            SalesLine.DELETEALL;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SalesLine.SETFILTER("No.", '<>%1', 'FREIGHT');
                            SalesLine.SETFILTER("Outstanding Quantity", '<>%1', 0);

                            MoreLines := SalesLine.FIND('+');
                            WHILE MoreLines AND (SalesLine.Description = '') AND (SalesLine."Description 2" = '') AND
                                  (SalesLine."No." = '') AND (SalesLine.Quantity = 0) AND
                                  (SalesLine.Amount = 0)
                            DO
                                MoreLines := SalesLine.NEXT(-1) <> 0;
                            IF NOT MoreLines THEN
                                CurrReport.BREAK;
                            SalesLine.SETRANGE("Line No.", 0, SalesLine."Line No.");
                            SETRANGE(Number, 1, SalesLine.COUNT);
                            //CurrReport.CREATETOTALS(SalesLine."Line Amount", SalesLine."Inv. Discount Amount");
                        end;
                    }

                    dataitem(VATCounter; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(VATAmtLineVATBase; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmt; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineLineAmt; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscAmt; VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVAT; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier; VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATPercentCaption; VATPercentCaptionLbl)
                        {
                        }
                        column(VATBaseCaption; VATBaseCaptionLbl)
                        {
                        }
                        column(VATAmtCaption; VATAmtCaptionLbl)
                        {
                        }
                        column(VATAmtSpecCaption; VATAmtSpecCaptionLbl)
                        {
                        }
                        column(InvDiscBaseCaption; InvDiscBaseCaptionLbl)
                        {
                        }
                        column(LineAmtCaption; LineAmtCaptionLbl)
                        {
                        }
                        column(VATIdentCaption; VATIdentCaptionLbl)
                        {
                        }
                        column(TotalCaption; TotalCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF VATAmount = 0 THEN
                                CurrReport.BREAK;
                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                            // CurrReport.CREATETOTALS(
                            //   VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
                            //   VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount");
                        end;
                    }
                    dataitem(VATCounterLCY; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(VALExchRate; VALExchRate)
                        {
                        }
                        column(VALSpecLCYHeader; VALSpecLCYHeader)
                        {
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATAmountLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VAT_VATAmountLine; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATIdentifier_VATAmtLine; VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            VALVATBaseLCY :=
                              VATAmountLine.GetBaseLCY(
                                "Sales Header"."Posting Date", "Sales Header"."Currency Code", "Sales Header"."Currency Factor");
                            VALVATAmountLCY :=
                              VATAmountLine.GetAmountLCY(
                                "Sales Header"."Posting Date", "Sales Header"."Currency Code", "Sales Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF (NOT GLSetup."Print VAT specification in LCY") OR
                               ("Sales Header"."Currency Code" = '') OR
                               (VATAmountLine.GetTotalVATAmount = 0)
                            THEN
                                CurrReport.BREAK;

                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                            // CurrReport.CREATETOTALS(VALVATBaseLCY, VALVATAmountLCY);

                            IF GLSetup."LCY Code" = '' THEN
                                VALSpecLCYHeader := Text007 + Text008
                            ELSE
                                VALSpecLCYHeader := Text007 + FORMAT(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Sales Header"."Posting Date", "Sales Header"."Currency Code", 1);
                            VALExchRate := STRSUBSTNO(Text009, CurrExchRate."Relational Exch. Rate Amount", CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(Total; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    }
                    dataitem(Total2; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                        column(SelltoCustNo_SalesHeader; "Sales Header"."Sell-to Customer No.")
                        {
                        }
                        column(ShipToAddr8; ShipToAddr[8])
                        {
                        }
                        column(ShipToAddr7; ShipToAddr[7])
                        {
                        }
                        column(ShipToAddr6; ShipToAddr[6])
                        {
                        }
                        column(ShipToAddr5; ShipToAddr[5])
                        {
                        }
                        column(ShipToAddr4; ShipToAddr[4])
                        {
                        }
                        column(ShipToAddr3; ShipToAddr[3])
                        {
                        }
                        column(ShipToAddr2; ShipToAddr[2])
                        {
                        }
                        column(ShipToAddr1; ShipToAddr[1])
                        {
                        }
                        column(ShiptoAddrCaption; ShiptoAddrCaptionLbl)
                        {
                        }
                        column(SelltoCustNo_SalesHeaderCaption; "Sales Header".FIELDCAPTION("Sell-to Customer No."))
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            IF NOT ShowShippingAddr THEN
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem(PrepmtLoop; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                        column(PrepmtLineAmount; PrepmtLineAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtInvBufDesc; PrepmtInvBuf.Description)
                        {
                        }
                        column(PrepmtInvBufGLAccNo; PrepmtInvBuf."G/L Account No.")
                        {
                        }
                        column(TotalExclVATText_PrepmtLoop; TotalExclVATText)
                        {
                        }
                        column(PrepmtVATAmtLineVATAmtTxt; PrepmtVATAmountLine.VATAmountText)
                        {
                        }
                        column(TotalInclVATText1_PrepmtLoop; TotalInclVATText)
                        {
                        }
                        column(PrepmtInvBufAmt; PrepmtInvBuf.Amount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmt; PrepmtVATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtInvBufAmtVATAmt; PrepmtInvBuf.Amount + PrepmtVATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtText_VATAmountLine; VATAmountLine.VATAmountText)
                        {
                        }
                        column(PrepmtTotalAmountInclVAT; PrepmtTotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATBaseAmount; PrepmtVATBaseAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(InvDisc; ROUND(InvDisc, 0.01))//SC-TI-59 Begin
                        {
                        }
                        column(DescriptionCaption; DescriptionCaptionLbl)
                        {
                        }
                        column(GLAccNoCaption; GLAccNoCaptionLbl)
                        {
                        }
                        column(PrepaymentSpecCaption; PrepaymentSpecCaptionLbl)
                        {
                        }
                        dataitem(PrepmtDimLoop; "Integer")
                        {
                            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                            column(DimText_PrepmtDimLoop; DimText)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                IF Number = 1 THEN BEGIN
                                    IF NOT TempPrepmtDimSetEntry.FIND('-') THEN
                                        CurrReport.BREAK;
                                END ELSE
                                    IF NOT Continue THEN
                                        CurrReport.BREAK;

                                CLEAR(DimText);
                                Continue := FALSE;
                                REPEAT
                                    OldDimText := DimText;
                                    IF DimText = '' THEN
                                        DimText :=
                                          STRSUBSTNO('%1 %2', TempPrepmtDimSetEntry."Dimension Code", TempPrepmtDimSetEntry."Dimension Value Code")
                                    ELSE
                                        DimText :=
                                          STRSUBSTNO(
                                            '%1, %2 %3', DimText,
                                            TempPrepmtDimSetEntry."Dimension Code", TempPrepmtDimSetEntry."Dimension Value Code");
                                    IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                        DimText := OldDimText;
                                        Continue := TRUE;
                                        EXIT;
                                    END;
                                UNTIL TempPrepmtDimSetEntry.NEXT = 0;
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF Number = 1 THEN BEGIN
                                IF NOT PrepmtInvBuf.FIND('-') THEN
                                    CurrReport.BREAK;
                            END ELSE
                                IF PrepmtInvBuf.NEXT = 0 THEN
                                    CurrReport.BREAK;

                            IF ShowInternalInfo THEN
                                DimMgt.GetDimensionSet(TempPrepmtDimSetEntry, PrepmtInvBuf."Dimension Set ID");

                            IF "Sales Header"."Prices Including VAT" THEN
                                PrepmtLineAmount := PrepmtInvBuf."Amount Incl. VAT"
                            ELSE
                                PrepmtLineAmount := PrepmtInvBuf.Amount;
                        end;

                        // trigger OnPreDataItem()
                        // begin
                        //     CurrReport.CREATETOTALS(
                        //       PrepmtInvBuf.Amount,PrepmtInvBuf."Amount Incl. VAT",
                        //       PrepmtVATAmountLine."Line Amount",PrepmtVATAmountLine."VAT Base",
                        //       PrepmtVATAmountLine."VAT Amount",
                        //       PrepmtLineAmount);
                        // end;
                    }
                    dataitem(PrepmtVATCounter; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(PrepmtVATAmtLineVATAmt; PrepmtVATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmtLineVATBase; PrepmtVATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmtLineLineAmt; PrepmtVATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmtLineVAT; PrepmtVATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(PrepmtVATAmtLineVATIdent; PrepmtVATAmountLine."VAT Identifier")
                        {
                        }
                        column(PrepaymentVATAmtSpecCaption; PrepaymentVATAmtSpecCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            PrepmtVATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            SETRANGE(Number, 1, PrepmtVATAmountLine.COUNT);
                        end;
                    }
                    dataitem(PrepmtTotal; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

                        trigger OnPreDataItem()
                        begin
                            IF NOT PrepmtInvBuf.FIND('-') THEN
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem(Comment; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(NewComment; txtComment[intCommentLine])
                        {
                        }
                        column(CommentGroup; Number)
                        {
                        }
                        column(txtBlod; txtBold)
                        {
                        }
                        trigger OnAfterGetRecord()
                        begin
                            txtBold := StrPos(txtComment[Number], '~') <> 0;
                            intCommentLine := intCommentLine + 1;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SETRANGE(Number, 1, intLineCount);
                            intCommentLine := 0;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                var
                    PrepmtSalesLine: Record "Sales Line" temporary;
                    SalesPost: Codeunit "Sales-Post";
                    TempSalesLine: Record "Sales Line" temporary;
                begin
                    CLEAR(SalesLine);
                    CLEAR(SalesPost);
                    VATAmountLine.DELETEALL;
                    SalesLine.DELETEALL;
                    SalesPost.GetSalesLines("Sales Header", SalesLine, 0);
                    SalesLine.CalcVATAmountLines(0, "Sales Header", SalesLine, VATAmountLine);
                    SalesLine.UpdateVATOnLines(0, "Sales Header", SalesLine, VATAmountLine);
                    VATAmount := VATAmountLine.GetTotalVATAmount;
                    VATBaseAmount := VATAmountLine.GetTotalVATBase;
                    VATDiscountAmount :=
                      VATAmountLine.GetTotalVATDiscount("Sales Header"."Currency Code", "Sales Header"."Prices Including VAT");
                    TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

                    PrepmtInvBuf.DELETEALL;
                    SalesPostPrepmt.GetSalesLines("Sales Header", 0, PrepmtSalesLine);

                    IF NOT PrepmtSalesLine.ISEMPTY THEN BEGIN
                        SalesPostPrepmt.GetSalesLinesToDeduct("Sales Header", TempSalesLine);
                        IF NOT TempSalesLine.ISEMPTY THEN
                            SalesPostPrepmt.CalcVATAmountLines("Sales Header", TempSalesLine, PrepmtVATAmountLineDeduct, 1);
                    END;
                    SalesPostPrepmt.CalcVATAmountLines("Sales Header", PrepmtSalesLine, PrepmtVATAmountLine, 0);
                    IF PrepmtVATAmountLine.FINDSET THEN
                        REPEAT
                            PrepmtVATAmountLineDeduct := PrepmtVATAmountLine;
                            IF PrepmtVATAmountLineDeduct.FIND THEN BEGIN
                                PrepmtVATAmountLine."VAT Base" := PrepmtVATAmountLine."VAT Base" - PrepmtVATAmountLineDeduct."VAT Base";
                                PrepmtVATAmountLine."VAT Amount" := PrepmtVATAmountLine."VAT Amount" - PrepmtVATAmountLineDeduct."VAT Amount";
                                PrepmtVATAmountLine."Amount Including VAT" := PrepmtVATAmountLine."Amount Including VAT" -
                                  PrepmtVATAmountLineDeduct."Amount Including VAT";
                                PrepmtVATAmountLine."Line Amount" := PrepmtVATAmountLine."Line Amount" - PrepmtVATAmountLineDeduct."Line Amount";
                                PrepmtVATAmountLine."Inv. Disc. Base Amount" := PrepmtVATAmountLine."Inv. Disc. Base Amount" -
                                  PrepmtVATAmountLineDeduct."Inv. Disc. Base Amount";
                                PrepmtVATAmountLine."Invoice Discount Amount" := PrepmtVATAmountLine."Invoice Discount Amount" -
                                  PrepmtVATAmountLineDeduct."Invoice Discount Amount";
                                PrepmtVATAmountLine."Calculated VAT Amount" := PrepmtVATAmountLine."Calculated VAT Amount" -
                                  PrepmtVATAmountLineDeduct."Calculated VAT Amount";
                                PrepmtVATAmountLine.MODIFY;
                            END;
                        UNTIL PrepmtVATAmountLine.NEXT = 0;

                    SalesPostPrepmt.UpdateVATOnLines("Sales Header", PrepmtSalesLine, PrepmtVATAmountLine, 0);
                    //  SalesPostPrepmt.BuildInvLineBuffer2("Sales Header", PrepmtSalesLine, 0, PrepmtInvBuf); //DS-vr
                    PrepmtVATAmount := PrepmtVATAmountLine.GetTotalVATAmount;
                    PrepmtVATBaseAmount := PrepmtVATAmountLine.GetTotalVATBase;
                    PrepmtTotalAmountInclVAT := PrepmtVATAmountLine.GetTotalAmountInclVAT;

                    IF Number > 1 THEN BEGIN
                        CopyText := Text003;
                        OutputNo += 1;
                    END;
                    CurrReport.PAGENO := 1;

                    NNC_TotalLCY := 0;
                    NNC_TotalExclVAT := 0;
                    NNC_VATAmt := 0;
                    NNC_TotalInclVAT := 0;
                    NNC_PmtDiscOnVAT := 0;
                    NNC_TotalInclVAT2 := 0;
                    NNC_VatAmt2 := 0;
                    NNC_TotalExclVAT2 := 0;
                    NNC_SalesLineLineAmt := 0;
                    TotalAmount := 0;//SC-TI-53 Begin
                    NNC_SalesLineInvDiscAmt := 0;
                    LineDiscAmt := 0;
                    TotalAmtinc := 0;
                    InvDisc := 0;//SC-TI-59 Begin
                    decLineDiscountPer := 0;
                    UnitPrice := 0;
                    RemUnitPrice := 0;
                    NNC_UnitpriceL := 0;
                end;

                trigger OnPostDataItem()
                begin
                    IF Print THEN
                        SalesCountPrinted.RUN("Sales Header");//"Sales Header"
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := ABS(NoOfCopies) + 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            //SC-TIC-62 Begin 
            var
                Symbology: Enum "Barcode Symbology 2D";
                FontProvider: Interface "Barcode Font Provider 2D";
                TypeHelper: Codeunit "Type Helper";
            //SC-TIC-62 End
            begin
                //SC-TIC-62 Begin
                EncodedTotals := '';
                BarcodeString := "Sales Header"."No.";
                FontProvider := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                Symbology := Enum::"Barcode Symbology 2D"::"QR-Code";

                EncodedTotals := FontProvider.EncodeFont(BarcodeString, Symbology);
                //SC-TIC-62 End
                if "Language Code" <> '' then
                    CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                //Vikaram
                /*
                IF RespCenter.GET("Responsibility Center") THEN BEGIN
                  FormatAddr.RespCenter(CompanyAddr,RespCenter);
                  CompanyInfo."Phone No." := RespCenter."Phone No.";
                  CompanyInfo."Fax No." := RespCenter."Fax No.";

                END ELSE
                  FormatAddr.Company(CompanyAddr,CompanyInfo);
                 */
                CompanyInfo.GET();
                CompanyAddr[1] := CompanyInfo.Name;
                CompanyAddr[2] := CompanyInfo.Address;
                CompanyAddr[3] := CompanyInfo.City + ', ' + CompanyInfo.County + ' ' + CompanyInfo."Post Code";
                CompanyAddr[4] := 'T: ' + CompanyInfo."Phone No.";
                CompanyAddr[5] := 'E: ' + CompanyInfo."E-Mail";
                //Vikaram

                DimSetEntry1.SETRANGE("Dimension Set ID", "Dimension Set ID");

                IF "Salesperson Code" = '' THEN BEGIN
                    CLEAR(SalesPurchPerson);
                    SalesPersonText := '';
                END ELSE BEGIN
                    SalesPurchPerson.GET("Salesperson Code");
                    SalesPersonText := Text000;
                END;
                IF "Your Reference" = '' THEN
                    ReferenceText := ''
                ELSE
                    ReferenceText := FIELDCAPTION("Your Reference");
                IF "VAT Registration No." = '' THEN
                    VATNoText := ''
                ELSE
                    VATNoText := FIELDCAPTION("VAT Registration No.");
                IF "Currency Code" = '' THEN BEGIN
                    GLSetup.TESTFIELD("LCY Code");
                    TotalText := STRSUBSTNO(Text001, GLSetup."LCY Code");
                    TotalInclVATText := STRSUBSTNO(Text002, GLSetup."LCY Code");
                    TotalExclVATText := STRSUBSTNO(Text006, GLSetup."LCY Code");
                END ELSE BEGIN
                    TotalText := STRSUBSTNO(Text001, "Currency Code");
                    TotalInclVATText := STRSUBSTNO(Text002, "Currency Code");
                    TotalExclVATText := STRSUBSTNO(Text006, "Currency Code");
                END;
                FormatAddr.SalesHeaderBillTo(CustAddr, "Sales Header");
                IF NOT Cust.GET("Bill-to Customer No.") THEN
                    CLEAR(Cust);

                IF "Payment Terms Code" = '' THEN
                    PaymentTerms.INIT
                ELSE BEGIN
                    PaymentTerms.GET("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                END;
                IF "Prepmt. Payment Terms Code" = '' THEN
                    PrepmtPaymentTerms.INIT
                ELSE BEGIN
                    PrepmtPaymentTerms.GET("Prepmt. Payment Terms Code");
                    PrepmtPaymentTerms.TranslateDescription(PrepmtPaymentTerms, "Language Code");
                END;
                IF "Prepmt. Payment Terms Code" = '' THEN
                    PrepmtPaymentTerms.INIT
                ELSE BEGIN
                    PrepmtPaymentTerms.GET("Prepmt. Payment Terms Code");
                    PrepmtPaymentTerms.TranslateDescription(PrepmtPaymentTerms, "Language Code");
                END;
                IF "Shipment Method Code" = '' THEN
                    ShipmentMethod.INIT
                ELSE BEGIN
                    ShipmentMethod.GET("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                END;

                FormatAddr.SalesHeaderShipTo(ShipToAddr, ShipToAddr, "Sales Header");
                ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
                FOR i := 1 TO ARRAYLEN(ShipToAddr) DO
                    IF ShipToAddr[i] <> CustAddr[i] THEN
                        ShowShippingAddr := TRUE;

                IF Print THEN BEGIN
                    IF ArchiveDocument THEN
                        ArchiveManagement.StoreSalesDocument("Sales Header", LogInteraction);

                    IF LogInteraction THEN BEGIN
                        CALCFIELDS("No. of Archived Versions");
                        IF "Bill-to Contact No." <> '' THEN
                            SegManagement.LogDocument(
                              3, "No.", "Doc. No. Occurrence",
                              "No. of Archived Versions", DATABASE::Contact, "Bill-to Contact No."
                              , "Salesperson Code", "Campaign No.", "Posting Description", "Opportunity No.")
                        ELSE
                            SegManagement.LogDocument(
                              3, "No.", "Doc. No. Occurrence",
                              "No. of Archived Versions", DATABASE::Customer, "Bill-to Customer No.",
                              "Salesperson Code", "Campaign No.", "Posting Description", "Opportunity No.");
                    END;
                END;



                Freight := 0;
                RecSalesinvLine.RESET;
                RecSalesinvLine.SETRANGE(RecSalesinvLine."Document No.", "No.");
                RecSalesinvLine.SETFILTER(RecSalesinvLine.Type, 'RESOURCE');
                RecSalesinvLine.SETFILTER(RecSalesinvLine."No.", 'FREIGHT');
                IF RecSalesinvLine.FIND('-') THEN BEGIN
                    Freight := RecSalesinvLine.Amount;
                END;

                LineAmtTot := 0;
                RecSalesinvLine.RESET;
                RecSalesinvLine.SETRANGE(RecSalesinvLine."Document No.", "No.");
                //RecSalesinvLine.SETFILTER(RecSalesinvLine.Type, 'Item');
                //RecSalesinvLine.SETFILTER(RecSalesinvLine."No.", '<>%1', '');
                IF RecSalesinvLine.FIND('-') THEN
                    repeat
                        if (RecSalesinvLine."No." <> 'FREIGHT') then
                            LineAmtTot := LineAmtTot + RecSalesinvLine.Amount;
                    Until RecSalesinvLine.Next() = 0;

                //MESSAGE('%1',Freight);
                LOGENTRYAMOUNT := 0;
                CreditCardNo := '';
                CreditCardType := '';
                DOPaymentTransLoEntry.RESET;
                DOPaymentTransLoEntry.SETRANGE(DOPaymentTransLoEntry."Document No.", "No.");
                IF DOPaymentTransLoEntry.FIND('-') THEN BEGIN
                    LOGENTRYAMOUNT += DOPaymentTransLoEntry.Amount;
                    DOPaymentCreditCard.RESET;
                    DOPaymentCreditCard.SETRANGE(DOPaymentCreditCard."No.", DOPaymentTransLoEntry."Credit Card No.");
                    IF DOPaymentCreditCard.FIND('-') THEN BEGIN
                        CreditCardNo := DOPaymentCreditCard."Credit Card Number";
                        CreditCardType := DOPaymentCreditCard.Type;
                    END;
                END;
                //MESSAGE('%1',CreditCardType);

                IF PaymentTerms.GET("Prepmt. Payment Terms Code") THEN
                    BillToPhoneNo := '';
                BillToEmail := '';
                IF BillToContact.GET("Sales Header"."Bill-to Contact No.") THEN BEGIN
                    BillToPhoneNo := BillToContact."Phone No.";
                    BillToEmail := BillToContact."E-Mail";
                END;

                ShipToPhoneNo := '';
                ShipToEmail := '';
                ShipAccNo := '';
                ShiptoAddress.RESET;
                ShiptoAddress.SETRANGE("Customer No.", "Sales Header"."Sell-to Customer No.");
                ShiptoAddress.SETRANGE(ShiptoAddress.Code, "Sales Header"."Ship-to Code");
                IF ShiptoAddress.FINDFIRST THEN BEGIN
                    ShipToPhoneNo := ShiptoAddress."Phone No.";
                    ShipToEmail := ShiptoAddress."E-Mail";
                    ShipAccNo := ShipToAddress."UPS Account No.";
                END ELSE BEGIN
                    IF Contact.GET("Sales Header"."Sell-to Contact No.") THEN
                        ShipToPhoneNo := Contact."Phone No.";
                    ShipToEmail := Contact."E-Mail";
                END;

                //TotalAmount := 0;
                FOR intLineCount := 1 TO 50 DO BEGIN
                    txtComment[intLineCount] := '';
                END;
                intLineCount := 0;
                //txtComment:='';
                txtProductGroup := '';
                recSalesLine.RESET;
                recSalesLine.SETCURRENTKEY("Document Type", "Document No.", "Item Category Code");
                recSalesLine.SETRANGE("Document Type", "Document Type");
                recSalesLine.SETRANGE("Document No.", "No.");
                IF recSalesLine.FIND('-') THEN BEGIN
                    //txtProductGroup:=recSalesLine."Item Category Code";
                    REPEAT
                        IF recSalesLine.Quantity - recSalesLine."Quantity Shipped" > 0 THEN
                            IF (txtProductGroup <> recSalesLine."Item Category Code") AND (recSalesLine."Item Category Code" <> '') THEN BEGIN
                                recStandardComment.RESET;
                                recStandardComment.SETRANGE("Product Code", recSalesLine."Item Category Code");
                                recStandardComment.SETFILTER(recStandardComment."From Date", '%1|<%2', 0D, "Posting Date");
                                recStandardComment.SETRANGE(recStandardComment."Sales Type", recStandardComment."Sales Type"::Customer);
                                recStandardComment.SETRANGE(recStandardComment."Sales Code", "Sell-to Customer No.");
                                //recStandardComment.SETRANGE(Internal,TRUE);
                                IF recStandardComment.FIND('-') THEN BEGIN
                                    IF recStandardComment.Comment <> '' THEN BEGIN
                                        intLineCount := intLineCount + 1;
                                        txtComment[intLineCount] := recStandardComment.Comment;//+' '+recStandardComment."Comment 2";
                                    END;
                                    IF recStandardComment."Comment 2" <> '' THEN BEGIN
                                        intLineCount := intLineCount + 1;
                                        txtComment[intLineCount] := recStandardComment."Comment 2";//+' '+recStandardComment."Comment 2";
                                    END;
                                    IF recStandardComment."Comment 3" <> '' THEN BEGIN
                                        intLineCount := intLineCount + 1;
                                        txtComment[intLineCount] := recStandardComment."Comment 3";//+' '+recStandardComment."Comment 2";
                                    END;
                                    IF recStandardComment."Comment 4" <> '' THEN BEGIN
                                        intLineCount := intLineCount + 1;
                                        txtComment[intLineCount] := recStandardComment."Comment 4";//+' '+recStandardComment."Comment 2";
                                    END;
                                    IF recStandardComment."Comment 5" <> '' THEN BEGIN
                                        intLineCount := intLineCount + 1;
                                        txtComment[intLineCount] := recStandardComment."Comment 5";//+' '+recStandardComment."Comment 2";
                                    END;
                                    txtProductGroup := recSalesLine."Item Category Code";
                                END ELSE BEGIN
                                    CLEAR(txtComment);//Ashwini
                                    recStandardComment.RESET;
                                    recStandardComment.SETRANGE("Product Code", recSalesLine."Item Category Code");
                                    recStandardComment.SETFILTER(recStandardComment."From Date", '%1|<%2', 0D, "Posting Date");
                                    recStandardComment.SETRANGE(recStandardComment."Sales Type", recStandardComment."Sales Type"::"All Customer");
                                    //recStandardComment.SETRANGE(recStandardComment."Sales Code","Sell-to Customer No.");
                                    //recStandardComment.SETRANGE(Internal,TRUE);
                                    IF recStandardComment.FIND('-') THEN BEGIN
                                        IF recStandardComment.Comment <> '' THEN BEGIN
                                            intLineCount := intLineCount + 1;
                                            txtComment[intLineCount] := recStandardComment.Comment;//+' '+recStandardComment."Comment 2";
                                        END;
                                        IF recStandardComment."Comment 2" <> '' THEN BEGIN
                                            intLineCount := intLineCount + 1;
                                            txtComment[intLineCount] := recStandardComment."Comment 2";//+' '+recStandardComment."Comment 2";
                                        END;
                                        IF recStandardComment."Comment 3" <> '' THEN BEGIN
                                            intLineCount := intLineCount + 1;
                                            txtComment[intLineCount] := recStandardComment."Comment 3";//+' '+recStandardComment."Comment 2";
                                        END;
                                        IF recStandardComment."Comment 4" <> '' THEN BEGIN
                                            intLineCount := intLineCount + 1;
                                            txtComment[intLineCount] := recStandardComment."Comment 4";//+' '+recStandardComment."Comment 2";
                                        END;
                                        IF recStandardComment."Comment 5" <> '' THEN BEGIN
                                            intLineCount := intLineCount + 1;
                                            txtComment[intLineCount] := recStandardComment."Comment 5";//+' '+recStandardComment."Comment 2";
                                        END;
                                        txtProductGroup := recSalesLine."Item Category Code";
                                    END ELSE BEGIN
                                        recStandardComment.RESET;
                                        recStandardComment.SETRANGE("Product Code", recSalesLine."Item Category Code");
                                        recStandardComment.SETFILTER(recStandardComment."From Date", '%1|<%2', 0D, "Posting Date");
                                        recStandardComment.SETRANGE(recStandardComment."Sales Type", recStandardComment."Sales Type"::"Customer Price Group");
                                        recStandardComment.SETRANGE(recStandardComment."Sales Code", "Customer Price Group");
                                        //recStandardComment.SETRANGE(Internal,TRUE);
                                        IF recStandardComment.FIND('-') THEN BEGIN
                                            IF recStandardComment.Comment <> '' THEN BEGIN
                                                intLineCount := intLineCount + 1;
                                                txtComment[intLineCount] := recStandardComment.Comment;//+' '+recStandardComment."Comment 2";
                                            END;
                                            IF recStandardComment."Comment 2" <> '' THEN BEGIN
                                                intLineCount := intLineCount + 1;
                                                txtComment[intLineCount] := recStandardComment."Comment 2";//+' '+recStandardComment."Comment 2";
                                            END;
                                            IF recStandardComment."Comment 3" <> '' THEN BEGIN
                                                intLineCount := intLineCount + 1;
                                                txtComment[intLineCount] := recStandardComment."Comment 3";//+' '+recStandardComment."Comment 2";
                                            END;
                                            IF recStandardComment."Comment 4" <> '' THEN BEGIN
                                                intLineCount := intLineCount + 1;
                                                txtComment[intLineCount] := recStandardComment."Comment 4";//+' '+recStandardComment."Comment 2";
                                            END;
                                            IF recStandardComment."Comment 5" <> '' THEN BEGIN
                                                intLineCount := intLineCount + 1;
                                                txtComment[intLineCount] := recStandardComment."Comment 5";//+' '+recStandardComment."Comment 2";
                                            END;
                                            txtProductGroup := recSalesLine."Item Category Code";
                                        END;
                                    END;
                                END;
                            END;
                    UNTIL recSalesLine.NEXT = 0;
                END;

                recStandardComment.RESET;
                recStandardComment.SETFILTER("Product Code", '');
                recStandardComment.SETFILTER(recStandardComment."From Date", '%1|<%2', 0D, "Posting Date");
                recStandardComment.SETRANGE(recStandardComment."Sales Type", recStandardComment."Sales Type"::Customer);
                recStandardComment.SETRANGE(recStandardComment."Sales Code", "Sell-to Customer No.");
                //recStandardComment.SETRANGE(Internal,TRUE);
                IF recStandardComment.FIND('-') THEN BEGIN
                    IF recStandardComment.Comment <> '' THEN BEGIN
                        intLineCount := intLineCount + 1;
                        txtComment[intLineCount] := recStandardComment.Comment;//+' '+recStandardComment."Comment 2";
                    END;
                    IF recStandardComment."Comment 2" <> '' THEN BEGIN
                        intLineCount := intLineCount + 1;
                        txtComment[intLineCount] := recStandardComment."Comment 2";//+' '+recStandardComment."Comment 2";
                    END;
                    IF recStandardComment."Comment 3" <> '' THEN BEGIN
                        intLineCount := intLineCount + 1;
                        txtComment[intLineCount] := recStandardComment."Comment 3";//+' '+recStandardComment."Comment 2";
                    END;
                    IF recStandardComment."Comment 4" <> '' THEN BEGIN
                        intLineCount := intLineCount + 1;
                        txtComment[intLineCount] := recStandardComment."Comment 4";//+' '+recStandardComment."Comment 2";
                    END;
                    IF recStandardComment."Comment 5" <> '' THEN BEGIN
                        intLineCount := intLineCount + 1;
                        txtComment[intLineCount] := recStandardComment."Comment 5";//+' '+recStandardComment."Comment 2";
                    END;
                END;
            end;

            trigger OnPreDataItem()
            begin
                Print := Print OR NOT CurrReport.PREVIEW;


                // IF i = int THEN
                //     CurrReport.SHOWOUTPUT := TRUE
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
                    field(NoOfCopies; NoOfCopies)
                    {
                        Caption = 'No. of Copies';
                        ApplicationArea = all;
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        Caption = 'Show Internal Information';
                        ApplicationArea = all;
                    }
                    field(ArchiveDocument; ArchiveDocument)
                    {
                        Caption = 'Archive Document';
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
                    field(ShowAssemblyComponents; DisplayAssemblyInformation)
                    {
                        Caption = 'Show Assembly Components';
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := FALSE;
        end;

        trigger OnOpenPage()
        begin
            ArchiveDocument := SalesSetup."Archive Orders";
            LogInteraction := SegManagement.FindInteractTmplCode(3) <> '';

            LogInteractionEnable := LogInteraction;
            LogInteraction := FALSE;
            //LogInteractionEnable:=FALSE;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.GET;
        CompanyInfo.GET;
        SalesSetup.GET;

        CASE SalesSetup."Logo Position on Documents" OF
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                BEGIN
                    CompanyInfo3.GET;
                    CompanyInfo3.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Center:
                BEGIN
                    CompanyInfo1.GET;
                    CompanyInfo1.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Right:
                BEGIN
                    CompanyInfo2.GET;
                    CompanyInfo2.CALCFIELDS(Picture);
                END;
        END;


        Companyinformation.GET;
        Companyinformation.CALCFIELDS(Companyinformation.Picture);
    end;

    var
        EncodedTotals: Text;//SC-TIC-62 Begin
        BarcodeString: Text; //SC-TIC-62 Begin
        Text000: Label 'Salesperson';
        Text001: Label 'Total %1';
        Text002: Label 'Total %1 Incl. Tax';
        Text003: Label 'COPY';
        Text004: Label 'Order Confirmation %1';
        PageCaptionCap: Label 'Page %1 of %2';
        Text006: Label 'Total %1 Excl. Tax';
        Companyinformation: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PrepmtPaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        VATAmountLine: Record "VAT Amount Line" temporary;
        PrepmtVATAmountLine: Record "VAT Amount Line" temporary;
        PrepmtVATAmountLineDeduct: Record "VAT Amount Line" temporary;
        SalesLine: Record "Sales Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        TempPrepmtDimSetEntry: Record "Dimension Set Entry" temporary;
        PrepmtInvBuf: Record "Prepayment Inv. Line Buffer" temporary;
        RespCenter: Record "Responsibility Center";
        Language: Codeunit Language;
        CurrExchRate: Record "Currency Exchange Rate";
        AsmHeader: Record "Assembly Header";
        AsmLine: Record "Assembly Line";
        SalesCountPrinted: Codeunit "Sales-Printed";
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        ArchiveManagement: Codeunit ArchiveManagement;
        SalesPostPrepmt: Codeunit "Sales-Post Prepayments";
        DimMgt: Codeunit DimensionManagement;
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        SalesPersonText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        i: Integer;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        Text007: Label 'Tax Amount Specification in ';
        Text008: Label 'Local Currency';
        Text009: Label 'Exchange rate: %1/%2';
        VALExchRate: Text[50];
        PrepmtVATAmount: Decimal;
        PrepmtVATBaseAmount: Decimal;
        PrepmtTotalAmountInclVAT: Decimal;
        PrepmtLineAmount: Decimal;
        OutputNo: Integer;
        NNC_TotalLCY: Decimal;
        NNC_TotalExclVAT: Decimal;
        NNC_VATAmt: Decimal;
        NNC_TotalInclVAT: Decimal;
        NNC_PmtDiscOnVAT: Decimal;
        NNC_TotalInclVAT2: Decimal;
        NNC_VatAmt2: Decimal;
        NNC_TotalExclVAT2: Decimal;
        NNC_SalesLineLineAmt: Decimal;
        //SC-TI-53 Begin
        TotalAmount: Decimal;
        AmountExclInvDisc: Decimal;
        //SC-TI-53 End

        InvDisc: Decimal;//SC-TI-59 Begin
        DiscountAmount: Decimal;//SC-TI-59 Begin
        NNC_SalesLineInvDiscAmt: Decimal;
        Print: Boolean;
        Cust: Record Customer;
        [InDataSet]
        ArchiveDocumentEnable: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        AsmInfoExistsForLine: Boolean;
        PhoneNoCaptionLbl: Label 'Phone No.';
        GiroNoCaptionLbl: Label 'Giro No.';
        BankNameCaptionLbl: Label 'Bank';
        BankAccNoCaptionLbl: Label 'Account No.';
        ShipmentDateCaptionLbl: Label 'Shipment Date';
        OrderNoCaptionLbl: Label 'Order No.';
        TaxIdentTypeCaptionLbl: Label 'Tax Ident. Type';
        HdrDimCaptionLbl: Label 'Header Dimensions';
        UnitPriceCaptionLbl: Label 'Unit Price';
        DiscPercentCaptionLbl: Label 'Discount %';
        AmtCaptionLbl: Label 'Amount';
        InvDiscAmtCaptionLbl: Label 'Invoice Discount Amount';
        SubtotalCaptionLbl: Label 'Subtotal';
        PmtDiscOnVATCaptionLbl: Label 'Payment Discount on Tax';
        LineDimCaptionLbl: Label 'Line Dimensions';
        VATPercentCaptionLbl: Label 'Tax %';
        VATBaseCaptionLbl: Label 'Tax Base';
        VATAmtCaptionLbl: Label 'Tax Amount';
        VATAmtSpecCaptionLbl: Label 'Tax Amount Specification';
        InvDiscBaseCaptionLbl: Label 'Invoice Discount Base Amount';
        LineAmtCaptionLbl: Label 'Line Amount';
        VATIdentCaptionLbl: Label 'Tax Identifier';
        TotalCaptionLbl: Label 'Total';
        ShiptoAddrCaptionLbl: Label 'Ship-to Address';
        DescriptionCaptionLbl: Label 'Description';
        GLAccNoCaptionLbl: Label 'G/L Account No.';
        PrepaymentSpecCaptionLbl: Label 'Prepayment Specification';
        PrepaymentVATAmtSpecCaptionLbl: Label 'Prepayment Tax Amount Specification';
        PmtTermsDescCaptionLbl: Label 'Payment Terms';
        ShpMethodDescCaptionLbl: Label 'Shipment Method';
        PrepmtPmtTermsDescCaptionLbl: Label 'Prepayment Payment Terms';
        DocDateCaptionLbl: Label 'Document Date';
        AllowInvDiscCaptionLbl: Label 'Allow Invoice Discount';
        HomePageCaptionCap: Label 'HomePage';
        EmailCaptionLbl: Label 'E-Mail';
        rECSalesCommentLine: Record "Sales Comment Line";
        COMENT: Text;
        Freight: Decimal;
        LineAmtTot: Decimal;
        CreditCardNo: Text;
        RecSalesinvLine: Record "Sales Line";
        DOPaymentTransLoEntry: Record "DO Payment Trans. Log Entry";
        DOPaymentCreditCard: Record "DO Payment Credit Card";
        LineDiscAmt: Decimal;
        TotalAmtinc: Decimal;
        ReportName: Label 'Sales Order';
        LOGENTRYAMOUNT: Decimal;
        CreditCardType: Text;
        decLineDiscountPer: Decimal;
        UnitPrice: Decimal;
        RemUnitPrice: Decimal;
        NNC_UnitpriceL: Decimal;
        J: Integer;
        cdDocNo: Text;
        int: Integer;
        TexComment: array[10] of Text;
        recGLE: Record "Sales Comment Line";
        lineno: Integer;
        txtStockStatus: Text[50];
        recLEADTIME: Record "Handheld Login";
        BillToContact: Record Contact;
        BillToEmail: Text;
        BillToPhoneNo: Text;
        ShipToContact: Record Contact;
        ShipToPhoneNo: Text;
        ShipToEmail: Text;
        ShiptoAddress: Record "Ship-to Address";
        Customer: Record Customer;
        Contact: Record Contact;
        intLineCount: Integer;
        txtProductGroup: Code[20];
        recStandardComment: Record "Standard Comment";
        txtComment: array[256] of Text[250];
        intCommentLine: Integer;
        recSalesLine: Record "Sales Line";
        txtBold: Boolean;
        ShipAccNo: Text;



    procedure InitializeRequest(NoOfCopiesFrom: Integer; ShowInternalInfoFrom: Boolean; ArchiveDocumentFrom: Boolean; LogInteractionFrom: Boolean; PrintFrom: Boolean; DisplAsmInfo: Boolean)
    begin
        NoOfCopies := NoOfCopiesFrom;
        ShowInternalInfo := ShowInternalInfoFrom;
        ArchiveDocument := ArchiveDocumentFrom;
        LogInteraction := LogInteractionFrom;
        Print := PrintFrom;
        DisplayAssemblyInformation := DisplAsmInfo;
    end;


    procedure GetUnitOfMeasureDescr(UOMCode: Code[10]): Text[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        IF NOT UnitOfMeasure.GET(UOMCode) THEN
            EXIT(UOMCode);
        EXIT(UnitOfMeasure.Description);
    end;


    procedure BlanksForIndent(): Text[10]
    begin
        EXIT(PADSTR('', 2, ' '));
    end;
}

