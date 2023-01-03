report 50012 "Manufacturing Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50012_Report_ManufacturingOrder.rdlc';
    Caption = 'Sales Order';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Sell-to Customer No.", "Bill-to Customer No.", "Ship-to Code", "No. Printed";
            RequestFilterHeading = 'Sales Order';
            column(No_SalesHeader; "No.")
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE("Document Type" = CONST(Order));
                dataitem(SalesLineComments; "Sales Comment Line")
                {
                    DataItemLink = "No." = FIELD("Document No."), "Document Line No." = FIELD("Line No.");
                    DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = CONST(Order), "Print On Order Confirmation" = CONST(True));

                    trigger OnAfterGetRecord()
                    begin
                        WITH TempSalesLine DO BEGIN
                            INIT;
                            "Document Type" := "Sales Header"."Document Type";
                            "Document No." := "Sales Header"."No.";
                            "Line No." := HighestLineNo + 10;
                            HighestLineNo := "Line No.";
                        END;
                        IF STRLEN(Comment) <= MAXSTRLEN(TempSalesLine.Description) THEN BEGIN
                            TempSalesLine.Description := Comment;
                            TempSalesLine."Description 2" := '';
                        END ELSE BEGIN
                            SpacePointer := MAXSTRLEN(TempSalesLine.Description) + 1;
                            WHILE (SpacePointer > 1) AND (Comment[SpacePointer] <> ' ') DO
                                SpacePointer := SpacePointer - 1;
                            IF SpacePointer = 1 THEN
                                SpacePointer := MAXSTRLEN(TempSalesLine.Description) + 1;
                            TempSalesLine.Description := COPYSTR(Comment, 1, SpacePointer - 1);
                            TempSalesLine."Description 2" := COPYSTR(COPYSTR(Comment, SpacePointer + 1), 1, MAXSTRLEN(TempSalesLine."Description 2"));
                        END;
                        TempSalesLine.INSERT;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    TempSalesLine := "Sales Line";
                    TempSalesLine.INSERT;
                    TempSalesLineAsm := "Sales Line";
                    TempSalesLineAsm.INSERT;

                    HighestLineNo := "Line No.";
                    IF ("Sales Header"."Tax Area Code" <> '') AND NOT UseExternalTaxEngine THEN
                        SalesTaxCalc.AddSalesLine(TempSalesLine);
                end;

                trigger OnPostDataItem()
                begin
                    IF "Sales Header"."Tax Area Code" <> '' THEN BEGIN
                        IF UseExternalTaxEngine THEN
                            SalesTaxCalc.CallExternalTaxEngineForSales("Sales Header", TRUE)
                        ELSE
                            SalesTaxCalc.EndSalesTaxCalculation(UseDate);
                        SalesTaxCalc.DistTaxOverSalesLines(TempSalesLine);
                        SalesTaxCalc.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);
                        BrkIdx := 0;
                        PrevPrintOrder := 0;
                        PrevTaxPercent := 0;
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
                                UNTIL NEXT = 0;
                        END;
                        IF BrkIdx = 1 THEN BEGIN
                            CLEAR(BreakdownLabel);
                            CLEAR(BreakdownAmt);
                        END;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    TempSalesLine.RESET;
                    TempSalesLine.DELETEALL;
                    TempSalesLineAsm.RESET;
                    TempSalesLineAsm.DELETEALL;
                end;
            }
            dataitem("Sales Comment Line"; "Sales Comment Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = CONST(Order), "Print On Order Confirmation" = CONST(True), "Document Line No." = CONST(0));

                trigger OnAfterGetRecord()
                begin
                    WITH TempSalesLine DO BEGIN
                        INIT;
                        "Document Type" := "Sales Header"."Document Type";
                        "Document No." := "Sales Header"."No.";
                        "Line No." := HighestLineNo + 1000;
                        HighestLineNo := "Line No.";
                    END;
                    IF STRLEN(Comment) <= MAXSTRLEN(TempSalesLine.Description) THEN BEGIN
                        TempSalesLine.Description := Comment;
                        TempSalesLine."Description 2" := '';
                    END ELSE BEGIN
                        SpacePointer := MAXSTRLEN(TempSalesLine.Description) + 1;
                        WHILE (SpacePointer > 1) AND (Comment[SpacePointer] <> ' ') DO
                            SpacePointer := SpacePointer - 1;
                        IF SpacePointer = 1 THEN
                            SpacePointer := MAXSTRLEN(TempSalesLine.Description) + 1;
                        TempSalesLine.Description := COPYSTR(Comment, 1, SpacePointer - 1);
                        TempSalesLine."Description 2" := COPYSTR(COPYSTR(Comment, SpacePointer + 1), 1, MAXSTRLEN(TempSalesLine."Description 2"));
                    END;
                    TempSalesLine.INSERT;
                end;

                trigger OnPreDataItem()
                begin
                    WITH TempSalesLine DO BEGIN
                        INIT;
                        "Document Type" := "Sales Header"."Document Type";
                        "Document No." := "Sales Header"."No.";
                        "Line No." := HighestLineNo + 1000;
                        HighestLineNo := "Line No.";
                    END;
                    TempSalesLine.INSERT;
                end;
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfoPicture; CompanyInfo3.Picture)
                    {
                    }
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
                    column(CompanyInformation_Name; CompanyInformation.Name)
                    {
                    }
                    column(CompanyInformation_Address; CompanyInformation.Address)
                    {
                    }
                    column(CompanyInformation_Address_2; CompanyInformation."Address 2")
                    {
                    }
                    column(CompanyInformation_City; CompanyInformation.City)
                    {
                    }
                    column(CompanyInformatio_PostCode; CompanyInformation."Post Code")
                    {
                    }
                    column(CompanyInformation_County; CompanyInformation.County)
                    {
                    }
                    column(CompanyInformation_Phone; CompanyInformation."Phone No.")
                    {
                    }
                    column(CompanyInformation_Country; CompanyInformation."Country/Region Code")
                    {
                    }
                    column(CompanyInformation_Fax; CompanyInformation."Fax No.")
                    {
                    }
                    column(CompanyInformation_EMail; CompanyInformation."E-Mail")
                    {
                    }
                    column(CompanyInformation_HomePage; CompanyInformation."Home Page")
                    {
                    }
                    column(CopyTxt; CopyTxt)
                    {
                    }
                    column(BillToAddress1; BillToAddress[1])
                    {
                    }
                    column(BillToAddress2; BillToAddress[2])
                    {
                    }
                    column(BillToAddress3; BillToAddress[3])
                    {
                    }
                    column(BillToAddress4; BillToAddress[4])
                    {
                    }
                    column(BillToAddress5; BillToAddress[5])
                    {
                    }
                    column(BillToAddress6; BillToAddress[6])
                    {
                    }
                    column(BillToAddress7; BillToAddress[7])
                    {
                    }
                    column(recCustomer_Name; recCustomer.Name)
                    {
                    }
                    column(recCustomer_Address; recCustomer.Address)
                    {
                    }
                    column(recCustomer_Addres2; recCustomer."Address 2")
                    {
                    }
                    column(recCustomer_City; recCustomer.City)
                    {
                    }
                    column(recCustomer_PostCode; recCustomer."Post Code")
                    {
                    }
                    column(recCustomer_County; recCustomer.County)
                    {
                    }
                    column(recCustomer_Country; recCustomer."Country/Region Code")
                    {
                    }
                    column(recCustomer_Contact; recCustomer.Contact)
                    {
                    }
                    column(recCustomer_Balance; recCustomer.Balance)
                    {
                    }
                    column(CreditLimit; recCustomer."Credit Limit (LCY)")
                    {
                    }
                    column(recCountry_Name; recCountry.Name)
                    {
                    }
                    column(recCountry2_Name; recCountry2.Name)
                    {
                    }
                    column(ShptDate_SalesHeader; "Sales Header"."Shipment Date")
                    {
                    }
                    column(SalesHeaderRequestedDeliveryDate; "Sales Header"."Requested Delivery Date")
                    {
                    }
                    column(Shipping_Agent_code; "Sales Header"."Shipping Agent Code")
                    {
                    }
                    column(Shipping_Agent_Service_Code; "Sales Header"."Shipping Agent Service Code")
                    {
                    }
                    column(Shipment_Method_Code; "Sales Header"."Shipment Method Code")
                    {
                    }
                    column(PMT_TERM; recPmtTerm.Description)
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
                    column(ShiptoCode; "Sales Header"."Ship-to Code")
                    {
                    }
                    column(Ship_to_Name; "Sales Header"."Ship-to Name")
                    {
                    }
                    column(Ship_to_Address; "Sales Header"."Ship-to Address")
                    {
                    }
                    column(Ship_to_Address2; "Sales Header"."Ship-to Address 2")
                    {
                    }
                    column(Ship_to_City; "Sales Header"."Ship-to City")
                    {
                    }
                    column(Ship_to_Contact; "Sales Header"."Ship-to Contact")
                    {
                    }
                    column(Ship_to_PostCode; "Sales Header"."Ship-to Post Code")
                    {
                    }
                    column(Ship_to_County; "Sales Header"."Ship-to County")
                    {
                    }
                    column(Ship_to_Country; "Sales Header"."Ship-to Country/Region Code")
                    {
                    }
                    column(BilltoCustNo_SalesHeader; "Sales Header"."Bill-to Customer No.")
                    {
                    }
                    column(External_Document_No; "Sales Header"."External Document No.")
                    {
                    }
                    column(YourRef_SalesHeader; "Sales Header"."Your Reference")
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(OrderDate_SalesHeader; "Sales Header"."Order Date")
                    {
                    }
                    column(CompanyAddress7; CompanyAddress[7])
                    {
                    }
                    column(CompanyAddress8; CompanyAddress[8])
                    {
                    }
                    column(BillToAddress8; BillToAddress[8])
                    {
                    }
                    column(ShipToAddress8; ShipToAddress[8])
                    {
                    }
                    column(ShipmentMethodDesc; ShipmentMethod.Description)
                    {
                    }
                    column(PaymentTermsDesc; PaymentTerms.Description)
                    {
                    }
                    column(TaxRegLabel; TaxRegLabel)
                    {
                    }
                    column(TaxRegNo; TaxRegNo)
                    {
                    }
                    column(CopyNo; CopyNo)
                    {
                    }
                    column(CustTaxIdentificationType; FORMAT(Cust."Tax Identification Type"))
                    {
                    }
                    column(SoldCaption; SoldCaptionLbl)
                    {
                    }
                    column(ToCaption; ToCaptionLbl)
                    {
                    }
                    column(ShipDateCaption; ShipDateCaptionLbl)
                    {
                    }
                    column(CustomerIDCaption; CustomerIDCaptionLbl)
                    {
                    }
                    column(PONumberCaption; PONumberCaptionLbl)
                    {
                    }
                    column(SalesPersonCaption; SalesPersonCaptionLbl)
                    {
                    }
                    column(ShipCaption; ShipCaptionLbl)
                    {
                    }
                    column(SalesOrderCaption; SalesOrderCaptionLbl)
                    {
                    }
                    column(SalesOrderNumberCaption; SalesOrderNumberCaptionLbl)
                    {
                    }
                    column(SalesOrderDateCaption; SalesOrderDateCaptionLbl)
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
                    column(PODateCaption; PODateCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption; TaxIdentTypeCaptionLbl)
                    {
                    }
                    column(ConfirmToCap; ConfirmToCap)
                    {
                    }
                    column(SalesHeader_Location_Code; "Sales Header"."Location Code")
                    {
                    }
                    column(Whse_Cap; Whse_Cap)
                    {
                    }
                    dataitem(SalesLine; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(PrintFooter; PrintFooter)
                        {
                        }
                        column(AmountExclInvDisc; AmountExclInvDisc)
                        {
                        }
                        column(TempSalesLineNo; TempSalesLine."No.")
                        {
                        }
                        column(TempSalesLineUOM; TempSalesLine."Unit of Measure")
                        {
                        }
                        column(TempSalesLineQuantity; TempSalesLine.Quantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(UnitPriceToPrint; UnitPriceToPrint)
                        {
                            DecimalPlaces = 2 : 5;
                        }
                        column(TempSalesLineDesc; TempSalesLine.Description)
                        {
                        }
                        column(TempSalesLineDesc2; TempSalesLine."Description 2")
                        {
                        }
                        column(TempSalesLineDocumentNo; TempSalesLine."Document No.")
                        {
                        }
                        column(TempSalesLineLineNo; TempSalesLine."Line No.")
                        {
                        }
                        column(AsmInfoExistsForLine; AsmInfoExistsForLine)
                        {
                        }
                        column(TaxLiable; TaxLiable)
                        {
                        }
                        column(TempSalesLineLineAmtTaxLiable; TempSalesLine."Line Amount" - TaxLiable)
                        {
                        }
                        column(TempSalesLineInvDiscAmt; TempSalesLine."Inv. Discount Amount")
                        {
                        }
                        column(TaxAmount; TaxAmount)
                        {
                        }
                        column(TempSalesLineLineAmtTaxAmtInvDiscAmt; TempSalesLine."Line Amount" + TaxAmount - TempSalesLine."Inv. Discount Amount")
                        {
                        }
                        column(BreakdownTitle; BreakdownTitle)
                        {
                        }
                        column(BreakdownLabel1; BreakdownLabel[1])
                        {
                        }
                        column(BreakdownLabel2; BreakdownLabel[2])
                        {
                        }
                        column(BreakdownLabel3; BreakdownLabel[3])
                        {
                        }
                        column(BreakdownAmt1; BreakdownAmt[1])
                        {
                        }
                        column(BreakdownAmt2; BreakdownAmt[2])
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
                        column(TotalTaxLabel; TotalTaxLabel)
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
                        column(Description2Caption; Description2CaptionLbl)
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
                        column(InvoiceDiscountCaption; InvoiceDiscountCaptionLbl)
                        {
                        }
                        column(TotalCaption; TotalCaptionLbl)
                        {
                        }
                        column(AmtSubjecttoSalesTaxCptn; AmtSubjecttoSalesTaxCptnLbl)
                        {
                        }
                        column(AmtExemptfromSalesTaxCptn; AmtExemptfromSalesTaxCptnLbl)
                        {
                        }
                        column(CustBalanceDueLCY_5_; CustBalanceDueLCY[5])
                        {
                            AutoFormatType = 1;
                        }
                        column(CustBalanceDueLCY_4_; CustBalanceDueLCY[4])
                        {
                            AutoFormatType = 1;
                        }
                        column(CustBalanceDueLCY_3_; CustBalanceDueLCY[3])
                        {
                            AutoFormatType = 1;
                        }
                        column(CustBalanceDueLCY_2_; CustBalanceDueLCY[2])
                        {
                            AutoFormatType = 1;
                        }
                        column(CustBalanceDueLCY_1_; CustBalanceDueLCY[1])
                        {
                            AutoFormatType = 1;
                        }
                        column(CustBalanceDueLCY_5__Control25; CustBalanceDueLCY_5__Control25CaptionLbl)
                        {
                            AutoFormatType = 1;
                        }
                        column(CustBalanceDueLCY_4__Control26; CustBalanceDueLCY_4__Control26CaptionLbl)
                        {
                            AutoFormatType = 1;
                        }
                        column(CustBalanceDueLCY_3__Control27; CustBalanceDueLCY_3__Control27CaptionLbl)
                        {
                            AutoFormatType = 1;
                        }
                        column(CustBalanceDueLCY_2__Control28; CustBalanceDueLCY_2__Control28CaptionLbl)
                        {
                            AutoFormatType = 1;
                        }
                        column(CustBalanceDueLCY_1__Control29; CustBalanceDueLCY_1__Control29CaptionLbl)
                        {
                            AutoFormatType = 1;
                        }
                        column(CustBalanceDueLCY_5__Control37; CustBalanceDueLCY[5])
                        {
                            AutoFormatType = 1;
                        }
                        column(CustBalanceDueLCY_4__Control38; CustBalanceDueLCY[4])
                        {
                            AutoFormatType = 1;
                        }
                        column(CustBalanceDueLCY_3__Control39; CustBalanceDueLCY[3])
                        {
                            AutoFormatType = 1;
                        }
                        column(CustBalanceDueLCY_2__Control40; CustBalanceDueLCY[2])
                        {
                            AutoFormatType = 1;
                        }
                        column(CustBalanceDueLCY_1__Control41; CustBalanceDueLCY[1])
                        {
                            AutoFormatType = 1;
                        }
                        column(OPEN_ORDER; OPEN_ORDER)
                        {
                        }
                        column(recCustomer_CreditLimit; recCustomer."Credit Limit (LCY)")
                        {
                        }
                        column(CrLimitCap; CrLimitCap)
                        {
                        }
                        column(ApprovedByCap; ApprovedByCap)
                        {
                        }
                        column(PackedByCap; PackedByCap)
                        {
                        }
                        column(InvoicedByCap; InvoicedByCap)
                        {
                        }
                        column(OPenOderCap; OPenOderCap)
                        {
                        }
                        column(BalanceCap; BalanceCap)
                        {
                        }
                        column(DUE_BAL; DUE_BAL)
                        {
                        }
                        column(Order_Amt; Order_Amt)
                        {
                        }
                        column(Total_Bal_Cap; Total_Bal_Cap)
                        {
                        }
                        dataitem(AsmLoop; "Integer")
                        {
                            DataItemTableView = SORTING(Number);
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
                                ELSE BEGIN
                                    AsmLine.NEXT;
                                    TaxLiable := 0;
                                    TaxAmount := 0;
                                    AmountExclInvDisc := 0;
                                    TempSalesLine."Line Amount" := 0;
                                    TempSalesLine."Inv. Discount Amount" := 0;
                                END;
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
                        var
                            SalesLine: Record "Sales Line";
                        begin
                            OnLineNumber := OnLineNumber + 1;

                            WITH TempSalesLine DO BEGIN
                                IF OnLineNumber = 1 THEN
                                    FIND('-')
                                ELSE
                                    NEXT;

                                IF Type = 0 THEN BEGIN
                                    "No." := '';
                                    "Unit of Measure" := '';
                                    "Line Amount" := 0;
                                    "Inv. Discount Amount" := 0;
                                    Quantity := 0;
                                END ELSE
                                    IF Type = Type::"G/L Account" THEN
                                        "No." := '';

                                IF "Tax Area Code" <> '' THEN
                                    TaxAmount := "Amount Including VAT" - Amount
                                ELSE
                                    TaxAmount := 0;

                                IF TaxAmount <> 0 THEN BEGIN
                                    TaxFlag := TRUE;
                                    TaxLiable := Amount;
                                END ELSE BEGIN
                                    TaxFlag := FALSE;
                                    TaxLiable := 0;
                                END;

                                AmountExclInvDisc := "Line Amount";

                                IF Quantity = 0 THEN
                                    UnitPriceToPrint := 0 // so it won't print
                                ELSE
                                    UnitPriceToPrint := ROUND(AmountExclInvDisc / Quantity, 0.00001);
                                IF DisplayAssemblyInformation THEN BEGIN
                                    AsmInfoExistsForLine := FALSE;
                                    IF TempSalesLineAsm.GET("Document Type", "Document No.", "Line No.") THEN BEGIN
                                        SalesLine.GET("Document Type", "Document No.", "Line No.");
                                        AsmInfoExistsForLine := SalesLine.AsmToOrderExists(AsmHeader);
                                    END;
                                END;
                            END;
                            IF OnLineNumber = NumberOfLines THEN
                                PrintFooter := TRUE;
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.CREATETOTALS(TaxLiable, TaxAmount, AmountExclInvDisc, TempSalesLine."Line Amount", TempSalesLine."Inv. Discount Amount");
                            NumberOfLines := TempSalesLine.COUNT;
                            SETRANGE(Number, 1, NumberOfLines);
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
                            SalesPrinted.RUN("Sales Header");
                        CurrReport.BREAK;
                    END;
                    CopyNo := CopyNo + 1;
                    IF CopyNo = 1 THEN // Original
                        CLEAR(CopyTxt)
                    ELSE
                        CopyTxt := Text000;
                end;

                trigger OnPreDataItem()
                begin
                    NoLoops := 1 + ABS(NoCopies);
                    IF NoLoops <= 0 THEN
                        NoLoops := 1;
                    CopyNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //  VK-SPDSPL
                recCustomer.GET("Sales Header"."Sell-to Customer No.");
                recCustomer.CALCFIELDS(recCustomer.Balance);
                IF ("Sales Header"."Sell-to Country/Region Code" <> '') AND ("Sales Header"."Sell-to Country/Region Code" <> 'US') THEN
                    recCountry.GET("Sales Header"."Sell-to Country/Region Code");

                IF ("Sales Header"."Ship-to Country/Region Code" <> '') AND ("Sales Header"."Ship-to Country/Region Code" <> 'US') THEN
                    recCountry2.GET("Sales Header"."Ship-to Country/Region Code");
                IF "Sales Header"."Payment Terms Code" <> '' THEN
                    recPmtTerm.GET("Sales Header"."Payment Terms Code");
                //VK-SPDSPL

                IF PrintCompany THEN BEGIN
                    IF RespCenter.GET("Responsibility Center") THEN BEGIN
                        FormatAddress.RespCenter(CompanyAddress, RespCenter);
                        CompanyInformation."Phone No." := RespCenter."Phone No.";
                        CompanyInformation."Fax No." := RespCenter."Fax No.";
                    END;
                END;
                if "Language Code" <> '' then
                    CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                IF "Salesperson Code" = '' THEN
                    CLEAR(SalesPurchPerson)
                ELSE
                    SalesPurchPerson.GET("Salesperson Code");

                IF "Payment Terms Code" = '' THEN
                    CLEAR(PaymentTerms)
                ELSE
                    PaymentTerms.GET("Payment Terms Code");

                IF "Shipment Method Code" = '' THEN
                    CLEAR(ShipmentMethod)
                ELSE
                    ShipmentMethod.GET("Shipment Method Code");

                IF NOT Cust.GET("Sell-to Customer No.") THEN
                    CLEAR(Cust);

                FormatAddress.SalesHeaderSellTo(BillToAddress, "Sales Header");
                FormatAddress.SalesHeaderShipTo(ShipToAddress, ShipToAddress, "Sales Header");

                IF NOT CurrReport.PREVIEW THEN BEGIN
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

                CLEAR(BreakdownTitle);
                CLEAR(BreakdownLabel);
                CLEAR(BreakdownAmt);
                TotalTaxLabel := Text008;
                TaxRegNo := '';
                TaxRegLabel := '';
                IF "Tax Area Code" <> '' THEN BEGIN
                    TaxArea.GET("Tax Area Code");
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

                IF "Posting Date" <> 0D THEN
                    UseDate := "Posting Date"
                ELSE
                    UseDate := WORKDATE;
                //VK-SPDSPL-02/02/15
                StartDate := "Sales Header"."Order Date";
                PeriodStartDate[5] := StartDate;
                PeriodStartDate[6] := 99991231D;
                FOR i2 := 4 DOWNTO 2 DO
                    PeriodStartDate[i2] := CALCDATE('<-30D>', PeriodStartDate[i2 + 1]);
                //---------
                CurrReport.CREATETOTALS(CustBalanceDueLCY);
                //------------

                //PrintCust := FALSE;
                FOR i2 := 1 TO 5 DO BEGIN
                    DtldCustLedgEntry.SETCURRENTKEY("Customer No.", "Initial Entry Due Date", "Posting Date");
                    DtldCustLedgEntry.SETRANGE("Customer No.", "Sales Header"."Sell-to Customer No.");
                    DtldCustLedgEntry.SETRANGE("Posting Date", 0D, StartDate);
                    DtldCustLedgEntry.SETRANGE("Initial Entry Due Date", PeriodStartDate[i2], PeriodStartDate[i2 + 1] - 1);
                    // IF DtldCustLedgEntry.FIND('-') THEN REPEAT
                    DtldCustLedgEntry.CALCSUMS(DtldCustLedgEntry."Amount (LCY)");
                    CustBalanceDueLCY[i2] := DtldCustLedgEntry."Amount (LCY)";
                    //  UNTIL DtldCustLedgEntry.NEXT=0;
                    IF CustBalanceDueLCY[i2] <> 0 THEN
                        PrintCust := TRUE;
                END;
                //IF NOT PrintCust THEN
                //  CurrReport.SKIP;
                OPEN_ORDER := 0;
                //  END;
                //--------
                Order_Amt := 0;
                recSalesHeader.RESET;
                recSalesHeader.SETRANGE(recSalesHeader."Sell-to Customer No.", "Sales Header"."Sell-to Customer No.");
                recSalesHeader.SETRANGE("Document Type", "Document Type"::Order);
                // recSalesHeader.SETRANGE(Status,Status::Released);
                IF recSalesHeader.FIND('-') THEN
                    REPEAT
                        recSalesHeader.CALCFIELDS(recSalesHeader."Outstanding Amount ($)");
                        Order_Amt += recSalesHeader."Outstanding Amount ($)";
                    UNTIL recSalesHeader.NEXT = 0;


                //---------
                DUE_BAL := 0;
                recCLE.RESET;
                recCLE.SETRANGE("Customer No.", "Sales Header"."Sell-to Customer No.");
                recCLE.SETRANGE(Open, TRUE);
                recCLE.SETFILTER("Due Date", '>%1', WORKDATE);
                IF recCLE.FIND('-') THEN
                    REPEAT
                        recCLE.CALCFIELDS(recCLE."Remaining Amount");
                        DUE_BAL += recCLE."Remaining Amount";
                    UNTIL recCLE.NEXT = 0;
                //VK-SPDSPL-02/02/15
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
                    field(NoCopies; NoCopies)
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
                    field("Display Assembly information"; DisplayAssemblyInformation)
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
            LogInteractionEnable := TRUE;
            ArchiveDocumentEnable := TRUE;
        end;

        trigger OnOpenPage()
        begin
            ArchiveDocument := ArchiveManagement.SalesDocArchiveGranule;
            LogInteraction := SegManagement.FindInteractTmplCode(3) <> '';

            ArchiveDocumentEnable := ArchiveDocument;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        PrintCompany := TRUE;
        CompanyInformation.GET;
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

        IF PrintCompany THEN
            FormatAddress.Company(CompanyAddress, CompanyInformation)
        ELSE
            CLEAR(CompanyAddress);
    end;

    var
        TaxLiable: Decimal;
        UnitPriceToPrint: Decimal;
        AmountExclInvDisc: Decimal;
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        TempSalesLine: Record "Sales Line" temporary;
        TempSalesLineAsm: Record "Sales Line" temporary;
        RespCenter: Record "Responsibility Center";
        Language: Codeunit Language;
        TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
        TaxArea: Record "Tax Area";
        Cust: Record Customer;
        AsmHeader: Record "Assembly Header";
        AsmLine: Record "Assembly Line";
        CompanyAddress: array[8] of Text[50];
        BillToAddress: array[8] of Text[50];
        ShipToAddress: array[8] of Text[50];
        CopyTxt: Text[10];
        PrintCompany: Boolean;
        PrintFooter: Boolean;
        TaxFlag: Boolean;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        HighestLineNo: Integer;
        SpacePointer: Integer;
        SalesPrinted: Codeunit "Sales-Printed";
        FormatAddress: Codeunit "Format Address";
        SalesTaxCalc: Codeunit "Sales Tax Calculate";
        TaxAmount: Decimal;
        SegManagement: Codeunit SegManagement;
        ArchiveManagement: Codeunit ArchiveManagement;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        Text000: Label 'COPY';
        Text003: Label 'Sales Tax Breakdown:';
        Text004: Label 'Other Taxes';
        Text005: Label 'Total Sales Tax:';
        Text006: Label 'Tax Breakdown:';
        Text007: Label 'Total Tax:';
        Text008: Label 'Tax:';
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
        UseExternalTaxEngine: Boolean;
        [InDataSet]
        ArchiveDocumentEnable: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        AsmInfoExistsForLine: Boolean;
        SoldCaptionLbl: Label 'Sold To:';
        ToCaptionLbl: Label 'To:';
        ShipDateCaptionLbl: Label 'Ship Date:';
        CustomerIDCaptionLbl: Label 'Customer ID';
        PONumberCaptionLbl: Label 'Customer P.O.:';
        SalesPersonCaptionLbl: Label 'Salesperson:';
        ShipCaptionLbl: Label 'Ship To:';
        SalesOrderCaptionLbl: Label 'Manufacturing Order ';
        SalesOrderNumberCaptionLbl: Label 'Order Number:';
        SalesOrderDateCaptionLbl: Label 'Order Date:';
        PageCaptionLbl: Label 'Page:';
        ShipViaCaptionLbl: Label 'Ship Via:';
        TermsCaptionLbl: Label 'Incoterms:';
        PODateCaptionLbl: Label 'P.O. Date:';
        TaxIdentTypeCaptionLbl: Label 'Tax Ident. Type';
        ItemNoCaptionLbl: Label 'No.';
        UnitCaptionLbl: Label 'Unit';
        DescriptionCaptionLbl: Label 'Item';
        Description2CaptionLbl: Label 'Description';
        QuantityCaptionLbl: Label 'Quantity';
        UnitPriceCaptionLbl: Label 'Unit Price';
        TotalPriceCaptionLbl: Label 'Total Price';
        SubtotalCaptionLbl: Label 'Subtotal:';
        InvoiceDiscountCaptionLbl: Label 'Discount:';
        TotalCaptionLbl: Label 'Total:';
        AmtSubjecttoSalesTaxCptnLbl: Label 'Amount Subject to Sales Tax';
        AmtExemptfromSalesTaxCptnLbl: Label 'Amount Exempt from Sales Tax';
        ConfirmToCap: Label 'Confirm To :';
        "----VK-------": Integer;
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        StartDate: Date;
        CustFilter: Text;
        PeriodStartDate: array[6] of Date;
        CustBalanceDueLCY: array[5] of Decimal;
        PrintCust: Boolean;
        i2: Integer;
        // "---VK2---": ;
        Text001: Label 'As of %1';
        Customer___Summary_Aging_Simp_CaptionLbl: Label 'Customer - Summary Aging Simp.';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        All_amounts_are_in_LCYCaptionLbl: Label 'All amounts are in $';
        CustBalanceDueLCY_5__Control25CaptionLbl: Label 'Not Due';
        CustBalanceDueLCY_4__Control26CaptionLbl: Label '0-30 days';
        CustBalanceDueLCY_3__Control27CaptionLbl: Label '31-60 days';
        CustBalanceDueLCY_2__Control28CaptionLbl: Label '61-90 days';
        CustBalanceDueLCY_1__Control29CaptionLbl: Label 'Over 90 days';
        TotalCaptionLbl2: Label 'Total';
        recCustomer: Record Customer;
        recSalesHeader: Record "Sales Header";
        OPEN_ORDER: Integer;
        OPenOderCap: Label 'Open Orders';
        BalanceCap: Label 'Current Balance';
        CrLimitCap: Label 'Cr. Limit';
        ApprovedByCap: Label 'Approved By';
        PackedByCap: Label 'Packed By';
        InvoicedByCap: Label 'Invoiced By';
        BALANCE: Decimal;
        CRLIMIT: Decimal;
        recCountry: Record "Country/Region";
        recCountry2: Record "Country/Region";
        recPmtTerm: Record "Payment Terms";
        INCOTERMS: Label 'Incoterms :';
        recCLE: Record "Cust. Ledger Entry";
        DUE_BAL: Decimal;
        Order_Amt: Decimal;
        Total_Bal_Cap: Label 'Total Balance';
        Whse_Cap: Label 'Whse :';


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

