report 50004 "UPS Label Report"
{
    ProcessingOnly = true;
    UseRequestPage = false;
    UseSystemPrinter = false;

    dataset
    {
        dataitem("Tracking No."; "Tracking No.")
        {
            RequestFilterFields = "Warehouse Shipment No";

            trigger OnAfterGetRecord()
            begin
                FOR i := 1 TO 30 DO BEGIN
                    txtData[i] := '';
                END;
                CLEAR(DataText);
                CALCFIELDS(Image);
                IF Image.HASVALUE THEN BEGIN
                    Image.CREATEINSTREAM(DataStream);
                    DataText.READ(DataStream);

                    //DataText.GETSUBTEXT(Value,1);
                    Length := DataText.LENGTH;
                    //  UpdateText;
                    //CLEAR(NavPrinter);

                    // IF ISCLEAR(NavPrinter) THEN BEGIN
                    //     Result := CREATE(NavPrinter, TRUE, TRUE);
                    //     //abpRecTempBlob.CALCFIELDS(Blob);
                    //NavPrinter.DirectPrint('ZEBLABEL',DataText);
                    recPrinterSelection.RESET;
                    recPrinterSelection.SETRANGE("Report ID", 50004);
                    recPrinterSelection.SETRANGE("User ID", USERID);
                    IF recPrinterSelection.FIND('-') THEN
                        txtPrinterName := recPrinterSelection."Printer Name"
                    ELSE BEGIN
                        recPrinterSelection.RESET;
                        recPrinterSelection.SETRANGE("Report ID", 50004);
                        recPrinterSelection.SETRANGE("User ID", '');
                        IF recPrinterSelection.FIND('-') THEN
                            txtPrinterName := recPrinterSelection."Printer Name"
                        ELSE
                            txtPrinterName := '';
                    END;
                    // NavPrinter.DirectPrint(txtPrinterName, DataText);
                    /* NavPrinter.DirectPrint(txtPrinterName,txtData[1]+txtData[2]+txtData[3]+txtData[4]+txtData[5]+txtData[6]+txtData[7]+txtData[8]+txtData[9]+txtData[10]+
                     txtData[11]+txtData[12]+txtData[13]+txtData[14]+txtData[15]+txtData[16]+txtData[17]+txtData[18]+txtData[19]+txtData[20]+
                     txtData[21]+txtData[22]+txtData[23]+txtData[24]+txtData[25]+txtData[26]+txtData[27])*/
                    CLEAR(DataText);
                    ERROR('Printed Successfully');
                    //NavPrinter.DirectPrint('Brother MFC-8810DW Printer',DataText)
                    //SLEEP(10000);
                    //CLEAR(NavPrinter);
                    //END;

                END;
                //EXIT(EncryptionMgt.Decrypt(Value));

            end;

            trigger OnPostDataItem()
            begin
                //CLEARALL;
                //IF NOT ISCLEAR(NavPrinter) THEN
                //CLEAR(NavPrinter);
            end;

            trigger OnPreDataItem()
            begin
                IF cdNo1 <> '' THEN
                    SETRANGE("Warehouse Shipment No", cdNo1);
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
        TrackingNo: Text[30];
        //  Xmlhttp: Automation;
        Result: Boolean;
        //NavPrinter: Automation;
        recPrinterSelection: Record "Printer Selection";
        txtPrinterName: Text[250];


    procedure UpdateText()
    begin
        i := 0;
        IF Length <> 0 THEN
            REPEAT

                i += 1;
                IF Length > i * 1000 THEN
                    //int1:=i*1000-999

                    DataText.GETSUBTEXT(txtData[i], i * 1000 - 999, 1000)
                ELSE
                    DataText.GETSUBTEXT(txtData[i], i * 1000 - 999, Length);


            UNTIL Length <= i * 1000;
    end;


    procedure InitVar(cdNo: Code[20]; trckNo: Text[30])
    begin
        cdNo1 := cdNo;
        TrackingNo := trckNo;
    end;
}

