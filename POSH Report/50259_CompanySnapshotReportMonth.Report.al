report 50259 "Company Snapshot Report Month"
{
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;



    trigger OnPreReport()
    var
        txtSubject: Text[100];
        txtBody1: Text;
        txtBody2: Text;
        //Mail: Codeunit "SMTP Mail";
        // MailTO: Text[100];
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
        txtBody1 := '';
        Clear(MailBCC);
        Clear(MailCC);
        Clear(AddRecipients);

        Day := DATE2DMY(WORKDATE, 1);
        Month := DATE2DMY(WORKDATE, 2);
        Year := DATE2DMY(WORKDATE, 3);

        //MESSAGE('%1',DATE2DMY(TODAY,1));
        IF DATE2DMY(TODAY, 1) <> 1 THEN
            CurrReport.SKIP;

        LastMonthDate := DMY2DATE(1, Month - 1, Year);
        CurrentMonthDate := DMY2DATE(1, Month, Year);
        LastMonthLastDate := CurrentMonthDate - 1;

        TotalSales := 0;
        TotalPurchases := 0;
        TotalPaymentsReceived := 0;
        TotalPaymentsSent := 0;
        ARBalance := 0;
        APBalance := 0;
        TotalSales := TotalSalesCustomer();
        TotalPurchases := TotalPurchasesVendor();
        TotalPaymentsReceived := TotalPaymentsReceivedCustomer();
        TotalPaymentsSent := TotalPaymentsSentVendor();
        ARBalance := ARBalanceCustomer();
        APBalance := APBalanceVendor();



        txtSubject := 'Company Snapshot Report for the Month ' + FORMAT(Month) + '/' + FORMAT(Day) + '/' + FORMAT(Year);
        txtBody1 := '<html><body>'
                    + '<pre><p><font face = "Arial" size = "4">Dear Sir/Mam,</font></p></pre>'
                    + '<pre><p><font face = "Arial" size = "4">Please find the Company Snapshot Report for the Month ' + FORMAT(Month) + '/' + FORMAT(Day) + '/' + FORMAT(Year) + ', </a></font></p></pre>'

                    + '<table style="solid black;border-collapse:collapse;">'
                    + '<tr><th style="border:1px solid black;"> Description </th>'
                    + '<th style="border:1px solid black;"> Value </th>'

                    + '<tr><td style="border:1px solid black;"> Date </td>'
                    + '<td style="border:1px solid black;">' + FORMAT(WORKDATE) + '</td>'
                    + '<tr><td style="border:1px solid black;"> Total Sales </td>'
                    + '<td style="border:1px solid black;">' + FORMAT(TotalSales) + '</td>'
                    + '<tr><td style="border:1px solid black;"> Total Purchases </td>'
                    + '<td style="border:1px solid black;">' + FORMAT(TotalPurchases) + '</td>'
                    + '<tr><td style="border:1px solid black;"> Total Payments Received </td>'
                    + '<td style="border:1px solid black;">' + FORMAT(TotalPaymentsReceived) + '</td>'
                    + '<tr><td style="border:1px solid black;"> Total Payments Sent </td>'
                    + '<td style="border:1px solid black;">' + FORMAT(TotalPaymentsSent) + '</td>'
                    + '<tr><td style="border:1px solid black;"> Total AR Balance </td>'
                    + '<td style="border:1px solid black;">' + FORMAT(ARBalance) + '</td>'
                    + '<tr><td style="border:1px solid black;"> Total AP Balance </td>'
                    + '<td style="border:1px solid black;">' + FORMAT(APBalance) + '</td>'
                    + '</table>'

                    + '<pre><p><font face = "Arial" size = "4">Thank you</font></p></pre>'
                    + '<pre><p><font face = "Arial" size = "3"><b>posh textiles Team</font></p></pre>' +
                    '</html></body>';

        MailTO.Add('rs@poshtextiles.com');
        MailCC.Add('sarika@poshtextiles.com');
        MailBCC.Add('meghan@poshtextiles.com');
        MailBCC.Add('saurav@silk-crafts.com');

        EmailMessage.Create(AddRecipients, txtSubject, txtBody1, TRUE, MailCC, MailBCC);
        Email.Send(EmailMessage);
    end;

    var
        TotalSales: Decimal;
        TotalPurchases: Decimal;
        TotalPaymentsReceived: Decimal;
        TotalPaymentsSent: Decimal;
        Month: Integer;
        Day: Integer;
        Year: Integer;
        LastMonthDate: Date;
        CurrentMonthDate: Date;
        LastMonthLastDate: Date;
        ARBalance: Decimal;
        APBalance: Decimal;

    local procedure TotalSalesCustomer(): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        decTotalSale: Decimal;
    begin
        decTotalSale := 0;
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Invoice);
        CustLedgerEntry.SETRANGE("Posting Date", LastMonthDate, LastMonthLastDate);
        IF CustLedgerEntry.FINDSET THEN
            REPEAT
                CustLedgerEntry.CALCFIELDS(Amount);
                decTotalSale := decTotalSale + CustLedgerEntry.Amount;
            UNTIL CustLedgerEntry.NEXT = 0;
        EXIT(decTotalSale);
    end;

    local procedure TotalPurchasesVendor(): Decimal
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        decTotalPurch: Decimal;
    begin
        decTotalPurch := 0;
        VendorLedgerEntry.RESET;
        VendorLedgerEntry.SETRANGE("Document Type", VendorLedgerEntry."Document Type"::Invoice);
        VendorLedgerEntry.SETRANGE("Posting Date", LastMonthDate, LastMonthLastDate);
        IF VendorLedgerEntry.FINDSET THEN
            REPEAT
                VendorLedgerEntry.CALCFIELDS(Amount);
                decTotalPurch := decTotalPurch + VendorLedgerEntry.Amount;
            UNTIL VendorLedgerEntry.NEXT = 0;
        EXIT(decTotalPurch);
    end;

    local procedure TotalPaymentsReceivedCustomer(): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        decTotalPaymentRec: Decimal;
    begin
        decTotalPaymentRec := 0;
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Payment);
        CustLedgerEntry.SETRANGE("Posting Date", LastMonthDate, LastMonthLastDate);
        IF CustLedgerEntry.FINDSET THEN
            REPEAT
                CustLedgerEntry.CALCFIELDS(Amount);
                decTotalPaymentRec := decTotalPaymentRec + CustLedgerEntry.Amount;
            UNTIL CustLedgerEntry.NEXT = 0;
        EXIT(decTotalPaymentRec);
    end;

    local procedure TotalPaymentsSentVendor(): Decimal
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        decTotalPmttSent: Decimal;
    begin
        decTotalPmttSent := 0;
        VendorLedgerEntry.RESET;
        VendorLedgerEntry.SETRANGE("Document Type", VendorLedgerEntry."Document Type"::Payment);
        VendorLedgerEntry.SETRANGE("Posting Date", LastMonthDate, LastMonthLastDate);
        IF VendorLedgerEntry.FINDSET THEN
            REPEAT
                VendorLedgerEntry.CALCFIELDS(Amount);
                decTotalPmttSent := decTotalPmttSent + VendorLedgerEntry.Amount;
            UNTIL VendorLedgerEntry.NEXT = 0;
        EXIT(decTotalPmttSent);
    end;

    local procedure ARBalanceCustomer(): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        decARBalance: Decimal;
    begin
        decARBalance := 0;
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Posting Date", LastMonthDate, LastMonthLastDate);
        IF CustLedgerEntry.FINDSET THEN
            REPEAT
                CustLedgerEntry.CALCFIELDS("Remaining Amount");
                decARBalance := decARBalance + CustLedgerEntry."Remaining Amount";
            UNTIL CustLedgerEntry.NEXT = 0;
        EXIT(decARBalance);
    end;

    local procedure APBalanceVendor(): Decimal
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        decAPBalance: Decimal;
    begin
        decAPBalance := 0;
        VendorLedgerEntry.RESET;
        VendorLedgerEntry.SETRANGE("Posting Date", LastMonthDate, LastMonthLastDate);
        IF VendorLedgerEntry.FINDSET THEN
            REPEAT
                VendorLedgerEntry.CALCFIELDS("Remaining Amount");
                decAPBalance := decAPBalance + VendorLedgerEntry."Remaining Amount";
            UNTIL VendorLedgerEntry.NEXT = 0;
        EXIT(decAPBalance);
    end;
}

