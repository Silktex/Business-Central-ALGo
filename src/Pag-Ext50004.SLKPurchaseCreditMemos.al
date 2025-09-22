pageextension 50004 "SLK Purchase Credit Memos" extends "Purchase Credit Memos"
{
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Document Type", "No.");
        Rec.Ascending(false);
        if Rec.FindFirst() then;
    end;
}
