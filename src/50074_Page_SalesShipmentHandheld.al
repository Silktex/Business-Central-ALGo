page 50074 "Sales Shipment Handheld"
{
    Caption = 'Posted Sales Shipments';
    CardPageID = "Posted Sales Shipment";
    Editable = false;
    PageType = List;
    SourceTable = "Sales Shipment Header";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Warehouse Shipment No."; Rec."Warehouse Shipment No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    var
        recPWSL: Record "Posted Whse. Shipment Line";
        recTrackingNo: Record "Tracking No.";
}

