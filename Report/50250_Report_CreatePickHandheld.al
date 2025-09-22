report 50250 "Create Pick Handheld"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50250_Report_CreatePickHandheld.rdlc';

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                CuNOPPortal.CreateWarehouseShipment(cdWarehouseShipmentNO);
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
}

