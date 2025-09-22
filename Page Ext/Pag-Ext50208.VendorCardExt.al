pageextension 50208 "Vendor Card_Ext" extends "Vendor Card"
{
    layout
    {
        addafter("E-Mail")
        {

            field("Email CC"; Rec."Email CC")
            {
                ApplicationArea = all;
            }
        }
        modify("Name 2")
        {
            Visible = true;
            CaptionML = ENU = 'Short Name',
                           ESM = 'Nombre 2',
                           FRC = 'Nom 2',
                           ENC = 'Name 2';
        }
        modify("Shipping Agent Code")
        {
            Visible = true;
            ApplicationArea = all;
        }
    }

}
