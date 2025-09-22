pageextension 50274 "Purchase Return Order_Ext" extends "Purchase Return Order"
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
                    CurrPage.SetSelectionFilter(Rec);
                    CUMail.PurchReturnOrderOutlook(Rec, '');
                end;
            }
        }
    }
}
