report 70002 "CFA Request Form POSH"
{
    DefaultLayout = RDLC;
    RDLCLayout = './POSH Report/70002_Report_CFARequestForm.rdlc';
    Caption = 'Sales - Quote';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            CalcFields = "Specifier Name";
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Quote));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Sell-to Customer No.", "Bill-to Customer No.", "Ship-to Code", "No. Printed";
            RequestFilterHeading = 'Sales Order';
            column(DocType_SalesHeader; "Document Type")
            {
            }
            column(No_SalesHeader; "No.")
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE("Document Type" = CONST(Quote));
                dataitem(SalesLineComments; "Sales Comment Line")
                {
                    DataItemLink = "No." = FIELD("Document No."), "Document Line No." = FIELD("Line No.");
                    DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = CONST(Quote), "Print On Quote" = CONST(True));

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
                    HighestLineNo := "Line No.";
                    IF ("Sales Header"."Tax Area Code" <> '') AND NOT UseExternalTaxEngine THEN
                        SalesTaxCalc.AddSalesLine(TempSalesLine);

                    TotalAmountExclInvDisc += "Line Amount";
                    TotalTaxAmount += TaxAmount;
                    TotalTempSalesLineInvDiscAmt += TempSalesLine."Inv. Discount Amount";
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
                end;
            }
            dataitem("Sales Comment Line"; "Sales Comment Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = CONST(Quote), "Print On Quote" = CONST(true), "Document Line No." = CONST(0));

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
                    column(CompanyInfoPicture; CompanyInfo.Picture)
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
                    column(CopyTxt; CopyTxt)
                    {
                    }
                    column(SalesExpDt; "Sales Header"."Expiry Date")
                    {
                    }
                    column(ConfirmTo; "Sales Header"."Bill-to Contact")
                    {
                    }
                    column(SalesShiptToContact; "Sales Header"."Ship-to Contact")
                    {
                    }
                    column(Comment_SalesLineComments; Txt)
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
                    column(Project_Name; "Sales Header"."Project Name")
                    {
                    }
                    column(Specifier_Name; "Sales Header"."Specifier Name")
                    {
                    }
                    column(BilltoCustNo_SalesHeader; "Sales Header"."Bill-to Customer No.")
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(OrderDate_SalesHeader; "Sales Header"."Order Date")
                    {
                    }
                    column(SH_ExtDocNo; "Sales Header"."External Document No.")
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
                    column(ShipmentMethodDesc; "Sales Header"."Shipping Agent Code" + ' ' + "Sales Header"."Shipping Agent Service Code" + ' ' + UpsAccNo)
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
                    column(PrintFooter; PrintFooter)
                    {
                    }
                    column(CopyNo; CopyNo)
                    {
                    }
                    column(CustTaxIdentificationType; FORMAT(Cust."Tax Identification Type"))
                    {
                    }
                    column(SellCaption; SellCaptionLbl)
                    {
                    }
                    column(ToCaption; ToCaptionLbl)
                    {
                    }
                    column(CustomerIDCaption; CustomerIDCaptionLbl)
                    {
                    }
                    column(SalesPersonCaption; SalesPersonCaptionLbl)
                    {
                    }
                    column(ShipCaption; ShipCaptionLbl)
                    {
                    }
                    column(SalesQuoteCaption; SalesQuoteCaptionLbl)
                    {
                    }
                    column(SalesQuoteNumberCaption; SalesQuoteNumberCaptionLbl)
                    {
                    }
                    column(SalesQuoteDateCaption; SalesQuoteDateCaptionLbl)
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
                    column(TaxIdentTypeCaption; TaxIdentTypeCaptionLbl)
                    {
                    }
                    dataitem(SalesLine; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(Number_IntegerLine; Number)
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
                        column(MinQty; TempSalesLine."Minimum Qty")
                        {
                        }
                        column(UnitPriceToPrint; UnitPriceToPrint)
                        {
                            DecimalPlaces = 2 : 5;
                        }
                        column(decFreigth; decFreigth)
                        {
                        }
                        column(TempSalesLineDescription; TempSalesLine.Description + ' ' + TempSalesLine."Description 2")
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
                        column(TempSalesLine_LineNo; TempSalesLine."Line No.")
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
                        column(BreakdownAmt1; BreakdownAmt[1])
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
                        column(TotalAmountExclInvDisc; TotalAmountExclInvDisc)
                        {
                        }
                        column(TotalTaxAmount; TotalTaxAmount)
                        {
                        }
                        column(TotalTempSalesLineInvDiscAmt; TotalTempSalesLineInvDiscAmt)
                        {
                        }
                        dataitem(Comment; "Integer")
                        {
                            DataItemTableView = SORTING(Number);
                            column(NewComment; txtComment[intCommentLine])
                            {
                            }

                            column(txtBold; (strpos(txtComment[intCommentLine], '~') <> 0))
                            {
                            }
                            column(CommentGroup; Number)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                intCommentLine := intCommentLine + 1;
                            end;

                            trigger OnPreDataItem()
                            begin
                                SETRANGE(Number, 1, intLineCount);
                                intCommentLine := 0;
                            end;
                        }
                        dataitem(SalesLineComments1; "Integer")
                        {
                            DataItemLinkReference = SalesLine;
                            DataItemTableView = SORTING(Number);
                            column(recSalesLineComments_Comment; recSalesLineComments.Comment)
                            {
                            }
                            column(LineCmtBold; (strpos(recSalesLineComments.Comment, '~') <> 0))
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                IF Number = 1 THEN
                                    recSalesLineComments.FINDSET
                                ELSE
                                    recSalesLineComments.NEXT;
                            end;

                            trigger OnPreDataItem()
                            begin

                                recSalesLineComments.SETRANGE(recSalesLineComments."Document Type", TempSalesLine."Document Type");
                                recSalesLineComments.SETRANGE(recSalesLineComments."No.", TempSalesLine."Document No.");
                                recSalesLineComments.SETRANGE(recSalesLineComments."Document Line No.", TempSalesLine."Line No.");
                                SETRANGE(Number, 1, recSalesLineComments.COUNT);
                                //MESSAGE('%1',recSalesLineComments.COUNT);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            recSalesLine: Record "Sales Line";
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
                                /*
                                IF (Type = Type::Resource) AND ("No." = 'FREIGHT') THEN BEGIN
                                  IF Quantity = 0 THEN
                                    decFreigth += 0
                                  ELSE
                                    decFreigth += ROUND(AmountExclInvDisc / Quantity,0.00001);
                                END;
                                */
                                recSalesLine.RESET;
                                recSalesLine.SETRANGE("Document Type", recSalesLine."Document Type"::Quote);
                                recSalesLine.SETRANGE(recSalesLine."Document No.", TempSalesLine."Document No.");
                                recSalesLine.SETRANGE(Type, Type::Resource);
                                recSalesLine.SETRANGE("No.", 'FREIGHT');
                                recSalesLine.SETFILTER(Quantity, '<>%1', 0);
                                IF recSalesLine.FINDFIRST THEN BEGIN
                                    REPEAT
                                        decFreigth += ROUND(recSalesLine."Line Amount" / recSalesLine.Quantity, 0.00001);
                                    UNTIL recSalesLine.NEXT = 0;
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
                            TempSalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
                            TempSalesLine.Ascending(true);
                        end;
                    }
                    dataitem(SalesHeaderComments; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(recSalesHeaderComments_Comment; recSalesHeaderComments.Comment)
                        {
                        }
                        column(HdrCmtBold; (strpos(recSalesHeaderComments.Comment, '~') <> 0))
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF Number = 1 THEN
                                recSalesHeaderComments.FINDSET
                            ELSE
                                recSalesHeaderComments.NEXT;
                        end;

                        trigger OnPreDataItem()
                        begin
                            recSalesHeaderComments.SETRANGE(recSalesHeaderComments."Document Type", "Sales Header"."Document Type");
                            recSalesHeaderComments.SETRANGE(recSalesHeaderComments."No.", "Sales Header"."No.");
                            recSalesHeaderComments.SETRANGE(recSalesHeaderComments."Document Line No.", 0);
                            SETRANGE(Number, 1, recSalesHeaderComments.COUNT);
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
                //SPD MS
                CLEAR(Txt);
                Rec44.RESET;
                Rec44.SETRANGE(Rec44."No.", "Sales Header"."No.");
                IF Rec44.FIND('-') THEN
                    Txt := Rec44.Comment;



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
                    REPEAT

                        IF recSalesLine.Quantity - recSalesLine."Quantity Shipped" > 0 THEN
                            IF (txtProductGroup <> recSalesLine."Item Category Code") AND (recSalesLine."Item Category Code" <> '') THEN BEGIN

                                recStandardComment.RESET;
                                recStandardComment.SETRANGE("Product Code", recSalesLine."Item Category Code");
                                recStandardComment.SETFILTER(recStandardComment."From Date", '%1|>%2', 0D, "Posting Date");
                                recStandardComment.SETRANGE(recStandardComment."Sales Type", recStandardComment."Sales Type"::Customer);
                                recStandardComment.SETRANGE(recStandardComment."Sales Code", "Sell-to Customer No.");
                                recStandardComment.SETRANGE(Internal, TRUE);
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
                                    recStandardComment.SETFILTER(recStandardComment."From Date", '%1|>%2', 0D, "Posting Date");
                                    recStandardComment.SETRANGE(recStandardComment."Sales Type", recStandardComment."Sales Type"::"All Customer");
                                    //recStandardComment.SETRANGE(recStandardComment."Sales Code","Sell-to Customer No.");
                                    recStandardComment.SETRANGE(Internal, TRUE);
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
                                        recStandardComment.SETFILTER(recStandardComment."From Date", '%1|>%2', 0D, "Posting Date");
                                        recStandardComment.SETRANGE(recStandardComment."Sales Type", recStandardComment."Sales Type"::"Customer Price Group");
                                        recStandardComment.SETRANGE(recStandardComment."Sales Code", "Customer Price Group");
                                        recStandardComment.SETRANGE(Internal, TRUE);
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
                recStandardComment.SetRange("Product Code", '');
                recStandardComment.SETFILTER(recStandardComment."From Date", '%1|>%2', 0D, "Document Date");
                recStandardComment.SETRANGE(recStandardComment."Sales Type", recStandardComment."Sales Type"::Customer);
                recStandardComment.SETRANGE(recStandardComment."Sales Code", "Sell-to Customer No.");
                recStandardComment.SETRANGE(Internal, TRUE);
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

                //Added 07-Jan-2025
                recStandardComment.RESET;
                recStandardComment.SetRange("Product Code", '');
                recStandardComment.SETFILTER(recStandardComment."From Date", '%1|<%2', 0D, "Document Date");
                recStandardComment.SETRANGE(recStandardComment."Sales Type", recStandardComment."Sales Type"::"All Customer");
                recStandardComment.SETRANGE(recStandardComment."Sales Code", '');
                //recStandardComment.SETRANGE(Internal,TRUE);
                IF recStandardComment.FIND('-') THEN
                    repeat
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
                    until recStandardComment.Next() = 0;

                //SPD MS
                IF PrintCompany THEN BEGIN
                    IF RespCenter.GET("Responsibility Center") THEN BEGIN
                        FormatAddress.RespCenter(CompanyAddress, RespCenter);
                        CompanyInformation."Phone No." := RespCenter."Phone No.";
                        CompanyInformation."Fax No." := RespCenter."Fax No.";
                    END;
                END;
                if "Language Code" <> '' then
                    CurrReport.LANGUAGE := LanguageMgmt.GetLanguageID("Language Code");

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
                              1, "No.", "Doc. No. Occurrence",
                              "No. of Archived Versions", DATABASE::Contact, "Bill-to Contact No.",
                              "Salesperson Code", "Campaign No.", "Posting Description", "Opportunity No.")
                        ELSE
                            SegManagement.LogDocument(
                              1, "No.", "Doc. No. Occurrence",
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

                UseDate := WORKDATE;

                UpsAccNo := '';
                IF recCustomer.GET("Sell-to Customer No.") THEN BEGIN
                    IF "Sales Header"."Shipping Agent Code" = 'UPS' THEN
                        UpsAccNo := recCustomer."UPS Account No."
                    ELSE
                        IF "Sales Header"."Shipping Agent Code" = 'FEDEX' THEN
                            UpsAccNo := recCustomer."Shipping Account No."
                        ELSE
                            UpsAccNo := '';
                END;
            end;

            trigger OnPreDataItem()
            begin
                TotalAmountExclInvDisc := 0;
                TotalTaxAmount := 0;
                TotalTempSalesLineInvDiscAmt := 0;
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
            ArchiveDocument := ArchiveManagement.SalesDocArchiveGranule;
            LogInteraction := SegManagement.FindInteractionTemplateCode(DocumentType::"Sales Qte.") <> '';

            ArchiveDocumentEnable := ArchiveDocument;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        CompanyInfo.GET;
        SalesSetup.GET;
        CompanyInfo.CALCFIELDS(Picture);

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
    end;

    trigger OnPreReport()
    begin
        CompanyInformation.GET;
        SalesSetup.GET;

        CASE SalesSetup."Logo Position on Documents" OF
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                CompanyInformation.CALCFIELDS(Picture);
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
        CompanyInfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        TempSalesLine: Record "Sales Line" temporary;
        RespCenter: Record "Responsibility Center";
        Languagemgmt: Codeunit Language;
        TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
        TaxArea: Record "Tax Area";
        Cust: Record Customer;
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
        ArchiveManagement: Codeunit ArchiveManagement;
        TaxAmount: Decimal;
        SegManagement: Codeunit SegManagement;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        Text000: Label 'COPY';
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
        Text003: Label 'Sales Tax Breakdown:';
        Text004: Label 'Other Taxes';
        Text005: Label 'Total Sales Tax:';
        Text006: Label 'Tax Breakdown:';
        Text007: Label 'Total Tax:';
        Text008: Label 'Tax:';
        UseExternalTaxEngine: Boolean;

        ArchiveDocumentEnable: Boolean;

        LogInteractionEnable: Boolean;
        SellCaptionLbl: Label 'Sell';
        ToCaptionLbl: Label 'To:';
        CustomerIDCaptionLbl: Label 'Customer ID';
        SalesPersonCaptionLbl: Label 'SalesPerson';
        ShipCaptionLbl: Label 'Ship';
        SalesQuoteCaptionLbl: Label 'Sales Quote';
        SalesQuoteNumberCaptionLbl: Label 'Sales Quote Number:';
        SalesQuoteDateCaptionLbl: Label 'Sales Quote Date:';
        PageCaptionLbl: Label 'Page:';
        ShipViaCaptionLbl: Label 'Ship Via';
        TermsCaptionLbl: Label 'Terms';
        TaxIdentTypeCaptionLbl: Label 'Tax Ident. Type';
        ItemNoCaptionLbl: Label 'Item No.';
        UnitCaptionLbl: Label 'Unit';
        DescriptionCaptionLbl: Label 'Description';
        QuantityCaptionLbl: Label 'Quantity';
        UnitPriceCaptionLbl: Label 'Unit Price';
        TotalPriceCaptionLbl: Label 'Total Price';
        SubtotalCaptionLbl: Label 'Subtotal:';
        InvoiceDiscountCaptionLbl: Label 'Invoice Discount:';
        TotalCaptionLbl: Label 'Total:';
        AmtSubjecttoSalesTaxCptnLbl: Label 'Amount Subject to Sales Tax';
        AmtExemptfromSalesTaxCptnLbl: Label 'Amount Exempt from Sales Tax';
        "--SPD MS--": Integer;
        intLineCount: Integer;
        txtComment: array[256] of Text[250];
        intCommentLine: Integer;
        txtProductGroup: Code[20];
        recStandardComment: Record "Standard Comment";
        recSalesLine: Record "Sales Line";
        Rec44: Record "Sales Comment Line";
        recSalesLineComments: Record "Sales Comment Line";
        recSalesHeaderComments: Record "Sales Comment Line";
        Txt: Text[250];
        recCustomer: Record Customer;
        UpsAccNo: Code[10];
        TotalAmountExclInvDisc: Decimal;
        TotalTaxAmount: Decimal;
        TotalTempSalesLineInvDiscAmt: Decimal;
        decFreigth: Decimal;
}

