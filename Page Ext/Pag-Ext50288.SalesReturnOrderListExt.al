pageextension 50288 "Sales Return Order List_Ext" extends "Sales Return Order List"
{
    actions
    {
        addafter(Reopen)
        {
            action(PrintLabel)
            {
                Caption = 'Print Label';
                Image = NewReceipt;
                Promoted = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                // ReportLabel: Report "Print PHP Label";
                begin
                    ReservationEntry.Reset;
                    ReservationEntry.SetRange(ReservationEntry."Source Type", 37);
                    ReservationEntry.SetRange(ReservationEntry."Source Subtype", 3);
                    ReservationEntry.SetRange(ReservationEntry."Source ID", Rec."No.");
                    ReservationEntry.SetRange(ReservationEntry.Positive, true);
                    if ReservationEntry.FindFirst then begin
                        repeat
                            // ReportLabel.PrintLable(ReservationEntry."Item No.", ReservationEntry."Lot No.", ReservationEntry.Quantity);
                            Message('Printed Successfully');
                        until ReservationEntry.Next = 0;
                    end;
                end;
            }
        }
    }
    var
        ReservationEntry: Record "Reservation Entry";
}
