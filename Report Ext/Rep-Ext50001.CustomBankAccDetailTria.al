reportextension 50001 "Custom Bank Acc. - Detail Tria" extends "Bank Acc. - Detail Trial Bal."
{
    RDLCLayout = './Report Ext/BankAccDetailTrialBalExt.rdlc';

    dataset
    {
        modify("Bank Account Ledger Entry")
        {
            trigger OnAfterAfterGetRecord()
            var
                Cust: Record Customer;
                Vend: Record Vendor;
                GLAcc: Record "G/L Account";
            begin
                SalesOrderNo := '';
                if "Source Code" = 'SALES' then
                    Case "Bal. Account Type" of
                        "Bal. Account Type"::Customer:
                            begin
                                Cust.get("Bal. Account No.");
                                if Description <> Cust.Name then
                                    Description := Cust.Name;
                                if SalesInvHeader.get("Document No.") then
                                    SalesOrderNo := SalesInvHeader."Order No.";
                            end;
                        "Bal. Account Type"::Vendor:
                            begin
                                Vend.get("Bal. Account No.");
                                if Description <> Vend.Name then
                                    Description := Vend.Name;
                            end;
                        "Bal. Account Type"::"G/L Account":
                            begin
                                GLAcc.get("Bal. Account No.");
                                if Description <> GLAcc.Name then
                                    Description := GLAcc.Name;
                            end;
                    End;
            end;
        }

        add("Bank Account Ledger Entry")
        {
            column(SalesOrderNo; SalesOrderNo)
            {
            }
        }
    }

    var
        SalesOrderNo: Code[20];
        SalesInvHeader: Record "Sales Invoice Header";
}
