page 50016 "Customer Aging FactBox"
{
    Caption = 'Customer Details';
    PageType = CardPart;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            field("No."; Rec."No.")
            {
                ApplicationArea = all;
                Caption = 'Customer No.';

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            field("Balance (LCY)"; Rec."Balance (LCY)")
            {
                ApplicationArea = all;

                trigger OnDrillDown()
                var
                    DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                    CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    DtldCustLedgEntry.SetRange("Customer No.", Rec."No.");
                    Rec.CopyFilter("Global Dimension 1 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 1");
                    Rec.CopyFilter("Global Dimension 2 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 2");
                    Rec.CopyFilter("Currency Filter", DtldCustLedgEntry."Currency Code");
                    CustLedgEntry.DrillDownOnEntries(DtldCustLedgEntry);
                end;
            }
            field(CurrentBalance; CurrentBalance)
            {
                ApplicationArea = all;
                Caption = 'Current Balance';

                trigger OnDrillDown()
                var
                    DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                    CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    CustLedgEntry.Reset;
                    DtldCustLedgEntry.CopyFilter("Customer No.", CustLedgEntry."Customer No.");
                    DtldCustLedgEntry.CopyFilter("Currency Code", CustLedgEntry."Currency Code");
                    DtldCustLedgEntry.CopyFilter("Initial Entry Global Dim. 1", CustLedgEntry."Global Dimension 1 Code");
                    DtldCustLedgEntry.CopyFilter("Initial Entry Global Dim. 2", CustLedgEntry."Global Dimension 2 Code");
                    CustLedgEntry.SetCurrentKey("Customer No.", "Due Date");
                    CustLedgEntry.SetRange("Customer No.", Rec."No.");
                    CustLedgEntry.SetFilter("Due Date", '%..', WorkDate);
                    CustLedgEntry.SetRange(Open, true);
                    PAGE.Run(0, CustLedgEntry);
                end;
            }
            field(Balance30; Balance30)
            {
                ApplicationArea = all;
                Caption = '0-30 Days:';

                trigger OnDrillDown()
                var
                    DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                    CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    CustLedgEntry.Reset;
                    DtldCustLedgEntry.CopyFilter("Customer No.", CustLedgEntry."Customer No.");
                    DtldCustLedgEntry.CopyFilter("Currency Code", CustLedgEntry."Currency Code");
                    DtldCustLedgEntry.CopyFilter("Initial Entry Global Dim. 1", CustLedgEntry."Global Dimension 1 Code");
                    DtldCustLedgEntry.CopyFilter("Initial Entry Global Dim. 2", CustLedgEntry."Global Dimension 2 Code");
                    CustLedgEntry.SetCurrentKey("Customer No.", "Due Date");
                    CustLedgEntry.SetRange("Customer No.", Rec."No.");
                    CustLedgEntry.SetRange("Due Date", CalcDate('<-30D>', WorkDate), CalcDate('<-1D>', WorkDate));
                    CustLedgEntry.SetRange(Open, true);
                    PAGE.Run(0, CustLedgEntry);
                end;
            }
            field(Balance60; Balance60)
            {
                ApplicationArea = all;
                Caption = '31-60 Days:';

                trigger OnDrillDown()
                var
                    DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                    CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    CustLedgEntry.Reset;
                    DtldCustLedgEntry.CopyFilter("Customer No.", CustLedgEntry."Customer No.");
                    DtldCustLedgEntry.CopyFilter("Currency Code", CustLedgEntry."Currency Code");
                    DtldCustLedgEntry.CopyFilter("Initial Entry Global Dim. 1", CustLedgEntry."Global Dimension 1 Code");
                    DtldCustLedgEntry.CopyFilter("Initial Entry Global Dim. 2", CustLedgEntry."Global Dimension 2 Code");
                    CustLedgEntry.SetCurrentKey("Customer No.", "Due Date");
                    CustLedgEntry.SetRange("Customer No.", Rec."No.");
                    CustLedgEntry.SetRange("Due Date", CalcDate('<-60D>', WorkDate), CalcDate('<-31D>', WorkDate));
                    CustLedgEntry.SetRange(Open, true);
                    PAGE.Run(0, CustLedgEntry);
                end;
            }
            field(Balance90; Balance90)
            {
                ApplicationArea = all;
                Caption = '61-90 Days:';

                trigger OnDrillDown()
                var
                    DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                    CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    CustLedgEntry.Reset;
                    DtldCustLedgEntry.CopyFilter("Customer No.", CustLedgEntry."Customer No.");
                    DtldCustLedgEntry.CopyFilter("Currency Code", CustLedgEntry."Currency Code");
                    DtldCustLedgEntry.CopyFilter("Initial Entry Global Dim. 1", CustLedgEntry."Global Dimension 1 Code");
                    DtldCustLedgEntry.CopyFilter("Initial Entry Global Dim. 2", CustLedgEntry."Global Dimension 2 Code");
                    CustLedgEntry.SetCurrentKey("Customer No.", "Due Date");
                    CustLedgEntry.SetRange("Customer No.", Rec."No.");
                    CustLedgEntry.SetRange("Due Date", CalcDate('<-90D>', WorkDate), CalcDate('<-61D>', WorkDate));
                    CustLedgEntry.SetRange(Open, true);
                    PAGE.Run(0, CustLedgEntry);
                end;
            }
            field(Balance91above; Balance91above)
            {
                ApplicationArea = all;
                Caption = 'Above 91 Days:';

                trigger OnDrillDown()
                var
                    DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                    CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    CustLedgEntry.Reset;
                    DtldCustLedgEntry.CopyFilter("Customer No.", CustLedgEntry."Customer No.");
                    DtldCustLedgEntry.CopyFilter("Currency Code", CustLedgEntry."Currency Code");
                    DtldCustLedgEntry.CopyFilter("Initial Entry Global Dim. 1", CustLedgEntry."Global Dimension 1 Code");
                    DtldCustLedgEntry.CopyFilter("Initial Entry Global Dim. 2", CustLedgEntry."Global Dimension 2 Code");
                    CustLedgEntry.SetCurrentKey("Customer No.", "Due Date");
                    CustLedgEntry.SetRange("Customer No.", Rec."No.");
                    CustLedgEntry.SetRange("Due Date", 0D, CalcDate('<-91D>', WorkDate));
                    CustLedgEntry.SetRange(Open, true);
                    PAGE.Run(0, CustLedgEntry);
                end;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Actions")
            {
                Caption = 'Actions';
                Image = "Action";
                action("Ship-to Address")
                {
                    ApplicationArea = all;
                    Caption = 'Ship-to Address';
                    RunObject = Page "Ship-to Address List";
                    RunPageLink = "Customer No." = FIELD("No.");
                }
                action(Comments)
                {
                    ApplicationArea = all;
                    Caption = 'Comments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Customer),
                                  "No." = FIELD("No.");
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleTxt := Rec.SetStyle;
        CurrentBalance := CurrrntBal(Rec."No.");
        Balance30 := CustomerAging30(Rec."No.");
        Balance60 := CustomerAging60(Rec."No.");
        Balance90 := CustomerAging90(Rec."No.");
        Balance91above := CustomerAging91Above(Rec."No.");
    end;

    var
        StyleTxt: Text;
        CurrentBalance: Decimal;
        Balance30: Decimal;
        Balance60: Decimal;
        Balance90: Decimal;
        Balance91above: Decimal;


    procedure ShowDetails()
    begin
        PAGE.Run(PAGE::"Customer Card", Rec);
    end;

    procedure CurrrntBal(CustomerNo: Code[20]): Decimal
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        BalanceAmt: Decimal;
    begin
        CustLedgEntry.SetCurrentKey("Customer No.", "Due Date");
        CustLedgEntry.SetRange("Customer No.", Rec."No.");
        CustLedgEntry.SetFilter("Due Date", '%..', WorkDate);
        if CustLedgEntry.FindFirst then
            repeat
                CustLedgEntry.CalcFields("Remaining Amt. (LCY)");
                BalanceAmt += CustLedgEntry."Remaining Amt. (LCY)";
            until CustLedgEntry.Next = 0;
        exit(BalanceAmt);
    end;

    procedure CustomerAging30(CustomerNo: Code[20]): Decimal
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        BalanceAmt: Decimal;
    begin
        CustLedgEntry.SetCurrentKey("Customer No.", "Due Date");
        CustLedgEntry.SetRange("Customer No.", Rec."No.");
        CustLedgEntry.SetRange("Due Date", CalcDate('<-30D>', WorkDate), CalcDate('<-1D>', WorkDate));
        if CustLedgEntry.FindFirst then
            repeat
                CustLedgEntry.CalcFields("Remaining Amt. (LCY)");
                BalanceAmt += CustLedgEntry."Remaining Amt. (LCY)";
            until CustLedgEntry.Next = 0;
        exit(BalanceAmt);
    end;


    procedure CustomerAging60(CustomerNo: Code[20]): Decimal
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        BalanceAmt: Decimal;
    begin
        CustLedgEntry.SetCurrentKey("Customer No.", "Due Date");
        CustLedgEntry.SetRange("Customer No.", Rec."No.");
        CustLedgEntry.SetRange("Due Date", CalcDate('<-60D>', WorkDate), CalcDate('<-31D>', WorkDate));
        if CustLedgEntry.FindFirst then
            repeat
                CustLedgEntry.CalcFields("Remaining Amt. (LCY)");
                BalanceAmt += CustLedgEntry."Remaining Amt. (LCY)";
            until CustLedgEntry.Next = 0;
        exit(BalanceAmt);
    end;

    procedure CustomerAging90(CustomerNo: Code[20]): Decimal
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        BalanceAmt: Decimal;
    begin
        CustLedgEntry.SetCurrentKey("Customer No.", "Due Date");
        CustLedgEntry.SetRange("Customer No.", Rec."No.");
        CustLedgEntry.SetRange("Due Date", CalcDate('<-90D>', WorkDate), CalcDate('<-61D>', WorkDate));
        if CustLedgEntry.FindFirst then
            repeat
                CustLedgEntry.CalcFields("Remaining Amt. (LCY)");
                BalanceAmt += CustLedgEntry."Remaining Amt. (LCY)";
            until CustLedgEntry.Next = 0;
        exit(BalanceAmt);
    end;

    procedure CustomerAging91Above(CustomerNo: Code[20]): Decimal
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        BalanceAmt: Decimal;
    begin
        CustLedgEntry.SetCurrentKey("Customer No.", "Due Date");
        CustLedgEntry.SetRange("Customer No.", Rec."No.");
        CustLedgEntry.SetRange("Due Date", 0D, CalcDate('<-91D>', WorkDate));
        if CustLedgEntry.FindFirst then
            repeat
                CustLedgEntry.CalcFields("Remaining Amt. (LCY)");
                BalanceAmt += CustLedgEntry."Remaining Amt. (LCY)";
            until CustLedgEntry.Next = 0;
        exit(BalanceAmt);
    end;
}

