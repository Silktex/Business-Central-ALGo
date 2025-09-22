pageextension 50003 "SLK Purchase Invoices" extends "Purchase Invoices"
{
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Document Type", "No.");
        Rec.Ascending(false);
        if Rec.FindFirst() then;
    end;
}
