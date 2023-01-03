page 50057 "Sales Order Subform Handheld"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "Sales Line";
    SourceTableView = WHERE("Document Type" = FILTER(Order),
                            Type = FILTER(Item));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Order No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Order No.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Order Item No.';
                }
                field("Original Quantity"; Rec."Original Quantity")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Quantity';
                }
                field("Minimum Qty"; Rec."Minimum Qty")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity Assigned';
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Item Name';
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = All;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = All;
                }
                field("Shipping Agent Service Des"; Rec."Shipping Agent Service Des")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    var
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
    begin
    end;

    procedure CreateWarehouseShipment()
    var
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
        SH: Record "Sales Header";
    begin
        SH.Reset;
        SH.SetRange("No.", Rec."Document No.");
        if SH.FindFirst then
            GetSourceDocOutbound.CreateFromSalesOrder(SH);
    end;
}

