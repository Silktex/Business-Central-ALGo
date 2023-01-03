pageextension 50223 "Applied Customer Entries_Ext" extends "Applied Customer Entries"
{

    layout
    {
        modify("Posting Date")
        {
            StyleExpr = StyleText;
        }
        modify("Document Type")
        {
            StyleExpr = StyleText;
        }
        modify("Document No.")
        {
            StyleExpr = StyleText;
        }
        modify(Description)
        {
            StyleExpr = StyleText;
        }
        addafter("Currency Code")
        {
            field(PaidFutureAppAmnt; PaidFutureAppAmnt)
            {
                Caption = 'Paid/Future Applied No.';
                ApplicationArea = all;
            }
            field("Remaining Amount"; Rec."Remaining Amount")
            {
                ApplicationArea = all;
            }
        }
        addafter("Closed by Amount")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Entry No.")
        {
            field("Detailed Entry"; Rec."Detailed Entry")
            {
                Visible = false;
                ApplicationArea = all;
            }
            field("Ref. Document No."; Rec."Ref. Document No.")
            {
                Visible = false;
                ApplicationArea = all;
            }
        }
    }
    var
        CreateCustLedgEntry: Record "Cust. Ledger Entry";

    trigger OnOpenPage()
    begin
        if Rec."Entry No." <> 0 then begin
            CreateCustLedgEntry := Rec;

            EntryNo := CreateCustLedgEntry."Entry No.";
            DocNo := CreateCustLedgEntry."Document No.";

            FindApplnEntriesDtldtLedgEntry();
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        StyleText := SetStyle1;
    end;

    trigger OnAfterGetRecord()
    begin
        StyleText := SetStyle1;

        PaidFutureAppAmnt := 0;
        RecPaidFut.Reset;
        RecPaidFut.SetRange("Document No.", DocNo);
        RecPaidFut.SetRange("Invoice No.", Rec."Document No.");
        if RecPaidFut.FindFirst then
            PaidFutureAppAmnt := RecPaidFut.Amount;
    end;

    var
        recDLE: Record "Detailed Cust. Ledg. Entry";
        recCLE: Record "Cust. Ledger Entry";
        Bool: Boolean;
        StyleText: Text[30];
        EntryNo: Integer;
        DocNo: Code[20];
        RecPaidFut: Record "Payment Future Old Inv";
        PaidFutureAppAmnt: Decimal;

    procedure SetStyleN(): Text
    begin
        if Rec.Open then begin
            if WorkDate > Rec."Due Date" then
                exit('Unfavorable')
        end else
            if Rec."Closed at Date" > Rec."Due Date" then
                exit('Attention');
        exit('');
    end;

    procedure FindApplnEntriesDtldtLedgEntry1(CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        DtldCustLedgEntry1: Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
    begin
        DtldCustLedgEntry1.Reset;
        DtldCustLedgEntry1.SetCurrentKey("Cust. Ledger Entry No.");
        DtldCustLedgEntry1.SetRange("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
        DtldCustLedgEntry1.SetRange(Unapplied, false);
        if DtldCustLedgEntry1.Find('-') then
            repeat
                if DtldCustLedgEntry1."Cust. Ledger Entry No." =
                   DtldCustLedgEntry1."Applied Cust. Ledger Entry No."
                then begin
                    DtldCustLedgEntry2.Reset;
                    DtldCustLedgEntry2.Init;
                    DtldCustLedgEntry2.SetCurrentKey("Applied Cust. Ledger Entry No.", "Entry Type");
                    DtldCustLedgEntry2.SetRange(
                      "Applied Cust. Ledger Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                    DtldCustLedgEntry2.SetRange("Entry Type", DtldCustLedgEntry2."Entry Type"::Application);
                    DtldCustLedgEntry2.SetRange(Unapplied, false);
                    if DtldCustLedgEntry2.Find('-') then
                        repeat
                            if DtldCustLedgEntry2."Cust. Ledger Entry No." <>
                               DtldCustLedgEntry2."Applied Cust. Ledger Entry No."
                            then begin
                                Rec.SetCurrentKey("Entry No.");
                                Rec.SetRange("Entry No.", DtldCustLedgEntry2."Cust. Ledger Entry No.");
                                if Rec.Find('-') then
                                    Rec.Mark(true);
                            end;
                        until DtldCustLedgEntry2.Next = 0;
                end else begin
                    Rec.SetCurrentKey("Entry No.");
                    Rec.SetRange("Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                    if Rec.Find('-') then
                        if not Rec.Mark then
                            Rec.Mark(true);
                end;
            until DtldCustLedgEntry1.Next = 0;
    end;

    procedure SetStyle1(): Text
    begin
        //IF Open THEN BEGIN
        //IF WORKDATE > "Due Date" THEN

        if Rec."Ref. Document No." = Format(EntryNo) then
            exit('Unfavorable')
        else
            RecPaidFut.Reset;
        RecPaidFut.SetRange("Document No.", DocNo);
        RecPaidFut.SetRange("Invoice No.", Rec."Document No.");
        if RecPaidFut.FindFirst then
            exit('Attention');
        exit('');
    end;

    local procedure FindApplnEntriesDtldtLedgEntry()
    var
        DtldCustLedgEntry1: Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
    begin
        /*  RecPaidFut.RESET;
          RecPaidFut.SETRANGE("Document No.",CreateCustLedgEntry."Document No.");
          IF RecPaidFut.FINDSET THEN
            REPEAT
            recCLE.RESET;
            recCLE.SETFILTER("Document No.",RecPaidFut."Invoice No.");
            recCLE.SETRANGE("Document Type",recCLE."Document Type"::"Credit Memo");
            IF recCLE.FIND('-') THEN BEGIN
               FindApplnEntriesDtldtLedgEntry1(recCLE);
            END;
            UNTIL RecPaidFut.NEXT=0;
        */
        recCLE.Reset;
        recCLE.SetFilter("Ref. Document No.", Format(CreateCustLedgEntry."Entry No."));
        recCLE.SetRange("Document Type", recCLE."Document Type"::"Credit Memo");
        if recCLE.Find('-') then begin
            FindApplnEntriesDtldtLedgEntry1(recCLE);
        end;

        RecPaidFut.Reset;
        RecPaidFut.SetRange("Document No.", CreateCustLedgEntry."Document No.");
        if RecPaidFut.FindSet then
            repeat
                recCLE.Reset;
                recCLE.SetFilter("Document No.", RecPaidFut."Invoice No.");
                //recCLE.SETRANGE("Document Type",recCLE."Document Type"::"Invoice");
                if recCLE.Find('-') then begin
                    repeat
                        Rec.SetCurrentKey("Entry No.");
                        Rec.SetRange("Entry No.", recCLE."Entry No.");
                        if Rec.Find('-') then
                            Rec.Mark(true);
                    //END;
                    until recCLE.Next = 0;
                end;
            until RecPaidFut.Next = 0;

    end;
}
