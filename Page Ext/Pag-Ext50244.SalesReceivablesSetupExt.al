pageextension 50244 "Sales & Receivables Setup_Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        modify("Write-in Product Type")
        {
            Visible = true;
        }
        addafter("Archive Return Orders")
        {
            field("Email Id"; Rec."Email Id")
            {
                ApplicationArea = all;
            }
            field("Start Date"; Rec."Start Date")
            {
                ApplicationArea = all;
            }
            field("End Date"; Rec."End Date")
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
            field("Custom Price Mgmt. Enabled"; Rec."Custom Price Mgmt. Enabled")
            {
                ApplicationArea = all;
            }
        }

        addlast(General)
        {
            field("Show Project Info"; Rec."Show Project Info")
            {
                ApplicationArea = All;
            }
        }
    }
}
