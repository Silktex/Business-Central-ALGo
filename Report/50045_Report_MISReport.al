report 50045 "MIS Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50045_Report_MISReport.rdlc';
    Caption = 'MIS';
    UsageCategory = Administration;
    ApplicationArea = all;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Document Type", "Customer No.", "Posting Date", "Currency Code") WHERE("Document Type" = FILTER(Payment | Refund));
            column(EntryNo_CustLedgEntry; "Entry No.")
            {
            }
            dataitem(PageLoop; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(CustomerNo_CustLedgEntry; "Cust. Ledger Entry"."Customer No.")
                {
                    IncludeCaption = true;
                }
                column(Name_Cust; Cust.Name)
                {
                }
                column(DocDate_CustLedgEntry; FORMAT("Cust. Ledger Entry"."Document Date"))
                {
                }
                column(DocumentNo_CustLedgEntry; "Cust. Ledger Entry"."Document No.")
                {
                }
                dataitem(DetailedCustLedgEntry1; "Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Applied Cust. Ledger Entry No." = FIELD("Entry No.");
                    DataItemLinkReference = "Cust. Ledger Entry";
                    DataItemTableView = SORTING("Applied Cust. Ledger Entry No.", "Entry Type") WHERE(Unapplied = CONST(false));
                    dataitem(CustLedgEntry1; "Cust. Ledger Entry")
                    {
                        DataItemLink = "Entry No." = FIELD("Cust. Ledger Entry No.");
                        DataItemLinkReference = DetailedCustLedgEntry1;
                        DataItemTableView = SORTING("Entry No.");
                        column(PostDate_CustLedgEntry1; FORMAT("Posting Date"))
                        {
                        }
                        column(DocType_CustLedgEntry1; "Document Type")
                        {
                            IncludeCaption = true;
                        }
                        column(DocumentNo_CustLedgEntry1; "Document No.")
                        {
                            IncludeCaption = true;
                        }
                        column(Desc_CustLedgEntry1; Description)
                        {
                            IncludeCaption = true;
                        }
                        column(CurrCode_CustLedgEntry1; CurrencyCode("Currency Code"))
                        {
                        }
                        column(ShowAmount; ShowAmount)
                        {
                        }
                        column(PmtDiscInvCurr; PmtDiscInvCurr)
                        {
                        }
                        column(PmtTolInvCurr; PmtTolInvCurr)
                        {
                        }
                        column(CurrencyCodeCaption; FIELDCAPTION("Currency Code"))
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF "Entry No." = "Cust. Ledger Entry"."Entry No." THEN
                                CurrReport.SKIP;

                            PmtDiscInvCurr := 0;
                            PmtTolInvCurr := 0;
                            PmtDiscPmtCurr := 0;
                            PmtTolPmtCurr := 0;

                            ShowAmount := -DetailedCustLedgEntry1.Amount;

                            IF "Cust. Ledger Entry"."Currency Code" <> "Currency Code" THEN BEGIN
                                PmtDiscInvCurr := ROUND("Pmt. Disc. Given (LCY)" * "Original Currency Factor");
                                PmtTolInvCurr := ROUND("Pmt. Tolerance (LCY)" * "Original Currency Factor");
                                AppliedAmount :=
                                  ROUND(
                                    -DetailedCustLedgEntry1.Amount / "Original Currency Factor" *
                                    "Cust. Ledger Entry"."Original Currency Factor", Currency."Amount Rounding Precision");
                            END ELSE BEGIN
                                PmtDiscInvCurr := ROUND("Pmt. Disc. Given (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");
                                PmtTolInvCurr := ROUND("Pmt. Tolerance (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");
                                AppliedAmount := -DetailedCustLedgEntry1.Amount;
                            END;

                            PmtDiscPmtCurr := ROUND("Pmt. Disc. Given (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");
                            PmtTolPmtCurr := ROUND("Pmt. Tolerance (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");

                            RemainingAmount := (RemainingAmount - AppliedAmount) + PmtDiscPmtCurr + PmtTolPmtCurr;
                        end;
                    }
                }
                dataitem(DetailedCustLedgEntry2; "Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Cust. Ledger Entry No." = FIELD("Entry No.");
                    DataItemLinkReference = "Cust. Ledger Entry";
                    DataItemTableView = SORTING("Cust. Ledger Entry No.", "Entry Type", "Posting Date") WHERE(Unapplied = CONST(false));
                    dataitem(CustLedgEntry2; "Cust. Ledger Entry")
                    {
                        DataItemLink = "Entry No." = FIELD("Applied Cust. Ledger Entry No.");
                        DataItemLinkReference = DetailedCustLedgEntry2;
                        DataItemTableView = SORTING("Entry No.");
                        column(AppliedAmount; AppliedAmount)
                        {
                        }
                        column(Desc_CustLedgEntry2; Description)
                        {
                        }
                        column(DocumentNo_CustLedgEntry2; "Document No.")
                        {
                        }
                        column(DocType_CustLedgEntry2; "Document Type")
                        {
                        }
                        column(PostDate_CustLedgEntry2; FORMAT("Posting Date"))
                        {
                        }
                        column(PmtDiscInvCurr1; PmtDiscInvCurr)
                        {
                        }
                        column(PmtTolInvCurr1; PmtTolInvCurr)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF "Entry No." = "Cust. Ledger Entry"."Entry No." THEN
                                CurrReport.SKIP;

                            PmtDiscInvCurr := 0;
                            PmtTolInvCurr := 0;
                            PmtDiscPmtCurr := 0;
                            PmtTolPmtCurr := 0;

                            ShowAmount := DetailedCustLedgEntry2.Amount;

                            IF "Cust. Ledger Entry"."Currency Code" <> "Currency Code" THEN BEGIN
                                PmtDiscInvCurr := ROUND("Pmt. Disc. Given (LCY)" * "Original Currency Factor");
                                PmtTolInvCurr := ROUND("Pmt. Tolerance (LCY)" * "Original Currency Factor");
                            END ELSE BEGIN
                                PmtDiscInvCurr := ROUND("Pmt. Disc. Given (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");
                                PmtTolInvCurr := ROUND("Pmt. Tolerance (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");
                            END;

                            PmtDiscPmtCurr := ROUND("Pmt. Disc. Given (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");
                            PmtTolPmtCurr := ROUND("Pmt. Tolerance (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");

                            AppliedAmount := DetailedCustLedgEntry2.Amount;
                            RemainingAmount := (RemainingAmount - AppliedAmount) + PmtDiscPmtCurr + PmtTolPmtCurr;
                        end;
                    }
                }
                dataitem(Total; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(RemainingAmount; RemainingAmount)
                    {
                    }
                    column(CurrCode_CustLedgEntry; CurrencyCode("Cust. Ledger Entry"."Currency Code"))
                    {
                    }
                    column(OriginalAmt_CustLedgEntry; "Cust. Ledger Entry"."Original Amount")
                    {
                    }
                    column(ExtDocNo_CustLedgEntry; "Cust. Ledger Entry"."External Document No.")
                    {
                    }
                    column(PaymAmtNotAllocatedCptn; PaymAmtNotAllocatedCptnLbl)
                    {
                    }
                    column(CustLedgEntryOrgAmtCptn; CustLedgEntryOrgAmtCptnLbl)
                    {
                    }
                    column(ExternalDocumentNoCaption; ExternalDocumentNoCaptionLbl)
                    {
                    }
                }
            }

            trigger OnAfterGetRecord()
            begin
                Cust.GET("Customer No.");
                FormatAddr.Customer(CustAddr, Cust);

                IF NOT Currency.GET("Currency Code") THEN
                    Currency.InitRoundingPrecision;

                IF "Document Type" = "Document Type"::Payment THEN BEGIN
                    ReportTitle := Text003;
                    PaymentDiscountTitle := Text006;
                END ELSE BEGIN
                    ReportTitle := Text004;
                    PaymentDiscountTitle := Text007;
                END;

                CALCFIELDS("Original Amount");
                RemainingAmount := -"Original Amount";
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.GET;
                FormatAddr.Company(CompanyAddr, CompanyInfo);
                GLSetup.GET;
                SETRANGE("Posting Date", WORKDATE);
                //SETRANGE("Posting Date",CALCDATE('<-7D>',WORKDATE),WORKDATE);
            end;
        }
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = WHERE("Document Type" = FILTER(Order));
            PrintOnlyIfDetail = true;
            column(No_SalesHeader; "Sales Header"."No.")
            {
            }
            column(OrderDate_SalesHeader; FORMAT("Sales Header"."Order Date"))
            {
            }
            column(SelltoCustomerNo_SalesHeader; "Sales Header"."Sell-to Customer No.")
            {
            }
            column(SelltoCustomerName_SalesHeader; "Sales Header"."Sell-to Customer Name")
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemTableView = WHERE(Type = FILTER(Item));
                column(ShipmentDate_SalesLine; FORMAT("Sales Line"."Shipment Date"))
                {
                }
                column(No_SalesLine; "Sales Line"."No.")
                {
                }
                column(Description_SalesLine; "Sales Line".Description)
                {
                }
                column(Quantity_SalesLine; "Sales Line".Quantity)
                {
                }
                column(UnitPrice_SalesLine; "Sales Line"."Unit Price")
                {
                }
                column(SOSubTotal; "Sales Line".Quantity * "Sales Line"."Unit Price")
                {
                }
                column(OutstandingQuantity_SalesLine; "Sales Line"."Outstanding Quantity")
                {
                }
                column(SOOnHandQty; SOOnHandQty)
                {
                }
                column(SOItemQtyOnPO; SOItemQtyOnPO)
                {
                }
                column(SOItem12MonthSale; SOItem12MonthSale)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SOOnHandQty := 0;
                    SOItem12MonthSale := 0;
                    SOItemQtyOnPO := 0;

                    recILE.RESET;
                    recILE.SETRANGE(recILE."Item No.", "Sales Line"."No.");
                    recILE.SETRANGE(recILE."Location Code", 'BOMMASANDR');
                    recILE.SETFILTER(recILE."Remaining Quantity", '<>%1', 0);
                    IF recILE.FINDFIRST THEN
                        REPEAT
                            SOOnHandQty := SOOnHandQty + recILE."Remaining Quantity";
                        UNTIL recILE.NEXT = 0;

                    recILE.RESET;
                    recILE.SETRANGE(recILE."Item No.", "Sales Line"."No.");
                    recILE.SETRANGE(recILE."Entry Type", recILE."Entry Type"::Sale);
                    recILE.SETFILTER(recILE."Posting Date", '%1..%2', CALCDATE('<-1Y-1D>', WORKDATE), WORKDATE);
                    IF recILE.FINDFIRST THEN
                        REPEAT
                            SOItem12MonthSale := SOItem12MonthSale + recILE.Quantity;
                        UNTIL recILE.NEXT = 0;

                    recPL.RESET;
                    recPL.SETRANGE(recPL."Document Type", "Document Type"::Order);
                    recPL.SETRANGE(recPL."No.", "Sales Line"."No.");
                    recPL.SETRANGE(recPL."Location Code", 'BOMMASANDR');
                    recPL.SETFILTER(recPL."Outstanding Quantity", '<>%1', 0);
                    IF recPL.FINDFIRST THEN
                        REPEAT
                            SOItemQtyOnPO := SOItemQtyOnPO + recPL."Outstanding Quantity";
                        UNTIL recPL.NEXT = 0;
                end;
            }

            trigger OnPreDataItem()
            begin
                SETRANGE("Order Date", WORKDATE);
                //SETRANGE("Order Date",CALCDATE('<-7D>',WORKDATE),WORKDATE);
            end;
        }
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            PrintOnlyIfDetail = true;
            column(No_SalesInvoiceHeader; "Sales Invoice Header"."No.")
            {
            }
            column(PostingDate_SalesInvoiceHeader; FORMAT("Sales Invoice Header"."Posting Date"))
            {
            }
            column(SelltoCustomerNo_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Customer Name")
            {
            }
            column(SelltoCustomerName_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Customer Name")
            {
            }
            column(SelltoCity_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to City")
            {
            }
            column(State_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to County")
            {
            }
            column(SelltoCountryRegionCode_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Country/Region Code")
            {
            }
            column(SalespersonCode_SalesInvoiceHeader; "Sales Invoice Header"."Salesperson Code")
            {
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE(Type = FILTER(Item), Quantity = FILTER(<> 0));
                column(No_SalesInvoiceLine; "Sales Invoice Line"."No.")
                {
                }
                column(Description_SalesInvoiceLine; "Sales Invoice Line".Description)
                {
                }
                column(Quantity_SalesInvoiceLine; "Sales Invoice Line".Quantity)
                {
                }
                column(UnitPrice_SalesInvoiceLine; "Sales Invoice Line"."Unit Price")
                {
                }
                column(SInvSubTotal; "Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price")
                {
                }
                column(SIOnHandQty; SIOnHandQty)
                {
                }
                column(SIItemQtyOnPO; SIItemQtyOnPO)
                {
                }
                column(SIItem12MonthSale; SIItem12MonthSale)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SIOnHandQty := 0;
                    SIItem12MonthSale := 0;
                    SIItemQtyOnPO := 0;

                    recILE.RESET;
                    recILE.SETRANGE(recILE."Item No.", "Sales Invoice Line"."No.");
                    recILE.SETRANGE(recILE."Location Code", 'BOMMASAND');
                    recILE.SETFILTER(recILE."Remaining Quantity", '<>%1', 0);
                    IF recILE.FINDFIRST THEN
                        REPEAT
                            SIOnHandQty := SIOnHandQty + recILE."Remaining Quantity";
                        UNTIL recILE.NEXT = 0;

                    recILE.RESET;
                    recILE.SETRANGE(recILE."Item No.", "Sales Invoice Line"."No.");
                    recILE.SETRANGE(recILE."Entry Type", recILE."Entry Type"::Sale);
                    recILE.SETFILTER(recILE."Posting Date", '%1..%2', CALCDATE('<-1Y-1D>', WORKDATE), WORKDATE);
                    IF recILE.FINDFIRST THEN
                        REPEAT
                            SIItem12MonthSale := SIItem12MonthSale + recILE.Quantity;
                        UNTIL recILE.NEXT = 0;

                    recPL.RESET;
                    recPL.SETRANGE(recPL."Document Type", recPL."Document Type"::Order);
                    recPL.SETRANGE(recPL."No.", "Sales Invoice Line"."No.");
                    recPL.SETRANGE(recPL."Location Code", 'BOMMASANDR');
                    recPL.SETFILTER(recPL."Outstanding Quantity", '<>%1', 0);
                    IF recPL.FINDFIRST THEN
                        REPEAT
                            SIItemQtyOnPO := SIItemQtyOnPO + recPL."Outstanding Quantity";
                        UNTIL recPL.NEXT = 0;
                end;
            }

            trigger OnPreDataItem()
            begin
                SETRANGE("Posting Date", WORKDATE);
                //SETRANGE("Posting Date",CALCDATE('<-7D>',WORKDATE),WORKDATE);
            end;
        }
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = WHERE("Document Type" = FILTER(Order));
            PrintOnlyIfDetail = true;
            column(No_PurchaseHeader; "Purchase Header"."No.")
            {
            }
            column(OrderDate_PurchaseHeader; FORMAT("Purchase Header"."Order Date"))
            {
            }
            column(BuyfromVendorNo_PurchaseHeader; "Purchase Header"."Buy-from Vendor No.")
            {
            }
            column(BuyfromVendorName_PurchaseHeader; "Purchase Header"."Buy-from Vendor Name")
            {
            }
            column(PostingDate_PurchaseHeader; FORMAT("Purchase Header"."Posting Date"))
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemTableView = WHERE(Type = FILTER(Item));
                column(No_PurchaseLine; "Purchase Line"."No.")
                {
                }
                column(Description_PurchaseLine; "Purchase Line".Description)
                {
                }
                column(Quantity_PurchaseLine; "Purchase Line".Quantity)
                {
                }
                column(DirectUnitCost_PurchaseLine; "Purchase Line"."Direct Unit Cost")
                {
                }
                column(POSubTotal; "Purchase Line".Quantity * "Purchase Line"."Direct Unit Cost")
                {
                }
                column(OutstandingQuantity_PurchaseLine; "Purchase Line"."Outstanding Quantity")
                {
                }
                column(POOnHandQty; POOnHandQty)
                {
                }
                column(POItemQtyOnPO; POItemQtyOnPO)
                {
                }
                column(POItem12MonthSale; POItem12MonthSale)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    POOnHandQty := 0;
                    POItem12MonthSale := 0;
                    POItemQtyOnPO := 0;

                    recILE.RESET;
                    recILE.SETRANGE(recILE."Item No.", "Purchase Line"."No.");
                    recILE.SETRANGE(recILE."Location Code", 'BOMMASANDR');
                    recILE.SETFILTER(recILE."Remaining Quantity", '<>%1', 0);
                    IF recILE.FINDFIRST THEN
                        REPEAT
                            POOnHandQty := POOnHandQty + recILE."Remaining Quantity";
                        UNTIL recILE.NEXT = 0;

                    recILE.RESET;
                    recILE.SETRANGE(recILE."Item No.", "Purchase Line"."No.");
                    recILE.SETRANGE(recILE."Entry Type", recILE."Entry Type"::Sale);
                    recILE.SETFILTER(recILE."Posting Date", '%1..%2', CALCDATE('<-1Y-1D>', WORKDATE), WORKDATE);
                    IF recILE.FINDFIRST THEN
                        REPEAT
                            POItem12MonthSale := POItem12MonthSale + recILE.Quantity;
                        UNTIL recILE.NEXT = 0;

                    recPL.RESET;
                    recPL.SETRANGE(recPL."Document Type", recPL."Document Type"::Order);
                    recPL.SETRANGE(recPL."No.", "Purchase Line"."No.");
                    recPL.SETRANGE(recPL."Location Code", 'BOMMASANDR');
                    recPL.SETFILTER(recPL."Outstanding Quantity", '<>%1', 0);
                    IF recPL.FINDFIRST THEN
                        REPEAT
                            POItemQtyOnPO := POItemQtyOnPO + recPL."Outstanding Quantity";
                        UNTIL recPL.NEXT = 0;
                end;
            }

            trigger OnPreDataItem()
            begin
                SETRANGE("Order Date", WORKDATE);
                //SETRANGE("Order Date",CALCDATE('<-7D>',WORKDATE),WORKDATE);
            end;
        }
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            column(No_PurchInvHeader; "Purch. Inv. Header"."No.")
            {
            }
            column(BuyfromVendorNo_PurchInvHeader; "Purch. Inv. Header"."Buy-from Vendor No.")
            {
            }
            column(BuyfromVendorName_PurchInvHeader; "Purch. Inv. Header"."Buy-from Vendor Name")
            {
            }
            column(PostingDate_PurchInvHeader; FORMAT("Purch. Inv. Header"."Posting Date"))
            {
            }
            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE(Type = FILTER(Item));
                column(No_PurchInvLine; "Purch. Inv. Line"."No.")
                {
                }
                column(Description_PurchInvLine; "Purch. Inv. Line".Description)
                {
                }
                column(Quantity_PurchInvLine; "Purch. Inv. Line".Quantity)
                {
                }
                column(DirectUnitCost_PurchInvLine; "Purch. Inv. Line"."Direct Unit Cost")
                {
                }
                column(PISubTotal; "Purch. Inv. Line".Quantity * "Purch. Inv. Line"."Direct Unit Cost")
                {
                }
                column(Amount_PurchInvLine; "Purch. Inv. Line".Amount)
                {
                }
                column(PIOnHandQty; PIOnHandQty)
                {
                }
                column(PIItemQtyOnPO; PIItemQtyOnPO)
                {
                }
                column(PIItem12MonthSale; PIItem12MonthSale)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    PIOnHandQty := 0;
                    PIItem12MonthSale := 0;
                    PIItemQtyOnPO := 0;

                    recILE.RESET;
                    recILE.SETRANGE(recILE."Item No.", "Purch. Inv. Line"."No.");
                    recILE.SETRANGE(recILE."Location Code", 'BOMMASANDR');
                    recILE.SETFILTER(recILE."Remaining Quantity", '<>%1', 0);
                    IF recILE.FINDFIRST THEN
                        REPEAT
                            PIOnHandQty := PIOnHandQty + recILE."Remaining Quantity";
                        UNTIL recILE.NEXT = 0;

                    recILE.RESET;
                    recILE.SETRANGE(recILE."Item No.", "Purch. Inv. Line"."No.");
                    recILE.SETRANGE(recILE."Entry Type", recILE."Entry Type"::Sale);
                    recILE.SETFILTER(recILE."Posting Date", '%1..%2', CALCDATE('<1Y-1D>', WORKDATE), WORKDATE);
                    IF recILE.FINDFIRST THEN
                        REPEAT
                            PIItem12MonthSale := PIItem12MonthSale + recILE.Quantity;
                        UNTIL recILE.NEXT = 0;

                    recPL.RESET;
                    recPL.SETRANGE(recPL."Document Type", recPL."Document Type"::Order);
                    recPL.SETRANGE(recPL."No.", "Purch. Inv. Line"."No.");
                    recPL.SETRANGE(recPL."Location Code", 'BOMMASANDR');
                    recPL.SETFILTER(recPL."Outstanding Quantity", '<>%1', 0);
                    IF recPL.FINDFIRST THEN
                        REPEAT
                            PIItemQtyOnPO := PIItemQtyOnPO + recPL."Outstanding Quantity";
                        UNTIL recPL.NEXT = 0;
                end;
            }

            trigger OnPreDataItem()
            begin
                SETRANGE("Posting Date", WORKDATE);
                //SETRANGE("Posting Date",CALCDATE('<-7D>',WORKDATE),WORKDATE);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        Cust: Record Customer;
        Currency: Record Currency;
        FormatAddr: Codeunit "Format Address";
        ReportTitle: Text[30];
        PaymentDiscountTitle: Text[30];
        CompanyAddr: array[8] of Text[50];
        CustAddr: array[8] of Text[50];
        RemainingAmount: Decimal;
        AppliedAmount: Decimal;
        PmtDiscInvCurr: Decimal;
        PmtTolInvCurr: Decimal;
        PmtDiscPmtCurr: Decimal;
        Text003: Label 'Payment Receipt';
        Text004: Label 'Payment Voucher';
        Text006: Label 'Pmt. Disc. Given';
        Text007: Label 'Pmt. Disc. Rcvd.';
        PmtTolPmtCurr: Decimal;
        ShowAmount: Decimal;
        CompanyInfoPhoneNoCaptionLbl: Label 'Phone No.';
        CompanyInfoGiroNoCaptionLbl: Label 'Giro No.';
        CompanyInfoBankNameCptnLbl: Label 'Bank';
        CompanyInfoBankAccNoCptnLbl: Label 'Account No.';
        ReceiptNoCaptionLbl: Label 'Receipt No.';
        CompanyInfoVATRegNoCptnLbl: Label 'GST Reg. No.';
        CustLedgEntry1PostDtCptnLbl: Label 'Posting Date';
        AmountCaptionLbl: Label 'Amount';
        PaymAmtSpecificationCptnLbl: Label 'Payment Amount Specification';
        PmtTolInvCurrCaptionLbl: Label 'Pmt Tol.';
        DocumentDateCaptionLbl: Label 'Document Date';
        CompanyInfoEMailCaptionLbl: Label 'E-Mail';
        CompanyInfoHomePageCptnLbl: Label 'Home Page';
        PaymAmtNotAllocatedCptnLbl: Label 'Payment Amount Not Allocated';
        CustLedgEntryOrgAmtCptnLbl: Label 'Payment Amount';
        ExternalDocumentNoCaptionLbl: Label 'External Document No.';
        SOOnHandQty: Decimal;
        SIOnHandQty: Decimal;
        POOnHandQty: Decimal;
        PIOnHandQty: Decimal;
        SOItem12MonthSale: Decimal;
        SIItem12MonthSale: Decimal;
        POItem12MonthSale: Decimal;
        PIItem12MonthSale: Decimal;
        SOItemQtyOnPO: Decimal;
        SIItemQtyOnPO: Decimal;
        POItemQtyOnPO: Decimal;
        PIItemQtyOnPO: Decimal;
        recILE: Record "Item Ledger Entry";
        recPL: Record "Purchase Line";

    local procedure CurrencyCode(SrcCurrCode: Code[10]): Code[10]
    begin
        IF SrcCurrCode = '' THEN
            EXIT(GLSetup."LCY Code");
        EXIT(SrcCurrCode);
    end;
}

