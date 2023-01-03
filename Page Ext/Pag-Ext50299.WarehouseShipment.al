page 50299 "Ecom_Warehouse_Shipment"
{
    Caption = 'Ecom_Warehouse_Shipment';
    PageType = Document;
    SourceTable = "Warehouse Shipment Header";
    ApplicationArea = all;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; rec."No.")
                {
                    ApplicationArea = all;

                }
                field("Location Code"; rec."Location Code")
                {
                    ApplicationArea = Location;

                }
                field("Zone Code"; rec."Zone Code")
                {
                    ApplicationArea = all;

                }
                field("Bin Code"; rec."Bin Code")
                {
                    ApplicationArea = all;

                }
                field("Document Status"; rec."Document Status")
                {
                    ApplicationArea = all;

                }
                field(Status; rec.Status)
                {
                    ApplicationArea = all;

                }
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = all;

                }
                field("Assigned User ID"; rec."Assigned User ID")
                {
                    ApplicationArea = all;

                }
                field("Assignment Date"; rec."Assignment Date")
                {
                    ApplicationArea = all;

                }
                field("Assignment Time"; rec."Assignment Time")
                {
                    ApplicationArea = all;

                }
                field("Sorting Method"; rec."Sorting Method")
                {
                    ApplicationArea = all;

                }
                field("COD Amount"; Rec."COD Amount")
                {
                    ApplicationArea = all;
                }
                field("Charges Pay By"; Rec."Charges Pay By")
                {
                    ApplicationArea = all;
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                    ApplicationArea = all;
                }
                field("Insurance Amount"; Rec."Insurance Amount")
                {
                    ApplicationArea = all;
                }
                field("No. of Boxes"; Rec."No. of Boxes")
                {
                    ApplicationArea = all;
                }
                field("Shipping Account No."; Rec."Shipping Account No.")
                {
                    ApplicationArea = all;
                }
                field("Signature Required"; Rec."Signature Required")
                {
                    ApplicationArea = all;
                }
                field("Third Party"; Rec."Third Party")
                { ApplicationArea = all; }
                field("Third Party Account No."; Rec."Third Party Account No.")
                {
                    ApplicationArea = all;
                }
                field("Cash On Delivery"; Rec."Cash On Delivery")
                { ApplicationArea = all; }
                field("Box Code"; Rec."Box Code")
                {
                    ApplicationArea = all;
                }
                field("Tracking No."; Rec."Tracking No.")
                {
                    ApplicationArea = all;
                }
            }


        }

    }

}