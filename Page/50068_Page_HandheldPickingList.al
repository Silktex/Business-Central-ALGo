page 50068 "Handheld Picking List"
{
    Caption = 'Picking List';
    Editable = false;
    PageType = List;
    SourceTable = "Warehouse Activity Line";
    SourceTableView = WHERE("Line No." = FILTER(10000),
                            "Source Document" = FILTER("Outbound Transfer" | "Sales Order"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Picking No.';
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Order No.';
                }
                field("Source Document"; Rec."Source Document")
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
        Text000: Label 'Warehouse Put-away Lines';
        Text001: Label 'Warehouse Pick Lines';
        Text002: Label 'Warehouse Movement Lines';
        Text003: Label 'Warehouse Activity Lines';
        Text004: Label 'Inventory Put-away Lines';
        Text005: Label 'Inventory Pick Lines';

    local procedure FormCaption(): Text[250]
    begin
    end;
}

