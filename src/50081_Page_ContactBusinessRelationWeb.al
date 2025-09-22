page 50081 "Contact Business Relation-Web"
{
    Caption = 'Contact Business Relations';
    DataCaptionFields = "Contact No.";
    PageType = List;
    SourceTable = "Contact Business Relation";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = all;
                }
                field("Contact Name"; Rec."Contact Name")
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Link to Table"; Rec."Link to Table")
                {
                    ApplicationArea = all;
                }
                field("Business Relation Code"; Rec."Business Relation Code")
                {
                    ApplicationArea = all;
                }
                field("Business Relation Description"; Rec."Business Relation Description")
                {
                    ApplicationArea = all;
                    DrillDown = false;
                }
            }
        }
    }

    actions
    {
    }
}

