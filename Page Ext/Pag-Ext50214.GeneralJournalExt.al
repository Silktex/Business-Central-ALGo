pageextension 50214 "General Journal_Ext" extends "General Journal"
{
    //Editable = true;

    layout
    {
        addafter("Document Date")
        {
            field("Applicable for FO Invoice"; Rec."Applicable for FO Invoice")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter(SaveAsStandardJournal)
        {
            action(UpdateFutureOldInvoice)
            {
                Caption = '&Paid/Future Invoice';
                ApplicationArea = all;

                trigger OnAction()
                begin
                    if Rec."Applicable for FO Invoice" then begin
                        recPF.Reset;
                        recPF.FilterGroup(2);
                        recPF.SetRange(recPF."Journal Template Name", Rec."Journal Template Name");
                        recPF.SetRange(recPF."Journal Batch Name", Rec."Journal Batch Name");
                        recPF.SetRange(recPF."Document Line No.", Rec."Line No.");
                        recPF.SetRange(recPF."Document No.", Rec."Document No.");
                        if Rec."Account Type" = Rec."Account Type"::Customer then begin
                            if Rec."Account No." <> '' then
                                recPF.SetRange(recPF."Customer No.", Rec."Account No.")
                            else
                                Error('Select the Account No.');
                        end else
                            if Rec."Bal. Account Type" = Rec."Bal. Account Type"::Customer then begin
                                if Rec."Bal. Account No." <> '' then
                                    recPF.SetRange(recPF."Customer No.", Rec."Bal. Account No.")
                                else
                                    Error('Select the Balance Account No.');
                            end else
                                Error('Account Type Or Balance Account Type must be customer on Document No %1 and Document Line No %2', Rec."Document No.", Rec."Line No.");

                        recPF.FilterGroup(0);
                        pgPF.SetTableView(recPF);
                        pgPF.Run;
                    end else
                        Error('Future Old Invoice must be true on customer card');
                end;
            }
        }
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                if (Rec."Account Type" = Rec."Account Type"::Customer) or (Rec."Bal. Account Type" = Rec."Bal. Account Type"::Customer) then begin
                    CreateFutureInvoice(Rec);//SPD
                                             // CreatePastInvoice(Rec);
                                             //CurrPage.UPDATE;//SPD
                end;
            end;

            trigger OnAfterAction()
            begin
                recGenJourLine.Reset;
                recGenJourLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                recGenJourLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                if not recGenJourLine.Find('-') then
                    CheckForJournal;
            end;
        }
    }
    trigger OnAfterGetRecord()
    begin
        if Rec."For Future Invoice" = true then begin
            EnableoldInvoice := false;
            EnableFutureInvoice := true;

        end else begin
            EnableFutureInvoice := false;
            EnableoldInvoice := true;

        end;
        if Rec."For Old Invoice" = true then begin
            EnableFutureInvoice1 := false;
            EnableOldInvoice1 := true;

        end else begin
            EnableFutureInvoice := true;
            EnableOldInvoice1 := false;

        end;
        if Rec."For Future Invoice" or Rec."For Old Invoice" then
            EnableApplicationDocument := true
        else
            EnableApplicationDocument := false;

    end;

    var
        CustEntrySetApplID: Codeunit "Cust. Entry-SetAppl.ID";
        CustLedgEntry: Record "Cust. Ledger Entry";
        ApplyingCustLedgEntry: Record "Cust. Ledger Entry";
        EnableFutureInvoice: Boolean;
        EnableoldInvoice: Boolean;
        EnableFutureInvoice1: Boolean;
        EnableApplicationDocument: Boolean;
        EnableOldInvoice1: Boolean;
        recGenJnlBatch: Record "Gen. Journal Batch";
        recPF: Record "Payment Future Old Inv";
        decAmount: Decimal;
        recCustLedEntry: Record "Cust. Ledger Entry";
        cdDocNo: Code[20];
        pgPF: Page "Paid/Future Invoice";
        recPF1: Record "Payment Future Old Inv";
        decAmtToApply: Decimal;
        recGLSetup: Record "General Ledger Setup";
        cuNoSeries: Codeunit NoSeriesManagement;
        cdAppDocNo: array[50] of Code[20];
        i: Integer;
        cdAppcmNo: Code[20];
        recGJB: Record "Gen. Journal Batch";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        recGenJourLine: Record "Gen. Journal Line";
        cdRefDocNo: Code[20];
        cdRefDocNo2: Code[20];
        cdRefDocNo1: Code[20];
        recCLE: Record "Cust. Ledger Entry";
        recCLE1: Record "Cust. Ledger Entry";

    procedure CreateFutureInvoice(var recGenJourLine: Record "Gen. Journal Line")
    var
        recGJL: Record "Gen. Journal Line";
        DocNo: Code[20];
        LineNo: Integer;
        AccNo: Code[20];
        recCust: Record Customer;
        recCustPostGroup: Record "Customer Posting Group";
    begin
        //recGenJourLine:=Rec;
        // with recGenJourLine do begin
        repeat
            //recPF.RESET;
            recPF1.Reset;
            recPF1.SetRange(recPF1."Journal Template Name", recGenJourLine."Journal Template Name");
            recPF1.SetRange(recPF1."Journal Batch Name", recGenJourLine."Journal Batch Name");
            recPF1.SetRange(recPF1."Document No.", recGenJourLine."Document No.");
            recPF1.SetRange(recPF1."Document Line No.", recGenJourLine."Line No.");
            recPF1.SetFilter(Amount, '<>0');
            if recPF1.Find('-') then begin
                if recPF1."Invoice No." <> '' then begin
                    //IF (recGenJourLine."For Future Invoice" =TRUE) THEN BEGIN
                    //TESTFIELD("External Document No.");
                    //TESTFIELD("Future Invoice No.");
                    //TESTFIELD("Future Invoice Amount");
                    //TESTFIELD("Application Document No.");
                    cdRefDocNo := recGenJourLine."Document No.";
                    recGJL.Reset;
                    recGJL.SetRange(recGJL."Journal Template Name", 'GENERAL');
                    recGJL.SetRange(recGJL."Journal Batch Name", 'PFI');
                    //recGJL.SETRANGE("Document Type",recGJL."Document Type"::"Credit Memo");
                    if recGJL.FindSet then begin
                        recGJL.DeleteAll;
                    end;

                    decAmtToApply := 0;
                    decAmount := 0;
                    recPF.Reset;
                    recPF.SetRange(recPF."Journal Template Name", recGenJourLine."Journal Template Name");
                    recPF.SetRange(recPF."Journal Batch Name", recGenJourLine."Journal Batch Name");
                    recPF.SetRange(recPF."Document No.", recGenJourLine."Document No.");
                    recPF.SetRange(recPF."Document Line No.", recGenJourLine."Line No.");
                    if recPF.Find('-') then
                        repeat
                            decAmount := decAmount + recPF.Amount
 until recPF.Next = 0;
                    recPF.Reset;
                    recPF.SetRange(recPF."Journal Template Name", recGenJourLine."Journal Template Name");
                    recPF.SetRange(recPF."Journal Batch Name", recGenJourLine."Journal Batch Name");
                    recPF.SetRange(recPF."Document No.", recGenJourLine."Document No.");
                    recPF.SetRange(recPF."Document Line No.", recGenJourLine."Line No.");
                    if recPF.Find('-') then
                        repeat
                            //decAmount:=decAmount+recPF.Amount
                            recCustLedEntry.Reset;
                            recCustLedEntry.SetRange("Document No.", recPF."Invoice No.");
                            if recCustLedEntry.Find('-') then begin
                                recCustLedEntry."Ref. Document No." := recGenJourLine."Document No.";
                                recCustLedEntry.Modify;
                            end;

                        until recPF.Next = 0;
                    for i := 1 to 50 do begin
                        cdAppDocNo[i] := '';
                    end;
                    i := 0;
                    cdDocNo := '';
                    recCustLedEntry.Reset;
                    recCustLedEntry.SetCurrentKey("Entry No.");
                    recCustLedEntry.Ascending(false);
                    recCustLedEntry.SetRange("Applies-to ID", recGenJourLine."Document No.");
                    if recCustLedEntry.Find('-') then begin
                        repeat
                            i += 1;
                            decAmtToApply := decAmtToApply + recCustLedEntry."Amount to Apply";
                            cdAppDocNo[i] := recCustLedEntry."Document No.";

                        until (recCustLedEntry.Next = 0);
                    end;

                    if Abs(decAmtToApply) <> Abs(decAmount) + Abs(recGenJourLine.Amount) then
                        Error('Amount Not Matched');
                    cdDocNo := '';
                    recCustLedEntry.Reset;
                    recCustLedEntry.SetCurrentKey("Entry No.");
                    recCustLedEntry.Ascending(false);
                    recCustLedEntry.SetRange("Applies-to ID", recGenJourLine."Document No.");
                    if recCustLedEntry.Find('-') then begin
                        repeat
                            i += 1;
                            decAmtToApply := decAmtToApply + recCustLedEntry."Amount to Apply";
                            cdAppDocNo[i] := recCustLedEntry."Document No.";
                            if recCustLedEntry."Amount to Apply" > decAmount then begin
                                //recCustLedEntry."Amount to Apply":=recCustLedEntry."Amount to Apply"-decAmount;
                                //recCustLedEntry.MODIFY;
                                cdDocNo := recCustLedEntry."Document No.";
                                recCustLedEntry."Amount to Apply" := recCustLedEntry."Amount to Apply" - decAmount;
                                recCustLedEntry.Modify;
                            end;

                        until (recCustLedEntry.Next = 0) or (cdDocNo <> '');
                    end;
                    //IF ABS(decAmtToApply)<>ABS(decAmount)+ABS(Amount) THEN
                    // ERROR('Amount Not Matched');
                    DocNo := '';
                    //AccNo:=recGen
                    if recGenJourLine."Account Type" = recGenJourLine."Account Type"::Customer then
                        AccNo := recGenJourLine."Account No."
                    else
                        if recGenJourLine."Bal. Account Type" = recGenJourLine."Bal. Account Type"::Customer then
                            AccNo := recGenJourLine."Bal. Account No."
                        else
                            AccNo := '';
                    if AccNo = '' then
                        Error('Account Type or Bal Account Type must be customer for future invoice');
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
                    //recGLSetup.GET;


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

                    recGJL.Validate(recGJL."Posting Date", recGenJourLine."Posting Date");
                    recGJL.Validate("Document Type", recGJL."Document Type"::"Credit Memo");
                    recGJL.Validate(recGJL."Account Type", recGJL."Account Type"::Customer);
                    recGJL.Validate(recGJL."Account No.", AccNo);
                    recGJL.Validate(recGJL.Amount, -Abs(decAmount));
                    recGJL.Validate(recGJL."Bal. Account Type", recGJL."Account Type"::"G/L Account");
                    recGJL.Validate(recGJL."Bal. Account No.", recCustPostGroup."Receivables Account");
                    recGJL."Posting No. Series" := recGJB."Posting No. Series";
                    if recGenJourLine."External Document No." <> '' then
                        recGJL.Validate(recGJL."External Document No.", recGenJourLine."External Document No.")
                    else
                        recGJL.Validate(recGJL."External Document No.", recGenJourLine."Document No.");
                    recGJL.Validate("Future/Paid Invoice", true);
                    recGJL.Validate(recGJL."Applies-to ID", recGJL."Document No.");
                    //recGJL.VALIDATE("Applies-to Doc. Type",recGJL."Applies-to Doc. Type"::Invoice);
                    //recGJL.VALIDATE("Applies-to Doc. No.",cdDocNo);
                    cdAppcmNo := recGJL."Document No.";
                    recGJL.Modify(true);

                    //END;












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

                    recGJL.Init;
                    recGJL."Journal Template Name" := 'GENERAL';
                    recGJL."Journal Batch Name" := 'PFI';
                    recGJL."Line No." := LineNo + 10000;

                    recGJL."Source Code" := 'GENJNL';
                    //IF recGJL."Document No."='' THEN
                    recGJL."Document No." := DocNo;
                    if recGJL.Insert(true) then;

                    recGJL.Validate(recGJL."Posting Date", recGenJourLine."Posting Date");
                    recGJL.Validate("Document Type", recGJL."Document Type"::Invoice);
                    recGJL.Validate(recGJL."Account Type", recGJL."Account Type"::Customer);
                    recGJL.Validate(recGJL."Account No.", AccNo);
                    recGJL.Validate(recGJL.Amount, Abs(decAmount));
                    recGJL.Validate(recGJL."Bal. Account Type", recGJL."Account Type"::"G/L Account");
                    recGJL.Validate(recGJL."Bal. Account No.", recCustPostGroup."Receivables Account");
                    //recGJL.VALIDATE(recGJL."External Document No.",recGenJourLine."External Document No.");
                    recGJL."Posting No. Series" := recGJB."Posting No. Series";
                    if recGenJourLine."External Document No." <> '' then
                        recGJL.Validate(recGJL."External Document No.", recGenJourLine."External Document No.")
                    else
                        recGJL.Validate(recGJL."External Document No.", recGenJourLine."Document No.");

                    recGJL.Validate(recGJL."Applies-to ID", recGJL."Document No.");
                    recGJL.Validate("Future/Paid Invoice", true);
                    recGJL.Modify(true);
                end;
            end;
        until recGenJourLine.Next = 0;
        //end;
    end;


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
                    SetApplId1(CustLedgEntry, recGJL."Document No.", recGJL, CustLedgEntry."Remaining Amount");
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
            recPF.SetRange(recPF."Journal Template Name", Rec."Journal Template Name");
            recPF.SetRange(recPF."Journal Batch Name", Rec."Journal Batch Name");
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
            cdRefDocNo1 := recGJL."Document No.";
            GenJnlPostLine.RunWithCheck(recGJL);
            //CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",recGJL);
        end;
        recGJL.Reset;
        recGJL.SetRange(recGJL."Journal Template Name", 'GENERAL');
        recGJL.SetRange(recGJL."Journal Batch Name", 'PFI');
        recGJL.SetRange("Document Type", recGJL."Document Type"::Invoice);
        if recGJL.FindSet then begin
            Clear(GenJnlPostLine);
            cdRefDocNo2 := recGJL."Document No.";
            GenJnlPostLine.RunWithCheck(recGJL);
            //CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",recGJL);
        end;
        recCLE.Reset;
        recCLE.SetRange("Document No.", cdRefDocNo2);
        recCLE.SetRange("Document Type", recCLE."Document Type"::Invoice);
        recCLE.SetRange("Customer No.", AccNo);
        if recCLE.Find('-') then begin
            recCLE1.Reset;
            recCLE1.SetRange("Document No.", cdRefDocNo);
            recCLE1.SetRange("Customer No.", AccNo);
            if recCLE1.Find('-') then begin
                recCLE."Ref. Document No." := Format(recCLE1."Entry No.");
                recCLE.Modify;
            end;
        end;
        recCLE.Reset;
        recCLE.SetRange("Document No.", cdRefDocNo1);
        recCLE.SetRange("Document Type", recCLE."Document Type"::"Credit Memo");
        recCLE.SetRange("Customer No.", AccNo);
        if recCLE.Find('-') then begin
            recCLE1.Reset;
            recCLE1.SetRange("Document No.", cdRefDocNo);
            recCLE1.SetRange("Customer No.", AccNo);
            if recCLE1.Find('-') then begin
                recCLE."Ref. Document No." := Format(recCLE1."Entry No.");
                recCLE.Modify;
            end;
        end;
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

}
