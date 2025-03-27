tableextension 50205 Customer_Ext extends Customer
{

    fields
    {
        modify("Payment Terms Code")
        {

            trigger OnbeforeValidate()
            var
                ShiptoAddress: Record "Ship-to Address";
            begin
                IF "Payment Terms Code" <> xRec."Payment Terms Code" THEN BEGIN
                    IF CONFIRM('Do you want to update ship to address Payment Term code?', TRUE) THEN BEGIN
                        ShiptoAddress.RESET;
                        ShiptoAddress.SETRANGE("Customer No.", "No.");
                        IF ShiptoAddress.FINDFIRST THEN
                            REPEAT
                                ShiptoAddress."Payment Terms Code" := "Payment Terms Code";
                                ShiptoAddress.MODIFY;
                            UNTIL ShiptoAddress.NEXT = 0;
                    END;
                END;
            end;
        }
        field(50000; "Shipping Account No."; Code[20])
        {
            Caption = 'Shipping Account No.';
            Description = 'Shipping Account No.';
        }
        field(50001; "UPS Account No."; Code[20])
        {
            Caption = 'UPS Account No.';
            Description = 'UPS Account No.';
        }
        field(50004; "Future Old Invoice"; Boolean)
        {
            Caption = 'Future Old Invoice';
            Description = 'Future Old Invoice';
        }
        field(50013; "Sales Price Expire Days"; Integer)
        {
            Caption = 'Sales Price Expire Days';
            Description = 'Sales Price Expire Days';
        }
        field(50014; Residential; Boolean)
        {
            Caption = 'Residential';
            Description = 'Residential';
        }
        field(50015; AddressValidated; Boolean)
        {
            Caption = 'AddressValidated';
            Description = 'AddressValidated';
        }
        field(50016; "Email CC"; Text[30])
        {
            Caption = 'Email CC';
            Description = 'Email CC';
            ExtendedDatatype = EMail;
        }
        field(50017; "Schedule Day"; Option)
        {
            Description = 'Statement Schedule Day';
            OptionCaption = ' ,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = " ",Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
        }
        field(50020; "Agreement Posting"; Option)
        {
            Caption = 'Agreement Posting';
            OptionCaption = 'No Agreement,Mandatory';
            OptionMembers = "No Agreement",Mandatory;

            trigger OnValidate()
            var
                CustLedgEntry: Record "Cust. Ledger Entry";
            begin
                /*
                IF "Agreement Posting" = "Agreement Posting"::Mandatory THEN BEGIN
                  CustLedgEntry.RESET;
                  CustLedgEntry.SETCURRENTKEY("Customer No.");
                  CustLedgEntry.SETRANGE("Customer No.","No.");
                  CustLedgEntry.SETRANGE("Agreement No.",'');
                  IF CustLedgEntry.FINDFIRST THEN
                    AgrmtMgt.CreateAgrmtFromCust(Rec,'');
                END;
                IF "Agreement Posting" = "Agreement Posting"::"No Agreement" THEN BEGIN
                  CustLedgEntry.RESET;
                  CustLedgEntry.SETCURRENTKEY("Customer No.");
                  CustLedgEntry.SETRANGE("Customer No.","No.");
                  CustLedgEntry.SETFILTER("Agreement No.",'<> %1','');
                  CustLedgEntry.SETRANGE(Open,TRUE);
                  IF CustLedgEntry.FINDFIRST THEN
                    ERROR(Text012,FIELDCAPTION("Agreement Posting"),TABLECAPTION);
                END;
                */

            end;
        }
        field(50021; "Agreement Filter"; Code[20])
        {
            Caption = 'Agreement Filter';
            FieldClass = FlowFilter;
            // TableRelation = Table50061 .Field2 WHERE(Field1 = FIELD("No.")); //VR same error in old verison
        }
        field(50022; "Agreement Nos."; Code[20])
        {
            Caption = 'Agreement Nos.';
            TableRelation = "No. Series";
        }
        field(50023; "No insurance"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Handheld';
        }
        field(50074; "PI Contact"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Meghna';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusRel: Record "Contact Business Relation";
                TempCust: Record Customer temporary;
            begin
                ContBusRel.SETCURRENTKEY("Link to Table", "No.");
                ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Customer);
                ContBusRel.SETRANGE("No.", "No.");
                IF ContBusRel.FINDFIRST THEN
                    Cont.SETRANGE("Company No.", ContBusRel."Contact No.")
                ELSE
                    Cont.SETRANGE("No.", '');

                IF "PI Contact" <> '' THEN
                    IF Cont.GET("PI Contact") THEN;
                IF PAGE.RUNMODAL(0, Cont) = ACTION::LookupOK THEN BEGIN
                    TempCust.COPY(Rec);
                    FIND;
                    TRANSFERFIELDS(TempCust, FALSE);
                    VALIDATE("PI Contact", Cont."No.");
                END;
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
                Opportunity: Record Opportunity;
            begin
            end;
        }
        field(50100; AdminComments; Text[250])
        {
            Description = 'NOP Commerce';
        }
        field(50101; HasShoppingCartItems; Boolean)
        {
            Description = 'NOP Commerce';
        }
        field(50102; Active; Boolean)
        {
            Description = 'NOP Commerce';
        }
        field(50103; "NOP Insert"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'NOP_18';
        }
        field(50104; Published; Boolean)
        {
            Description = 'ECOM';
        }
        field(50150; "Stax Customer ID"; Text[50])
        {
            Caption = 'Stax Customer ID';
        }
    }
}
