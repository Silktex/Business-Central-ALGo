pageextension 50237 "Posted Sales Invoices_Ext" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Sell-to Customer Name"; "External Document No.")
        modify("External Document No.")
        {
            Visible = true;
        }
        moveafter("Currency Code"; "Order No.")
        modify("Order No.")
        {
            Visible = true;
        }
        addafter("Order No.")
        {

            field("Pre-Assigned No."; Rec."Pre-Assigned No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Ship-to Contact")
        {
            field("Customer Posting Group"; Rec."Customer Posting Group")
            {
                ApplicationArea = all;
            }
            field("Campaign No."; Rec."Campaign No.")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Shipping Agent Code"; Closed)

        modify(Closed)
        {
            Visible = true;
            Caption = 'Closed/Paid';
            ToolTip = 'Specifies if the posted sales invoice is paid. The check box will also be selected if a credit memo for the remaining amount has been applied.';
        }

        addafter("Shipment Date")
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
        addafter(Dimensions)
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
                    // ReportHelper: Codeunit "SMTP Mail";
                    Name: Text[50];
                    FileName: Text[250];
                    ToFile: Text[250];
                begin
                    IF Rec."Location Code" <> 'MATRL BANK' then begin
                        CurrPage.SetSelectionFilter(Rec);
                        Name := StrSubstNo('%1.pdf', Rec."No.");
                        ToFile := Name;
                        CUMail.SalesInvoiceOutlook(Rec, ToFile);
                    End;
                    Rec.Reset;
                    CurrPage.Update(true);
                end;
            }
        }
        addafter(Print)
        {
            action(SendEmailPDF)
            {
                Caption = 'Send Email PDF';
                Ellipsis = true;
                Image = SendEmailPDF;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;

                trigger OnAction()
                var
                    SendSmtpMail: Codeunit SmtpMail_Ext;
                    UserSetup: Record "User Setup";
                    TEXT001: Label 'You are not authorized.';
                begin
                    if UserSetup.Get(UserId) and UserSetup."Sent Mail Sales Invoice" then begin
                        IF Rec."Location Code" <> 'MATRL BANK' THEn BEGIn
                            CurrPage.SetSelectionFilter(Rec);
                            Rec.Copy(Rec);
                            if Rec.FindFirst then
                                repeat
                                    SendSmtpMail.SendInvoiceAsPDF(Rec);
                                until Rec.Next = 0;
                        END;
                        Rec.Reset;
                        CurrPage.Update(true);
                    end else
                        Message(TEXT001);
                end;
            }
        }
        addafter(ShowCreditMemo)
        {
            action("<Report Sales Commission Report>")
            {
                Caption = 'Report Sales Commission Report';
                //   RunObject = Report "Sales Commission";
                ApplicationArea = all;
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
