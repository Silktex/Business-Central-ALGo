pageextension 50240 PostedPurchaseCreditMemos_Ext extends "Posted Purchase Credit Memos"
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("Return Order No."; Rec."Return Order No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
