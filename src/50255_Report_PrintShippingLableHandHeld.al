report 50255 "Print Shipping Lable HandHeld"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50255_Report_PrintShippingLableHandHeld.rdlc';

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                //Text:=CuNOPPortal.ShipRequestHandHeld(cdWarehouseShipmentNO);
                //Text:=CuNOPPortal.PrintWarehouseShipment(cdWarehouseShipmentNO);
                //MESSAGE('%1',Text);

                //bln:=CuNOPPortal.HandheldPrintRequest(cdWarehouseShipmentNO,Text1,Text2,Text3);
                //MESSAGE('%1',Text1);

                //CuNOPPortal.CalculateInsuredValue(cdWarehouseShipmentNO);
                CuNOPPortal.CreateTOWhsRcpt('3131');
            end;

            trigger OnPreDataItem()
            begin
                //cdWarehouseShipmentNO :=cdNo1;
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
        Text1: Text;
        bln: Boolean;
        Text2: Text;
        Text3: Text;


    procedure InitVar(cdNo: Code[20])
    begin
        //cdNo1:=cdNo;
    end;
}

