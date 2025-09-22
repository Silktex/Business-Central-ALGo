report 50252 "Finish Pick Handheld"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50252_Report_FinishPickHandheld.rdlc';

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                text := CuNOPPortal.RegisterActivityYesNo(cdWarehouseShipmentNO);
                MESSAGE(text);
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
                    field(cdWarehouseShipmentNO; cdWarehouseShipmentNO)
                    {
                        Caption = 'Sale Order no';
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
        text: Text[250];
}

