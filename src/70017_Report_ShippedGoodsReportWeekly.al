report 70017 "Shipped Goods Report Weekly"
{
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
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
        NewString: Text[50];
        Name: Text[60];
        FileName: Text[250];
        ToFile: Text[250];
        EmailMessage: Codeunit "Email Message";
        email: Codeunit Email;
        TempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        Outstream: OutStream;
        InStream: InStream;
        MailTO: List of [Text];
        MailCC: List of [Text];
        MailBCC: List of [Text];
        AddRecipients: List of [text];
    begin


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
                SalesHeader.SETRANGE("Posting Date", WORKDATE - 7, WORKDATE - 1);
                SalesHeader.SETRANGE(SalesHeader."Salesperson Code", SalesPerson.Code);
                IF SalesHeader.FINDSET THEN BEGIN

                    NewString := CONVERTSTR(SalesPerson.Code, '/', '-');
                    Name := 'Weekly_Shipped_Goods_Report-' + NewString + '-' + CONVERTSTR(FORMAT(WORKDATE), '/', '-') + '.xlsx';
                    ToFile := Name;

                    TempBlob.CreateOutStream(Outstream, TextEncoding::UTF8);
                    RecRef.GetTable(SalesHeader);
                    Report.SaveAs(70011, '', ReportFormat::Excel, Outstream, RecRef);
                    SLEEP(20000);

                    TempBlob.CreateInStream(InStream, TextEncoding::UTF8);
                    IF TempBlob.HasValue() THEN BEGIN
                        txtSubject := 'Weekly Shipped Goods Report ' + FORMAT(WORKDATE);
                        txtBody1 := '<html><body>'
                                    + '<pre><p><font face = "Arial" size = "4">Dear ' + SalesPerson.Name + ',</font></p></pre>'
                                    + '<pre><p><font face = "Arial" size = "4">Please find Weekly Shipped Goods Report for Last Week, </a></font></p></pre>'
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
                            //MailCC.Add('mm@poshtextiles.com');
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
        SalesPerson: Record "Salesperson/Purchaser";
        SalesHeader: Record "Sales Invoice Header";
        ComInfo: Record "Company Information";
}

