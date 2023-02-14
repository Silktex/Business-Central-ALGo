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
            field("Ready Goods Date"; Rec."Ready Goods Date")
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
            field("Balance Qty Date"; Rec."Balance Qty Date")
            {
                ApplicationArea = all;
            }
            field("Priority Qty"; Rec."Priority Qty")
            {
                ApplicationArea = all;
            }
            field("Priority Date"; Rec."Priority Date")
            {
                ApplicationArea = All;
            }
            field("Priority Qty 2"; Rec."Priority Qty 2")
            {
                ApplicationArea = All;
            }
            field("Priority Date 2"; Rec."Priority Date 2")
            {
                ApplicationArea = All;
            }
            field("Priority Qty 3"; Rec."Priority Qty 3")
            {
                ApplicationArea = All;
            }
            field("Priority Date 3"; Rec."Priority Date 3")
            {
                ApplicationArea = All;
            }
            field("Comment for Vendor"; Rec."Comment for Vendor")
            {
                ApplicationArea = All;
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
