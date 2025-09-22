pageextension 50276 "Purchase Prices_Ext" extends "Purchase Price List Lines"
{

    layout
    {
        // addbefore("Vendor No.")
        // {
        //     field("Purchase Type"; Rec."Purchase Type")
        //     {
        //         ApplicationArea = all;
        //     }
        // }
        modify(SourceNo)
        {
            CaptionML = ENU = 'Purchase Code', ESM = 'N§ proveedor', FRC = 'Nø fournisseur', ENC = 'Vendor No.';
        }
        // addafter("Vendor No.")
        // {
        //     field("Product Type"; Rec."Product Type")
        //     {
        //         ApplicationArea = all;
        //     }
        // }
    }

    trigger OnOpenPage()
    begin
        Rec.SETRANGE("Ending Date", 0D);
    end;
}
