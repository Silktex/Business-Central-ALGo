page 50017 "Item Customer Catalog"
{
    PageType = List;
    SourceTable = "Item Customer";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'Customer No.';
                }
                field("Customer Item No."; Rec."Customer Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Item No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

