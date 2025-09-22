pageextension 50281 "Posted Whse. Shipment_Ext" extends "Posted Whse. Shipment"
{
    layout
    {
        addafter("Assignment Time")
        {
            field("Freight Amount"; Rec."Freight Amount")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }
    actions
    {
        addafter("&Print")
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
            action(PackingSlip)
            {
                Caption = 'Packing Slip';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;

                trigger OnAction()
                var
                    recSalesHeader: Record "Sales Header";
                begin
                    CurrPage.SETSELECTIONFILTER(Rec);
                    REPORT.RUN(50080, TRUE, FALSE, Rec);
                end;
            }
        }
    }
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
