report 50067 "Delete Item Category"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50067_Report_DeleteItemCategory.rdlc';

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                itemCat.RESET;
                itemCat.SETRANGE(Code, '');
                IF itemCat.FINDFIRST THEN BEGIN
                    itemCat.DELETE;
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

    var
        itemCat: Record "Item Category";
}

