codeunit 50207 Mail_Ext
{
    Var
        SubjectText: Text;
        BodyText: Text;
        RecRef: RecordRef;
        OutStreamValue: OutStream;
        InStreamValue: InStream;
        Tempblob: Codeunit "Temp Blob";
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        AddRecipients: List of [text];
        AddCC: List of [Text];
        AddBCC: List of [Text];

    procedure PurchOrderOutlook(PurchHdr: Record "Purchase Header"; AttachFilename: Text)
    var
        //OutlookMessageHelperInstance: DotNet IOutlookMessage;
        recPurchaseLine: Record "Purchase Line";
        I: Integer;
        recCompInfo: Record "Company Information";
        recUser: Record User;
        recVendor: Record Vendor;
        recContact: Record Contact;
        ContactName: Text[100];
        PurchaseHeader: Record "Purchase Header";
    begin
        BodyText := '';
        Clear(AddBCC);
        Clear(AddCC);
        Clear(AddRecipients);
        Clear(Tempblob);
        Clear(RecRef);
        Clear(OutStreamValue);
        Clear(InStreamValue);

        PurchaseHeader.Reset();
        PurchaseHeader.SetRange("Document Type", PurchHdr."Document Type");
        PurchaseHeader.SetRange("No.", PurchHdr."No.");
        if PurchaseHeader.FindFirst() then;
        Tempblob.CreateOutStream(OutStreamValue, TextEncoding::UTF8);
        RecRef.GetTable(PurchaseHeader);
        // //REPORT.SaveAsPdf(50010, FileName, Rec);
        Report.SaveAs(Report::"Purchase Order2", '', ReportFormat::Pdf, OutStreamValue, RecRef);
        // end;
        ContactName := '';
        IF recCompInfo.GET THEN;
        IF recVendor.GET(PurchHdr."Buy-from Vendor No.") THEN;
        IF PurchHdr."Buy-from Contact" <> '' THEN
            ContactName := 'Hi, ' + PurchHdr."Buy-from Contact" + ','
        ELSE
            IF PurchHdr."Buy-from Contact No." <> '' THEN BEGIN
                IF recContact.GET(PurchHdr."Buy-from Contact No.") THEN
                    ContactName := 'Hi, ' + recContact.Name + ',';
            END ELSE
                ContactName := 'M/S, ' + PurchHdr."Buy-from Vendor Name" + ',';

        I := 1;
        // Initialize;
        AddRecipients.Add(recVendor."Email CC");
        AddCC.Add(recVendor."Email CC");
        //OutlookMessageHelper.Recipients(recVendor."E-Mail");
        //OutlookMessageHelper.CarbonCopyRecipients(recVendor."Email CC");
        //OutlookMessageHelper.BlindCarbonCopyRecipients('');
        //OutlookMessageHelper.Subject := PurchHdr."No.";
        //OutlookMessageHelper.BodyFormat := 2;
        // OutlookMessageHelper.ShowNewMailDialogOnSend := TRUE;
        //OutlookMessageHelper.NewMailDialogIsModal := TRUE;
        BodyText := ('<html>');
        BodyText += ('<head>');
        BodyText += ('<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
        BodyText += ('<title>Order</title>');
        BodyText += ('</head>');
        BodyText += ('<body>');
        BodyText += ('<p>' + ContactName + '</p>');
        BodyText += ('Please find enclosed the PO for the following items and priority quantity and date required.<br>');
        BodyText += ('We request your immediate confirmation of the priority quantity and priority delivery date.');
        BodyText += ('<table style="solid black;border-collapse:collapse;">');
        BodyText += ('<tr style="color: #FF0000"><td colspan="7" style="text-align: center">PO Delivery Status</td></tr>');
        BodyText += ('<tr><td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px; color: #FF0000">PO#</td>');
        BodyText += ('<td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px; color: #FF0000">' + PurchHdr."No." + '</td>');
        BodyText += ('<td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px;"></td>');
        BodyText += ('<td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px;"></td>');
        BodyText += ('<td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px;"></td>');
        BodyText += ('<td colspan="2" style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px; text-align: right; color: #FF0000">Po Date : ' +
        FORMAT(PurchHdr."Order Date") + '</td></tr>');
        BodyText += ('<tr><th style="border:1px solid black;"> Sr. No. </th>');
        BodyText += ('<th style="border:1px solid black;"> Our Design </th>');
        BodyText += ('<th style="border:1px solid black;"> Your Design </th>');
        BodyText += ('<th style="border:1px solid black;"> Req. Date </th>');
        BodyText += ('<th style="border:1px solid black;"> Ord. Qty. </th>');
        BodyText += ('<th style="border:1px solid black;"> Priority Quantity </th>');
        BodyText += ('<th style="border:1px solid black;">Priority Date</th></tr>');
        recPurchaseLine.RESET;
        recPurchaseLine.SETRANGE(recPurchaseLine."Document Type", PurchHdr."Document Type");
        recPurchaseLine.SETRANGE(recPurchaseLine."Document No.", PurchHdr."No.");
        IF recPurchaseLine.FINDFIRST THEN
            REPEAT
                BodyText += ('<tr><td style="border:1px solid black;">' + FORMAT(I) + '</td>');
                BodyText += ('<td style="border:1px solid black;">' + recPurchaseLine.Description + '</td>');
                BodyText += ('<td align=right style="border:1px solid black;">' + recPurchaseLine."Vendor Item No." + '</td>');
                BodyText += ('<td style="border:1px solid black;">' + FORMAT(recPurchaseLine."Requested Receipt Date") + '</td>');
                BodyText += ('<td style="border:1px solid black;">' + FORMAT(recPurchaseLine.Quantity) + '</td>');
                IF recPurchaseLine."Priority Qty" = 0 THEN
                    BodyText += ('<td style="border:1px solid black;"></td>')
                ELSE
                    BodyText += ('<td style="border:1px solid black;">' + FORMAT(recPurchaseLine."Priority Qty") + '</td>');
                BodyText += ('<td style="border:1px solid black;">' + FORMAT(recPurchaseLine."Priority Date") + '</td></tr>');
                I += 1;
            UNTIL recPurchaseLine.NEXT = 0;

        BodyText += ('</table>');
        BodyText += ('<br>');
        BodyText += ('<b>Important Note:- All Goods must be rolled as face side in and please put face side sticker.</b>');
        BodyText += ('<p>Thank you.<br>');
        BodyText += ('<p>Regards,<br>');
        BodyText += ('<B>' + recCompInfo.Name + '</B>');
        recUser.RESET;
        recUser.SETRANGE(recUser."User Name", USERID);
        IF recUser.FINDFIRST THEN
            BodyText += ('<br>' + recUser."Full Name");
        BodyText += ('<br>' + recCompInfo.Address);
        BodyText += ('<br>' + recCompInfo.City + ', ' + recCompInfo.County + ' ' + recCompInfo."Post Code");
        BodyText += ('</body>');
        BodyText += ('</html>');

        EmailMessage.Create(AddRecipients, PurchHdr."No.", BodyText, true, AddCC, AddBCC);

        Tempblob.CreateInStream(InStreamValue, TextEncoding::UTF8);
        EmailMessage.AddAttachment(AttachFilename, '.pdf', instreamvalue);

        Email.OpenInEditor(EmailMessage);
        //AttachFile(AttachFilename);
        //Send;
    end;


    procedure SalesOrderOutlook(SalesHdr: Record "Sales Header"; AttachFilename: Text)
    var
        recSalesLine: Record "Sales Line";
        I: Integer;
        recCompInfo: Record "Company Information";
        recUser: Record User;
        recCustomer: Record Customer;
        recContact: Record Contact;
        ContactName: Text[100];
    begin
        SubjectText := '';
        BodyText := '';
        Clear(AddBCC);
        Clear(AddCC);
        Clear(AddRecipients);
        Clear(Tempblob);
        Clear(RecRef);
        Clear(OutStreamValue);
        Clear(InStreamValue);

        ContactName := '';
        IF recCompInfo.GET THEN;
        IF recCustomer.GET(SalesHdr."Bill-to Customer No.") THEN;
        IF SalesHdr."Bill-to Contact" <> '' THEN
            ContactName := 'Hi ' + SalesHdr."Bill-to Contact" + ','
        ELSE
            IF SalesHdr."Bill-to Contact No." <> '' THEN BEGIN
                IF recContact.GET(SalesHdr."Bill-to Contact No.") THEN
                    ContactName := 'Hi ' + recContact.Name + ',';
            END ELSE
                ContactName := SalesHdr."Bill-to Name" + ',';

        I := 1;
        AddRecipients.Add(recCustomer."E-Mail");
        AddCC.Add(recCustomer."Email CC");
        SubjectText := 'Order Confirmation for your PO#' + SalesHdr."External Document No.";
        BodyText := ('<html>');
        BodyText += ('<head>');
        BodyText += ('<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
        BodyText += ('<title>Order</title>');
        BodyText += ('</head>');
        BodyText += ('<body>');
        BodyText += ('<p>' + ContactName + '</p>');
        BodyText += ('Thanks for your order.<br>');
        BodyText += ('<table style="solid black;border-collapse:collapse;">');
        BodyText += ('<tr style="color: #FF0000"><td colspan="7" style="text-align: center">Delivery Status</td></tr>');
        BodyText += ('<tr><td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px; color: #FF0000">SO#</td>');
        BodyText += ('<td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px; color: #FF0000">' + SalesHdr."No." + '</td>');
        BodyText += ('<td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px; color: #FF0000"></td>');
        BodyText += ('<td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px; color: #FF0000">PO No.</td>');
        BodyText += ('<td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px; color: #FF0000">' + SalesHdr."External Document No." + '</td>');
        BodyText += ('<td colspan="2" style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px; text-align: right; color: #FF0000">Order Date : ' +
        FORMAT(SalesHdr."Order Date") + '</td></tr>');
        BodyText += ('<tr style="text-align: center"><th style="border:1px solid black";>Sr. No.</th>');
        BodyText += ('<th style="border:1px solid black;">Our Design</th>');
        BodyText += ('<th style="border:1px solid black;">Order Qty.</th>');
        BodyText += ('<th style="border:1px solid black;"> Min Qty. </th>');
        BodyText += ('<th style="border:1px solid black;">Stock Status</th>');
        BodyText += ('<th style="border:1px solid black;">Estimated Ship Date</th>');
        BodyText += ('<th style="border:1px solid black;">Detailed Comments</th></tr>');
        recSalesLine.RESET;
        recSalesLine.SETRANGE(recSalesLine."Document Type", SalesHdr."Document Type");
        recSalesLine.SETRANGE(recSalesLine."Document No.", SalesHdr."No.");
        IF recSalesLine.FINDFIRST THEN
            REPEAT
                BodyText += ('<tr style="text-align: center"><td style="border:1px solid black;">' + FORMAT(I) + '</td>');
                BodyText += ('<td style="border:1px solid black;">' + recSalesLine.Description + '</td>');
                IF recSalesLine.Quantity = 0 THEN
                    BodyText += ('<td style="border:1px solid black;"></td>')
                ELSE
                    BodyText += ('<td style="border:1px solid black;">' + FORMAT(recSalesLine.Quantity) + '</td>');
                IF recSalesLine."Minimum Qty" = 0 THEN
                    BodyText += ('<td style="border:1px solid black;"></td>')
                ELSE
                    BodyText += ('<td style="border:1px solid black;">' + FORMAT(recSalesLine."Minimum Qty") + '</td>');
                BodyText += ('<td style="border:1px solid black;"></td>');
                BodyText += ('<td style="border:1px solid black;">' + FORMAT(recSalesLine."Planned Delivery Date") + '</td>');
                BodyText += ('<td style="border:1px solid black;"></td></tr>');
                I += 1;
            UNTIL recSalesLine.NEXT = 0;

        BodyText += ('</table>');
        BodyText += ('<p>Thank you.<br>');
        BodyText += ('<p>Regards,<br>');
        BodyText += ('<B>' + recCompInfo.Name + '</B>');
        recUser.RESET;
        recUser.SETRANGE(recUser."User Name", USERID);
        IF recUser.FINDFIRST THEN
            BodyText += ('<br>' + recUser."Full Name");
        BodyText += ('<br>' + recCompInfo.Address);
        BodyText += ('<br>' + recCompInfo.City + ', ' + recCompInfo.County + ' ' + recCompInfo."Post Code");
        BodyText += ('</body>');
        BodyText += ('</html>');

        //AttachFile(AttachFilename);
        EmailMessage.Create(AddRecipients, SubjectText, BodyText, true, AddCC, AddBCC);
        Email.OpenInEditor(EmailMessage);
        //Send;
    end;


    procedure PurchReturnOrderOutlook(PurchHdr: Record "Purchase Header"; AttachFilename: Text)
    var
        // OutlookMessageHelperInstance: DotNet IOutlookMessage;
        recPurchaseLine: Record "Purchase Line";
        I: Integer;
        recCompInfo: Record "Company Information";
        recUser: Record User;
        recVendor: Record Vendor;
        recContact: Record Contact;
        ContactName: Text[100];
    begin
        SubjectText := '';
        BodyText := '';
        Clear(AddBCC);
        Clear(AddCC);
        Clear(AddRecipients);
        Clear(Tempblob);
        Clear(RecRef);
        Clear(OutStreamValue);
        Clear(InStreamValue);

        ContactName := '';
        IF recCompInfo.GET THEN;
        IF recVendor.GET(PurchHdr."Buy-from Vendor No.") THEN;
        IF PurchHdr."Buy-from Contact" <> '' THEN
            ContactName := 'Hi, ' + PurchHdr."Buy-from Contact" + ','
        ELSE
            IF PurchHdr."Buy-from Contact No." <> '' THEN BEGIN
                IF recContact.GET(PurchHdr."Buy-from Contact No.") THEN
                    ContactName := 'Hi, ' + recContact.Name + ',';
            END ELSE
                ContactName := 'M/S, ' + PurchHdr."Buy-from Vendor Name" + ',';

        I := 1;
        //Initialize;
        //OutlookMessageHelper.Recipients(recVendor."E-Mail");
        //OutlookMessageHelper.CarbonCopyRecipients(recVendor."Email CC");
        //OutlookMessageHelper.BlindCarbonCopyRecipients('');
        //OutlookMessageHelper.Subject := PurchHdr."No.";
        //OutlookMessageHelper.BodyFormat := 2;
        //OutlookMessageHelper.ShowNewMailDialogOnSend := TRUE;
        //OutlookMessageHelper.NewMailDialogIsModal := TRUE;

        AddRecipients.Add(recVendor."E-Mail");
        AddCC.Add(recVendor."Email CC");
        SubjectText := PurchHdr."No.";
        BodyText := ('<html>');
        BodyText += ('<head>');
        BodyText += ('<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
        BodyText += ('<title>Order</title>');
        BodyText += ('</head>');
        BodyText += ('<body>');
        BodyText += ('<p>' + ContactName + '</p>');
        BodyText += ('Please find enclosed a debit request for the following items.<br>');
        BodyText += ('Please review and get back to us ASAP.');
        BodyText += ('<table style="solid black;border-collapse:collapse;">');
        BodyText += ('<tr style="color: #FF0000"><td colspan="5" style="text-align: center">Purchase Return</td></tr>');
        BodyText += ('<tr><td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px; color: #FF0000">PRO#</td>');
        BodyText += ('<td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px; color: #FF0000">' + PurchHdr."No." + '</td>');
        //BodyText += ('<td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px;"></td>');
        //BodyText += ('<td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px;"></td>');
        BodyText += ('<td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px;"></td>');
        BodyText += ('<td colspan="2" style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px; text-align: right; color: #FF0000">PRO Date : ' +
        FORMAT(PurchHdr."Order Date") + '</td></tr>');
        BodyText += ('<tr><th style="border:1px solid black;"> Sr. No. </th>');
        BodyText += ('<th style="border:1px solid black;"> Our Design </th>');
        BodyText += ('<th style="border:1px solid black;"> Your Design </th>');
        //BodyText += ('<th style="border:1px solid black;"> Req. Date </th>');
        BodyText += ('<th style="border:1px solid black;"> Qty. </th>');
        //BodyText += ('<th style="border:1px solid black;"> Priority Quantity </th>');
        BodyText += ('<th style="border:1px solid black;">Amount</th></tr>');
        recPurchaseLine.RESET;
        recPurchaseLine.SETRANGE(recPurchaseLine."Document Type", PurchHdr."Document Type");
        recPurchaseLine.SETRANGE(recPurchaseLine."Document No.", PurchHdr."No.");
        IF recPurchaseLine.FINDFIRST THEN
            REPEAT
                BodyText += ('<tr><td style="border:1px solid black;">' + FORMAT(I) + '</td>');
                BodyText += ('<td style="border:1px solid black;">' + recPurchaseLine.Description + '</td>');
                BodyText += ('<td align=right style="border:1px solid black;">' + recPurchaseLine."Vendor Item No." + '</td>');
                //BodyText += ('<td style="border:1px solid black;">'+FORMAT(recPurchaseLine."Requested Receipt Date")+'</td>');
                BodyText += ('<td style="border:1px solid black;">' + FORMAT(recPurchaseLine.Quantity) + '</td>');
                //IF recPurchaseLine."Priority Qty" = 0 THEN
                //BodyText += ('<td style="border:1px solid black;"></td>')
                //ELSE
                //BodyText += ('<td style="border:1px solid black;">'+FORMAT(recPurchaseLine."Priority Qty")+'</td>');
                BodyText += ('<td style="border:1px solid black;">' + FORMAT(recPurchaseLine.Amount) + '</td></tr>');
                I += 1;
            UNTIL recPurchaseLine.NEXT = 0;

        BodyText += ('</table>');
        BodyText += ('<p>Thank you.<br>');
        BodyText += ('<p>Regards,<br>');
        BodyText += ('<B>' + recCompInfo.Name + '</B>');
        recUser.RESET;
        recUser.SETRANGE(recUser."User Name", USERID);
        IF recUser.FINDFIRST THEN
            BodyText += ('<br>' + recUser."Full Name");
        BodyText += ('<br>' + recCompInfo.Address);
        BodyText += ('<br>' + recCompInfo.City + ', ' + recCompInfo.County + ' ' + recCompInfo."Post Code");
        BodyText += ('</body>');
        BodyText += ('</html>');

        //AttachFile(AttachFilename);
        EmailMessage.Create(AddRecipients, SubjectText, BodyText, true, AddCC, AddBCC);
        Email.OpenInEditor(EmailMessage);
        //Send;
    end;

    procedure SalesInvoiceOutlook(SalesInvHdr: Record "Sales Invoice Header"; AttachFilename: Text)
    var
        //OutlookMessageHelperInstance: DotNet IOutlookMessage;
        recSalesInvLine: Record "Sales Invoice Line";
        I: Integer;
        recCompInfo: Record "Company Information";
        recUser: Record User;
        recCustomer: Record Customer;
        recContact: Record Contact;
        ContactName: Text[100];
    begin
        SubjectText := '';
        BodyText := '';
        Clear(AddBCC);
        Clear(AddCC);
        Clear(AddRecipients);
        Clear(Tempblob);
        Clear(RecRef);
        Clear(OutStreamValue);
        Clear(InStreamValue);

        Tempblob.CreateOutStream(OutStreamValue, TextEncoding::UTF8);
        RecRef.GetTable(SalesInvHdr);
        //REPORT.SaveAsPdf(50204, FileName, Rec);
        REPORT.SaveAs(50204, '', ReportFormat::Pdf, OutStreamValue);
        ContactName := '';
        IF recCompInfo.GET THEN;
        IF recCustomer.GET(SalesInvHdr."Bill-to Customer No.") THEN;
        IF SalesInvHdr."Bill-to Contact" <> '' THEN
            ContactName := 'Hi ' + SalesInvHdr."Bill-to Contact" + ','
        ELSE
            IF SalesInvHdr."Bill-to Contact No." <> '' THEN BEGIN
                IF recContact.GET(SalesInvHdr."Bill-to Contact No.") THEN
                    ContactName := 'Hi ' + recContact.Name + ',';
            END ELSE
                ContactName := SalesInvHdr."Bill-to Name" + ',';

        I := 1;
        // Initialize;
        // OutlookMessageHelper.Recipients(recCustomer."E-Mail");
        //OutlookMessageHelper.CarbonCopyRecipients(recCustomer."Email CC");
        //OutlookMessageHelper.BlindCarbonCopyRecipients('');
        //Ravi 170315 OutlookMessageHelper.Subject := SalesInvHdr."No.";
        //OutlookMessageHelper.Subject := 'Your PO#' + SalesInvHdr."External Document No.";
        // OutlookMessageHelper.BodyFormat := 2;
        // OutlookMessageHelper.ShowNewMailDialogOnSend := TRUE;
        // OutlookMessageHelper.NewMailDialogIsModal := TRUE;
        SubjectText := 'Your PO#' + SalesInvHdr."External Document No.";
        AddRecipients.Add(recCustomer."E-Mail");
        AddCC.Add(recCustomer."Email CC");
        BodyText := ('<html>');
        BodyText += ('<head>');
        BodyText += ('<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
        BodyText += ('<title>Order</title>');
        BodyText += ('</head>');
        BodyText += ('<body>');
        BodyText += ('<p>' + ContactName + '</p>');
        BodyText += ('Thanks for your order. The invoice is attached in this email.<br>');
        BodyText += ('We have listed the items shipped below:<br>');
        BodyText += ('<table style="solid black;border-collapse:collapse;">');
        BodyText += ('<tr style="color: #FF0000"><td colspan="6" style="text-align: center"></td></tr>');
        BodyText += ('<tr><td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px; color: #FF0000">INV#</td>');
        BodyText += ('<td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px; color: #FF0000">' + SalesInvHdr."No." + '</td>');
        BodyText += ('<td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px; color: #FF0000">PO No. ' + SalesInvHdr."External Document No." + '</td>');
        BodyText += ('<td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px; color: #FF0000"></td>');
        BodyText += ('<td colspan="2" style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px; text-align: right; color: #FF0000">Order Date : ' +
        FORMAT(SalesInvHdr."Order Date") + '</td></tr>');
        BodyText += ('<tr style="text-align: center"><th style="border:1px solid black";>Sr. No.</th>');
        BodyText += ('<th style="border:1px solid black;">Our Design</th>');
        BodyText += ('<th style="border:1px solid black;">Your Design</th>');
        BodyText += ('<th style="border:1px solid black;">Shipped Qty. </th>');
        BodyText += ('<th style="border:1px solid black;">Price</th>');
        BodyText += ('<th style="border:1px solid black;">Amount</th>');
        recSalesInvLine.RESET;
        recSalesInvLine.SETRANGE(recSalesInvLine."Document No.", SalesInvHdr."No.");
        IF recSalesInvLine.FINDFIRST THEN
            REPEAT
                BodyText += ('<tr style="text-align: center"><td style="border:1px solid black;">' + FORMAT(I) + '</td>');
                BodyText += ('<td style="border:1px solid black;">' + recSalesInvLine.Description + '</td>');
                BodyText += ('<td style="border:1px solid black;">' + recSalesInvLine."Item Reference No." + '</td>');
                IF recSalesInvLine.Quantity = 0 THEN
                    BodyText += ('<td style="border:1px solid black;"></td>')
                ELSE
                    BodyText += ('<td style="border:1px solid black;">' + FORMAT(recSalesInvLine.Quantity) + '</td>');
                IF recSalesInvLine."Unit Price" = 0 THEN
                    BodyText += ('<td style="border:1px solid black;""></td>')
                ELSE
                    BodyText += ('<td style="border:1px solid black;">' + FORMAT(recSalesInvLine."Unit Price") + '</td>');
                //IF recSalesInvLine.Amount = 0 THEN
                // BodyText += ('<td style="border:1px solid black;"></td>')
                // ELSE
                //BodyText += ('<td style="border:1px solid black;">'+FORMAT(recSalesInvLine.Amount)+'</td>');
                BodyText += ('<td style="border:1px solid black;">' + FORMAT(recSalesInvLine.Quantity * recSalesInvLine."Unit Price") + '</td>');
                I += 1;
            UNTIL recSalesInvLine.NEXT = 0;

        BodyText += ('</table>');
        BodyText += ('<p>Thank you.<br>');
        BodyText += ('<p>Regards,<br>');
        BodyText += ('<B>' + recCompInfo.Name + '</B>');
        recUser.RESET;
        recUser.SETRANGE(recUser."User Name", USERID);
        IF recUser.FINDFIRST THEN
            BodyText += ('<br>' + recUser."Full Name");
        BodyText += ('<br>' + recCompInfo.Address);
        BodyText += ('<br>' + recCompInfo.City + ', ' + recCompInfo.County + ' ' + recCompInfo."Post Code");
        BodyText += ('</body>');
        BodyText += ('</html>');

        //AttachFile(AttachFilename);
        //Send;
        Tempblob.CreateInStream(InStreamValue);
        EmailMessage.AddAttachment(AttachFilename, '.pdf', InStreamValue);
        EmailMessage.Create(AddRecipients, SubjectText, BodyText, True, AddCC, AddBCC);
        Email.OpenInEditor(EmailMessage);
    end;

    PROCEDURE PurchQuoteOutlook(PurchHdr: Record 38; AttachFilename: Text);
    VAR
        //OutlookMessageHelperInstance@1000000001 : DotNet "'Microsoft.Dynamics.Nav.Integration.Office, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Integration.Office.Outlook.IOutlookMessage";
        recPurchaseLine: Record 39;
        I: Integer;
        recCompInfo: Record 79;
        recUser: Record 2000000120;
        recVendor: Record 23;
        recContact: Record 5050;
        ContactName: Text[100];
    BEGIN
        Clear(Tempblob);
        Clear(RecRef);
        Clear(OutStreamValue);
        Clear(InStreamValue);
        Tempblob.CreateOutStream(OutStreamValue, TextEncoding::UTF8);
        RecRef.GetTable(PurchHdr);
        //REPORT.SaveAsPdf(50204, FileName, Rec);
        REPORT.SaveAs(10123, '', ReportFormat::Pdf, OutStreamValue, RecRef);
        ContactName := '';

        ContactName := '';
        IF recCompInfo.GET THEN;
        IF recVendor.GET(PurchHdr."Buy-from Vendor No.") THEN;
        IF PurchHdr."Buy-from Contact" <> '' THEN
            ContactName := 'Hi, ' + PurchHdr."Buy-from Contact" + ','
        ELSE
            IF PurchHdr."Buy-from Contact No." <> '' THEN BEGIN
                IF recContact.GET(PurchHdr."Buy-from Contact No.") THEN
                    ContactName := 'Hi, ' + recContact.Name + ',';
            END ELSE
                ContactName := 'M/S, ' + PurchHdr."Buy-from Vendor Name" + ',';

        I := 1;
        // Initialize;
        // OutlookMessageHelper.Recipients(recVendor."E-Mail");
        // OutlookMessageHelper.CarbonCopyRecipients(recVendor."Email CC");
        // OutlookMessageHelper.Subject := PurchHdr."No.";
        // OutlookMessageHelper.BodyFormat := 2;
        // OutlookMessageHelper.ShowNewMailDialogOnSend := TRUE;
        // OutlookMessageHelper.NewMailDialogIsModal := TRUE;

        SubjectText := PurchHdr."No.";
        AddRecipients.Add(recVendor."E-Mail");
        AddCC.Add(recVendor."Email CC");

        BodyText := ('<html>');
        BodyText += ('<head>');
        BodyText += ('<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
        BodyText += ('<title>Quote</title>');
        BodyText += ('</head>');
        BodyText += ('<body>');
        BodyText += ('<p>' + ContactName + '</p>');
        BodyText += ('Please find enclosed the Purchase Quote for the following items and priority quantity and date required.<br>');
        BodyText += ('We request your immediate confirmation of the priority quantity and priority delivery date.');
        BodyText += ('<table style="solid black;border-collapse:collapse;">');
        BodyText += ('<tr style="color: #FF0000"><td colspan="7" style="text-align: center">PQ Delivery Status</td></tr>');
        BodyText += ('<tr><td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px; color: #FF0000">PO#</td>');
        BodyText += ('<td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px; color: #FF0000">' + PurchHdr."No." + '</td>');
        BodyText += ('<td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px;"></td>');
        BodyText += ('<td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px;"></td>');
        BodyText += ('<td style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px;"></td>');
        BodyText += ('<td colspan="2" style="border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px; text-align: right; color: #FF0000">Po Date : ' +
        FORMAT(PurchHdr."Order Date") + '</td></tr>');
        BodyText += ('<tr><th style="border:1px solid black;"> Sr. No. </th>');
        BodyText += ('<th style="border:1px solid black;"> Our Design </th>');
        BodyText += ('<th style="border:1px solid black;"> Your Design </th>');
        BodyText += ('<th style="border:1px solid black;"> Req. Date </th>');
        BodyText += ('<th style="border:1px solid black;"> Ord. Qty. </th>');
        BodyText += ('<th style="border:1px solid black;"> Priority Quantity </th>');
        BodyText += ('<th style="border:1px solid black;">Priority Date</th></tr>');
        recPurchaseLine.RESET;
        recPurchaseLine.SETRANGE(recPurchaseLine."Document Type", PurchHdr."Document Type");
        recPurchaseLine.SETRANGE(recPurchaseLine."Document No.", PurchHdr."No.");
        IF recPurchaseLine.FINDFIRST THEN
            REPEAT
                BodyText += ('<tr><td style="border:1px solid black;">' + FORMAT(I) + '</td>');
                BodyText += ('<td style="border:1px solid black;">' + recPurchaseLine.Description + '</td>');
                BodyText += ('<td align=right style="border:1px solid black;">' + recPurchaseLine."Vendor Item No." + '</td>');
                BodyText += ('<td style="border:1px solid black;">' + FORMAT(recPurchaseLine."Requested Receipt Date") + '</td>');
                BodyText += ('<td style="border:1px solid black;">' + FORMAT(recPurchaseLine.Quantity) + '</td>');
                IF recPurchaseLine."Priority Qty" = 0 THEN
                    BodyText += ('<td style="border:1px solid black;"></td>')
                ELSE
                    BodyText += ('<td style="border:1px solid black;">' + FORMAT(recPurchaseLine."Priority Qty") + '</td>');
                BodyText += ('<td style="border:1px solid black;">' + FORMAT(recPurchaseLine."Priority Date") + '</td></tr>');
                I += 1;
            UNTIL recPurchaseLine.NEXT = 0;

        BodyText += ('</table>');
        BodyText += ('<p>Thank you.<br>');
        BodyText += ('<p>Regards,<br>');
        BodyText += ('<B>' + recCompInfo.Name + '</B>');
        recUser.RESET;
        recUser.SETRANGE(recUser."User Name", USERID);
        IF recUser.FINDFIRST THEN
            BodyText += ('<br>' + recUser."Full Name");
        BodyText += ('<br>' + recCompInfo.Address);
        BodyText += ('<br>' + recCompInfo.City + ', ' + recCompInfo.County + ' ' + recCompInfo."Post Code");
        BodyText += ('</body>');
        BodyText += ('</html>');

        // AttachFile(AttachFilename);
        // Send;

        Tempblob.CreateInStream(InStreamValue);
        EmailMessage.AddAttachment(AttachFilename, '.pdf', InStreamValue);
        EmailMessage.Create(AddRecipients, SubjectText, BodyText, True, AddCC, AddBCC);
        Email.OpenInEditor(EmailMessage);
    END;
}
