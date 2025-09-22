tableextension 50217 "GenJournal Line_Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(50000; "Sales Invoice Ref."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST(Customer)) "Sales Invoice Header"."No." WHERE("Sell-to Customer No." = FIELD("Account No.")) ELSE
            IF ("Bal. Account Type" = CONST(Customer)) "Sales Invoice Header"."No." WHERE("Sell-to Customer No." = FIELD("Bal. Account No."));
        }
        field(50001; "For Future Invoice"; Boolean)
        {

            trigger OnValidate()
            begin
                IF "For Future Invoice" = FALSE THEN BEGIN
                    "Future Invoice No." := '';
                    "Future Invoice Amount" := 0;
                    "Application Document No." := '';
                END;
            end;
        }
        field(50002; "Future Invoice No."; Code[20])
        {

            trigger OnLookup()
            var
                pgCustLedgerEntry: Page "Customer Ledger Entries";
                AccNo: Code[20];
            begin
            end;
        }
        field(50003; "Future Invoice Amount"; Decimal)
        {
        }
        field(50004; "Application Document No."; Code[20])
        {

            trigger OnLookup()
            var
                pgCustLedgerEntry: Page "Customer Ledger Entries";
                AccNo: Code[20];
            begin
            end;
        }
        field(50005; "For Old Invoice"; Boolean)
        {

            trigger OnValidate()
            begin
                IF "For Old Invoice" = FALSE THEN BEGIN
                    //"Sales Invoice Ref.":='';
                    "Future Invoice Amount" := 0;
                    "Application Document No." := '';
                END;
            end;
        }
        field(50006; "Applicable for FO Invoice"; Boolean)
        {
        }
        field(50007; "Future/Paid Invoice"; Boolean)
        {
        }
        field(50008; "Ref. Document No."; Code[20])
        {
        }
        // field(60000; "Credit Card No."; Code[20])
        // {
        //     Caption = 'Credit Card No.';
        // }
    }
}
