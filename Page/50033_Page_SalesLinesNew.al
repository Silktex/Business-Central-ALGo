page 50033 "Sales Lines New"
{
    // //SPD AK 13022015

    Caption = 'Sales Lines';
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Line";

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
                field(ExternalDocumentNo; ExternalDocumentNo)
                {
                    ApplicationArea = All;
                    Caption = 'External Document No';
                    Editable = false;
                }
                field(OrderDate; OrderDate)
                {
                    ApplicationArea = All;
                    Caption = 'Order Date';
                }
                field(CustomerName; CustomerName)
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                    ToolTip = 'Customer Name';
                }
                field("Promised Delivery Date"; Rec."Promised Delivery Date")
                {
                    ApplicationArea = All;
                }
                field("Minimum Qty"; Rec."Minimum Qty")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = All;
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = All;
                }
                field("Comment Status"; Rec."Comment Status")
                {
                    ApplicationArea = All;
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = All;
                    Editable = false;
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
                action("Show Document")
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
                        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
                        case Rec."Document Type" of
                            Rec."Document Type"::Quote:
                                PAGE.Run(PAGE::"Sales Quote", SalesHeader);
                            Rec."Document Type"::Order:
                                PAGE.Run(PAGE::"Sales Order", SalesHeader);
                            Rec."Document Type"::Invoice:
                                PAGE.Run(PAGE::"Sales Invoice", SalesHeader);
                            Rec."Document Type"::"Return Order":
                                PAGE.Run(PAGE::"Sales Return Order", SalesHeader);
                            Rec."Document Type"::"Credit Memo":
                                PAGE.Run(PAGE::"Sales Credit Memo", SalesHeader);
                            Rec."Document Type"::"Blanket Order":
                                PAGE.Run(PAGE::"Blanket Sales Order", SalesHeader);
                        end;
                    end;
                }
                action("Reservation Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Reservation Entries';
                    Image = ReservationLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Rec.ShowReservationEntries(true);
                    end;
                }
                action("Item &Tracking Lines")
                {
                    ApplicationArea = All;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        Rec.OpenItemTrackingLines;
                    end;
                }
            }

        }

    }

    trigger OnAfterGetRecord()
    var
        recCustomer: Record Customer;
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        //>>SPD AK 13022015
        Clear(CustomerName);
        Clear(OrderDate);
        if recCustomer.Get(Rec."Sell-to Customer No.") then
            CustomerName := recCustomer.Name;
        if SalesHeader.Get(Rec."Document Type"::Order, Rec."Document No.") then
            OrderDate := SalesHeader."Order Date";
        //<<SPD AK 13022015

        if SalesHeader.Get(Rec."Document Type"::Order, Rec."Document No.") then
            ExternalDocumentNo := SalesHeader."External Document No.";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ShortcutDimCode);
    end;

    var
        CustomerDetails: Page "Ecom Customer List";
        SalesHeader: Record "Sales Header";
        OrderDate: Date;
        ShortcutDimCode: array[8] of Code[20];
        CustomerName: Text[100];
        ExternalDocumentNo: Code[35];
}

