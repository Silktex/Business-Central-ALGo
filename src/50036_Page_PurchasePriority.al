page 50036 "Purchase Priority"
{
    PageType = List;
    SourceTable = "Purchase Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Priority Qty"; Rec."Priority Qty")
                {
                    ApplicationArea = All;
                }
                field("Priority Date"; Rec."Priority Date")
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

