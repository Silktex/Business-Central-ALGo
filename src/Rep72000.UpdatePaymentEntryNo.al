report 72000 UpdatePaymentEntryNo
{
    ApplicationArea = All;
    Caption = 'UpdatePaymentEntryNo';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(DOPaymentTransLogEntry; "DO Payment Trans. Log Entry")
        {
            trigger OnAfterGetRecord()
            begin
                if "Payment Entry No." = 0 then begin
                    "Payment Entry No." := "Entry No.";
                    Modify();
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
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
        Message('Done');
    end;
}
