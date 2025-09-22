page 50037 "Sales Quote Lines New"
{
    // //SPD AK 13022015

    Caption = 'Sales Quote Lines New';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Sales Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Document Type"; Rec."Document Type")
                {
                    Applicationarea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    Applicationarea = all;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    Applicationarea = all;
                }
                field("Line No."; Rec."Line No.")
                {
                    Applicationarea = all;
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    Applicationarea = all;
                }
                field("No."; Rec."No.")
                {
                    Applicationarea = all;
                }
                field(CustomerName; CustomerName)
                {
                    Applicationarea = all;
                    Caption = 'Customer Name';
                    ToolTip = 'Customer Name';
                    Visible = false;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Applicationarea = all;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    Applicationarea = all;
                }
                field("Package Tracking No."; Rec."Package Tracking No.")
                {
                    Applicationarea = all;
                    Visible = false;
                }
                field("Promised Delivery Date"; Rec."Promised Delivery Date")
                {
                    Applicationarea = all;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    Applicationarea = all;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Applicationarea = all;
                    Visible = true;
                }
                field(Reserve; Rec.Reserve)
                {
                    Applicationarea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    Applicationarea = all;
                }
                field("Reserved Qty. (Base)"; Rec."Reserved Qty. (Base)")
                {
                    Applicationarea = all;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Applicationarea = all;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    Applicationarea = all;
                    BlankZero = true;
                }
                field("Job No."; Rec."Job No.")
                {
                    Applicationarea = all;
                    Visible = false;
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    Applicationarea = all;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Applicationarea = all;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Applicationarea = all;
                    Visible = false;
                }
                field("ShortcutDimCode[3]"; ShortcutDimCode[3])
                {
                    Applicationarea = all;
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]"; ShortcutDimCode[4])
                {
                    Applicationarea = all;
                    CaptionClass = '1,2,4';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]"; ShortcutDimCode[5])
                {
                    Applicationarea = all;
                    CaptionClass = '1,2,5';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]"; ShortcutDimCode[6])
                {
                    Applicationarea = all;
                    CaptionClass = '1,2,6';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]"; ShortcutDimCode[7])
                {
                    Applicationarea = all;
                    CaptionClass = '1,2,7';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]"; ShortcutDimCode[8])
                {
                    Applicationarea = all;
                    CaptionClass = '1,2,8';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    Applicationarea = all;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Show Document")
                {
                    Applicationarea = all;
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
                    Applicationarea = all;
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
                    Applicationarea = all;
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
        if recCustomer.Get(Rec."Sell-to Customer No.") then
            CustomerName := recCustomer.Name;
        //<<SPD AK 13022015
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ShortcutDimCode);
    end;

    var
        SalesHeader: Record "Sales Header";
        ShortcutDimCode: array[8] of Code[20];
        CustomerName: Text[100];
}

