report 50000 "Sales Order11"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {

            trigger OnAfterGetRecord()
            begin
                Status := Status::Open;
                MODIFY(TRUE);
            end;

            trigger OnPostDataItem()
            begin
                MESSAGE('Done');
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

