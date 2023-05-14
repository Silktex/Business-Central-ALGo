pageextension 50290 "Purchase Order List_Ext" extends "Purchase Order List"
{
    layout
    {
        // addafter("Buy-from Vendor No.")
        // {
        //     field("Vendor Order No."; Rec."Vendor Order No.")
        //     {
        //         ApplicationArea = all;
        //     }
        // }
        addafter("Currency Code")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = all;
            }
        }
        addafter("Job Queue Status")
        {
            field(MailSentCount; MailCountFN(Rec."No."))
            {
                Caption = 'Mail Sent Count';
                ApplicationArea = all;

                trigger OnDrillDown()
                var
                    MailSentRec: Record "Mail Detail";
                begin
                    MailSentRec.Reset;
                    MailSentRec.SetCurrentKey("Source No.", "Date Time");
                    MailSentRec.SetRange("Source No.", Rec."No.");
                    PAGE.Run(0, MailSentRec);
                end;
            }
            field("LastMailSenton"; LastDateMailSentFN(Rec."No."))
            {
                Caption = 'Last Mail Sent on';
                ApplicationArea = all;
            }
        }
    }
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
                    //ReportHelper: Codeunit "SMTP Mail";
                    Name: Text[50];
                    FileName: Text[250];
                    ToFile: Text[250];
                    lPurchaseHeader: Record "Purchase Header";
                begin
                    lPurchaseHeader := Rec;
                    CurrPage.SetSelectionFilter(lPurchaseHeader);
                    Name := StrSubstNo('%1.pdf', lPurchaseHeader."No.");
                    ToFile := Name;
                    // FileName := TemporaryPath + ToFile;
                    //REPORT.SaveAsPdf(50010, FileName, lPurchaseHeader);
                    //ToFile := ReportHelper.DownloadToClientFileName(FileName, ToFile);
                    //CUMail.NewMessage('','','Order','',ToFile,TRUE);
                    //CUMail.PurchOrderOutlook(lPurchaseHeader, ToFile);
                    //FILE.Erase(FileName);
                end;
            }
        }
        addafter("Send IC Purchase Order")
        {
            action("Change Vendor")
            {
                Image = Change;
                RunObject = Report "Change Vendor-Purchase Order";
                ApplicationArea = all;
            }
        }
        addafter(RemoveFromJobQueue)
        {
            action("Open PO Report")
            {
                Caption = 'Open PO Report';
                Description = 'Open PO Report';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                ToolTip = 'Open PO Report';
                ApplicationArea = all;

                trigger OnAction()
                var
                    recPurchLine: Record "Purchase Line";
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    recPurchLine.Reset;
                    recPurchLine.SetRange(recPurchLine."Document No.", Rec."No.");
                    if recPurchLine.FindFirst then
                        REPORT.RunModal(50011, true, true, recPurchLine);
                    Rec.Reset;
                end;
            }
            action("Urgent Goods Requirement")
            {
                Caption = 'Urgent Goods Requirement';
                Description = 'Urgent Goods Requirement';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Urgent Goods Requirement";
                ToolTip = 'Urgent Goods Requirement New';
                ApplicationArea = all;
            }
            action("BackOrderFill Report")
            {
                Caption = 'Bal Qty on PO to Fill SO Report';
                Description = 'Bal Qty on PO to Fill SO Report';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                ToolTip = 'Bal Qty on PO to Fill SO Report';
                ApplicationArea = all;

                trigger OnAction()
                var
                    recPurchaseLine: Record "Purchase Line";
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    recPurchaseLine.Reset;
                    recPurchaseLine.SetRange(recPurchaseLine."Document No.", Rec."No.");
                    if recPurchaseLine.FindFirst then
                        REPORT.Run(50026, true, true, recPurchaseLine);
                    Rec.Reset;
                end;
            }
            action(SendEmailPDF)
            {
                Caption = 'Send Email PDF';
                Image = SendEmailPDF;
                ApplicationArea = all;

                trigger OnAction()
                var
                    SendSmtpMail: Codeunit SmtpMail_Ext;
                    UserSetup: Record "User Setup";
                    TEXT001: Label 'You are not authorized.';
                begin
                    if UserSetup.Get(UserId) and UserSetup."Sent Mail Purchase Order" then begin
                        CurrPage.SetSelectionFilter(Rec);
                        Rec.Copy(Rec);
                        if Rec.FindFirst then
                            repeat
                                SendSmtpMail.SendPurchaseOrderAsPDF(Rec);
                            until Rec.Next = 0;
                        Rec.Reset;
                        CurrPage.Update(true);
                    end else
                        Message(TEXT001);
                end;
            }
        }
    }

    procedure MailCountFN(RecNo: Code[20]): Integer
    var
        RecMailDetail: Record "Mail Detail";
        TotalNo: Integer;
    begin
        RecMailDetail.Reset;
        RecMailDetail.SetCurrentKey("Source No.", "Date Time");
        RecMailDetail.SetRange("Source No.", RecNo);
        if RecMailDetail.FindSet then
            TotalNo := RecMailDetail.Count;
        exit(TotalNo);
    end;

    procedure LastDateMailSentFN(OrderNo: Code[20]): DateTime
    var
        RecMailDetails: Record "Mail Detail";
        LastSentDate: DateTime;
    begin
        RecMailDetails.Reset;
        RecMailDetails.SetCurrentKey("Source No.", "Date Time");
        RecMailDetails.SetRange("Source No.", OrderNo);
        if RecMailDetails.FindLast then
            LastSentDate := RecMailDetails."Date Time";
        exit(LastSentDate);
    end;
}
