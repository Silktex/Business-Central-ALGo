table 60003 "DO Payment Credit Card"
{
    Caption = 'Dynamics Online Payment Credit Card';
    Permissions = TableData "DO Payment Credit Card Number" = rimd;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Type; Code[20])
        {
            Caption = 'Type';
            NotBlank = true;
            TableRelation = "DO Payment Card Type".Name;

            trigger OnValidate()
            begin
                IF Type <> xRec.Type THEN
                    DeleteCreditCardNumber;
            end;
        }
        field(3; "Credit Card Number"; Text[20])
        {
            Caption = 'Credit Card Number';
        }
        field(4; "Expiry Date"; Code[4])
        {
            Caption = 'Expiry Date';
            NotBlank = true;

            trigger OnValidate()
            var
                IntegerValue: Integer;
            begin
                IF NOT EVALUATE(IntegerValue, "Expiry Date") OR (STRLEN("Expiry Date") <> 4) THEN
                    ERROR(Text006, FIELDCAPTION("Expiry Date"));

                EVALUATE(IntegerValue, COPYSTR("Expiry Date", 1, 2));
                IF NOT (IntegerValue IN [1 .. 12]) THEN
                    ERROR(Text007);
            end;
        }
        field(5; "Card Holder Name"; Text[50])
        {
            Caption = 'Card Holder Name';
            NotBlank = true;
        }
        field(6; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            NotBlank = true;
            TableRelation = Customer;

            trigger OnValidate()
            var
                Contact: Record Contact;
            begin
                Contact.SETRANGE("Company No.", FindCustomerContactNo);
                Contact.SETRANGE(Type, Contact.Type::Person);
                IF Contact.FINDFIRST THEN
                    "Contact No." := Contact."No.";
                ValidateContact;
            end;
        }
        field(7; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            NotBlank = true;

            trigger OnLookup()
            var
                Contact: Record Contact;
                ContactList: Page "Contact List";
            begin
                Contact.SETRANGE("Company No.", FindCustomerContactNo);
                Contact.SETRANGE(Type, Contact.Type::Person);

                IF "Contact No." <> '' THEN
                    Contact.GET("Contact No.")
                ELSE BEGIN
                    IF Contact.GET THEN;
                END;

                ContactList.SETTABLEVIEW(Contact);
                ContactList.LOOKUPMODE(TRUE);
                IF ContactList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    ContactList.GETRECORD(Contact);
                    VALIDATE("Contact No.", Contact."No.");
                END;
            end;

            trigger OnValidate()
            begin
                IF "Contact No." <> xRec."Contact No." THEN
                    ValidateContact;
            end;
        }
        field(8; "Cvc No."; Text[4])
        {
            Caption = 'Cvc No.';

            trigger OnValidate()
            var
                NumericCvc: Integer;
            begin
                IF NOT EVALUATE(NumericCvc, "Cvc No.") THEN
                    ERROR(Text011, FIELDCAPTION("Cvc No."));
            end;
        }
        field(10; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(50000; "Correct credit Card"; Boolean)
        {
        }
        field(50050; "Token No."; Text[250])
        {
            Caption = 'Token No.';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Customer No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Type, "Expiry Date", "Credit Card Number")
        {
        }
    }

    trigger OnDelete()
    begin
        DOPaymentSetup.Get();
        if DOPaymentSetup."Admin User ID" <> UserId then
            IF DOPaymentTransLogEntry.HasTransaction(Rec) THEN
                ERROR(Text010, TABLECAPTION, "No.");
        DeleteCreditCardNumber;
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            DOPaymentSetup.GET;
            DOPaymentSetup.TESTFIELD("Credit Card Nos.");
            //NoSeriesMgt.InitSeries(DOPaymentSetup."Credit Card Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            if NoSeriesMgt.AreRelated(DOPaymentSetup."Credit Card Nos.", xRec."No. Series") then
                "No. Series" := xRec."No. Series"
            else
                "No. Series" := DOPaymentSetup."Credit Card Nos.";
            "No." := NoSeriesMgt.GetNextNo("No. Series");
        END;

        VALIDATE("Customer No.", GETFILTER("Customer No."));
    end;

    trigger OnRename()
    begin
        IF DOPaymentTransLogEntry.HasTransaction(Rec) THEN
            ERROR(Text010, TABLECAPTION, "No.");
    end;

    var
        Text006: Label '%1 must be 4 characters, for example, 1094 for October, 1994.';
        Text007: Label 'Check the month number.';
        Text010: Label 'You cannot delete %1 %2 because it has a valid transaction log entry.', Comment = '%1=table caption, %2=record no.';
        Text011: Label '%1 must be a number.';
        DOPaymentSetup: Record "DO Payment Setup";
        DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
        NoSeriesMgt: Codeunit "No. Series";


    procedure AssistEdit(OldDOPaymentCreditCard: Record "DO Payment Credit Card"): Boolean
    var
        DOPaymentCreditCard: Record "DO Payment Credit Card";
    begin
        //WITH DOPaymentCreditCard DO BEGIN
        DOPaymentCreditCard := Rec;
        DOPaymentSetup.GET;
        DOPaymentSetup.TESTFIELD("Credit Card Nos.");
        // IF NoSeriesMgt.SelectSeries(DOPaymentSetup."Credit Card Nos.", OldDOPaymentCreditCard."No. Series", DOPaymentCreditCard."No. Series") THEN BEGIN
        //     NoSeriesMgt.SetSeries(DOPaymentCreditCard."No.");
        //     Rec := DOPaymentCreditCard;
        //     EXIT(TRUE);
        // END;
        //END;

        if NoSeriesMgt.LookupRelatedNoSeries(DOPaymentSetup."Credit Card Nos.", xRec."No. Series", "No. Series") then begin
            "No." := NoSeriesMgt.GetNextNo("No. Series");
            exit(true);
        end;
    end;


    procedure SetCreditCardNumber(CreditCardNumberText: Text[30])
    var
        DOPaymentCreditCardNo: Record "DO Payment Credit Card Number";
        DOPaymentCardValidation: Codeunit "DO Payment Card Validation";
        StarString: Text[30];
    begin

        DOPaymentCardValidation.ValidateCreditCard(CreditCardNumberText, Type);

        IF DOPaymentCreditCardNo.GET("No.") THEN BEGIN
            DOPaymentCreditCardNo.SetData(CreditCardNumberText);
            DOPaymentCreditCardNo.MODIFY;
        END ELSE BEGIN
            DOPaymentCreditCardNo.INIT;
            DOPaymentCreditCardNo."No." := "No.";
            DOPaymentCreditCardNo.SetData(CreditCardNumberText);
            DOPaymentCreditCardNo.INSERT;
        END;

        // Set obfuscated card no
        StarString := '';
        "Credit Card Number" :=
          PADSTR(
            StarString,
            STRLEN(CreditCardNumberText) - 4, '*') + COPYSTR(CreditCardNumberText,
            STRLEN(CreditCardNumberText) - 3);
    end;


    procedure DeleteCreditCardNumber()
    var
        DOPaymentCreditCardNo: Record "DO Payment Credit Card Number";
    begin
        IF DOPaymentCreditCardNo.GET("No.") THEN BEGIN
            DOPaymentCreditCardNo.DELETE;
            "Credit Card Number" := '';
        END;
    end;


    procedure ValidateContact()
    var
        Contact: Record Contact;
    begin
        IF "Contact No." <> '' THEN BEGIN
            Contact.GET("Contact No.");
            IF "Card Holder Name" = '' THEN
                "Card Holder Name" := Contact.Name;
        END;
    end;


    procedure FindCustomerContactNo(): Code[20]
    var
        ContBusRel: Record "Contact Business Relation";
    begin
        ContBusRel.SETCURRENTKEY("Link to Table", "No.");
        ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Customer);
        ContBusRel.SETRANGE("No.", "Customer No.");

        IF ContBusRel.FINDFIRST THEN
            EXIT(ContBusRel."Contact No.");
    end;


    procedure DeleteByContact(Contact: Record Contact)
    var
        DOPaymentCreditCard: Record "DO Payment Credit Card";
    begin
        DOPaymentCreditCard.SETRANGE("Contact No.", Contact."No.");
        IF DOPaymentCreditCard.FINDFIRST THEN
            DOPaymentCreditCard.DELETEALL(TRUE);
    end;


    procedure DeleteByCustomer(Customer: Record Customer)
    var
        DOPaymentCreditCard: Record "DO Payment Credit Card";
    begin
        DOPaymentCreditCard.SETRANGE("Customer No.", Customer."No.");
        IF DOPaymentCreditCard.FINDFIRST THEN
            DOPaymentCreditCard.DELETEALL(TRUE);
    end;


    procedure GetCreditCardNumber(CreditCardNo: Code[20]): Text[20]
    begin
        IF GET(CreditCardNo) THEN
            EXIT("Credit Card Number");

        EXIT('');
    end;
}

