report 50709 "Stock Report Lot & Bin wise"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50709_Report_StockReportLotBinwise.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Warehouse Entry"; "Warehouse Entry")
        {
            DataItemTableView = SORTING("Location Code", "Item No.", "Variant Code", "Zone Code", "Bin Code", "Lot No.");
            RequestFilterFields = "Location Code", "Item No.", "Lot No.", "Bin Code";
            column(Item_No; txtdata[1])
            {
            }
            column(Item_Name; txtdata[2])
            {
            }
            column(Description; txtdata[3])
            {
            }
            column(Item_Cat; txtdata[4])
            {
            }
            column(Prod_Group; txtdata[5])
            {
            }
            column(UOM; txtdata[6])
            {
            }
            column(Location; txtdata[7])
            {
            }
            column(Lot_No; txtdata[8])
            {
            }
            column(Bin_Code; txtdata[9])
            {
            }
            column(decQty; decQty)
            {
            }

            trigger OnAfterGetRecord()
            begin


                recWarehouseEntry.RESET;
                recWarehouseEntry.SETCURRENTKEY("Location Code", "Item No.", "Lot No.", "Bin Code");
                recWarehouseEntry.SETRANGE(recWarehouseEntry."Entry No.", "Entry No.");
                recWarehouseEntry.SETRANGE(recWarehouseEntry."Registering Date", dtStartDate, dtEndDate);
                IF recWarehouseEntry.FIND('-') THEN BEGIN
                    txtdata[7] := recWarehouseEntry."Location Code";
                    txtdata[8] := recWarehouseEntry."Lot No.";
                    txtdata[9] := recWarehouseEntry."Bin Code";
                    txtdata[3] := recWarehouseEntry."Zone Code";

                END;

                decQty := 0;
                recWarehouseEntry.RESET;
                recWarehouseEntry.SETCURRENTKEY("Location Code", "Item No.", "Lot No.", "Bin Code");
                //recWarehouseEntry.SETRANGE(recWarehouseEntry."Entry No.","Entry No.");
                recWarehouseEntry.SETRANGE(recWarehouseEntry."Registering Date", dtStartDate, dtEndDate);
                recWarehouseEntry.SETRANGE(recWarehouseEntry."Location Code", "Location Code");
                recWarehouseEntry.SETRANGE(recWarehouseEntry."Item No.", "Item No.");
                recWarehouseEntry.SETRANGE(recWarehouseEntry."Lot No.", "Lot No.");
                recWarehouseEntry.SETRANGE(recWarehouseEntry."Bin Code", "Bin Code");
                IF recWarehouseEntry.FIND('-') THEN BEGIN
                    REPEAT
                        decQty += recWarehouseEntry.Quantity;
                    UNTIL recWarehouseEntry.NEXT = 0;
                END;

                recITEM.RESET;
                recITEM.SETRANGE(recITEM."No.", recWarehouseEntry."Item No.");
                IF recITEM.FIND('-') THEN BEGIN
                    txtdata[1] := recITEM."No.";
                    txtdata[2] := recITEM.Description;
                    //txtdata[3] := recITEM."Description 2";
                    txtdata[4] := recITEM."Item Category Code";
                    txtdata[5] := recITEM."Item Category Code";
                    txtdata[6] := recITEM."Base Unit of Measure";

                END;
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
                    field(dtStartDate; dtStartDate)
                    {
                        Caption = 'From Date';
                        ApplicationArea = all;
                    }
                    field(dtEndDate; dtEndDate)
                    {
                        Caption = 'To Date';
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
            dtStartDate := 20140101D;
            dtEndDate := TODAY;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin

        IF dtStartDate = 0D THEN
            ERROR('Please select From Date');

        IF dtEndDate = 0D THEN
            ERROR('Please Select To Date');

        /*stdate:=0d;

        dtStartDate := 0D;
        dtEndDate := TODAY; */

    end;

    var
        recWarehouseEntry: Record "Warehouse Entry";
        dtStartDate: Date;
        dtEndDate: Date;
        decQty: Decimal;
        recITEM: Record Item;
        txtdata: array[255] of Text[255];
        stdate: Date;
}

