pageextension 50239 "Posted Purchase Receipts_Ext" extends "Posted Purchase Receipts"
{
    actions
    {
        addafter("&Navigate")
        {
            action(BackOrderFill)
            {
                Caption = 'Back Order Fill';
                Image = "Report";
                Promoted = true;
                ToolTip = 'Back Order Fill';
                ApplicationArea = all;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    PurchRcptLine.Reset;
                    PurchRcptLine.SetRange("Document No.", Rec."No.");
                    if PurchRcptLine.FindFirst then
                        REPORT.RunModal(50025, true, true, PurchRcptLine);
                    Rec.Reset;
                end;
            }
        }
    }
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
}
