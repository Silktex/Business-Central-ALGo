pageextension 50241 "Apply Customer Entries_Ext" extends "Apply Customer Entries"
{
    layout
    {
        // addafter("Document No.")
        // {
        //     field("External Document No."; Rec."External Document No.")
        //     {
        //         ApplicationArea = all;
        //     }
        // }
        addafter("Global Dimension 2 Code")
        {
            field("Future/Paid Invoice"; Rec."Future/Paid Invoice")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }
    actions
    {

        addafter(Dimensions)
        {
            action(UpdatePaidFutureInvoice)
            {
                Caption = '&Paid Future Invoice';
                ApplicationArea = all;

                trigger OnAction()
                begin
                    Rec.PaidInvoice(ApplyingCustLedgEntry);
                end;
            }

        }
    }
    var
        recPF: Record "Payment Future Old Inv";
        recCust: Record Customer;
        pgPF: Page "Paid/Future Invoice";
        i: Integer;
        cdAppDocNo: array[50] of Code[20];
        cdAppDocAmt: array[50] of Decimal;
        cdRefDocNo: Code[20];
        cdRemAmt: array[50] of Decimal;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        recPF1: Record "Payment Future Old Inv";
        recGJL: Record "Gen. Journal Line";
        decAmtToApply: Decimal;
        decAmount: Decimal;
        recCustLedEntry: Record "Cust. Ledger Entry";
        cdDocNo: Code[20];
        recCustPostGroup: Record "Customer Posting Group";
        DocNo: Code[20];
        AccNo: Code[20];
        LineNo: Integer;
        cdAppcmNo: Code[20];
        recGJB: Record "Gen. Journal Batch";
        cuNoSeries: Codeunit "No. Series";
        recCLE1: Record "Cust. Ledger Entry";
        decAmnt: Decimal;
        Bool1: Boolean;
        ApplyingCustLedgEntry: Record "Cust. Ledger Entry" temporary;

    procedure SetApplId(var CustLedgEntry: Record "Cust. Ledger Entry"; AppliesToID: Code[50]; recGJL: Record "Gen. Journal Line"; Amt: Decimal)
    var
        CustEntryApplID: Code[50];
    begin
        CustLedgEntry.LockTable;
        if CustLedgEntry.Find('-') then begin
            // Make Applies-to ID
            //IF CustLedgEntry."Applies-to ID" <> '' THEN
            //CustEntryApplID := ''
            //ELSE BEGIN
            CustEntryApplID := AppliesToID;
            if CustEntryApplID = '' then begin
                CustEntryApplID := UserId;
                if CustEntryApplID = '' then
                    CustEntryApplID := '***';
            end;
            //END;

            // Set Applies-to ID
            repeat
                //CustLedgEntry.TESTFIELD(Open,TRUE);
                if not CustLedgEntry.Open then
                    CustLedgEntry.Open := true;
                CustLedgEntry."Applies-to ID" := CustEntryApplID;
                if CustLedgEntry."Applies-to ID" = '' then begin
                    CustLedgEntry."Accepted Pmt. Disc. Tolerance" := false;
                    CustLedgEntry."Accepted Payment Tolerance" := 0;
                end;
                // Set Amount to Apply
                CustLedgEntry."Amount to Apply" := 0;
                /*IF ((CustLedgEntry."Amount to Apply" <> 0) AND (CustEntryApplID = '')) OR
                   (CustEntryApplID = '')
                THEN
                  CustLedgEntry."Amount to Apply" := 0
                ELSE  */
                if CustLedgEntry."Amount to Apply" = 0 then begin
                    CustLedgEntry.CalcFields("Remaining Amount");
                    CustLedgEntry."Amount to Apply" := -Abs(Amt);
                end;

                CustLedgEntry.Modify;
            until CustLedgEntry.Next = 0;
        end;

    end;


    procedure CheckForJournal()
    var
        recGJL: Record "Gen. Journal Line";
        DocNo: Code[20];
        LineNo: Integer;
        AccNo: Code[20];
        recCust: Record Customer;
        recCustPostGroup: Record "Customer Posting Group";
        recCustLedEntry: Record "Cust. Ledger Entry";
    begin
        recGJL.Reset;
        recGJL.SetRange(recGJL."Journal Template Name", 'GENERAL');
        recGJL.SetRange(recGJL."Journal Batch Name", 'PFI');
        recGJL.SetRange("Document Type", recGJL."Document Type"::"Credit Memo");
        if recGJL.FindLast then begin
            if recGJL."Account Type" = recGJL."Account Type"::Customer then
                AccNo := recGJL."Account No."
            else
                if recGJL."Bal. Account Type" = recGJL."Bal. Account Type"::Customer then
                    AccNo := recGJL."Bal. Account No."
                else
                    AccNo := '';
            if AccNo = '' then
                Error('Account Type or Bal Account Type must be customer for future invoice');


            for i := 1 to 50 do begin

                //cdAppDocNo[i]
                CustLedgEntry.Reset;
                CustLedgEntry.SetRange("Document No.", cdAppDocNo[i]);
                CustLedgEntry.SetRange("Customer No.", AccNo);
                CustLedgEntry.SetRange(Open, true);
                //CustLedgEntry.SETRANGE("Document Type",CustLedgEntry."Document Type"::Invoice);
                if CustLedgEntry.Find('-') then begin
                    CustLedgEntry.CalcFields("Remaining Amount");
                    SetApplId1(CustLedgEntry, recGJL."Document No.", recGJL, cdRemAmt[i] - CustLedgEntry."Remaining Amount");
                    //(cdAppDocAmt[i]-(CustLedgEntry."Original Amount"-CustLedgEntry."Remaining Amount")));
                    //ELSE
                    //   ERROR('There is no open Customer Entry with Document No %1 ',recPF."Invoice No.");
                end;
            end;
        end;
        recGJL.Reset;
        recGJL.SetRange(recGJL."Journal Template Name", 'GENERAL');
        recGJL.SetRange(recGJL."Journal Batch Name", 'PFI');
        recGJL.SetRange("Document Type", recGJL."Document Type"::Invoice);
        if recGJL.FindLast then begin

            recPF.Reset;
            /*recPF.SETRANGE(recPF."Journal Template Name","Journal Template Name");
            recPF.SETRANGE(recPF."Journal Batch Name","Journal Batch Name");*/
            recPF.SetRange(recPF."Document No.", cdRefDocNo);
            //recPF.SETRANGE(recPF."Document Line No.",recGenJourLine."Line No.");
            if recPF.Find('-') then
                repeat
                    CustLedgEntry.Reset;
                    CustLedgEntry.SetRange("Document No.", recPF."Invoice No.");
                    CustLedgEntry.SetRange("Customer No.", AccNo);
                    //CustLedgEntry.SETRANGE(Open,TRUE);
                    CustLedgEntry.SetRange("Document Type", CustLedgEntry."Document Type"::Invoice);
                    if CustLedgEntry.Find('-') then
                        SetApplId(CustLedgEntry, recGJL."Document No.", recGJL, recPF.Amount)
                    else
                        Error('There is no open Customer Entry with Document No %1 ', recPF."Invoice No.");
                until recPF.Next = 0;
        end;



        recGJL.Reset;
        recGJL.SetRange(recGJL."Journal Template Name", 'GENERAL');
        recGJL.SetRange(recGJL."Journal Batch Name", 'PFI');
        recGJL.SetRange("Document Type", recGJL."Document Type"::"Credit Memo");
        if recGJL.FindSet then begin
            Clear(GenJnlPostLine);
            GenJnlPostLine.RunWithCheck(recGJL);
            //CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",recGJL);
        end;
        recGJL.Reset;
        recGJL.SetRange(recGJL."Journal Template Name", 'GENERAL');
        recGJL.SetRange(recGJL."Journal Batch Name", 'PFI');
        recGJL.SetRange("Document Type", recGJL."Document Type"::Invoice);
        if recGJL.FindSet then begin
            Clear(GenJnlPostLine);
            GenJnlPostLine.RunWithCheck(recGJL);
            //CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",recGJL);
        end;
        /*
         recGJL.RESET;
         recGJL.SETRANGE(recGJL."Journal Template Name",'GENERAL');
         recGJL.SETRANGE(recGJL."Journal Batch Name",'PFI');
         IF recGJL.FINDSET THEN
          REPEAT
            recCustLedEntry.RESET;
            recCustLedEntry.SETRANGE(recCustLedEntry."Applies-to ID",recGJL."Document No.");
            IF recCustLedEntry.FINDFIRST THEN
              recCustLedEntry.MODIFYALL("Applies-to ID",'');
          UNTIL recGJL.NEXT=0;
        */

    end;


    procedure SetApplId1(var CustLedgEntry: Record "Cust. Ledger Entry"; AppliesToID: Code[50]; recGJL: Record "Gen. Journal Line"; Amt: Decimal)
    var
        CustEntryApplID: Code[50];
    begin
        CustLedgEntry.LockTable;
        if CustLedgEntry.Find('-') then begin
            // Make Applies-to ID
            //IF CustLedgEntry."Applies-to ID" <> '' THEN
            //CustEntryApplID := ''
            //ELSE BEGIN
            CustEntryApplID := AppliesToID;
            if CustEntryApplID = '' then begin
                CustEntryApplID := UserId;
                if CustEntryApplID = '' then
                    CustEntryApplID := '***';
            end;
            //END;

            // Set Applies-to ID
            repeat
                //CustLedgEntry.TESTFIELD(Open,TRUE);
                if not CustLedgEntry.Open then
                    CustLedgEntry.Open := true;
                CustLedgEntry."Applies-to ID" := CustEntryApplID;
                if CustLedgEntry."Applies-to ID" = '' then begin
                    CustLedgEntry."Accepted Pmt. Disc. Tolerance" := false;
                    CustLedgEntry."Accepted Payment Tolerance" := 0;
                end;
                // Set Amount to Apply
                if ((CustLedgEntry."Amount to Apply" <> 0) and (CustEntryApplID = '')) or
                   (CustEntryApplID = '')
                then
                    CustLedgEntry."Amount to Apply" := 0
                else
                    if CustLedgEntry."Amount to Apply" = 0 then begin
                        CustLedgEntry.CalcFields("Remaining Amount");
                        CustLedgEntry."Amount to Apply" := Abs(Amt);
                    end;

                CustLedgEntry.Modify;
            until CustLedgEntry.Next = 0;
        end;
    end;


    procedure PaidFutureInvoice()
    begin
        recCust.Get(ApplyingCustLedgEntry."Customer No.");
        recPF1.Reset;
        recPF1.SetRange(recPF1."Document No.", ApplyingCustLedgEntry."Document No.");
        recPF1.SetRange(recPF1."Customer No.", ApplyingCustLedgEntry."Customer No.");
        recPF1.SetRange(recPF1."Entry No.", ApplyingCustLedgEntry."Entry No.");
        recPF1.SetFilter(Amount, '<>0');
        if recPF1.Find('-') then begin
            if recPF1."Invoice No." <> '' then begin
                cdRefDocNo := ApplyingCustLedgEntry."Document No.";
                recGJL.Reset;
                recGJL.SetRange(recGJL."Journal Template Name", 'GENERAL');
                recGJL.SetRange(recGJL."Journal Batch Name", 'PFI');
                //recGJL.SETRANGE("Document Type",recGJL."Document Type"::"Credit Memo");
                if recGJL.FindSet then begin
                    recGJL.DeleteAll;
                end;

                decAmount := 0;
                recPF.Reset;
                recPF.SetRange(recPF."Document No.", ApplyingCustLedgEntry."Document No.");
                recPF.SetRange(recPF."Customer No.", recCust."No.");
                recPF.SetRange(recPF."Entry No.", ApplyingCustLedgEntry."Entry No.");
                if recPF.Find('-') then
                    repeat
                        decAmount := decAmount + recPF.Amount
until recPF.Next = 0;
                recPF.Reset;
                recPF.SetRange(recPF."Document No.", ApplyingCustLedgEntry."Document No.");
                recPF.SetRange(recPF."Customer No.", recCust."No.");
                recPF.SetRange(recPF."Entry No.", ApplyingCustLedgEntry."Entry No.");
                if recPF.Find('-') then
                    repeat
                        recCustLedEntry.Reset;
                        recCustLedEntry.SetRange("Document No.", recPF."Invoice No.");
                        if recCustLedEntry.Find('-') then begin
                            recCustLedEntry."Ref. Document No." := ApplyingCustLedgEntry."Document No.";
                            recCustLedEntry.Modify;
                        end;

                    until recPF.Next = 0;
                DocNo := '';

                AccNo := ApplyingCustLedgEntry."Customer No.";
                recCust.Get(AccNo);
                recCustPostGroup.Get(recCust."Customer Posting Group");
                //Credit Note Creation
                recGJL.Reset;
                recGJL.SetRange(recGJL."Journal Template Name", 'GENERAL');
                recGJL.SetRange(recGJL."Journal Batch Name", 'PFI');
                if recGJL.FindLast then begin
                    LineNo := recGJL."Line No.";
                    DocNo := IncStr(recGJL."Document No.");
                end else begin
                    LineNo := 0;
                end;


                cdAppcmNo := '';
                recGJB.Get('GENERAL', 'PFI');
                Clear(cuNoSeries);
                DocNo := cuNoSeries.GetNextNo(recGJB."No. Series", Today, true);

                recGJL.Init;
                recGJL."Journal Template Name" := 'GENERAL';
                recGJL."Journal Batch Name" := 'PFI';
                recGJL."Line No." := LineNo + 10000;

                recGJL."Source Code" := 'GENJNL';
                //IF recGJL."Document No."='' THEN
                recGJL."Document No." := DocNo;
                //DocNo:=recGJL."Document No.";
                //DocNo:=recGJL."Document No.";
                if recGJL.Insert(true) then;

                recGJL.Validate(recGJL."Posting Date", ApplyingCustLedgEntry."Posting Date");
                recGJL.Validate("Document Type", recGJL."Document Type"::"Credit Memo");
                recGJL.Validate(recGJL."Account Type", recGJL."Account Type"::Customer);
                recGJL.Validate(recGJL."Account No.", AccNo);
                recGJL.Validate(recGJL.Amount, -Abs(decAmount));
                recGJL.Validate(recGJL."Bal. Account Type", recGJL."Account Type"::"G/L Account");
                recGJL.Validate(recGJL."Bal. Account No.", recCustPostGroup."Receivables Account");
                recGJL.Validate(recGJL."Ref. Document No.", Format(ApplyingCustLedgEntry."Entry No."));
                recGJL."Posting No. Series" := recGJB."Posting No. Series";
                if ApplyingCustLedgEntry."External Document No." <> '' then
                    recGJL.Validate(recGJL."External Document No.", ApplyingCustLedgEntry."External Document No.")
                else
                    recGJL.Validate(recGJL."External Document No.", ApplyingCustLedgEntry."Document No.");
                recGJL.Validate("Future/Paid Invoice", true);
                recGJL.Validate(recGJL."Applies-to ID", recGJL."Document No.");
                //recGJL.VALIDATE("Applies-to Doc. Type",recGJL."Applies-to Doc. Type"::Invoice);
                //recGJL.VALIDATE("Applies-to Doc. No.",cdDocNo);
                cdAppcmNo := recGJL."Document No.";
                recGJL.Modify(true);

                //Invoice Creation
                recGJL.Reset;
                recGJL.SetRange(recGJL."Journal Template Name", 'GENERAL');
                recGJL.SetRange(recGJL."Journal Batch Name", 'PFI');
                if recGJL.FindLast then begin
                    LineNo := recGJL."Line No.";
                    DocNo := IncStr(recGJL."Document No.");
                end else begin
                    LineNo := 0;
                end;
                //recGLSetup.GET;

                recGJB.Get('GENERAL', 'PFI');
                Clear(cuNoSeries);
                DocNo := cuNoSeries.GetNextNo(recGJB."No. Series", Today, true);
                //recGJL.LOCKTABLE;
                recGJL.Init;
                recGJL."Journal Template Name" := 'GENERAL';
                recGJL."Journal Batch Name" := 'PFI';
                recGJL."Line No." := LineNo + 10000;

                recGJL."Source Code" := 'GENJNL';
                //IF recGJL."Document No."='' THEN
                recGJL."Document No." := DocNo;
                if recGJL.Insert(true) then;

                recGJL.Validate(recGJL."Posting Date", ApplyingCustLedgEntry."Posting Date");
                recGJL.Validate("Document Type", recGJL."Document Type"::Invoice);
                recGJL.Validate(recGJL."Account Type", recGJL."Account Type"::Customer);
                recGJL.Validate(recGJL."Account No.", AccNo);
                recGJL.Validate(recGJL.Amount, Abs(decAmount));
                recGJL.Validate(recGJL."Bal. Account Type", recGJL."Account Type"::"G/L Account");
                recGJL.Validate(recGJL."Bal. Account No.", recCustPostGroup."Receivables Account");
                //recGJL.VALIDATE(recGJL."External Document No.",recGenJourLine."External Document No.");
                recGJL."Posting No. Series" := recGJB."Posting No. Series";
                recGJL.Validate(recGJL."Ref. Document No.", Format(ApplyingCustLedgEntry."Entry No."));
                if ApplyingCustLedgEntry."External Document No." <> '' then
                    recGJL.Validate(recGJL."External Document No.", ApplyingCustLedgEntry."External Document No.")
                else
                    recGJL.Validate(recGJL."External Document No.", ApplyingCustLedgEntry."Document No.");

                recGJL.Validate(recGJL."Applies-to ID", recGJL."Document No.");
                recGJL.Validate("Future/Paid Invoice", true);
                recGJL.Modify(false);
                Commit;
            end;
        end;
    end;


    procedure PaidFutureInvoice1()
    begin
        recCust.Get(ApplyingCustLedgEntry."Customer No.");
        recPF1.Reset;
        recPF1.SetRange(recPF1."Document No.", ApplyingCustLedgEntry."Document No.");
        recPF1.SetRange(recPF1."Customer No.", ApplyingCustLedgEntry."Customer No.");
        recPF1.SetRange(recPF1."Entry No.", ApplyingCustLedgEntry."Entry No.");
        recPF1.SetFilter(Amount, '<>0');
        if recPF1.Find('-') then begin
            if recPF1."Invoice No." <> '' then begin
                cdRefDocNo := ApplyingCustLedgEntry."Document No.";
                recGJL.Reset;
                recGJL.SetRange(recGJL."Journal Template Name", 'GENERAL');
                recGJL.SetRange(recGJL."Journal Batch Name", 'PFI');
                //recGJL.SETRANGE("Document Type",recGJL."Document Type"::"Credit Memo");
                decAmtToApply := 0;
                decAmount := 0;
                recPF.Reset;
                recPF.SetRange(recPF."Document No.", ApplyingCustLedgEntry."Document No.");
                recPF.SetRange(recPF."Customer No.", recCust."No.");
                recPF.SetRange(recPF."Entry No.", ApplyingCustLedgEntry."Entry No.");
                if recPF.Find('-') then
                    repeat
                        decAmount := decAmount + recPF.Amount
until recPF.Next = 0;
                for i := 1 to 50 do begin
                    cdAppDocNo[i] := '';
                    cdAppDocAmt[i] := 0;
                    cdRemAmt[i] := 0;
                end;
                decAmnt := 0;
                decAmnt := Abs(ApplyingAmount) - Abs(AppliedAmount + (-PmtDiscAmount) + ApplyingAmount + ApplnRounding);
                i := 0;
                Bool1 := true;
                cdDocNo := '';
                recCustLedEntry.Reset;
                recCustLedEntry.SetCurrentKey("Entry No.");
                recCustLedEntry.Ascending(false);
                recCustLedEntry.SetFilter("Document No.", '<>%1', ApplyingCustLedgEntry."Document No.");
                recCustLedEntry.SetRange("Applies-to ID", UserId);
                //recCustLedEntry.SETRANGE("Future/Paid to Apply",True);
                if recCustLedEntry.Find('-') then begin
                    repeat
                        i += 1;

                        decAmtToApply := decAmtToApply + recCustLedEntry."Amount to Apply";
                        //           IF recCustLedEntry."Future/Paid to Apply" THEN BEGIN
                        if decAmnt >= recCustLedEntry."Amount to Apply" then begin
                            recCustLedEntry.CalcFields("Remaining Amount");
                            cdAppDocNo[i] := recCustLedEntry."Document No.";
                            cdAppDocAmt[i] := recCustLedEntry."Amount to Apply";
                            decAmnt -= recCustLedEntry."Amount to Apply";
                            cdRemAmt[i] := recCustLedEntry."Remaining Amount" - recCustLedEntry."Amount to Apply";
                        end else
                            if (decAmnt < recCustLedEntry."Amount to Apply") and Bool1 then begin
                                recCustLedEntry.CalcFields("Remaining Amount");
                                cdAppDocNo[i] := recCustLedEntry."Document No.";
                                cdAppDocAmt[i] := recCustLedEntry."Amount to Apply";
                                decAmnt -= recCustLedEntry."Amount to Apply";
                                cdRemAmt[i] := recCustLedEntry."Remaining Amount" - recCustLedEntry."Amount to Apply";
                                Bool1 := false;
                            end;
                    until (recCustLedEntry.Next = 0);
                end;
                if Abs(decAmtToApply) <> Abs(decAmount) + Abs(ApplyingCustLedgEntry."Remaining Amount") then
                    Error('Amount Not Matched');
            end;
        end;
    end;

}
