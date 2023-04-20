report 70015 "Shipped Samples Report Weekly"
{
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        Path: Text[250];
        txtSubject: Text[100];
        txtBody1: Text[1024];
        txtBody2: Text[1024];
        //Mail: Codeunit "SMTP Mail";      
        NewString: Text[50];
        MailTO: List of [Text];
        MailCC: List of [Text];
        MailBCC: List of [Text];
        Name: Text[60];
        FileName: Text[250];
        ToFile: Text[250];
        ShippedSamplesReport: Report "Shipped Samples Report";
        EmailMessage: Codeunit "Email Message";
        email: Codeunit Email;
        TempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        Outstream: OutStream;
        InStream: InStream;
        AddRecipients: List of [text];
        FromDate: date;
        ToDate: Date;
        WeeKStart: Date;
    begin
        WeeKStart := CalcDate('-CW', WorkDate());
        FromDate := CalcDate('-7D', WeeKStart);
        ToDate := CalcDate('-3D', WeeKStart);

        SalesPerson.RESET;
        SalesPerson.SetRange("Active MIS", true);
        IF SalesPerson.FINDFIRST THEN BEGIN
            REPEAT
                Clear(txtSubject);
                Clear(txtBody1);
                Clear(MailBCC);
                Clear(MailCC);
                Clear(AddRecipients);
                Clear(TempBlob);
                Clear(RecRef);

                SalesHeader.RESET;
                //SalesHeader.SETRANGE("Shipment Date", WORKDATE - 7, WORKDATE - 1);
                //SalesHeader.SETRANGE("Posting Date", WORKDATE - 7, WORKDATE - 1);
                SalesHeader.SETRANGE("Posting Date", FromDate, ToDate);
                SalesHeader.SETRANGE(SalesHeader."Salesperson Code", SalesPerson.Code);
                IF SalesHeader.FINDSET THEN BEGIN

                    NewString := CONVERTSTR(SalesPerson.Code, '/', '-');
                    Name := 'Weekly_Shipped_Samples_Report-' + NewString + '-' + CONVERTSTR(FORMAT(WORKDATE), '/', '-') + '.xlsx';

                    TempBlob.CreateOutStream(Outstream, TextEncoding::UTF8);
                    RecRef.GetTable(SalesHeader);
                    Report.SaveAs(70016, '', ReportFormat::Excel, Outstream, RecRef);
                    TempBlob.CreateInStream(InStream, TextEncoding::UTF8);
                    IF TempBlob.HasValue() THEN BEGIN
                        txtSubject := 'Weekly Shipped Sample Order Report ' + FORMAT(WORKDATE);
                        txtBody1 := '<html><body>'
                                    + '<pre><p><font face = "Arial" size = "4">Dear ' + SalesPerson.Name + ',</font></p></pre>'
                                    + '<pre><p><font face = "Arial" size = "4">Please find Weekly Shipped Sample Order Report for Last Week, </a></font></p></pre>'
                                    + '<pre><p><font face = "Arial" size = "4">Thank you</font></p></pre>'
                                    + '<pre><p><font face = "Arial" size = "3"><b>posh textiles Team</font></p></pre>' +
                                    '</html></body>';

                        ComInfo.GET();
                        IF ComInfo."Test MIS E-Mail" <> '' then
                            AddRecipients.Add(ComInfo."Test MIS E-Mail")
                        ELSE
                            AddRecipients.Add(SalesPerson."E-Mail");

                        IF ComInfo."Test MIS E-Mail" = '' then BEGIn
                            MailCC.Add('sarika@poshtextiles.com');
                            MailCC.Add('mm@poshtextiles.com');
                        END;

                        EmailMessage.Create(AddRecipients, txtSubject, txtBody1, TRUE, MailCC, MailBCC);
                        EmailMessage.AddAttachment(Name, '.xlsx', InStream);
                        Email.Send(EmailMessage);
                    END;
                END;

            UNTIL SalesPerson.NEXT = 0;
        END;
    end;

    var
        ComInfo: Record "Company Information";
        SalesPerson: Record "Salesperson/Purchaser";
        SalesHeader: Record "Sales Invoice Header";
        FileMgt: Codeunit "File Management";
}

