report 80000 UpdateSalesOrderPostingDate
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Sales Invoice Header" = RIMD,
                  tabledata "Sales Invoice Line" = RIMD,
                  tabledata "G/L Entry" = RIMD,
                  tabledata "VAT Entry" = RIMD,
                  tabledata "Cust. Ledger Entry" = RIMD,
                  tabledata "Detailed Cust. Ledg. Entry" = RIMD,
                  tabledata "Value Entry" = RIMD,
                  tabledata "Res. Ledger Entry" = RIMD;

    dataset
    {
        dataitem(Integer;
        Integer)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1));
            trigger OnAfterGetRecord()
            var
                SalesInvoiceHeader: Record "Sales Invoice Header";
                SalesInvoiceLine: Record "Sales Invoice Line";
                GLEntry: Record "G/L Entry";
                TaxEntry: Record "VAT Entry";
                CustLedgEntry: Record "Cust. Ledger Entry";
                DetailCustLedEntry: Record "Detailed Cust. Ledg. Entry";
                ValueEntry: Record "Value Entry";
                ResLedEntry: Record "Res. Ledger Entry";
            begin
                SalesInvoiceHeader.Reset();
                SalesInvoiceHeader.SetRange("No.", DocumentNo);
                IF SalesInvoiceHeader.FindFirst then begin
                    SalesInvoiceHeader.Validate("Posting Date", PosttingDate);
                    SalesInvoiceHeader.Modify();
                END;
                SalesInvoiceLine.Reset();
                SalesInvoiceLine.SetRange("Document No.", DocumentNo);
                IF SalesInvoiceLine.FindFirst then begin
                    repeat
                        SalesInvoiceLine.Validate("Posting Date", PosttingDate);
                        SalesInvoiceLine.Modify();
                    until SalesInvoiceLine.Next = 0;
                END;

                GLEntry.Reset();
                GLEntry.SetRange("Document No.", DocumentNo);
                IF GLEntry.FindFirst then begin
                    repeat
                        GLEntry.Validate("Posting Date", PosttingDate);
                        GLEntry.Modify();
                    until GLEntry.Next = 0;
                END;

                TaxEntry.Reset();
                TaxEntry.SetRange("Document No.", DocumentNo);
                IF TaxEntry.FindFirst then begin
                    repeat
                        TaxEntry.Validate("Posting Date", PosttingDate);
                        TaxEntry.Modify();
                    until TaxEntry.Next = 0;
                END;

                CustLedgEntry.Reset();
                CustLedgEntry.SetRange("Document No.", DocumentNo);
                IF CustLedgEntry.FindFirst then begin
                    repeat
                        CustLedgEntry.Validate("Posting Date", PosttingDate);
                        CustLedgEntry.Modify();
                    until CustLedgEntry.Next = 0;
                END;

                DetailCustLedEntry.Reset();
                DetailCustLedEntry.SetRange("Document No.", DocumentNo);
                IF DetailCustLedEntry.FindFirst then begin
                    repeat
                        DetailCustLedEntry.Validate("Posting Date", PosttingDate);
                        DetailCustLedEntry.Modify();
                    until DetailCustLedEntry.Next = 0;
                END;

                ValueEntry.Reset();
                ValueEntry.SetRange("Document No.", DocumentNo);
                IF ValueEntry.FindFirst then begin
                    repeat
                        ValueEntry.Validate("Posting Date", PosttingDate);
                        ValueEntry.Modify();
                    until ValueEntry.Next = 0;
                END;

                ResLedEntry.Reset();
                ResLedEntry.SetRange("Document No.", DocumentNo);
                IF ResLedEntry.FindFirst then begin
                    repeat
                        ResLedEntry.Validate("Posting Date", PosttingDate);
                        ResLedEntry.Modify();
                    until ResLedEntry.Next = 0;
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
                    field(DocumentNo; DocumentNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Document No.';
                    }
                    field(PosttingDate; PosttingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date';
                    }
                    field(DueDate; DueDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Due Date';
                    }
                }
            }
        }

        actions
        {
        }
    }

    var
        DocumentNo: Code[20];
        PosttingDate: Date;
        DueDate: Date;
}