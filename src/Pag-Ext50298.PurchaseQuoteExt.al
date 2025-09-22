pageextension 50298 PurchaseQuote_Ext extends "Purchase Quote"
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
                    ReportHelper: Codeunit SmtpMail_Ext;
                    Name: Text[50];
                    FileName: Text[250];
                    ToFile: Text[250];
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    Name := StrSubstNo('%1.pdf', Rec."No.");
                    ToFile := Name;
                    //FileName := TemporaryPath + ToFile;
                    //REPORT.SaveAsPdf(50010, FileName, Rec);
                    //ToFile := ReportHelper.DownloadToClientFileName(FileName, ToFile);
                    //CUMail.NewMessage('','','Order','',ToFile,TRUE);
                    CUMail.PurchQuoteOutlook(Rec, ToFile);
                    //FILE.Erase(FileName);
                end;
            }
        }
    }
}
