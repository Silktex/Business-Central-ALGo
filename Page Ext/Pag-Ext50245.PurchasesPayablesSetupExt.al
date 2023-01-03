pageextension 50245 "Purchases & Payables Setup_Ext" extends "Purchases & Payables Setup"
{
    layout
    {
        modify("Combine Special Orders Default")
        {
            Visible = true;
            ApplicationArea = all;
        }
        addbefore("Allow Document Deletion Before")
        {
            field("Email Id"; Rec."Email Id")
            {
                ApplicationArea = all;
            }

            field("Allow Quantity Variance"; Rec."Allow Quantity Variance")
            {
                ApplicationArea = all;
            }
            field("Define % for Variance"; Rec."Define % for Variance")
            {
                ApplicationArea = all;
            }
        }
    }
}
