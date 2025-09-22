report 50063 "MODIFY;"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50063_Report_MODIFY.rdlc';

    dataset
    {
        dataitem("Bin Content"; "Bin Content")
        {

            trigger OnAfterGetRecord()
            begin
                IF "Bin Content"."Item No." = 'S10721-001' THEN BEGIN
                    "Bin Content"."Zone Code" := 'PICK';
                    "Bin Content"."Bin Type Code" := 'STORAGE';
                    MODIFY;
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

