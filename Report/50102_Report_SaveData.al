report 50102 "Save Data"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50102_Report_SaveData.rdlc';

    dataset
    {
        dataitem("DO Payment Trans. Log Entry"; "DO Payment Trans. Log Entry")
        {

            trigger OnAfterGetRecord()
            begin

                IF "DO Payment Trans. Log Entry"."Transaction Result" = "DO Payment Trans. Log Entry"."Transaction Result"::Success THEN
                    "DO Payment Trans. Log Entry".Result := "DO Payment Trans. Log Entry".Result::Success;
                MODIFY;
                IF "DO Payment Trans. Log Entry"."Transaction Result" = "DO Payment Trans. Log Entry"."Transaction Result"::Failed THEN
                    "DO Payment Trans. Log Entry".Result := "DO Payment Trans. Log Entry".Result::Failed;
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

