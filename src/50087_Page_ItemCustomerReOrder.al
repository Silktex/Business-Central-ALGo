page 50087 "Item Customer Re-Order"
{
    PageType = List;
    SourceTable = "Item Customer Re-Order";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Customer Name 2"; Rec."Customer Name 2")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("O&rder")
            {
                Caption = 'O&rder';
                Image = "Order";
                action("Posted Sales Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Invoice Line';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    RunObject = Page "Sales Invoice Line New";
                    RunPageLink = "Sell-to Customer No." = FIELD("Customer No."),
                                  "No." = FIELD("Item No.");
                    RunPageView = SORTING("Document No.", "Line No.")
                                  WHERE(Type = FILTER(Item));
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    var
                        Handled: Boolean;
                    begin
                    end;
                }
                action("Sales Order")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Order Line';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    RunObject = Page "Sales Lines New";
                    RunPageLink = "Sell-to Customer No." = FIELD("Customer No."),
                                  "No." = FIELD("Item No.");
                    RunPageView = SORTING("Document No.", "Line No.")
                                  WHERE(Type = FILTER(Item));
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    var
                        Handled: Boolean;
                    begin
                    end;
                }
                action("Missing Item Cross Ref")
                {
                    ApplicationArea = All;
                    Image = "Report";
                    RunObject = Report "Missing Item Cross Ref";
                }
            }
        }
    }
}

