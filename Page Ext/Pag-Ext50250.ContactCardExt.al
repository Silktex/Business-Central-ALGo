pageextension 50250 "Contact Card_Ext" extends "Contact Card"
{
    layout
    {
        modify("E-Mail")
        {
            Visible = true;
        }
        addafter("Post Code")
        {
            field("Credit Card Contact"; Rec."Credit Card Contact")
            {
                ApplicationArea = all;
            }
        }
        addafter("Language Code")
        {
            field("Mail To"; Rec."Mail To")
            {
                ApplicationArea = all;
            }
            field("Mail CC"; Rec."Mail CC")
            {
                ApplicationArea = all;
            }
            field("Mail BCC"; Rec."Mail BCC")
            {
                Visible = false;
                ApplicationArea = all;
            }
            field("Entity ID"; Rec."Entity ID")
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
            field("Customer Ledger"; Rec."Customer Ledger")
            {
                ApplicationArea = all;
            }
            field("Purchase Order"; Rec."Purchase Order")
            {
                ApplicationArea = all;
            }
            field("Vendor Ledger"; Rec."Vendor Ledger")
            {
                ApplicationArea = all;
            }
            field("Expired Price"; Rec."Expired Price")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {

    }
    trigger OnClosePage()
    begin
        //>>Ashwini
        IF Rec."Phone No." = '' THEN
            MESSAGE('Pleasr fill Phone No.');
        IF Rec."E-Mail" = '' THEN
            MESSAGE('Please fill email.');
        //<<Ashwini
    end;
}
