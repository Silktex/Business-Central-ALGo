report 60000 "Bin Contant Update"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/60000_Report_BinContantUpdate.rdlc';

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                WITH BinContant DO BEGIN
                    IF FINDLAST THEN BEGIN
                        BinContant.INIT;
                        "Location Code" := 'SYOSSET';
                        "Zone Code" := 'PICK';
                        "Bin Code" := 'II2';
                        "Item No." := 'I10085-002';
                        "Bin Type Code" := 'STORAGE';
                        Quantity := 39.59;
                        "Quantity (Base)" := 39.59;
                        "Qty. per Unit of Measure" := 1;
                        "Unit of Measure Code" := 'YDS';
                        INSERT;
                    END;
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
        BinContant: Record "Bin Content";
}

