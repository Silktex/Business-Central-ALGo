pageextension 50209 "Vendor List_Ext" extends "Vendor List"
{
    layout
    {
        modify("Name 2")
        {
            Visible = true;
            CaptionML = ENU = 'Short Name',
                           ESM = 'Nombre 2',
                           FRC = 'Nom 2',
                           ENC = 'Name 2';
        }
        addafter("Base Calendar Code")
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
            field("""LastMailSenton"; LastDateMailSentFN(Rec."No."))
            {
                Caption = 'Last Mail Sent on';
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        modify("Aged Accounts Payable")
        {
            Visible = false;
        }
        addafter("Vendor - Trial Balance")
        {
            action("Aged Accounts Payable New")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Aged Accounts Payable';
                Image = "Report";
                RunObject = Report "Aged Accounts Payable Ext";
                ToolTip = 'View a list of aged remaining balances for each vendor.';
            }
        }
        addafter("Payment Journal")
        {
            action(VendorDetail)
            {
                Caption = 'Vendor Detail';
                Image = LedgerEntries;
                RunObject = Page "Vendor Detail";
                RunPageOnRec = true;
                ApplicationArea = all;
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
                    if UserSetup.Get(UserId) and UserSetup."Sent Mail Vendor Ledger" then begin
                        CurrPage.SetSelectionFilter(Rec);
                        Rec.Copy(Rec);
                        if Rec.FindFirst then
                            repeat
                                SendSmtpMail.SendVendorLedgerAsPDF(Rec);
                            until Rec.Next = 0;
                        Rec.Reset;
                        CurrPage.Update(true);
                    end else
                        Message(TEXT001);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        Rec.Ascending(false);
        if Rec.FindFirst() then;
    end;

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
