pageextension 50264 "Posted Transfer Receipts_Ext" extends "Posted Transfer Receipts"
{
    actions
    {
        addafter("&Navigate")
        {
            action("Back Order Fill Report")
            {
                Caption = 'Back Order Fill Report';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Back Order Transfer Report";
                ApplicationArea = all;

                trigger OnAction()
                var
                    TransRcptHeader: Record "Transfer Receipt Header";
                begin
                    CurrPage.SetSelectionFilter(TransRcptHeader);
                    TransRcptHeader.PrintRecords(true);
                end;
            }
        }
    }
}
