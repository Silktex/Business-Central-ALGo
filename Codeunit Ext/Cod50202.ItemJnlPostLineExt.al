codeunit 50202 "Item Jnl.-Post Line_Ext"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnInsertTransferEntryOnTransferValues', '', false, false)]
    local procedure OnInsertTransferEntryOnTransferValues(var NewItemLedgerEntry: Record "Item Ledger Entry"; OldItemLedgerEntry: Record "Item Ledger Entry"; ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; var TempItemEntryRelation: Record "Item Entry Relation")
    begin
        //SPDSAUDY001 BEGIN
        NewItemLedgerEntry."Dylot No." := ItemJournalLine."Dylot No.";
        NewItemLedgerEntry."Quality Grade" := ItemJournalLine."Quality Grade";

        //SPDSAUDY001 BEGIN
        NewItemLedgerEntry."Dylot No." := ItemJournalLine."Dylot No.";
        NewItemLedgerEntry."Quality Grade" := ItemJournalLine."Quality Grade";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    begin
        NewItemLedgEntry."ETA Date" := ItemJournalLine."ETA Date";//Ashwini
        //SPDSAUDY001 BEGIN
        NewItemLedgEntry."Dylot No." := ItemJournalLine."Dylot No.";
        NewItemLedgEntry."Quality Grade" := ItemJournalLine."Quality Grade";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertSetupTempSplitItemJnlLine', '', false, false)]
    local procedure OnBeforeInsertSetupTempSplitItemJnlLine(var TempTrackingSpecification: Record "Tracking Specification" temporary; var TempItemJournalLine: Record "Item Journal Line" temporary; var PostItemJnlLine: Boolean; var ItemJournalLine2: Record "Item Journal Line")
    begin
        //SPDSAUDY001 BEGIN
        TempItemJournalLine."Dylot No." := TempTrackingSpecification."Dylot No.";
        TempItemJournalLine."Quality Grade" := TempTrackingSpecification."Quality Grade";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnInsertItemLedgEntryOnBeforeSNQtyCheck', '', false, false)]
    local procedure OnInsertItemLedgEntryOnBeforeSNQtyCheck(ItemJournalLine: Record "Item Journal Line"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;
}
