xmlport 50051 CustomerOpening
{
    DefaultFieldsValidation = false;
    Format = VariableText;
    TransactionType = Update;

    schema
    {
        textelement(root)
        {
            tableelement("Gen. Journal Line"; "Gen. Journal Line")
            {
                XmlName = 'GenJournalLine';
                UseTemporary = true;
                fieldattribute(GenTemplate; "Gen. Journal Line"."Journal Template Name")
                {
                }
                fieldattribute(GenBatch; "Gen. Journal Line"."Journal Batch Name")
                {
                }
                fieldattribute(LineNumber; "Gen. Journal Line"."Line No.")
                {
                }
                fieldattribute(PostDate; "Gen. Journal Line"."Posting Date")
                {
                }
                fieldattribute(DocType; "Gen. Journal Line"."Document Type")
                {
                }
                fieldattribute(DocNumber; "Gen. Journal Line"."Document No.")
                {
                }
                fieldattribute(AccNo; "Gen. Journal Line"."Account No.")
                {
                }
                fieldattribute(ExDoc; "Gen. Journal Line"."External Document No.")
                {
                }
                fieldattribute(DAmount; "Gen. Journal Line"."Debit Amount")
                {
                }
                fieldattribute(CAmount; "Gen. Journal Line"."Credit Amount")
                {
                }
                fieldattribute(Duedate; "Gen. Journal Line"."Due Date")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    GJL.RESET;
                    GJL.SETFILTER("Journal Template Name", 'GENERAL');
                    GJL.SETFILTER("Journal Batch Name", 'DEFAULT');
                    IF GJL.FINDLAST THEN
                        LineNo := GJL."Line No."
                    ELSE
                        LineNo := 0;

                    GJL.INIT;
                    GJL."Journal Template Name" := 'GENERAL';
                    GJL."Journal Batch Name" := 'DEFAULT';
                    GJL."Line No." := LineNo + 10000;
                    GJL."Source Code" := 'GENJNL';
                    IF GJL.INSERT(TRUE) THEN;

                    GJL.VALIDATE("Posting Date", "Gen. Journal Line"."Posting Date");
                    GJL.VALIDATE("Document Type", "Gen. Journal Line"."Document Type");
                    GJL.VALIDATE("Document No.", "Gen. Journal Line"."Document No.");
                    GJL.VALIDATE("Account Type", GJL."Account Type"::Customer);
                    GJL.VALIDATE("Account No.", "Gen. Journal Line"."Account No.");
                    GJL.VALIDATE(GJL."External Document No.", "Gen. Journal Line"."External Document No.");
                    GJL.VALIDATE(GJL."Due Date", "Gen. Journal Line"."Due Date");
                    IF "Gen. Journal Line"."Debit Amount" <> 0 THEN
                        GJL.VALIDATE(GJL."Debit Amount", "Gen. Journal Line"."Debit Amount");
                    IF "Gen. Journal Line"."Credit Amount" <> 0 THEN
                        GJL.VALIDATE(GJL."Credit Amount", "Gen. Journal Line"."Credit Amount");
                    GJL."Bal. Account Type" := GJL."Bal. Account Type"::"G/L Account";
                    IF Cust.GET("Gen. Journal Line"."Account No.") THEN
                        IF CPG.GET(Cust."Customer Posting Group") THEN
                            BalAccNo := CPG."Receivables Account"
                        ELSE
                            BalAccNo := ''
                    ELSE
                        BalAccNo := '';

                    GJL.VALIDATE("Bal. Account No.", BalAccNo);
                    GJL.MODIFY(TRUE);
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        GJL: Record "Gen. Journal Line";
        PostDate: Date;
        DocNumber: Code[20];
        LineNo: Integer;
        AccNo: Code[20];
        DAmount: Decimal;
        CAmount: Decimal;
        BalAccNo: Code[20];
        CurrFactor: Decimal;
        Curr: Decimal;
        CurrCode: Code[10];
        Desc: Text[100];
        Amt: Decimal;
        SP: Code[20];
        ExDoc: Code[20];
        DocDate: Date;
        DueDate: Date;
        DocType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        BalType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        Cust: Record Customer;
        CPG: Record "Customer Posting Group";
}

