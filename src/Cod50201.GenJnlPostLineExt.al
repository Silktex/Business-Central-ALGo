codeunit 50201 "Gen. Jnl.-Post Line_Ext"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCustLedgEntryInsert', '', false, false)]
    local procedure OnBeforeCustLedgEntryInsert(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register")
    begin
        CustLedgerEntry."Sales Invoice Ref." := GenJournalLine."Sales Invoice Ref.";//SPD
        CustLedgerEntry."Future/Paid Invoice" := GenJournalLine."Future/Paid Invoice";//SPD_AG
        CustLedgerEntry."Ref. Document No." := GenJournalLine."Ref. Document No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', false, false)]
    local procedure OnAfterInitGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        GLEntry."Sales Invoice Ref." := GenJournalLine."Sales Invoice Ref."; //SPD
    end;
}
