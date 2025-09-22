tableextension 50261 "Purchase Price_ext" extends "Purchase Price"
{

    fields
    {
        field(50000; "Purchase Type"; Option)
        {
            ObsoleteState = Removed;
            ObsoleteTag = '25.0';
            Caption = 'Purchase Type';
            OptionCaption = 'Vendor,All Vendors';
            OptionMembers = Vendor,"All Vendors";

            trigger OnValidate()
            begin
                /*
                IF "Purchase Type" <> xRec."Purchase Type" THEN BEGIN
                  VALIDATE("Vendor No.",'');
                  UpdateValuesFromItem;
                END;
                 */

            end;
        }
        field(50001; "Product Type"; Option)
        {
            ObsoleteState = Removed;
            ObsoleteTag = '25.0';
            OptionCaption = ',Item,Item Category';
            OptionMembers = ,Item,"Item Category";
        }

    }
}
