page 50082 "Contact List-Web"
{
    Caption = 'Contact List';
    CardPageID = "Contact Card";
    DataCaptionFields = "Company No.";
    Editable = false;
    PageType = List;
    SourceTable = Contact;
    SourceTableView = SORTING("Company Name", "Company No.", Type, Name);

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                ShowCaption = false;
                field("Company No."; Rec."Company No.")
                {
                    ApplicationArea = all;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = all;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = all;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = all;
                }
                field("Credit Card Contact"; Rec."Credit Card Contact")
                {
                    ApplicationArea = all;
                }
                field("Sales Order"; Rec."Sales Order")
                {
                    ApplicationArea = all;
                }
                field("Sales Shipment"; Rec."Sales Shipment")
                {
                    ApplicationArea = all;
                }
                field("Sales Invoice"; Rec."Sales Invoice")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        EnableFields;
        StyleIsStrong := Rec.Type = Rec.Type::Company;

        NameIndent := 0;
        if Rec.Type <> Rec.Type::Company then begin
            Cont.SetCurrentKey("Company Name", "Company No.", Type, Name);
            if (Rec."Company No." <> '') and (not Rec.HasFilter) and (not Rec.MarkedOnly) and (Rec.CurrentKey = Cont.CurrentKey) then
                NameIndent := 1
        end;
    end;

    var
        Cont: Record Contact;

        StyleIsStrong: Boolean;

        NameIndent: Integer;
        CompanyGroupEnabled: Boolean;
        PersonGroupEnabled: Boolean;

    local procedure EnableFields()
    begin
        CompanyGroupEnabled := Rec.Type = Rec.Type::Company;
        PersonGroupEnabled := Rec.Type = Rec.Type::Person;
    end;
}

