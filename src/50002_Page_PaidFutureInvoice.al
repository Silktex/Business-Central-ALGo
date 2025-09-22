page 50002 "Paid/Future Invoice"
{
    PageType = List;
    SourceTable = "Payment Future Old Inv";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        recFI.Reset;
                        recFI.SetRange(recFI."Journal Template Name", Rec."Journal Template Name");
                        recFI.SetRange(recFI."Journal Batch Name", Rec."Journal Batch Name");
                        recFI.SetRange(recFI."Document No.", Rec."Document No.");
                        recFI.SetRange(recFI."Document Line No.", Rec."Document Line No.");
                        recFI.SetFilter("Invoice No.", '<>%1', '');
                        recFI.SetFilter(Amount, '<>%1', 0);
                        if recFI.Find('-') then begin

                            recGJ.Reset;
                            if recGJ.Get(recFI."Journal Template Name", recFI."Journal Batch Name", recFI."Document Line No.") then begin
                                if not recGJ."For Future Invoice" then begin
                                    recGJ."For Future Invoice" := true;
                                    recGJ.Modify;
                                end;
                            end;
                        end else begin
                            recGJ.Reset;
                            if recGJ.Get(recFI."Journal Template Name", recFI."Journal Batch Name", recFI."Document Line No.") then begin
                                if recGJ."For Future Invoice" then begin
                                    recGJ."For Future Invoice" := false;
                                    recGJ.Modify;
                                end;
                            end;
                        end;
                    end;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        recFI.Reset;
                        recFI.SetRange(recFI."Journal Template Name", Rec."Journal Template Name");
                        recFI.SetRange(recFI."Journal Batch Name", Rec."Journal Batch Name");
                        recFI.SetRange(recFI."Document No.", Rec."Document No.");
                        recFI.SetRange(recFI."Document Line No.", Rec."Document Line No.");
                        recFI.SetFilter("Invoice No.", '<>%1', '');
                        recFI.SetFilter(Amount, '<>%1', 0);
                        if recFI.Find('-') then begin

                            recGJ.Reset;
                            if recGJ.Get(recFI."Journal Template Name", recFI."Journal Batch Name", recFI."Document Line No.") then begin
                                if not recGJ."For Future Invoice" then begin
                                    recGJ."For Future Invoice" := true;
                                    recGJ.Modify;
                                end;
                            end;
                        end else begin
                            recGJ.Reset;
                            if recGJ.Get(recFI."Journal Template Name", recFI."Journal Batch Name", recFI."Document Line No.") then begin
                                if recGJ."For Future Invoice" then begin
                                    recGJ."For Future Invoice" := false;
                                    recGJ.Modify;
                                end;
                            end;
                        end;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        recFI: Record "Payment Future Old Inv";
        recGJ: Record "Gen. Journal Line";
}

