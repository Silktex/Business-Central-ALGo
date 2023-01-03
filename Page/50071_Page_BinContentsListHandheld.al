page 50071 "Bin Contents List Handheld"
{
    DataCaptionExpression = Rec.GetCaption;
    Editable = false;
    PageType = List;
    SourceTable = "Bin Content";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                }
                field("Zone Code"; Rec."Zone Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = all;
                }
                field(CalcQtyUOM; Rec.CalcQtyUOM)
                {
                    ApplicationArea = all;
                    Caption = 'Quantity';
                    DecimalPlaces = 0 : 5;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if Initialized then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Location Code", LocationCode);
            Rec.FilterGroup(0);
        end;
    end;

    var
        LocationCode: Code[10];
        Initialized: Boolean;


    procedure Initialize(LocationCode2: Code[10])
    begin
        LocationCode := LocationCode2;
        Initialized := true;
    end;
}

