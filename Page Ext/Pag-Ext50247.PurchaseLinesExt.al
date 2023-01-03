pageextension 50247 "Purchase Lines_Ext" extends "Purchase Lines"
{
    layout
    {
        addafter("No.")
        {
            field(VendorName; VendorName)
            {
                Caption = 'Vendor Name';
                ToolTip = 'Vendor Name';
                Visible = false;
                ApplicationArea = all;
            }
        }
        addafter(Quantity)
        {
            field("Quantity Received"; Rec."Quantity Received")
            {
                ApplicationArea = all;
            }
            field("Quantity Invoiced"; Rec."Quantity Invoiced")
            {
                ApplicationArea = all;
            }
        }
        addafter("Amt. Rcd. Not Invoiced (LCY)")
        {
            field("Promised Receipt Date"; Rec."Promised Receipt Date")
            {
                ApplicationArea = all;
            }
            field("Ready Goods Qty"; Rec."Ready Goods Qty")
            {
                ApplicationArea = all;
            }
            field("Shipped Air"; Rec."Shipped Air")
            {
                ApplicationArea = all;
            }
            field("Shipped Boat"; Rec."Shipped Boat")
            {
                ApplicationArea = all;
            }
            field("Shipping Hold"; Rec."Shipping Hold")
            {
                ApplicationArea = all;
            }
            field("Balance Qty"; Rec."Balance Qty")
            {
                ApplicationArea = all;
            }
            field("Priority Qty"; Rec."Priority Qty")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {

    }
    trigger OnAfterGetRecord()
    var
        recVendor: Record Vendor;
    begin
        //>>SPD AK 02242015
        CLEAR(VendorName);
        IF recVendor.GET(Rec."Buy-from Vendor No.") THEN
            VendorName := recVendor.Name;
        //<<SPD AK 02242015
    end;

    var
        VendorName: Text;
}
