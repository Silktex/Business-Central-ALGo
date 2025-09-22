report 50274 "Update Posting Date imn Sales"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50274_Report_UpdatePostingDateimnSales.rdlc';

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                SalesInvoiceHeader.RESET;
                SalesInvoiceHeader.SETRANGE("No.", SalesInvoiceNo);
                IF SalesInvoiceHeader.FINDFIRST THEN BEGIN
                    SalesInvoiceHeader."Posting Date" := PostingDate;
                    SalesInvoiceHeader.MODIFY;
                END;

                SalesInvoiceLine.RESET;
                SalesInvoiceLine.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                IF SalesInvoiceLine.FINDFIRST THEN BEGIN
                    REPEAT
                        SalesInvoiceLine."Posting Date" := PostingDate;
                        SalesInvoiceLine.MODIFY;
                    UNTIL SalesInvoiceLine.NEXT = 0;
                END;

                ResLedgerEntry.RESET;
                ResLedgerEntry.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                IF ResLedgerEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        ResLedgerEntry."Posting Date" := PostingDate;
                        ResLedgerEntry.MODIFY;
                    UNTIL ResLedgerEntry.NEXT = 0;
                END;

                ValueEntry.RESET;
                ValueEntry.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                IF ValueEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        ValueEntry."Posting Date" := PostingDate;
                        ValueEntry.MODIFY;
                    UNTIL ValueEntry.NEXT = 0;
                END;

                DetailedCustLedgEntry.RESET;
                DetailedCustLedgEntry.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                IF DetailedCustLedgEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        DetailedCustLedgEntry."Posting Date" := PostingDate;
                        DetailedCustLedgEntry.MODIFY;
                    UNTIL DetailedCustLedgEntry.NEXT = 0;
                END;

                CustLedgerEntry.RESET;
                CustLedgerEntry.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                IF CustLedgerEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        CustLedgerEntry."Posting Date" := PostingDate;
                        CustLedgerEntry.MODIFY;
                    UNTIL CustLedgerEntry.NEXT = 0;
                END;

                VATEntry.RESET;
                VATEntry.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                IF VATEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        VATEntry."Posting Date" := PostingDate;
                        VATEntry.MODIFY;
                    UNTIL VATEntry.NEXT = 0;
                END;

                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                IF GLEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        GLEntry."Posting Date" := PostingDate;
                        GLEntry.MODIFY;
                    UNTIL GLEntry.NEXT = 0;
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(SalesInvoiceNo; SalesInvoiceNo)
                    {
                        Caption = 'Sales Invoice No';
                        TableRelation = "Sales Invoice Header"."No.";
                        ApplicationArea = all;
                    }
                    field(PostingDate; PostingDate)
                    {
                        Caption = 'Posting Date';
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceNo: Code[20];
        PostingDate: Date;
        SalesInvoiceLine: Record "Sales Invoice Line";
        ResLedgerEntry: Record "Res. Ledger Entry";
        ValueEntry: Record "Value Entry";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VATEntry: Record "VAT Entry";
        GLEntry: Record "G/L Entry";
}

