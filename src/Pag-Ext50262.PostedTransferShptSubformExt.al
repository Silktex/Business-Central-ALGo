pageextension 50262 PostedTransferShptSubform_Ext extends "Posted Transfer Shpt. Subform"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("Purchase Receipt No."; Rec."Purchase Receipt No.")
            {
                ApplicationArea = all;
            }
        }
        addlast(Control1)
        {
            field("Sales Order No."; Rec."Sales Order No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Sales Order Line No."; Rec."Sales Order Line No.")
            {
                ApplicationArea = all;
                Editable = false;
            }

        }
    }
}
