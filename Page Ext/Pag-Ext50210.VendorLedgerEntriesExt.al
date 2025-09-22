pageextension 50210 "Vendor Ledger Entries_Ext" extends "Vendor Ledger Entries"
{
    layout
    {
        // addafter("Document No.")
        // {
        //     field("Document Date"; Rec."Document Date")
        //     {
        //         ApplicationArea = all;
        //     }
        // }
        //moveafter("Document Date"; "Due Date")
        modify("Due Date")
        {
            Visible = true;
        }
        addafter("Exported to Payment File")
        {
            field(Skip; Rec.Skip)
            {
                ApplicationArea = all;
            }
        }
    }

}
