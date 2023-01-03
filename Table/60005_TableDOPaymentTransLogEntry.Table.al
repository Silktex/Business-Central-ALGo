table 60005 "DO Payment Trans. Log Entry"
{
    Caption = 'DO Payment Trans. Log Entry';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';

            trigger OnValidate()
            begin
                SetData(FORMAT("Entry No."));
                VALIDATE("Refund No.", "Entry No." + 10005);
            end;
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Order,Invoice,Payment,Refund';
            OptionMembers = " ","Order",Invoice,Payment,Refund;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(5; "Credit Card No."; Code[20])
        {
            Caption = 'Credit Card No.';
            TableRelation = "DO Payment Credit Card"."No.";
        }
        field(6; "Transaction Type"; Option)
        {
            Caption = 'Transaction Type';
            OptionCaption = 'Authorization,Void,Capture,Refund';
            OptionMembers = Authorization,Void,Capture,Refund;
        }
        field(7; "Transaction Result"; Option)
        {
            Caption = 'Transaction Result';
            OptionCaption = 'Success,Failed';
            OptionMembers = Success,Failed;
        }
        field(8; "Transaction Description"; Text[250])
        {
            Caption = 'Transaction Description';
        }
        field(9; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(10; "Transaction Date-Time"; DateTime)
        {
            Caption = 'Transaction Date-Time';
        }
        field(11; "Transaction Status"; Option)
        {
            Caption = 'Transaction Status';
            OptionCaption = ' ,Voided,Expired,Captured,Refunded,Posting Not Finished';
            OptionMembers = " ",Voided,Expired,Captured,Refunded,"Posting Not Finished";
        }
        field(12; "Cust. Ledger Entry No."; Integer)
        {
            Caption = 'Cust. Ledger Entry No.';
            TableRelation = "Cust. Ledger Entry";
        }
        field(13; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(14; "Transaction GUID"; Guid)
        {
            Caption = 'Transaction GUID';
        }
        field(15; "Transaction ID"; Text[50])
        {
            Caption = 'Transaction ID';
        }
        field(16; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(17; "Parent Entry No."; Integer)
        {
            Caption = 'Parent Entry No.';
        }
        field(18; "Reference GUID"; Guid)
        {
            Caption = 'Reference GUID';
        }
        field(50000; Company; Text[50])
        {
            TableRelation = Company.Name;
        }
        field(50001; "Refund No."; Integer)
        {
        }
        field(50002; "Entry Blob"; BLOB)
        {
        }
        field(50003; "Refund Blob"; BLOB)
        {
        }
        field(50004; "Authorization Code"; Code[30])
        {
        }
        field(50005; Result; Option)
        {
            Caption = 'Result';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Success,Failed';
            OptionMembers = " ",Success,Failed;
        }
        field(50006; "Contact No."; Code[20])
        {
            CalcFormula = Lookup("DO Payment Credit Card"."Contact No." WHERE("No." = FIELD("Credit Card No.")));
            Caption = 'Contact No.';
            FieldClass = FlowField;
            NotBlank = true;

            trigger OnLookup()
            var
                Contact: Record Contact;
            begin
            end;
        }
        field(50007; "Payment Entry No."; Integer)
        {

        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Document Type", "Document No.", "Transaction Type", "Transaction Result", "Transaction Status")
        {
        }
        key(Key3; "Cust. Ledger Entry No.")
        {
        }
        key(Key4; "Parent Entry No.", "Transaction Type", "Transaction Result")
        {
            SumIndexFields = Amount;
        }
        key(Key5; "Credit Card No.")
        {
        }
        key(Key6; "Document No.", "Customer No.", "Transaction Status")
        {
        }
    }

    fieldgroups
    {
    }

    var
    // EncryptionMgt: Codeunit "Encryption Management";


    procedure HasTransaction(var DOPaymentCreditCard: Record "DO Payment Credit Card"): Boolean
    begin
        SETCURRENTKEY("Credit Card No.");
        SETRANGE("Credit Card No.", DOPaymentCreditCard."No.");
        SETFILTER("Transaction Result", '<>%1', "Transaction Result"::Failed);
        EXIT(FINDFIRST);
    end;


    procedure SetData(Value: Text[1024])
    var
        DataStream: OutStream;
        DataText: BigText;
    begin
        CLEAR("Entry Blob");
        DataText.ADDTEXT(Encrypt(Value)); //Vishal
        "Entry Blob".CREATEOUTSTREAM(DataStream);
        DataText.WRITE(DataStream);
    end;
}

