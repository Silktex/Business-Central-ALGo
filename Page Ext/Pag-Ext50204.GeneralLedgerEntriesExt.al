pageextension 50204 GeneralLedgerEntries_Ext extends "General Ledger Entries"
{
    actions
    {
        addafter("Value Entries")
        {
            action("Print Voucher")
            {
                Caption = 'Print Voucher';
                Ellipsis = true;
                Image = PrintVoucher;
                ApplicationArea = all;

                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                begin
                    GLEntry.SetCurrentKey("Document No.", "Posting Date");
                    GLEntry.SetRange("Document No.", Rec."Document No.");
                    GLEntry.SetRange("Posting Date", Rec."Posting Date");
                    if GLEntry.FindFirst then
                        REPORT.RunModal(REPORT::"Posted Voucher", true, true, GLEntry);
                end;
            }
        }
    }
}
