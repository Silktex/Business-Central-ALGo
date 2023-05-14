report 60503 "Sales Shipment Ext"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/60503_Report_SalesShipment.rdl';
    Caption = 'Sales Shipment';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Sell-to Customer No.", "Bill-to Customer No.", "Ship-to Code", "No. Printed";
            RequestFilterHeading = 'Sales Shipment';
            column(No_SalesShptHeader; "No.")
            {
            }
            column(txtTrackingNo; txtTrackingNo)
            {
            }
            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");
                dataitem(SalesLineComments; "Sales Comment Line")
                {
                    DataItemLink = "No." = FIELD("Document No."), "Document Line No." = FIELD("Line No.");
                    DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = CONST(Shipment), "Print On Shipment" = CONST(true));

                    trigger OnAfterGetRecord()
                    begin
                        WITH TempSalesShipmentLine DO BEGIN
                            INIT;
                            "Document No." := "Sales Shipment Header"."No.";
                            "Line No." := HighestLineNo + 10;
                            HighestLineNo := "Line No.";
                        END;
                        IF STRLEN(Comment) <= MAXSTRLEN(TempSalesShipmentLine.Description) THEN BEGIN
                            TempSalesShipmentLine.Description := Comment;
                            TempSalesShipmentLine."Description 2" := '';
                        END ELSE BEGIN
                            SpacePointer := MAXSTRLEN(TempSalesShipmentLine.Description) + 1;
                            WHILE (SpacePointer > 1) AND (Comment[SpacePointer] <> ' ') DO
                                SpacePointer := SpacePointer - 1;
                            IF SpacePointer = 1 THEN
                                SpacePointer := MAXSTRLEN(TempSalesShipmentLine.Description) + 1;
                            TempSalesShipmentLine.Description := COPYSTR(Comment, 1, SpacePointer - 1);
                            TempSalesShipmentLine."Description 2" :=
                              COPYSTR(COPYSTR(Comment, SpacePointer + 1), 1, MAXSTRLEN(TempSalesShipmentLine."Description 2"));
                        END;
                        TempSalesShipmentLine.INSERT;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    TempSalesShipmentLine := "Sales Shipment Line";
                    TempSalesShipmentLine.INSERT;
                    TempSalesShipmentLineAsm := "Sales Shipment Line";
                    TempSalesShipmentLineAsm.INSERT;
                    HighestLineNo := "Line No.";
                end;

                trigger OnPreDataItem()
                begin
                    TempSalesShipmentLine.RESET;
                    TempSalesShipmentLine.DELETEALL;
                    TempSalesShipmentLineAsm.RESET;
                    TempSalesShipmentLineAsm.DELETEALL;
                end;
            }
            dataitem("Sales Comment Line"; "Sales Comment Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = CONST(Shipment), "Print On Shipment" = CONST(true), "Document Line No." = CONST(0));

                trigger OnAfterGetRecord()
                begin
                    WITH TempSalesShipmentLine DO BEGIN
                        INIT;
                        "Document No." := "Sales Shipment Header"."No.";
                        "Line No." := HighestLineNo + 1000;
                        HighestLineNo := "Line No.";
                    END;
                    IF STRLEN(Comment) <= MAXSTRLEN(TempSalesShipmentLine.Description) THEN BEGIN
                        TempSalesShipmentLine.Description := Comment;
                        TempSalesShipmentLine."Description 2" := '';
                    END ELSE BEGIN
                        SpacePointer := MAXSTRLEN(TempSalesShipmentLine.Description) + 1;
                        WHILE (SpacePointer > 1) AND (Comment[SpacePointer] <> ' ') DO
                            SpacePointer := SpacePointer - 1;
                        IF SpacePointer = 1 THEN
                            SpacePointer := MAXSTRLEN(TempSalesShipmentLine.Description) + 1;
                        TempSalesShipmentLine.Description := COPYSTR(Comment, 1, SpacePointer - 1);
                        TempSalesShipmentLine."Description 2" :=
                          COPYSTR(COPYSTR(Comment, SpacePointer + 1), 1, MAXSTRLEN(TempSalesShipmentLine."Description 2"));
                    END;
                    TempSalesShipmentLine.INSERT;
                end;

                trigger OnPreDataItem()
                begin
                    WITH TempSalesShipmentLine DO BEGIN
                        INIT;
                        "Document No." := "Sales Shipment Header"."No.";
                        "Line No." := HighestLineNo + 1000;
                        HighestLineNo := "Line No.";
                    END;
                    TempSalesShipmentLine.INSERT;
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
                    column(CopyTxt; CopyTxt)
                    {
                    }
                    column(Shipping_Agent_Code; "Sales Shipment Header"."Shipping Agent Code")
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
                    column(BilltoName_SalesShipmentHeader; "Sales Shipment Header"."Bill-to Name")
                    {
                    }
                    column(BilltoAddress_SalesShipmentHeader; "Sales Shipment Header"."Bill-to Address")
                    {
                    }
                    column(BilltoAddress2_SalesShipmentHeader; "Sales Shipment Header"."Bill-to Address 2")
                    {
                    }
                    column(BilltoCity_SalesShipmentHeader; "Sales Shipment Header"."Bill-to City")
                    {
                    }
                    column(BilltoPostCode_SalesShipmentHeader; "Sales Shipment Header"."Bill-to Post Code")
                    {
                    }
                    column(BilltoCounty_SalesShipmentHeader; "Sales Shipment Header"."Bill-to County")
                    {
                    }
                    column(BilltoCountryRegionCode_SalesShipmentHeader; "Sales Shipment Header"."Bill-to Country/Region Code")
                    {
                    }
                    column(ShiptoName_SalesShipmentHeader; "Sales Shipment Header"."Ship-to Name")
                    {
                    }
                    column(ShiptoAddress_SalesShipmentHeader; "Sales Shipment Header"."Ship-to Address")
                    {
                    }
                    column(ShiptoAddress2_SalesShipmentHeader; "Sales Shipment Header"."Ship-to Address 2")
                    {
                    }
                    column(ShiptoCity_SalesShipmentHeader; "Sales Shipment Header"."Ship-to City")
                    {
                    }
                    column(ShiptoPostCode_SalesShipmentHeader; "Sales Shipment Header"."Ship-to Post Code")
                    {
                    }
                    column(ShiptoCounty_SalesShipmentHeader; "Sales Shipment Header"."Ship-to County")
                    {
                    }
                    column(ShiptoCountryRegionCode_SalesShipmentHeader; "Sales Shipment Header"."Ship-to Country/Region Code")
                    {
                    }
                    column(BilltoCustNo_SalesShptHeader; "Sales Shipment Header"."Bill-to Customer No.")
                    {
                    }
                    column(SalesShipmentHeader_ExternalDocumentNo; "Sales Shipment Header"."External Document No.")
                    {
                    }
                    column(YourRef_SalesShptHeader; "Sales Shipment Header"."Your Reference")
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(ShptDate_SalesShptHeader; "Sales Shipment Header"."Posting Date")
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
                    column(OrderDate_SalesShptHeader; "Sales Shipment Header"."Order Date")
                    {
                    }
                    column(OrderNo_SalesShptHeader; "Sales Shipment Header"."Order No.")
                    {
                    }
                    column(PackageTrackingNoText; PackageTrackingNoText)
                    {
                    }
                    column(ShippingAgentCodeText; ShippingAgentCodeText)
                    {
                    }
                    column(ShippingAgentCodeLabel; ShippingAgentCodeLabel)
                    {
                    }
                    column(PackageTrackingNoLabel; PackageTrackingNoLabel)
                    {
                    }
                    column(TaxRegNo; TaxRegNo)
                    {
                    }
                    column(TaxRegLabel; TaxRegLabel)
                    {
                    }
                    column(CopyNo; CopyNo)
                    {
                    }
                    column(PageLoopNumber; Number)
                    {
                    }
                    column(BillCaption; BillCaptionLbl)
                    {
                    }
                    column(ToCaption; ToCaptionLbl)
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
                    column(ShipmentCaption; ShipmentCaptionLbl)
                    {
                    }
                    column(ShipmentNumberCaption; ShipmentNumberCaptionLbl)
                    {
                    }
                    column(ShipmentDateCaption; ShipmentDateCaptionLbl)
                    {
                    }
                    column(PageCaption; PageCaptionLbl)
                    {
                    }
                    column(ShipViaCaption; ShipViaCaptionLbl)
                    {
                    }
                    column(PODateCaption; PODateCaptionLbl)
                    {
                    }
                    column(OurOrderNoCaption; OurOrderNoCaptionLbl)
                    {
                    }
                    dataitem(SalesShptLine; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(SalesShptLineNumber; Number)
                        {
                        }
                        column(TempSalesShptLineNo; TempSalesShipmentLine."No.")
                        {
                        }
                        column(TempSalesShptLineUOM; TempSalesShipmentLine."Unit of Measure")
                        {
                        }
                        column(TempSalesShptLineQy; TempSalesShipmentLine.Quantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(OrderedQuantity; OrderedQuantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(BackOrderedQuantity; BackOrderedQuantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(TempSalesShptLineDesc; TempSalesShipmentLine.Description + ' ' + TempSalesShipmentLine."Description 2")
                        {
                        }
                        column(PackageTrackingText; PackageTrackingText)
                        {
                            //DecimalPlaces = 0 : 5;
                        }
                        column(AsmHeaderExists; AsmHeaderExists)
                        {
                        }
                        column(PrintFooter; PrintFooter)
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
                        column(ShippedCaption; ShippedCaptionLbl)
                        {
                        }
                        column(OrderedCaption; OrderedCaptionLbl)
                        {
                        }
                        column(BackOrderedCaption; BackOrderedCaptionLbl)
                        {
                        }
                        column(CustRef; TempSalesShipmentLine."Item Reference No.")
                        {
                        }
                        dataitem(AsmLoop; "Integer")
                        {
                            DataItemTableView = SORTING(Number);
                            column(PostedAsmLineItemNo; BlanksForIndent + PostedAsmLine."No.")
                            {
                            }
                            column(PostedAsmLineDescription; BlanksForIndent + PostedAsmLine.Description)
                            {
                            }
                            column(PostedAsmLineQuantity; PostedAsmLine.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(PostedAsmLineUOMCode; GetUnitOfMeasureDescr(PostedAsmLine."Unit of Measure Code"))
                            {
                                // DecimalPlaces = 0 : 5;
                            }

                            trigger OnAfterGetRecord()
                            begin
                                IF Number = 1 THEN
                                    PostedAsmLine.FINDSET
                                ELSE
                                    PostedAsmLine.NEXT;
                            end;

                            trigger OnPreDataItem()
                            begin
                                IF NOT DisplayAssemblyInformation THEN
                                    CurrReport.BREAK;
                                IF NOT AsmHeaderExists THEN
                                    CurrReport.BREAK;
                                PostedAsmLine.SETRANGE("Document No.", PostedAsmHeader."No.");
                                SETRANGE(Number, 1, PostedAsmLine.COUNT);
                            end;
                        }
                        dataitem(LotNo; "Integer")
                        {
                            DataItemTableView = SORTING(Number);
                            column(ItemLedgerEntry_ItemNo; recItemLedgerEntry."Item No.")
                            {
                            }
                            column(ItemLedgerEntry_LotNo; recItemLedgerEntry."Lot No.")
                            {
                            }
                            column(ItemLedgerEntry_Quantity; -recItemLedgerEntry.Quantity)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                IF Number = 1 THEN
                                    recItemLedgerEntry.FINDSET
                                ELSE
                                    recItemLedgerEntry.NEXT;
                            end;

                            trigger OnPreDataItem()
                            begin
                                recItemLedgerEntry.SETRANGE("Document No.", TempSalesShipmentLine."Document No.");
                                recItemLedgerEntry.SETRANGE("Item No.", TempSalesShipmentLine."No.");
                                recItemLedgerEntry.SETRANGE("Variant Code", TempSalesShipmentLine."Variant Code");
                                recItemLedgerEntry.SETRANGE("Document Line No.", TempSalesShipmentLine."Line No.");
                                SETRANGE(Number, 1, recItemLedgerEntry.COUNT);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            SalesShipmentLine: Record "Sales Shipment Line";
                        begin
                            OnLineNumber := OnLineNumber + 1;

                            WITH TempSalesShipmentLine DO BEGIN
                                IF OnLineNumber = 1 THEN
                                    FIND('-')
                                ELSE
                                    NEXT;

                                OrderedQuantity := 0;
                                BackOrderedQuantity := 0;
                                IF "Order No." = '' THEN
                                    OrderedQuantity := Quantity
                                ELSE BEGIN
                                    IF OrderLine.GET(1, "Order No.", "Order Line No.") THEN BEGIN
                                        OrderedQuantity := OrderLine.Quantity;
                                        BackOrderedQuantity := OrderLine."Outstanding Quantity";
                                    END ELSE BEGIN
                                        ReceiptLine.SETCURRENTKEY("Order No.", "Order Line No.");
                                        ReceiptLine.SETRANGE("Order No.", "Order No.");
                                        ReceiptLine.SETRANGE("Order Line No.", "Order Line No.");
                                        ReceiptLine.FIND('-');
                                        REPEAT
                                            OrderedQuantity := OrderedQuantity + ReceiptLine.Quantity;
                                        UNTIL 0 = ReceiptLine.NEXT;
                                    END;
                                END;

                                IF Type = 0 THEN BEGIN
                                    OrderedQuantity := 0;
                                    BackOrderedQuantity := 0;
                                    "No." := '';
                                    "Unit of Measure" := '';
                                    Quantity := 0;
                                END ELSE
                                    IF Type = Type::"G/L Account" THEN
                                        "No." := '';

                                PackageTrackingText := '';
                                IF ("Package Tracking No." <> "Sales Shipment Header"."Package Tracking No.") AND
                                   ("Package Tracking No." <> '') AND PrintPackageTrackingNos
                                THEN
                                    PackageTrackingText := Text002 + ' ' + "Package Tracking No.";

                                IF DisplayAssemblyInformation THEN
                                    IF TempSalesShipmentLineAsm.GET("Document No.", "Line No.") THEN BEGIN
                                        SalesShipmentLine.GET("Document No.", "Line No.");
                                        AsmHeaderExists := SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader);
                                    END;
                            END;

                            ///

                            IF OnLineNumber = NumberOfLines THEN
                                PrintFooter := TRUE;
                        end;

                        trigger OnPreDataItem()
                        begin
                            NumberOfLines := TempSalesShipmentLine.COUNT;
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
                            SalesShipmentPrinted.RUN("Sales Shipment Header");
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
                IF PrintCompany THEN
                    IF RespCenter.GET("Responsibility Center") THEN BEGIN
                        FormatAddress.RespCenter(CompanyAddress, RespCenter);
                        CompanyInformation."Phone No." := RespCenter."Phone No.";
                        CompanyInformation."Fax No." := RespCenter."Fax No.";
                    END;

                if "Language Code" <> '' then
                    CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                IF "Salesperson Code" = '' THEN
                    CLEAR(SalesPurchPerson)
                ELSE
                    SalesPurchPerson.GET("Salesperson Code");

                IF "Shipment Method Code" = '' THEN
                    CLEAR(ShipmentMethod)
                ELSE
                    ShipmentMethod.GET("Shipment Method Code");

                IF "Sell-to Customer No." = '' THEN BEGIN
                    "Bill-to Name" := Text009;
                    "Ship-to Name" := Text009;
                END;
                IF NOT Cust.GET("Sell-to Customer No.") THEN
                    CLEAR(Cust);

                FormatAddress.SalesShptBillTo(BillToAddress, BillToAddress, "Sales Shipment Header");
                FormatAddress.SalesShptShipTo(ShipToAddress, "Sales Shipment Header");

                ShippingAgentCodeLabel := '';
                ShippingAgentCodeText := '';
                PackageTrackingNoLabel := '';
                PackageTrackingNoText := '';
                IF PrintPackageTrackingNos THEN BEGIN
                    // ShippingAgentCodeLabel := Text003;
                    // ShippingAgentCodeText := "Sales Shipment Header"."Shipping Agent Code";
                    PackageTrackingNoLabel := Text001;
                    PackageTrackingNoText := "Sales Shipment Header"."Package Tracking No.";
                END;
                IF LogInteraction THEN
                    IF NOT CurrReport.PREVIEW THEN
                        SegManagement.LogDocument(
                          5, "No.", 0, 0, DATABASE::Customer, "Sell-to Customer No.",
                          "Salesperson Code", "Campaign No.", "Posting Description", '');
                TaxRegNo := '';
                TaxRegLabel := '';
                IF "Tax Area Code" <> '' THEN BEGIN
                    TaxArea.GET("Tax Area Code");
                    CASE TaxArea."Country/Region" OF
                        TaxArea."Country/Region"::US:
                            ;
                        TaxArea."Country/Region"::CA:
                            BEGIN
                                TaxRegNo := CompanyInformation."VAT Registration No.";
                                TaxRegLabel := CompanyInformation.FIELDCAPTION("VAT Registration No.");
                            END;
                    END;
                END;

                txtTrackingNo := '';
                recPWSL.RESET;
                recPWSL.SETRANGE("Posted Source Document", recPWSL."Posted Source Document"::"Posted Shipment");
                recPWSL.SETRANGE("Posted Source No.", "No.");
                IF recPWSL.FIND('-') THEN
                    recTrackingNo.RESET;
                recTrackingNo.SETRANGE(recTrackingNo."Warehouse Shipment No", recPWSL."Whse. Shipment No.");
                IF recTrackingNo.FIND('-') THEN
                    txtTrackingNo := recTrackingNo."Tracking No.";
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
                    field(PrintPackageTrackingNos; PrintPackageTrackingNos)
                    {
                        Caption = 'Print Package Tracking Nos.';
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
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
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
        IF PrintCompany THEN
            FormatAddress.Company(CompanyAddress, CompanyInformation)
        ELSE
            CLEAR(CompanyAddress);
    end;

    trigger OnPreReport()
    begin
        IF NOT CurrReport.USEREQUESTPAGE THEN
            InitLogInteraction;

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
        OrderedQuantity: Decimal;
        BackOrderedQuantity: Decimal;
        ShipmentMethod: Record "Shipment Method";
        ReceiptLine: Record "Sales Shipment Line";
        OrderLine: Record "Sales Line";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        CompanyInfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        TempSalesShipmentLine: Record "Sales Shipment Line" temporary;
        TempSalesShipmentLineAsm: Record "Sales Shipment Line" temporary;
        RespCenter: Record "Responsibility Center";
        Language: Codeunit Language;
        TaxArea: Record "Tax Area";
        Cust: Record Customer;
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        CompanyAddress: array[8] of Text[50];
        BillToAddress: array[8] of Text[50];
        ShipToAddress: array[8] of Text[50];
        CopyTxt: Text[10];

        [InDataSet]
        PrintCompany: Boolean;
        PrintFooter: Boolean;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        HighestLineNo: Integer;
        SpacePointer: Integer;
        SalesShipmentPrinted: Codeunit "Sales Shpt.-Printed";
        FormatAddress: Codeunit "Format Address";
        PackageTrackingText: Text[100];
        PrintPackageTrackingNos: Boolean;
        PackageTrackingNoText: Text[50];
        PackageTrackingNoLabel: Text[50];
        ShippingAgentCodeText: Text[50];
        ShippingAgentCodeLabel: Text[50];
        SegManagement: Codeunit SegManagement;
        LogInteraction: Boolean;
        Text000: Label 'COPY';
        Text001: Label 'Tracking No.';
        Text002: Label 'Specific Tracking No.';
        Text003: Label 'Shipping Agent';
        TaxRegNo: Text[30];
        TaxRegLabel: Text[30];
        Text009: Label 'VOID SHIPMENT';
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        AsmHeaderExists: Boolean;
        BillCaptionLbl: Label 'Bill';
        ToCaptionLbl: Label 'To:';
        CustomerIDCaptionLbl: Label 'Customer ID';
        PONumberCaptionLbl: Label 'P.O. Number';
        SalesPersonCaptionLbl: Label 'SalesPerson';
        ShipCaptionLbl: Label 'Ship';
        ShipmentCaptionLbl: Label 'Shipment Advice';
        ShipmentNumberCaptionLbl: Label 'Shipment Number:';
        ShipmentDateCaptionLbl: Label 'Posting Date:';
        PageCaptionLbl: Label 'Page:';
        ShipViaCaptionLbl: Label 'Incoterms:';
        PODateCaptionLbl: Label 'P.O. Date';
        OurOrderNoCaptionLbl: Label 'Our Order No.';
        ItemNoCaptionLbl: Label 'Item No.';
        UnitCaptionLbl: Label 'Unit';
        DescriptionCaptionLbl: Label 'Description';
        ShippedCaptionLbl: Label 'Shipped';
        OrderedCaptionLbl: Label 'Ordered';
        BackOrderedCaptionLbl: Label 'Back Ordered';
        recItemLedgerEntry: Record "Item Ledger Entry";
        recPWSL: Record "Posted Whse. Shipment Line";
        recTrackingNo: Record "Tracking No.";
        txtTrackingNo: Text[30];


    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(5) <> '';
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

