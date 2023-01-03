pageextension 50251 ContactList_Ext extends "Contact List"
{
    layout
    {
        moveafter("Salesperson Code"; "E-Mail")

        modify("E-Mail")
        {
            ApplicationArea = all;
            Visible = true;
        }

        addafter("Search Name")
        {
            field("Credit Card Contact"; Rec."Credit Card Contact")
            {
                ApplicationArea = all;
            }
            field("Sales Order"; Rec."Sales Order")
            {
                ApplicationArea = all;
            }
            field("Sales Shipment"; Rec."Sales Shipment")
            {
                ApplicationArea = all;
            }
            field("Sales Invoice"; Rec."Sales Invoice")
            {
                ApplicationArea = all;
            }
            field("Expired Price"; Rec."Expired Price")
            {
                ApplicationArea = all;
            }
        }
    }
}
