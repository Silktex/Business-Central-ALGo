pageextension 50002 "SLK Sales Credit Memos" extends "Sales Credit Memos"
{
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Document Type","No.");
        Rec.Ascending(false);
        if Rec.FindFirst() then;
    end;
}
