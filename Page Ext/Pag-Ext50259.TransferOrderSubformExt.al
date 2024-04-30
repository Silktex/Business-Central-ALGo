pageextension 50259 "Transfer Order Subform_Ext" extends "Transfer Order Subform"
{
    layout
    {
        addafter("ShortcutDimCode[8]")
        {
            field("Document No."; Rec."Document No.")
            {
                ApplicationArea = all;
                CaptionML = ENU = 'No.', ESM = 'N§ documento', FRC = 'Nø de document', ENC = 'Document No.';
            }
            field("Transfer-from Code"; Rec."Transfer-from Code")
            {
                ApplicationArea = all;
            }
            field("Transfer-to Code"; Rec."Transfer-to Code")
            {
                ApplicationArea = all;
            }
            field(Status; Rec.Status)
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
            field("SLK Instructions"; Rec."SLK Instructions")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Instructions field.';
            }


        }
    }
}
