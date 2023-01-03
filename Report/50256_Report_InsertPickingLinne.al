report 50256 "InsertPicking Linne"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50256_Report_InsertPickingLinne.rdlc';

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                //Text:=CuNOPPortal.InsertNewPickingLines('SO18143','PI022836','I11150-021','LOT33815',54.14,30000);
                //Text:=CuNOPPortal.DeleteNewPickingLines('SO16486','PI022206','I11335-011',20002);
                //MESSAGE('%1',Text);

                //bl:=CuNOPPortal.HandheldPrintRequest('SH022870',Text1,Text2,Text3);
                //MESSAGE('%1',Text1);


                //bl:= CuNOPPortal.TOWhsePostRcptYesNo('RE002491');
                //MESSAGE('%1',bl);

                //bl:= CuNOPPortal.RegisterPutAwayYesNo('3126','PU002709');
                //MESSAGE('%1',bl);

                //bl:= CuNOPPortal.CreateTOWhsRcpt('3124');
                //MESSAGE('%1',bl);
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
                    field(cdWarehouseShipmentNO; cdWarehouseShipmentNO)
                    {
                        Caption = 'Warehouse Shipment NO';
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            cdWarehouseShipmentNO := cdNo1;
        end;
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
        Text: Text[250];
        cdNo1: Code[20];
        bl: Boolean;
        Text1: Text;
        Text2: Text;
        Text3: Text;
}

