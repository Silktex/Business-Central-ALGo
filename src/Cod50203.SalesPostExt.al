codeunit 50203 SalesPost_Ext
{

    var
        DOPaymentMgt: Codeunit "DO Payment Mgt.";
        DoPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
        recCompInfo: Record "Company Information";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";

    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnBeforePostSalesOrder', '', false, false)]
    local procedure OnBeforePostSalesOrder(var SalesHeader: Record "Sales Header"; PostingCodeunitID: Integer; Navigate: Enum "Navigate After Posting")
    var
        compInfo: Record "Company Information";
    begin
        compInfo.get();
        IF compInfo."Report Selection" <> compInfo."Report Selection"::Slik then begin
            SalesHeader."Posting Date" := WorkDate;
            SalesHeader.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnInsertShipmentHeaderOnAfterTransferfieldsToSalesShptHeader', '', false, false)]
    local procedure OnInsertShipmentHeaderOnAfterTransferfieldsToSalesShptHeader(SalesHeader: Record "Sales Header"; var SalesShptHeader: Record "Sales Shipment Header")
    begin
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) and (SalesHeader."Location Code" <> 'MATRL BANK') then begin
            SalesHeader.TestField("Shipping Agent Code");
            SalesHeader.TestField("Shipping Agent Service Code");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean)
    var
        TransactionLogEntryNo: Integer;
        UserSetup: Record "User Setup";
        SendSmtpMail: Codeunit SmtpMail_Ext;
        // Xmlhttp: Automation;
        Result: Boolean;
        txtURL: Text;
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        //SPDSAUCRCardPayment
        IF IsOnlinePayment(SalesHeader) AND SalesHeader.Invoice THEN BEGIN
            DOPaymentMgt.CheckSalesDoc(SalesHeader);
            IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice] THEN BEGIN

                DoPaymentTransLogEntry.RESET;
                DoPaymentTransLogEntry.SETCURRENTKEY("Document Type", "Document No.", "Transaction Result", "Transaction Status");
                DoPaymentTransLogEntry.SETRANGE("Document Type", SalesHeader."Document Type");
                DoPaymentTransLogEntry.SETRANGE("Document No.", SalesHeader."No.");
                DoPaymentTransLogEntry.SETFILTER("Transaction Type", '%1', DoPaymentTransLogEntry."Transaction Type"::Capture);
                DoPaymentTransLogEntry.SETRANGE("Transaction Result", DoPaymentTransLogEntry."Transaction Result"::Success);
                DoPaymentTransLogEntry.SETRANGE("Transaction Status", DoPaymentTransLogEntry."Transaction Status"::Captured);
                IF DoPaymentTransLogEntry.FIND('-') THEN BEGIN
                    REPEAT
                        DOPaymentMgt.CheckCreditCardData(DoPaymentTransLogEntry."Credit Card No.");
                        TransactionLogEntryNo := DoPaymentTransLogEntry."Entry No.";

                        IF (SalesHeader."Bal. Account No." <> '') AND IsOnlinePayment(SalesHeader) AND SalesHeader.Invoice AND (TransactionLogEntryNo > 0) THEN
                            PostBalanceEntry(
                              TransactionLogEntryNo, SalesHeader, SalesInvHdrNo, SalesCrMemoHdrNo, CustLedgerEntry, DoPaymentTransLogEntry.Amount);

                    UNTIL DoPaymentTransLogEntry.NEXT = 0;
                END;
            END;


            IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN BEGIN
                DoPaymentTransLogEntry.RESET;
                //  DoPaymentTransLogEntry.SETCURRENTKEY("Document Type", "Document No.", SalesHeader."Transaction Type", SalesHeader."Transaction Result", SalesHeader."Transaction Status");
                DoPaymentTransLogEntry.SETRANGE("Document Type", SalesHeader."Document Type");
                DoPaymentTransLogEntry.SETRANGE("Document No.", SalesHeader."No.");
                //SETFILTER("Transaction Type",'%1|%2',"Transaction Type"::Void,"Transaction Type"::Refund);
                DoPaymentTransLogEntry.SETRANGE("Transaction Result", DoPaymentTransLogEntry."Transaction Result"::Success);
                DoPaymentTransLogEntry.SETRANGE("Transaction Status", DoPaymentTransLogEntry."Transaction Status"::Refunded);
                IF DoPaymentTransLogEntry.FIND('-') THEN BEGIN
                    REPEAT
                        DOPaymentMgt.CheckCreditCardData(DoPaymentTransLogEntry."Credit Card No.");
                        TransactionLogEntryNo := DoPaymentTransLogEntry."Entry No.";

                        IF (SalesHeader."Bal. Account No." <> '') AND IsOnlinePayment(SalesHeader) AND SalesHeader.Invoice AND (TransactionLogEntryNo > 0) THEN
                            PostBalanceEntry(
                              TransactionLogEntryNo, SalesHeader, SalesInvHdrNo, SalesCrMemoHdrNo, CustLedgerEntry, DoPaymentTransLogEntry.Amount);
                    UNTIL DoPaymentTransLogEntry.NEXT = 0;
                END;
            END;
        END;

        //>>SPD AK 08042015
        IF (SalesHeader.Ship) AND (SalesHeader."Location Code" <> 'MATRL BANK') THEN BEGIN
            IF UserSetup.GET(USERID) AND UserSetup."Sent Mail Sales Shipment" THEN BEGIN
                if SalesShptHeader.Get(SalesShptHdrNo) then
                    SendSmtpMail.SendShipmentAsPDF(SalesShptHeader);
            END;
        END;


        IF (SalesHeader.Invoice) AND (SalesHeader."Location Code" <> 'MATRL BANK') THEN BEGIN
            IF UserSetup.GET(USERID) AND UserSetup."Sent Mail Sales Invoice" THEN BEGIN
                if SalesInvHeader.Get(SalesInvHdrNo) then
                    SendSmtpMail.SendInvoiceAsPDF(SalesInvHeader);
            END;
        END;
        //>>SPD AK 08042015
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnCheckAndUpdateOnAfterReleaseSalesDocument', '', false, false)]
    local procedure OnCheckAndUpdateOnAfterReleaseSalesDocument(SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    var
        TransactionLogEntryNo: Integer;
    begin
        TransactionLogEntryNo := AuthorizeCreditCard(SalesHeader, SalesHeader."Authorization Required"); //SKNAV11.00
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnBeforeSalesShptHeaderInsert', '', false, false)]
    local procedure OnBeforeSalesShptHeaderInsert(var SalesShptHeader: Record "Sales Shipment Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; var IsHandled: Boolean)
    begin
        //Handheld Begin
        SalesShptHeader."Warehouse Shipment No." := SalesHeader."No.";
        //Handheld END
    end;

    procedure IsOnlinePayment(var SalesHeader: Record "Sales Header"): Boolean
    var
        DOPaymentMgt: Codeunit "DO Payment Mgt.";
    begin
        IF DOPaymentMgt.IsValidPaymentMethod(SalesHeader."Payment Method Code") THEN
            EXIT(TRUE);
        EXIT(FALSE);
    end;

    local procedure AuthorizeCreditCard(var SalesHeader: Record "Sales Header"; AuthorizationRequired: Boolean): Integer
    var
        DOPaymentMgt: Codeunit "DO Payment Mgt.";
    begin
        //WITH SalesHeader DO BEGIN
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) AND SalesHeader.Ship OR
           (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) AND SalesHeader.Invoice
        THEN
            IF DOPaymentMgt.IsValidPaymentMethod(SalesHeader."Payment Method Code") THEN BEGIN
                IF DOPaymentMgt.IsAuthorizationRequired OR AuthorizationRequired THEN
                    EXIT(DOPaymentMgt.AuthorizeSalesDoc(SalesHeader, 0, TRUE));
                SalesHeader.TESTFIELD("Credit Card No.");
            END;
        //END;
        EXIT(0);
    end;

    local procedure PostBalanceEntry(TransactionLogEntryNo: Integer; SalesHeader2: Record "Sales Header"; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; var CustLedgEntry: Record "Cust. Ledger Entry"; decAmount: Decimal)
    var
        //CustLedgEntry: Record "Cust. Ledger Entry";
        DOPaymentMgt: Codeunit "DO Payment Mgt.";
        CrCardDocumentType: Option Payment,Refund;
        GenJnlLine: Record "Gen. Journal Line";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        GLEntry: Record "G/L Entry";
        AmtIncVat: Decimal;
    begin
        //WITH SalesHeader2 DO BEGIN
        //FindCustLedgEntry(DocType, DocNo, CustLedgEntry);
        AmtIncVat := 0;
        if SalesInvHdrNo <> '' then begin
            SalesInvoiceLine.Reset();
            SalesInvoiceLine.SetRange("Document No.", SalesInvHdrNo);
            if SalesInvoiceLine.FindSet() then
                SalesInvoiceLine.CalcSums("Amount Including VAT");
            AmtIncVat := SalesInvoiceLine."Amount Including VAT";
        end;
        if SalesCrMemoHdrNo <> '' then begin
            SalesCrMemoLine.Reset();
            SalesCrMemoLine.SetRange("Document No.", SalesCrMemoHdrNo);
            if SalesCrMemoLine.FindSet() then
                SalesCrMemoLine.CalcSums("Amount Including VAT");
            AmtIncVat := SalesCrMemoLine."Amount Including VAT";
        end;

        GenJnlLine.INIT;
        GenJnlLine."Posting Date" := SalesHeader2."Posting Date";
        GenJnlLine."Document Date" := SalesHeader2."Document Date";
        GenJnlLine.Description := SalesHeader2."Posting Description";
        GenJnlLine."Shortcut Dimension 1 Code" := SalesHeader2."Shortcut Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := SalesHeader2."Shortcut Dimension 2 Code";
        GenJnlLine."Dimension Set ID" := SalesHeader2."Dimension Set ID";
        GenJnlLine."Reason Code" := SalesHeader2."Reason Code";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := SalesHeader2."Bill-to Customer No.";
        IF SalesHeader2."Document Type" IN [SalesHeader2."Document Type"::"Return Order", SalesHeader2."Document Type"::"Credit Memo"] THEN
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund
        ELSE
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := CustLedgEntry."Document No.";
        GenJnlLine."External Document No." := CustLedgEntry."External Document No.";
        IF SalesHeader2."Bal. Account Type" = SalesHeader2."Bal. Account Type"::"Bank Account" THEN
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
        GenJnlLine."Bal. Account No." := SalesHeader2."Bal. Account No.";
        GenJnlLine."Currency Code" := SalesHeader2."Currency Code";
        IF decAmount = 0 THEN BEGIN
            GenJnlLine.Amount :=
              AmtIncVat + CustLedgEntry."Remaining Pmt. Disc. Possible";
        END ELSE BEGIN
            IF AmtIncVat > 0 THEN
                GenJnlLine.Amount := ABS(decAmount)
            ELSE
                GenJnlLine.Amount := -ABS(decAmount);
        END;


        GenJnlLine."Source Currency Code" := SalesHeader2."Currency Code";
        GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
        GenJnlLine.Correction := SalesHeader2.Correction;
        CustLedgEntry.CALCFIELDS(Amount);
        IF decAmount = 0 THEN BEGIN
            IF CustLedgEntry.Amount = 0 THEN
                GenJnlLine."Amount (LCY)" := AmtIncVat
            ELSE
                GenJnlLine."Amount (LCY)" :=
                  AmtIncVat +
                  ROUND(
                    CustLedgEntry."Remaining Pmt. Disc. Possible" /
                    CustLedgEntry."Adjusted Currency Factor");
        END ELSE BEGIN
            IF AmtIncVat > 0 THEN
                GenJnlLine."Amount (LCY)" := ABS(decAmount)
            ELSE
                GenJnlLine."Amount (LCY)" := -ABS(decAmount);
        END;
        IF SalesHeader2."Currency Code" = '' THEN
            GenJnlLine."Currency Factor" := 1
        ELSE
            GenJnlLine."Currency Factor" := SalesHeader2."Currency Factor";
        GenJnlLine."Applies-to Doc. Type" := CustLedgEntry."Document Type";
        GenJnlLine."Applies-to Doc. No." := CustLedgEntry."Document No.";
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
        GenJnlLine."Source No." := SalesHeader2."Bill-to Customer No.";
        GenJnlLine."Source Code" := CustLedgEntry."Source Code";// SourceCode;
        GenJnlLine."Posting No. Series" := SalesHeader2."Posting No. Series";
        GenJnlLine."IC Partner Code" := SalesHeader2."Sell-to IC Partner Code";
        GenJnlLine."Salespers./Purch. Code" := SalesHeader2."Salesperson Code";
        GenJnlLine."Allow Zero-Amount Posting" := TRUE;

        GenJnlPostLine.RunWithCheck(GenJnlLine);

        IF TransactionLogEntryNo <> 0 THEN BEGIN
            CASE SalesHeader2."Document Type" OF
                GenJnlLine."Document Type"::Payment:
                    CrCardDocumentType := CrCardDocumentType::Payment;
                SalesHeader2."Document Type"::"Credit Memo":
                    CrCardDocumentType := CrCardDocumentType::Refund;
            END;
            DOPaymentMgt.UpdateTransactEntryAfterPost(TransactionLogEntryNo, CustLedgEntry."Entry No.", CrCardDocumentType);
        END;
    END;
    //end;
    local procedure FindCustLedgEntry(DocType: Enum "Gen. Journal Document Type"; DocNo: Code[20]; var CustLedgEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgEntry.SetRange("Document Type", DocType);
        CustLedgEntry.SetRange("Document No.", DocNo);
        CustLedgEntry.FindLast;
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnBeforeCheckQuantityIsCompletelyReleased', '', false, false)]
    // local procedure OnBeforeCheckQuantityIsCompletelyReleased(ItemTrackingHandling: Option "None","Allow deletion",Match; QtyToRelease: Decimal; DeleteAll: Boolean; CurrentItemTrackingSetup: Record "Item Tracking Setup"; ReservEntry: Record "Reservation Entry"; var IsHandled: boolean)
    // begin
    //     ItemTrackingHandling := ItemTrackingHandling::"Allow deletion";
    // end;
}
