page 50001 "Bin Inventory"
{
    Caption = 'Bin Inventory';
    PageType = ListPart;
    SourceTable = "Bin Content";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location code of the bin.';
                    Visible = false;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bin where the items are picked or put away.';
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many units of the item, in the base unit of measure, are stored in the bin.';
                }
            }
        }
    }
}
