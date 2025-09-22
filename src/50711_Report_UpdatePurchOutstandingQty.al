report 50711 "Update Purch Outstanding Qty"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = WHERE (Number = CONST (1));
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
        PurchaseLine: Record "Purchase Line";
        OrderNo: Code[20];
        ItemNo: Code[20];
}

