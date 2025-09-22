pageextension 50252 "Salesperson/Purchaser Card_Ext" extends "Salesperson/Purchaser Card"
{
    layout
    {
        addafter("Privacy Blocked")
        {
            field("Active MIS"; Rec."Active MIS")
            {
                ApplicationArea = all;
            }
        }
        addafter(Invoicing)
        {
            group(EMailDocuments)
            {
                Caption = 'E Mail Documents';
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
            }
        }
    }
}
