tableextension 50211 "Sales Header_Ext" extends "Sales Header"
{
    fields
    {
        modify("External Document No.")
        {
            CaptionML = ENU = 'External Document No.', ESM = 'N§ documento externo',
            FRC = 'Nø document externe',
            ENC = 'External Document No.';
            trigger OnBeforeValidate()
            VAR
                recSalesHeader: Record "Sales Header";
                recSalesInvHeader: Record "Sales Invoice Header";
            BEGIN
                IF "External Document No." <> '' THEN BEGIN
                    IF "Document Type" IN ["Document Type"::Order, "Document Type"::Invoice] THEN BEGIN
                        recSalesHeader.RESET;
                        recSalesHeader.SETRANGE("Sell-to Customer No.", "Sell-to Customer No.");
                        recSalesHeader.SETFILTER("No.", '<>%1', "No.");
                        recSalesHeader.SETRANGE("External Document No.", "External Document No.");
                        IF recSalesHeader.FIND('-') THEN BEGIN
                            REPEAT
                                //IF "External Document No."=recSalesHeader."External Document No." THEN
                                IF recSalesHeader."Document Type" IN [recSalesHeader."Document Type"::Order, recSalesHeader."Document Type"::Invoice] THEN
                                    IF NOT CONFIRM('External No already exist for %1 No. %2', FALSE, recSalesHeader."Document Type", recSalesHeader."No.") THEN
                                        ERROR('External Document No. is already use on Document No. %1 and Document Type %2', FORMAT(recSalesHeader."No."), FORMAT(recSalesHeader."No."));
                            UNTIL recSalesHeader.NEXT = 0;
                        END;
                        recSalesInvHeader.RESET;
                        recSalesInvHeader.SETRANGE("Sell-to Customer No.", "Sell-to Customer No.");
                        recSalesInvHeader.SETFILTER("No.", '<>%1', "No.");
                        recSalesInvHeader.SETRANGE("External Document No.", "External Document No.");
                        IF recSalesInvHeader.FIND('-') THEN BEGIN
                            REPEAT
                                //IF "External Document No."=recSalesHeader."External Document No." THEN
                                // IF recSalesHeader."Document Type" IN [recSalesHeader."Document Type"::Order,recSalesHeader."Document Type"::Invoice] THEN
                                IF NOT CONFIRM('External No already exist for Invoice %1', FALSE, recSalesInvHeader."No.") THEN
                                    ERROR('External Document No. is already use on Invoice No. %1', FORMAT(recSalesInvHeader."No."));
                            UNTIL recSalesInvHeader.NEXT = 0;
                        END;
                    END;
                END;
            END;

        }
        modify("Package Tracking No.")
        {
            TableRelation = "Tracking No."."Tracking No." WHERE("Source Document No." = FIELD("No."));
            CaptionML = ENU = 'Package Tracking No.';
        }
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
        field(50021; "Ship Acct. No."; Code[20])
        {
        }
        field(50050; "Short Close"; Boolean)
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
        field(50054; "Expiry Date"; Date)
        {
            Description = 'SPD MS 050815';

            trigger OnValidate()
            var
                recSalesLine: Record "Sales Line";
            begin
                TESTFIELD(Status, Status::Open);
                IF CONFIRM(Text032, TRUE, "No.") THEN BEGIN
                    recSalesLine.RESET;
                    recSalesLine.SETRANGE(recSalesLine."Document Type", "Document Type");
                    recSalesLine.SETRANGE(recSalesLine."Document No.", "No.");
                    IF recSalesLine.FIND('-') THEN
                        REPEAT
                            recSalesLine."Expiry Date" := "Expiry Date";
                            recSalesLine.MODIFY;
                        UNTIL recSalesLine.NEXT = 0;
                END;
            end;
        }
        field(50055; "Third Party"; Boolean)
        {
        }
        field(50056; "Third Party Account No."; Code[20])
        {
        }
        field(50057; Priority; Option)
        {
            Description = 'Ravi';
            InitValue = "Sea 3";
            OptionCaption = ' ,Air 1,Air 2,Air 3,Sea 1,Sea 2,Sea 3';
            OptionMembers = " ","Air 1","Air 2","Air 3","Sea 1","Sea 2","Sea 3";
        }
        field(50058; AddressValidated; Boolean)
        {
        }
        field(50059; Residential; Boolean)
        {
        }
        field(50060; "RocketShip Tracking No."; Code[30])
        {
            CalcFormula = Lookup("Packing Header"."Tracking No." WHERE("Sales Order No." = FIELD("No."), "Void Entry" = FILTER(false)));
            FieldClass = FlowField;
        }
        field(50061; "Sales Order No."; Code[20])
        {
            Description = 'Ravi';
        }
        field(50062; SignatureImage; BLOB)
        {
            Description = 'QR';
            SubType = Bitmap;
        }
        field(50063; "QR Code"; BLOB)
        {
            Description = 'QR';
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
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                IF SepcifierCust.GET(Specifier) THEN
                    "Salesperson Code" := SepcifierCust."Salesperson Code";
            end;
        }
        field(50066; "Specifier Name"; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD(Specifier)));
            Description = 'Ravi';
            Editable = false;
            FieldClass = FlowField;
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
        field(50069; "Order Status"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'POSH';
        }
        field(50070; "Quote Status"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'POSH';
        }
        field(50071; "Specifier Contact No."; Code[20])
        {
            Caption = 'Specifier Contact No.';
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
        field(50072; "Physical Order Loc"; Option)
        {
            DataClassification = CustomerContent;
            Description = 'RS - Location of the Order Copy';
            OptionCaption = ' ,Shipping,Back Order,Backing,P&H';
            OptionMembers = " ",Shipping,"Back Order",Backing,"P&H";
        }
        field(50073; "No insurance"; Boolean)
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
                ContBusinessRelation: Record "Contact Business Relation";
            begin
                IF "Bill-to Customer No." <> '' THEN
                    IF Cont.GET("PI Contact") THEN
                        Cont.SETRANGE("Company No.", Cont."Company No.")
                    ELSE
                        IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Customer, "Bill-to Customer No.") THEN
                            Cont.SETRANGE("Company No.", ContBusinessRelation."Contact No.")
                        ELSE
                            Cont.SETRANGE("No.", '');

                IF "PI Contact" <> '' THEN
                    IF Cont.GET("PI Contact") THEN;
                IF PAGE.RUNMODAL(0, Cont) = ACTION::LookupOK THEN BEGIN
                    xRec := Rec;
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
        field(50504; "MB Order ID"; Integer)
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
        }
        field(50900; "Additional Info"; Text[50])
        {
            Caption = 'Additional Info';
            DataClassification = ToBeClassified;
        }
        field(60000; "Authorization Required"; Boolean)
        {
            Caption = 'Authorization Required';
            DataClassification = ToBeClassified;
        }
        field(60001; "Credit Card No."; Code[20])
        {
            //Caption = 'Credit Card No.';
            DataClassification = ToBeClassified;
            TableRelation = "DO Payment Credit Card" WHERE("Customer No." = FIELD("Bill-to Customer No."));
            CaptionML = ENU = 'Credit Card No.',
            ESM = 'N§ tarjeta de cr‚dito',
            FRC = 'Nø de carte de cr‚dit',
            ENC = 'Credit Card No.';


            trigger OnValidate()
            var
                DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
            begin
                IF NOT DOPaymentTransLogEntry.ISEMPTY THEN
                    DOPaymentTransLogMgt.ValidateHasNoValidTransactions("Document Type".AsInteger(), FORMAT("Document Type"), "No.");

                IF "Credit Card No." = '' THEN
                    EXIT;

                DOPaymentMgt.CheckCreditCardData("Credit Card No.");

                IF NOT DOPaymentMgt.IsValidPaymentMethod("Payment Method Code") THEN
                    FIELDERROR("Payment Method Code");
            end;
        }

    }

    keys
    {
        key(SK1; "Salesperson Code", "Order Date")
        {
        }
    }
    trigger OnAfterModify()
    begin
        IF ("Shipping Agent Code" = 'FEDEX') AND ("Shipping Agent Service Code" = 'GROUND') AND (Residential) THEN
            "Shipping Agent Service Code" := '9 GRND HOM';
    END;

    var
        DOPaymentMgt: Codeunit "DO Payment Mgt.";
        DOPaymentTransLogMgt: Codeunit "DO Payment Trans. Log Mgt.";
        Text032: Label 'Do you want to update the lines?';
        Text067: Label '%1 %4 with amount of %2 has already been authorized on %3 and is not expired yet. You must void the previous authorization before you can re-authorize this %1.';
        Text068: Label 'There is nothing to void.';
        Text069: Label 'The selected operation cannot complete with the specified %1.';
        SepcifierCust: Record Customer;

    // procedure Authorize()
    // var
    //     DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
    // begin
    //     IF NOT DOPaymentMgt.IsValidPaymentMethod("Payment Method Code") THEN
    //         ERROR(Text069, FIELDCAPTION("Payment Method Code"));
    //     DOPaymentTransLogMgt.FindValidAuthorizationEntry("Document Type".AsInteger(), "No.", DOPaymentTransLogEntry);
    //     IF DOPaymentTransLogEntry."Entry No." = DOPaymentMgt.AuthorizeSalesDoc(Rec, 0, TRUE) THEN
    //         ERROR(Text067,
    //           DOPaymentTransLogEntry."Document Type",
    //           DOPaymentTransLogEntry.Amount,
    //           DOPaymentTransLogEntry."Transaction Date-Time",
    //           DOPaymentTransLogEntry."Document No.");
    //     "Authorization Required" := TRUE;
    //     MODIFY;
    // end;

    // procedure Void()
    // var
    //     DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
    //     DOPaymentTransLogMgt: Codeunit "DO Payment Trans. Log Mgt.";
    // begin
    //     IF NOT DOPaymentMgt.IsValidPaymentMethod("Payment Method Code") THEN
    //         ERROR(Text069, FIELDCAPTION("Payment Method Code"));
    //     CLEAR(DOPaymentMgt);
    //     DOPaymentMgt.CheckSalesDoc(Rec);
    //     IF DOPaymentTransLogMgt.FindValidAuthorizationEntry("Document Type".AsInteger(), "No.", DOPaymentTransLogEntry) THEN
    //         DOPaymentMgt.VoidSalesDoc(Rec, DOPaymentTransLogEntry)
    //     ELSE
    //         MESSAGE(Text068);
    //     "Authorization Required" := FALSE;
    //     MODIFY;
    // end;

    procedure GetCreditcardNumber(): Text[20]
    var
        DOPaymentCreditCard: Record "DO Payment Credit Card";
    begin
        IF "Credit Card No." = '' THEN
            EXIT('');
        EXIT(DOPaymentCreditCard.GetCreditCardNumber("Credit Card No."));
    end;
}
