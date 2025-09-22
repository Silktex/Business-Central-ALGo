pageextension 50243 "Ship-to Address_Ext" extends "Ship-to Address"
{

    layout
    {
        modify(Name)
        {
            trigger OnBeforeValidate()
            begin
                IF (Rec.Name <> xRec.Name) THEN BEGIN
                    Rec.AddressValidated := FALSE;
                END
            end;
        }
        modify(Address)
        {
            trigger OnBeforeValidate()
            begin
                IF (Rec.Address <> xRec.Address) THEN BEGIN
                    Rec.AddressValidated := FALSE;
                END
            end;
        }
        modify("Address 2")
        {
            trigger OnBeforeValidate()
            begin
                IF (Rec."Address 2" <> xRec."Address 2") THEN BEGIN
                    Rec.AddressValidated := FALSE;
                END
            end;
        }
        modify(City)
        {
            trigger OnBeforeValidate()
            begin
                IF (Rec.City <> xRec.City) THEN BEGIN
                    Rec.AddressValidated := FALSE;
                END
            end;
        }
        modify(County)
        {
            trigger OnBeforeValidate()
            begin
                IF (Rec.County <> xRec.County) THEN BEGIN
                    Rec.AddressValidated := FALSE;
                END
            end;
        }
        modify("Post Code")
        {
            trigger OnBeforeValidate()
            begin
                IF (Rec."Post Code" <> xRec."Post Code") THEN BEGIN
                    Rec.AddressValidated := FALSE;
                END
            end;
        }
        modify("Country/Region Code")
        {
            trigger OnBeforeValidate()
            begin
                IF (Rec."Country/Region Code" <> xRec."Country/Region Code") THEN BEGIN
                    Rec.AddressValidated := FALSE;
                END
            end;
        }
        addafter("Tax Area Code")
        {
            field("Shipping Account No."; Rec."Shipping Account No.")
            {
                Caption = 'Fedex Account No.';
                ApplicationArea = all;
            }
            field("UPS Account No."; Rec."UPS Account No.")
            {
                ApplicationArea = all;
            }
            field("Third Party"; Rec."Third Party")
            {
                ApplicationArea = all;
            }
            field("Customer Price Group"; Rec."Customer Price Group")
            {
                ApplicationArea = all;
            }
            field("Use Default"; Rec."Use Default")
            {
                ApplicationArea = all;
            }
            field(Residential; Rec.Residential)
            {
                ApplicationArea = all;
            }
            field(AddressValidated; Rec.AddressValidated)
            {
                ApplicationArea = all;
            }
            field("Payment Terms Code"; Rec."Payment Terms Code")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("&Address")
        {
            action("FedEx Address Validation")
            {
                Caption = 'FedEx Address Validation';
                Image = "Action";
                ApplicationArea = all;

                trigger OnAction()
                begin
                    if ((Rec."Country/Region Code" = 'US') or (Rec."Country/Region Code" = 'CA')) and (not Rec.AddressValidated) then
                        AddressValidation.USAddressValidationJsonShiptoAdd(Rec, '');
                end;
            }
        }
    }

    trigger OnClosePage()
    var
        myAnswer: Integer;
    BEGIN
        IF ((Rec."Country/Region Code" = 'US') OR (Rec."Country/Region Code" = 'CA')) AND (NOT Rec.AddressValidated) THEN
            AddressValidation.USAddressValidationJsonShiptoAdd(Rec, '');
    END;


    trigger OnQueryClosePage(CloseAction: Action): Boolean
    BEGIN
        Rec.TESTFIELD("Country/Region Code");
        Rec.TESTFIELD("Phone No.");
    END;

    var
        cuTest: Codeunit "Integration Fedex UPS";
        //Xmlhttp: Automation;
        Result: Boolean;
        txtURL: Text;
        recCompInfo: Record "Company Information";
        AddressValidation: Codeunit "Address Validation";

}
