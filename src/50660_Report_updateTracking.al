report 50660 updateTracking
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50660_Report_updateTracking.rdlc';

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                cuPortal.InsertTransferOrder('EXP/41/15-16', 'Boat');
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
        cuPortal: Codeunit "Portal CU";
}

