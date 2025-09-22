report 50062 "Update Whse Ship No. in SSH"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50062_Report_UpdateWhseShipNoinSSH.rdlc';

    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                PostedWhseShipmentLine.RESET;
                PostedWhseShipmentLine.SETRANGE("Posted Source Document", PostedWhseShipmentLine."Posted Source Document"::"Posted Shipment");
                PostedWhseShipmentLine.SETRANGE("Posted Source No.", "Sales Shipment Header"."No.");
                IF PostedWhseShipmentLine.FINDFIRST THEN BEGIN
                    "Sales Shipment Header"."Warehouse Shipment No." := PostedWhseShipmentLine."Whse. Shipment No.";
                    "Sales Shipment Header".MODIFY;
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
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
}

