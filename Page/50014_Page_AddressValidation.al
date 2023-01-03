page 50014 "Address Validation"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Address Validation";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = all;
                }
            }
            group("FedEx Response")
            {
                Caption = 'FedEx Response';
                field(HighestSeverity; Rec.HighestSeverity)
                {
                    ApplicationArea = all;
                }
                field(Severity; Rec.Severity)
                {
                    ApplicationArea = all;
                }
                field(Message; Rec.Message)
                {
                    ApplicationArea = all;
                }
                field("Address State"; Rec."Address State")
                {
                    ApplicationArea = all;
                }
                field(Classification; Rec.Classification)
                {
                    ApplicationArea = all;
                }
                field(DPV; Rec.DPV)
                {
                    Caption = 'Delivery Point Valid';
                    ApplicationArea = all;
                }
                field(EncompassingZIP; Rec.EncompassingZIP)
                {
                    ApplicationArea = all;
                }
                field(InterpolatedStreetAddress; Rec.InterpolatedStreetAddress)
                {
                    ApplicationArea = all;
                }
                field(MultipleMatches; Rec.MultipleMatches)
                {
                    ApplicationArea = all;
                }
                field(OrganizationValidated; Rec.OrganizationValidated)
                {
                    ApplicationArea = all;
                }
                field(PostalValidated; Rec.PostalValidated)
                {
                    ApplicationArea = all;
                }
                field(StreetAddress; Rec.StreetAddress)
                {
                    ApplicationArea = all;
                }
                field(Resolved; Rec.Resolved)
                {
                    ApplicationArea = all;
                }
            }
            group("Address Comparision")
            {
                Caption = 'Address Comparision';
                grid(Control1170000015)
                {
                    GridLayout = Rows;
                    ShowCaption = false;
                    group(Address)
                    {
                        Caption = 'Address';
                        field("Customer Address"; Rec."Customer Address")
                        {
                            Caption = 'From NAV';
                            StyleExpr = AddOneDiff;
                            ApplicationArea = all;
                        }
                        field(StreetLines; Rec.StreetLines)
                        {
                            Caption = 'From FedEx';
                            StyleExpr = AddOneDiff;
                            ApplicationArea = all;
                        }
                    }
                }
                grid(Control1170000017)
                {
                    GridLayout = Rows;
                    ShowCaption = false;
                    group("Address 2")
                    {
                        Caption = 'Address 2';
                        field("Customer Address 2"; Rec."Customer Address 2")
                        {
                            Caption = 'From NAV';
                            StyleExpr = AddTwoDiff;
                            ApplicationArea = all;
                        }
                        field("StreetLines 2"; Rec."StreetLines 2")
                        {
                            Caption = 'From FedEx';
                            StyleExpr = AddTwoDiff;
                            ApplicationArea = all;
                        }
                    }
                }
                grid(Control1170000019)
                {
                    GridLayout = Rows;
                    ShowCaption = false;
                    group(City)
                    {
                        Caption = 'City';
                        field("Customer City"; Rec."Customer City")
                        {
                            Caption = 'From NAV';
                            StyleExpr = CityDiff;
                            ApplicationArea = all;
                        }
                        field("From FedEx"; Rec.City)
                        {
                            Caption = 'From FedEx';
                            StyleExpr = CityDiff;
                            ApplicationArea = all;
                        }
                    }
                }
                grid(Control1170000011)
                {
                    GridLayout = Rows;
                    ShowCaption = false;
                    group("Post Code")
                    {
                        Caption = 'Post Code';
                        field("Customer Post Code"; Rec."Customer Post Code")
                        {
                            Caption = 'From NAV';
                            StyleExpr = PostCodeDiff;
                            ApplicationArea = all;
                        }
                        field(PostalCode; Rec.PostalCode)
                        {
                            Caption = 'From FedEx';
                            StyleExpr = PostCodeDiff;
                            ApplicationArea = all;
                        }
                    }
                }
                grid(Control1170000023)
                {
                    GridLayout = Rows;
                    ShowCaption = false;
                    group("State Code")
                    {
                        Caption = 'State Code';
                        field("Customer County"; Rec."Customer County")
                        {
                            Caption = 'From NAV';
                            StyleExpr = StateDiff;
                            ApplicationArea = all;
                        }
                        field(StateOrProvinceCode; Rec.StateOrProvinceCode)
                        {
                            Caption = 'From FedEx';
                            StyleExpr = StateDiff;
                            ApplicationArea = all;
                        }
                    }
                }
                grid(Control1170000025)
                {
                    GridLayout = Rows;
                    ShowCaption = false;
                    group("Country Code")
                    {
                        Caption = 'Country Code';
                        field("Customer Country/Region Code"; Rec."Customer Country/Region Code")
                        {
                            Caption = 'From NAV';
                            StyleExpr = CountryDiff;
                            ApplicationArea = all;
                        }
                        field(CountryCode; Rec.CountryCode)
                        {
                            Caption = 'From FedEx';
                            StyleExpr = CountryDiff;
                            ApplicationArea = all;
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Update Cust Address")
            {
                Caption = 'Update Cust Address';
                Image = UpdateShipment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                begin
                    UpdateCustomerAddress;
                end;
            }
            action("Update ship-to Address")
            {
                Caption = 'Update ship-to Address';
                Image = UpdateShipment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                begin
                    UpdateShipToAddress;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetStyle;
        if Rec."StreetLines 2" = '' then
            if Rec.UrbanizationCode <> '' then
                Rec."StreetLines 2" := Rec.UrbanizationCode;
    end;

    var
        AddOneDiff: Text;
        AddTwoDiff: Text;
        CityDiff: Text;
        PostCodeDiff: Text;
        CountryDiff: Text;
        StateDiff: Text;

    procedure SetStyle()
    begin
        if Rec."Customer Address" <> Rec.StreetLines then
            AddOneDiff := 'Attention'
        else
            AddOneDiff := '';

        if Rec."Customer Address 2" <> Rec."StreetLines 2" then
            AddTwoDiff := 'Attention'
        else
            AddTwoDiff := '';

        if Rec."Customer City" <> Rec.City then
            CityDiff := 'Attention'
        else
            CityDiff := '';

        if Rec."Customer Post Code" <> Rec.PostalCode then
            PostCodeDiff := 'Attention'
        else
            PostCodeDiff := '';

        if Rec."Customer Country/Region Code" <> Rec.CountryCode then
            CountryDiff := 'Attention'
        else
            CountryDiff := '';

        if Rec."Customer County" <> Rec.StateOrProvinceCode then
            StateDiff := 'Attention'
        else
            StateDiff := '';
    end;

    local procedure UpdateCustomerAddress()
    var
        Cust: Record Customer;
        ShipToadd: Record "Ship-to Address";
        SalesHeader: Record "Sales Header";
    begin
        if Rec.DPV then begin
            //IF Classification IN ['BUSINESS', 'RESIDENTIAL'] THEN
            if Confirm('Do you really want to update?', false) then begin
                if Cust.Get(Rec."Customer No.") then begin
                    Cust.Address := Rec.StreetLines;
                    Cust."Address 2" := Rec."StreetLines 2";
                    Cust.City := Rec.City;
                    Cust."Post Code" := Rec.PostalCode;
                    Cust.County := Rec.StateOrProvinceCode;
                    Cust."Country/Region Code" := Rec.CountryCode;
                    Cust.AddressValidated := true;
                    Cust.Modify(true);
                end;
                if Rec."Sales Order No" <> '' then begin
                    if SalesHeader.Get(Rec."Sales Order No") then begin
                        SalesHeader."Bill-to Address" := Rec.StreetLines;
                        SalesHeader."Bill-to Address 2" := Rec."StreetLines 2";
                        SalesHeader."Bill-to City" := Rec.City;
                        SalesHeader."Bill-to Post Code" := Rec.PostalCode;
                        SalesHeader."Bill-to County" := Rec.StateOrProvinceCode;
                        SalesHeader."Bill-to Country/Region Code" := Rec.CountryCode;
                        SalesHeader.AddressValidated := true;
                        SalesHeader.Modify(true);
                    end;
                end;
            end;
        end else
            Error('Either Delivery Point is not valid or Address is not resolved.');
    end;

    local procedure UpdateShipToAddress()
    var
        Cust: Record Customer;
        ShipToadd: Record "Ship-to Address";
        SalesHeader: Record "Sales Header";
    begin
        if Rec.DPV then begin
            //IF Classification IN ['BUSINESS', 'RESIDENTIAL'] THEN
            if Confirm('Do you really want to update?', false) then begin
                if ShipToadd.Get(Rec."Customer No.", Rec."Ship-To Code") then begin
                    ShipToadd.Address := Rec.StreetLines;
                    ShipToadd."Address 2" := Rec."StreetLines 2";
                    ShipToadd.City := Rec.City;
                    ShipToadd."Post Code" := Rec.PostalCode;
                    ShipToadd.County := Rec.StateOrProvinceCode;
                    ShipToadd."Country/Region Code" := Rec.CountryCode;
                    ShipToadd.AddressValidated := true;
                    ShipToadd.Modify(true);
                end;
                if Rec."Sales Order No" <> '' then begin
                    if SalesHeader.Get(Rec."Sales Order No") then begin
                        SalesHeader."Bill-to Address" := Rec.StreetLines;
                        SalesHeader."Bill-to Address 2" := Rec."StreetLines 2";
                        SalesHeader."Bill-to City" := Rec.City;
                        SalesHeader."Bill-to Post Code" := Rec.PostalCode;
                        SalesHeader."Bill-to County" := Rec.StateOrProvinceCode;
                        SalesHeader."Bill-to Country/Region Code" := Rec.CountryCode;
                        SalesHeader.AddressValidated := true;
                        SalesHeader.Modify(true);
                    end;
                end;

            end;
        end else
            Error('Either Delivery Point is not valid or Address is not resolved.');
    end;
}

