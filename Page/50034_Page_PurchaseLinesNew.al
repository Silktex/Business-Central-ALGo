page 50034 "Purchase Lines New"
{
    // //>>SPD AK 0224201 code added for get vendor name;

    Caption = 'Purchase Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Purchase Line";

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
                field(VendorName; VendorName)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Name';
                    ToolTip = 'Vendor Name';
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                }
                field("Promised Receipt Date"; Rec."Promised Receipt Date")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = All;
                }
                field("Ready Goods Qty"; Rec."Ready Goods Qty")
                {
                    ApplicationArea = All;
                }
                field("Last Change"; Rec."Last Change")
                {
                    ApplicationArea = All;
                }
                field("Shipped Air"; Rec."Shipped Air")
                {
                    ApplicationArea = All;
                }
                field("Shipped Boat"; Rec."Shipped Boat")
                {
                    ApplicationArea = All;
                }
                field("Shipping Hold"; Rec."Shipping Hold")
                {
                    ApplicationArea = All;
                }
                field("Balance Qty"; Rec."Balance Qty")
                {
                    ApplicationArea = All;
                }
                field("ETA Date"; Rec."ETA Date")
                {
                    ApplicationArea = All;
                }
                field("Priority Qty"; Rec."Priority Qty")
                {
                    ApplicationArea = All;
                }
                field("Ready Goods Comment"; Rec."Ready Goods Comment")
                {
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
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
                        PurchHeader.Get(Rec."Document Type", Rec."Document No.");
                        case Rec."Document Type" of
                            Rec."Document Type"::Quote:
                                PAGE.Run(PAGE::"Purchase Quote", PurchHeader);
                            Rec."Document Type"::Order:
                                PAGE.Run(PAGE::"Purchase Order", PurchHeader);
                            Rec."Document Type"::Invoice:
                                PAGE.Run(PAGE::"Purchase Invoice", PurchHeader);
                            Rec."Document Type"::"Return Order":
                                PAGE.Run(PAGE::"Purchase Return Order", PurchHeader);
                            Rec."Document Type"::"Credit Memo":
                                PAGE.Run(PAGE::"Purchase Credit Memo", PurchHeader);
                            Rec."Document Type"::"Blanket Order":
                                PAGE.Run(PAGE::"Blanket Purchase Order", PurchHeader);
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
        recVendor: Record Vendor;
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        //>>SPD AK 02242015
        Clear(VendorName);
        if recVendor.Get(Rec."Buy-from Vendor No.") then
            VendorName := recVendor.Name;
        //<<SPD AK 02242015
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ShortcutDimCode);
    end;

    var
        PurchHeader: Record "Purchase Header";
        ShortcutDimCode: array[8] of Code[20];
        VendorName: Text[100];
}

