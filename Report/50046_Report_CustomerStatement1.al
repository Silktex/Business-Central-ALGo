report 50046 "Customer Statement1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50046_Report_CustomerStatement1.rdlc';
    Caption = 'Customer Statement';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Print Statements", "Date Filter";
            column(Customer_No_; "No.")
            {
            }
            column(Customer_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(Customer_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            column(Picture_compinfo; compinfo.Picture)
            {
            }
            column(Name_compinfo; compinfo.Name)
            {
            }
            column(Address_compinfo; compinfo.Address)
            {
            }
            column(City_compinfo; compinfo.City)
            {
            }
            column(County_compinfo; compinfo.County)
            {
            }
            column(PostCode_compinfo; compinfo."Post Code")
            {
            }
            column(CountryRegionCode_compinfo; compinfo."Country/Region Code")
            {
            }
            column(EMail_compinfo; compinfo."E-Mail")
            {
            }
            column(PhoneNo_compinfo; compinfo."Phone No.")
            {
            }
            dataitem(HeaderFooter; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(CompanyInformation_Picture; CompanyInformation.Picture)
                {
                }
                column(CompanyInfo1_Picture; CompanyInfo1.Picture)
                {
                }
                column(CompanyInfo2_Picture; CompanyInfo2.Picture)
                {
                }
                column(CompanyAddress_1_; CompanyAddress[1])
                {
                }
                column(CompanyAddress_2_; CompanyAddress[2])
                {
                }
                column(CompanyAddress_3_; CompanyAddress[3])
                {
                }
                column(CompanyAddress_4_; CompanyAddress[4])
                {
                }
                column(CompanyAddress_5_; CompanyAddress[5])
                {
                }
                column(ToDate; ToDate)
                {
                }
                column(CompanyAddress_6_; CompanyAddress[6])
                {
                }
                column(Customer__No__; Customer."No.")
                {
                }
                column(CurrReport_PAGENO; CurrReport.PAGENO)
                {
                }
                column(CustomerAddress_1_; CustomerAddress[1])
                {
                }
                column(CustomerAddress_2_; CustomerAddress[2])
                {
                }
                column(CustomerAddress_3_; CustomerAddress[3])
                {
                }
                column(CustomerAddress_4_; CustomerAddress[4])
                {
                }
                column(CustomerAddress_5_; CustomerAddress[5])
                {
                }
                column(CustomerAddress_6_; CustomerAddress[6])
                {
                }
                column(CustomerAddress_7_; CustomerAddress[7])
                {
                }
                column(CompanyAddress_7_; CompanyAddress[7])
                {
                }
                column(CompanyAddress_8_; CompanyAddress[8])
                {
                }
                column(CustomerAddress_8_; CustomerAddress[8])
                {
                }
                column(CurrencyDesc; CurrencyDesc)
                {
                }
                column(AgingMethod_Int; AgingMethod_Int)
                {
                }
                column(StatementStyle_Int; StatementStyle_Int)
                {
                }
                column(printfooter3ornot; (AgingMethod <> AgingMethod::None) AND StatementComplete)
                {
                }
                column(DebitBalance; DebitBalance)
                {
                }
                column(CreditBalance; -CreditBalance)
                {
                }
                column(BalanceToPrint; BalanceToPrint)
                {
                }
                column(DebitBalance_Control22; DebitBalance)
                {
                }
                column(CreditBalance_Control23; -CreditBalance)
                {
                }
                column(BalanceToPrint_Control24; BalanceToPrint)
                {
                }
                column(AgingDaysText; AgingDaysText)
                {
                }
                column(AgingHead_1_; AgingHead[1])
                {
                }
                column(AgingHead_2_; AgingHead[2])
                {
                }
                column(AgingHead_3_; AgingHead[3])
                {
                }
                column(AgingHead_4_; AgingHead[4])
                {
                }
                column(AmountDue_1_; AmountDue[1])
                {
                }
                column(AmountDue_2_; AmountDue[2])
                {
                }
                column(AmountDue_3_; AmountDue[3])
                {
                }
                column(AmountDue_4_; AmountDue[4])
                {
                }
                column(TempAmountDue_1_; TempAmountDue[1])
                {
                }
                column(TempAmountDue_3_; TempAmountDue[3])
                {
                }
                column(TempAmountDue_2_; TempAmountDue[2])
                {
                }
                column(TempAmountDue_4_; TempAmountDue[4])
                {
                }
                column(HeaderFooter_Number; Number)
                {
                }
                column(STATEMENTCaption; STATEMENTCaptionLbl)
                {
                }
                column(Statement_Date_Caption; Statement_Date_CaptionLbl)
                {
                }
                column(Account_Number_Caption; Account_Number_CaptionLbl)
                {
                }
                column(Page_Caption; Page_CaptionLbl)
                {
                }
                column(RETURN_THIS_PORTION_OF_STATEMENT_WITH_YOUR_PAYMENT_Caption; RETURN_THIS_PORTION_OF_STATEMENT_WITH_YOUR_PAYMENT_CaptionLbl)
                {
                }
                column(Amount_RemittedCaption; Amount_RemittedCaptionLbl)
                {
                }
                column(TempCustLedgEntry__Document_No__Caption; TempCustLedgEntry__Document_No__CaptionLbl)
                {
                }
                column(TempCustLedgEntry__Posting_Date_Caption; TempCustLedgEntry__Posting_Date_CaptionLbl)
                {
                }
                column(GetTermsString_TempCustLedgEntry_Caption; GetTermsString_TempCustLedgEntry_CaptionLbl)
                {
                }
                column(TempCustLedgEntry__Document_Type_Caption; TempCustLedgEntry__Document_Type_CaptionLbl)
                {
                }
                column(TempCustLedgEntry__Remaining_Amount_Caption; TempCustLedgEntry__Remaining_Amount_CaptionLbl)
                {
                }
                column(TempCustLedgEntry__Remaining_Amount__Control47Caption; TempCustLedgEntry__Remaining_Amount__Control47CaptionLbl)
                {
                }
                column(BalanceToPrint_Control48Caption; BalanceToPrint_Control48CaptionLbl)
                {
                }
                column(Statement_BalanceCaption; Statement_BalanceCaptionLbl)
                {
                }
                column(Statement_BalanceCaption_Control25; Statement_BalanceCaption_Control25Lbl)
                {
                }
                column(Statement_Aging_Caption; Statement_Aging_CaptionLbl)
                {
                }
                column(Aged_amounts_Caption; Aged_amounts_CaptionLbl)
                {
                }
                dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = FIELD("No."), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                    DataItemLinkReference = Customer;
                    DataItemTableView = SORTING("Customer No.", Open) WHERE(Open = CONST(true), "Remaining Amount" = FILTER(> 0));

                    trigger OnAfterGetRecord()
                    begin
                        SETRANGE("Date Filter", 0D, ToDate);
                        CALCFIELDS("Remaining Amount");
                        IF "Remaining Amount" <> 0 THEN
                            InsertTemp("Cust. Ledger Entry");
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF (AgingMethod = AgingMethod::None) AND (StatementStyle = StatementStyle::Balance) THEN
                            CurrReport.BREAK;    // Optimization

                        // Find ledger entries which are open and posted before the statement date.
                        SETRANGE("Posting Date", 0D, ToDate);
                    end;
                }
                dataitem(AfterStmntDateEntry; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = FIELD("No."), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                    DataItemLinkReference = Customer;
                    DataItemTableView = SORTING("Customer No.", "Posting Date");

                    trigger OnAfterGetRecord()
                    begin
                        EntryAppMgt.GetAppliedCustEntries(TempAppliedCustLedgEntry, AfterStmntDateEntry, FALSE);
                        TempAppliedCustLedgEntry.SETRANGE("Posting Date", 0D, ToDate);
                        IF TempAppliedCustLedgEntry.FIND('-') THEN
                            REPEAT
                                InsertTemp(TempAppliedCustLedgEntry);
                            UNTIL TempAppliedCustLedgEntry.NEXT = 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF (AgingMethod = AgingMethod::None) AND (StatementStyle = StatementStyle::Balance) THEN
                            CurrReport.BREAK;    // Optimization

                        // Find ledger entries which are posted after the statement date and eliminate
                        // their application to ledger entries posted before the statement date.
                        SETFILTER("Posting Date", '%1..', ToDate + 1);
                    end;
                }
                dataitem("Balance Forward"; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(FromDate___1; FromDate - 1)
                    {
                    }
                    column(BalanceToPrint_Control39; BalanceToPrint)
                    {
                    }
                    column(Balance_Forward_Number; Number)
                    {
                    }
                    column(Balance_ForwardCaption; Balance_ForwardCaptionLbl)
                    {
                    }
                    column(Bal_FwdCaption; Bal_FwdCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF StatementStyle <> StatementStyle::Balance THEN
                            CurrReport.BREAK;
                    end;

                    trigger OnPreDataItem()
                    begin
                        StatementStyle_Int := StatementStyle;
                    end;
                }
                dataitem(OpenItem; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(TempCustLedgEntry__Document_No__; TempCustLedgEntry."Document No.")
                    {
                    }
                    column(TempCustLedgEntry__Posting_Date_; TempCustLedgEntry."Posting Date")
                    {
                    }
                    column(TempCustLedgEntry_DueDate; TempCustLedgEntry."Due Date")
                    {
                    }
                    column(GetTermsString_TempCustLedgEntry_; GetTermsString(TempCustLedgEntry))
                    {
                    }
                    column(TempCustLedgEntry__Document_Type_; TempCustLedgEntry."Document Type")
                    {
                        OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
                    }
                    column(TempCustLedgEntry__Remaining_Amount_; TempCustLedgEntry."Remaining Amount")
                    {
                    }
                    column(TempCustLedgEntry__Remaining_Amount__Control47; -TempCustLedgEntry."Remaining Amount")
                    {
                    }
                    column(BalanceToPrint_Control48; BalanceToPrint)
                    {
                    }
                    column(OpenItem_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF Number = 1 THEN
                            TempCustLedgEntry.FIND('-')
                        ELSE
                            TempCustLedgEntry.NEXT;
                        WITH TempCustLedgEntry DO BEGIN
                            CALCFIELDS("Remaining Amount");
                            IF "Currency Code" <> Customer."Currency Code" THEN
                                "Remaining Amount" :=
                                  ROUND(
                                    CurrExchRate.ExchangeAmtFCYToFCY(
                                      "Posting Date",
                                      "Currency Code",
                                      Customer."Currency Code",
                                      "Remaining Amount"),
                                    Currency."Amount Rounding Precision");

                            IF AgingMethod <> AgingMethod::None THEN BEGIN
                                CASE AgingMethod OF
                                    AgingMethod::"Due Date":
                                        AgingDate := "Due Date";
                                    AgingMethod::"Trans Date":
                                        AgingDate := "Posting Date";
                                    AgingMethod::"Doc Date":
                                        AgingDate := "Document Date";
                                END;
                                i := 0;
                                WHILE AgingDate < PeriodEndingDate[i + 1] DO
                                    i := i + 1;
                                IF i = 0 THEN
                                    i := 1;
                                AmountDue[i] := "Remaining Amount";
                                TempAmountDue[i] := TempAmountDue[i] + AmountDue[i];
                            END;

                            IF StatementStyle = StatementStyle::"Open Item" THEN BEGIN
                                BalanceToPrint := BalanceToPrint + "Remaining Amount";
                                IF "Remaining Amount" >= 0 THEN
                                    DebitBalance := DebitBalance + "Remaining Amount"
                                ELSE
                                    CreditBalance := CreditBalance + "Remaining Amount";
                            END;
                        END;
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF (NOT TempCustLedgEntry.FIND('-')) OR
                           ((StatementStyle = StatementStyle::Balance) AND
                            (AgingMethod = AgingMethod::None))
                        THEN
                            CurrReport.BREAK
                            ;
                        SETRANGE(Number, 1, TempCustLedgEntry.COUNT);
                        TempCustLedgEntry.SETCURRENTKEY("Customer No.", "Posting Date");
                        TempCustLedgEntry.SETRANGE("Date Filter", 0D, ToDate);
                        CurrReport.CREATETOTALS(AmountDue);
                    end;
                }
                dataitem(CustLedgerEntry4; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = FIELD("No.");
                    DataItemLinkReference = Customer;
                    DataItemTableView = SORTING("Customer No.", "Posting Date");
                    column(CustLedgerEntry4__Document_No__; "Document No.")
                    {
                    }
                    column(CustLedgerEntry4__Posting_Date_; "Posting Date")
                    {
                    }
                    column(DueDate_CustLedgerEntry4; CustLedgerEntry4."Due Date")
                    {
                    }
                    column(GetTermsString_CustLedgerEntry4_; GetTermsString(CustLedgerEntry4))
                    {
                    }
                    column(CustLedgerEntry4__Document_Type_; "Document Type")
                    {
                    }
                    column(CustLedgerEntry4_Amount; Amount)
                    {
                    }
                    column(Amount; -Amount)
                    {
                    }
                    column(BalanceToPrint_Control55; BalanceToPrint)
                    {
                    }
                    column(CustLedgerEntry4_Entry_No_; "Entry No.")
                    {
                    }
                    column(CustLedgerEntry4_Customer_No_; "Customer No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CALCFIELDS(Amount, "Amount (LCY)");
                        IF (Customer."Currency Code" = '') AND ("Cust. Ledger Entry"."Currency Code" = '') THEN
                            Amount := "Amount (LCY)"
                        ELSE
                            Amount :=
                              ROUND(
                                CurrExchRate.ExchangeAmtFCYToFCY(
                                  "Posting Date",
                                  "Currency Code",
                                  Customer."Currency Code",
                                  Amount),
                                Currency."Amount Rounding Precision");

                        BalanceToPrint := BalanceToPrint + Amount;
                        IF Amount >= 0 THEN
                            DebitBalance := DebitBalance + Amount
                        ELSE
                            CreditBalance := CreditBalance + Amount;
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF StatementStyle <> StatementStyle::Balance THEN
                            CurrReport.BREAK;
                        SETRANGE("Posting Date", FromDate, ToDate);
                    end;
                }
                dataitem(EndOfCustomer; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(StatementComplete; StatementComplete)
                    {
                    }
                    column(EndOfCustomer_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        StatementComplete := TRUE;
                        IF UpdateNumbers AND (NOT CurrReport.PREVIEW) THEN BEGIN
                            Customer.MODIFY; // just update the Last Statement No
                            COMMIT;
                        END;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    AgingMethod_Int := AgingMethod;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Language Code" <> '' then
                    CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                DebitBalance := 0;
                CreditBalance := 0;
                CLEAR(AmountDue);
                CLEAR(TempAmountDue);
                Print := FALSE;
                IF AllHavingBalance THEN BEGIN
                    SETRANGE("Date Filter", 0D, ToDate);
                    CALCFIELDS("Net Change");
                    Print := "Net Change" <> 0;
                END;
                IF (NOT Print) AND AllHavingEntries THEN BEGIN
                    "Cust. Ledger Entry".RESET;
                    IF StatementStyle = StatementStyle::Balance THEN BEGIN
                        "Cust. Ledger Entry".SETCURRENTKEY("Customer No.", "Posting Date");
                        "Cust. Ledger Entry".SETRANGE("Posting Date", FromDate, ToDate);
                    END ELSE BEGIN
                        "Cust. Ledger Entry".SETCURRENTKEY("Customer No.", Open);
                        "Cust. Ledger Entry".SETRANGE("Posting Date", 0D, ToDate);
                        "Cust. Ledger Entry".SETRANGE(Open, TRUE);
                    END;
                    "Cust. Ledger Entry".SETRANGE("Customer No.", "No.");
                    Print := "Cust. Ledger Entry".FIND('-');
                END;
                IF NOT Print THEN
                    CurrReport.SKIP;

                TempCustLedgEntry.DELETEALL;

                AgingDaysText := '';
                IF AgingMethod <> AgingMethod::None THEN BEGIN
                    AgingHead[1] := Text006;
                    PeriodEndingDate[1] := ToDate;
                    IF AgingMethod = AgingMethod::"Due Date" THEN BEGIN
                        PeriodEndingDate[2] := PeriodEndingDate[1];
                        FOR i := 3 TO 4 DO
                            PeriodEndingDate[i] := CALCDATE(PeriodCalculation, PeriodEndingDate[i - 1]);
                        AgingDaysText := Text007;
                        AgingHead[2] := Text008 + ' '
                          + FORMAT(PeriodEndingDate[1] - PeriodEndingDate[3])
                          + Text009;
                    END ELSE BEGIN
                        FOR i := 2 TO 4 DO
                            PeriodEndingDate[i] := CALCDATE(PeriodCalculation, PeriodEndingDate[i - 1]);
                        AgingDaysText := Text010;
                        AgingHead[2] := FORMAT(PeriodEndingDate[1] - PeriodEndingDate[2] + 1)
                          + ' - '
                          + FORMAT(PeriodEndingDate[1] - PeriodEndingDate[3])
                          + Text009;
                    END;
                    PeriodEndingDate[5] := 0D;
                    AgingHead[3] := FORMAT(PeriodEndingDate[1] - PeriodEndingDate[3] + 1)
                      + ' - '
                      + FORMAT(PeriodEndingDate[1] - PeriodEndingDate[4])
                      + Text009;
                    AgingHead[4] := Text011 + ' '
                      + FORMAT(PeriodEndingDate[1] - PeriodEndingDate[4])
                      + Text009;
                END;

                IF "Currency Code" = '' THEN BEGIN
                    CLEAR(Currency);
                    CurrencyDesc := '';
                END ELSE BEGIN
                    Currency.GET("Currency Code");
                    CurrencyDesc := STRSUBSTNO(Text013, Currency.Description);
                END;

                IF StatementStyle = StatementStyle::Balance THEN BEGIN
                    SETRANGE("Date Filter", 0D, FromDate - 1);
                    CALCFIELDS("Net Change (LCY)");
                    IF "Currency Code" = '' THEN
                        BalanceToPrint := "Net Change (LCY)"
                    ELSE
                        BalanceToPrint := CurrExchRate.ExchangeAmtFCYToFCY(FromDate - 1, '', "Currency Code", "Net Change (LCY)");
                    SETRANGE("Date Filter");
                END ELSE
                    BalanceToPrint := 0;

                /* Update Statement Number so it can be printed on the document. However,
                  defer actually updating the customer file until the statement is complete. */
                IF "Last Statement No." >= 9999 THEN
                    "Last Statement No." := 1
                ELSE
                    "Last Statement No." := "Last Statement No." + 1;
                CurrReport.PAGENO := 1;

                FormatAddress.Customer(CustomerAddress, Customer);
                StatementComplete := FALSE;

                IF LogInteraction THEN
                    IF NOT CurrReport.PREVIEW THEN
                        SegManagement.LogDocument(
                          7, FORMAT(Customer."Last Statement No."), 0, 0, DATABASE::Customer, "No.", "Salesperson Code",
                          '', Text012 + FORMAT(Customer."Last Statement No."), '');

            end;

            trigger OnPreDataItem()
            begin
                /* remove user-entered date filter; info now in FromDate & ToDate */
                SETRANGE("Date Filter");
                IF (StartDate1 <> 0D) AND (EndDate1 <> 0D) THEN
                    SETFILTER("Date Filter", '%1..%2', StartDate1, EndDate1);

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
                    field(AllHavingEntries; AllHavingEntries)
                    {
                        Caption = 'Print All with Entries';
                        ApplicationArea = all;
                    }
                    field(AllHavingBalance; AllHavingBalance)
                    {
                        Caption = 'Print All with Balance';
                        ApplicationArea = all;
                    }
                    field(UpdateNumbers; UpdateNumbers)
                    {
                        Caption = 'Update Statement No.';
                        ApplicationArea = all;
                    }
                    field(PrintCompany; PrintCompany)
                    {
                        Caption = 'Print Company Address';
                        ApplicationArea = all;
                    }
                    field(StatementStyle; StatementStyle)
                    {
                        Caption = 'Statement Style';
                        OptionCaption = 'Open Item,Balance';
                        ApplicationArea = all;
                    }
                    field(AgingMethod; AgingMethod)
                    {
                        Caption = 'Aged By';
                        OptionCaption = 'None,Due Date,Trans Date,Doc Date';
                        ApplicationArea = all;
                    }
                    field(PeriodCalculation; PeriodCalculation)
                    {
                        Caption = 'Length of Aging Periods';
                        ApplicationArea = all;

                        trigger OnValidate()
                        begin
                            IF (AgingMethod <> AgingMethod::None) AND (FORMAT(PeriodCalculation) = '') THEN
                                ERROR(Text014);
                        end;
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
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
        var
            DocumentType: Enum "Interaction Log Entry Document Type";

        begin
            IF (NOT AllHavingEntries) AND (NOT AllHavingBalance) THEN
                AllHavingBalance := TRUE;

            LogInteraction := SegManagement.FindInteractionTemplateCode(DocumentType::"Sales Stmnt.") <> '';
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        IF (NOT AllHavingEntries) AND (NOT AllHavingBalance) THEN
            ERROR(Text000);
        IF UpdateNumbers AND CurrReport.PREVIEW THEN
            ERROR(Text001);
        FromDate := Customer.GETRANGEMIN("Date Filter");
        ToDate := Customer.GETRANGEMAX("Date Filter");

        IF (StatementStyle = StatementStyle::Balance) AND (FromDate = ToDate) THEN
            ERROR(Text002 + ' '
              + Text003);

        IF (AgingMethod <> AgingMethod::None) AND (FORMAT(PeriodCalculation) = '') THEN
            ERROR(Text004);

        IF FORMAT(PeriodCalculation) <> '' THEN
            EVALUATE(PeriodCalculation, '-' + FORMAT(PeriodCalculation));

        IF PrintCompany THEN BEGIN
            CompanyInformation.GET;
            FormatAddress.Company(CompanyAddress, CompanyInformation);
        END ELSE
            CLEAR(CompanyAddress);

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
        IF compinfo.GET THEN
            compinfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        compinfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        Language: Codeunit Language;
        TempCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        TempAppliedCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        FormatAddress: Codeunit "Format Address";
        EntryAppMgt: Codeunit "Entry Application Management";
        StatementStyle: Option "Open Item",Balance;
        AllHavingEntries: Boolean;
        AllHavingBalance: Boolean;
        UpdateNumbers: Boolean;
        AgingMethod: Option "None","Due Date","Trans Date","Doc Date";
        PrintCompany: Boolean;
        PeriodCalculation: DateFormula;
        Print: Boolean;
        FromDate: Date;
        ToDate: Date;
        AgingDate: Date;
        LogInteraction: Boolean;
        CustomerAddress: array[8] of Text[50];
        CompanyAddress: array[8] of Text[50];
        BalanceToPrint: Decimal;
        DebitBalance: Decimal;
        CreditBalance: Decimal;
        AgingHead: array[4] of Text[20];
        AmountDue: array[4] of Decimal;
        AgingDaysText: Text[20];
        PeriodEndingDate: array[5] of Date;
        StatementComplete: Boolean;
        i: Integer;
        CurrencyDesc: Text[80];
        SegManagement: Codeunit SegManagement;
        Text000: Label 'You must select either All with Entries or All with Balance.';
        Text001: Label 'You must print statements if you want to update statement numbers.';
        Text002: Label 'You must enter a range of dates (not just one date) in the';
        Text003: Label 'Date Filter if you want to print Balance Forward Statements.';
        Text004: Label 'You must enter a Length of Aging Periods if you select aging.';
        Text006: Label 'Current';
        Text007: Label 'Days overdue:';
        Text008: Label 'Up To';
        Text009: Label ' Days';
        Text010: Label 'Days old:';
        Text011: Label 'Over';
        Text012: Label 'Statement ';
        Text013: Label '(All amounts are in %1)';
        TempAmountDue: array[4] of Decimal;
        AgingMethod_Int: Integer;
        StatementStyle_Int: Integer;

        LogInteractionEnable: Boolean;
        Text014: Label 'You must enter a Length of Aging Periods if you select aging.';
        STATEMENTCaptionLbl: Label 'STATEMENT';
        Statement_Date_CaptionLbl: Label 'Statement Date:';
        Account_Number_CaptionLbl: Label 'Account Number:';
        Page_CaptionLbl: Label 'Page:';
        RETURN_THIS_PORTION_OF_STATEMENT_WITH_YOUR_PAYMENT_CaptionLbl: Label 'RETURN THIS PORTION OF STATEMENT WITH YOUR PAYMENT.';
        Amount_RemittedCaptionLbl: Label 'Amount Remitted';
        TempCustLedgEntry__Document_No__CaptionLbl: Label 'Document';
        TempCustLedgEntry__Posting_Date_CaptionLbl: Label 'Date';
        GetTermsString_TempCustLedgEntry_CaptionLbl: Label 'Terms';
        TempCustLedgEntry__Document_Type_CaptionLbl: Label 'Code';
        TempCustLedgEntry__Remaining_Amount_CaptionLbl: Label 'Debits';
        TempCustLedgEntry__Remaining_Amount__Control47CaptionLbl: Label 'Credits';
        BalanceToPrint_Control48CaptionLbl: Label 'Balance';
        Statement_BalanceCaptionLbl: Label 'Statement Balance';
        Statement_BalanceCaption_Control25Lbl: Label 'Statement Balance';
        Statement_Aging_CaptionLbl: Label 'Statement Aging:';
        Aged_amounts_CaptionLbl: Label 'Aged amounts:';
        Balance_ForwardCaptionLbl: Label 'Balance Forward';
        Bal_FwdCaptionLbl: Label 'Bal Fwd';
        StartDate1: Date;
        EndDate1: Date;


    procedure GetTermsString(var CustLedgerEntry: Record "Cust. Ledger Entry"): Text[250]
    var
        InvoiceHeader: Record "Sales Invoice Header";
        PaymentTerms: Record "Payment Terms";
    begin
        WITH CustLedgerEntry DO BEGIN
            IF ("Document No." = '') OR ("Document Type" <> "Document Type"::Invoice) THEN
                EXIT('');

            IF InvoiceHeader.READPERMISSION THEN BEGIN
                IF InvoiceHeader.GET("Document No.") THEN BEGIN
                    IF PaymentTerms.GET(InvoiceHeader."Payment Terms Code") THEN BEGIN
                        IF PaymentTerms.Description <> '' THEN
                            EXIT(PaymentTerms.Description);

                        EXIT(InvoiceHeader."Payment Terms Code");
                    END;
                    EXIT(InvoiceHeader."Payment Terms Code");
                END;
            END;
        END;

        IF Customer."Payment Terms Code" <> '' THEN BEGIN
            IF PaymentTerms.GET(Customer."Payment Terms Code") THEN BEGIN
                IF PaymentTerms.Description <> '' THEN
                    EXIT(PaymentTerms.Description);

                EXIT(Customer."Payment Terms Code");
            END;
            EXIT(Customer."Payment Terms Code");
        END;

        EXIT('');
    end;

    local procedure InsertTemp(var CustLedgEntry: Record "Cust. Ledger Entry")
    begin
        WITH TempCustLedgEntry DO BEGIN
            IF GET(CustLedgEntry."Entry No.") THEN
                EXIT;
            TempCustLedgEntry := CustLedgEntry;
            INSERT;
        END;
    end;


    procedure FilterDate(StartDate: Date; EndDate: Date)
    var
        DFilter: Text[30];
    begin
        //FromDate := StartDate;
        //ToDate :=EndDate;
        //DFilter:=STRSUBSTNO('%1..%2',StartDate,EndDate);
        //EVALUATE(Customer."Date Filter",DFilter);
        //Customer."Date Filter":=STRSUBSTNO('%1..%2',StartDate,EndDate);
        StartDate1 := StartDate;
        StartDate1 := EndDate;
    end;


    procedure FilterCustomer(custNo: Code[20])
    begin
        Customer."No." := custNo;
    end;


    procedure ReportFilter(LStatementStyle: Option "Open Item",Balance; LAllHavingEntries: Boolean; LAllHavingBalance: Boolean; LAgingMethod: Option "None","Due Date","Trans Date","Doc Date"; LPrintCompany: Boolean)
    begin
        StatementStyle := LStatementStyle;
        AllHavingEntries := LAllHavingEntries;
        AllHavingBalance := LAllHavingBalance;
        AgingMethod := LAgingMethod;
        PrintCompany := LPrintCompany;
    end;


    procedure FNAgingMethod(LAgingMethod: Option "None","Due Date","Trans Date","Doc Date")
    begin
        AgingMethod := LAgingMethod;
    end;


    procedure FNPeriodCalculation()
    begin
        EVALUATE(PeriodCalculation, '1M');
    end;
}

