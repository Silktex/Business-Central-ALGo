page 50083 "Packing Lot Validation"
{
    PageType = List;
    SourceTable = "Registered Whse. Activity Line";
    SourceTableView = SORTING("Activity Type", "No.", "Line No.")
                      WHERE("Source Document" = FILTER("Sales Order"),
                            "Whse. Document Type" = FILTER(Shipment),
                            "Activity Type" = FILTER(Pick),
                            "Action Type" = FILTER(Take),
                            "Source Type" = FILTER(37),
                            "Source Subtype" = FILTER("1"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Source Document"; Rec."Source Document")
                {
                    ApplicationArea = All;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = All;
                }
                field("Whse. Document Type"; Rec."Whse. Document Type")
                {
                    ApplicationArea = All;
                }
                field("Whse. Document No."; Rec."Whse. Document No.")
                {
                    ApplicationArea = All;
                }
                field("Whse. Document Line No."; Rec."Whse. Document Line No.")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
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

