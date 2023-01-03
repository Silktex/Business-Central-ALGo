tableextension 50206 "Cust. Ledger Entry_Ext" extends "Cust. Ledger Entry"
{
    fields
    {
        field(50000; "Sales Invoice Ref."; Code[20])
        {
            Caption = 'Sales Invoice Ref.';
            Description = 'Sales Invoice Ref.';
            Editable = false;
        }
        field(50007; "Future/Paid Invoice"; Boolean)
        {
            Caption = 'Future/Paid Invoice';
        }
        field(50008; "Ref. Document No."; Code[20])
        {
            Caption = 'Ref. Document No.';
        }
        field(50016; "Detailed Entry"; Code[20])
        {
            Caption = 'Detailed Entry';
            Editable = false;
            TableRelation = "Detailed Cust. Ledg. Entry"."Document No." WHERE("Cust. Ledger Entry No." = FIELD("Entry No."));
        }
        field(50017; "Future/Paid to Apply"; Boolean)
        {
            Caption = 'Future/Paid to Apply';
        }
        field(50018; "Sales Order No."; Code[20])
        {
            CalcFormula = Lookup("Sales Invoice Header"."Order No." WHERE("No." = FIELD("Document No.")));
            Description = 'NOP';
            FieldClass = FlowField;
        }
        field(50019; "Sales Payment No."; Code[20])
        {
            CalcFormula = Lookup("Cust. Ledger Entry"."Document No." WHERE("Document Type" = FILTER(Payment), "Entry No." = FIELD("Closed by Entry No.")));
            Description = 'NOP';
            FieldClass = FlowField;
        }
        field(50021; "Agreement No."; Code[20])
        {
            Caption = 'Agreement No.';
            // TableRelation = Table50061.Field2 WHERE(Field1 = FIELD("Customer No."));//VR same error in old verison
        }
        field(50022; Skip; Boolean)
        {
        }
    }
    keys
    {
        key(key50; "Future/Paid to Apply")
        {

        }
    }
    procedure PaidInvoice(recCustLedgerEntry: Record "Cust. Ledger Entry")
    var
        pgPF: Page "Paid/Future Invoice";
        recCust: Record Customer;
        recPF: Record "Payment Future Old Inv";
    begin
        recCust.GET(recCustLedgerEntry."Customer No.");
        IF recCust."Future Old Invoice" THEN BEGIN
            recPF.RESET;
            recPF.FILTERGROUP(2);
            recPF.SETRANGE(recPF."Document No.", recCustLedgerEntry."Document No.");
            recPF.SETRANGE(recPF."Customer No.", recCust."No.");
            recPF.SETRANGE(recPF."Entry No.", recCustLedgerEntry."Entry No.");
            recPF.FILTERGROUP(0);
            pgPF.SETTABLEVIEW(recPF);
            pgPF.RUN;
        END ELSE
            ERROR('Future Paid Invoice must be true on customer card');
    end;

}
