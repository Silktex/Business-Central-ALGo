page 50104 "Auto Email Setup"
{
    PageType = List;
    SourceTable = "Auto Email Setup";
    UsageCategory = Administration;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Report ID"; Rec."Report Id")
                {
                    ApplicationArea = all;
                }
                field("Email Name"; Rec."Email Name")
                {
                    ApplicationArea = all;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("Email ID"; Rec."Email ID")
                {
                    ApplicationArea = all;
                }

            }
        }
    }

}

