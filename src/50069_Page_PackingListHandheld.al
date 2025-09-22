page 50069 "Packing List Handheld"
{
    Caption = 'Packing List';
    // CardPageID = "Voided Packing List"; //Page Discarded
    Editable = false;
    PageType = List;
    SourceTable = "Packing Header";
    SourceTableView = WHERE(Status = FILTER(<> Closed),
                            "Sales Order No." = FILTER(<> ''));

    layout
    {
        area(content)
        {
            repeater(Control1000000014)
            {
                ShowCaption = false;
                field("Packing No."; Rec."Packing No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = All;
                }
                field("Source Document Type"; Rec."Source Document Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    var
        cuPack: Codeunit Packing;
}

