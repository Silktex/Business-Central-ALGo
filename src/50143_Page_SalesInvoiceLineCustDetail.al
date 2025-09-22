page 50143 "Sales Invoice LineCust Detail"
{
    AutoSplitKey = true;
    Caption = 'Sales Invoice Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Invoice Line";
    SourceTableView = WHERE(Quantity = FILTER(<> 0));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(ShowDocument)
                {
                    ApplicationArea = All;
                    Caption = 'Show Document';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        if SalesInvHeader.Get(Rec."Document No.") then
                            PAGE.Run(PAGE::"Posted Sales Invoice", SalesInvHeader);
                    end;
                }
                action(Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        Rec.ShowLineComments;
                    end;
                }
                action(ItemTrackingEntries)
                {
                    ApplicationArea = All;
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;

                    trigger OnAction()
                    begin
                        Rec.ShowItemTrackingLines;
                    end;
                }
                action("Item Shipment &Lines")
                {
                    ApplicationArea = All;
                    Caption = 'Item Shipment &Lines';
                    Image = ShipmentLines;

                    trigger OnAction()
                    begin
                        if not (Rec.Type in [Rec.Type::Item, Rec.Type::"Charge (Item)"]) then
                            Rec.TestField(Type);
                        Rec.ShowItemShipmentLines;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //>>SPD AK 13022015
        Clear(CustomerName);
        if recCustomer.Get(Rec."Sell-to Customer No.") then
            CustomerName := recCustomer.Name;
        //<<SPD AK 13022015
    end;

    var
        SalesInvHeader: Record "Sales Invoice Header";
        recCustomer: Record Customer;
        CustomerName: Text[100];
}

