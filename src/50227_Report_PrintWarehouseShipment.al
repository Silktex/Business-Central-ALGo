report 50227 PrintWarehouseShipment
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50227_Report_PrintWarehouseShipment.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin

                Return := NOPPortal.PrintWarehouseShipment('102128');

                MESSAGE('%1', Return);
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
        NOPPortal: Codeunit ecomPortal;
        Return: Text[250];
}

