pageextension 50221 "Purchase Order Subform_Ext" extends "Purchase Order Subform"
{
    layout
    {
        modify("Description 2")
        {
            Visible = true;
        }
        // modify(Quantity)
        // {
        //     Editable = false;
        // }
        addafter("Bin Code")
        {
            field("Original Quantity"; Rec."Original Quantity")
            {
                //Caption = 'Quantity';
                ApplicationArea = all;
            }
            field("Quantity Variance %"; Rec."Quantity Variance %")
            {
                ApplicationArea = all;
            }
        }
        addafter(Quantity)
        {
            field("Outstanding Quantity"; Rec."Outstanding Quantity")
            {
                ApplicationArea = all;
            }
            field("Min. Order Qty."; Rec."Min. Order Qty.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Over-Receipt Code")
        {
            field("Priority Qty"; Rec."Priority Qty")
            {
                ApplicationArea = all;
            }
            field("Priority Date"; Rec."Priority Date")
            {
                ApplicationArea = all;
            }
            field("Priority Qty 2"; Rec."Priority Qty 2")
            {
                ApplicationArea = all;
            }
            field("Priority Date 2"; Rec."Priority Date 2")
            {
                ApplicationArea = all;
            }
            field("Priority Qty 3"; Rec."Priority Qty 3")
            {
                ApplicationArea = all;
            }
            field("Priority Date 3"; Rec."Priority Date 3")
            {
                ApplicationArea = all;
            }
            field("Balance Qty"; Rec."Balance Qty")
            {
                //Visible = false;
                ApplicationArea = all;
            }
            field("Ready Goods Qty"; Rec."Ready Goods Qty")
            {
                //Visible = false;
                ApplicationArea = all;
            }
            field("Ready Goods Comment"; Rec."Ready Goods Comment")
            {
                //Visible = false;
                ApplicationArea = all;
            }
            field("Shipped Air"; Rec."Shipped Air")
            {
                //Visible = false;
                ApplicationArea = all;
            }
            field("Shipped Boat"; Rec."Shipped Boat")
            {
                //Visible = false;
                ApplicationArea = all;
            }
            field("Shipping Hold"; Rec."Shipping Hold")
            {
                //Visible = false;
                ApplicationArea = all;
            }
            field("Shipping Comment"; Rec."Shipping Comment")
            {
                //Visible = false;
                ApplicationArea = all;
            }
            field(Amount; Rec.Amount)
            {
                Visible = false;
                ApplicationArea = all;
            }

            field("Last Change"; Rec."Last Change")
            {
                Visible = false;
                ApplicationArea = all;
            }
            field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
            {
                Visible = false;
                ApplicationArea = all;
            }
            field(Comment; Rec.Comment)
            {
                ApplicationArea = all;
            }
            field(Backing; Rec.Backing)
            {
                ApplicationArea = all;
            }
            field("Comment for Vendor"; Rec."Comment for Vendor")
            {
                ApplicationArea = all;
            }
        }
    }
}
