table 50010 "Multiple Payment"
{
    DrillDownPageID = 50010;
    LookupPageID = 50010;

    fields
    {
        field(1; "Order No."; Code[20])
        {
        }
        field(2; "Credit Card No."; Code[20])
        {
            TableRelation = "DO Payment Credit Card" WHERE("Customer No." = FIELD("Customer No."));

            trigger OnValidate()
            begin
                /*recMP.RESET;
                recMP.SETRANGE("Document Type","Document Type");
                recMP.SETRANGE("Order No.","Order No.");
                //recMP.SETRANGE("Customer No.","Customer No.");
                recMP.SETRANGE("Credit Card No.","Credit Card No.");
                recMP.SETFILTER("Entry No.",'<>%1',"Entry No.");
                //recMP.SETFILTER("Entry No.",'<>%1',0);
                IF recMP.FIND('-') THEN BEGIN */
                /*
                DPTLE.RESET;
                DPTLE.SETRANGE("Document Type","Document Type");
                DPTLE.SETRANGE("Document No.","Order No.");
                //DPTLE.SETRANGE(DPTLE."Transaction Status",DPTLE."Transaction Status"::Captured);
                DPTLE.SETRANGE("Credit Card No.","Credit Card No.");
                IF DPTLE.FIND('-') THEN// BEGIN
                   ERROR('First Finish previous entry for same credit card');
              //END;
              */

                CALCFIELDS("Transaction Status");
                IF "Transaction Status" = "Transaction Status"::Captured THEN
                    ERROR('Can not make change in Amout Transaction is Captured')

            end;
        }
        field(3; "Amount to Capture"; Decimal)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Credit Card No.");
                IF recSalesHeader.GET("Document Type", "Order No.") THEN BEGIN
                    decAmount := 0;
                    recSalesLine.RESET;
                    recSalesLine.SETRANGE("Document Type", "Document Type");
                    recSalesLine.SETRANGE("Document No.", "Order No.");
                    IF recSalesLine.FIND('-') THEN
                        REPEAT
                            IF recSalesLine.Quantity <> 0 THEN
                                decAmount := decAmount + recSalesLine.Amount * recSalesLine."Qty. to Invoice" / recSalesLine.Quantity;
                        UNTIL recSalesLine.NEXT = 0;
                    decAmount := ROUND(decAmount);

                    recMP.RESET;
                    recMP.SETRANGE("Document Type", "Document Type");
                    recMP.SETRANGE("Order No.", "Order No.");
                    recMP.SETRANGE("Customer No.", "Customer No.");
                    recMP.SETFILTER("Entry No.", '<>%1', "Entry No.");
                    IF recMP.FIND('-') THEN BEGIN
                        REPEAT
                            decAmount := decAmount - recMP."Amount to Capture";
                        UNTIL recMP.NEXT = 0;
                    END;
                    IF decAmount < "Amount to Capture" THEN
                        ERROR('Can not make Payment more than %1', FORMAT(decAmount));
                END;

                CALCFIELDS("Transaction Status");
                IF "Transaction Status" = "Transaction Status"::Captured THEN
                    ERROR('Can not make change in Amout Transaction is Captured');
            end;
        }
        field(4; "Entry No."; Integer)
        {
            Editable = false;
        }
        field(5; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(6; "Customer No."; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(7; "Transaction Result"; Option)
        {
            CalcFormula = Lookup("DO Payment Trans. Log Entry".Result WHERE("Payment Entry No." = FIELD("Entry No.")));
            Caption = 'Transaction Result';
            FieldClass = FlowField;
            OptionCaption = ' ,Success,Failed';
            OptionMembers = " ",Success,Failed;
        }
        field(8; "Transaction Status"; Option)
        {
            CalcFormula = Lookup("DO Payment Trans. Log Entry"."Transaction Status" WHERE("Payment Entry No." = FIELD("Entry No.")));
            Caption = 'Transaction Status';
            FieldClass = FlowField;
            OptionCaption = ' ,Voided,Expired,Captured,Refunded,Posting Not Finished';
            OptionMembers = " ",Voided,Expired,Captured,Refunded,"Posting Not Finished";
        }
    }

    keys
    {
        key(Key1; "Order No.", "Credit Card No.", "Entry No.", "Document Type", "Customer No.")
        {
            Clustered = true;
        }
        key(Key2; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        /*
        DPTLE.RESET;
        DPTLE.SETRANGE("Document Type","Document Type");
        DPTLE.SETRANGE("Document No.","Order No.");
        DPTLE.SETRANGE(DPTLE."Transaction Status",DPTLE."Transaction Status"::"3");
        DPTLE.SETRANGE("Entry No.","Entry No.");
        IF DPTLE.FIND('-') THEN// BEGIN
           ERROR('Can not delete capture entry');
        DPTLE.RESET;
        DPTLE.SETRANGE("Document Type","Document Type");
        DPTLE.SETRANGE("Document No.","Order No.");
        //DPTLE.SETRANGE(DPTLE."Transaction Status",DPTLE."Transaction Status"::Captured);
        DPTLE.SETRANGE("Entry No.","Entry No.");
        IF DPTLE.FIND('-') THEN// BEGIN
           IF NOT (DPTLE."Transaction Status" IN [DPTLE."Transaction Status"::"3",DPTLE."Transaction Status"::"4"]) THEN BEGIN
                DPTLE.DELETE;
        
        
              END;
        */

    end;

    trigger OnInsert()
    begin
        recMP.RESET;
        recMP.SETCURRENTKEY("Entry No.");
        IF recMP.FIND('+') THEN
            "Entry No." := recMP."Entry No." + 1;
    end;

    trigger OnModify()
    begin
        /*
        DPTLE.RESET;
        DPTLE.SETRANGE("Document Type","Document Type");
        DPTLE.SETRANGE("Document No.","Order No.");
        DPTLE.SETRANGE(DPTLE."Transaction Status",DPTLE."Transaction Status"::"3");
        DPTLE.SETRANGE("Entry No.","Entry No.");
        IF DPTLE.FIND('-') THEN// BEGIN
           ERROR('Can not Modify capture entry');
        */

    end;

    var
        recSalesHeader: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        decAmount: Decimal;
        recMP: Record "Multiple Payment";
}

