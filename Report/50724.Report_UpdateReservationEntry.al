report 50724 UpdateReservationEntry
{
    Caption = 'Fix Transfer Rcpt. Tracking';
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = Administration;

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
                    field(EntryNo; EntryNo)
                    {
                        Caption = 'Entry No.';
                        ApplicationArea = All;
                    }
                    field(Qty; Qty)
                    {
                        ApplicationArea = All;
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

    trigger OnPreReport()
    begin
        if EntryNo = 0 then
            Error('Entry No. must not be zero.');

        if Qty = 0 then
            error('Qty must not be zero.')
    end;

    trigger OnPostReport()
    begin
        ResEntry.Reset();
        ResEntry.SetRange("Entry No.", EntryNo);
        ResEntry.SetRange("Source Type", 5741);
        ResEntry.SetRange("Source Subtype", 1);
        ResEntry.SetRange(Positive, true);
        if ResEntry.FindFirst() then begin
            ResEntry.Validate("Quantity (Base)", Qty);
            ResEntry.Modify(false);
        end;
    end;

    var

        EntryNo: Integer;
        Qty: Decimal;
        ResEntry: Record "Reservation Entry";
}
