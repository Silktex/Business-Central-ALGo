report 90005 BatchJobGLE
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/90005_Report_BatchJobGLE.rdlc';

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = WHERE("Bal. Account Type" = CONST(Vendor));
            dataitem(Vendor; Vendor)
            {
                DataItemLink = "No." = FIELD("Bal. Account No.");

                trigger OnAfterGetRecord()
                begin
                    RecVPG.RESET;
                    RecVPG.SETRANGE(Code, Vendor."Vendor Posting Group");
                    IF RecVPG.FINDFIRST THEN BEGIN
                        RecGLE.RESET;
                        RecGLE.SETRANGE("Document No.", "G/L Entry"."Document No.");
                        RecGLE.SETRANGE(RecGLE."Bal. Account Type", RecGLE."Bal. Account Type"::"Bank Account");
                        IF RecGLE.FINDFIRST THEN BEGIN
                            RecGLE."G/L Account No." := RecVPG."Payables Account";
                            RecGLE.MODIFY;
                        END;
                    END;
                end;
            }

            trigger OnPreDataItem()
            begin
                SETFILTER("Posting Date", '%1..%2', 20160601D, 20160831D);
            end;
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

    labels
    {
    }

    var
        RecVPG: Record "Vendor Posting Group";
        RecGLE: Record "G/L Entry";
}

