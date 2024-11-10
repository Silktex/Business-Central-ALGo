pageextension 50236 "Posted Sales Shipments_Ext" extends "Posted Sales Shipments"
{
    layout
    {
        moveafter("Sell-to Customer Name"; "External Document No.")
        modify("External Document No.")
        {
            Visible = true;
        }
        addafter("External Document No.")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Document Date")
        {
            field("Customer Posting Group"; Rec."Customer Posting Group")
            {
                ApplicationArea = all;
            }
            field("Campaign No."; Rec."Campaign No.")
            {
                ApplicationArea = all;
            }
            field("Project Name"; Rec."Project Name")
            {
                ApplicationArea = all;
            }
            field("Project Location"; Rec."Project Location")
            {
                ApplicationArea = all;
            }
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
            field("LastMailSenton"; LastDateMailSentFN(Rec."No."))
            {
                Caption = 'Last Mail Sent on';
                ApplicationArea = all;
            }
            field("Tracking No."; Rec."Tracking No.")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("Sales - Shipment per Package")
        {
            action(SendEmailPDF)
            {
                Caption = 'Send Email PDF';
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
                    if UserSetup.Get(UserId) and UserSetup."Sent Mail Sales Shipment" then begin
                        IF rec."Location Code" <> 'MATRL BANK' THEN BEGIn
                            CurrPage.SetSelectionFilter(Rec);
                            Rec.Copy(Rec);
                            if Rec.FindFirst then
                                repeat
                                    SendSmtpMail.SendShipmentAsPDF(Rec);
                                until Rec.Next = 0;
                        END;
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
        Rec."Tracking No." := '';
        recPWSL.RESET;
        recPWSL.SETRANGE("Posted Source Document", recPWSL."Posted Source Document"::"Posted Shipment");
        recPWSL.SETRANGE("Posted Source No.", Rec."No.");
        IF recPWSL.FIND('-') THEN begin
            recTrackingNo.RESET;
            recTrackingNo.SETRANGE(recTrackingNo."Warehouse Shipment No", recPWSL."Whse. Shipment No.");
            IF recTrackingNo.FIND('-') THEN
                Rec."Tracking No." := recTrackingNo."Tracking No.";
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        Rec."Tracking No." := '';
        recPWSL.RESET;
        recPWSL.SETRANGE("Posted Source Document", recPWSL."Posted Source Document"::"Posted Shipment");
        recPWSL.SETRANGE("Posted Source No.", Rec."No.");
        IF recPWSL.FIND('-') THEN begin
            recTrackingNo.RESET;
            recTrackingNo.SETRANGE(recTrackingNo."Warehouse Shipment No", recPWSL."Whse. Shipment No.");
            IF recTrackingNo.FIND('-') THEN
                Rec."Tracking No." := recTrackingNo."Tracking No.";
        end;
    end;

    var
        recPWSL: Record "Posted Whse. Shipment Line";
        recTrackingNo: Record "Tracking No.";
        //Xmlhttp: Automation;
        Result: Boolean;
        txtURL: Text;
        recCompInfo: Record "Company Information";
        IsOfficeAddin: Boolean;

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

    procedure LastDateMailSentFN(ShipmentNo: Code[20]): DateTime
    var
        RecMailDetails: Record "Mail Detail";
        LastSentDate: DateTime;
    begin
        RecMailDetails.Reset;
        RecMailDetails.SetCurrentKey("Source No.", "Date Time");
        RecMailDetails.SetRange("Source No.", ShipmentNo);
        if RecMailDetails.FindLast then
            LastSentDate := RecMailDetails."Date Time";
        exit(LastSentDate);
    end;

}
