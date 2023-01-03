report 50661 "Update Product Group Code in I"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50661_Report_UpdateProductGroupCodeinI.rdlc';

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.") WHERE("Item Category Code" = FILTER(''));

            trigger OnAfterGetRecord()
            begin
                Item."Item Category Code" := Item."Item Category Code";
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

