page 50043 "Ecom Product List"
{
    CardPageID = "Ecom Product Card";
    PageType = List;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Name; Rec.Description)
                {
                    ApplicationArea = all;
                    Caption = 'Name';
                }
                field(ShortDescription; Rec.Description)
                {
                    ApplicationArea = all;
                    Caption = 'ShortDescription';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = all;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                }
                field(DisplayStockAvailability; Rec.DisplayStockAvailability)
                {
                    ApplicationArea = all;
                }
                field(DisplayStockQuantity; Rec.DisplayStockQuantity)
                {
                    ApplicationArea = all;
                }
                field(Published; Rec.Published)
                {
                    ApplicationArea = all;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = all;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = all;
                }
                field("Product Group Code"; Rec."Item Category Code")
                {
                    ApplicationArea = all;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = all;
                }
                field(Weight; Rec.Weight)
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

