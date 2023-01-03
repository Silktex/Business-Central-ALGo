report 50253 "Box Filled HandHeld"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50253_Report_BoxFilledHandHeld.rdlc';

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                CuNOPPortal.BoxFilledHandHeld(PackingNo, BoxCode, NoOfLots, 10, 12);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PackingNo; PackingNo)
                    {
                        Caption = 'Packing No';
                        ApplicationArea = all;
                    }
                    field(BoxCode; BoxCode)
                    {
                        Caption = 'Box Code';
                        ApplicationArea = all;
                    }
                    field(NoOfLots; NoOfLots)
                    {
                        Caption = 'No Of Lots';
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CuNOPPortal: Codeunit ecomPortal;
        cdWarehouseShipmentNO: Code[20];
        PackingNo: Code[20];
        BoxCode: Code[20];
        NoOfLots: Decimal;
}

