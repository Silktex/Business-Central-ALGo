report 50043 "Sales Invoice (Tax)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50043_Report_SalesInvoiceTax.rdlc';
    Caption = 'Sales - Invoice';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Sell-to Customer No.", "Bill-to Customer No.", "Ship-to Code", "No. Printed";
            RequestFilterHeading = 'Sales Invoice';
            column(No_SalesInvHeader; "No.")
            {
            }
            column(LineAmount; decLineAmount)
            {
            }
            column(DiscountAmount; decDiscountAmount)
            {
            }
            column(NetAmount; decTotalAmount)
            {
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Quantity = FILTER(<> 0));
                dataitem(SalesLineComments; "Sales Comment Line")
                {
                    DataItemLink = "No." = FIELD("Document No."), "Document Line No." = FIELD("Line No.");
                    DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = CONST("Posted Invoice"), "Print On Invoice" = CONST(true));

                    trigger OnAfterGetRecord()
                    begin

                        WITH TempSalesInvoiceLine DO BEGIN
                            INIT;
                            "Document No." := "Sales Invoice Header"."No.";
                            "Line No." := HighestLineNo + 10;
                            HighestLineNo := "Line No.";
                        END;
                        IF STRLEN(Comment) <= MAXSTRLEN(TempSalesInvoiceLine.Description) THEN BEGIN
                            TempSalesInvoiceLine.Description := Comment;
                            TempSalesInvoiceLine."Description 2" := '';
                        END ELSE BEGIN
                            SpacePointer := MAXSTRLEN(TempSalesInvoiceLine.Description) + 1;
                            WHILE (SpacePointer > 1) AND (Comment[SpacePointer] <> ' ') DO
                                SpacePointer := SpacePointer - 1;
                            IF SpacePointer = 1 THEN
                                SpacePointer := MAXSTRLEN(TempSalesInvoiceLine.Description) + 1;
                            TempSalesInvoiceLine.Description := COPYSTR(Comment, 1, SpacePointer - 1);
                            TempSalesInvoiceLine."Description 2" :=
                              COPYSTR(COPYSTR(Comment, SpacePointer + 1), 1, MAXSTRLEN(TempSalesInvoiceLine."Description 2"));
                        END;
                        TempSalesInvoiceLine.INSERT;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    TempSalesInvoiceLine := "Sales Invoice Line";
                    TempSalesInvoiceLine.INSERT;
                    TempSalesInvoiceLineAsm := "Sales Invoice Line";
                    TempSalesInvoiceLineAsm.INSERT;

                    HighestLineNo := "Line No.";
                end;

                trigger OnPreDataItem()
                begin
                    TempSalesInvoiceLine.RESET;
                    TempSalesInvoiceLine.DELETEALL;
                    TempSalesInvoiceLineAsm.RESET;
                    TempSalesInvoiceLineAsm.DELETEALL;
                end;
            }
            dataitem("Sales Comment Line"; "Sales Comment Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = WHERE("Document Type" = CONST("Posted Invoice"), "Document Line No." = CONST(0));

                trigger OnAfterGetRecord()
                begin
                    WITH TempSalesInvoiceLine DO BEGIN
                        INIT;
                        "Document No." := "Sales Invoice Header"."No.";
                        "Line No." := HighestLineNo + 1000;
                        HighestLineNo := "Line No.";
                    END;
                    IF STRLEN(Comment) <= MAXSTRLEN(TempSalesInvoiceLine.Description) THEN BEGIN
                        TempSalesInvoiceLine.Description := Comment;
                        TempSalesInvoiceLine."Description 2" := '';
                    END ELSE BEGIN
                        SpacePointer := MAXSTRLEN(TempSalesInvoiceLine.Description) + 1;
                        WHILE (SpacePointer > 1) AND (Comment[SpacePointer] <> ' ') DO
                            SpacePointer := SpacePointer - 1;
                        IF SpacePointer = 1 THEN
                            SpacePointer := MAXSTRLEN(TempSalesInvoiceLine.Description) + 1;
                        TempSalesInvoiceLine.Description := COPYSTR(Comment, 1, SpacePointer - 1);
                        TempSalesInvoiceLine."Description 2" :=
                          COPYSTR(COPYSTR(Comment, SpacePointer + 1), 1, MAXSTRLEN(TempSalesInvoiceLine."Description 2"));
                    END;
                    TempSalesInvoiceLine.INSERT;
                end;

                trigger OnPreDataItem()
                begin
                    WITH TempSalesInvoiceLine DO BEGIN
                        INIT;
                        "Document No." := "Sales Invoice Header"."No.";
                        "Line No." := HighestLineNo + 1000;
                        HighestLineNo := "Line No.";
                    END;
                    TempSalesInvoiceLine.INSERT;
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
                    column(CompanyInformationPicture; CompanyInfo3.Picture)
                    {
                    }
                    column(ShowEmbLogo; ShowEmbLogo)
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
                    column(CompanyInformation_Address2; CompanyInformation."Address 2")
                    {
                    }
                    column(CompanyInformation_City; CompanyInformation.City)
                    {
                    }
                    column(CompanyInformation_County; CompanyInformation.County)
                    {
                    }
                    column(CompanyInformation_PostCode; CompanyInformation."Post Code")
                    {
                    }
                    column(CompanyInformation_PhoneNo; CompanyInformation."Phone No.")
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
                    column(CustContNumbertxt; CustContNumber)
                    {
                    }
                    column(PhoneNo; PhoneNo)
                    {
                    }
                    column(ConfirmContact; "Sales Invoice Header"."Sell-to Contact")
                    {
                    }
                    column(ShipmentMethodDescription; "Sales Invoice Header"."Shipment Method Code")
                    {
                    }
                    column(SalesInvoiceHeader_ShippingAgentCode; "Sales Invoice Header"."Shipping Agent Code")
                    {
                    }
                    column(AccountCode; AccountCode)
                    {
                    }
                    column(AccountCodetxt; AccountCodetxt)
                    {
                    }
                    column(PackageTrackingNo; "Sales Invoice Header"."Package Tracking No.")
                    {
                    }
                    column(ShptDate_SalesInvHeader; "Sales Invoice Header"."Shipment Date")
                    {
                    }
                    column(DueDate_SalesInvHeader; "Sales Invoice Header"."Due Date")
                    {
                    }
                    column(PaymentTermsDescription; PaymentTerms.Description)
                    {
                    }
                    column(ShiptoName_SalesInvoiceHeader; "Sales Invoice Header"."Ship-to Name")
                    {
                    }
                    column(ShiptoAddress_SalesInvoiceHeader; "Sales Invoice Header"."Ship-to Address")
                    {
                    }
                    column(ShiptoAddress2_SalesInvoiceHeader; "Sales Invoice Header"."Ship-to Address 2")
                    {
                    }
                    column(ShiptoCity_SalesInvoiceHeader; "Sales Invoice Header"."Ship-to City")
                    {
                    }
                    column(ShiptoPostCode_SalesInvoiceHeader; "Sales Invoice Header"."Ship-to Post Code")
                    {
                    }
                    column(ShiptoCounty_SalesInvoiceHeader; "Sales Invoice Header"."Ship-to County")
                    {
                    }
                    column(ShiptoContact_SalesInvoiceHeader; "Sales Invoice Header"."Ship-to Contact")
                    {
                    }
                    column(ShiptoCountryRegionCode_SalesInvoiceHeader; "Sales Invoice Header"."Ship-to Country/Region Code")
                    {
                    }
                    column(recCustomer_Name; "Sales Invoice Header"."Bill-to Name")
                    {
                    }
                    column(recCustomer_Address; "Sales Invoice Header"."Bill-to Address")
                    {
                    }
                    column(recCustomer_Address2; "Sales Invoice Header"."Bill-to Address 2")
                    {
                    }
                    column(recCustomer_City; "Sales Invoice Header"."Bill-to City")
                    {
                    }
                    column(recCustomer_County; "Sales Invoice Header"."Bill-to County")
                    {
                    }
                    column(recCustomer_PostCode; "Sales Invoice Header"."Bill-to Post Code")
                    {
                    }
                    column(recCustomer_BilltoCountryRegionCode; "Sales Invoice Header"."Bill-to Country/Region Code")
                    {
                    }
                    column(PmtTerms; recPmtTerms.Description)
                    {
                    }
                    column(recCountry_Name; recCountry.Name)
                    {
                    }
                    column(recCountry2_Name; recCountry2.Name)
                    {
                    }
                    column(ShiptoCode; "Sales Invoice Header"."Ship-to Code")
                    {
                    }
                    column(ShiptoName; "Sales Invoice Header"."Ship-to Name")
                    {
                    }
                    column(ShiptoAddress; "Sales Invoice Header"."Ship-to Address")
                    {
                    }
                    column(Shipto_Address2; "Sales Invoice Header"."Ship-to Address 2")
                    {
                    }
                    column(ShiptoCity; "Sales Invoice Header"."Ship-to City")
                    {
                    }
                    column(ShiptoContact; "Sales Invoice Header"."Ship-to Contact")
                    {
                    }
                    column(ShiptoPostCode; "Sales Invoice Header"."Ship-to Post Code")
                    {
                    }
                    column(ShiptoCounty; "Sales Invoice Header"."Ship-to County")
                    {
                    }
                    column(BilltoCustNo_SalesInvHeader; "Sales Invoice Header"."Bill-to Customer No.")
                    {
                    }
                    column(YourRef_SalesInvHeader; "Sales Invoice Header"."Your Reference")
                    {
                    }
                    column(OrderDate_SalesInvHeader; "Sales Invoice Header"."Order Date")
                    {
                    }
                    column(OrderNo_SalesInvHeader; "Sales Invoice Header"."Order No.")
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(DocumentDate_SalesInvHeader; "Sales Invoice Header"."Posting Date")
                    {
                    }
                    column(SalesInvoiceHeader_PreAssignedNo; "Sales Invoice Header"."Pre-Assigned No.")
                    {
                    }
                    column(SalesInvoiceHeader_ExternalDocumentNo; "Sales Invoice Header"."External Document No.")
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
                    column(TaxRegNo; TaxRegNo)
                    {
                    }
                    column(TaxRegLabel; TaxRegLabel)
                    {
                    }
                    column(DocumentText; DocumentText)
                    {
                    }
                    column(CopyNo; CopyNo)
                    {
                    }
                    column(CustTaxIdentificationType; FORMAT(Cust."Tax Identification Type"))
                    {
                    }
                    column(BillCaption; BillCaptionLbl)
                    {
                    }
                    column(ToCaption; ToCaptionLbl)
                    {
                    }
                    column(ShipViaCaption; ShipViaCaptionLbl)
                    {
                    }
                    column(ShipDateCaption; ShipDateCaptionLbl)
                    {
                    }
                    column(DueDateCaption; DueDateCaptionLbl)
                    {
                    }
                    column(TermsCaption; TermsCaptionLbl)
                    {
                    }
                    column(CustomerIDCaption; CustomerIDCaptionLbl)
                    {
                    }
                    column(PONumberCaption; PONumberCaptionLbl)
                    {
                    }
                    column(PODateCaption; PODateCaptionLbl)
                    {
                    }
                    column(OurOrderNoCaption; OurOrderNoCaptionLbl)
                    {
                    }
                    column(SalesPersonCaption; SalesPersonCaptionLbl)
                    {
                    }
                    column(ShipCaption; ShipCaptionLbl)
                    {
                    }
                    column(InvoiceNumberCaption; InvoiceNumberCaptionLbl)
                    {
                    }
                    column(InvoiceDateCaption; InvoiceDateCaptionLbl)
                    {
                    }
                    column(PageCaption; PageCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption; TaxIdentTypeCaptionLbl)
                    {
                    }
                    column(ConfirmTo; ConfirmTo)
                    {
                    }
                    column(BilltoContact_SalesInvoiceHeader; "Sales Invoice Header"."Bill-to Contact")
                    {
                    }
                    dataitem(SalesInvLine; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(No_SalesCommentheader; "Sales Comment Line"."No.")
                        {
                        }
                        column(LineNo_SalesCommentheader; "Sales Comment Line"."Line No.")
                        {
                        }
                        column(Comment_SalesCommentheader; "Sales Comment Line".Comment)
                        {
                        }
                        column(Comment_LINE; SalesLineComments.Comment)
                        {
                        }
                        column(PrintFooter; PrintFooter)
                        {
                        }
                        column(AmountExclInvDisc; AmountExclInvDisc)
                        {
                        }
                        column(TempSalesInvoiceLineNo; TempSalesInvoiceLine."No.")
                        {
                        }
                        column(TempSalesInvoiceLineUOM; TempSalesInvoiceLine."Unit of Measure")
                        {
                        }
                        column(OrderedQuantity; TempSalesInvoiceLine.Quantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(TempSalesInvoiceLineQty; TempSalesInvoiceLine.Quantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(CustRef; TempSalesInvoiceLine."Item Reference No.")
                        {
                        }
                        column(UnitPriceToPrint; UnitPriceToPrint)
                        {
                            DecimalPlaces = 2 : 5;
                        }
                        column(LowDescriptionToPrint; LowDescriptionToPrint)
                        {
                        }
                        column(HighDescriptionToPrint; HighDescriptionToPrint)
                        {
                        }
                        column(TempSalesInvoiceLineDocNo; TempSalesInvoiceLine."Document No.")
                        {
                        }
                        column(TempSalesInvoiceLineLineNo; TempSalesInvoiceLine."Line No.")
                        {
                        }
                        column(TaxLiable; TaxLiable)
                        {
                        }
                        column(TempSalesInvoiceLineAmtTaxLiable; TempSalesInvoiceLine.Amount - TaxLiable)
                        {
                        }
                        column(TempSalesInvoiceLineAmtAmtExclInvDisc; TempSalesInvoiceLine.Amount - AmountExclInvDisc)
                        {
                        }
                        column(TempSalesInvoiceLineAmtInclVATAmount; TempSalesInvoiceLine."Amount Including VAT" - TempSalesInvoiceLine.Amount)
                        {
                        }
                        column(TempSalesInvoiceLineAmtInclVAT; TempSalesInvoiceLine."Amount Including VAT")
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
                        column(BreakdownAmt2; BreakdownAmt[2])
                        {
                        }
                        column(BreakdownLabel2; BreakdownLabel[2])
                        {
                        }
                        column(BreakdownAmt3; BreakdownAmt[3])
                        {
                        }
                        column(BreakdownLabel3; BreakdownLabel[3])
                        {
                        }
                        column(BreakdownAmt4; BreakdownAmt[4])
                        {
                        }
                        column(BreakdownLabel4; BreakdownLabel[4])
                        {
                        }
                        column(ItemDescriptionCaption; ItemDescriptionCaptionLbl)
                        {
                        }
                        column(UnitCaption; UnitCaptionLbl)
                        {
                        }
                        column(OrderQtyCaption; OrderQtyCaptionLbl)
                        {
                        }
                        column(QuantityCaption; QuantityCaptionLbl)
                        {
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(ItemNoCap; ItemNoCap)
                        {
                        }
                        column(Description2Cap; Description2Cap)
                        {
                        }
                        column(TempSalesInvoiceLine_Description_; TempSalesInvoiceLine.Description)
                        {
                        }
                        column(TempSalesInvoiceLine_Description2_; TempSalesInvoiceLine."Description 2")
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
                        column(AmountSubjecttoSalesTaxCaption; AmountSubjecttoSalesTaxCaptionLbl)
                        {
                        }
                        column(AmountExemptfromSalesTaxCaption; AmountExemptfromSalesTaxCaptionLbl)
                        {
                        }
                        column(SalesInvoiceLine_LineDiscountAmount; TempSalesInvoiceLine."Line Discount Amount")
                        {
                        }
                        column(Discounttxt; Discounttxt)
                        {
                        }
                        column(TempSalesInvoiceLineLineDiscountAmount; TempSalesInvoiceLine."Line Discount Amount")
                        {
                        }
                        column(TempSalesInvoiceLineLineAmount; TempSalesInvoiceLine."Line Amount" + TempSalesInvoiceLine."Line Discount Amount")
                        {
                        }
                        column(TempSalesInvoiceLine_Description; ItemName)
                        {
                        }
                        column(TempSalesInvoiceLine_Description2; ItemDes)
                        {
                        }
                        dataitem(SalesLineComments1; "Integer")
                        {
                            DataItemLinkReference = SalesInvLine;
                            DataItemTableView = SORTING(Number);
                            column(recSalesLineComments_Comment; recSalesLineComments.Comment)
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
                                recSalesLineComments.SETRANGE(recSalesLineComments."No.", TempSalesInvoiceLine."Document No.");
                                recSalesLineComments.SETRANGE(recSalesLineComments."Document Line No.", TempSalesInvoiceLine."Line No.");
                                SETRANGE(Number, 1, recSalesLineComments.COUNT);
                                //MESSAGE('%1',recSalesLineComments.COUNT);
                            end;
                        }
                        dataitem(Comment; "Integer")
                        {
                            DataItemLinkReference = "Sales Invoice Header";
                            DataItemTableView = SORTING(Number);
                            column(NewComment; txtComment[intCommentLine])
                            {
                            }
                            column(CommentGroup; intCommentLine)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                intCommentLine := intCommentLine + 1;
                            end;

                            trigger OnPreDataItem()
                            begin
                                SETRANGE(Number, 1, intLineCount1);
                                intCommentLine := 0;
                            end;
                        }
                        dataitem(SalesHeadComm; "Sales Comment Line")
                        {
                            DataItemLink = "No." = FIELD("No.");
                            DataItemLinkReference = "Sales Invoice Header";
                            DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = CONST("Posted Invoice"), "Document Line No." = CONST(0));
                            column(DocumentType_SalesHeadComm; SalesHeadComm."Document Type")
                            {
                            }
                            column(No_SalesHeadComm; SalesHeadComm."No.")
                            {
                            }
                            column(LineNo_SalesHeadComm; SalesHeadComm."Line No.")
                            {
                            }
                            column(Comment_SalesHeadComm; SalesHeadComm.Comment)
                            {
                            }
                        }
                        dataitem(AsmLoop; "Integer")
                        {
                            DataItemLinkReference = SalesInvLine;
                            DataItemTableView = SORTING(Number);
                            column(TempPostedAsmLineUOMCode; GetUOMText(TempPostedAsmLine."Unit of Measure Code"))
                            {
                                //DecimalPlaces = 0 : 5;
                            }
                            column(TempPostedAsmLineQuantity; TempPostedAsmLine.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(TempPostedAsmLineDesc; BlanksForIndent + TempPostedAsmLine.Description)
                            {
                            }
                            column(TempPostedAsmLineNo; BlanksForIndent + TempPostedAsmLine."No.")
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                IF Number = 1 THEN
                                    TempPostedAsmLine.FINDSET
                                ELSE BEGIN
                                    TempPostedAsmLine.NEXT;
                                    TaxLiable := 0;
                                    AmountExclInvDisc := 0;
                                    TempSalesInvoiceLine.Amount := 0;
                                    TempSalesInvoiceLine."Amount Including VAT" := 0;
                                END;
                            end;

                            trigger OnPreDataItem()
                            begin
                                CLEAR(TempPostedAsmLine);
                                SETRANGE(Number, 1, TempPostedAsmLine.COUNT);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            OnLineNumber := OnLineNumber + 1;

                            WITH TempSalesInvoiceLine DO BEGIN
                                IF OnLineNumber = 1 THEN
                                    FIND('-')
                                ELSE
                                    NEXT;
                                /*
                      OrderedQuantity := 0;
                      IF "Sales Invoice Header"."Order No." = '' THEN
                        OrderedQuantity := Quantity
                      ELSE BEGIN
                        IF OrderLine.GET(1,"Sales Invoice Header"."Order No.","Line No.") THEN
                          OrderedQuantity := OrderLine.Quantity
                        ELSE BEGIN
                          ShipmentLine.SETRANGE("Order No.","Sales Invoice Header"."Order No.");
                          ShipmentLine.SETRANGE("Order Line No.","Line No.");
                          IF ShipmentLine.FIND('-') THEN
                            REPEAT
                              OrderedQuantity := OrderedQuantity + ShipmentLine.Quantity;
                            UNTIL 0 = ShipmentLine.NEXT;
                        END;
                      END;
                            */

                                DescriptionToPrint := Description + ' ' + "Description 2";

                                //Ashwini
                                IF NOT GLAccountPrint THEN BEGIN
                                    IF Type = 0 THEN BEGIN
                                        IF OnLineNumber < NumberOfLines THEN BEGIN
                                            NEXT;
                                            IF Type = 0 THEN BEGIN
                                                DescriptionToPrint :=
                                                  COPYSTR(DescriptionToPrint + ' ' + Description + ' ' + "Description 2", 1, MAXSTRLEN(DescriptionToPrint));
                                                OnLineNumber := OnLineNumber + 1;
                                                SalesInvLine.NEXT;
                                            END ELSE
                                                NEXT(-1);
                                        END;
                                        "No." := '';
                                        "Unit of Measure" := '';
                                        Amount := 0;
                                        "Amount Including VAT" := 0;
                                        "Inv. Discount Amount" := 0;
                                        Quantity := 0;
                                    END ELSE
                                        IF Type = Type::"G/L Account" THEN
                                            "No." := '';
                                END;
                                //Ashwini
                                IF "No." = '' THEN BEGIN
                                    HighDescriptionToPrint := DescriptionToPrint;
                                    LowDescriptionToPrint := '';
                                END ELSE BEGIN
                                    HighDescriptionToPrint := '';
                                    LowDescriptionToPrint := DescriptionToPrint;
                                END;

                                IF Amount <> "Amount Including VAT" THEN BEGIN
                                    TaxFlag := TRUE;
                                    TaxLiable := Amount;
                                END ELSE BEGIN
                                    TaxFlag := FALSE;
                                    TaxLiable := 0;
                                END;

                                //AmountExclInvDisc := Amount + "Inv. Discount Amount";
                                AmountExclInvDisc := "Unit Price" * Quantity;
                                IF Quantity = 0 THEN
                                    UnitPriceToPrint := 0 // so it won't print
                                ELSE
                                    // UnitPriceToPrint := ROUND(AmountExclInvDisc / Quantity,0.00001);
                                    UnitPriceToPrint := ROUND("Unit Price", 0.00001);

                                ItemName := '';
                                ItemDes := '';
                                recItemCust.RESET;
                                recItemCust.SETRANGE("Customer No.", TempSalesInvoiceLine."Sell-to Customer No.");
                                recItemCust.SETRANGE("Item No.", TempSalesInvoiceLine."No.");
                                IF recItemCust.FIND('-') THEN BEGIN
                                    IF (TempSalesInvoiceLine.Type <> TempSalesInvoiceLine.Type::Item) THEN BEGIN
                                        ItemName := TempSalesInvoiceLine.Description;
                                    END ELSE BEGIN
                                        IF (recItemCust."Customer Item No." <> '') THEN
                                            ItemName := recItemCust."Customer Item No."
                                        ELSE
                                            ItemName := TempSalesInvoiceLine.Description;
                                    END;

                                    IF (TempSalesInvoiceLine.Type <> TempSalesInvoiceLine.Type::Item) THEN BEGIN
                                        ItemDes := TempSalesInvoiceLine."Description 2";
                                    END ELSE BEGIN
                                        IF (recItemCust.Description <> '') THEN
                                            ItemDes := recItemCust.Description
                                        ELSE
                                            ItemDes := TempSalesInvoiceLine."Description 2";
                                    END;
                                END ELSE BEGIN
                                    ItemDes := TempSalesInvoiceLine."Description 2";
                                    ItemName := TempSalesInvoiceLine.Description;
                                END;

                            END;

                            IF OnLineNumber = NumberOfLines THEN
                                PrintFooter := TRUE;
                            CollectAsmInformation(TempSalesInvoiceLine);

                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.CREATETOTALS(TaxLiable, AmountExclInvDisc, TempSalesInvoiceLine.Amount, TempSalesInvoiceLine."Amount Including VAT");
                            NumberOfLines := TempSalesInvoiceLine.COUNT;
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
                            SalesInvPrinted.RUN("Sales Invoice Header");
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
                    NoLoops := 1 + ABS(NoCopies) + Customer."Invoice Copies";
                    IF NoLoops <= 0 THEN
                        NoLoops := 1;
                    CopyNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                FOR intLineCount1 := 1 TO 80 DO BEGIN
                    txtComment[intLineCount1] := '';
                END;
                intLineCount1 := 0;
                //txtComment:='';
                txtProductGroup := '';
                recSalesLine.RESET;
                recSalesLine.SETCURRENTKEY("Document No.", "Item Category Code");
                //recSalesLine.SETRANGE("Document Type","Document Type");
                recSalesLine.SETRANGE("Document No.", "No.");
                IF recSalesLine.FIND('-') THEN BEGIN
                    REPEAT

                        IF recSalesLine.Quantity > 0 THEN
                            IF (txtProductGroup <> recSalesLine."Item Category Code") AND (recSalesLine."Item Category Code" <> '') THEN BEGIN

                                recStandardComment.RESET;
                                recStandardComment.SETRANGE("Product Code", recSalesLine."Item Category Code");
                                recStandardComment.SETFILTER(recStandardComment."From Date", '%1|>%2', 0D, "Posting Date");
                                recStandardComment.SETRANGE(recStandardComment."Sales Type", recStandardComment."Sales Type"::Customer);
                                recStandardComment.SETRANGE(recStandardComment."Sales Code", "Sell-to Customer No.");
                                //recStandardComment.SETRANGE(External,TRUE);
                                IF recStandardComment.FIND('-') THEN BEGIN
                                    IF recStandardComment.External THEN
                                        IF recStandardComment.Comment <> '' THEN BEGIN
                                            intLineCount1 := intLineCount1 + 1;
                                            txtComment[intLineCount1] := recStandardComment.Comment;//+' '+recStandardComment."Comment 2";
                                        END;
                                    IF recStandardComment.External2 THEN
                                        IF recStandardComment."Comment 2" <> '' THEN BEGIN
                                            intLineCount1 := intLineCount1 + 1;
                                            txtComment[intLineCount1] := recStandardComment."Comment 2";//+' '+recStandardComment."Comment 2";
                                        END;
                                    IF recStandardComment.External3 THEN
                                        IF recStandardComment."Comment 3" <> '' THEN BEGIN
                                            intLineCount1 := intLineCount1 + 1;
                                            txtComment[intLineCount1] := recStandardComment."Comment 3";//+' '+recStandardComment."Comment 2";
                                        END;
                                    IF recStandardComment.External4 THEN
                                        IF recStandardComment."Comment 4" <> '' THEN BEGIN
                                            intLineCount1 := intLineCount1 + 1;
                                            txtComment[intLineCount1] := recStandardComment."Comment 4";//+' '+recStandardComment."Comment 2";
                                        END;
                                    IF recStandardComment.External5 THEN
                                        IF recStandardComment."Comment 5" <> '' THEN BEGIN
                                            intLineCount1 := intLineCount1 + 1;
                                            txtComment[intLineCount1] := recStandardComment."Comment 5";//+' '+recStandardComment."Comment 2";
                                        END;


                                    txtProductGroup := recSalesLine."Item Category Code";
                                END ELSE BEGIN
                                    recStandardComment.RESET;
                                    recStandardComment.SETRANGE("Product Code", recSalesLine."Item Category Code");
                                    recStandardComment.SETFILTER(recStandardComment."From Date", '%1|>%2', 0D, "Posting Date");
                                    recStandardComment.SETRANGE(recStandardComment."Sales Type", recStandardComment."Sales Type"::"All Customer");
                                    //recStandardComment.SETRANGE(recStandardComment."Sales Code","Sell-to Customer No.");
                                    // recStandardComment.SETRANGE(External,TRUE);
                                    IF recStandardComment.FIND('-') THEN BEGIN
                                        IF recStandardComment.External THEN
                                            IF recStandardComment.Comment <> '' THEN BEGIN
                                                intLineCount1 := intLineCount1 + 1;
                                                txtComment[intLineCount1] := recStandardComment.Comment;//+' '+recStandardComment."Comment 2";
                                            END;
                                        IF recStandardComment.External2 THEN
                                            IF recStandardComment."Comment 2" <> '' THEN BEGIN
                                                intLineCount1 := intLineCount1 + 1;
                                                txtComment[intLineCount1] := recStandardComment."Comment 2";//+' '+recStandardComment."Comment 2";
                                            END;
                                        IF recStandardComment.External3 THEN
                                            IF recStandardComment."Comment 3" <> '' THEN BEGIN
                                                intLineCount1 := intLineCount1 + 1;
                                                txtComment[intLineCount1] := recStandardComment."Comment 3";//+' '+recStandardComment."Comment 2";
                                            END;
                                        IF recStandardComment.External4 THEN
                                            IF recStandardComment."Comment 4" <> '' THEN BEGIN
                                                intLineCount1 := intLineCount1 + 1;
                                                txtComment[intLineCount1] := recStandardComment."Comment 4";//+' '+recStandardComment."Comment 2";
                                            END;
                                        IF recStandardComment.External5 THEN
                                            IF recStandardComment."Comment 5" <> '' THEN BEGIN
                                                intLineCount1 := intLineCount1 + 1;
                                                txtComment[intLineCount1] := recStandardComment."Comment 5";//+' '+recStandardComment."Comment 2";
                                            END;


                                        txtProductGroup := recSalesLine."Item Category Code";


                                    END ELSE BEGIN
                                        recStandardComment.RESET;
                                        recStandardComment.SETRANGE("Product Code", recSalesLine."Item Category Code");
                                        recStandardComment.SETFILTER(recStandardComment."From Date", '%1|>%2', 0D, "Posting Date");
                                        recStandardComment.SETRANGE(recStandardComment."Sales Type", recStandardComment."Sales Type"::"Customer Price Group");
                                        recStandardComment.SETRANGE(recStandardComment."Sales Code", "Customer Price Group");
                                        // recStandardComment.SETRANGE(External,TRUE);
                                        IF recStandardComment.FIND('-') THEN BEGIN
                                            IF recStandardComment.External THEN
                                                IF recStandardComment.Comment <> '' THEN BEGIN
                                                    intLineCount1 := intLineCount1 + 1;
                                                    txtComment[intLineCount1] := recStandardComment.Comment;//+' '+recStandardComment."Comment 2";
                                                END;
                                            IF recStandardComment.External2 THEN
                                                IF recStandardComment."Comment 2" <> '' THEN BEGIN
                                                    intLineCount1 := intLineCount1 + 1;
                                                    txtComment[intLineCount1] := recStandardComment."Comment 2";//+' '+recStandardComment."Comment 2";
                                                END;
                                            IF recStandardComment.External3 THEN
                                                IF recStandardComment."Comment 3" <> '' THEN BEGIN
                                                    intLineCount1 := intLineCount1 + 1;
                                                    txtComment[intLineCount1] := recStandardComment."Comment 3";//+' '+recStandardComment."Comment 2";
                                                END;
                                            IF recStandardComment.External4 THEN
                                                IF recStandardComment."Comment 4" <> '' THEN BEGIN
                                                    intLineCount1 := intLineCount1 + 1;
                                                    txtComment[intLineCount1] := recStandardComment."Comment 4";//+' '+recStandardComment."Comment 2";
                                                END;
                                            IF recStandardComment.External5 THEN
                                                IF recStandardComment."Comment 5" <> '' THEN BEGIN
                                                    intLineCount1 := intLineCount1 + 1;
                                                    txtComment[intLineCount1] := recStandardComment."Comment 5";//+' '+recStandardComment."Comment 2";
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
                recStandardComment.SETFILTER(recStandardComment."From Date", '%1|>%2', 0D, "Posting Date");
                recStandardComment.SETRANGE(recStandardComment."Sales Type", recStandardComment."Sales Type"::Customer);
                recStandardComment.SETRANGE(recStandardComment."Sales Code", "Sell-to Customer No.");
                //recStandardComment.SETRANGE(External,TRUE);
                IF recStandardComment.FIND('-') THEN BEGIN
                    IF recStandardComment.External THEN
                        IF recStandardComment.Comment <> '' THEN BEGIN
                            intLineCount1 := intLineCount1 + 1;
                            txtComment[intLineCount1] := recStandardComment.Comment;//+' '+recStandardComment."Comment 2";
                        END;
                    IF recStandardComment.External2 THEN
                        IF recStandardComment."Comment 2" <> '' THEN BEGIN
                            intLineCount1 := intLineCount1 + 1;
                            txtComment[intLineCount1] := recStandardComment."Comment 2";//+' '+recStandardComment."Comment 2";
                        END;
                    IF recStandardComment.External3 THEN
                        IF recStandardComment."Comment 3" <> '' THEN BEGIN
                            intLineCount1 := intLineCount1 + 1;
                            txtComment[intLineCount1] := recStandardComment."Comment 3";//+' '+recStandardComment."Comment 2";
                        END;
                    IF recStandardComment.External4 THEN
                        IF recStandardComment."Comment 4" <> '' THEN BEGIN
                            intLineCount1 := intLineCount1 + 1;
                            txtComment[intLineCount1] := recStandardComment."Comment 4";//+' '+recStandardComment."Comment 2";
                        END;
                    IF recStandardComment.External5 THEN
                        IF recStandardComment."Comment 5" <> '' THEN BEGIN
                            intLineCount1 := intLineCount1 + 1;
                            txtComment[intLineCount1] := recStandardComment."Comment 5";//+' '+recStandardComment."Comment 2";
                        END;


                END;
                decLineAmount := 0;
                decTotalAmount := 0;
                decDiscountAmount := 0;
                recSalesLine.RESET;
                //recSalesLine.SETCURRENTKEY("Document No.","Item Category Code");
                //recSalesLine.SETRANGE("Document Type","Document Type");
                recSalesLine.SETRANGE("Document No.", "No.");
                IF recSalesLine.FIND('-') THEN BEGIN
                    REPEAT
                        decLineAmount := decLineAmount + recSalesLine."Line Amount" + recSalesLine."Line Discount Amount";
                        decDiscountAmount := decDiscountAmount + recSalesLine."Line Discount Amount";

                        decTotalAmount := decTotalAmount + recSalesLine."Amount Including VAT";
                    UNTIL recSalesLine.NEXT = 0;
                END;



                IF "Bill-to Name 2" = '' THEN
                    "Bill-to Name 2" := ' ';
                //VK
                recCustomer.GET("Sales Invoice Header"."Bill-to Customer No.");

                AccountCodetxt := '';
                AccountCode := '';
                IF "Shipping Agent Code" = 'UPS' THEN BEGIN
                    AccountCodetxt := 'Fedex Account Code';
                    AccountCode := recCustomer."Shipping Account No.";
                END ELSE
                    IF "Shipping Agent Code" = 'FEDEX' THEN BEGIN
                        AccountCodetxt := 'UPS Account Code';
                        AccountCode := recCustomer."UPS Account No.";
                    END;

                IF ("Sales Invoice Header"."Bill-to Country/Region Code" <> '') AND ("Sales Invoice Header"."Bill-to Country/Region Code" <> 'US') THEN
                    recCountry.GET("Sales Invoice Header"."Bill-to Country/Region Code");
                IF ("Sales Invoice Header"."Ship-to Country/Region Code" <> '') AND ("Sales Invoice Header"."Ship-to Country/Region Code" <> 'US') THEN
                    recCountry2.GET("Sales Invoice Header"."Ship-to Country/Region Code");

                IF "Sales Invoice Header"."Payment Terms Code" <> '' THEN
                    recPmtTerms.GET("Sales Invoice Header"."Payment Terms Code");


                //VK

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

                IF NOT Customer.GET("Bill-to Customer No.") THEN BEGIN
                    CLEAR(Customer);
                    "Bill-to Name" := Text009;
                    "Ship-to Name" := Text009;
                END;
                DocumentText := USText000;
                IF "Prepayment Invoice" THEN
                    DocumentText := USText001;

                FormatAddress.SalesInvBillTo(BillToAddress, "Sales Invoice Header");
                FormatAddress.SalesInvShipTo(ShipToAddress, ShipToAddress, "Sales Invoice Header");

                IF "Payment Terms Code" = '' THEN
                    CLEAR(PaymentTerms)
                ELSE
                    PaymentTerms.GET("Payment Terms Code");

                IF "Shipment Method Code" = '' THEN
                    CLEAR(ShipmentMethod)
                ELSE
                    ShipmentMethod.GET("Shipment Method Code");


                IF LogInteraction THEN
                    IF NOT CurrReport.PREVIEW THEN BEGIN
                        IF "Bill-to Contact No." <> '' THEN
                            SegManagement.LogDocument(
                              4, "No.", 0, 0, DATABASE::Contact, "Bill-to Contact No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '')
                        ELSE
                            SegManagement.LogDocument(
                              4, "No.", 0, 0, DATABASE::Customer, "Bill-to Customer No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '');
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
                    SalesTaxCalc.StartSalesTaxCalculation;
                    IF TaxArea."Use External Tax Engine" THEN
                        SalesTaxCalc.CallExternalTaxEngineForDoc(DATABASE::"Sales Invoice Header", 0, "No.")
                    ELSE BEGIN
                        SalesTaxCalc.AddSalesInvoiceLines("No.");
                        SalesTaxCalc.EndSalesTaxCalculation("Posting Date");
                    END;
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
                //>>SPD AK 01232014
                IF Customer1.GET("Bill-to Customer No.") THEN
                    PhoneNo := Customer1."Phone No.";
                //<<SPD AK 01232014
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
                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ApplicationArea = all;
                    }
                    field(DisplayAsmInfo; DisplayAssemblyInformation)
                    {
                        Caption = 'Show Assembly Components';
                        ApplicationArea = all;
                    }
                    field(ShowEmbLogo; ShowEmbLogo)
                    {
                        Caption = 'Show Emb. Logo';
                        ApplicationArea = all;
                    }
                    field(GLAccountPrint; GLAccountPrint)
                    {
                        Caption = 'Print G/L Account';
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
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
            ShowEmbLogo := TRUE;
            GLAccountPrint := TRUE;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin

        PrintCompany := TRUE;
        ShipmentLine.SETCURRENTKEY("Order No.", "Order Line No.");
        IF NOT CurrReport.USEREQUESTPAGE THEN
            InitLogInteraction;

        CompanyInformation.GET;
        SalesSetup.GET;

        CASE SalesSetup."Logo Position on Documents" OF
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                BEGIN
                    CompanyInfo3.GET;
                    IF NOT ShowEmbLogo THEN
                        CompanyInfo3.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Center:
                BEGIN
                    CompanyInfo1.GET;
                    IF NOT ShowEmbLogo THEN
                        CompanyInfo1.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Right:
                BEGIN
                    CompanyInfo2.GET;
                    IF NOT ShowEmbLogo THEN
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
        OrderedQuantity: Decimal;
        UnitPriceToPrint: Decimal;
        AmountExclInvDisc: Decimal;
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
        OrderLine: Record "Sales Line";
        ShipmentLine: Record "Sales Shipment Line";
        TempSalesInvoiceLine: Record "Sales Invoice Line" temporary;
        TempSalesInvoiceLineAsm: Record "Sales Invoice Line" temporary;
        RespCenter: Record "Responsibility Center";
        Languagemgmt: Codeunit Language;
        TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
        TaxArea: Record "Tax Area";
        Cust: Record Customer;
        TempPostedAsmLine: Record "Posted Assembly Line" temporary;
        CompanyAddress: array[8] of Text[50];
        BillToAddress: array[8] of Text[50];
        ShipToAddress: array[8] of Text[50];
        CopyTxt: Text[10];
        DescriptionToPrint: Text[210];
        HighDescriptionToPrint: Text[210];
        LowDescriptionToPrint: Text[210];
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
        SalesInvPrinted: Codeunit "Sales Inv.-Printed";
        FormatAddress: Codeunit "Format Address";
        SalesTaxCalc: Codeunit "Sales Tax Calculate";
        SegManagement: Codeunit SegManagement;
        LogInteraction: Boolean;
        Text000: Label 'COPY';
        TaxRegNo: Text[30];
        TaxRegLabel: Text[30];
        TotalTaxLabel: Text[30];
        BreakdownTitle: Text[30];
        BreakdownLabel: array[4] of Text[30];
        BreakdownAmt: array[4] of Decimal;
        Text003: Label 'Sales Tax Breakdown:';
        Text004: Label 'Other Taxes';
        BrkIdx: Integer;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
        Text005: Label 'Total Sales Tax:';
        Text006: Label 'Tax Breakdown:';
        Text007: Label 'Total Tax:';
        Text008: Label 'Tax:';
        Text009: Label 'VOID INVOICE';
        DocumentText: Text[20];
        USText000: Label 'INVOICE';
        USText001: Label 'PREPAYMENT REQUEST';

        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        BillCaptionLbl: Label 'Sold To:';
        ToCaptionLbl: Label 'To:';
        ShipViaCaptionLbl: Label 'Ship Via:';
        ShipDateCaptionLbl: Label 'Ship Date:';
        DueDateCaptionLbl: Label 'Due Date:';
        TermsCaptionLbl: Label 'Terms';
        CustomerIDCaptionLbl: Label 'Customer ID';
        PONumberCaptionLbl: Label 'P.O. Number';
        PODateCaptionLbl: Label 'Order Date:';
        OurOrderNoCaptionLbl: Label 'Order Number:';
        SalesPersonCaptionLbl: Label 'Salesperson:';
        ShipCaptionLbl: Label 'Ship To:';
        InvoiceNumberCaptionLbl: Label 'Invoice Number:';
        InvoiceDateCaptionLbl: Label 'Invoice Date:';
        PageCaptionLbl: Label 'Page:';
        TaxIdentTypeCaptionLbl: Label 'Tax Ident. Type';
        ItemDescriptionCaptionLbl: Label 'Item';
        UnitCaptionLbl: Label 'Unit';
        OrderQtyCaptionLbl: Label 'Ordered';
        QuantityCaptionLbl: Label 'Shipped';
        UnitPriceCaptionLbl: Label 'Price';
        TotalPriceCaptionLbl: Label 'Amount';
        SubtotalCaptionLbl: Label 'Subtotal:';
        InvoiceDiscountCaptionLbl: Label 'Invoice Discount:';
        TotalCaptionLbl: Label 'Invoice Total:';
        AmountSubjecttoSalesTaxCaptionLbl: Label 'Amount Subject to Sales Tax';
        AmountExemptfromSalesTaxCaptionLbl: Label 'Amount Exempt from Sales Tax';
        CustContNumber: Label 'Customer Number :';
        Customer1: Record Customer;
        PhoneNo: Text;
        ConfirmTo: Label 'Confirm To:';
        "---VK-----": Integer;
        recCustomer: Record Customer;
        recCountry: Record "Country/Region";
        recCountry2: Record "Country/Region";
        recPmtTerms: Record "Payment Terms";
        ItemNoCap: Label 'No.';
        Description2Cap: Label 'Description';
        AccountCodetxt: Text[100];
        AccountCode: Text[100];
        Discounttxt: Label 'Discount';
        intLineCount: Integer;
        txtProductGroup: Code[20];
        recStandardComment: Record "Standard Comment";
        txtComment: array[256] of Text[250];
        intCommentLine: Integer;
        recSalesLine: Record "Sales Invoice Line";
        decLineAmount: Decimal;
        decTotalAmount: Decimal;
        decDiscountAmount: Decimal;
        intLineCount1: Integer;
        txtAlis: Text[50];
        recItemCust: Record "Item Customer";
        txtAlisDes: Text[50];
        ItemName: Text[81];
        ItemDes: Text[81];
        recSalesLineComments: Record "Sales Comment Line";
        TempSalesLine: Record "Sales Invoice Line";
        recSalesHeaderComments: Record "Sales Comment Line";
        HEADERCOMMENT: Text;
        INLINEN: Integer;
        ShowEmbLogo: Boolean;
        GLAccountPrint: Boolean;


    procedure InitLogInteraction()
    var
        DocumentType: Enum "Interaction Log Entry Document Type";
    begin
        LogInteraction := SegManagement.FindInteractionTemplateCode(DocumentType::"Sales Inv.") <> '';
    end;


    procedure CollectAsmInformation(TempSalesInvoiceLine: Record "Sales Invoice Line" temporary)
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        TempPostedAsmLine.DELETEALL;
        IF NOT DisplayAssemblyInformation THEN
            EXIT;
        IF NOT TempSalesInvoiceLineAsm.GET(TempSalesInvoiceLine."Document No.", TempSalesInvoiceLine."Line No.") THEN
            EXIT;
        SalesInvoiceLine.GET(TempSalesInvoiceLineAsm."Document No.", TempSalesInvoiceLineAsm."Line No.");
        IF SalesInvoiceLine.Type <> SalesInvoiceLine.Type::Item THEN
            EXIT;
        WITH ValueEntry DO BEGIN
            SETCURRENTKEY("Document No.");
            SETRANGE("Document No.", SalesInvoiceLine."Document No.");
            SETRANGE("Document Type", "Document Type"::"Sales Invoice");
            SETRANGE("Document Line No.", SalesInvoiceLine."Line No.");
            IF NOT FINDSET THEN
                EXIT;
        END;
        REPEAT
            IF ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") THEN BEGIN
                IF ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Shipment" THEN BEGIN
                    SalesShipmentLine.GET(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.");
                    IF SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) THEN BEGIN
                        PostedAsmLine.SETRANGE("Document No.", PostedAsmHeader."No.");
                        IF PostedAsmLine.FINDSET THEN
                            REPEAT
                                TreatAsmLineBuffer(PostedAsmLine);
                            UNTIL PostedAsmLine.NEXT = 0;
                    END;
                END;
            END;
        UNTIL ValueEntry.NEXT = 0;
    end;


    procedure TreatAsmLineBuffer(PostedAsmLine: Record "Posted Assembly Line")
    begin
        CLEAR(TempPostedAsmLine);
        TempPostedAsmLine.SETRANGE(Type, PostedAsmLine.Type);
        TempPostedAsmLine.SETRANGE("No.", PostedAsmLine."No.");
        TempPostedAsmLine.SETRANGE("Variant Code", PostedAsmLine."Variant Code");
        TempPostedAsmLine.SETRANGE(Description, PostedAsmLine.Description);
        TempPostedAsmLine.SETRANGE("Unit of Measure Code", PostedAsmLine."Unit of Measure Code");
        IF TempPostedAsmLine.FINDFIRST THEN BEGIN
            TempPostedAsmLine.Quantity += PostedAsmLine.Quantity;
            TempPostedAsmLine.MODIFY;
        END ELSE BEGIN
            CLEAR(TempPostedAsmLine);
            TempPostedAsmLine := PostedAsmLine;
            TempPostedAsmLine.INSERT;
        END;
    end;


    procedure GetUOMText(UOMCode: Code[10]): Text[10]
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


    procedure Init(NoCopies1: Integer)
    begin
        NoCopies := NoCopies1;
    end;
}

