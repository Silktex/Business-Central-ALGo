page 50055 "Handheld Login"
{
    PageType = List;
    SourceTable = "Handheld Login";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                }
                field(Password; Rec.Password)
                {
                    ApplicationArea = All;
                }
                field("Warehouse Employee"; Rec."Warehouse Employee")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }
}

