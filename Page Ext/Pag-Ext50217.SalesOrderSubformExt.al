pageextension 50217 "Sales Order Subform_Ext" extends "Sales Order Subform"
{
    layout
    {
        addafter("Variant Code")
        {
            field(Backing; Rec.Backing)
            {
                ApplicationArea = all;
            }
        }
        modify(Quantity)
        {
            Visible = false;
        }
        addafter(Quantity)
        {
            field("Original Quantity"; Rec."Original Quantity")
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                Caption = 'Quantity';
                Editable = NOT IsCommentLine;
                Enabled = NOT IsCommentLine;
                ShowMandatory = (NOT IsCommentLine) AND (Rec."No." <> '');
                ToolTip = 'Specifies how many units are being sold.';

                trigger OnValidate()
                begin
                    QuantityOnAfterValidate;
                    DeltaUpdateTotals;
                end;
            }
            field("Minimum Qty"; Rec."Minimum Qty")
            {
                ApplicationArea = all;
            }
            field(Quantity1; Rec.Quantity)
            {
                Caption = 'Quantity Assigned';
                Editable = false;
                ApplicationArea = all;
            }
        }
        addafter("Line No.")
        {
            field("Outstanding Quantity"; Rec."Outstanding Quantity")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field(Priority; Rec.Priority)
            {
                ApplicationArea = all;
            }
            field(Comments; Rec.Comments)
            {
                ApplicationArea = all;
            }
            field("Resource Line Created"; Rec."Resource Line Created")
            {
                ApplicationArea = all;
            }
            field("Comment Status"; Rec."Comment Status")
            {
                ApplicationArea = all;
            }
            field("Expiry Date"; Rec."Expiry Date")
            {
                ApplicationArea = all;
            }
        }
    }
}
