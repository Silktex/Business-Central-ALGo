page 50009 "Box Master List"
{
    PageType = List;
    SourceTable = "Box Master";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Box Code"; Rec."Box Code")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field(Height; Rec.Height)
                {
                    ApplicationArea = all;
                }
                field(Width; Rec.Width)
                {
                    ApplicationArea = all;
                }
                field(Length; Rec.Length)
                {
                    ApplicationArea = all;
                }
                field("Box Weight"; Rec."Box Weight")
                {
                    ApplicationArea = all;
                }
                field("Show in Handheld"; Rec."Show in Handheld")
                {
                    ApplicationArea = all;
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec.GetFilter("Shipping Agent Service Code") <> '' then
            Rec."Shipping Agent Service Code" := Rec.GetFilter("Shipping Agent Service Code");
    end;

    trigger OnOpenPage()
    begin
        //ApplyFilters;
    end;

    procedure ApplyFilters()
    begin
        if Rec.GetFilter("Shipping Agent Service Code") <> '' then
            Rec.SetRange("Shipping Agent Service Code", Rec.GetFilter("Shipping Agent Service Code"));
    end;
}

