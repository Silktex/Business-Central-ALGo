page 50044 "Ecom Product Card"
{
    SourceTable = Item;

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
                }
                field(Name; Rec.Description)
                {
                    ApplicationArea = all;
                    Caption = 'Name';
                }
                field(ShortDescription; Rec.Description)
                {
                    ApplicationArea = all;
                    Caption = 'ShortDescription';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = all;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                }
                field(DisplayStockAvailability; Rec.DisplayStockAvailability)
                {
                    ApplicationArea = all;
                }
                field(DisplayStockQuantity; Rec.DisplayStockQuantity)
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
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = all;
                }
                field("Product Group Code"; Rec."Item Category Code")
                {
                    ApplicationArea = all;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ven&dor")
            {
                Caption = 'Ven&dor';
                Image = Vendor;
                //Discard Function
                // action(NOPProductAttribute)
                // {
                //     ApplicationArea = all;
                //     Caption = 'NOP Product Attribute';
                //     Image = Archive;
                //     RunObject = Page "Ecom Item Attribute";
                //     RunPageLink = Field4 = FIELD("No.");
                // }
            }
        }
    }

    // trigger OnClosePage()
    // begin
    //     ///NOP Commerce BEGIN
    //     if IsClear(Xmlhttp) then
    //         Result := Create(Xmlhttp, true, true);

    //     txtURL := 'http://localhost:80/api/SyncSingleProduct/' + Rec."No.";
    //     Xmlhttp.open('GET', txtURL, false);
    //     Xmlhttp.send('');
    //     Message('%1', Xmlhttp.responseText);

    //     ///NOP Commerce END
    // end;

    var
        // Xmlhttp: Automation;
        // HttpWebResponse: DotNet WebResponse;
        RecCompanyInfo: Record "Company Information";
        Result: Boolean;
        txtURL: Text;
}

