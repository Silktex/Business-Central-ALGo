pageextension 50257 ItemCrossReferenceEntries_ext extends "Item Reference Entries"
{
    layout
    {
        addafter("Reference Type No.")
        {
            field("Customer/Vendor Name"; CustomerVendorName)
            {
                ApplicationArea = all;
            }
            // }
            //     addafter("Discontinue Bar Code")
            // {
            field("Palcement Start Date"; rec."Palcement Start Date")
            {
                ApplicationArea = all;

            }
            field("Placement End Date"; Rec."Placement End Date")
            {
                ApplicationArea = all;

            }
            field("Item No."; Rec."Item No.")
            {
                ApplicationArea = all;
            }
        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        IF Rec."Reference Type" = Rec."Reference Type"::Vendor THEN BEGIN
            recVendor.GET(Rec."Reference Type No.");
            CustomerVendorName := recVendor.Name;
        END;
        IF Rec."Reference Type" = Rec."Reference Type"::Customer THEN BEGIN
            recCustomer.GET(Rec."Reference Type No.");
            CustomerVendorName := recCustomer.Name;
        END;
    END;

    var
        CustomerVendorName: Text;
        recVendor: Record Vendor;
        recCustomer: Record Customer;
}
