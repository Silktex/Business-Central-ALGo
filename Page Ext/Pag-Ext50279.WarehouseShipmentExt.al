pageextension 50279 "Warehouse Shipment_Ext" extends "Warehouse Shipment"
{
    layout
    {
        modify("Zone Code")
        {
            Visible = false;
            Enabled = false;
        }
        modify("Bin Code")
        {
            Visible = false;
            Enabled = false;
        }
        addafter("Sorting Method")
        {
            field("Charges Pay By"; Rec."Charges Pay By")
            {
                Editable = BlChargesPayBy;
                ApplicationArea = all;
            }
            field("Tracking No."; Rec."Tracking No.")
            {
                ApplicationArea = all;
            }
            field("Tracking Status"; Rec."Tracking Status")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("RocketShip Tracking No."; Rec."RocketShip Tracking No.")
            {
                Caption = 'Tracking No.';
                ApplicationArea = all;
            }
            field("No. of Boxes"; Rec."No. of Boxes")
            {
                Visible = blNoOfBoxes;
                ApplicationArea = all;
            }
            field("Shipment Time"; Rec."Shipment Time")
            {
                ApplicationArea = all;
            }
            field("Track On Header"; Rec."Track On Header")
            {
                ApplicationArea = all;
            }
            field(Picture; Rec.Picture)
            {
                ApplicationArea = all;
                trigger OnAssistEdit()
                var
                    outFile: File;
                    Istream1: InStream;
                    Line: Text;
                    Text1: array[10] of Text[1024];
                    OStream: OutStream;
                    Tempblob: Codeunit "Temp Blob";
                    FileName: Text;
                    FileManagement: Codeunit "File Management";
                    DataText: BigText;
                begin
                    CLEAR(Istream1);
                    Rec.CALCFIELDS(Picture);

                    IF Rec.Picture.HASVALUE THEN BEGIN
                        Rec.Picture.CREATEINSTREAM(Istream1);
                        DataText.READ(Istream1);
                        //PrinterSelection(50003, txtPrinterName);
                        ZPLPrintLable(DataText, txtPrinterName);
                        //ERROR('Printed Successfully');
                    END;

                    /*
                    
                    Rec.Picture.CREATEINSTREAM(Istream1);
                    //outFile.CREATE('\\silk4\share\ShippingLabels\ImageURL' + '.txt');
                    FileName := 'ImageURL.txt';
                    //outFile.CREATEOUTSTREAM(OStream);
                    Tempblob.CreateOutStream(OStream);
                    WHILE NOT Istream1.EOS DO BEGIN
                        Istream1.READTEXT(Line);
                        OStream.WRITETEXT(Line);
                    END;

                    CLEAR(Istream1);
                    // outFile.CLOSE();
                    DownloadFromStream(Istream1, '', '\\silk4\share\ShippingLabels\ImageURL', '', FileName);
                    CurrPage.UPDATE;

                    HYPERLINK('\\silk4\share\ShippingLabels\ImageURL' + '.txt');
                    */
                    //FileManagement.BLOBExport(TempBlob, 'ImageURL.txt', true);
                end;
            }
            field("Service Type"; Rec."Service Type")
            {
                Editable = false;
                Visible = blServiceType;
                ApplicationArea = all;
            }
            field("Gross Weight LB"; Rec."Gross Weight LB")
            {
                Visible = blGrossWeightLB;
                ApplicationArea = all;

                trigger OnValidate()
                begin
                    IF Rec."Gross Weight LB" <> xRec."Gross Weight LB" THEN BEGIN
                        Rec."Service Type" := Rec."Service Type"::USPS;
                        IF Rec."Gross Weight LB" > 0 THEN BEGIN
                            Rec."Gross Weight Oz" := 0;
                        END;
                        IF Rec."Gross Weight LB" = 0 THEN
                            Rec."Service Type" := Rec."Service Type"::" ";
                    END;
                end;
            }
            field("Gross Weight Oz"; Rec."Gross Weight Oz")
            {
                Visible = blGrossWeightOz;
                ApplicationArea = all;

                trigger OnValidate()
                begin
                    IF Rec."Gross Weight Oz" <> xRec."Gross Weight Oz" THEN BEGIN
                        Rec."Service Type" := Rec."Service Type"::USFC;
                        IF Rec."Gross Weight Oz" > 0 THEN
                            Rec."Gross Weight LB" := 0;
                        IF Rec."Gross Weight Oz" = 0 THEN
                            Rec."Service Type" := Rec."Service Type"::" ";
                    END;
                end;
            }
            field("Gross Weight"; Rec."Gross Weight")
            {
                Visible = blGrossWeight;
                ApplicationArea = all;
            }
            field("Handling Charges"; Rec."Handling Charges")
            {
                ApplicationArea = all;
            }
            field("Insurance Amount"; Rec."Insurance Amount")
            {
                Caption = 'Insured Value';
                ApplicationArea = all;
            }
            field("Insurance Charges"; Rec."Insurance Charges")
            {
                Visible = blInsuranceCharges;
                ApplicationArea = all;
            }
            field(Path; Rec.Path)
            {
                ApplicationArea = all;
            }
            field("Cash On Delivery"; Rec."Cash On Delivery")
            {
                Visible = blCashOnDelivery;
                ApplicationArea = all;
            }
            field("Signature Required"; Rec."Signature Required")
            {
                ApplicationArea = all;
            }
            field("Third Party"; Rec."Third Party")
            {
                Visible = blThirdParty;
                ApplicationArea = all;
            }
            field("Third Party Account No."; Rec."Third Party Account No.")
            {
                Visible = blThirdPartyAccountNo;
                ApplicationArea = all;
            }
            field("Label Type"; Rec."Label Type")
            {
                Enabled = LabelBool;
                ApplicationArea = all;
            }

            field("Box Code"; Rec."Box Code")
            {
                CaptionClass = txtBox;
                ApplicationArea = all;
            }
            field("Shipping Account No."; Rec."Shipping Account No.")
            {
                Visible = blShippingAccountNo;
                ApplicationArea = all;
            }
            field("Freight Amount"; Rec."Freight Amount")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("COD Amount"; Rec."COD Amount")
            {
                Visible = blCODAmount;
                ApplicationArea = all;
            }
            field("Packing List No."; Rec."Packing List No.")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Label Type"; "Shipping Agent Code")
        modify("Shipping Agent Code")
        {
            trigger OnbeforeValidate()
            begin
                //Meghna Begin
                IF Rec."Shipping Agent Code" <> xRec."Shipping Agent Code" THEN BEGIN
                    IF Rec."Shipping Agent Code" = 'STAMPS' THEN BEGIN
                        BlChargesPayBy := FALSE;
                        blNoOfBoxes := FALSE;
                        blInsuranceCharges := FALSE;
                        blShippingAccountNo := FALSE;
                        blThirdParty := FALSE;
                        blThirdPartyAccountNo := FALSE;
                        blGrossWeight := FALSE;
                        blCashOnDelivery := FALSE;
                        blCODAmount := FALSE;
                    END ELSE BEGIN
                        BlChargesPayBy := TRUE;
                        blNoOfBoxes := TRUE;
                        blInsuranceCharges := TRUE;
                        blShippingAccountNo := TRUE;
                        blThirdParty := TRUE;
                        blThirdPartyAccountNo := TRUE;
                        blGrossWeight := TRUE;
                        blCashOnDelivery := TRUE;
                        blCODAmount := TRUE;
                    END;

                    IF Rec."Shipping Agent Code" = 'STAMPS' THEN BEGIN
                        blGrossWeightLB := TRUE;
                        blGrossWeightOz := TRUE;
                        blServiceType := TRUE;
                    END ELSE BEGIN
                        blGrossWeightLB := FALSE;
                        blGrossWeightOz := FALSE;
                        blServiceType := FALSE;
                    END;
                END;
                CurrPage.UPDATE();
                //Meghna END
            end;
        }
        moveafter("Shipping Agent Code"; "Shipping Agent Service Code")

    }
    actions
    {
        addafter("Create Pick")
        {
            //Tarun Printer RND Begin
            action("DirectPrintTest")
            {
                Caption = 'DirectPrintTest';
                ApplicationArea = all;

                trigger OnAction()
                var
                    RecRef: RecordRef;

                begin
                    PrinterSelection(10077, txtPrinterName);
                    RecRef.GetTable(Rec);
                    REPORT.Print(7317, '', txtPrinterName, RecRef);
                end;
            }
            //Tarun Printer RND End
            action("Check Zprinter")
            {
                ApplicationArea = all;
                trigger OnAction()
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
                    PdfOutStrem: OutStream;
                    PdfInStream: InStream;
                begin
                    Rec.CalcFields(Picture);
                    Rec.Picture.CreateInStream(instream);
                    instream.ReadText(Bodytext);
                    Message(Bodytext);
                    WebClientURL := 'http://api.labelary.com/v1/printers/8dpmm/labels/4x3/';


                    HttpWebContent.WriteFrom(instream);
                    HttpWebContent.GetHeaders(ContentHeaders);
                    //ContentHeaders.Clear();

                    ContentHeaders.Remove('Accept');
                    ContentHeaders.Add('Accept', 'application/pdf');
                    ContentHeaders.Remove('Content-Type');

                    ContentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');
                    ContentHeaders.Remove('Content-Length');
                    ContentHeaders.Add('Content-Length', format(StrLen(Bodytext)));

                    RequestMsg.Content := HttpWebContent;
                    RequestMsg.SetRequestUri(WebClientURL);
                    RequestMsg.Method := 'POST';
                    HttpWebClient.Send(RequestMsg, HttpWebResponse);

                    HttpWebResponse.Content().ReadAs(Istream1);
                    // Istream1.ReadText(Bodytext);
                    //Message(Bodytext);
                    //Rec.CALCFIELDS(Picture);
                    //Istream1.ReadText(FileName);
                    //Message(FileName);
                    FileName := 'Zfile.pdf';

                    DownloadFromStream(Istream1, '', '', '', FileName);
                    // Rec."Test ZPrinter".CREATEINSTREAM(Istream1);

                    // Rec.Modify(true);
                    // rec.CalcFields("Test ZPrinter");
                    // if rec."Test ZPrinter".HasValue then
                    //     Message('Value');
                    // CurrPage.UPDATE;
                end;
            }

            action(ShipRequest)
            {
                Caption = 'ShipRequest';
                Image = "Event";
                ApplicationArea = all;

                trigger OnAction()
                var
                    recWhseShip: Record "Warehouse Shipment Header";
                    DataText: BigText;
                    DataStream: InStream;
                begin
                    recPackingHeader.RESET;
                    recPackingHeader.SETRANGE("Source Document Type", recPackingHeader."Source Document Type"::"Warehouse Shipment");
                    recPackingHeader.SETRANGE("Source Document No.", Rec."No.");
                    recPackingHeader.SETRANGE("Void Entry", FALSE);
                    recPackingHeader.SETFILTER("Tracking No.", '<>%1', '');
                    IF recPackingHeader.FINDFIRST THEN
                        ERROR('The Shipment level is already genrated by RocketShipIt if you want to Re-Genrate first Void IT');

                    recShipReqTrackingNo.RESET;
                    recShipReqTrackingNo.SETRANGE("Warehouse Shipment No", Rec."No.");
                    recShipReqTrackingNo.SETRANGE("Void Entry", FALSE);
                    IF recShipReqTrackingNo.FINDFIRST THEN
                        ERROR('The Shipment level is already genrated by ShipRequest if you want to Re-Genrate first Void IT');

                    IF Rec."Shipping Agent Code" = 'FEDEX' THEN BEGIN
                        IF Rec."Tracking No." = '' THEN BEGIN
                            cuTest.StandardOverNight(Rec);
                            //CurrPage.UPDATE;
                            COMMIT;
                            //rptTest.InitVar("No.");
                            //rptTest.RUN;
                            recWhseShip.RESET;
                            recWhseShip.SETRANGE("No.", Rec."No.");
                            IF recWhseShip.FIND('-') THEN BEGIN
                                CLEAR(DataText);
                                recWhseShip.CALCFIELDS(Picture);
                                IF recWhseShip.Picture.HASVALUE THEN BEGIN
                                    recWhseShip.Picture.CREATEINSTREAM(DataStream);
                                    DataText.READ(DataStream);
                                    //PrinterSelection(50003, txtPrinterName);
                                    ZPLPrintLable(DataText, txtPrinterName);
                                    ERROR('Printed Successfully');
                                END;
                            END;
                        END;
                    END;
                    // IF Rec."Shipping Agent Code" = 'UPS' THEN BEGIN
                    //     recTrackingNo.RESET;
                    //     recTrackingNo.SETRANGE("Warehouse Shipment No", Rec."No.");
                    //     IF NOT recTrackingNo.FIND('-') THEN BEGIN
                    //         Rec.TESTFIELD("No. of Boxes");
                    //         Rec.TESTFIELD("Shipping Agent Service Code");
                    //         Rec.TESTFIELD(Status, Rec.Status::Released);
                    //         //cuTest.UPSRequest(Rec); //not in use
                    //         COMMIT;
                    //         //Handheld BEGIN
                    //         recTrackingNo.RESET;
                    //         recTrackingNo.SETRANGE("Warehouse Shipment No", Rec."No.");
                    //         IF recTrackingNo.FINDFIRST THEN BEGIN
                    //             recPackingLine.RESET;
                    //             recPackingLine.SETRANGE("Source Document Type", recPackingLine."Source Document Type"::"Warehouse Shipment");
                    //             recPackingLine.SETRANGE(recPackingLine."Source Document No.", Rec."No.");
                    //             recPackingLine.SETRANGE(recPackingLine."Void Entry", FALSE);
                    //             IF recPackingLine.FINDSET THEN BEGIN
                    //                 recPackingLine."Tracking No." := recTrackingNo."Tracking No.";
                    //                 recTrackingNo.CALCFIELDS(Image);
                    //                 recPackingLine.Image := recTrackingNo.Image;
                    //                 recPackingLine.MODIFY;
                    //             END;
                    //         END;
                    //         //Handheld END
                    //         // rptTest1.InitVar(Rec."No.", '');
                    //         // rptTest1.RUN;
                    //     END;
                    //END;

                    //Stamps BEGIN
                    IF Rec."Shipping Agent Code" = 'STAMPS' THEN BEGIN
                        recTrackingNo.RESET;
                        recTrackingNo.SETRANGE("Warehouse Shipment No", Rec."No.");
                        IF NOT recTrackingNo.FIND('-') THEN BEGIN
                            Rec.TESTFIELD("Service Type");
                            Rec."Shipment Time" := TIME;
                            Rec.MODIFY(FALSE);
                            Rec.TESTFIELD(Status, Rec.Status::Released);
                            cuTest.StampsEndicia(Rec);
                            COMMIT;
                            recWhseShip.RESET;
                            recWhseShip.SETRANGE("No.", Rec."No.");
                            IF recWhseShip.FIND('-') THEN BEGIN
                                CLEAR(DataText);
                                recWhseShip.CALCFIELDS(Picture);
                                IF recWhseShip.Picture.HASVALUE THEN BEGIN
                                    recWhseShip.Picture.CREATEINSTREAM(DataStream);
                                    DataText.READ(DataStream);
                                    PrinterSelection(50003, txtPrinterName);
                                    ZPLPrintLable(DataText, txtPrinterName);
                                    ERROR('Printed Successfully');
                                END;
                            END;
                        END;
                    END;
                    //Stamps END

                    // SLEEP(2000);
                    // PrintLable;
                    //Ashwini
                end;
            }
            action(VoidShipRequest)
            {
                Caption = 'Void Ship Request';
                Image = VoidCheck;
                ApplicationArea = all;

                trigger OnAction()
                var
                    recWhseShip: Record "Warehouse Shipment Header";
                    DataText: BigText;
                    DataStream: InStream;
                begin
                    //Stamps BEGIN
                    IF Rec."Shipping Agent Code" = 'STAMPS' THEN BEGIN
                        recTrackingNo.RESET;
                        recTrackingNo.SETRANGE("Warehouse Shipment No", Rec."No.");
                        IF recTrackingNo.FIND('-') THEN BEGIN
                            Rec.TESTFIELD("Tracking No.");
                            Rec.MODIFY(FALSE);
                            Rec.TESTFIELD(Status, Rec.Status::Released);
                            cuTest.VoidStampsEndicia(Rec);
                        END;
                    END;
                    //Stamps END

                    //FedEx BEGIN
                    IF Rec."Shipping Agent Code" = 'FEDEX' THEN BEGIN
                        recTrackingNo.RESET;
                        recTrackingNo.SETRANGE("Warehouse Shipment No", Rec."No.");
                        IF recTrackingNo.FIND('-') THEN BEGIN
                            Rec.TESTFIELD("Tracking No.");
                            Rec.TESTFIELD(Status, Rec.Status::Released);
                            cuTest.VoidStampsFedEx(Rec, recTrackingNo);
                        END;
                    END;
                    //FedEx END
                end;
            }
            action(RePrintLabel)
            {
                Caption = 'Re-Print Label';
                ApplicationArea = all;

                trigger OnAction()
                var
                    DataText: BigText;
                    DataStream: InStream;
                    txtData: array[30] of Text[1000];
                    Length: Integer;
                    TrackingNo: Text[30];
                    Result: Boolean;
                    recPrinterSelection: Record "Printer Selection";
                    txtPrinterName: Text[250];
                    isActive: Boolean;
                    recPostedWhseShip: Record "Warehouse Shipment Header";
                begin
                    IF (Rec."Shipping Agent Code" = 'UPS') OR (Rec."Shipping Agent Code" = 'ENDICIA') THEN BEGIN
                        recTrackingNo.RESET;
                        recTrackingNo.SETRANGE(recTrackingNo."Warehouse Shipment No", Rec."No.");
                        IF recTrackingNo.FIND('-') THEN BEGIN
                            CLEAR(DataText);
                            recTrackingNo.CALCFIELDS(Image);
                            IF recTrackingNo.Image.HASVALUE THEN BEGIN
                                recTrackingNo.Image.CREATEINSTREAM(DataStream);
                                DataText.READ(DataStream);
                                PrinterSelection(50004, txtPrinterName);
                                ZPLPrintLable(DataText, txtPrinterName);
                                ERROR('Printed Successfully');
                            END;
                        END;
                    END ELSE BEGIN
                        IF Rec."Shipping Agent Code" = 'FEDEX' THEN BEGIN
                            recTrackingNo.RESET;
                            recTrackingNo.SETRANGE("Warehouse Shipment No", Rec."No.");
                            IF recTrackingNo.FIND('-') THEN BEGIN
                                CLEAR(DataText);
                                recTrackingNo.CALCFIELDS(Image);
                                IF recTrackingNo.Image.HASVALUE THEN BEGIN
                                    recTrackingNo.Image.CREATEINSTREAM(DataStream);
                                    DataText.READ(DataStream);
                                    PrinterSelection(50003, txtPrinterName);
                                    ZPLPrintLable(DataText, txtPrinterName);
                                    ERROR('Printed Successfully');
                                END;
                            END ELSE BEGIN
                                recPostedWhseShip.RESET;
                                recPostedWhseShip.SETRANGE("No.", Rec."No.");
                                IF recPostedWhseShip.FIND('-') THEN BEGIN
                                    CLEAR(DataText);
                                    recPostedWhseShip.CALCFIELDS(Picture);
                                    IF recPostedWhseShip.Picture.HASVALUE THEN BEGIN
                                        recPostedWhseShip.Picture.CREATEINSTREAM(DataStream);
                                        DataText.READ(DataStream);
                                        PrinterSelection(50003, txtPrinterName);
                                        ZPLPrintLable(DataText, txtPrinterName);
                                        ERROR('Printed Successfully');
                                    END;
                                END;
                            END;
                        END;
                    END;
                    //rptTest.InitVar("No.");
                    //rptTest.RUN;
                    //END;
                end;
            }
            action("Tracking No")
            {
                Caption = 'Tracking No.';
                RunObject = Page "Tracking No";
                RunPageLink = "Warehouse Shipment No" = FIELD("No.");
                ApplicationArea = all;
            }
            action("Calculate COD")
            {
                Caption = 'Calculate COD';
                ApplicationArea = all;

                trigger OnAction()
                begin
                    TotalAmount := 0;
                    recWhseShipLine.RESET;
                    recWhseShipLine.SETRANGE("No.", Rec."No.");
                    recWhseShipLine.SETFILTER("Qty. to Ship", '<>%1', 0);
                    IF recWhseShipLine.FIND('-') THEN BEGIN
                        REPEAT
                            recSalesLine.RESET;
                            recSalesLine.SETRANGE("Document No.", recWhseShipLine."Source No.");
                            recSalesLine.SETRANGE("Line No.", recWhseShipLine."Source Line No.");

                            IF recSalesLine.FIND('-') THEN BEGIN
                                REPEAT
                                    //TotalAmount:=TotalAmount+recWhseShipLine."Qty. to Ship"*recSalesLine."Unit Price";
                                    //Ashwini

                                    TotalAmount := TotalAmount + ((recWhseShipLine."Qty. to Ship" * recSalesLine."Unit Price")
                                     - (recWhseShipLine."Qty. to Ship" * recSalesLine."Unit Price" * recSalesLine."Line Discount %") / 100);
                                //+ "Handling Charges" + "Insurance Amount";

                                //Ashwini
                                UNTIL recSalesLine.NEXT = 0;
                            END;
                        UNTIL recWhseShipLine.NEXT = 0;
                    END;
                    Rec."COD Amount" := TotalAmount;
                    CurrPage.UPDATE;
                end;
            }
            action("Calculate Insured Value")
            {
                Caption = 'Calculate Insured Value';
                ApplicationArea = all;

                trigger OnAction()
                var
                    CuNOPPortal: Codeunit ecomPortal;
                begin
                    CuNOPPortal.CalculateInsuredValue(Rec."No.");
                end;
            }
        }
        addafter("F&unctions")
        {
            group("Void Shipment")
            {
                Caption = 'Void Shipment';
                Image = Post;

                //Rocket Functionlity removeds
                // action(Action1000000038)
                // {
                //     Caption = 'Void Shipment';
                //     ApplicationArea = all;
                //     Image = View;

                //     trigger OnAction()
                //     var
                //         Print_Answer: Integer;
                //         Print_Question: Label 'RocketShipIt, ShipRequest';
                //     begin
                //         Print_Answer := DIALOG.STRMENU(Print_Question, 3, 'Which Shipment you want to Void it');
                //         IF (Print_Answer = 1) THEN BEGIN
                //             SLEEP(2000);
                //             cuTest.RocketShipItVoid(Rec);
                //         END;
                //         IF (Print_Answer = 2) THEN BEGIN
                //             SLEEP(2000);
                //             cuTest.VoidShipRequest(Rec);
                //         END;
                //     end;
                // }
                action(OpenVoidedTrackingNo)
                {
                    Caption = 'Open Voided ShipRequest';
                    Image = View;
                    RunObject = Page "Voided Tracking No (ShipReq.)";
                    RunPageLink = "Warehouse Shipment No" = FIELD("No.");
                    ApplicationArea = all;
                }

            }
        }


        addbefore("P&ost Shipment")
        {
            action("Generate/Open Packing List")
            {
                Caption = 'Generate/Open Packing List';
                Image = PickWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    RecPackingHead: Record "Packing Header";
                    recWhseShptLines: Record "Warehouse Shipment Line";
                begin
                    Rec.CALCFIELDS("Packing List No.");                             //ENDINT1.0
                    IF Rec."Packing List No." = '' THEN BEGIN
                        RecPackingHead.RESET;
                        RecPackingHead.INIT;
                        RecPackingHead.VALIDATE(RecPackingHead."Source Document Type", RecPackingHead."Source Document Type"::"Warehouse Shipment");
                        RecPackingHead.VALIDATE(RecPackingHead."Source Document No.", Rec."No.");
                        //Handheld BEGIN
                        recWhseShptLines.RESET;
                        recWhseShptLines.SETRANGE(recWhseShptLines."Source Document", recWhseShptLines."Source Document"::"Sales Order");
                        recWhseShptLines.SETRANGE(recWhseShptLines."No.", Rec."No.");
                        IF recWhseShptLines.FINDFIRST THEN
                            RecPackingHead.VALIDATE("Sales Order No.", recWhseShptLines."Source No.");
                        //Handheld END
                        RecPackingHead.INSERT(TRUE);
                        PAGE.RUN(50021, RecPackingHead);
                        //"Packing List No.":=RecPackingHead."Packing No.";
                        Rec.MODIFY;
                    END ELSE BEGIN
                        IF CONFIRM('Packing List already created. Do you want to open?') THEN BEGIN
                            RecPackingHead.RESET;
                            RecPackingHead.SETRANGE("Packing No.", Rec."Packing List No.");
                            RecPackingHead.SETRANGE(RecPackingHead."Void Entry", FALSE);
                            IF RecPackingHead.FINDFIRST THEN
                                PAGE.RUN(50021, RecPackingHead);
                        END;
                    END;
                    //ENDINT1.0
                end;
            }
        }
        modify("P&ost Shipment")
        {
            trigger OnBeforeAction()
            var
                RecPackHead: Record "Packing Header";
                Text102: Label 'Do you want to proceed without Tracking No. ?';
            begin
                //ENDINT1.0
                IF (Rec."Shipping Agent Code" = 'ENDICIA') AND (Rec."Label Type" = Rec."Label Type"::International) THEN BEGIN
                    IF Rec."Packing List No." = '' THEN
                        ERROR('Please create packing list before posting');
                END;

                RecPackHead.RESET;
                IF RecPackHead.GET(Rec."Packing List No.") THEN
                    RecPackHead.TESTFIELD(RecPackHead.Status, RecPackHead.Status::Release);

                //Meghna Amar issue BEGIN
                IF (Rec."Shipping Agent Code" <> '') AND (Rec."Tracking No." = '') THEN BEGIN
                    IF NOT CONFIRM(Text102, FALSE, '') THEN
                        Rec.TESTFIELD("Tracking No.");
                END;
                //Meghna Amar issue END
            end;

            trigger OnAfterAction()
            var
                RecPackHead: Record "Packing Header";
            begin
                RecPackHead.RESET;
                IF RecPackHead.GET(Rec."Packing List No.") THEN BEGIN
                    RecPackHead.Status := RecPackHead.Status::Closed;
                    RecPackHead.MODIFY;
                    Rec."Packing List No." := '';
                    Rec.MODIFY;
                END;
                //ENDINT1.0
            end;
        }
        modify("Post and &Print")
        {
            trigger OnBeforeAction()
            var
                Text102: TextConst ENU = 'Do you want to proceed without Tracking No. ?', ESM = '¨Confirma que desea registrar el/la %1?', FRC = 'Dsirez-vous reporter la %1?;ENC=Do you want to post the %1?';
            begin
                //Meghna Amar issue BEGIN
                IF (Rec."Shipping Agent Code" <> '') AND (Rec."Tracking No." = '') THEN BEGIN
                    IF NOT CONFIRM(Text102, FALSE, '') THEN
                        Rec.TESTFIELD("Tracking No.");
                END;
                //Meghna Amar issue END
            end;
        }
        addafter("P&osting")
        {
            group(Stamps)
            {
                Caption = 'Stamps';
                action(AddBalance)
                {
                    ApplicationArea = Advanced;
                    Caption = 'Add Stamp Balance';
                    Image = Add;

                    trigger OnAction()
                    var
                        ReturnRespnceMessage: Text;
                        AddStampPostage: Report "Add Postage in Stamps";
                        ControlTotal: Decimal;
                        Result: Boolean;
                        LastPurchaseAmount: Decimal;
                        NoSeriesMgt: Codeunit NoSeriesManagement;
                        CompInfo: Record "Company Information";
                        IntegratorTxID: Code[20];
                    begin
                        //Meghna BEGIN
                        IF IntegratorTxID = '' THEN BEGIN
                            CompInfo.GET();
                            CompInfo.TESTFIELD("Stamp Postage Nos.");
                            NoSeriesMgt.InitSeries(CompInfo."Stamp Postage Nos.", CompInfo."Stamp Postage Nos.", TODAY, IntegratorTxID, CompInfo."Stamp Postage Nos.");
                            COMMIT;
                        END;


                        GetToken(ReturnRespnceMessage);
                        Result := GetControlTotal(ReturnRespnceMessage, ControlTotal, LastPurchaseAmount);
                        IF Result THEN BEGIN
                            AddStampPostage.AddControlTotal(ControlTotal, LastPurchaseAmount, IntegratorTxID);
                            AddStampPostage.RUNMODAL();
                        END;
                        //Meghna END
                    end;
                }
                action(CheckStampsBalance)
                {
                    ApplicationArea = Advanced;
                    Caption = 'Check Stamps Balance';
                    Image = Check;

                    trigger OnAction()
                    var
                        ReturnRespnceMessage: Text;
                    begin
                        //Meghna BEGIN
                        GetToken(ReturnRespnceMessage);
                        CheckAccountInfo(ReturnRespnceMessage);
                        //Meghna END
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //ENDINT1.0
        IF Rec."Shipping Agent Code" = 'ENDICIA' THEN
            txtBox := 'Piece Shape'
        ELSE
            txtBox := 'Box Code';
        IF Rec."Shipping Agent Code" = 'ENDICIA' THEN
            LabelBool := TRUE
        ELSE
            LabelBool := FALSE;
        //ENDINT1.0

        IF Rec."Shipping Agent Code" = 'STAMPS' THEN BEGIN
            BlChargesPayBy := FALSE;
            blNoOfBoxes := FALSE;
            blInsuranceCharges := FALSE;
            blShippingAccountNo := FALSE;
            blThirdParty := FALSE;
            blThirdPartyAccountNo := FALSE;
            blGrossWeight := FALSE;
            blCashOnDelivery := FALSE;
            blCODAmount := FALSE;
        END ELSE BEGIN
            BlChargesPayBy := TRUE;
            blNoOfBoxes := TRUE;
            blInsuranceCharges := TRUE;
            blShippingAccountNo := TRUE;
            blThirdParty := TRUE;
            blThirdPartyAccountNo := TRUE;
            blGrossWeight := TRUE;
            blCashOnDelivery := TRUE;
            blCODAmount := TRUE;
        END;
        IF Rec."Shipping Agent Code" = 'STAMPS' THEN BEGIN
            blGrossWeightLB := TRUE;
            blGrossWeightOz := TRUE;
            blServiceType := TRUE;
        END ELSE BEGIN
            blGrossWeightLB := FALSE;
            blGrossWeightOz := FALSE;
            blServiceType := FALSE;
        END;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        //ENDINT1.0
        IF Rec."Shipping Agent Code" = 'ENDICIA' THEN
            txtBox := 'Piece Shape'
        ELSE
            txtBox := 'Box Code';
        IF Rec."Shipping Agent Code" = 'ENDICIA' THEN
            LabelBool := TRUE
        ELSE
            LabelBool := FALSE;
        //ENDINT1.0
    end;

    trigger OnOpenPage()
    begin
        //ENDINT1.0
        IF Rec."Shipping Agent Code" = 'ENDICIA' THEN
            txtBox := 'Piece Shape'
        ELSE
            txtBox := 'Box Code';
        IF Rec."Shipping Agent Code" = 'ENDICIA' THEN
            LabelBool := TRUE
        ELSE
            LabelBool := FALSE;
        //ENDINT1.0

        IF Rec."Shipping Agent Code" = 'STAMPS' THEN BEGIN
            BlChargesPayBy := FALSE;
            blNoOfBoxes := FALSE;
            blInsuranceCharges := FALSE;
            blShippingAccountNo := FALSE;
            blThirdParty := FALSE;
            blThirdPartyAccountNo := FALSE;
            blGrossWeight := FALSE;
            blCashOnDelivery := FALSE;
            blCODAmount := FALSE;
        END ELSE BEGIN
            BlChargesPayBy := TRUE;
            blNoOfBoxes := TRUE;
            blInsuranceCharges := TRUE;
            blShippingAccountNo := TRUE;
            blThirdParty := TRUE;
            blThirdPartyAccountNo := TRUE;
            blGrossWeight := TRUE;
            blCashOnDelivery := TRUE;
            blCODAmount := TRUE;
        END;
        IF Rec."Shipping Agent Code" = 'STAMPS' THEN BEGIN
            blGrossWeightLB := TRUE;
            blGrossWeightOz := TRUE;
            blServiceType := TRUE;
        END ELSE BEGIN
            blGrossWeightLB := FALSE;
            blGrossWeightOz := FALSE;
            blServiceType := FALSE;
        END;
    end;

    var
        cuTest: Codeunit "Integration Fedex UPS";
        // rptTest: Report "FedEx Label Report";
        recTrackingNo: Record "Tracking No.";
        //rptTest1: Report "UPS Label Report";
        recWhseShipLine: Record "Warehouse Shipment Line";
        recSalesLine: Record "Sales Line";
        TotalAmount: Decimal;
        txtBox: Text;
        [InDataSet]

        LabelBool: Boolean;
        recWhseShipLine1: Record "Warehouse Shipment Line";
        recSalesHeader: Record "Sales Header";
        recPackingLine: Record "Packing Line";
        recPackingHeader: Record "Packing Header";
        intLen: Integer;
        // Xmlhttp: Automation;
        Result: Boolean;
        recShipReqTrackingNo: Record "Tracking No.";
        recPrinterSelection: Record "Printer Selection";
        txtPrinterName: Text[250];
        PrintServerIP: Text[50];
        decWeight: Decimal;
        decWeight1: Decimal;
        BlChargesPayBy: Boolean;
        blNoOfBoxes: Boolean;
        blInsuranceCharges: Boolean;
        blShippingAccountNo: Boolean;
        blThirdParty: Boolean;
        blThirdPartyAccountNo: Boolean;
        blGrossWeightLB: Boolean;
        blGrossWeight: Boolean;
        blGrossWeightOz: Boolean;
        blCashOnDelivery: Boolean;
        blCODAmount: Boolean;
        blServiceType: Boolean;
        CompInfo: Record "Company Information";

    procedure PrintLable()
    var
        DataText: BigText;
        DataStream: InStream;
        txtData: array[30] of Text[1000];
        Length: Integer;
        TrackingNo: Text[30];
        Result: Boolean;
        recPrinterSelection: Record "Printer Selection";
        txtPrinterName: Text[250];
        isActive: Boolean;
    begin
        IF (Rec."Shipping Agent Code" = 'UPS') OR (Rec."Shipping Agent Code" = 'ENDICIA') THEN BEGIN
            recTrackingNo.RESET;
            recTrackingNo.SETRANGE(recTrackingNo."Warehouse Shipment No", Rec."No.");
            IF recTrackingNo.FIND('-') THEN BEGIN
                CLEAR(DataText);
                recTrackingNo.CALCFIELDS(Image);
                IF recTrackingNo.Image.HASVALUE THEN BEGIN
                    recTrackingNo.Image.CREATEINSTREAM(DataStream);
                    DataText.READ(DataStream);
                    PrinterSelection(50004, txtPrinterName);
                    ZPLPrintLable(DataText, txtPrinterName);
                    ERROR('Printed Successfully');
                END;
            END;
        END ELSE BEGIN
            // rptTest.InitVar(Rec."No.");
            // rptTest.RUN;
        END;
    end;

    procedure PrintLableHandheld(WarehouseNo: Code[20])
    var
        DataText: BigText;
        DataStream: InStream;
        txtData: array[30] of Text[1000];
        Length: Integer;
        TrackingNo: Text[30];
        Result: Boolean;
        recPrinterSelection: Record "Printer Selection";
        txtPrinterName: Text[250];
        isActive: Boolean;
        recWarehouseShipment: Record "Warehouse Shipment Header";
    begin
        recWarehouseShipment.RESET;
        recWarehouseShipment.SETRANGE(recWarehouseShipment."No.", WarehouseNo);
        IF recWarehouseShipment.FINDSET THEN BEGIN
            IF (recWarehouseShipment."Shipping Agent Code" = 'UPS') OR (recWarehouseShipment."Shipping Agent Code" = 'ENDICIA') THEN BEGIN
                recPackingHeader.RESET;
                recPackingHeader.SETRANGE("Source Document Type", recPackingHeader."Source Document Type"::"Warehouse Shipment");
                recPackingHeader.SETRANGE("Source Document No.", recWarehouseShipment."No.");
                IF recPackingHeader.FINDFIRST THEN BEGIN
                    recPackingLine.RESET;
                    recPackingLine.SETRANGE("Source Document Type", recPackingLine."Source Document Type"::"Warehouse Shipment");
                    recPackingLine.SETRANGE("Source Document No.", recWarehouseShipment."No.");
                    recPackingLine.SETRANGE("Packing No.", recPackingHeader."Packing No.");
                    IF recPackingLine.FIND('-') THEN BEGIN
                        CLEAR(DataText);
                        recPackingLine.CALCFIELDS(Image);
                        IF recPackingLine.Image.HASVALUE THEN BEGIN
                            recPackingLine.Image.CREATEINSTREAM(DataStream);
                            DataText.READ(DataStream);
                            // PrinterSelection(50004, txtPrinterName);
                            //ZPLPrintLable(DataText, txtPrinterName);
                            ERROR('Printed Successfully');
                        END;
                    END;
                END;
            END ELSE BEGIN
                // rptTest.InitVar(recWarehouseShipment."No.");
                // rptTest.RUN;
            END;
        END;
    end;

    local procedure "--ZPL Printer---"()
    begin
    end;

    procedure ZPLPrintLable(DataText: BigText; txtPrinterName: Text[250])
    var
        DataStream: InStream;
        Base64String: Text;
        TempBlob: Codeunit "Temp Blob";
        OStream: OutStream;
        FileName: Text;
    begin
        // TempBlob.INIT;
        TempBlob.CREATEOUTSTREAM(OStream);
        OStream.WRITETEXT(FORMAT(DataText));
        //CLEAR(DataText);
        CLEAR(DataStream);
        TempBlob.CREATEINSTREAM(DataStream);
        DataText.ADDTEXT(Base64String);
        FileName := Rec."No." + '.pdf';
        DownloadFromStream(DataStream, '', '', '', FileName);
    end;

    local procedure PrinterSelection(ReportID: Integer; var txtPrinterName: Text[250])
    var
        recPrinterSelection: Record "Printer Selection";
    begin
        recPrinterSelection.RESET;
        recPrinterSelection.SETRANGE("Report ID", ReportID);
        recPrinterSelection.SETRANGE("User ID", USERID);
        IF recPrinterSelection.FIND('-') THEN
            txtPrinterName := recPrinterSelection."Printer Name"
        ELSE BEGIN
            recPrinterSelection.RESET;
            recPrinterSelection.SETRANGE("Report ID", ReportID);
            recPrinterSelection.SETRANGE("User ID", '');
            IF recPrinterSelection.FIND('-') THEN
                txtPrinterName := recPrinterSelection."Printer Name"
            ELSE
                txtPrinterName := '';
        END;
    end;

    local procedure "--Stamps--"()
    begin
    end;

    local procedure GetToken(var ReturnRespnceMessage: Text)
    var
        // Stamps: DotNet ShippingServices;
        // ReturnMessage: Text;
        // bl: Boolean;
        // RetAuthenticateUser: DotNet RetAuthenticateUser;
        jsonstring: Text;
        URL: Text;
    begin
        CompInfo.GET();
        jsonstring := '{'
          + '"Credentials":{'
            + '"IntegrationID":"' + CompInfo."Stamps Integration ID" + '",'
            + '"Username":"' + CompInfo."Stamps Username" + '",'
            + '"Password":"' + CompInfo."Stamps Password" + '"'
          + '}'
        + '}';

        URL := CompInfo."Stamps URL";

        // Stamps := Stamps.ShippingServices();
        // RetAuthenticateUser := Stamps.AuthenticateUser(jsonstring, URL);
        // bl := RetAuthenticateUser.Status();
        // ReturnMessage := RetAuthenticateUser.Message();
        // ReturnRespnceMessage := RetAuthenticateUser.Authenticator;
    end;

    local procedure CheckAccountInfo(ReturnRespnceMessage: Text)
    var
        // Stamps: DotNet ShippingServices;
        // jsonstring: Text;
        // RetGetAccountInfo: DotNet RetGetAccountInfo;
        bl: Boolean;
        ReturnMessage: Text;
        txtResponse: Text;
        Control_Total: Decimal;
        Purchase_Amount: Decimal;
        URL: Text;
    begin
        CompInfo.GET();
        // jsonstring := '{'
        //   + '"Item": "' + ReturnRespnceMessage + '"'
        // + '}';

        // URL := CompInfo."Stamps URL";

        // Stamps := Stamps.ShippingServices();
        // RetGetAccountInfo := Stamps.GetAccountInfo(jsonstring, URL);
        // bl := RetGetAccountInfo.Status();
        // ReturnMessage := RetGetAccountInfo.Message();
        // Control_Total := RetGetAccountInfo.Control_Total();
        // Purchase_Amount := RetGetAccountInfo.Purchase_Amount();
        IF bl THEN
            MESSAGE('In your Stamps Account Purchase Amount %1 & Control Total is %2', Purchase_Amount, Control_Total)
        ELSE
            MESSAGE('Not Getting Stamps Responce');
    end;

    local procedure GetControlTotal(ReturnRespnceMessage: Text; var Control_Total: Decimal; var Purchase_Amount: Decimal) Result: Boolean
    var
        // Stamps: DotNet ShippingServices;
        // jsonstring: Text;
        // RetGetAccountInfo: DotNet RetGetAccountInfo;
        // bl: Boolean;
        ReturnMessage: Text;
        txtResponse: Text;
        URL: Text;
    begin
        CompInfo.GET();
        // jsonstring := '{'
        //   + '"Item": "' + ReturnRespnceMessage + '"'
        // + '}';

        // URL := CompInfo."Stamps URL";

        // Stamps := Stamps.ShippingServices();
        // RetGetAccountInfo := Stamps.GetAccountInfo(jsonstring, URL);
        // bl := RetGetAccountInfo.Status();
        // Control_Total := RetGetAccountInfo.Control_Total();
        // Purchase_Amount := RetGetAccountInfo.Purchase_Amount();
        // EXIT(bl);
    end;

}
