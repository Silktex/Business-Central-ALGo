report 50226 "PO status"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {

            trigger OnAfterGetRecord()
            begin
                IF "Purchase Header".Status = "Purchase Header".Status::Released THEN BEGIN
                    "Purchase Header".Status := "Purchase Header".Status::Open;
                    "Purchase Header".MODIFY;
                END;
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

