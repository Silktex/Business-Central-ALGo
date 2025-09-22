page 60000 "DO Payment Card Type List"
{
    Caption = 'Card Type List';
    PageType = List;
    SourceTable = "DO Payment Card Type";
    SourceTableView = SORTING("Sort Order")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if not Rec.FindFirst then
            Rec.CreateDefaults;
    end;
}

