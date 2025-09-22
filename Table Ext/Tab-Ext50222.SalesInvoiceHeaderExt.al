tableextension 50222 "Sales Invoice Header_Ext" extends "Sales Invoice Header"
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
        field(50013; Path; Text[100])
        {
            ExtendedDatatype = URL;
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
        field(50054; "Expiry Date"; Date)
        {
            Description = 'SPD MS 050815';
        }
        field(50055; "Third Party"; Boolean)
        {
        }
        field(50056; "Third Party Account No."; Code[20])
        {
        }
        field(50064; "Project Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'RS - Name of Project';
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
        field(50074; "PI Contact"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Meghna';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
                Opportunity: Record Opportunity;
            begin
            end;
        }
        field(50075; "Specifier Designer Contact No."; Code[20])
        {
            Caption = 'Specifier Designer Contact No.';
            TableRelation = Contact WHERE(Type = CONST(Person));
            trigger OnValidate()
            var
                Cont: Record Contact;
            begin
                if Cont.Get("Specifier Designer Contact No.") then begin
                    "Specifier Designer Name" := Cont.Name;
                    "Specifier Designer Email" := Cont."E-Mail";
                end else begin
                    Clear("Specifier Designer Name");
                    Clear("Specifier Designer Email");
                end;
            end;
        }
        field(50076; "Specifier Designer Name"; Text[100])
        {
            Caption = 'Specifier Designer Name';
            Editable = false;
        }
        field(50077; "Specifier Designer Email"; Text[100])
        {
            Caption = 'Specifier Designer Email';
            Editable = false;
        }
        field(50500; "Project Type"; Text[50])
        {
            Caption = 'Project Type';
            DataClassification = ToBeClassified;
        }
        field(50501; "Project Phase"; Text[100])
        {
            Caption = 'Project Phase';
            DataClassification = ToBeClassified;
        }
        field(50502; "Project Description"; Text[500])
        {
            Caption = 'Project Description';
            DataClassification = ToBeClassified;
        }
        field(50505; "Project Location"; Text[50])
        {
            Caption = 'Project Location';
            DataClassification = ToBeClassified;
        }
        field(50504; "MB Order ID"; BigInteger)
        {
            Caption = 'MB Order ID';
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
            ObsoleteReason = 'Replaced with a new Text[100] field "MBOrderID"';
            ObsoleteTag = '1.0.0.0';
        }
        field(50510; "MBOrderID"; Text[100])
        {
            Caption = 'MB Order ID';
            DataClassification = ToBeClassified;
        }
        field(50503; "Project City"; Text[100])
        {
            Caption = 'Project City';
            DataClassification = ToBeClassified;
        }
        field(50506; "Project Size"; Option)
        {
            OptionCaption = ' ,0 - 5K sq ft,5K - 20K sq ft,20K - 50K sq ft,50K - 100K sq ft,100K - 500K sq ft,500K+ sq ft,Unknown';
            OptionMembers = " ","0 - 5K sq ft","5K - 20K sq ft","20K - 50K sq ft","50K - 100K sq ft","100K - 500K sq ft","500K+ sq ft",Unknown;
        }
        field(50507; "Project Budget"; Option)
        {
            OptionCaption = ' , $0 - $10K,$10K - $50K,$50K - $100K,$100K - $250K, $250K - $500K, $500K+,Unknown';
            OptionMembers = " ","$0 - $10K","$10K - $50K","$50K - $100K","$100K - $250K"," $250K - $500K","$500K+",Unknown;
        }
        field(50508; "ExpectedProjectCompletionMonth"; Text[50])
        {
            Caption = 'Expected Project Completion Month';
            DataClassification = ToBeClassified;
        }
        field(50509; "ExpectedProjectCompletionYear"; Integer)
        {
            Caption = 'Expected Project Completion Year';
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
            ObsoleteReason = 'Replaced with new Text field "Expected_ProjectCompletionYear".';
            ObsoleteTag = '1.0.0.0';
        }
        field(50511; "Expected_ProjectCompletionYear"; Text[100])
        {
            Caption = 'Expected Project Completion Year';
            DataClassification = ToBeClassified;
        }
        field(60001; "Credit Card No."; Code[20])
        {
            Caption = 'Credit Card No.';
            DataClassification = ToBeClassified;
            TableRelation = "DO Payment Credit Card" WHERE("Customer No." = FIELD("Bill-to Customer No."));
        }
    }
}
