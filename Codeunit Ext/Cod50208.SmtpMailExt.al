codeunit 50208 SmtpMail_Ext
{
    var
        txtReceipient: Text;
        RecRef: RecordRef;
        OutStreamValue: OutStream;
        InStreamValue: InStream;
        Tempblob: Codeunit "Temp Blob";
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        AddRecipients: List of [text];
        AddCC: List of [Text];
        AddBCC: List of [Text];
        BodyText: Text;

    procedure SendSalesOrderAsPDF(recSalesHeader: Record "Sales Header")
    var
        CompanyInfo: Record "Company Information";
        LocationInfo: Record Location;
        ContryRegion: Record "Country/Region";
        UserSetup: Record "User Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        ContactBusinessRelation: Record "Contact Business Relation";
        ReportSelection: Record "Report Selections";
        Contact: Record Contact;
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        MailDetail: Record "Mail Detail";
        Name: Text[50];
        FileName: Text[250];
        ToFile: Text[250];
        FromMailID: Text[50];
        TOAddress: Text[250];
        CCAddress: Text[250];
        Text001: Label 'Please find enclosed a copy of your sales order.';
        Text002: Label 'Regards,';
        BCCAddress: Text[250];
        LocationAdd1: Text[100];
        LocationAdd2: Text[100];
        LocationCity: Text[50];
        LocationPostCode: Code[20];
        LocationCountry: Text[50];
    begin
        BodyText := '';
        Clear(AddBCC);
        Clear(AddCC);
        Clear(AddRecipients);
        Clear(Tempblob);
        Clear(RecRef);
        Clear(OutStreamValue);
        Clear(InStreamValue);
        CompanyInfo.GET;
        IF LocationInfo.GET(recSalesHeader."Location Code") THEN BEGIN
            LocationAdd1 := LocationInfo.Address;
            LocationAdd2 := LocationInfo."Address 2";
            LocationCity := LocationInfo.City;
            LocationPostCode := LocationInfo."Post Code";
            IF ContryRegion.GET(LocationInfo."Country/Region Code") THEN
                LocationCountry := ContryRegion.Name;
        END;

        Name := STRSUBSTNO('Order No. %1.pdf', recSalesHeader."No.");
        ToFile := Name;
        //FileName := TEMPORARYPATH + ToFile;

        TempBlob.CreateOutStream(OutStreamValue, TEXTENCODING::UTF8);
        ReportSelection.RESET;
        ReportSelection.SETRANGE(Usage, ReportSelection.Usage::"S.Order");
        ReportSelection.SETFILTER("Report ID", '<>0');
        IF ReportSelection.FINDFIRST THEN BEGIN
            recSalesHeader.SETRANGE("No.", recSalesHeader."No.");
            IF recSalesHeader.FINDFIRST THEN begin
                RecRef.GetTable(recSalesHeader);
                REPORT.SAVEAS(ReportSelection."Report ID", '', ReportFormat::Pdf, OutStreamValue, RecRef);
            end;
        END;

        //ToFile := DownloadToClientFileName(FileName, ToFile);

        IF UserSetup.GET(USERID) THEN
            FromMailID := UserSetup."E-Mail";


        txtReceipient := '';
        //CreateMessage(CompanyInfo.Name, FromMailID, '', 'Sales Order' + ' ' + recSalesHeader."No.", '', TRUE);
        ContactBusinessRelation.RESET;
        ContactBusinessRelation.SETRANGE(ContactBusinessRelation."No.", recSalesHeader."Sell-to Customer No.");
        IF ContactBusinessRelation.FINDFIRST THEN BEGIN
            Contact.RESET;
            Contact.SETRANGE(Contact."Company No.", ContactBusinessRelation."Contact No.");
            IF Contact.FINDFIRST THEN
                REPEAT
                    IF (Contact."Mail To" <> FALSE) AND (Contact."Sales Order" <> FALSE) THEN BEGIN
                        IF Contact."E-Mail" <> '' THEN BEGIN
                            AddRecipients.Add(Contact."E-Mail");
                            txtReceipient := txtReceipient + Contact."E-Mail";
                        END;
                    END ELSE
                        IF (Contact."Mail CC" <> FALSE) AND (Contact."Sales Order" <> FALSE) THEN BEGIN
                            IF Contact."E-Mail" <> '' THEN BEGIN
                                AddCC.Add(Contact."E-Mail");
                                txtReceipient := txtReceipient + Contact."E-Mail";
                            END;
                        END;
                    AddBCC.Add('SO@silk-safari.com');
                UNTIL Contact.NEXT = 0;
        END;
        IF SalespersonPurchaser.GET(recSalesHeader."Salesperson Code") THEN BEGIN
            IF SalespersonPurchaser."E-Mail" <> '' THEN BEGIN
                IF SalespersonPurchaser."Sales Order" THEN BEGIN
                    IF SalespersonPurchaser."Mail To" THEN
                        AddRecipients.Add(SalespersonPurchaser."E-Mail");
                    IF SalespersonPurchaser."Mail CC" THEN
                        AddCC.Add(SalespersonPurchaser."E-Mail");
                    IF SalespersonPurchaser."Mail BCC" THEN
                        AddBCC.Add(SalespersonPurchaser."E-Mail");
                END;
            END;
        END;

        IF txtReceipient <> '' THEN BEGIN
            // AddBCC('SO@silk-safari.com');

            BodyText := ('<html>');
            BodyText += ('<head>');
            BodyText += ('<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
            BodyText += ('<title>Sales Order</title>');
            BodyText += ('</head>');
            BodyText += ('<body>');
            BodyText += ('<p>');
            BodyText += ('Dear Sir/Madam,');
            BodyText += ('</p>');
            BodyText += ('<p>');
            BodyText += (Text001);
            BodyText += ('</p>');
            BodyText += ('<p>');
            BodyText += (Text002);
            BodyText += ('<br>');
            BodyText += ('<B>' + CompanyInfo.Name + '</B>');
            BodyText += ('<br>');
            BodyText += (LocationAdd1 + ' ' + LocationAdd2);
            BodyText += ('<br>');
            BodyText += (LocationCity + ', ' + LocationInfo.County + ' ' + LocationPostCode + ' ' + LocationCountry);
            BodyText += ('<br>');
            BodyText += ('</p>');
            BodyText += ('<br>');
            BodyText += ('<P>This is a system-generated e-mail.</P>');
            BodyText += ('<br>');
            BodyText += ('</body>');
            BodyText += ('</html>');
            EmailMessage.Create(AddRecipients, 'Sales Order' + ' ' + recSalesHeader."No.", BodyText, TRUE, AddCC, AddBCC);
            TempBlob.CreateInStream(InStreamValue, TextEncoding::UTF8);
            EmailMessage.AddAttachment(ToFile, '.pdf', InStreamValue);
            // Email.OpenInEditor(EmailMessage);
            Email.Send(EmailMessage);
            //Send();

            MailDetail.FINDLAST;
            MailDetail.INIT;
            MailDetail."Entry No." := MailDetail."Entry No." + 1;
            MailDetail.Type := 'Sales Order';
            MailDetail."Source No." := recSalesHeader."No.";
            MailDetail."Date Time" := CURRENTDATETIME;
            MailDetail.INSERT;

        END;
        //FILE.ERASE(FileName);
    end;


    procedure SendInvoiceAsPDF(var recSalesInvoiceHeader: Record "Sales Invoice Header")
    var
        CompanyInfo: Record "Company Information";
        LocationInfo: Record Location;
        ContryRegion: Record "Country/Region";
        UserSetup: Record "User Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        ContactBusinessRelation: Record "Contact Business Relation";
        Contact: Record Contact;
        MailDetail: Record "Mail Detail";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        Name: Text[50];
        FileName: Text[250];
        ToFile: Text[250];
        FromMailID: Text[50];
        TOAddress: Text[250];
        CCAddress: Text[250];
        Text001: Label 'Please find enclosed a copy of your invoice.';
        Text002: Label 'Regards,';
        BCCAddress: Text[250];
        LocationAdd1: Text[100];
        LocationAdd2: Text[100];
        LocationCity: Text[50];
        LocationPostCode: Code[20];
        LocationCountry: Text[50];
        ReportSelection: Record "Report Selections";
        rptSalesInvoice: Report "Sales Invoice Com";
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        BodyText := '';
        Clear(AddBCC);
        Clear(AddCC);
        Clear(AddRecipients);
        Clear(Tempblob);
        Clear(RecRef);
        Clear(OutStreamValue);
        Clear(InStreamValue);
        CompanyInfo.GET;
        IF LocationInfo.GET(recSalesInvoiceHeader."Location Code") THEN BEGIN
            LocationAdd1 := LocationInfo.Address;
            LocationAdd2 := LocationInfo."Address 2";
            LocationCity := LocationInfo.City;
            LocationPostCode := LocationInfo."Post Code";
            IF ContryRegion.GET(LocationInfo."Country/Region Code") THEN
                LocationCountry := ContryRegion.Name;
        END;

        Name := STRSUBSTNO('Invoice No. %1.pdf', recSalesInvoiceHeader."No.");
        ToFile := Name;
        //FileName := TEMPORARYPATH + ToFile;

        ///RS 170222
        Tempblob.CreateOutStream(OutStreamValue);
        ReportSelection.RESET;
        ReportSelection.SETRANGE(Usage, ReportSelection.Usage::"S.Invoice");
        ReportSelection.SETFILTER("Report ID", '<>0');
        IF ReportSelection.FINDFIRST THEN BEGIN
            SalesInvoiceHeader.Reset();
            SalesInvoiceHeader.SETRANGE("No.", recSalesInvoiceHeader."No.");
            IF SalesInvoiceHeader.FINDFIRST THEN;
            RecRef.GetTable(SalesInvoiceHeader);
            REPORT.SAVEAS(ReportSelection."Report ID", '', ReportFormat::Pdf, OutStreamValue, RecRef);
            // end;
        END;
        ///RS 170222

        //ToFile := DownloadToClientFileName(FileName, ToFile);

        IF UserSetup.GET(USERID) THEN
            FromMailID := UserSetup."E-Mail";

        txtReceipient := '';
        //CreateMessage(CompanyInfo.Name, FromMailID, '', 'Invoice' + ' ' + recSalesInvoiceHeader."No.", '', TRUE);
        ContactBusinessRelation.RESET;
        ContactBusinessRelation.SETRANGE(ContactBusinessRelation."No.", recSalesInvoiceHeader."Sell-to Customer No.");
        IF ContactBusinessRelation.FINDFIRST THEN BEGIN
            Contact.RESET;
            Contact.SETRANGE(Contact."Company No.", ContactBusinessRelation."Contact No.");
            IF Contact.FINDFIRST THEN
                REPEAT
                    IF (Contact."Mail To" <> FALSE) AND (Contact."Sales Invoice" <> FALSE) THEN BEGIN
                        IF Contact."E-Mail" <> '' THEN BEGIN
                            AddRecipients.Add(Contact."E-Mail");
                            txtReceipient := txtReceipient + Contact."E-Mail";
                        END;
                    END ELSE
                        IF (Contact."Mail CC" <> FALSE) AND (Contact."Sales Invoice" <> FALSE) THEN BEGIN
                            IF Contact."E-Mail" <> '' THEN BEGIN
                                AddCC.Add(Contact."E-Mail");
                                txtReceipient := txtReceipient + Contact."E-Mail";
                            END;
                        END;
                    AddBCC.Add('SI@silk-safari.com');
                UNTIL Contact.NEXT = 0;
        END;

        ///Posh Code BEGIN
        IF txtReceipient = '' THEN BEGIN
            Contact.RESET;
            Contact.SETRANGE("No.", recSalesInvoiceHeader."Bill-to Contact No.");
            IF Contact.FINDFIRST THEN BEGIN
                IF Contact."E-Mail" <> '' THEN BEGIN
                    AddRecipients.Add(Contact."E-Mail");
                    txtReceipient := txtReceipient + Contact."E-Mail";
                END;
            END;
        END;
        ///Posh Code END

        IF SalespersonPurchaser.GET(recSalesInvoiceHeader."Salesperson Code") THEN BEGIN
            IF SalespersonPurchaser."E-Mail" <> '' THEN BEGIN
                IF SalespersonPurchaser."Sales Invoice" THEN BEGIN
                    IF SalespersonPurchaser."Mail To" THEN
                        AddRecipients.Add(SalespersonPurchaser."E-Mail");
                    IF SalespersonPurchaser."Mail CC" THEN
                        AddCC.Add(SalespersonPurchaser."E-Mail");
                    IF SalespersonPurchaser."Mail BCC" THEN
                        AddBCC.Add(SalespersonPurchaser."E-Mail");
                END;
            END;
        END;

        IF txtReceipient <> '' THEN BEGIN

            BodyText := ('<html>');
            BodyText += ('<head>');
            BodyText += ('<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
            BodyText += ('<title>Sales Invoice</title>');
            BodyText += ('</head>');
            BodyText += ('<body>');
            BodyText += ('<p>');
            BodyText += ('Dear Sir/Madam,');
            BodyText += ('</p>');
            BodyText += ('<p>');
            BodyText += (Text001);
            BodyText += ('</p>');
            BodyText += ('<p>');
            BodyText += (Text002);
            BodyText += ('<br>');
            BodyText += ('<B>' + CompanyInfo.Name + '</B>');
            BodyText += ('<br>');
            BodyText += (LocationAdd1 + ' ' + LocationAdd2);
            BodyText += ('<br>');
            BodyText += (LocationCity + ', ' + LocationInfo.County + ' ' + LocationPostCode + ' ' + LocationCountry);
            BodyText += ('<br>');
            BodyText += ('</p>');
            BodyText += ('<br>');
            BodyText += ('<P>This is a system-generated e-mail.</P>');
            BodyText += ('<br>');
            BodyText += ('</body>');
            BodyText += ('</html>');
            EmailMessage.Create(AddRecipients, 'Invoice' + ' ' + recSalesInvoiceHeader."No.", BodyText, true, AddCC, AddBCC);
            Tempblob.CreateInStream(InStreamValue, TextEncoding::UTF8);
            EmailMessage.AddAttachment(ToFile, '.pdf', InStreamValue);

            Email.Send(EmailMessage);

            MailDetail.FINDLAST;
            MailDetail.INIT;
            MailDetail."Entry No." := MailDetail."Entry No." + 1;
            MailDetail.Type := 'Sales Invoice';
            MailDetail."Source No." := recSalesInvoiceHeader."No.";
            MailDetail."Date Time" := CURRENTDATETIME;
            MailDetail.INSERT;

        END;
        //FILE.ERASE(FileName);
    end;


    procedure SendCustomerLedgerAsPDF(recCustomer: Record Customer)
    var
        CompanyInfo: Record "Company Information";
        ContryRegion: Record "Country/Region";
        UserSetup: Record "User Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        MailDetail: Record "Mail Detail";
        ContactBusinessRelation: Record "Contact Business Relation";
        Contact: Record Contact;
        Name: Text[50];
        FileName: Text[250];
        ToFile: Text[250];
        FromMailID: Text[50];
        TOAddress: Text[250];
        CCAddress: Text[250];
        Text001: Label 'Please find enclosed a copy of your ledger.';
        Text002: Label 'Regards,';
        BCCAddress: Text[250];
        LocationAdd1: Text[100];
        LocationAdd2: Text[100];
        LocationCity: Text[50];
        LocationPostCode: Code[20];
        LocationState: Text[50];
        LocationCountry: Text[50];
    begin
        BodyText := '';
        Clear(AddBCC);
        Clear(AddCC);
        Clear(AddRecipients);
        Clear(Tempblob);
        Clear(RecRef);
        Clear(OutStreamValue);
        Clear(InStreamValue);
        CompanyInfo.GET;
        LocationAdd1 := CompanyInfo.Address;
        LocationAdd2 := CompanyInfo."Address 2";
        LocationCity := CompanyInfo.City;
        LocationPostCode := CompanyInfo."Post Code";
        IF ContryRegion.GET(CompanyInfo."Country/Region Code") THEN
            LocationCountry := ContryRegion.Name;

        Name := STRSUBSTNO('Customer No. %1.pdf', recCustomer."No.");
        ToFile := Name;
        //FileName := TEMPORARYPATH + ToFile;
        Tempblob.CreateOutStream(OutStreamValue, TextEncoding::UTF8);
        recCustomer.SETRANGE("No.", recCustomer."No.");
        IF recCustomer.FINDFIRST THEN begin
            RecRef.GetTable(recCustomer);
            //REPORT.SAVEASPDF(REPORT::"Customer - Detail Trial Bal.", FileName, recCustomer);
            REPORT.SAVEAS(REPORT::"Customer - Detail Trial Bal.", '', ReportFormat::Pdf, OutStreamValue, RecRef);
        end;
        //ToFile := DownloadToClientFileName(FileName, ToFile);
        Tempblob.CreateInStream(InStreamValue, TextEncoding::UTF8);
        IF SalesReceivablesSetup.GET() THEN
            FromMailID := SalesReceivablesSetup."Email Id";

        txtReceipient := '';
        //CreateMessage(CompanyInfo.Name, FromMailID, '', 'Customer Ledger' + ' ' + recCustomer."No.", '', TRUE);
        ContactBusinessRelation.RESET;
        ContactBusinessRelation.SETRANGE(ContactBusinessRelation."No.", recCustomer."No.");
        IF ContactBusinessRelation.FINDFIRST THEN BEGIN
            Contact.RESET;
            Contact.SETRANGE(Contact."Company No.", ContactBusinessRelation."Contact No.");
            IF Contact.FINDFIRST THEN
                REPEAT
                    IF (Contact."Mail To" <> FALSE) AND (Contact."Customer Ledger" <> FALSE) THEN BEGIN
                        IF Contact."E-Mail" <> '' THEN BEGIN
                            AddRecipients.Add(Contact."E-Mail");
                            txtReceipient := txtReceipient + Contact."E-Mail";
                        END;
                    END ELSE
                        IF (Contact."Mail CC" <> FALSE) AND (Contact."Customer Ledger" <> FALSE) THEN BEGIN
                            IF Contact."E-Mail" <> '' THEN BEGIN
                                AddCC.Add(Contact."E-Mail");
                                txtReceipient := txtReceipient + Contact."E-Mail";
                            END;
                        END;
                    AddBCC.Add('AR@silk-safari.com');
                UNTIL Contact.NEXT = 0;
        END;
        IF txtReceipient <> '' THEN BEGIN
            BodyText := ('<html>');
            BodyText += ('<head>');
            BodyText += ('<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
            BodyText += ('<title>Customer Ledger</title>');
            BodyText += ('</head>');
            BodyText += ('<body>');
            BodyText += ('<p>');
            BodyText += ('Dear Sir/Madam,');
            BodyText += ('</p>');
            BodyText += ('<p>');
            BodyText += (Text001);
            BodyText += ('</p>');

            BodyText += ('<p>');
            BodyText += (Text002);
            BodyText += ('<br>');
            BodyText += ('<B>' + CompanyInfo.Name + '</B>');
            BodyText += ('<br>');
            BodyText += (LocationAdd1 + ' ' + LocationAdd2);
            BodyText += ('<br>');
            BodyText += (LocationCity + ', ' + LocationCity + ' ' + LocationPostCode + ' ' + LocationCountry);
            BodyText += ('<br>');
            BodyText += ('</p>');
            BodyText += ('<br>');
            BodyText += ('<P>This is a system-generated e-mail.</P>');
            BodyText += ('<br>');
            BodyText += ('</body>');
            BodyText += ('</html>');
            EmailMessage.Create(AddRecipients, 'Customer Ledger' + ' ' + recCustomer."No.", BodyText, TRUE, AddCC, AddBCC);
            EmailMessage.AddAttachment(ToFile, '.pdf', InStreamValue);
            email.Send(EmailMessage);

            MailDetail.FINDLAST;
            MailDetail.INIT;
            MailDetail."Entry No." := MailDetail."Entry No." + 1;
            MailDetail.Type := 'Customer Ledger';
            MailDetail."Source No." := recCustomer."No.";
            MailDetail."Date Time" := CURRENTDATETIME;
            MailDetail.INSERT;

            MESSAGE('E-mail Sent for Customer No. %1', recCustomer."No.");
        END;
        //FILE.ERASE(FileName);
    end;


    procedure SendPurchaseOrderAsPDF(recPurchaseOrderHeader: Record "Purchase Header")
    var
        CompanyInfo: Record "Company Information";
        LocationInfo: Record Location;
        ContryRegion: Record "Country/Region";
        UserSetup: Record "User Setup";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        MailDetail: Record "Mail Detail";
        ReportSelection: Record "Report Selections";
        ContactBusinessRelation: Record "Contact Business Relation";
        Contact: Record Contact;
        Name: Text[50];
        FileName: Text[250];
        ToFile: Text[250];
        FromMailID: Text[50];
        TOAddress: Text[250];
        CCAddress: Text[250];
        Text001: Label 'Please find enclosed a copy of your purchase order.';
        Text002: Label 'Regards,';
        BCCAddress: Text[250];
        LocationAdd1: Text[100];
        LocationAdd2: Text[100];
        LocationCity: Text[50];
        LocationPostCode: Code[20];
        LocationState: Text[50];
        LocationCountry: Text[50];
    begin
        BodyText := '';
        Clear(AddBCC);
        Clear(AddCC);
        Clear(AddRecipients);
        Clear(Tempblob);
        Clear(RecRef);
        Clear(OutStreamValue);
        Clear(InStreamValue);

        CompanyInfo.GET;
        IF LocationInfo.GET(recPurchaseOrderHeader."Location Code") THEN BEGIN
            LocationAdd1 := LocationInfo.Address;
            LocationAdd2 := LocationInfo."Address 2";
            LocationCity := LocationInfo.City;
            LocationPostCode := LocationInfo."Post Code";
            IF ContryRegion.GET(LocationInfo."Country/Region Code") THEN
                LocationCountry := ContryRegion.Name;
        END;

        Name := STRSUBSTNO('Order No. %1.pdf', recPurchaseOrderHeader."No.");
        ToFile := Name;
        // FileName := TEMPORARYPATH + ToFile;
        Tempblob.CreateOutStream(OutStreamValue, TextEncoding::UTF8);
        ReportSelection.RESET;
        ReportSelection.SETRANGE(Usage, ReportSelection.Usage::"P.Order");
        ReportSelection.SETFILTER("Report ID", '<>0');
        IF ReportSelection.FINDFIRST THEN BEGIN
            recPurchaseOrderHeader.SETRANGE("No.", recPurchaseOrderHeader."No.");
            IF recPurchaseOrderHeader.FINDFIRST THEN begin
                RecRef.GetTable(recPurchaseOrderHeader);
                REPORT.SAVEAS(ReportSelection."Report ID", '', ReportFormat::Pdf, OutStreamValue, RecRef);
            end;
        END;

        //ToFile := DownloadToClientFileName(FileName, ToFile);

        IF PurchasesPayablesSetup.GET() THEN
            FromMailID := PurchasesPayablesSetup."Email Id";

        txtReceipient := '';
        //CreateMessage(CompanyInfo.Name, FromMailID, '', 'Purchase Order' + ' ' + recPurchaseOrderHeader."No.", '', TRUE);
        ContactBusinessRelation.RESET;
        ContactBusinessRelation.SETRANGE(ContactBusinessRelation."No.", recPurchaseOrderHeader."Buy-from Vendor No.");
        IF ContactBusinessRelation.FINDFIRST THEN BEGIN
            Contact.RESET;
            Contact.SETRANGE(Contact."Company No.", ContactBusinessRelation."Contact No.");
            IF Contact.FINDFIRST THEN
                REPEAT
                    IF (Contact."Mail To" <> FALSE) AND (Contact."Purchase Order" <> FALSE) THEN BEGIN
                        IF Contact."E-Mail" <> '' THEN BEGIN
                            AddRecipients.Add(Contact."E-Mail");
                            txtReceipient := txtReceipient + Contact."E-Mail";
                        END;
                    END ELSE
                        IF (Contact."Mail CC" <> FALSE) AND (Contact."Purchase Order" <> FALSE) THEN BEGIN
                            IF Contact."E-Mail" <> '' THEN BEGIN
                                AddCC.Add(Contact."E-Mail");
                                txtReceipient := txtReceipient + Contact."E-Mail";
                            END;
                        END;
                    AddBCC.Add('PO@silk-safari.com');
                UNTIL Contact.NEXT = 0;
        END;

        IF txtReceipient <> '' THEN BEGIN
            BodyText := ('<html>');
            BodyText += ('<head>');
            BodyText += ('<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
            BodyText += ('<title>Purchase Order</title>');
            BodyText += ('</head>');
            BodyText += ('<body>');
            BodyText += ('<p>');
            BodyText += ('Dear Sir/Madam,');
            BodyText += ('</p>');
            BodyText += ('<p>');
            BodyText += (Text001);
            BodyText += ('</p>');
            BodyText += ('<p>');
            BodyText += (Text002);
            BodyText += ('<br>');
            BodyText += ('<B>' + CompanyInfo.Name + '</B>');
            BodyText += ('<br>');
            BodyText += (LocationAdd1 + ' ' + LocationAdd2);
            BodyText += ('<br>');
            BodyText += (LocationCity + ', ' + LocationInfo.County + ' ' + LocationPostCode + ' ' + LocationCountry);
            BodyText += ('<br>');
            BodyText += ('</p>');
            BodyText += ('<br>');
            BodyText += ('<P>This is a system-generated e-mail.</P>');
            BodyText += ('<br>');
            BodyText += ('</body>');
            BodyText += ('</html>');
            EmailMessage.Create(AddRecipients, 'Purchase Order' + ' ' + recPurchaseOrderHeader."No.", BodyText, true, AddCC, AddBCC);
            Tempblob.CreateInStream(InStreamValue, TextEncoding::UTF8);
            EmailMessage.AddAttachment(ToFile, '.pdf', InStreamValue);
            Email.Send(EmailMessage);
            //Send();

            MailDetail.FINDLAST;
            MailDetail.INIT;
            MailDetail."Entry No." := MailDetail."Entry No." + 1;
            MailDetail.Type := 'Purchase Order';
            MailDetail."Source No." := recPurchaseOrderHeader."No.";
            MailDetail."Date Time" := CURRENTDATETIME;
            MailDetail.INSERT;

            MESSAGE('E-mail Sent for Purchase Order No. %1', recPurchaseOrderHeader."No.");
        END;
        //FILE.ERASE(FileName);
    end;


    procedure SendVendorLedgerAsPDF(recVendor: Record Vendor)
    var
        CompanyInfo: Record "Company Information";
        ContryRegion: Record "Country/Region";
        UserSetup: Record "User Setup";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        MailDetail: Record "Mail Detail";
        ContactBusinessRelation: Record "Contact Business Relation";
        Contact: Record Contact;
        Name: Text[50];
        FileName: Text[250];
        ToFile: Text[250];
        FromMailID: Text[50];
        TOAddress: Text[250];
        CCAddress: Text[250];
        Text001: Label 'Please find enclosed a copy of your ledger.';
        Text002: Label 'Regards,';
        BCCAddress: Text[250];
        LocationAdd1: Text[100];
        LocationAdd2: Text[100];
        LocationCity: Text[50];
        LocationPostCode: Code[20];
        LocationState: Text[50];
        LocationCountry: Text[50];
    begin
        BodyText := '';
        Clear(AddBCC);
        Clear(AddCC);
        Clear(AddRecipients);
        Clear(Tempblob);
        Clear(RecRef);
        Clear(OutStreamValue);
        Clear(InStreamValue);

        CompanyInfo.GET;
        LocationAdd1 := CompanyInfo.Address;
        LocationAdd2 := CompanyInfo."Address 2";
        LocationCity := CompanyInfo.City;
        LocationPostCode := CompanyInfo."Post Code";
        IF ContryRegion.GET(CompanyInfo."Country/Region Code") THEN
            LocationCountry := ContryRegion.Name;

        Name := STRSUBSTNO('Vendor No. %1.pdf', recVendor."No.");
        ToFile := Name;
        // FileName := TEMPORARYPATH + ToFile;
        Tempblob.CreateOutStream(OutStreamValue, TextEncoding::UTF8);
        recVendor.SETRANGE("No.", recVendor."No.");
        IF recVendor.FINDFIRST THEN begin
            RecRef.GetTable(recVendor);
            //REPORT.SAVEASPDF(REPORT::"Vendor - Detail Trial Balance", FileName, recVendor);
            Report.SaveAs(REPORT::"Vendor - Detail Trial Balance", '', ReportFormat::Pdf, OutStreamValue, RecRef);
        end;
        //ToFile := DownloadToClientFileName(FileName, ToFile);
        Tempblob.CreateInStream(InStreamValue, TextEncoding::UTF8);
        IF PurchasesPayablesSetup.GET() THEN
            FromMailID := PurchasesPayablesSetup."Email Id";


        txtReceipient := '';
        //CreateMessage(CompanyInfo.Name, FromMailID, '', 'Vendor Ledger' + ' ' + recVendor."No.", '', TRUE);
        ContactBusinessRelation.RESET;
        ContactBusinessRelation.SETRANGE(ContactBusinessRelation."No.", recVendor."No.");
        IF ContactBusinessRelation.FINDFIRST THEN BEGIN
            Contact.RESET;
            Contact.SETRANGE(Contact."Company No.", ContactBusinessRelation."Contact No.");
            IF Contact.FINDFIRST THEN
                REPEAT
                    IF (Contact."Mail To" <> FALSE) AND (Contact."Vendor Ledger" <> FALSE) THEN BEGIN
                        IF Contact."E-Mail" <> '' THEN BEGIN
                            AddRecipients.Add(Contact."E-Mail");
                            txtReceipient := txtReceipient + Contact."E-Mail";
                        END;
                    END ELSE
                        IF (Contact."Mail CC" <> FALSE) AND (Contact."Vendor Ledger" <> FALSE) THEN BEGIN
                            IF Contact."E-Mail" <> '' THEN BEGIN
                                AddCC.Add(Contact."E-Mail");
                                txtReceipient := txtReceipient + Contact."E-Mail";
                            END;
                        END;
                    AddBCC.Add('AP@silk-safari.com');
                UNTIL Contact.NEXT = 0;
        END;
        IF txtReceipient <> '' THEN BEGIN
            BodyText := ('<html>');
            BodyText += ('<head>');
            BodyText += ('<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
            BodyText += ('<title>Vendor Ledger</title>');
            BodyText += ('</head>');
            BodyText += ('<body>');
            BodyText += ('<p>');
            BodyText += ('Dear Sir/Madam,');
            BodyText += ('</p>');
            BodyText += ('<p>');
            BodyText += (Text001);
            BodyText += ('</p>');
            BodyText += ('<p>');
            BodyText += (Text002);
            BodyText += ('<br>');
            BodyText += ('<B>' + CompanyInfo.Name + '</B>');
            BodyText += ('<br>');
            BodyText += (LocationAdd1 + ' ' + LocationAdd2);
            BodyText += ('<br>');
            BodyText += (LocationCity + ', ' + LocationCity + ' ' + LocationPostCode + ' ' + LocationCountry);
            BodyText += ('<br>');
            BodyText += ('</p>');
            BodyText += ('<br>');
            BodyText += ('<P>This is a system-generated e-mail.</P>');
            BodyText += ('<br>');
            BodyText += ('</body>');
            BodyText += ('</html>');
            EmailMessage.Create(AddRecipients, 'Vendor Ledger' + ' ' + recVendor."No.", BodyText, TRUE, AddCC, AddBCC);
            EmailMessage.AddAttachment(ToFile, '.pdf', InStreamValue);
            Email.Send(EmailMessage);

            MailDetail.FINDLAST;
            MailDetail.INIT;
            MailDetail."Entry No." := MailDetail."Entry No." + 1;
            MailDetail.Type := 'Vendor Ledger';
            MailDetail."Source No." := recVendor."No.";
            MailDetail."Date Time" := CURRENTDATETIME;
            MailDetail.INSERT;

            MESSAGE('E-mail Sent for Vendor No. %1', recVendor."No.");
        END;
        //FILE.ERASE(FileName);
    end;


    procedure SendShipmentAsPDF(var recSalesShipmentHeader: Record "Sales Shipment Header")
    var
        CompanyInfo: Record "Company Information";
        LocationInfo: Record Location;
        ContryRegion: Record "Country/Region";
        UserSetup: Record "User Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        ContactBusinessRelation: Record "Contact Business Relation";
        Contact: Record Contact;
        MailDetail: Record "Mail Detail";
        ReportSelection: Record "Report Selections";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        Name: Text[50];
        FileName: Text[250];
        ToFile: Text[250];
        FromMailID: Text[50];
        TOAddress: Text[250];
        CCAddress: Text[250];
        Text001: Label 'Please find attached a copy of the shipment notification.  The tracking number ';
        Text002: Label 'Regards,';
        BCCAddress: Text[250];
        LocationAdd1: Text[100];
        LocationAdd2: Text[100];
        LocationCity: Text[50];
        LocationPostCode: Code[20];
        LocationCountry: Text[50];
        Test003: Label ' in on the top right side of the attachment.';
        Contact1: Record contact;
        RecipientsContact1: Text;
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        BodyText := '';
        Clear(AddBCC);
        Clear(AddCC);
        Clear(AddRecipients);
        Clear(Tempblob);
        Clear(RecRef);
        Clear(OutStreamValue);
        Clear(InStreamValue);

        CompanyInfo.GET;
        IF LocationInfo.GET(recSalesShipmentHeader."Location Code") THEN BEGIN
            LocationAdd1 := LocationInfo.Address;
            LocationAdd2 := LocationInfo."Address 2";
            LocationCity := LocationInfo.City;
            LocationPostCode := LocationInfo."Post Code";
            IF ContryRegion.GET(LocationInfo."Country/Region Code") THEN
                LocationCountry := ContryRegion.Name;
            //>>02-12-2-17
            IF LocationInfo."E-Mail" <> '' THEN
                BCCAddress := LocationInfo."E-Mail"
            ELSE
                BCCAddress := 'SH@silk-safari.com';
            //<<02-12-2017
        END;

        Name := STRSUBSTNO('Shipment No. %1.pdf', recSalesShipmentHeader."No.");
        ToFile := Name;
        Tempblob.CreateOutStream(OutStreamValue, TextEncoding::UTF8);
        ReportSelection.RESET;
        ReportSelection.SETRANGE(Usage, ReportSelection.Usage::"S.Shipment");
        ReportSelection.SETFILTER("Report ID", '<>0');
        IF ReportSelection.FINDFIRST THEN BEGIN
            SalesShipmentHeader.Reset();
            SalesShipmentHeader.SETRANGE("No.", recSalesShipmentHeader."No.");
            SalesShipmentHeader.FindFirst();
            RecRef.GetTable(SalesShipmentHeader);
            REPORT.SAVEAS(ReportSelection."Report ID", '', ReportFormat::Pdf, OutStreamValue, RecRef);
        END;

        IF UserSetup.GET(USERID) THEN
            FromMailID := UserSetup."E-Mail";

        ///Meghna BEGIN
        RecipientsContact1 := '';
        Contact1.RESET;
        Contact1.SETRANGE("No.", recSalesShipmentHeader."PI Contact");
        IF Contact1.FINDFIRST THEN BEGIN
            IF Contact1."E-Mail" <> '' THEN
                RecipientsContact1 := Contact1."E-Mail";

        END;
        ///Meghna END
        txtReceipient := '';

        ContactBusinessRelation.RESET;
        ContactBusinessRelation.SETRANGE(ContactBusinessRelation."No.", recSalesShipmentHeader."Sell-to Customer No.");
        IF ContactBusinessRelation.FINDFIRST THEN BEGIN
            Contact.RESET;
            Contact.SETRANGE(Contact."Company No.", ContactBusinessRelation."Contact No.");
            IF Contact.FINDFIRST THEN
                REPEAT
                    IF (Contact."Mail To" <> FALSE) AND (Contact."Sales Shipment" <> FALSE) THEN BEGIN
                        IF Contact."E-Mail" <> '' THEN BEGIN
                            ///Meghna BEGIN
                            IF RecipientsContact1 <> '' THEN BEGIN
                                AddRecipients.Add(Contact."E-Mail");
                                AddRecipients.Add(RecipientsContact1);
                            END ELSE
                                AddRecipients.Add(Contact."E-Mail");
                            txtReceipient := txtReceipient + Contact."E-Mail";
                        END;
                    END ELSE
                        IF (Contact."Mail CC" <> FALSE) AND (Contact."Sales Shipment" <> FALSE) THEN BEGIN
                            IF Contact."E-Mail" <> '' THEN BEGIN
                                AddCC.Add(Contact."E-Mail");
                                txtReceipient := txtReceipient + Contact."E-Mail";
                            END;
                        END;
                UNTIL Contact.NEXT = 0;
        END;

        ///Posh Code BEGIN
        IF txtReceipient = '' THEN BEGIN
            Contact.RESET;
            Contact.SETRANGE("No.", recSalesShipmentHeader."Bill-to Contact No.");
            IF Contact.FINDFIRST THEN BEGIN
                IF Contact."E-Mail" <> '' THEN BEGIN
                    ///Meghna BEGIN
                    IF RecipientsContact1 <> '' THEN BEGIN
                        AddRecipients.Add(RecipientsContact1);
                        AddRecipients.Add(Contact."E-Mail");
                    END ELSE
                        AddRecipients.Add(Contact."E-Mail");
                    txtReceipient := txtReceipient + Contact."E-Mail";
                END;
            END;
        END;
        ///Posh Code END

        AddBCC.Add(BCCAddress); //02-12-2017
        txtReceipient := txtReceipient + BCCAddress; //02-12-2017

        IF SalespersonPurchaser.GET(recSalesShipmentHeader."Salesperson Code") THEN BEGIN
            IF SalespersonPurchaser."E-Mail" <> '' THEN BEGIN
                IF SalespersonPurchaser."Sales Shipment" THEN BEGIN
                    IF SalespersonPurchaser."Mail To" THEN
                        AddRecipients.Add(SalespersonPurchaser."E-Mail");
                    IF SalespersonPurchaser."Mail CC" THEN
                        AddCC.Add(SalespersonPurchaser."E-Mail");
                    IF SalespersonPurchaser."Mail BCC" THEN
                        AddBCC.Add(SalespersonPurchaser."E-Mail");
                END;
            END;
        END;

        IF txtReceipient <> '' THEN BEGIN

            BodyText := ('<html>');
            BodyText += ('<head>');
            BodyText += ('<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
            BodyText += ('<title>Sales Shipment</title>');
            BodyText += ('</head>');
            BodyText += ('<body>');
            BodyText += ('<p>');
            BodyText += ('Dear Sir/Madam,');
            BodyText += ('</p>');
            BodyText += ('<p>');
            BodyText += (Text001 + recSalesShipmentHeader."Tracking No." + Test003);
            BodyText += ('</p>');
            BodyText += ('<p>');
            BodyText += (Text002);
            BodyText += ('<br>');
            BodyText += ('<B>' + CompanyInfo.Name + '</B>');
            BodyText += ('<br>');
            BodyText += (LocationAdd1 + ' ' + LocationAdd2);
            BodyText += ('<br>');
            BodyText += (LocationCity + ', ' + LocationInfo.County + ' ' + LocationPostCode + ' ' + LocationCountry);
            BodyText += ('<br>');
            BodyText += ('</p>');
            BodyText += ('<br>');
            BodyText += ('<P>This is a system-generated e-mail.</P>');
            BodyText += ('<br>');
            BodyText += ('</body>');
            BodyText += ('</html>');
            EmailMessage.Create(AddRecipients, 'Shipment' + ' ' + recSalesShipmentHeader."No.", BodyText, true, AddCC, AddBCC);
            Tempblob.CreateInStream(InStreamValue, TextEncoding::UTF8);
            EmailMessage.AddAttachment(ToFile, '.pdf', InStreamValue);
            Email.Send(EmailMessage);

            MailDetail.FINDLAST;
            MailDetail.INIT;
            MailDetail."Entry No." := MailDetail."Entry No." + 1;
            MailDetail.Type := 'Sales Shipment';
            MailDetail."Source No." := recSalesShipmentHeader."No.";
            MailDetail."Date Time" := CURRENTDATETIME;
            MailDetail.INSERT;

        END;
        //FILE.ERASE(FileName);
    end;


    procedure SendCustomerStatmentAsPDF(recCustomer: Record Customer)
    var
        CompanyInfo: Record "Company Information";
        ContryRegion: Record "Country/Region";
        UserSetup: Record "User Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        MailDetail: Record "Mail Detail";
        ContactBusinessRelation: Record "Contact Business Relation";
        Contact: Record Contact;
        rptCustomerStatement: Report "Customer Statement1";
        Name: Text[50];
        FileName: Text[250];
        ToFile: Text[250];
        FromMailID: Text[50];
        TOAddress: Text[250];
        CCAddress: Text[250];
        Text001: Label 'Please find enclosed a copy of your statement.';
        Text002: Label 'Regards,';
        BCCAddress: Text[250];
        LocationAdd1: Text[100];
        LocationAdd2: Text[100];
        LocationCity: Text[50];
        LocationPostCode: Code[20];
        LocationState: Text[50];
        LocationCountry: Text[50];
        BCCMail: Text[50];
    begin
        //This function e-mails the customer's statement
        BodyText := '';
        Clear(AddBCC);
        Clear(AddCC);
        Clear(AddRecipients);
        Clear(Tempblob);
        Clear(RecRef);
        Clear(OutStreamValue);
        Clear(InStreamValue);

        CompanyInfo.GET;
        UserSetup.GET(USERID);
        SalesReceivablesSetup.GET;
        IF UserSetup."E-Mail" <> '' THEN
            FromMailID := UserSetup."E-Mail"
        ELSE
            IF SalesReceivablesSetup."Email Id" <> '' THEN
                FromMailID := SalesReceivablesSetup."Email Id"
            ELSE
                ERROR('Please check your email id on user setup or sales & receivable setup email id');

        LocationAdd1 := CompanyInfo.Address;
        LocationAdd2 := CompanyInfo."Address 2";
        LocationCity := CompanyInfo.City;
        LocationPostCode := CompanyInfo."Post Code";

        Name := STRSUBSTNO('Customer No. %1.pdf', recCustomer."No.");
        ToFile := Name;
        // FileName := TEMPORARYPATH + ToFile;

        recCustomer.SETRANGE("No.", recCustomer."No.");
        recCustomer.SETFILTER("Date Filter", '%1..%2', 20100101D, WORKDATE);
        IF recCustomer.FINDFIRST THEN BEGIN
            rptCustomerStatement.FilterDate(20100101D, WORKDATE);
            rptCustomerStatement.FilterCustomer(recCustomer."No.");
            rptCustomerStatement.FNAgingMethod(1);
            rptCustomerStatement.FNPeriodCalculation;
            rptCustomerStatement.ReportFilter(0, FALSE, TRUE, 0, TRUE);
            rptCustomerStatement.SETTABLEVIEW(recCustomer);
            //rptCustomerStatement.SAVEASPDF(FileName);
            RecRef.GetTable(recCustomer);
            TempBlob.CreateOutStream(OutStreamValue, TEXTENCODING::UTF8);
            rptCustomerStatement.SaveAs('', ReportFormat::Pdf, OutStreamValue, recref);
            TempBlob.CreateInStream(InStreamValue);
        END;
        //ToFile := DownloadToClientFileName(FileName, ToFile);

        //Tix issue Id - 73
        if not Tempblob.HasValue() then
            exit;

        txtReceipient := '';
        ContactBusinessRelation.RESET;
        ContactBusinessRelation.SETRANGE(ContactBusinessRelation."No.", recCustomer."No.");
        IF ContactBusinessRelation.FINDFIRST THEN BEGIN
            Contact.RESET;
            Contact.SETRANGE(Contact."Company No.", ContactBusinessRelation."Contact No.");
            IF Contact.FINDFIRST THEN
                REPEAT
                    IF (Contact."Mail To" <> FALSE) AND (Contact."Customer Ledger" <> FALSE) THEN BEGIN
                        IF Contact."E-Mail" <> '' THEN BEGIN
                            //AddRecipients(Contact."E-Mail");
                            AddRecipients.Add(Contact."E-Mail");
                            txtReceipient := txtReceipient + Contact."E-Mail";
                        END;
                    END ELSE
                        IF (Contact."Mail CC" <> FALSE) AND (Contact."Customer Ledger" <> FALSE) THEN BEGIN
                            IF Contact."E-Mail" <> '' THEN BEGIN
                                //AddCC(Contact."E-Mail");
                                AddCC.Add(Contact."E-Mail");
                                txtReceipient := txtReceipient + Contact."E-Mail";
                            END;
                        END;
                UNTIL Contact.NEXT = 0;
        END;
        //Create(CompanyInfo.Name, FromMailID, '', 'Statement' + ' ' + recCustomer."No.", '', TRUE);
        //BCCMail:='AR@silk-crafts.com';
        BCCMail := 'docs@silk-crafts.com';
        BCCMail := 'saurav@silk-crafts.com';
        //txtReceipient :=txtReceipient+BCCMail;//03-12-2018
        AddBCC.Add(BCCMail);
        IF txtReceipient <> '' THEN BEGIN
            // IF EXISTS(FileName) THEN BEGIN

            BodyText := ('<html>');
            BodyText += ('<head>');
            BodyText += ('<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
            BodyText += ('<title>Customer Ledger</title>');
            BodyText += ('</head>');
            BodyText += ('<body>');
            BodyText += ('<p>');
            BodyText += ('Dear Sir/Madam,');
            BodyText += ('</p>');
            BodyText += ('<p>');
            BodyText += (Text001);
            BodyText += ('</p>');
            BodyText += ('<p>');
            BodyText += ('Your account is past due.  In case you are missing an invoice, please contact our Accounts Department for a copy.');
            BodyText += ('If you have already paid, please ignore this message.');
            BodyText += ('<br>');
            BodyText += (Text002);
            BodyText += ('<br>');
            BodyText += ('<B>' + CompanyInfo.Name + '</B>');
            BodyText += ('<br>');
            BodyText += (LocationAdd1 + ' ' + LocationAdd2);
            BodyText += ('<br>');
            //BodyText +=(LocationCity + ', ' +LocationCity +' '+ LocationPostCode + ' ' +LocationCountry);
            BodyText += (LocationCity + ', ' + LocationCity + ' ' + LocationPostCode);
            BodyText += ('<br>');
            BodyText += ('</p>');
            BodyText += ('<br>');
            BodyText += ('<P>This is a system-generated e-mail.</P>');
            BodyText += ('<br>');
            BodyText += ('</body>');
            BodyText += ('</html>');
            EmailMessage.Create(AddRecipients, 'Statement' + ' ' + recCustomer."No.", BodyText, TRUE, AddCC, AddBCC);

            if Tempblob.HasValue() then
                EmailMessage.AddAttachment(ToFile, '.pdf', InStreamValue);

            Email.Send(EmailMessage);
            //Send();

            MailDetail.FINDLAST;
            MailDetail.INIT;
            MailDetail."Entry No." := MailDetail."Entry No." + 1;
            MailDetail.Type := 'Customer Statment';
            MailDetail."Source No." := recCustomer."No.";
            MailDetail."Date Time" := CURRENTDATETIME;
            MailDetail.INSERT;
            //FILE.ERASE(FileName);
            //MESSAGE('E-mail Sent for Customer No. %1',recCustomer."No.");
            //END;
        END;
    end;


    procedure SendMISAsPDF()
    var
        Name: Text[50];
        FileName: Text[250];
        ToFile: Text[250];
        CLERec: Record "Cust. Ledger Entry";
    begin
        BodyText := '';
        Clear(AddBCC);
        Clear(AddCC);
        Clear(AddRecipients);
        Clear(Tempblob);
        Clear(RecRef);
        Clear(OutStreamValue);
        Clear(InStreamValue);
        Name := 'MIS.xlsx';
        ToFile := Name;

        CLERec.Reset();
        CLERec.FindSet();
        Tempblob.CreateOutStream(OutStreamValue, TextEncoding::UTF8);
        RecRef.GetTable(CLERec);
        REPORT.SAVEAS(50045, '', ReportFormat::Excel, OutStreamValue, RecRef);
        AddRecipients.Add('rs@silk-crafts.com');
        AddRecipients.Add('rs@poshtextiles.com');
        AddCC.Add('mukesh@silk-crafts.com');
        AddCC.Add('sejal@silk-crafts.com');
        AddCC.Add('sarika@poshtextiles.com');
        AddBCC.add('saurav@silk-crafts.com');

        Tempblob.CreateInStream(InStreamValue);

        BodyText := ('<html>');
        BodyText += ('<head>');
        BodyText += ('<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
        BodyText += ('<title>SC Purchase and Sales Report</title>');
        BodyText += ('</head>');
        BodyText += ('<body>');
        BodyText += ('<p> Dear Sir/Madam,</p>');
        BodyText += ('<p>Please find the attached MIS Report.');
        GetTotalPayment(BodyText);
        BodyText += ('<br>');
        BodyText += ('<br>Regards,</p>');
        BodyText += ('<p><br>Silk Crafts Accounts Team</br></p>');
        BodyText += ('</body>');
        BodyText += ('</html>');
        EmailMessage.Create(AddRecipients, 'MIS (SC)', BodyText, true, AddCC, AddBCC);
        if Tempblob.HasValue() then
            EmailMessage.AddAttachment(ToFile, '.xlsx', InStreamValue);
        Email.Send(EmailMessage);
        //Email.OpenInEditor(EmailMessage);
    end;

    procedure SendMISAsPDFPOSH()
    var
        Name: Text[50];
        FileName: Text[250];
        ToFile: Text[250];
        CLERec: Record "Cust. Ledger Entry";
    begin
        BodyText := '';
        Clear(AddBCC);
        Clear(AddCC);
        Clear(AddRecipients);
        Clear(Tempblob);
        Clear(RecRef);
        Clear(OutStreamValue);
        Clear(InStreamValue);
        //Name :='MIS.pdf';
        Name := 'MIS (PT).xlsx';
        ToFile := Name;
        CLERec.Reset();
        CLERec.FindSet();
        Tempblob.CreateOutStream(OutStreamValue, TextEncoding::UTF8);
        RecRef.GetTable(CLERec);
        REPORT.SAVEAS(50045, '', ReportFormat::Excel, OutStreamValue, RecRef);

        AddRecipients.Add('cs@poshtextiles.com');
        AddCC.Add('Sarika@poshtextiles.com');
        AddBCC.add('saurav@silk-crafts.com');

        if Tempblob.HasValue() then begin
            Tempblob.CreateInStream(InStreamValue);

            BodyText := ('<html>');
            BodyText += ('<head>');
            BodyText += ('<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
            BodyText += ('<title>SC Purchase and Sales Report</title>');
            BodyText += ('</head>');
            BodyText += ('<body>');
            BodyText += ('<p> Dear Sir/Madam,</p>');
            BodyText += ('<p>Please find the attached MIS Report.');
            GetTotalPayment(BodyText);
            BodyText += ('<br>');
            BodyText += ('<br>Regards,</p>');
            BodyText += ('<p><br>Posh Textiles Accounts Team</br></p>');
            BodyText += ('</body>');
            BodyText += ('</html>');
            EmailMessage.Create(AddRecipients, 'Posh Textiles', BodyText, true, AddCC, AddBCC);
            EmailMessage.AddAttachment(ToFile, '.xlsx', InStreamValue);
            Email.Send(EmailMessage);
        END;
    end;

    procedure GetTotalPayment(var BodyText: Text)
    var
        CustomerLedger: Record "Cust. Ledger Entry";
        Cust: Record Customer;
        TotalPaymentRcptAmount: Decimal;
        VendorLedger: Record "Vendor Ledger Entry";
        TotalPaymentPaidAmount: Decimal;
        Vend: Record Vendor;
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        PurchaseHedader: Record "Purchase Header";
        PurchaseInvoiceHeader: Record "Purch. Inv. Header";
        TotalAmt: Decimal;
    begin
        TotalPaymentRcptAmount := 0;
        TotalPaymentPaidAmount := 0;

        CustomerLedger.Reset();
        CustomerLedger.SetCurrentKey("Document Type", "Posting Date");
        CustomerLedger.SetRange("Document Type", CustomerLedger."Document Type"::Payment);
        CustomerLedger.SetRange("Posting Date", WorkDate());
        if CustomerLedger.FindSet() then
            repeat
                CustomerLedger.CalcFields("Amount (LCY)");
                TotalPaymentRcptAmount += CustomerLedger."Amount (LCY)";
            until CustomerLedger.Next() = 0;

        if TotalPaymentRcptAmount <> 0 then begin
            BodyText += ('<br>');
            BodyText += ('<P>Below are summary for your reference.</P>');
            BodyText += ('<br>');
            BodyText += ('<H2>Payment Received: ' + Format(ABS(TotalPaymentRcptAmount)) + '</H2>');

            if CustomerLedger.FindSet() then begin
                BodyText += ('<table border="1">');
                BodyText += ('<tr><th>Customer</th><th>External Document No.</th><th align="right">Amount</th>');
                repeat
                    CustomerLedger.CalcFields("Amount (LCY)");
                    Cust.Get(CustomerLedger."Customer No.");
                    BodyText += ('<tr><td>' + Cust.Name + '</td><td>' + CustomerLedger."External Document No." + '</td><td align="right">' + Format(ABS(CustomerLedger."Amount (LCY)")) + '</td>');
                until CustomerLedger.Next() = 0;
                BodyText += ('<tr><td>' + '<b>Total</b>' + '</td><td>' + ' ' + '</td><td align="right"><b>' + Format(ABS(TotalPaymentRcptAmount)) + '</b></td>');
                BodyText += ('</table>');
            end;
        end;

        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Order Date", WorkDate());
        SalesHeader.SetAutoCalcFields("Amount Including VAT");
        if SalesHeader.FindSet() then begin
            TotalAmt := 0;
            BodyText += ('<br>');
            BodyText += ('<br>');
            BodyText += ('<H2>Sales Order Details: ');
            BodyText += ('<br>');
            BodyText += ('<table border="1">');
            BodyText += ('<tr><th>Customer</th><th>Order No.</th><th align="right">Amount</th>');
            repeat
                BodyText += ('<tr><td>' + SalesHeader."Sell-to Customer Name" + '</td><td>' + SalesHeader."No." + '</td><td align="right">' + Format(SalesHeader."Amount Including VAT") + '</td>');
                TotalAmt += SalesHeader."Amount Including VAT";
            until SalesHeader.Next() = 0;
            BodyText += ('<tr><td>' + '<b>Total</b>' + '</td><td>' + ' ' + '</td><td align="right"><b>' + Format(TotalAmt) + '</b></td>');
            BodyText += ('</table>');
        end;

        SalesInvoiceHeader.Reset();
        SalesInvoiceHeader.SetRange("Posting Date", WorkDate());
        SalesInvoiceHeader.SetAutoCalcFields("Amount Including VAT");
        if SalesInvoiceHeader.FindSet() then begin
            TotalAmt := 0;
            BodyText += ('<br>');
            BodyText += ('<br>');
            BodyText += ('<H2>Sales Invoice Details: ');
            BodyText += ('<br>');
            BodyText += ('<table border="1">');
            BodyText += ('<tr><th>Customer</th><th>Order No.</th><th align="right">Amount</th>');
            repeat
                BodyText += ('<tr><td>' + SalesInvoiceHeader."Sell-to Customer Name" + '</td><td>' + SalesInvoiceHeader."No." + '</td><td align="right">' + Format(SalesInvoiceHeader."Amount Including VAT") + '</td>');
                TotalAmt += SalesInvoiceHeader."Amount Including VAT";
            until SalesInvoiceHeader.Next() = 0;
            BodyText += ('<tr><td>' + '<b>Total</b>' + '</td><td>' + ' ' + '</td><td align="right"><b>' + Format(TotalAmt) + '</b></td>');
            BodyText += ('</table>');
        end;

        VendorLedger.Reset();
        VendorLedger.SetCurrentKey("Document Type", "Posting Date");
        VendorLedger.SetRange("Document Type", VendorLedger."Document Type"::Payment);
        VendorLedger.SetRange("Posting Date", WorkDate());
        if VendorLedger.FindSet() then
            repeat
                VendorLedger.CalcFields("Amount (LCY)");
                TotalPaymentPaidAmount += VendorLedger."Amount (LCY)";
            until VendorLedger.Next() = 0;

        if TotalPaymentPaidAmount <> 0 then begin
            BodyText += ('<br>');
            BodyText += ('<br>');
            BodyText += ('<br>');
            BodyText += ('<H2>Vendor Payment: ' + Format(TotalPaymentPaidAmount)) + '</H2>';

            if VendorLedger.FindSet() then begin
                BodyText += ('<table border="1">');
                BodyText += ('<tr><th>Vendor</th><th>External Document No.</th><th align="right">Amount</th>');
                repeat
                    VendorLedger.CalcFields("Amount (LCY)");
                    Vend.get(VendorLedger."Vendor No.");
                    BodyText += ('<tr><td>' + Vend.Name + '</td><td>' + VendorLedger."External Document No." + '</td><td align="right">' + Format(VendorLedger."Amount (LCY)") + '</td>');
                until VendorLedger.Next() = 0;
                BodyText += ('<tr><td>' + '<b>Total</b>' + '</td><td>' + ' ' + '</td><td align="right"><b>' + Format(TotalPaymentPaidAmount) + '</b></td>');
                BodyText += ('</table>');
            end;
        end;

        PurchaseHedader.Reset();
        PurchaseHedader.SetRange("Document Type", PurchaseHedader."Document Type"::Order);
        PurchaseHedader.SetRange("Order Date", WorkDate());
        PurchaseHedader.SetAutoCalcFields("Amount Including VAT");
        if PurchaseHedader.FindSet() then begin
            TotalAmt := 0;
            BodyText += ('<br>');
            BodyText += ('<br>');
            BodyText += ('<H2>Purchase Order Details: ');
            BodyText += ('<br>');
            BodyText += ('<table border="1">');
            BodyText += ('<tr><th>Vendor</th><th>Order No.</th><th align="right">Amount</th>');
            repeat
                BodyText += ('<tr><td>' + PurchaseHedader."Buy-from Vendor Name" + '</td><td>' + PurchaseHedader."No." + '</td><td align="right">' + Format(PurchaseHedader."Amount Including VAT") + '</td>');
                TotalAmt += PurchaseHedader."Amount Including VAT";
            until PurchaseHedader.Next() = 0;
            BodyText += ('<tr><td>' + '<b>Total</b>' + '</td><td>' + ' ' + '</td><td align="right"><b>' + Format(TotalAmt) + '</b></td>');
            BodyText += ('</table>');
        end;

        PurchaseInvoiceHeader.Reset();
        PurchaseInvoiceHeader.SetRange("Posting Date", WorkDate());
        PurchaseInvoiceHeader.SetAutoCalcFields("Amount Including VAT");
        if PurchaseInvoiceHeader.FindSet() then begin
            TotalAmt := 0;
            BodyText += ('<br>');
            BodyText += ('<br>');
            BodyText += ('<H2>Purchase Invoice Details: ');
            BodyText += ('<br>');
            BodyText += ('<table border="1">');
            BodyText += ('<tr><th>Vendor</th><th>Invoice No.</th><th align="right">Amount</th>');
            repeat
                BodyText += ('<tr><td>' + PurchaseInvoiceHeader."Buy-from Vendor Name" + '</td><td>' + PurchaseInvoiceHeader."No." + '</td><td align="right">' + Format(PurchaseInvoiceHeader."Amount Including VAT") + '</td>');
                TotalAmt += PurchaseInvoiceHeader."Amount Including VAT";
            until PurchaseInvoiceHeader.Next() = 0;
            BodyText += ('<tr><td>' + '<b>Total</b>' + '</td><td>' + ' ' + '</td><td align="right"><b>' + Format(TotalAmt) + '</b></td>');
            BodyText += ('</table>');
        end;
    end;

}
