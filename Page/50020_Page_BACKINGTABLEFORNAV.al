page 50020 "BACKING TABLE FOR NAV"
{
    DeleteAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    ShowFilter = true;
    SourceTable = "BACKING TABLE FOR NAV";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer Type"; Rec."Customer Type")
                {
                    ApplicationArea = all;
                }
                field("Customer Code"; Rec."Customer Code")
                {
                    ApplicationArea = all;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = all;
                }
                field("Product Code"; Rec."Product Code")
                {
                    ApplicationArea = all;
                }
                field("Resc. Code"; Rec."Resc. Code")
                {
                    ApplicationArea = all;
                }
                field("Resc. Price"; Rec."Resc. Price")
                {
                    ApplicationArea = all;
                }
                field("Last Modified User"; Rec."Last Modified User")
                {
                    ApplicationArea = all;
                }
                field("Last Modified Date"; Rec."Last Modified Date")
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

