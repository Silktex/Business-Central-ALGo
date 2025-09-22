report 80001 UpdatePaymentTerminSalesInv
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
                    SalesInvoiceHeader.Validate("Payment Terms Code", PaymentTerm);
                    SalesInvoiceHeader.Validate("Due Date", DueDate);
                    SalesInvoiceHeader.Modify();
                END;


                CustLedgEntry.Reset();
                CustLedgEntry.SetRange("Document No.", DocumentNo);
                IF CustLedgEntry.FindFirst then begin
                    repeat
                        CustLedgEntry.Validate("Due Date", DueDate);
                        CustLedgEntry.Modify();
                    until CustLedgEntry.Next = 0;
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
                    field(PaymentTerm; PaymentTerm)
                    {
                        ApplicationArea = All;
                        Caption = 'Payment Term';
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
        PaymentTerm: Code[10];
        DueDate: Date;
}