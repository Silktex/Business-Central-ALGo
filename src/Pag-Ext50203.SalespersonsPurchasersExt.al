pageextension 50203 "Salespersons/Purchasers_Ext" extends "Salespersons/Purchasers"
{
    layout
    {
        addafter("Privacy Blocked")
        {
            field("Active MIS"; Rec."Active MIS")
            {
                ApplicationArea = all;
            }

            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = all;
            }
            field(Address; Rec.Address)
            {
                ApplicationArea = all;
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = all;
            }
            field(City; Rec.City)
            {
                ApplicationArea = all;
            }
            field("Post Code"; Rec."Post Code")
            {
                ApplicationArea = all;
            }
            field(County; Rec.County)
            {
                ApplicationArea = all;
            }
            field("Country/Region Code"; Rec."Country/Region Code")
            {
                ApplicationArea = all;
            }
            field(Active; Rec.Active)
            {
                ApplicationArea = all;
            }
            field(Comment; Rec.Comment)
            {
                ApplicationArea = all;
            }
        }
    }
}
