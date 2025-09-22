page 50141 "Customer Detail"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                }
                field(OpenOrders1; OpenOrders)
                {
                    ApplicationArea = all;
                    Caption = 'Open Orders';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        SalesOrder: Record "Sales Header";
                    begin
                        SalesOrder.Reset;
                        SalesOrder.SetCurrentKey("Document Type", "No.");
                        SalesOrder.SetRange(SalesOrder."Document Type", SalesOrder."Document Type"::Order);
                        SalesOrder.SetRange(SalesOrder."Sell-to Customer No.", Rec."No.");
                        PAGE.Run(PAGE::"Sales Order List", SalesOrder);
                    end;
                }
                field(NoOfOrderLines1; NoOfOrderLines)
                {
                    ApplicationArea = all;
                    Caption = 'Open Order Lines';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        SalesLine: Record "Sales Line";
                    begin
                        SalesLine.Reset;
                        SalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
                        SalesLine.SetRange(SalesLine."Document Type", SalesLine."Document Type"::Order);
                        SalesLine.SetRange(SalesLine."Sell-to Customer No.", Rec."No.");
                        SalesLine.SetFilter(SalesLine."Outstanding Quantity", '<>%1', 0);
                        PAGE.Run(PAGE::"Sales Order Subform", SalesLine);
                    end;
                }
                field(OrderOutstandingAmount1; OrderOutstandingAmount)
                {
                    ApplicationArea = all;
                    Caption = 'Orders Amount';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        SalesLine: Record "Sales Line";
                    begin
                        SalesLine.Reset;
                        SalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
                        SalesLine.SetRange(SalesLine."Document Type", SalesLine."Document Type"::Order);
                        SalesLine.SetRange(SalesLine."Sell-to Customer No.", Rec."No.");
                        SalesLine.SetFilter(SalesLine."Outstanding Quantity", '<>%1', 0);
                        PAGE.Run(PAGE::"Sales Order Subform", SalesLine);
                    end;
                }
                field(GetSalesInvoicesPrev1; GetSalesInvoicesPrev)
                {
                    ApplicationArea = all;
                    Caption = 'Total Invoices (Prev.)';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CLE: Record "Cust. Ledger Entry";
                    begin
                        StartDate := AccountingPeriod.GetFiscalYearStartDate(WorkDate);
                        EndDate := AccountingPeriod.GetFiscalYearEndDate(WorkDate);
                        CLE.Reset;
                        CLE.SetRange(CLE."Customer No.", Rec."No.");
                        CLE.SetRange(CLE."Document Type", CLE."Document Type"::Invoice);
                        CLE."SecurityFiltering"(Rec."SecurityFiltering");
                        CLE.SetRange("Posting Date", 0D, CalcDate('<-1D>', StartDate));
                        PAGE.Run(PAGE::"Customer Ledger Entries", CLE);
                    end;
                }
                field(TotalInvoice1; GetSalesInvoices)
                {
                    ApplicationArea = all;
                    Caption = 'Total Invoice (Curr.)';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CLE: Record "Cust. Ledger Entry";
                    begin
                        StartDate := AccountingPeriod.GetFiscalYearStartDate(WorkDate);
                        EndDate := AccountingPeriod.GetFiscalYearEndDate(WorkDate);
                        CLE.Reset;
                        CLE.SetRange(CLE."Customer No.", Rec."No.");
                        CLE.SetRange(CLE."Document Type", CLE."Document Type"::Invoice);
                        CLE."SecurityFiltering"(Rec."SecurityFiltering");
                        CLE.SetRange("Posting Date", StartDate, EndDate);
                        PAGE.Run(PAGE::"Customer Ledger Entries", CLE);
                    end;
                }
                field(GetSalesTotalPrev1; GetSalesTotalPrev)
                {
                    ApplicationArea = all;
                    Caption = 'Total Invoices Value (Prev.)';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CLE: Record "Cust. Ledger Entry";
                    begin
                        StartDate := AccountingPeriod.GetFiscalYearStartDate(WorkDate);
                        EndDate := AccountingPeriod.GetFiscalYearEndDate(WorkDate);
                        CLE.Reset;
                        CLE.SetRange(CLE."Customer No.", Rec."No.");
                        CLE.SetRange(CLE."Document Type", CLE."Document Type"::Invoice);
                        CLE."SecurityFiltering"(Rec."SecurityFiltering");
                        CLE.SetRange("Posting Date", 0D, CalcDate('<-1D>', StartDate));
                        PAGE.Run(PAGE::"Customer Ledger Entries", CLE);
                    end;
                }
                field(InvoiceAmount1; GetSalesTotal)
                {
                    ApplicationArea = all;
                    Caption = 'Total Invoice Value (Curr.)';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CLE: Record "Cust. Ledger Entry";
                    begin
                        StartDate := AccountingPeriod.GetFiscalYearStartDate(WorkDate);
                        EndDate := AccountingPeriod.GetFiscalYearEndDate(WorkDate);
                        CLE.Reset;
                        CLE.SetRange(CLE."Customer No.", Rec."No.");
                        CLE.SetRange(CLE."Document Type", CLE."Document Type"::Invoice);
                        CLE."SecurityFiltering"(Rec."SecurityFiltering");
                        CLE.SetRange("Posting Date", StartDate, EndDate);
                        PAGE.Run(PAGE::"Customer Ledger Entries", CLE);
                    end;
                }
            }
            part(SalesLine; "Sales Lines New Cust Detail")
            {
                ApplicationArea = all;
                Caption = 'Sales Line';
                SubPageLink = "Sell-to Customer No." = FIELD("No.");
                SubPageView = SORTING("Document Type", "Document No.", "Line No.")
                              ORDER(Descending)
                              WHERE("Document Type" = CONST(Order),
                                    "Outstanding Quantity" = FILTER(<> 0));
            }
            part(SalesInvLine; "Sales Invoice LineCust Detail")
            {
                ApplicationArea = all;
                Caption = 'Sales Invoice Line';
                SubPageLink = "Sell-to Customer No." = FIELD("No.");
                SubPageView = SORTING("Document No.", "Line No.")
                              ORDER(Descending);
            }
            part(CustomerLedgerEntries; "Customer Ledger Entries Cust D")
            {
                ApplicationArea = all;
                Caption = 'Customer Ledger Entries';
                SubPageLink = "Customer No." = FIELD("No.");
                SubPageView = SORTING("Customer No.", "Posting Date", "Currency Code")
                              ORDER(Descending)
                              WHERE("Remaining Amount" = FILTER(<> 0));
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        CurrPage.Update;
    end;

    var
        InvAmount: Decimal;
        AccountingPeriod: Record "Accounting Period";
        StartDate: Date;
        EndDate: Date;

    procedure ShowHideBTN(): Boolean
    begin
        exit(true);
    end;

    procedure OpenOrders(): Integer
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Reset;
        SalesHeader.SetCurrentKey("Document Type", "No.");
        SalesHeader.SetRange(SalesHeader."Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange(SalesHeader."Sell-to Customer No.", Rec."No.");
        SalesHeader.SetFilter(SalesHeader."Outstanding Amount ($)", '<>%1', 0);
        exit(SalesHeader.Count);
    end;

    procedure NoOfOrderLines(): Integer
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset;
        SalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        SalesLine.SetRange(SalesLine."Sell-to Customer No.", Rec."No.");
        SalesLine.SetRange(SalesLine."Document Type", SalesLine."Document Type"::Order);
        //SalesLine.SETRANGE(SalesLine.Type,SalesLine.Type::Item);
        SalesLine.SetFilter(SalesLine."Outstanding Amount", '<>%1', 0);
        exit(SalesLine.Count);
    end;

    procedure OrderOutstandingAmount(): Decimal
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset;
        SalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        SalesLine.SetRange(SalesLine."Sell-to Customer No.", Rec."No.");
        SalesLine.SetRange(SalesLine."Document Type", SalesLine."Document Type"::Order);
        //SalesLine.SETRANGE(SalesLine.Type,SalesLine.Type::Item);
        SalesLine.SetFilter(SalesLine."Outstanding Amount", '<>%1', 0);
        SalesLine.CalcSums(SalesLine."Outstanding Amount");
        exit(SalesLine."Outstanding Amount");
    end;

    procedure TotalInvoice(): Integer
    var
        CLE: Record "Cust. Ledger Entry";
    begin
        CLE.Reset;
        CLE.SetRange(CLE."Customer No.", Rec."No.");
        CLE.SetRange(CLE."Document Type", CLE."Document Type"::Invoice);
        exit(CLE.Count);
    end;

    procedure InvoiceAmount(): Decimal
    var
        CLE: Record "Cust. Ledger Entry";
    begin
        InvAmount := 0;
        CLE.Reset;
        CLE.SetRange(CLE."Customer No.", Rec."No.");
        CLE.SetRange(CLE."Document Type", CLE."Document Type"::Invoice);
        if CLE.FindFirst then
            repeat
                CLE.CalcFields("Amount (LCY)");
                InvAmount += CLE."Amount (LCY)";
            until CLE.Next = 0;
        exit(InvAmount);
    end;

    procedure GetSalesTotal(): Decimal
    var
        CustomerSalesYTD: Record Customer;
    begin
        StartDate := AccountingPeriod.GetFiscalYearStartDate(WorkDate);
        EndDate := AccountingPeriod.GetFiscalYearEndDate(WorkDate);
        CustomerSalesYTD := Rec;
        CustomerSalesYTD."SecurityFiltering"(Rec."SecurityFiltering");
        CustomerSalesYTD.SetRange("Date Filter", StartDate, EndDate);
        CustomerSalesYTD.CalcFields("Sales (LCY)");
        exit(CustomerSalesYTD."Sales (LCY)");
    end;

    procedure GetSalesInvoices(): Integer
    var
        CLE: Record "Cust. Ledger Entry";
    begin
        StartDate := AccountingPeriod.GetFiscalYearStartDate(WorkDate);
        EndDate := AccountingPeriod.GetFiscalYearEndDate(WorkDate);
        CLE.Reset;
        CLE.SetRange(CLE."Customer No.", Rec."No.");
        CLE.SetRange(CLE."Document Type", CLE."Document Type"::Invoice);
        CLE."SecurityFiltering"(Rec."SecurityFiltering");
        CLE.SetRange("Posting Date", StartDate, EndDate);
        exit(CLE.Count);
    end;

    procedure GetSalesTotalPrev(): Decimal
    var
        CustomerSalesYTD: Record Customer;
    begin
        StartDate := AccountingPeriod.GetFiscalYearStartDate(WorkDate);
        EndDate := AccountingPeriod.GetFiscalYearEndDate(WorkDate);
        CustomerSalesYTD := Rec;
        CustomerSalesYTD."SecurityFiltering"(Rec."SecurityFiltering");
        CustomerSalesYTD.SetRange("Date Filter", 0D, CalcDate('<-1D>', StartDate));
        CustomerSalesYTD.CalcFields("Sales (LCY)");
        exit(CustomerSalesYTD."Sales (LCY)");
    end;

    procedure GetSalesInvoicesPrev(): Integer
    var
        CLE: Record "Cust. Ledger Entry";
    begin
        StartDate := AccountingPeriod.GetFiscalYearStartDate(WorkDate);
        EndDate := AccountingPeriod.GetFiscalYearEndDate(WorkDate);
        CLE.Reset;
        CLE.SetRange(CLE."Customer No.", Rec."No.");
        CLE.SetRange(CLE."Document Type", CLE."Document Type"::Invoice);
        CLE."SecurityFiltering"(Rec."SecurityFiltering");
        CLE.SetRange("Posting Date", 0D, CalcDate('<-1D>', StartDate));
        exit(CLE.Count);
    end;
}

