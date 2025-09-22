page 50042 "Ecom Customer Card"
{
    SaveValues = true;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                }
                field(Username; Rec."No.")
                {
                    ApplicationArea = all;
                    Caption = 'Username';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = all;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = all;
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ApplicationArea = all;
                }
                field(AdminComments; Rec.AdminComments)
                {
                    ApplicationArea = all;
                }
                field(HasShoppingCartItems; Rec.HasShoppingCartItems)
                {
                    ApplicationArea = all;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = all;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = all;
                    Caption = 'Deleted';
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = all;
                    Caption = 'Name';
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = all;
                    Caption = 'OutstandingBalance';
                }
                field("Customer Price Group"; Rec."Customer Price Group")
                {
                    ApplicationArea = all;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = all;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = all;
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = all;
                }
                field("Shipping Account No."; Rec."Shipping Account No.")
                {
                    ApplicationArea = all;
                    Caption = 'FedEx Account No.';
                }
                field("UPS Account No."; Rec."UPS Account No.")
                {
                    ApplicationArea = all;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = all;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = all;
                }
                field("Primary Contact No."; Rec."Primary Contact No.")
                {
                    ApplicationArea = all;
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = all;
                }
                field(County; Rec.County)
                {
                    ApplicationArea = all;
                }
                field("Name 2"; Rec."Name 2")
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
                    Importance = Promoted;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = all;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = all;
                }
                field(Published; Rec.Published)
                {
                    ApplicationArea = all;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }

    // trigger OnClosePage()
    // begin
    //     //NOP Commerce BEGIN
    //     if IsClear(Xmlhttp) then
    //         Result := Create(Xmlhttp, true, true);

    //     txtURL := 'http://localhost:80/api/syncsinglecustomer/' + Rec."No.";
    //     Xmlhttp.open('GET', txtURL, false);
    //     Xmlhttp.send('');
    //     Message('%1', Xmlhttp.responseText);
    //     //NOP Commerce END
    // end;

    var
        // Xmlhttp: Automation;
        // HttpWebResponse: DotNet WebResponse;
        RecCompanyInfo: Record "Company Information";
        Result: Boolean;
        txtURL: Text;
}

