report 50254 "Finish Pack HandHeld"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50254_Report_FinishPackHandHeld.rdlc';

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                CuNOPPortal.FinishPackHandHeld(PackingNo);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PackingNo; PackingNo)
                    {
                        Caption = 'Packing No';
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CuNOPPortal: Codeunit ecomPortal;
        cdWarehouseShipmentNO: Code[20];
        PackingNo: Code[20];
        BoxCode: Code[20];
        NoOfLots: Decimal;
}

