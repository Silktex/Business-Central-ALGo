report 50211 "Update SL"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/Report_50211_UpdateSL.rdlc';

    dataset
    {
        dataitem("Sales Invoice Line"; "Sales Invoice Line")
        {
            DataItemTableView = SORTING("Document No.", "Line No.");
            RequestFilterFields = "Document No.";

            trigger OnAfterGetRecord()
            begin
                "Bill-to Customer No." := 'C06371';
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

