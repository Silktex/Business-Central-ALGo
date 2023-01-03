page 50100 "Vendor Detail"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = Vendor;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
            }
            part(Control1000000004; "Purchase Order Vendor Detail")
            {
                ApplicationArea = All;
                SubPageLink = "Buy-from Vendor No." = FIELD("No.");
            }
            part(Control1000000005; "Purch. Invoice Vendor Detail")
            {
                ApplicationArea = All;
                SubPageLink = "Buy-from Vendor No." = FIELD("No.");
            }
            part(Control1000000006; "Vendor Ledger Entries Vendor D")
            {
                ApplicationArea = All;
                SubPageLink = "Vendor No." = FIELD("No.");
            }
        }
    }

    actions
    {
    }
}

