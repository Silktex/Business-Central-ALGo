pageextension 50206 CustomerList extends "Customer List"
{

    layout
    {
        addafter(Contact)
        {
            field("Expire Price Contact Email"; ExpirePriceContactEmail)
            {
                ApplicationArea = all;
            }
        }
        modify("Name 2")
        {
            Visible = true;
        }
        addafter("Country/Region Code")
        {
            field(County; Rec.County)
            {
                ApplicationArea = all;
            }
        }
        addafter("Salesperson Code")
        {
            field(SalesPersonName; SalesPersonName)
            {
                Caption = 'Sales Person Name';
                ApplicationArea = all;
            }
        }
        addafter("Payment Terms Code")
        {
            field("Shipping Account No."; Rec."Shipping Account No.")
            {
                ApplicationArea = all;
            }
            field("UPS Account No."; Rec."UPS Account No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Base Calendar Code")
        {
            field(MailSentCount; MailCountFN(Rec."No."))
            {
                Caption = 'Mail Sent Count';
                ApplicationArea = all;

                trigger OnDrillDown()
                var
                    MailSentRec: Record "Mail Detail";
                begin
                    MailSentRec.Reset;
                    MailSentRec.SetCurrentKey("Source No.", "Date Time");
                    MailSentRec.SetRange("Source No.", Rec."No.");
                    PAGE.Run(0, MailSentRec);
                end;
            }
            field("LastMailSenton"; LastDateMailSentFN(Rec."No."))
            {
                Caption = 'Last Mail Sent on';
                ApplicationArea = all;
            }
        }
        addafter(CustomerDetailsFactBox)
        {
            part(CustomerAgingFactBox; "Customer Aging FactBox")
            {
                Caption = 'Customer Aging';
                ApplicationArea = all;
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
            }
        }
    }
    actions
    {
        addbefore(CustomerLedgerEntries)
        {
            action("Credit Card List")
            {
                RunObject = page "DO Payment Credit Card List";
                RunPageLink = "Customer No." = field("No.");
                ApplicationArea = all;
                Image = CreditCard;
            }
            action("Credit Cards Transaction Lo&g Entries")
            {
                Caption = 'Credit Cards Transaction Lo&g Entries';
                Image = CreditCardLog;
                RunObject = Page "DO Payment Trans. Log Entries";
                RunPageLink = "Customer No." = FIELD("No.");
                ApplicationArea = all;
            }
        }
        addafter(Sales_InvoiceDiscounts)
        {
            action(UpdateSalesPrice)
            {
                Caption = 'Update Expired Prices';
                Image = Close;
                ApplicationArea = all;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    REPORT.Run(50037, true, true, Rec);

                    //CLEAR(SalesPrice);
                    //SalesPrice.SetValue("No.");
                    //SalesPrice.RUNMODAL;
                end;
            }
            action("Expired Prices")
            {
                Caption = 'Expired Prices';
                Image = Price;
                ApplicationArea = all;

                trigger OnAction()
                begin
                    recExpirceSalesPrice.Reset;
                    recExpirceSalesPrice.SetRange(recExpirceSalesPrice."Source Type", recExpirceSalesPrice."Source Type"::Customer);
                    //recExpirceSalesPrice.SETRANGE(recExpirceSalesPrice."Sales Code",xRec."No.");
                    if recExpirceSalesPrice.FindSet then begin
                        Clear(pageExpiredSalesPrices);
                        pageExpiredSalesPrices.SetRecord(recExpirceSalesPrice);
                        pageExpiredSalesPrices.SetTableView(recExpirceSalesPrice);
                        pageExpiredSalesPrices.Run;
                    end;
                end;
            }
            action("Expired Prices(Disc)")
            {
                Caption = 'Expired Prices(Disc)';
                Image = Price;
                ApplicationArea = all;

                trigger OnAction()
                begin
                    recExpirceSalesPrice.Reset;
                    recExpirceSalesPrice.SetRange(recExpirceSalesPrice."Source Type", recExpirceSalesPrice."Source Type"::Customer);
                    //recExpirceSalesPrice.SETRANGE(recExpirceSalesPrice."Sales Code",xRec."No.");
                    if recExpirceSalesPrice.FindSet then begin
                        Clear(pageExpiredSalesPricesDisc);
                        pageExpiredSalesPricesDisc.SetRecord(recExpirceSalesPrice);
                        pageExpiredSalesPrices.SetTableView(recExpirceSalesPrice);
                        pageExpiredSalesPricesDisc.Run;
                    end;
                end;
            }
            action("BACKING TABLE FOR NAV")
            {
                ApplicationArea = all;
                Caption = 'BACKING TABLE FOR NAV';
                Image = Resource;
                RunObject = Page "BACKING TABLE FOR NAV";
                RunPageLink = "Customer Type" = CONST(Customer),
                                  "Customer Code" = FIELD("No.");
                RunPageView = SORTING("Customer Type", "Customer Code", "Product Type", "Product Code", "Resc. Code");
            }

        }
        addafter("Sales Journal")
        {
            action(SaleDetail)
            {
                Caption = 'Sale Detail';
                Image = LedgerEntries;
                RunObject = Page "Ecom Customer List";
                RunPageOnRec = true;
                ApplicationArea = all;
            }
            action(SendLedgerEmailPDF)
            {
                Caption = 'Send Ledger Email PDF';
                Image = SendEmailPDF;
                ApplicationArea = all;

                trigger OnAction()
                var
                    SendSmtpMail: Codeunit SmtpMail_Ext;
                    UserSetup: Record "User Setup";
                    TEXT001: Label 'You are not authorized.';
                begin
                    if UserSetup.Get(UserId) and UserSetup."Sent Mail Customer Ledger" then begin
                        CurrPage.SetSelectionFilter(Rec);
                        Rec.Copy(Rec);
                        if Rec.FindFirst then
                            repeat
                                SendSmtpMail.SendCustomerLedgerAsPDF(Rec);
                            until Rec.Next = 0;
                        Rec.Reset;
                        CurrPage.Update(true);
                    end else
                        Message(TEXT001);
                end;
            }
            action(SendStatementEmailPDF)
            {
                Caption = 'Send Statement Email PDF';
                Image = SendEmailPDF;
                ApplicationArea = all;

                trigger OnAction()
                var
                    SendSmtpMail: Codeunit SmtpMail_Ext;
                    UserSetup: Record "User Setup";
                    TEXT001: Label 'You are not authorized.';
                    CustLedgerEntry: Record "Cust. Ledger Entry";
                begin
                    if UserSetup.Get(UserId) and UserSetup."Sent Mail Customer Ledger" then begin
                        CurrPage.SetSelectionFilter(Rec);
                        Rec.Copy(Rec);

                        if Rec.FindFirst then
                            repeat
                                CustLedgerEntry.Reset;
                                CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", Rec."No.");
                                CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
                                CustLedgerEntry.SetFilter("Remaining Amount", '<>%1', 0);
                                if CustLedgerEntry.FindFirst then
                                    SendSmtpMail.SendCustomerStatmentAsPDF(Rec);
                            until Rec.Next = 0;
                        Rec.Reset;
                        CurrPage.Update(true);
                    end else
                        Message(TEXT001);


                end;
            }
        }
        addafter("Customer - Top 10 List")
        {
            action("<Report Customer Contact>")
            {
                Caption = 'Customer Contact Detail';
                Ellipsis = true;
                Image = Calls;
                RunObject = Report "Contact Detail (Excel)";
                ApplicationArea = all;
            }
        }
        addafter(ReportCustomerPaymentReceipt)
        {
            action(STKPLACEMENT)
            {
                Caption = 'STK PLACEMENT';
                Image = "Report";
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "STK PLACEMENT1";
                ApplicationArea = all;
            }
            action(SalesDiscountRecoveryReport)
            {
                RunObject = Report "Sales Discount Recovery Report";
                ApplicationArea = all;
            }
        }
        modify(ReportAgedAccountsReceivable)
        {
            Visible = false;
        }
        addafter(ReportCustomerSummaryAging)
        {
            action(ReportAgedAccountsReceivable1)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Aged Accounts Receivable';
                Image = "Report";
                RunObject = Report "Aged Accounts Receivable Ext";
                ToolTip = 'View an overview of when customer payments are due or overdue, divided into four periods. You must specify the date you want aging calculated from and the length of the period that each column will contain data for.';
            }

            action(TestZPLLabelPrint)
            {
                ApplicationArea = all;
                Caption = 'TestZPLLabelPrint';
                Image = "Report";
                trigger OnAction()
                var
                    ZPLTestPrint: Codeunit ZPLTestPrint;
                begin
                    ZPLTestPrint.TestPrint();
                end;

            }


        }

        addafter(PriceLines)
        {
            action(CustomerPriceLines)
            {
                AccessByPermission = TableData "Sales Price Access" = R;
                ApplicationArea = All;
                Caption = 'Customer Sales Prices';
                Image = Price;
                Scope = Repeater;
                ToolTip = 'View or set up sales price lines for products that you sell to the customer. A product price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';

                RunObject = page "Price List Line New";
                RunPageLink = "Assign-to No." = field("No.");
            }
        }


        addafter(PriceLines_Promoted)
        {
            actionref(CustomerPriceLines_P; CustomerPriceLines)
            {
            }
        }

    }

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        Rec.Ascending(false);
        if Rec.FindFirst() then;
    end;

    var
        ExpirePriceContactEmail: Text[100];
        SalesPersonName: Text[100];
        SalesPrice: Report "Exprie Sales Price Batch";
        RecCust: Record Customer;
        pageExpiredSalesPrices: Page "Expired Sales Prices";
        recExpirceSalesPrice: Record "Price List Line";
        pageExpiredSalesPricesDisc: Page "Expired Sales Prices(Disc)";

    trigger OnAfterGetRecord()
    var
        recContact: Record Contact;
        ContBusRel: Record "Contact Business Relation";
    begin
        SalesPersonName := GetSalesPersonName(Rec."Salesperson Code");
        ExpirePriceContactEmail := '';
        ContBusRel.SetCurrentKey("Link to Table", "No.");
        ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
        ContBusRel.SetRange("No.", rec."No.");
        if ContBusRel.FindFirst() then begin
            recContact.SetRange("Company No.", ContBusRel."Contact No.");
            recContact.SetRange("Expired Price", True);
            IF recContact.FindFirst then
                repeat
                    ExpirePriceContactEmail := ExpirePriceContactEmail + ',' + recContact."E-Mail";
                until recContact.Next = 0;
        end;
    end;

    procedure GetSalesPersonName(SalesPersonCode: Code[30]): Text
    var
        recSalesPersonPurchaser: Record "Salesperson/Purchaser";
    begin
        if recSalesPersonPurchaser.Get(SalesPersonCode) then
            exit(recSalesPersonPurchaser.Name);
    end;

    procedure MailCountFN(RecNo: Code[20]): Integer
    var
        RecMailDetail: Record "Mail Detail";
        TotalNo: Integer;
    begin
        RecMailDetail.Reset;
        RecMailDetail.SetCurrentKey("Source No.", "Date Time");
        RecMailDetail.SetRange("Source No.", RecNo);
        if RecMailDetail.FindSet then
            TotalNo := RecMailDetail.Count;
        exit(TotalNo);
    end;

    procedure LastDateMailSentFN(CustNo: Code[20]): DateTime
    var
        RecMailDetails: Record "Mail Detail";
        LastSentDate: DateTime;
    begin
        RecMailDetails.Reset;
        RecMailDetails.SetCurrentKey("Source No.", "Date Time");
        RecMailDetails.SetRange("Source No.", CustNo);
        if RecMailDetails.FindLast then
            LastSentDate := RecMailDetails."Date Time";
        exit(LastSentDate);
    end;
}
