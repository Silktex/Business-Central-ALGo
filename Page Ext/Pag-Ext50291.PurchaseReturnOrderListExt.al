pageextension 50291 "Purchase Return Order List_Ext" extends "Purchase Return Order List"
{
    actions
    {
        addafter("Co&mments")
        {
            action(CreateMail)
            {
                Caption = 'Create Mail';
                Ellipsis = true;
                Image = Email;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    CUMail: Codeunit Mail_Ext;
                begin
                    recPurchaseHeader := Rec;
                    CurrPage.SetSelectionFilter(recPurchaseHeader);
                    CUMail.PurchReturnOrderOutlook(recPurchaseHeader, '');

                    Rec.Reset;
                    CurrPage.Update(true);
                end;
            }
        }
        addafter("Cred&it Memos")
        {
            action(ReturnPO)
            {
                Caption = 'Return Order Report';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Open Return PO Report";
                ApplicationArea = all;
            }
        }
    }
    var
        recPurchaseHeader: Record "Purchase Header";
}
