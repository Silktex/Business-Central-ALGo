pageextension 50283 "Posted Whse. Shipment List_Ext" extends "Posted Whse. Shipment List"
{
    actions
    {
        addafter(Card)
        {
            action(RePrintLabel)
            {
                Caption = 'Re-Print Label';
                Image = NewReceipt;
                Promoted = true;
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
                    recTrackingNo: Record "Tracking No.";
                    rptTest: Report "FedEx Label Report Posted";
                    recPostedWhseShip: Record "Posted Whse. Shipment Header";
                begin
                    IF (Rec."Shipping Agent Code" = 'UPS') OR (Rec."Shipping Agent Code" = 'ENDICIA') THEN BEGIN
                        recTrackingNo.RESET;
                        recTrackingNo.SETRANGE("Warehouse Shipment No", Rec."Whse. Shipment No.");
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
                            recTrackingNo.SETRANGE("Warehouse Shipment No", Rec."Whse. Shipment No.");
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
                            END ELSE BEGIN
                                recPostedWhseShip.RESET;
                                recPostedWhseShip.SETRANGE("Whse. Shipment No.", Rec."Whse. Shipment No.");
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
                end;
            }
        }
    }
    local procedure "--ZPL Printer---"()
    begin
    end;

    procedure ZPLPrintLable(DataText: BigText; txtPrinterName: Text[250])
    var
        DataStream: InStream;
        // MemoryStream: DotNet MemoryStream;
        // Bytes: DotNet Array;
        // Convert: DotNet Convert;
        Base64String: Text;
        TempBlob: Codeunit "Temp Blob";
        OStream: OutStream;
        // ZebraTCPConnection: DotNet TcpConnection;
        // ZebraConnection: DotNet Connection;
        OutString: Text;
    begin
        //TempBlob.INIT;
        TempBlob.CREATEOUTSTREAM(OStream);
        OStream.WRITETEXT(FORMAT(DataText));
        //CLEAR(DataText);
        CLEAR(DataStream);
        TempBlob.CREATEINSTREAM(DataStream);
        // MemoryStream := MemoryStream.MemoryStream();
        // COPYSTREAM(MemoryStream, DataStream);
        // Base64String := Convert.ToBase64String(MemoryStream.ToArray);
        DataStream.ReadText(OutString);
        DataText.ADDTEXT(OutString);
        //MESSAGE(Base64String);

        // ZebraConnection := ZebraTCPConnection.TcpConnection(txtPrinterName, 9100);
        // ZebraConnection.Open();
        // Bytes := Convert.FromBase64String(Base64String);
        // ZebraConnection.Write(Bytes);
    end;

    local procedure PrinterSelection(ReportID: Integer; var txtPrinterName: Text[250])
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
