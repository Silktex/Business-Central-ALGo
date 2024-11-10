pageextension 50005 "SLK Purchase Quotes" extends "Purchase Quotes"
{
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Document Type", "No.");
        Rec.Ascending(false);
        if Rec.FindFirst() then;
    end;
}
