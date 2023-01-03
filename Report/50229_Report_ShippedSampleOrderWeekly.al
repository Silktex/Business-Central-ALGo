report 50229 "Shipped Sample Order Weekly"
{
    ProcessingOnly = true;

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
        //Mail: Codeunit "SMTP Mail";
        NewString: Text[50];
        MailTO: Text[100];
        Name: Text[60];
        FileName: Text[250];
        ToFile: Text[250];
        EMailMessage: Codeunit "Email Message";
        EMail: Codeunit Email;
        TempBlob: Codeunit "Temp Blob";
        Instream: InStream;
        Outstream: OutStream;
        RecRef: RecordRef;
        ToMail: List of [Text];
        CCMail: List of [Text];
        BccMail: List of [Text];
    begin

        SalesPerson.RESET;
        //SalesPerson.SETRANGE(SalesPerson.Code,'SP0001');
        IF SalesPerson.FINDFIRST THEN BEGIN
            REPEAT
                SalesHeader.RESET;
                SalesHeader.SETRANGE(SalesHeader."Document Type", SalesHeader."Document Type"::Order);
                SalesHeader.SETRANGE(SalesHeader."Salesperson Code", SalesPerson.Code);
                IF SalesHeader.FINDFIRST THEN BEGIN
                    // IF EXISTS(Path) THEN
                    //     ERASE(Path);

                    NewString := CONVERTSTR(SalesPerson.Code, '/', '-');
                    Name := 'Weekly Shipped Sample Report-' + NewString + '-' + CONVERTSTR(FORMAT(TODAY), '/', '-') + '.pdf';
                    ToFile := Name;
                    //FileName := TEMPORARYPATH + ToFile;
                    FileName := ToFile;
                    //REPORT.SAVEASPDF(50228, FileName, SalesHeader);
                    TempBlob.CreateOutStream(Outstream, TextEncoding::UTF8);
                    RecRef.GetTable(SalesHeader);
                    Report.SaveAs(50228, '', ReportFormat::Pdf, Outstream, RecRef);
                    SLEEP(50000);

                    //ToFile := DownloadToClientFileName(FileName, ToFile);

                    txtSubject := 'Weekly Shipped Sample Order Report ' + FORMAT(TODAY);
                    txtBody1 := '<html><body>'
                                + '<pre><p><font face = "Arial" size = "4">Dear ' + SalesPerson.Name + ',</font></p></pre>'
                                + '<pre><p><font face = "Arial" size = "4">Please find Weekly Shipped Sample Order Report for Last Week, </a></font></p></pre>'
                                + '<pre><p><font face = "Arial" size = "4">Thank you</font></p></pre>'
                                + '<pre><p><font face = "Arial" size = "3"><b>Silk Crafts Team</font></p></pre>' +
                                '</html></body>';

                    ToMail.add('rs@silk-crafts.com');
                    BCCMail.Add('t.tarunsharma@yahoo.com');
                    TempBlob.CreateInStream(Instream, TextEncoding::UTF8);
                    //MailTO := 't.tarunsharma@yahoo.com';
                    //Mail.CreateMessage('Weekly Shipped Sample Order Report', 'accounts@silk-crafts.com', MailTO, txtSubject, txtBody1, TRUE);
                    //Mail.AddCC('rs@silk-crafts.com');
                    //Mail.AddBCC('t.tarunsharma@yahoo.com');

                    SLEEP(20000);
                    EMailMessage.AddAttachment(ToFile, '.pdf', Instream);
                    EMailMessage.Create(ToMail, txtSubject, txtBody1, TRUE, CCMail, BccMail);
                    //Mail.AddAttachment(FileName, FileName);
                    //Mail.Send();
                    EMail.Send(EMailMessage);
                END;
            UNTIL SalesPerson.NEXT = 0;
        END;
    end;

    var
        SalesPerson: Record "Salesperson/Purchaser";
        SalesHeader: Record "Sales Header";


    // procedure DownloadToClientFileName(ServerFileName: Text[250]; ToFile: Text[250]): Text[250]
    // var
    //     ClientFileName: Text[250];
    //     objScript: Automation;
    //     CR: Text[1];
    // begin
    //     ClientFileName := ToFile;
    //     IF NOT DOWNLOAD(ServerFileName, '', '<TEMP>', '', ClientFileName) THEN
    //         EXIT('');
    //     IF CREATE(objScript, TRUE, TRUE) THEN BEGIN
    //         CR := ' ';
    //         CR[1] := 13;
    //         objScript.Language := 'VBScript';
    //         objScript.AddCode(
    //         'function RenameTempFile(fromFile, toFile)' + CR +
    //         'set fso = createobject("Scripting.FileSystemObject")' + CR +
    //         'set x = createobject("Scriptlet.TypeLib")' + CR +
    //         'path = fso.getparentfoldername(fromFile)' + CR +
    //         'toPath = path+"\"+left(x.GUID,38)' + CR +
    //         'fso.CreateFolder toPath' + CR +
    //         'fso.MoveFile fromFile, toPath+"\"+toFile' + CR +
    //         'RenameTempFile = toPath' + CR +
    //         'end function');
    //         ClientFileName := objScript.Eval('RenameTempFile("' + ClientFileName + '","' + ToFile + '")');
    //         ClientFileName := ClientFileName + '\' + ToFile;
    //     END;
    //     EXIT(ClientFileName);
    // end;
}

