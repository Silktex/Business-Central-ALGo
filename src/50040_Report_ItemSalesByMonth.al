report 50040 "Item Sales By Month"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50040_Report_ItemSalesByMonth.rdlc';

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING("Entry No.") ORDER(Ascending) WHERE("Entry Type" = FILTER(Sale));
            RequestFilterFields = "Item No.", "Posting Date", "Location Code";
            column(ItemNo_ItemLedgerEntry; "Item No.")
            {
            }
            column(Description; recItem.Description)
            {
            }
            column(PostingDate_ItemLedgerEntry; "Posting Date")
            {
            }
            column(LocationCode_ItemLedgerEntry; "Location Code")
            {
            }
            column(Quantity_ItemLedgerEntry; Quantity)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF recItem.GET("Item No.") THEN;
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
        lblItemNo = 'Item No.';
        lblDescription = 'Description';
        lblLocationCode = 'Location Code';
    }

    var
        recItem: Record Item;
}

