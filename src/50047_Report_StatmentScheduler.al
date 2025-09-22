report 50047 "Statment Scheduler"
{
    ProcessingOnly = true;

    dataset
    {
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
                    field(ScheduleDay; ScheduleDay)
                    {
                        Caption = 'Schedule Day';
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            ScheduleDay := DATE2DWY(WORKDATE, 1);
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        recCustomer.RESET;
        IF ScheduleDay <> 0 THEN
            recCustomer.SETRANGE(recCustomer."Schedule Day", ScheduleDay)
        ELSE
            recCustomer.SETRANGE(recCustomer."Schedule Day", DATE2DWY(WORKDATE, 1));
        IF recCustomer.FINDFIRST THEN
            REPEAT
                CustLedgerEntry.RESET;
                CustLedgerEntry.SETRANGE(CustLedgerEntry."Customer No.", recCustomer."No.");
                CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Invoice);
                CustLedgerEntry.SETFILTER("Remaining Amount", '<>%1', 0);
                CustLedgerEntry.SETFILTER("Due Date", '<%1', WORKDATE);
                IF CustLedgerEntry.FINDFIRST THEN
                    SMTPMail.SendCustomerStatmentAsPDF(recCustomer);
            UNTIL recCustomer.NEXT = 0;
    end;

    var
        ScheduleDay: Option " ",Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
        recCustomer: Record Customer;
        SMTPMail: Codeunit SmtpMail_Ext;
        CustLedgerEntry: Record "Cust. Ledger Entry";
}

