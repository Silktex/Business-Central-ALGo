pageextension 50246 "Sales Lines_Ext" extends "Sales Lines"
{

    layout
    {
        addafter("No.")
        {
            field(CustomerName; CustomerName)
            {
                Caption = 'Customer Name';
                ToolTip = 'Customer Name';
                Visible = false;
                ApplicationArea = all;
            }
        }
        addafter("Package Tracking No.")
        {
            field("Promised Delivery Date"; Rec."Promised Delivery Date")
            {
                ApplicationArea = all;
            }
            field("Requested Delivery Date"; Rec."Requested Delivery Date")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("Item &Tracking Lines")
        {
            action(StandardComment)
            {
                Caption = 'Standard Comment';
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    CommentsalesNew: Page "Comment sales New";
                begin
                    CommentsalesNew.FilterFind(Rec."Document No.");
                    CommentsalesNew.Run;
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        recCustomer: Record customer;
    begin
        //>>SPD AK 13022015
        CLEAR(CustomerName);
        IF recCustomer.GET(Rec."Sell-to Customer No.") THEN
            CustomerName := recCustomer.Name;
        //<<SPD AK 13022015
    end;

    var
        CustomerName: Text;
}
