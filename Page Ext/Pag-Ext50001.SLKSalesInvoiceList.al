pageextension 50001 "SLK Sales Invoice List" extends "Sales Invoice List"
{
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Document Type", "No.");
        Rec.Ascending(false);
        if Rec.FindFirst() then;
    end;
}
