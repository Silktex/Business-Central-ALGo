tableextension 50258 "Return Receipt Header_Ext" extends "Return Receipt Header"
{
    fields
    {
        field(50000; "Charges Pay By"; Option)
        {
            OptionCaption = ' ,SENDER,RECEIVER';
            OptionMembers = " ",SENDER,RECEIVER;
        }
        field(50001; "Tracking No."; Text[30])
        {
        }
        field(50002; "Tracking Status"; Code[20])
        {
        }
        field(50003; "Box Code"; Code[20])
        {
            TableRelation = "Box Master"."Box Code";
        }
        field(50004; "No. of Boxes"; Integer)
        {
        }
        field(50005; "Shipment Time"; Time)
        {
        }
        field(50051; "Multiple Payment"; Boolean)
        {
        }
        field(50052; "Commission Override"; Boolean)
        {
            Caption = 'Commission Override';
        }
        field(50053; "Commision %"; Decimal)
        {
            Caption = 'Commission %';
        }
        field(50055; "Third Party"; Boolean)
        {
        }
        field(50056; "Third Party Account No."; Code[20])
        {
        }
        field(50065; Specifier; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Ravi';
            TableRelation = Customer.Name;
        }
        field(50067; "Proj Owner 1"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'POSH';
        }
        field(50068; "Proj Owner 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'POSH';
        }
        field(50071; "Specifier Contact No."; Code[20])
        {
            Caption = 'Sell-to Contact No.';
            DataClassification = ToBeClassified;
            Description = 'POSH';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
                IF Specifier <> '' THEN
                    IF Cont.GET("Specifier Contact No.") THEN
                        Cont.SETRANGE("Company No.", Cont."Company No.")
                    ELSE
                        IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Customer, Specifier) THEN
                            Cont.SETRANGE("Company No.", ContBusinessRelation."Contact No.")
                        ELSE
                            Cont.SETRANGE("No.", '');

                IF "Specifier Contact No." <> '' THEN
                    IF Cont.GET("Specifier Contact No.") THEN;
                IF PAGE.RUNMODAL(0, Cont) = ACTION::LookupOK THEN BEGIN
                    xRec := Rec;
                    VALIDATE("Specifier Contact No.", Cont."No.");
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
    }
}
