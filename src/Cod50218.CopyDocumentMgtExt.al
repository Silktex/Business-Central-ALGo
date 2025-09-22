codeunit 50218 "Copy Document Mgt_Ext"
{

    var
        RecSIL: Record "Sales Invoice Header";
        ExtDocNo: Text;
        RecSSH: Record "Sales Shipment Header";
        ExtDocNo2: Text;
        Text013: Label 'Shipment No.,Invoice No.,Return Receipt No.,Credit Memo No.';
        Text015: Label '%1 %2:';
        Text016: Label 'Inv. No. ,Shpt. No. ,Cr. Memo No. ,Rtrn. Rcpt. No. ';
        Text018: Label '%1 - %2:';

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Copy Document Mgt.", 'OnBeforeInsertOldSalesDocNoLine', '', false, false)]
    local procedure OnBeforeInsertOldSalesDocNoLine(var ToSalesHeader: Record "Sales Header"; var ToSalesLine: Record "Sales Line"; OldDocType: Option; OldDocNo: Code[20]; var IsHandled: Boolean)
    begin
        //SKNAV11.00 : Begin
        ExtDocNo := '';      //sushant
        RecSIL.RESET;
        RecSIL.SETRANGE(RecSIL."No.", OldDocNo);
        IF RecSIL.FINDFIRST THEN BEGIN
            ExtDocNo := RecSIL."External Document No.";
        END;
        ToSalesLine.Description := STRSUBSTNO(Text015, SELECTSTR(OldDocType, Text013), OldDocNo, 'Cust.Po. No.', ExtDocNo);
        //SKNAV11.00 : End
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Copy Document Mgt.", 'OnBeforeInsertOldSalesCombDocNoLine', '', false, false)]
    local procedure OnBeforeInsertOldSalesCombDocNoLine(var ToSalesHeader: Record "Sales Header"; var ToSalesLine: Record "Sales Line"; CopyFromInvoice: Boolean; OldDocNo: Code[20]; OldDocNo2: Code[20])
    begin
        ExtDocNo2 := '';  //SKNAV11.00
        if CopyFromInvoice then begin
            RecSSH.RESET;
            RecSSH.SETRANGE(RecSSH."No.", OldDocNo2);
            IF RecSSH.FINDFIRST THEN BEGIN
                ExtDocNo2 := RecSSH."External Document No.";
            END;

            ToSalesLine.Description :=
              STRSUBSTNO(Text018, COPYSTR(SELECTSTR(1, Text016) + OldDocNo, 1, 23), COPYSTR(SELECTSTR(2, Text016) + OldDocNo2, 1, 23))

            // ToSalesLine.Description :=
            //   StrSubstNo(
            //     Text018,
            //     CopyStr(SelectStr(1, Text016) + OldDocNo, 1, 23),
            //     CopyStr(SelectStr(2, Text016) + OldDocNo2, 1, 23))
        END else
            ToSalesLine.Description :=
              StrSubstNo(
                Text018,
                CopyStr(SelectStr(3, Text016) + OldDocNo, 1, 23),
                CopyStr(SelectStr(4, Text016) + OldDocNo2, 1, 23));
    end;
}
