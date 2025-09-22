report 50064 "FedEx Label Report Posted"
{
    ProcessingOnly = true;
    UseRequestPage = false;
    UseSystemPrinter = false;

    dataset
    {
        dataitem("Posted Whse. Shipment Header"; "Posted Whse. Shipment Header")
        {
            CalcFields = Picture;
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                CLEAR(DataText);
                CALCFIELDS(Picture);
                IF Picture.HASVALUE THEN BEGIN
                    Picture.CREATEINSTREAM(DataStream);
                    DataText.READ(DataStream);
                    Length := DataText.LENGTH;

                    // IF ISCLEAR(NavPrinter) THEN
                    //     Result := CREATE(NavPrinter, TRUE, TRUE);
                    recPrinterSelection.RESET;
                    recPrinterSelection.SETRANGE("Report ID", 50003);
                    recPrinterSelection.SETRANGE("User ID", USERID);
                    IF recPrinterSelection.FIND('-') THEN
                        txtPrinterName := recPrinterSelection."Printer Name"
                    ELSE BEGIN
                        recPrinterSelection.RESET;
                        recPrinterSelection.SETRANGE("Report ID", 50003);
                        recPrinterSelection.SETRANGE("User ID", '');
                        IF recPrinterSelection.FIND('-') THEN
                            txtPrinterName := recPrinterSelection."Printer Name"
                        ELSE
                            txtPrinterName := '';
                    END;
                    //    NavPrinter.DirectPrint(txtPrinterName, DataText);
                    ERROR('Printed SuccessFully');
                END;
            end;

            trigger OnPreDataItem()
            begin
                IF cdNo1 <> '' THEN
                    SETRANGE("Whse. Shipment No.", cdNo1);
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
        DataText: BigText;
        DataStream: InStream;
        txtData: array[30] of Text[1000];
        Length: Integer;
        i: Integer;
        cdNo1: Code[20];
        // NavPrinter: Automation;
        Result: Boolean;
        recPrinterSelection: Record "Printer Selection";
        txtPrinterName: Text[250];


    procedure UpdateText()
    begin
        i := 0;
        REPEAT
            i += 1;
            IF Length > i * 1000 THEN
                DataText.GETSUBTEXT(txtData[i], i * 1000 - 999, 1000)
            ELSE
                DataText.GETSUBTEXT(txtData[i], i * 1000 - 999, Length);
        UNTIL Length <= i * 1000;
    end;


    procedure InitVar(cdNo: Code[20])
    begin
        cdNo1 := cdNo;
    end;
}

