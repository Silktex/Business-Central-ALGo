pageextension 50294 DetailedCustLedgEntries_Ext extends "Detailed Cust. Ledg. Entries"
{
    actions
    {
        modify("Unapply Entries")
        {
            Visible = false;
        }
        addafter("Unapply Entries")
        {
            action("Unapply Entries New")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Unapply Entries';
                Ellipsis = true;
                Image = UnApply;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Unselect one or more ledger entries that you want to unapply this record.';

                trigger OnAction()
                var
                    CustEntryApplyPostedEntries: Codeunit CustEntryApplyPostedEntriesExt;
                begin
                    CustEntryApplyPostedEntries.UnApplyDtldCustLedgEntry(Rec);
                end;
            }
        }
    }
}
