table 50002 "Payment Future Old Inv"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Document Line No."; Integer)
        {
        }
        field(3; "Invoice No."; Code[20])
        {
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnLookup()
            begin
                recCustLedgEntry.RESET;
                recCustLedgEntry.FILTERGROUP(2);
                recCustLedgEntry.SETRANGE("Document Type", recCustLedgEntry."Document Type"::Invoice);
                recCustLedgEntry.SETRANGE("Customer No.", "Customer No.");
                recCustLedgEntry.SETFILTER("Ref. Document No.", '%1', '');
                recCustLedgEntry.SETRANGE(Positive, TRUE);
                recCustLedgEntry.FILTERGROUP(0);
                IF PAGE.RUNMODAL(0, recCustLedgEntry) = ACTION::LookupOK THEN
                    "Invoice No." := recCustLedgEntry."Document No.";


                //pgCustLedgEntry.RUN;
            end;
        }
        field(4; Amount; Decimal)
        {
        }
        field(5; "Journal Batch Name"; Code[10])
        {
        }
        field(6; "Journal Template Name"; Code[10])
        {
        }
        field(7; "Future Invoice"; Boolean)
        {
        }
        field(8; "Old Invoice"; Boolean)
        {
        }
        field(9; "Customer No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(10; "Entry No."; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Document No.", "Document Line No.", "Customer No.", "Invoice No.", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        /*
        RecFutureInv.RESET;
        RecFutureInv.SETRANGE("Invoice No.","Invoice No.");
        IF RecFutureInv.FINDFIRST THEN
          ERROR('Invoice is already in Paid future invoiced');
        */

    end;

    var
        recCustLedgEntry: Record "Cust. Ledger Entry";
        pgCustLedgEntry: Page "Customer Ledger Entries";
        RecFutureInv: Record "Payment Future Old Inv";
}

