report 50081 "Packing Slip PSS"
{
    Caption = 'Whse. - Shipment';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            var
                MaxLinePerPage: Integer;
                LineCounter: Integer;
                TotalRecCount: Integer;
                ExpectedPageCount: Integer;
                PageCounter: Integer;
                RecCounter: Integer;
            begin
                ComInfo.GET();
                Contact.RESET;
                Contact.SETRANGE(Contact."No.", "Sell-to Contact No.");
                IF Contact.FINDFIRST THEN;

                MaxLinePerPage := 40;
                L := 365;
                txtLine := '';
                RWAL.RESET;
                RWAL.SETRANGE("Activity Type", RWAL."Activity Type"::Pick);
                RWAL.SETRANGE("Action Type", RWAL."Action Type"::Take);
                RWAL.SETRANGE("Whse. Document Type", RWAL."Whse. Document Type"::Shipment);
                RWAL.SETRANGE("Whse. Document No.", "Warehouse Shipment No.");
                IF RWAL.FINDSET THEN BEGIN
                    TotalRecCount := RWAL.COUNT;
                    EVALUATE(ExpectedPageCount, FORMAT(ROUND(TotalRecCount / MaxLinePerPage, 1, '>')));
                    LineCounter := 0;
                    RecCounter := 0;
                    PageCounter := 1;
                    txtLine := txtLine + HeaderData;

                    REPEAT
                        RecCounter += 1;
                        LineCounter += 1;

                        L += 20;
                        txtLine += '^FX|***Line row Variables***|^FS' +
                                  '^FO20,' + FORMAT(L) + '^FD' + RWAL."Lot No." + '^FS' +
                                  '^FO180,' + FORMAT(L) + '^FD' + RWAL.Description + '^FS' +
                                  '^FO450,' + FORMAT(L) + '^FD' + FORMAT(RWAL.Quantity) + '^FS' +
                                  '^FO550,' + FORMAT(L) + '^FD' + RWAL.Description + '^FS';

                        IF (LineCounter = MaxLinePerPage) AND (RecCounter <> TotalRecCount) THEN BEGIN
                            txtLine := txtLine + '' + '^XZ';

                            txtLine := txtLine + HeaderData;
                            LineCounter := 0;
                            L := 365;
                            PageCounter += 1;
                        END;


                    UNTIL RWAL.NEXT = 0;

                    //txtLine := txtLine+''+'^XZ';
                    txtLine := txtLine + '' + '^PQ2^LH0,0^XZ';
                END;
                Message('text Line %1', txtLine);
                DataText.ADDTEXT(txtLine);
                //PrinterSelection1(50003, txtPrinterName);                
                ZPLPrintLable(DataText);
                Message('Printed Successfully');
                //MESSAGE(txtLine);
            end;
        }
    }

    requestpage
    {
        Caption = 'Whse. - Posted Shipment';

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
        CurrReportPageNoCaptionLbl: Label 'Page';
        WarehouseShipmentCaptionLbl: Label 'Warehouse Shipment';
        txtSend: Text;
        ComInfo: Record "Company Information";
        txtLine: Text;
        L: Integer;
        RWAL: Record "Registered Whse. Activity Line";
        Contact: Record Contact;
        "--ZPL--": Integer;
        DataText: BigText;
        DataStream: InStream;
        TrackingNo: Text[30];
        //Xmlhttp: Automation;
        Result: Boolean;
        SpecialService: BigText;
        //MemoryStream: DotNet MemoryStream;
        //Bytes: DotNet Array;
        //Convert: DotNet Convert;
        Base64String: Text;
        // TempBlob: Record TempBlob temporary;
        OStream: OutStream;
        PrinterSelection: Record "Printer Selection";
        //ZebraConnection: DotNet Connection;
        //ZebraTCPConnection: DotNet TcpConnection;
        txtSendData: array[255] of Text;
        PageCount: Integer;
        txtPrinterName: Text[250];
        PrintServerIP: Text[50];

    local procedure HeaderData(): Text
    var
        HeaderText: Text;
    begin
        HeaderText := ('^XA' +
                  '^FX|***Label Length & Font Size 20***|^FS' +
                  '^LL1371^PW812' +
                  '^CFG, 20' +
                  '^FB812,1,0,C,0^FO0,10^FDPACKING LIST^FS' +
                  '^CFA,30' +
                  '^FB812,1,0,C,0^FO0,80^FDShipment# ' + "Sales Shipment Header"."No." + '^FS' +
                  '^CFA,15' +
                  '^FX|***From Variables***|^FS' +
                  '^FO20,110^FDFrom:^FS' +
                  '^FO20,130^FD' + ComInfo.Name + '^FS' +
                  '^FO20,150^FD' + ComInfo.Address + ' ' + ComInfo."Address 2" + '^FS' +
                  '^FO20,170^FD' + ComInfo.City + ' ' + ComInfo.County + ' ' + ComInfo."Post Code" + '^FS' +
                  '^FO20,190^FDPhone:  ' + ComInfo."Phone No." + '^FS' +
                  '^FO20,210^FDemail:  ' + ComInfo."E-Mail" + '^FS' +

                  '^FX|***Ship To variables***|^FS' +
                  '^FO420,110^FDShip To:^FS' +
                  '^FO420,130^FD' + "Sales Shipment Header"."Ship-to Name" + '^FS' +
                  '^FO420,150^FD' + "Sales Shipment Header"."Ship-to Address" + ' ' + "Sales Shipment Header"."Ship-to Address 2" + '^FS' +
                  '^FO420,170^FD' + "Sales Shipment Header"."Ship-to City" + ' ' + "Sales Shipment Header"."Ship-to County" + ' ' + "Sales Shipment Header"."Ship-to Post Code" + '^FS' +
                  '^FO420,190^FDPhone: ' + Contact."Phone No." + '^FS' +
                  '^FO420,210^FDemail: ' + Contact."E-Mail" + '^FS' +

                  '^FX|***Terms and other info***|^FS' +
                  '^FO20,240^FDPO# ' + "Sales Shipment Header"."External Document No." + '^FS' +
                  //'^FO20,260^FDPO Date: Dec 9, 2020^FS'+
                  //'^FO20,260^FDTrack# 1Z14X92606421231^FS'+
                  '^FO20,260^FDTrack: ' + FORMAT("Sales Shipment Header"."Package Tracking No.") + '^FS' +

                  '^FO420,240^FDTerms: ' + "Sales Shipment Header"."Payment Terms Code" + '^FS' +
                  '^FO420,260^FDShip Date: ' + FORMAT("Sales Shipment Header"."Shipment Date") + '^FS' +
                  '^FO420,280^FDSO# ' + "Sales Shipment Header"."Order No." + '^FS' +

                  '^FX|***HEADER DARK HORIZONTAL LINE***|^FS' +
                  '^FO3,300^GB800,5,5^FS' +

                   '^FX|***Line Row Labels***|^FS' +
                   '^FO20,320^FDRoll No^FS' +
                   '^FO180,320^FDOur Item^FS' +
                   '^FO450,320^FDQty^FS' +
                   '^FO550,320^FDCustomer Item^FS' +
                   '^FX|***Fixed Line***|^FS' +
                   //'^FO3,345^GB800,1,1^FS'+'');
                   '^FO3,345^GB800,1,1^FS' +
                   '^LH0,150' + '');
        EXIT(HeaderText);
    end;

    local procedure LineData()
    begin
    end;

    local procedure "--ZPL Printer---"()
    begin
    end;


    procedure ZPLPrintLable(pDataText: BigText)
    var
        outFile: File;
        Istream1: InStream;
        Line: Text;
        Text1: array[10] of Text[1024];
        OStream: OutStream;
        Tempblob: Codeunit "Temp Blob";
        FileName: Text;
        RequestMsg: HttpRequestMessage;
        ContentHeaders: HttpHeaders;
        HttpWebClient: HttpClient;
        HttpWebContent: HttpContent;
        HttpWebResponse: HttpResponseMessage;
        WebClientURL: Text[250];
        Bodytext: Text;
        instream: InStream;
        outstream: OutStream;
    begin
        Tempblob.CreateOutStream(outstream);
        pDataText.Write(outstream);
        Tempblob.CreateInStream(instream);
        //CopyStream(outstream, instream);

        instream.ReadText(Bodytext);

        Message('Body text %1', Bodytext);
        WebClientURL := 'http://api.labelary.com/v1/printers/8dpmm/labels/4x6/0/';
        HttpWebContent.WriteFrom(Bodytext);
        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');

        ContentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');
        ContentHeaders.Remove('Content-Length');
        ContentHeaders.Add('Content-Length', format(StrLen(Bodytext)));

        ContentHeaders.Remove('X-Rotation');
        ContentHeaders.Add('X-Rotation', format(0));

        RequestMsg.Content := HttpWebContent;
        RequestMsg.SetRequestUri(WebClientURL);
        RequestMsg.Method := 'POST';
        HttpWebClient.Send(RequestMsg, HttpWebResponse);

        HttpWebResponse.Content().ReadAs(Istream1);
        FileName := 'Zfile.png';

        DownloadFromStream(Istream1, '', '', '', FileName);
    end;

    local procedure PrinterSelection1(ReportID: Integer; var txtPrinterName: Text[250])
    var
        recPrinterSelection: Record "Printer Selection";
    begin
        recPrinterSelection.RESET;
        recPrinterSelection.SETRANGE("Report ID", ReportID);
        recPrinterSelection.SETRANGE("User ID", USERID);
        IF recPrinterSelection.FIND('-') THEN
            txtPrinterName := recPrinterSelection."Label Printer IP"
        ELSE BEGIN
            recPrinterSelection.RESET;
            recPrinterSelection.SETRANGE("Report ID", ReportID);
            recPrinterSelection.SETRANGE("User ID", '');
            IF recPrinterSelection.FIND('-') THEN
                txtPrinterName := recPrinterSelection."Label Printer IP"
            ELSE
                txtPrinterName := '';
        END;
    end;
}

