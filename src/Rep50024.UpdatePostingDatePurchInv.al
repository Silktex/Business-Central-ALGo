report 50024 "Update Posting Date Purch. Inv"
{
    ApplicationArea = All;
    Caption = 'Update Posting Date Purch. Inv';
    ProcessingOnly = true;
    UsageCategory = Tasks;
    Permissions = tabledata "Purch. Inv. Header" = RM,
                    tabledata "Purch. Inv. Line" = RM,
                    tabledata "Res. Ledger Entry" = RM,
                    tabledata "Value Entry" = RM,
                    tabledata "Detailed Vendor Ledg. Entry" = RM,
                    tabledata "Vendor Ledger Entry" = RM,
                    tabledata "VAT Entry" = RM,
                    tabledata "G/L Entry" = RM;

    dataset
    {

    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    Caption = 'Options';
                    field(PurchInvoiceNo; PurchInvoiceNo)
                    {
                        Caption = 'Purchase Invoice No';
                        TableRelation = "Purch. Inv. Header"."No.";
                        ApplicationArea = all;
                    }
                    field(PostingDate; PostingDate)
                    {
                        Caption = 'Posting Date';
                        ApplicationArea = all;
                    }
                    field(DocumentDate; DocumentDate)
                    {
                        Caption = 'Document Date';
                        ApplicationArea = all;
                    }
                    field(DueDate; DueDate)
                    {
                        Caption = 'Due Date';
                        ApplicationArea = all;
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }


    trigger OnPostReport()
    begin
        if PurchInvoiceNo = '' then
            Error('Invoice No. must not be blank.');

        if PostingDate = 0D then
            Error('Posting Date must not be blank.');

        if DocumentDate = 0D then
            Error('Document Date must not be blank.');

        if DueDate = 0D then
            Error('Due Date must not be blank.');

        if GuiAllowed then
            Win.Open(DigMsg);

        if GuiAllowed then
            win.Update(1, PurchInvoiceHeader.TableCaption);

        PurchInvoiceHeader.RESET;
        PurchInvoiceHeader.SETRANGE("No.", PurchInvoiceNo);
        IF PurchInvoiceHeader.FINDFIRST THEN BEGIN
            PurchInvoiceHeader."Posting Date" := PostingDate;
            PurchInvoiceHeader."Document Date" := DocumentDate;
            PurchInvoiceHeader."Due Date" := DueDate;
            // PaymentTerms.Get(PurchInvoiceHeader."Payment Terms Code");
            // NewDueDate := CalcDate(PaymentTerms."Due Date Calculation", PostingDate);
            // PurchInvoiceHeader."Due Date" := NewDueDate;
            PurchInvoiceHeader.MODIFY;
        END;

        if GuiAllowed then
            win.Update(1, PurchInvoiceLine.TableCaption);

        PurchInvoiceLine.RESET;
        PurchInvoiceLine.SETRANGE("Document No.", PurchInvoiceHeader."No.");
        IF PurchInvoiceLine.FINDFIRST THEN BEGIN
            REPEAT
                PurchInvoiceLine."Posting Date" := PostingDate;
                PurchInvoiceLine.MODIFY;
            UNTIL PurchInvoiceLine.NEXT = 0;
        END;

        if GuiAllowed then
            win.Update(1, ResLedgerEntry.TableCaption);

        ResLedgerEntry.RESET;
        ResLedgerEntry.SETRANGE("Document No.", PurchInvoiceHeader."No.");
        IF ResLedgerEntry.FINDFIRST THEN BEGIN
            REPEAT
                ResLedgerEntry."Posting Date" := PostingDate;
                ResLedgerEntry."Document Date" := DocumentDate;
                ResLedgerEntry.MODIFY;
            UNTIL ResLedgerEntry.NEXT = 0;
        END;

        if GuiAllowed then
            win.Update(1, ValueEntry.TableCaption);

        ValueEntry.RESET;
        ValueEntry.SETRANGE("Document No.", PurchInvoiceHeader."No.");
        IF ValueEntry.FINDFIRST THEN BEGIN
            REPEAT
                ValueEntry."Posting Date" := PostingDate;
                ValueEntry."Document Date" := DocumentDate;
                ValueEntry.MODIFY;
            UNTIL ValueEntry.NEXT = 0;
        END;

        if GuiAllowed then
            win.Update(1, DetailedVendLedgEntry.TableCaption);

        DetailedVendLedgEntry.RESET;
        DetailedVendLedgEntry.SETRANGE("Document No.", PurchInvoiceHeader."No.");
        IF DetailedVendLedgEntry.FINDFIRST THEN BEGIN
            REPEAT
                DetailedVendLedgEntry."Posting Date" := PostingDate;
                DetailedVendLedgEntry.MODIFY;
            UNTIL DetailedVendLedgEntry.NEXT = 0;
        END;

        if GuiAllowed then
            win.Update(1, VendLedgerEntry.TableCaption);

        VendLedgerEntry.RESET;
        VendLedgerEntry.SETRANGE("Document No.", PurchInvoiceHeader."No.");
        IF VendLedgerEntry.FINDFIRST THEN BEGIN
            REPEAT
                VendLedgerEntry."Posting Date" := PostingDate;
                VendLedgerEntry."Document Date" := DocumentDate;
                VendLedgerEntry."Due Date" := DueDate;
                // if NewDueDate <> 0D then
                //     VendLedgerEntry."Due Date" := NewDueDate;
                VendLedgerEntry.MODIFY;
            UNTIL VendLedgerEntry.NEXT = 0;
        END;

        if GuiAllowed then
            win.Update(1, VATEntry.TableCaption);

        VATEntry.RESET;
        VATEntry.SETRANGE("Document No.", PurchInvoiceHeader."No.");
        IF VATEntry.FINDFIRST THEN BEGIN
            REPEAT
                VATEntry."Posting Date" := PostingDate;
                VATEntry."Document Date" := DocumentDate;
                VATEntry.MODIFY;
            UNTIL VATEntry.NEXT = 0;
        END;

        if GuiAllowed then
            win.Update(1, GLEntry.TableCaption);

        GLEntry.RESET;
        GLEntry.SETRANGE("Document No.", PurchInvoiceHeader."No.");
        IF GLEntry.FINDFIRST THEN BEGIN
            REPEAT
                GLEntry."Posting Date" := PostingDate;
                GLEntry."Document Date" := DocumentDate;
                GLEntry.MODIFY;
            UNTIL GLEntry.NEXT = 0;
        END;

        if GuiAllowed then
            win.Close();

    end;

    var
        PurchInvoiceHeader: Record "Purch. Inv. Header";
        PurchInvoiceNo: Code[20];
        PostingDate: Date;
        DocumentDate: Date;
        DueDate: Date;
        PurchInvoiceLine: Record "Purch. Inv. Line";
        ResLedgerEntry: Record "Res. Ledger Entry";
        ValueEntry: Record "Value Entry";
        DetailedVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        VATEntry: Record "VAT Entry";
        GLEntry: Record "G/L Entry";
        Win: Dialog;
        DigMsg: Label 'Updating #1#################################################', Locked = true;
        NewDueDate: date;
        PaymentTerms: Record "Payment Terms";

}
