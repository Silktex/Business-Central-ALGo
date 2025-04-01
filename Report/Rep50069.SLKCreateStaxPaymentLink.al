report 50069 "SLK Create Stax Payment Link"
{
    ApplicationArea = All;
    Caption = 'Create Stax Payment Link';
    UsageCategory = None;
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(DocumentType; DocumentType)
                    {
                        Caption = 'Document Type';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Document Type field.';
                    }
                    field(DocumentNo; DocumentNo)
                    {
                        Caption = 'Document No.';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Document No. field.';
                    }
                    field(AmountToCharge; AmountToCharge)
                    {
                        Caption = 'Amount To Charge';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Amount To Charge field.';
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    var
        recSalesLine: Record "Sales Line";
        StaxPaymentMgmt: Codeunit "TLI Stax Payment Handler";
        decAmount: Decimal;
    begin
        SalesHeader.GET(SalesHeader."Document Type"::Order, DocumentNo);
        if AmountToCharge = 0 then
            Error('Amount To Charge must not be zero.');

        decAmount := 0;
        recSalesLine.RESET;
        recSalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        recSalesLine.SETRANGE("Document No.", SalesHeader."No.");
        IF recSalesLine.FIND('-') THEN
            REPEAT
                IF recSalesLine.Quantity <> 0 THEN
                    decAmount := decAmount + recSalesLine.Amount * recSalesLine."Qty. to Invoice" / recSalesLine.Quantity;
            UNTIL recSalesLine.NEXT = 0;
        decAmount := ROUND(decAmount);

        IF decAmount < AmountToCharge THEN
            ERROR('Can not make Payment more than %1', FORMAT(decAmount));

        Clear(StaxPaymentMgmt);
        if StaxPaymentMgmt.PaymentLinkIsEmpty(1, SalesHeader."No.") then begin
            if StaxPaymentMgmt.GeneratePaymentLink(1, SalesHeader."No.", AmountToCharge) then
                Message('Payment link created.');
        end else
            error('Payment link already exist.');
    end;

    var
        SalesHeader: Record "Sales Header";
        DocumentType: Option " ","Order",Invoice,Payment,Refund;
        DocumentNo: code[20];
        AmountToCharge: Decimal;

    procedure SetInitReport(DocType: Option " ","Order",Invoice,Payment,Refund; DocNo: Code[20])
    begin
        DocumentType := DocType;
        DocumentNo := DocNo;
    end;
}
