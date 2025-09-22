report 50251 "Create Pack Handheld"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50251_Report_CreatePackHandheld.rdlc';

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                CuNOPPortal.CreatePackHandHeld(cdWarehouseShipmentNO);
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
                        Caption = 'Warehouse Shipment No';
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

