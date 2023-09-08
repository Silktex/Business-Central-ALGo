page 50249 UnapplyCustomerEntries_Ext
{
    Caption = 'Unapply Customer Entries';
    DataCaptionExpression = Caption;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "Detailed Cust. Ledg. Entry";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(DocuNo; DocNo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Document No.';
                    ToolTip = 'Specifies the document number of the entry to be unapplied.';
                }
                field(PostDate; PostingDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the posting date of the entry to be unapplied.';
                }
            }
            repeater(Control1)
            {
                Editable = false;
                ShowCaption = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the posting date of the detailed customer ledger entry.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the entry type of the detailed customer ledger entry.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the document type of the detailed customer ledger entry.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the document number of the transaction that created the entry.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the customer account number to which the entry is posted.';
                }
                field("Initial Document Type"; Rec."Initial Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the document type that the initial customer ledger entry was created with.';
                }
                field(DocumentNo; GetDocumentNo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Initial Document No.';
                    DrillDown = false;
                    ToolTip = 'Specifies the number of the document for which the entry is unapplied.';
                }
                field("Initial Entry Global Dim. 1"; Rec."Initial Entry Global Dim. 1")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the Global Dimension 1 code of the initial customer ledger entry.';
                    Visible = false;
                }
                field("Initial Entry Global Dim. 2"; Rec."Initial Entry Global Dim. 2")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the Global Dimension 2 code of the initial customer ledger entry.';
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for the currency if the amount is in a foreign currency.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount of the detailed customer ledger entry.';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount of the entry in LCY.';
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total of the ledger entries that represent debits.';
                    Visible = false;
                }
                field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total of the ledger entries that represent debits, expressed in LCY.';
                    Visible = false;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total of the ledger entries that represent credits.';
                    Visible = false;
                }
                field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total of the ledger entries that represent credits, expressed in LCY.';
                    Visible = false;
                }
                field("Initial Entry Due Date"; Rec."Initial Entry Due Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date on which the initial entry is due for payment.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic, Suite;
                    LookupPageID = "User Lookup";
                    ToolTip = 'Specifies the ID of the user who posted the entry, to be used, for example, in the change log.';
                    Visible = false;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the source code that specifies where the entry was created.';
                    Visible = false;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
                    Visible = false;
                }
                field("Cust. Ledger Entry No."; Rec."Cust. Ledger Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the entry number of the customer ledger entry that the detailed customer ledger entry line was created for.';
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Unapply)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Unapply';
                Image = UnApply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Unselect one or more ledger entries that you want to unapply this record.';

                trigger OnAction()
                var
                    CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
                    ConfirmManagement: Codeunit "Confirm Management";
                    RecFutureInv: Record "Payment Future Old Inv";
                    RecCLE: Record "Cust. Ledger Entry";
                    ApplicationEntryNo: Integer;
                    DtldCustLedgEntry3: Record "Detailed Cust. Ledg. Entry";
                    DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                    DCVLedgerEntryType: Enum "Detailed CV Ledger Entry Type";
                    ApplyUnapplyParameters: Record "Apply Unapply Parameters";
                begin
                    if Rec.IsEmpty() then
                        Error(Text010);
                    if not ConfirmManagement.GetResponseOrDefault(Text011, true) then
                        exit;
                    RecCLE.Reset;
                    RecCLE.SetRange("Document Type", RecCLE."Document Type"::Invoice);
                    RecCLE.SetRange("Ref. Document No.", Format(CustLedgEntryNo));
                    RecCLE.SetRange("Future/Paid Invoice", true);
                    if RecCLE.FindSet then
                        repeat
                            CustEntryApplyPostedEntries.CheckReversal(RecCLE."Entry No.");
                            //ApplicationEntryNo := CustEntryApplyPostedEntries.FindLastApplTransactionEntry(RecCLE."Entry No.");
                            DtldCustLedgEntry.Reset;
                            DtldCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type");
                            DtldCustLedgEntry.SetRange("Cust. Ledger Entry No.", RecCLE."Entry No.");
                            DtldCustLedgEntry.SetRange("Entry Type", DCVLedgerEntryType::Application);
                            DtldCustLedgEntry.SetRange(Unapplied, false);
                            ApplicationEntryNo := 0;
                            if DtldCustLedgEntry.Find('-') then
                                repeat
                                    if DtldCustLedgEntry."Entry No." > ApplicationEntryNo then
                                        ApplicationEntryNo := DtldCustLedgEntry."Entry No.";
                                until DtldCustLedgEntry.Next = 0;
                            if ApplicationEntryNo <> 0 then begin
                                //ERROR('No application entry found');
                                DtldCustLedgEntry3.Get(ApplicationEntryNo);
                                ApplyUnapplyParameters."Document No." := DtldCustLedgEntry3."Document No.";
                                ApplyUnapplyParameters."Posting Date" := DtldCustLedgEntry3."Posting Date";
                                CustEntryApplyPostedEntries.PostUnApplyCustomer(DtldCustLedgEntry3, ApplyUnapplyParameters);
                                //CustEntryApplyPostedEntries.PostUnApplyCustomer(DtldCustLedgEntry3, DtldCustLedgEntry3."Document No.", DtldCustLedgEntry3."Posting Date");
                            end;
                        until RecCLE.Next = 0;
                    //    RecFutureInv.RESET;
                    //    RecFutureInv.SETRANGE(RecFutureInv."Document No.",DocNo);
                    //    IF RecFutureInv.FINDSET THEN
                    //      REPEAT
                    RecCLE.Reset;
                    RecCLE.SetRange("Ref. Document No.", Format(CustLedgEntryNo));
                    RecCLE.SetRange(RecCLE."Document Type", RecCLE."Document Type"::Invoice);
                    if RecCLE.FindSet then
                        RecCLE.ModifyAll(RecCLE."Ref. Document No.", '');
                    //      UNTIL RecFutureInv.NEXT=0;
                    //  END;
                    //END;

                    ApplyUnapplyParameters."Document No." := DocNo;
                    ApplyUnapplyParameters."Posting Date" := PostingDate;
                    CustEntryApplyPostedEntries.PostUnApplyCustomer(DtldCustLedgEntry3, ApplyUnapplyParameters);
                    //CustEntryApplyPostedEntries.PostUnApplyCustomer(DtldCustLedgEntry2, DocNo, PostingDate);

                    //IF CONFIRM('Unaplly entry',FALSE) THEN BEGIN
                    //  RecFutureInv.RESET;
                    //  RecFutureInv.SETRANGE(RecFutureInv."Document No.",DocNo);
                    //  IF RecFutureInv.FINDFIRST THEN BEGIN
                    RecCLE.Reset;
                    RecCLE.SetRange("Document Type", RecCLE."Document Type"::"Credit Memo");
                    RecCLE.SetRange("Ref. Document No.", Format(CustLedgEntryNo));
                    RecCLE.SetRange("Future/Paid Invoice", true);
                    if RecCLE.FindSet then
                        repeat
                            CustEntryApplyPostedEntries.CheckReversal(RecCLE."Entry No.");
                            //ApplicationEntryNo := CustEntryApplyPostedEntries.FindLastApplTransactionEntry(RecCLE."Entry No.");
                            DtldCustLedgEntry.Reset;
                            DtldCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type");
                            DtldCustLedgEntry.SetRange("Cust. Ledger Entry No.", RecCLE."Entry No.");
                            DtldCustLedgEntry.SetRange("Entry Type", DCVLedgerEntryType::Application);
                            DtldCustLedgEntry.SetRange(Unapplied, false);
                            ApplicationEntryNo := 0;
                            if DtldCustLedgEntry.Find('-') then
                                repeat
                                    if DtldCustLedgEntry."Entry No." > ApplicationEntryNo then
                                        ApplicationEntryNo := DtldCustLedgEntry."Entry No.";
                                until DtldCustLedgEntry.Next = 0;
                            if ApplicationEntryNo <> 0 then begin
                                //ERROR('No application entry found');
                                DtldCustLedgEntry3.Get(ApplicationEntryNo);
                                ApplyUnapplyParameters."Document No." := DtldCustLedgEntry3."Document No.";
                                ApplyUnapplyParameters."Posting Date" := DtldCustLedgEntry3."Posting Date";
                                CustEntryApplyPostedEntries.PostUnApplyCustomer(DtldCustLedgEntry3, ApplyUnapplyParameters);
                                //CustEntryApplyPostedEntries.PostUnApplyCustomer(DtldCustLedgEntry3, DtldCustLedgEntry3."Document No.", DtldCustLedgEntry3."Posting Date");
                            end;
                        until RecCLE.Next = 0;
                    //    RecFutureInv.RESET;
                    //    RecFutureInv.SETRANGE(RecFutureInv."Document No.",DocNo);
                    //    IF RecFutureInv.FINDSET THEN
                    //      REPEAT
                    RecCLE.Reset;
                    RecCLE.SetRange("Ref. Document No.", Format(CustLedgEntryNo));
                    RecCLE.SetRange(RecCLE."Document Type", RecCLE."Document Type"::"Credit Memo");
                    if RecCLE.FindSet then
                        RecCLE.ModifyAll(RecCLE."Ref. Document No.", '');
                    //      UNTIL RecFutureInv.NEXT=0;
                    //  END;
                    //END;

                    PostingDate := 0D;
                    DocNo := '';
                    Rec.DeleteAll();
                    Message(Text009);

                    CurrPage.Close;
                end;
            }
            action(Preview)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Preview Unapply';
                Image = ViewPostedOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Preview how unapplying one or more ledger entries will look like.';

                trigger OnAction()
                var
                    CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
                    ApplyUnapplyParameters: Record "Apply Unapply Parameters";
                begin
                    if Rec.IsEmpty() then
                        Error(Text010);

                    ApplyUnapplyParameters."Document No." := DocNo;
                    ApplyUnapplyParameters."Posting Date" := PostingDate;
                    CustEntryApplyPostedEntries.PreviewUnapply(DtldCustLedgEntry2, ApplyUnapplyParameters);
                    //CustEntryApplyPostedEntries.PreviewUnapply(DtldCustLedgEntry2, DocNo, PostingDate);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        InsertEntries;
    end;

    var
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        Cust: Record Customer;
        Unappcustle: page "Unapply Customer Entries";
        DocNo: Code[20];
        PostingDate: Date;
        CustLedgEntryNo: Integer;
        Text009: Label 'The entries were successfully unapplied.';
        Text010: Label 'There is nothing to unapply.';
        Text011: Label 'To unapply these entries, correcting entries will be posted.\Do you want to unapply the entries?';

    procedure SetDtldCustLedgEntry(EntryNo: Integer)
    begin
        DtldCustLedgEntry2.Get(EntryNo);
        CustLedgEntryNo := DtldCustLedgEntry2."Cust. Ledger Entry No.";
        PostingDate := DtldCustLedgEntry2."Posting Date";
        DocNo := DtldCustLedgEntry2."Document No.";
        Cust.Get(DtldCustLedgEntry2."Customer No.");
    end;

    local procedure InsertEntries()
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        if DtldCustLedgEntry2."Transaction No." = 0 then begin
            DtldCustLedgEntry.SetCurrentKey("Application No.", "Customer No.", "Entry Type");
            DtldCustLedgEntry.SetRange("Application No.", DtldCustLedgEntry2."Application No.");
        end else begin
            DtldCustLedgEntry.SetCurrentKey("Transaction No.", "Customer No.", "Entry Type");
            DtldCustLedgEntry.SetRange("Transaction No.", DtldCustLedgEntry2."Transaction No.");
        end;
        DtldCustLedgEntry.SetRange("Customer No.", DtldCustLedgEntry2."Customer No.");
        OnInsertEntriesOnAfterSetFilters(DtldCustLedgEntry, DtldCustLedgEntry2);
        Rec.DeleteAll();
        if DtldCustLedgEntry.FindSet then
            repeat
                if (DtldCustLedgEntry."Entry Type" <> DtldCustLedgEntry."Entry Type"::"Initial Entry") and
                   not DtldCustLedgEntry.Unapplied
                then begin
                    Rec := DtldCustLedgEntry;
                    OnBeforeRecInsert(Rec, DtldCustLedgEntry, DtldCustLedgEntry2);
                    Rec.Insert;
                end;
            until DtldCustLedgEntry.Next() = 0;
    end;

    local procedure GetDocumentNo(): Code[20]
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        if CustLedgEntry.Get(Rec."Cust. Ledger Entry No.") then;
        exit(CustLedgEntry."Document No.");
    end;

    procedure Caption(): Text
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        exit(StrSubstNo(
            '%1 %2 %3 %4',
            Cust."No.",
            Cust.Name,
            CustLedgEntry.FieldCaption("Entry No."),
            CustLedgEntryNo));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRecInsert(var RecDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertEntriesOnAfterSetFilters(var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; DetailedCustLedgEntry2: Record "Detailed Cust. Ledg. Entry")
    begin
    end;
}

