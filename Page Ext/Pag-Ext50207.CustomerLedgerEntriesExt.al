pageextension 50207 "Customer Ledger Entries_Ext" extends "Customer Ledger Entries"
{
    layout
    {
        moveafter("Document No."; "External Document No.")

        modify("External Document No.")
        {
            Visible = true;

        }
        addafter("Direct Debit Mandate ID")
        {
            field("Ref. Document No."; Rec."Ref. Document No.")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field(Skip; Rec.Skip)
            {
                ApplicationArea = all;
            }

        }
    }
    actions
    {
        modify(UnapplyEntries)
        {
            Visible = false;
        }
        addafter(UnapplyEntries)
        {
            action(UnapplyEntriesNew)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Unapply Entries';
                Ellipsis = true;
                Image = UnApply;
                Promoted = true;
                PromotedCategory = Process;
                Scope = Repeater;
                ToolTip = 'Unselect one or more ledger entries that you want to unapply this record.';

                trigger OnAction()
                var
                    CustEntryApplyPostedEntries: Codeunit CustEntryApplyPostedEntriesExt;
                begin
                    CustEntryApplyPostedEntries.UnApplyCustLedgEntry(Rec."Entry No.");
                end;
            }
        }
        addafter("Show Document")
        {
            action("Credit Cards Transaction Lo&g Entries")
            {
                Caption = 'Credit Cards Transaction Lo&g Entries';
                Image = CreditCardLog;
                RunObject = Page "DO Payment Trans. Log Entries";
                RunPageLink = "Document Type" = CONST(Payment),
                              "Document No." = FIELD("Document No."),
                              "Customer No." = FIELD("Customer No.");
                ApplicationArea = all;
            }
            action("PFI Entries")
            {
                Caption = 'PFI Entries';
                RunObject = Page "Customer Ledger Entries PFI";
                ApplicationArea = all;
            }
            action(SendMISReport)
            {
                Caption = 'Send MIS Report';
                //RunObject = codeunit Sedular;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    CUSmtpMail: Codeunit SmtpMail_Ext;
                begin
                    CUSmtpMail.SendMISAsPDF
                end;
            }
        }
    }
}
