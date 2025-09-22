report 50038 "Sales Price Expire Days Update"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50038_Report_SalesPriceExpireDaysUpdate.rdlc';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");

            trigger OnAfterGetRecord()
            begin
                Customer."Sales Price Expire Days" := 90;
                MODIFY;
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
}

