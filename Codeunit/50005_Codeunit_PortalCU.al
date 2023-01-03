codeunit 50005 "Portal CU"
{

    trigger OnRun()
    begin
        //GeneratePO('PO/14-15/0026');
    end;

    var
        WhseRegisterActivityYesNo: Codeunit "Whse.-Act.-RegisterWe (Yes/No)";


    procedure GenerateOC(var PDF: BigText; OrderNo: Code[30])
    var
        // Bytes: DotNet Array;
        // Convert: DotNet Convert;
        // MemoryStream: DotNet MemoryStream;
        IStream: InStream;
        SORec: Record "Sales Header";
        TempBlob: Codeunit "Temp Blob";
        Path: Text[250];
        FileName: Text[30];
        ThreeTierMgt: Codeunit "File Management";
        OutStram: OutStream;
        RecRef: RecordRef;
        Outstring: Text;
    begin
        //Path := ThreeTierMgt.GetDirectoryName(ThreeTierMgt.ServerTempFileName('.pdf')); //VR
        FileName := DELCHR(FORMAT(TODAY) + FORMAT(TIME), '=', '/:- ');
        SORec.RESET;
        SORec.SETFILTER("No.", '%1', OrderNo);
        IF SORec.FINDSET THEN begin
            //VR
            // IF REPORT.SAVEASPDF(50022, Path + FileName + '.pdf', SORec) THEN BEGIN
            //     TempBlob.INIT;
            //     TempBlob.Blob.IMPORT(Path + FileName + '.pdf');
            //     TempBlob.INSERT;
            //     TempBlob.Blob.CREATEINSTREAM(IStream);
            //     MemoryStream := MemoryStream.MemoryStream();
            //     COPYSTREAM(MemoryStream, IStream);
            //     Bytes := MemoryStream.GetBuffer();
            //     PDF.ADDTEXT(Convert.ToBase64String(Bytes));
            // END;
            //VR
            RecRef.GetTable(SORec);
            TempBlob.CreateOutStream(OutStram, TextEncoding::UTF16);
            IF REPORT.SAVEAS(50022, '', ReportFormat::Pdf, OutStram, RecRef) THEN BEGIN
                TempBlob.CREATEINSTREAM(IStream);
                IStream.ReadText(Outstring);
                PDF.ADDTEXT(Outstring);
            END;
        end;
    end;


    procedure GeneratevendorLedg(var PDF: BigText; VendNo: Code[20]; StartDate: Date; EndDate: Date)
    var
        // Bytes: DotNet Array;
        // Convert: DotNet Convert;
        // MemoryStream: DotNet MemoryStream;
        IStream: InStream;
        vENDRec: Record Vendor;
        TempBlob: Codeunit "Temp Blob";
        Path: Text[250];
        FileName: Text[30];
        ThreeTierMgt: Codeunit "File Management";
        rptVendorTrial: Report "Vendor - Detail Trial Balance";
        OutStram: OutStream;
        RecRef: RecordRef;
        Outstring: Text;
    begin
        // Path := ThreeTierMgt.GetDirectoryName(ThreeTierMgt.ServerTempFileName('.pdf'));
        FileName := DELCHR(FORMAT(TODAY) + FORMAT(TIME), '=', '/:- ');
        vENDRec.RESET;
        vENDRec.SETFILTER("No.", '%1', VendNo);
        vENDRec.SETFILTER(vENDRec."Date Filter", '%1', StartDate, EndDate);
        IF vENDRec.FINDSET THEN
            rptVendorTrial.SETTABLEVIEW(vENDRec);
        //   rptVendorTrial.Init(StartDate, EndDate);
        //VR
        // IF rptVendorTrial.SAVEASPDF(Path + FileName + '.pdf') THEN BEGIN
        //     // REPORT.SAVEASPDF(304,Path + FileName + '.pdf',vENDRec) THEN BEGIN
        //     TempBlob.INIT;
        //     TempBlob.Blob.IMPORT(Path + FileName + '.pdf');
        //     TempBlob.INSERT;
        //     TempBlob.Blob.CREATEINSTREAM(IStream);
        //     MemoryStream := MemoryStream.MemoryStream();
        //     COPYSTREAM(MemoryStream, IStream);
        //     Bytes := MemoryStream.GetBuffer();
        //     PDF.ADDTEXT(Convert.ToBase64String(Bytes));
        // END;
        TempBlob.CreateOutStream(OutStram, TextEncoding::UTF16);
        IF rptVendorTrial.SAVEAS('', ReportFormat::Pdf, OutStram) THEN BEGIN
            TempBlob.CREATEINSTREAM(IStream);
            IStream.ReadText(Outstring);
            PDF.AddText(Outstring);
        END;
    end;


    procedure GenerateSalesInv(var PDF: BigText; OrderNo: Code[30])
    var
        // Bytes: DotNet Array;
        // Convert: DotNet Convert;
        // MemoryStream: DotNet MemoryStream;
        IStream: InStream;
        SIRec: Record "Sales Invoice Header";
        TempBlob: Codeunit "Temp Blob";
        Path: Text[250];
        FileName: Text[30];
        ThreeTierMgt: Codeunit "File Management";
        OutStram: OutStream;
        RecRef: RecordRef;
        Outstring: Text;
    begin
        //Path := ThreeTierMgt.GetDirectoryName(ThreeTierMgt.ServerTempFileName('.pdf'));
        FileName := DELCHR(FORMAT(TODAY) + FORMAT(TIME), '=', '/:- ');
        SIRec.RESET;
        SIRec.SETFILTER("No.", '%1', OrderNo);
        IF SIRec.FINDSET THEN begin
            RecRef.GetTable(SIRec);
            TempBlob.CreateOutStream(OutStram, TextEncoding::UTF16);
            IF REPORT.SAVEAS(50020, '', ReportFormat::Pdf, OutStram, RecRef) THEN BEGIN
                TempBlob.CREATEINSTREAM(IStream);
                IStream.ReadText(Outstring);
                PDF.ADDTEXT(Outstring);
            END;
        end;
        // IF REPORT.SAVEASPDF(50020, Path + FileName + '.pdf', SIRec) THEN BEGIN
        //     TempBlob.INIT;
        //     TempBlob.Blob.IMPORT(Path + FileName + '.pdf');
        //     TempBlob.INSERT;
        //     TempBlob.Blob.CREATEINSTREAM(IStream);
        //     MemoryStream := MemoryStream.MemoryStream();
        //     COPYSTREAM(MemoryStream, IStream);
        //     Bytes := MemoryStream.GetBuffer();
        //     PDF.ADDTEXT(Convert.ToBase64String(Bytes));
        // END;
    end;


    procedure GeneratePurchInv(var PDF: BigText; OrderNo: Code[30])
    var
        // Bytes: DotNet Array;
        // Convert: DotNet Convert;
        // MemoryStream: DotNet MemoryStream;
        IStream: InStream;
        PIRec: Record "Purch. Inv. Header";
        TempBlob: Codeunit "Temp Blob";
        Path: Text[250];
        FileName: Text[30];
        ThreeTierMgt: Codeunit "File Management";
        OutStram: OutStream;
        RecRef: RecordRef;
        Outstring: Text;
    begin
        //Path := ThreeTierMgt.GetDirectoryName(ThreeTierMgt.ServerTempFileName('.pdf'));
        FileName := DELCHR(FORMAT(TODAY) + FORMAT(TIME), '=', '/:- ');
        PIRec.RESET;
        PIRec.SETFILTER("No.", '%1', OrderNo);
        IF PIRec.FINDSET THEN begin
            RecRef.GetTable(PIRec);
            TempBlob.CreateOutStream(OutStram);
            IF REPORT.SAVEAS(50013, '', ReportFormat::Pdf, OutStram, RecRef) THEN BEGIN
                TempBlob.CREATEINSTREAM(IStream);
                IStream.ReadText(Outstring);
                PDF.ADDTEXT(Outstring);
            END;
        end;
        // IF REPORT.SAVEASPDF(50013, Path + FileName + '.pdf', PIRec) THEN BEGIN
        //     TempBlob.INIT;
        //     TempBlob.Blob.IMPORT(Path + FileName + '.pdf');
        //     TempBlob.INSERT;
        //     TempBlob.Blob.CREATEINSTREAM(IStream);
        //     MemoryStream := MemoryStream.MemoryStream();
        //     COPYSTREAM(MemoryStream, IStream);
        //     Bytes := MemoryStream.GetBuffer();
        //     PDF.ADDTEXT(Convert.ToBase64String(Bytes));
        // END;
    end;


    procedure InsertTrackingSpecification(DocNo: Code[20]; DocLineNo: Integer; Qty: Decimal; SerialNo: Code[20]; LotNo: Code[20]; reserve: Boolean)
    var
        recReservationEntry: Record "Reservation Entry";
        EntryNo: Integer;
        recSalesLine: Record "Sales Line";
        recILE: Record "Item Ledger Entry";
    begin
        recSalesLine.RESET;
        recSalesLine.SETRANGE("Document Type", recSalesLine."Document Type"::Order);
        recSalesLine.SETRANGE("Document No.", DocNo);
        recSalesLine.SETRANGE("Line No.", DocLineNo);
        IF NOT recSalesLine.FIND('-') THEN
            EXIT
        ELSE BEGIN
            IF (LotNo <> '') OR (reserve) THEN BEGIN
                recReservationEntry.RESET;
                recReservationEntry.SETRANGE("Source ID", DocNo);
                recReservationEntry.SETRANGE(recReservationEntry.Positive, FALSE);
                recReservationEntry.SETRANGE(recReservationEntry."Source Type", 37);
                recReservationEntry.SETRANGE(recReservationEntry."Source Subtype", 1);
                recReservationEntry.SETRANGE(recReservationEntry."Lot No.", LotNo);

                //recReservationEntry.SETRANGE(recReservationEntry."Reservation Status",recReservationEntry."Reservation Status"::Reservation);
                recReservationEntry.SETRANGE(recReservationEntry."Source Ref. No.", DocLineNo);
                IF recReservationEntry.FIND('-') THEN BEGIN
                    recReservationEntry.VALIDATE("Quantity (Base)", -Qty);
                    recReservationEntry.MODIFY;
                END ELSE BEGIN
                    recReservationEntry.RESET;
                    IF recReservationEntry.FIND('+') THEN
                        EntryNo := recReservationEntry."Entry No." + 1
                    ELSE
                        EntryNo := 1;

                    recReservationEntry.INIT;
                    recReservationEntry.VALIDATE("Entry No.", EntryNo);
                    recReservationEntry.VALIDATE("Source ID", DocNo);
                    recReservationEntry.VALIDATE("Item No.", recSalesLine."No.");
                    recReservationEntry.VALIDATE("Variant Code", recSalesLine."Variant Code");
                    recReservationEntry.VALIDATE("Source Type", 37);
                    recReservationEntry.VALIDATE("Source Subtype", 1);
                    IF reserve THEN
                        recReservationEntry.VALIDATE("Reservation Status", recReservationEntry."Reservation Status"::Reservation)
                    ELSE
                        recReservationEntry.VALIDATE("Reservation Status", recReservationEntry."Reservation Status"::Surplus);
                    recReservationEntry.VALIDATE("Location Code", recSalesLine."Location Code");
                    recReservationEntry.VALIDATE("Source Ref. No.", DocLineNo);
                    recReservationEntry.VALIDATE(Positive, FALSE);
                    recReservationEntry.VALIDATE("Lot No.", LotNo);
                    recReservationEntry.VALIDATE("Quantity (Base)", -Qty);
                    recReservationEntry.VALIDATE("Qty. per Unit of Measure", recSalesLine."Qty. per Unit of Measure");
                    recReservationEntry.VALIDATE(recReservationEntry."Shipment Date", recSalesLine."Shipment Date");
                    IF LotNo <> '' THEN
                        recReservationEntry.VALIDATE("Item Tracking", recReservationEntry."Item Tracking"::"Lot No.");
                    recReservationEntry.INSERT;

                    IF reserve THEN BEGIN
                        recReservationEntry.INIT;
                        recReservationEntry.VALIDATE("Entry No.", EntryNo);
                        recReservationEntry.VALIDATE("Source ID", '');
                        recReservationEntry.VALIDATE("Item No.", recSalesLine."No.");
                        recReservationEntry.VALIDATE("Variant Code", recSalesLine."Variant Code");
                        recReservationEntry.VALIDATE("Source Type", 32);
                        recReservationEntry.VALIDATE("Source Subtype", 0);
                        IF reserve THEN
                            recReservationEntry.VALIDATE("Reservation Status", recReservationEntry."Reservation Status"::Reservation)
                        ELSE
                            recReservationEntry.VALIDATE("Reservation Status", recReservationEntry."Reservation Status"::Surplus);
                        recReservationEntry.VALIDATE("Location Code", recSalesLine."Location Code");
                        recILE.RESET;
                        recILE.SETRANGE("Item No.", recSalesLine."No.");
                        recILE.SETFILTER("Remaining Quantity", '<>%1', 0);
                        IF recILE.FIND('-') THEN
                            recReservationEntry.VALIDATE("Source Ref. No.", recILE."Entry No.");
                        recReservationEntry.VALIDATE(Positive, FALSE);
                        recReservationEntry.VALIDATE("Lot No.", LotNo);
                        recReservationEntry.VALIDATE("Quantity (Base)", Qty);
                        recReservationEntry.VALIDATE("Qty. per Unit of Measure", recSalesLine."Qty. per Unit of Measure");
                        recReservationEntry.VALIDATE(recReservationEntry."Shipment Date", recSalesLine."Shipment Date");
                        IF LotNo <> '' THEN
                            recReservationEntry.VALIDATE("Item Tracking", recReservationEntry."Item Tracking"::"Lot No.");
                        recReservationEntry.INSERT;

                    END;
                END;
            END;
        END;
    end;


    procedure InsertReservation(DocNo: Code[20]; DocLineNo: Integer; Qty: Decimal; SerialNo: Code[20]; LotNo: Code[20])
    var
        recReservationEntry: Record "Reservation Entry";
        EntryNo: Integer;
        recSalesLine: Record "Sales Line";
    begin
        recSalesLine.RESET;
        recSalesLine.SETRANGE("Document Type", recSalesLine."Document Type"::Order);
        recSalesLine.SETRANGE("Document No.", DocNo);
        recSalesLine.SETRANGE("Line No.", DocLineNo);
        IF NOT recSalesLine.FIND('-') THEN
            EXIT
        ELSE BEGIN

            recReservationEntry.RESET;
            recReservationEntry.SETRANGE("Source ID", DocNo);
            recReservationEntry.SETRANGE(recReservationEntry.Positive, FALSE);
            recReservationEntry.SETRANGE(recReservationEntry."Source Type", 37);
            recReservationEntry.SETRANGE(recReservationEntry."Source Subtype", 1);
            //recReservationEntry.SETRANGE(recReservationEntry."Lot No.",LotNo);
            recReservationEntry.SETRANGE(recReservationEntry."Reservation Status", recReservationEntry."Reservation Status"::Reservation);
            recReservationEntry.SETRANGE(recReservationEntry."Source Ref. No.", DocLineNo);
            IF recReservationEntry.FIND('-') THEN BEGIN
                recReservationEntry.VALIDATE("Quantity (Base)", -Qty);
                recReservationEntry.MODIFY;
            END ELSE BEGIN
                recReservationEntry.RESET;
                IF recReservationEntry.FIND('+') THEN
                    EntryNo := recReservationEntry."Entry No." + 1
                ELSE
                    EntryNo := 1;

                recReservationEntry.INIT;
                recReservationEntry.VALIDATE("Entry No.", EntryNo);
                recReservationEntry.VALIDATE("Source ID", DocNo);
                recReservationEntry.VALIDATE("Item No.", recSalesLine."No.");
                recReservationEntry.VALIDATE("Variant Code", recSalesLine."Variant Code");
                recReservationEntry.VALIDATE("Source Type", 37);
                recReservationEntry.VALIDATE("Source Subtype", 1);
                recReservationEntry.VALIDATE("Reservation Status", recReservationEntry."Reservation Status"::Reservation);
                recReservationEntry.VALIDATE("Location Code", recSalesLine."Location Code");
                recReservationEntry.VALIDATE("Source Ref. No.", DocLineNo);
                recReservationEntry.VALIDATE(Positive, FALSE);
                recReservationEntry.VALIDATE("Lot No.", LotNo);
                recReservationEntry.VALIDATE("Quantity (Base)", -Qty);
                recReservationEntry.VALIDATE("Qty. per Unit of Measure", recSalesLine."Qty. per Unit of Measure");
                recReservationEntry.VALIDATE(recReservationEntry."Shipment Date", recSalesLine."Shipment Date");
                recReservationEntry.VALIDATE("Item Tracking", recReservationEntry."Item Tracking"::"Lot No.");
                recReservationEntry.INSERT;



            END;
        END;
    end;

    //VR Code not in use
    procedure GeneratePO(OrderNo: Code[20])
    // var
    //     Bytes: DotNet Array;
    //     Convert: DotNet Convert;
    //     MemoryStream: DotNet MemoryStream;
    //     IStream: InStream;
    //     PORec: Record "Purchase Header";
    //     TempBlob: Record TempBlob temporary;
    //     Path: Text[250];
    //     FileName: Text[30];
    //     ThreeTierMgt: Codeunit "File Management";
    begin
        // Path := ThreeTierMgt.GetDirectoryName(ThreeTierMgt.ServerTempFileName('.html'));
        // FileName := DELCHR(FORMAT(TODAY) + FORMAT(TIME), '=', '/:- ');
        // PORec.RESET;
        // PORec.SETFILTER("No.", '%1', OrderNo);
        // IF PORec.FINDSET THEN BEGIN
        //     Path := Path + FileName + '.html';
        //     REPORT.SAVEASHTML(50003, Path, PORec);
        //     IF REPORT.SAVEASHTML(50003, Path, PORec) THEN BEGIN
        //         TempBlob.INIT;
        //         TempBlob.Blob.IMPORT(Path);
        //         TempBlob.INSERT;
        //         TempBlob.Blob.CREATEINSTREAM(IStream);
        //         MemoryStream := MemoryStream.MemoryStream();
        //         COPYSTREAM(MemoryStream, IStream);
        //         Bytes := MemoryStream.GetBuffer();
        //         //HTML.ADDTEXT(Convert.ToBase64String(Bytes));



        //END;
        //  END;
    end;


    procedure InsertTrackingSpecificationPur(DocNo: Code[20]; DocLineNo: Integer; Qty: Decimal; SerialNo: Code[20]; LotNo: Code[20]; DocketNo: Text[50]; ShipVia: Text[30])
    var
        recReservationEntry: Record "Reservation Entry";
        EntryNo: Integer;
        recPurchLine: Record "Purchase Line";
        recItem: Record Item;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        recPurchHeader: Record "Purchase Header";
        cuSalesRelease: Codeunit "Release Purchase Document";
        decQty: Decimal;
    begin

        recPurchHeader.RESET;
        recPurchHeader.SETRANGE("Document Type", recPurchLine."Document Type"::Order);
        recPurchHeader.SETRANGE("No.", DocNo);
        IF recPurchHeader.FIND('-') THEN BEGIN
            recPurchHeader.SetHideValidationDialog(TRUE);
            cuSalesRelease.Reopen(recPurchHeader);
        END;

        recPurchLine.RESET;
        recPurchLine.SETRANGE("Document Type", recPurchLine."Document Type"::Order);
        recPurchLine.SETRANGE("Document No.", DocNo);
        recPurchLine.SETRANGE("Line No.", DocLineNo);
        IF NOT recPurchLine.FIND('-') THEN
            EXIT
        ELSE BEGIN

            recPurchHeader.RESET;
            recPurchHeader.SETRANGE("Document Type", recPurchLine."Document Type"::Order);
            recPurchHeader.SETRANGE("No.", DocNo);
            IF recPurchHeader.FIND('-') THEN BEGIN
                recPurchHeader.SetHideValidationDialog(TRUE);
                decQty := 0;
                Qty := Qty * recPurchLine."Qty. per Unit of Measure";

                recReservationEntry.RESET;
                recReservationEntry.SETRANGE("Source ID", DocNo);
                recReservationEntry.SETRANGE(recReservationEntry.Positive, TRUE);
                recReservationEntry.SETRANGE(recReservationEntry."Source Type", 39);
                recReservationEntry.SETRANGE(recReservationEntry."Source Subtype", 1);
                //recReservationEntry.SETRANGE(recReservationEntry."Lot No.",LotNo);
                recReservationEntry.SETRANGE(recReservationEntry."Reservation Status", recReservationEntry."Reservation Status"::Surplus);
                recReservationEntry.SETRANGE(recReservationEntry."Source Ref. No.", DocLineNo);
                IF recReservationEntry.FIND('-') THEN
                    REPEAT
                        decQty := decQty + recReservationEntry."Quantity (Base)";
                    UNTIL recReservationEntry.NEXT = 0;
                decQty := Qty + decQty;
                IF (decQty) > recPurchLine."Outstanding Quantity" THEN
                    recPurchLine.VALIDATE(Quantity, decQty / recPurchLine."Qty. per Unit of Measure" + recPurchLine."Quantity Received");
                recPurchLine.VALIDATE("Qty. to Receive", decQty / recPurchLine."Qty. per Unit of Measure");
                recPurchLine.MODIFY;


                decQty := 0;
                recReservationEntry.RESET;
                recReservationEntry.SETRANGE("Source ID", DocNo);
                recReservationEntry.SETRANGE(recReservationEntry.Positive, TRUE);
                recReservationEntry.SETRANGE(recReservationEntry."Source Type", 39);
                recReservationEntry.SETRANGE(recReservationEntry."Source Subtype", 1);
                recReservationEntry.SETRANGE(recReservationEntry."Lot No.", LotNo);
                recReservationEntry.SETRANGE(recReservationEntry."Reservation Status", recReservationEntry."Reservation Status"::Surplus);
                recReservationEntry.SETRANGE(recReservationEntry."Source Ref. No.", DocLineNo);
                IF recReservationEntry.FIND('-') THEN BEGIN
                    recReservationEntry.VALIDATE("Quantity (Base)", Qty);
                    recReservationEntry.MODIFY;
                END ELSE BEGIN
                    recReservationEntry.RESET;
                    IF recReservationEntry.FIND('+') THEN
                        EntryNo := recReservationEntry."Entry No." + 1
                    ELSE
                        EntryNo := 1;

                    recReservationEntry.INIT;
                    recReservationEntry.VALIDATE("Entry No.", EntryNo);
                    recReservationEntry.VALIDATE("Source ID", DocNo);
                    recReservationEntry.VALIDATE("Item No.", recPurchLine."No.");
                    recReservationEntry.VALIDATE("Variant Code", recPurchLine."Variant Code");
                    recReservationEntry.VALIDATE("Source Type", 39);
                    recReservationEntry.VALIDATE("Source Subtype", 1);
                    recReservationEntry.VALIDATE("Reservation Status", recReservationEntry."Reservation Status"::Surplus);
                    recReservationEntry.VALIDATE("Location Code", recPurchLine."Location Code");
                    recReservationEntry.VALIDATE("Source Ref. No.", DocLineNo);
                    recReservationEntry.VALIDATE(Positive, TRUE);
                    IF recPurchLine.Type = recPurchLine.Type::Item THEN BEGIN
                        recItem.GET(recPurchLine."No.");
                        recItem.TESTFIELD("Lot Nos.");

                        recReservationEntry.VALIDATE("Lot No.", NoSeriesMgt.GetNextNo(recItem."Lot Nos.", WORKDATE, TRUE));
                    END;
                    recReservationEntry.VALIDATE("Dylot No.", DocNo);

                    recReservationEntry.VALIDATE("Quantity (Base)", Qty);
                    recReservationEntry.VALIDATE("Qty. per Unit of Measure", recPurchLine."Qty. per Unit of Measure");
                    recReservationEntry.VALIDATE(recReservationEntry."Shipment Date", recPurchLine."Requested Receipt Date");
                    recReservationEntry.VALIDATE("Item Tracking", recReservationEntry."Item Tracking"::"Lot No.");
                    recReservationEntry.INSERT;
                    recPurchHeader."Consignment No." := DocketNo;
                    recPurchHeader."Ship Via" := ShipVia;
                    recPurchHeader.MODIFY(FALSE);
                    /*recReservationEntry.RESET;
                    recReservationEntry.SETRANGE("Source ID",DocNo);
                    recReservationEntry.SETRANGE(recReservationEntry.Positive,TRUE);
                    recReservationEntry.SETRANGE(recReservationEntry."Source Type",39);
                    recReservationEntry.SETRANGE(recReservationEntry."Source Subtype",1);
                    //recReservationEntry.SETRANGE(recReservationEntry."Lot No.",LotNo);
                    recReservationEntry.SETRANGE(recReservationEntry."Reservation Status",recReservationEntry."Reservation Status"::Surplus);
                    recReservationEntry.SETRANGE(recReservationEntry."Source Ref. No.",DocLineNo);
                    IF recReservationEntry.FIND('-') THEN REPEAT
                         decQty:=decQty+recReservationEntry."Quantity (Base)";
                     UNTIL recReservationEntry.NEXT=0;
                          recPurchLine.VALIDATE("Qty. to Receive",decQty/recPurchLine."Qty. per Unit of Measure");
                          recPurchLine.MODIFY;
                     */


                END;
            END;
        END;
        recPurchHeader.RESET;
        recPurchHeader.SETRANGE("Document Type", recPurchLine."Document Type"::Order);
        recPurchHeader.SETRANGE("No.", DocNo);
        IF recPurchHeader.FIND('-') THEN BEGIN
            recPurchHeader.SetHideValidationDialog(TRUE);
            cuSalesRelease.RUN(recPurchHeader);
        END;

    end;


    procedure FindSalesPrice(ItemNo: Code[20]; CustNo: Code[20]): Decimal
    var
        // cuSalesPrice: Codeunit SalesPriceCalcMgt_Ext;
        recItem: Record Item;
    begin
        recItem.GET(ItemNo);
        // IF cuSalesPrice.FindSalesLinePriceWeb(ItemNo, CustNo) = 0 THEN
        //     EXIT(recItem."Unit Price")
        // ELSE
        //     EXIT(cuSalesPrice.FindSalesLinePriceWeb(ItemNo, CustNo));
    end;


    procedure GenerateSalesShip(var PDF: BigText; OrderNo: Code[30])
    var
        // Bytes: DotNet Array;
        // Convert: DotNet Convert;
        // MemoryStream: DotNet MemoryStream;
        IStream: InStream;
        SIRec: Record "Sales Shipment Header";
        TempBlob: Codeunit "Temp Blob";
        Path: Text[250];
        FileName: Text[30];
        ThreeTierMgt: Codeunit "File Management";
        Outstream: OutStream;
        RecRef: RecordRef;
        Outstring: Text;
    begin
        // Path := ThreeTierMgt.GetDirectoryName(ThreeTierMgt.ServerTempFileName('.pdf'));
        FileName := DELCHR(FORMAT(TODAY) + FORMAT(TIME), '=', '/:- ');
        SIRec.RESET;
        SIRec.SETFILTER("No.", '%1', OrderNo);
        IF SIRec.FINDSET THEN begin
            RecRef.GetTable(SIRec);
            TempBlob.CreateOutStream(Outstream, TextEncoding::UTF16);
            IF REPORT.SAVEAS(10077, '', ReportFormat::Pdf, Outstream, RecRef) THEN BEGIN
                TempBlob.CREATEINSTREAM(IStream);
                IStream.ReadText(Outstring);
                PDF.ADDTEXT(Outstring);
            END;
        end;
        // IF REPORT.SAVEASPDF(10077, Path + FileName + '.pdf', SIRec) THEN BEGIN
        //     TempBlob.INIT;
        //     TempBlob.Blob.IMPORT(Path + FileName + '.pdf');
        //     TempBlob.INSERT;
        //     TempBlob.Blob.CREATEINSTREAM(IStream);
        //     MemoryStream := MemoryStream.MemoryStream();
        //     COPYSTREAM(MemoryStream, IStream);
        //     Bytes := MemoryStream.GetBuffer();
        //     PDF.ADDTEXT(Convert.ToBase64String(Bytes));
        // END;
    end;


    procedure UpdateRequestSheet(OrderNo: Code[20]; OrderLineNo: Integer; ItemNo: Code[20]; Qty: Decimal; ShipmentDate: Date)
    var
        recVendReq: Record "Vendor Request Sheet";
        recPurchLine: Record "Purchase Line";
        LineNo: Integer;
    begin
        recVendReq.RESET;
        recVendReq.SETRANGE("Order No.", OrderNo);
        recVendReq.SETRANGE("Order Line No.", OrderLineNo);
        IF recVendReq.FINDLAST THEN
            LineNo := recVendReq."Line No." + 10000
        ELSE
            LineNo := 10000;

        recVendReq.INIT;
        recVendReq."Order No." := OrderNo;
        recVendReq."Order Line No." := OrderLineNo;
        recVendReq."Line No." := LineNo;
        recVendReq."Item No." := ItemNo;
        recVendReq.Quantity := Qty;
        recVendReq."Planned Shipment Date" := ShipmentDate;
        recPurchLine.RESET;
        recPurchLine.SETRANGE("Document Type", recPurchLine."Document Type"::Order);
        recPurchLine.SETRANGE("Document No.", OrderNo);
        recPurchLine.SETRANGE("Line No.", OrderLineNo);
        IF recPurchLine.FIND('-') THEN
            recVendReq."Requested Shipment Date" := recPurchLine."Requested Receipt Date";
        recVendReq.INSERT;
    end;


    procedure PostReceipt(OrderNo: Code[20])
    var
        recPurchHeader: Record "Purchase Header";
        cuPurchPost: Codeunit "Purch.-Post (Yes/No)";
    begin
        recPurchHeader.RESET;
        IF recPurchHeader.GET(recPurchHeader."Document Type"::Order, OrderNo) THEN BEGIN
            CLEAR(cuPurchPost);
            cuPurchPost.RUN(recPurchHeader);
        END;
    end;


    procedure RemoveReservationEntry(DocNo: Code[20])
    var
        recReservationEntry: Record "Reservation Entry";
        EntryNo: Integer;
        recPurchLine: Record "Purchase Line";
        recItem: Record Item;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        recPurchHeader: Record "Purchase Header";
        cuSalesRelease: Codeunit "Release Purchase Document";
        decQty: Decimal;
    begin
        recPurchHeader.RESET;
        recPurchHeader.SETRANGE("Document Type", recPurchHeader."Document Type"::Order);
        recPurchHeader.SETRANGE("No.", DocNo);
        IF recPurchHeader.FIND('-') THEN BEGIN
            cuSalesRelease.Reopen(recPurchHeader);
        END;

        recReservationEntry.RESET;
        recReservationEntry.SETRANGE("Source ID", DocNo);
        recReservationEntry.SETRANGE(recReservationEntry.Positive, TRUE);
        recReservationEntry.SETRANGE(recReservationEntry."Source Type", 39);
        recReservationEntry.SETRANGE(recReservationEntry."Source Subtype", 1);
        //recReservationEntry.SETRANGE(recReservationEntry."Lot No.",LotNo);
        recReservationEntry.SETRANGE(recReservationEntry."Reservation Status", recReservationEntry."Reservation Status"::Surplus);
        //recReservationEntry.SETRANGE(recReservationEntry."Source Ref. No.",DocLineNo);
        IF recReservationEntry.FIND('-') THEN BEGIN
            REPEAT
                recReservationEntry.DELETE;
            UNTIL recReservationEntry.NEXT = 0;
        END;
        recPurchLine.RESET;
        recPurchLine.SETRANGE("Document Type", recPurchLine."Document Type"::Order);
        recPurchLine.SETRANGE("Document No.", DocNo);
        IF recPurchLine.FIND('-') THEN
            REPEAT
                recPurchLine.VALIDATE("Qty. to Receive", 0);
                recPurchLine.MODIFY;
            UNTIL recPurchLine.NEXT = 0;


        recPurchHeader.RESET;
        recPurchHeader.SETRANGE("Document Type", recPurchHeader."Document Type"::Order);
        recPurchHeader.SETRANGE("No.", DocNo);
        IF recPurchHeader.FIND('-') THEN BEGIN
            cuSalesRelease.RUN(recPurchHeader);
        END;
    end;


    procedure InsertTransferOrder(DocketNo: Text[30]; ShipVia: Text[30])
    var
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        recILE: Record "Item Ledger Entry";
        LineNo: Integer;
        InvtSetup: Record "Inventory Setup";
        cuNoSeries: Codeunit NoSeriesManagement;
    begin
        PurchRcptHeader.RESET;
        PurchRcptHeader.SETRANGE("Consignment No.", DocketNo);
        IF PurchRcptHeader.FIND('-') THEN BEGIN
            REPEAT
                PurchRcptLine.RESET;
                PurchRcptLine.SETRANGE("Document No.", PurchRcptHeader."No.");
                PurchRcptLine.SETFILTER(Quantity, '>%1', 0);
                IF PurchRcptLine.FIND('-') THEN
                    REPEAT
                        TransferHeader.RESET;
                        TransferHeader.SETRANGE("Consignment No.", DocketNo);
                        IF NOT TransferHeader.FIND('-') THEN BEGIN
                            TransferHeader.INIT;
                            InvtSetup.GET();
                            TransferHeader.VALIDATE("No.", '');
                            TransferHeader.INSERT(TRUE);
                            TransferHeader.VALIDATE("Transfer-from Code", PurchRcptLine."Location Code");
                            TransferHeader.VALIDATE("Transfer-to Code", 'SYOSSET');
                            TransferHeader.VALIDATE("Posting Date", TODAY);
                            TransferHeader.VALIDATE("Consignment No.", DocketNo);
                            TransferHeader.VALIDATE("Ship Via", ShipVia);
                            TransferHeader.MODIFY;

                            TransferLine.RESET;
                            TransferLine.SETRANGE("Document No.", TransferHeader."No.");
                            IF TransferLine.FIND('+') THEN
                                LineNo := TransferLine."Line No." + 10000
                            ELSE
                                LineNo := 10000;

                            TransferLine.INIT;
                            TransferLine.VALIDATE("Document No.", TransferHeader."No.");
                            //TransferLine.VALIDATE("Transfer-from Code",TransferHeader."Transfer-from Code");
                            //TransferLine.VALIDATE("Transfer-to Code",TransferHeader."Transfer-to Code");
                            TransferLine.VALIDATE("Line No.", LineNo);
                            TransferLine.VALIDATE("Item No.", PurchRcptLine."No.");
                            TransferLine.VALIDATE(Quantity, PurchRcptLine.Quantity);

                            TransferLine.VALIDATE("Purchase Receipt No.", PurchRcptLine."Document No.");
                            TransferLine.VALIDATE("Purchase Receipt Line No.", PurchRcptLine."Line No.");
                            TransferLine.INSERT;
                            //END;
                        END ELSE BEGIN
                            TransferLine.RESET;
                            TransferLine.SETRANGE("Document No.", TransferHeader."No.");
                            IF TransferLine.FIND('+') THEN
                                LineNo := TransferLine."Line No." + 10000
                            ELSE
                                LineNo := 10000;

                            TransferLine.INIT;
                            TransferLine.VALIDATE("Document No.", TransferHeader."No.");
                            //TransferLine.VALIDATE("Transfer-from Code",TransferHeader."Transfer-from Code");
                            //TransferLine.VALIDATE("Transfer-to Code",TransferHeader."Transfer-to Code");
                            TransferLine.VALIDATE("Line No.", LineNo);
                            TransferLine.VALIDATE("Item No.", PurchRcptLine."No.");
                            TransferLine.VALIDATE(Quantity, PurchRcptLine.Quantity);

                            TransferLine.VALIDATE("Purchase Receipt No.", PurchRcptLine."Document No.");
                            TransferLine.VALIDATE("Purchase Receipt Line No.", PurchRcptLine."Line No.");

                            TransferLine.INSERT;

                        END;

                    UNTIL PurchRcptLine.NEXT = 0;
            UNTIL PurchRcptHeader.NEXT = 0;
        END;
    end;


    procedure InsertWhseActLine(ActivityType: Option " ","Put-away",Pick,Movement,"Invt. Put-away","Invt. Pick","Invt. Movement"; DocNo: Code[20]; LineNo: Integer; cdZone: Code[20]; cdBin: Code[20]; LotNo: Code[20]; ItemNo: Code[20]; decQuantity: Decimal)
    var
        recWhseActLine: Record "Warehouse Activity Line";
    begin
        recWhseActLine.RESET;
        IF recWhseActLine.GET(ActivityType, DocNo, LineNo) THEN BEGIN
            recWhseActLine.VALIDATE("Zone Code", cdZone);
            recWhseActLine.VALIDATE("Bin Code", cdBin);
            recWhseActLine.VALIDATE("Lot No.", LotNo);
            recWhseActLine.VALIDATE("Qty. to Handle", decQuantity);
            recWhseActLine.MODIFY;
        END;
    end;


    procedure RegisterWhseAct(ActivityType: Integer; DocNo: Code[20]; UsrId: Code[50]) blnStatus: Boolean
    var
        recWhseActivityLine: Record "Warehouse Activity Line";
        WhseActivLine: Record "Warehouse Activity Line";
        rptRegister: Report RegisterWhseActivity;
        RecHandHeld: Record HandHeld;
    begin
        blnStatus := FALSE;
        //REPORT.RUN(REPORT::RegisterWhseActivity,TRUE,TRUE);
        CLEAR(rptRegister);
        rptRegister.GetHHUsrId(UsrId, DocNo);
        rptRegister.RUNMODAL;
        /*
        CLEAR(WhseRegisterActivityYesNo);
        SLEEP(20000);
        recWhseActivityLine.RESET;
        recWhseActivityLine.SETRANGE(recWhseActivityLine."Activity Type",ActivityType);
        recWhseActivityLine.SETRANGE("No.",DocNo);
        recWhseActivityLine.SETRANGE("Hand Held User Id",UsrId);
        recWhseActivityLine.SETRANGE(Breakbulk);
        IF recWhseActivityLine.FINDSET THEN BEGIN
           WhseActivLine.COPY(recWhseActivityLine);
        WhseRegisterActivityYesNo.HHUsrId(UsrId);
        WhseRegisterActivityYesNo.RUN(WhseActivLine);
        END;
        */
        blnStatus := TRUE;
        EXIT(blnStatus);

    end;


    procedure UpdateRequestSheetDate(OrderNo: Code[20]; OrderLineNo: Integer; LineNo: Integer; ItemNo: Code[20]; Qty: Decimal; ShipmentDate: Date)
    var
        recVendReq: Record "Vendor Request Sheet";
        recPurchLine: Record "Purchase Line";
        intLineNo: Integer;
    begin
        recVendReq.RESET;
        recVendReq.SETRANGE("Order No.", OrderNo);
        recVendReq.SETRANGE("Order Line No.", OrderLineNo);
        IF recVendReq.FINDLAST THEN
            intLineNo := recVendReq."Line No." + 10000
        ELSE
            intLineNo := 10000;
        recVendReq.RESET;
        recVendReq.SETRANGE("Order No.", OrderNo);
        recVendReq.SETRANGE("Order Line No.", OrderLineNo);
        recVendReq.SETRANGE("Line No.", LineNo);
        IF recVendReq.FIND('-') THEN BEGIN
            recVendReq.Close := TRUE;
            recVendReq.MODIFY;
        END;
        recVendReq.INIT;
        recVendReq."Order No." := OrderNo;
        recVendReq."Order Line No." := OrderLineNo;
        recVendReq."Line No." := intLineNo;
        recVendReq."Item No." := ItemNo;
        recVendReq.Quantity := Qty;
        recVendReq."Planned Shipment Date" := ShipmentDate;
        recPurchLine.RESET;
        recPurchLine.SETRANGE("Document Type", recPurchLine."Document Type"::Order);
        recPurchLine.SETRANGE("Document No.", OrderNo);
        recPurchLine.SETRANGE("Line No.", OrderLineNo);
        IF recPurchLine.FIND('-') THEN
            recVendReq."Requested Shipment Date" := recPurchLine."Requested Receipt Date";
        recVendReq.INSERT;
    end;


    procedure GeneratePOVend(var PDF: BigText; OrderNo: Code[20])
    var
        // Bytes: DotNet Array;
        // Convert: DotNet Convert;
        // MemoryStream: DotNet MemoryStream;
        IStream: InStream;
        PORec: Record "Purchase Header";
        TempBlob: Codeunit "Temp Blob";
        Path: Text[250];
        FileName: Text[30];
        ThreeTierMgt: Codeunit "File Management";
        Outstream: OutStream;
        RecRef: RecordRef;
        Outstring: Text;
    begin
        //Path := ThreeTierMgt.GetDirectoryName(ThreeTierMgt.ServerTempFileName('.pdf'));
        FileName := DELCHR(FORMAT(TODAY) + FORMAT(TIME), '=', '/:- ');

        PORec.RESET;
        PORec.SETFILTER("No.", '%1', OrderNo);
        IF PORec.FINDSET THEN BEGIN
            RecRef.GetTable(PORec);
            TempBlob.CreateOutStream(Outstream, TextEncoding::UTF16);
            IF REPORT.SAVEAS(50010, '', ReportFormat::Pdf, Outstream, RecRef) THEN BEGIN
                TempBlob.CREATEINSTREAM(IStream);
                IStream.ReadText(Outstring);
                PDF.ADDTEXT(Outstring);
            END;
            // IF REPORT.SAVEASPDF(50010, Path + FileName + '.pdf', PORec) THEN BEGIN
            //     TempBlob.INIT;
            //     TempBlob.Blob.IMPORT(Path + FileName + '.pdf');
            //     TempBlob.INSERT;
            //     TempBlob.Blob.CREATEINSTREAM(IStream);
            //     MemoryStream := MemoryStream.MemoryStream();
            //     COPYSTREAM(MemoryStream, IStream);
            //     Bytes := MemoryStream.GetBuffer();
            //     PDF.ADDTEXT(Convert.ToBase64String(Bytes));
            // END;
        END;
    end;


    procedure GenerateReceipt(var PDF: BigText; OrderNo: Code[20])
    var
        // Bytes: DotNet Array;
        // Convert: DotNet Convert;
        // MemoryStream: DotNet MemoryStream;
        IStream: InStream;
        PORec: Record "Purch. Rcpt. Header";
        TempBlob: Codeunit "Temp Blob";
        Path: Text[250];
        FileName: Text[30];
        ThreeTierMgt: Codeunit "File Management";
        Outstream: OutStream;
        RecRef: RecordRef;
        Outstring: Text;
    begin
        //Path := ThreeTierMgt.GetDirectoryName(ThreeTierMgt.ServerTempFileName('.pdf'));
        FileName := DELCHR(FORMAT(TODAY) + FORMAT(TIME), '=', '/:- ');

        PORec.RESET;
        PORec.SETFILTER("No.", '%1', OrderNo);
        IF PORec.FINDSET THEN BEGIN
            RecRef.GetTable(PORec);
            TempBlob.CreateOutStream(Outstream, TextEncoding::UTF16);
            IF REPORT.SAVEAS(10124, '', ReportFormat::Pdf, Outstream, RecRef) THEN BEGIN
                TempBlob.CREATEINSTREAM(IStream);
                IStream.ReadText(Outstring);
                PDF.ADDTEXT(Outstring);
            END;
            // IF REPORT.SAVEASPDF(10124, Path + FileName + '.pdf', PORec) THEN BEGIN
            //     TempBlob.INIT;
            //     TempBlob.Blob.IMPORT(Path + FileName + '.pdf');
            //     TempBlob.INSERT;
            //     TempBlob.Blob.CREATEINSTREAM(IStream);
            //     MemoryStream := MemoryStream.MemoryStream();
            //     COPYSTREAM(MemoryStream, IStream);
            //     Bytes := MemoryStream.GetBuffer();
            //     PDF.ADDTEXT(Convert.ToBase64String(Bytes));
            // END;
        END;
    end;


    procedure GenerateCustomerStatement(var PDF: BigText; CustNo: Code[20]; StartDate: Date; EndDate: Date)
    var
        // Bytes: DotNet Array;
        // Convert: DotNet Convert;
        // MemoryStream: DotNet MemoryStream;
        IStream: InStream;
        vENDRec: Record Customer;
        TempBlob: Codeunit "Temp Blob";
        Path: Text[250];
        FileName: Text[30];
        ThreeTierMgt: Codeunit "File Management";
        rptVendorTrial: Report "Customer Statement";
        Outstream: OutStream;
        RecRef: RecordRef;
        Outstring: Text;
    begin
        // Path := ThreeTierMgt.GetDirectoryName(ThreeTierMgt.ServerTempFileName('.pdf'));
        FileName := DELCHR(FORMAT(TODAY) + FORMAT(TIME), '=', '/:- ');
        vENDRec.RESET;
        vENDRec.SETFILTER("No.", '%1', CustNo);
        vENDRec.SETFILTER(vENDRec."Date Filter", '%1', StartDate, EndDate);
        IF vENDRec.FINDSET THEN
            rptVendorTrial.SETTABLEVIEW(vENDRec);
        //  rptVendorTrial.Init(StartDate, EndDate);
        TempBlob.CreateOutStream(Outstream, TextEncoding::UTF16);
        IF rptVendorTrial.SAVEAS('', ReportFormat::Pdf, Outstream) THEN BEGIN
            // REPORT.SAVEASPDF(304,Path + FileName + '.pdf',vENDRec) THEN BEGIN
            TempBlob.CREATEINSTREAM(IStream);
            IStream.ReadText(Outstring);
            PDF.ADDTEXT(Outstring);
        END;
    end;


    procedure CreatePackingHeader(PackNo: Code[20]; SourceDocType: Integer; SourceDocNo: Code[20]; Location: Code[10]; ShipmentMethod: Code[10]; ShippingAgent: Code[10]; ShippingAgentService: Code[10]): Code[20]
    var
        recPackHeader: Record "Packing Header";
        recWSH: Record "Warehouse Shipment Header";
    begin
        recWSH.RESET;
        recWSH.SETRANGE("No.", SourceDocNo);
        IF NOT recWSH.FIND('-') THEN
            EXIT('WSNF');
        IF PackNo = '' THEN BEGIN
            //recPackHeader.RESET;
            recPackHeader.INIT;
            recPackHeader.VALIDATE("Packing No.", '');

            recPackHeader.INSERT(TRUE);
            recPackHeader.VALIDATE(recPackHeader."Source Document Type", SourceDocType);
            recPackHeader.VALIDATE(recPackHeader."Source Document No.", SourceDocNo);

            IF Location <> '' THEN
                recPackHeader.VALIDATE("Location Code", Location);
            IF ShipmentMethod <> '' THEN
                recPackHeader.VALIDATE("Shipment Method Code", ShipmentMethod);
            IF ShippingAgent <> '' THEN
                recPackHeader.VALIDATE("Shipping Agent Code", ShippingAgent);
            IF ShippingAgentService <> '' THEN
                recPackHeader.VALIDATE("Shipping Agent Service Code", ShippingAgent);
            recPackHeader.MODIFY;
            PackNo := recPackHeader."Packing No.";
            EXIT(PackNo);
        END ELSE BEGIN
            recPackHeader.RESET;
            IF recPackHeader.GET(PackNo) THEN BEGIN
                recPackHeader.VALIDATE(recPackHeader."Source Document Type", SourceDocType);
                recPackHeader.VALIDATE(recPackHeader."Source Document No.", SourceDocNo);
                IF Location <> '' THEN
                    recPackHeader.VALIDATE("Location Code", Location);
                IF ShipmentMethod <> '' THEN
                    recPackHeader.VALIDATE("Shipment Method Code", ShipmentMethod);
                IF ShippingAgent <> '' THEN
                    recPackHeader.VALIDATE("Shipping Agent Code", ShippingAgent);
                IF ShippingAgentService <> '' THEN
                    recPackHeader.VALIDATE("Shipping Agent Service Code", ShippingAgentService);
                recPackHeader.MODIFY;
                EXIT(PackNo);
            END;
        END;
    end;


    procedure CreatePackLine(PackNo: Code[20]; BoxType: Integer; BoxCode: Code[20]; LineNo: Integer; Height: Decimal; Width: Decimal; Length: Decimal; Weight: Decimal)
    var
        recPackingHeader: Record "Packing Header";
        recPackingLine: Record "Packing Line";
    begin


        IF recPackingHeader.GET(PackNo) THEN BEGIN

            recPackingHeader.TESTFIELD("Source Document No.");
            recPackingHeader.TESTFIELD("Source Document Type");
            IF LineNo = 0 THEN BEGIN
                recPackingLine.INIT;
                recPackingLine.VALIDATE("Packing No.", PackNo);
                recPackingLine.VALIDATE("Box Type", BoxType);
                recPackingLine.VALIDATE("Box Code", BoxCode);
                recPackingLine.INSERT(TRUE);
                IF Height > 0 THEN
                    recPackingLine.Height := Height;
                IF Width > 0 THEN
                    recPackingLine.Width := Width;
                IF Length > 0 THEN
                    recPackingLine.Length := Length;
                IF Weight > 0 THEN
                    recPackingLine.Weight := Weight;
                recPackingLine.MODIFY;
            END ELSE BEGIN

                recPackingLine.VALIDATE("Packing No.", PackNo);
                recPackingLine.VALIDATE("Box Type", BoxType);
                recPackingLine.VALIDATE("Box Code", BoxCode);

                IF Height > 0 THEN
                    recPackingLine.Height := Height;
                IF Width > 0 THEN
                    recPackingLine.Width := Width;
                IF Length > 0 THEN
                    recPackingLine.Length := Length;
                IF Weight > 0 THEN
                    recPackingLine.Weight := Weight;
                recPackingLine.MODIFY;
            END;
        END;
    end;


    procedure CreatePackItemLine(PackingNo: Code[20]; PackingLineNo: Integer; SourceDocNo: Code[20]; ItemNo: Code[20]; Qty: Decimal)
    var
        recPackLine: Record "Packing Line";
        recWhseShipLine: Record "Warehouse Shipment Line";
        cuPack: Codeunit Packing;
        recItem: Record Item;
        NextLineNo: Integer;
        recPackItemList2: Record "Packing Item List";
        recPackItemList: Record "Packing Item List";
    begin
        recPackLine.RESET;
        IF recPackLine.GET(PackingNo, PackingLineNo) THEN BEGIN
            recPackLine.TESTFIELD(recPackLine."Source Document No.", SourceDocNo);

            recWhseShipLine.RESET;
            recWhseShipLine.SETRANGE("No.", SourceDocNo);
            recWhseShipLine.SETRANGE("Item No.", ItemNo);
            IF recWhseShipLine.FIND('-') THEN BEGIN
                // END;
                recPackItemList.RESET;
                recPackItemList.SETRANGE("Packing No.", PackingNo);
                recPackItemList.SETRANGE("Packing Line No.", PackingLineNo);
                recPackItemList.SETRANGE("Item No.", ItemNo);
                IF recPackItemList.FIND('-') THEN BEGIN

                    recWhseShipLine."Quantity Packed" := recWhseShipLine."Quantity Packed" - recPackItemList.Quantity + Qty;
                    recWhseShipLine."Quantity To Pack" := recWhseShipLine."Qty. to Ship" + recWhseShipLine."Qty. Shipped" - recWhseShipLine."Quantity Packed";
                    recWhseShipLine.MODIFY(FALSE);

                    recPackItemList.VALIDATE(Quantity, Qty);
                    recPackItemList.MODIFY;

                END ELSE BEGIN
                    recPackItemList.RESET;
                    recPackItemList.SETRANGE("Packing No.", PackingNo);
                    recPackItemList.SETRANGE("Packing Line No.", PackingLineNo);
                    //recPackItemList.SETRANGE("Item No.",ItemNo);
                    IF recPackItemList.FIND('+') THEN
                        NextLineNo := recPackItemList."Line No." + 10000
                    ELSE
                        NextLineNo := 10000;

                    recItem.GET(ItemNo);

                    recPackItemList2.INIT;
                    recPackItemList2."Packing No." := PackingNo;
                    recPackItemList2."Packing Line No." := PackingLineNo;
                    recPackItemList2."Source Document Type" := recPackLine."Source Document Type";
                    recPackItemList2."Source Document No." := recPackLine."Source Document No.";
                    recPackItemList2."Source Document Line No." := recWhseShipLine."Line No.";
                    recPackItemList2."Line No." := NextLineNo;
                    recPackItemList2."Item No." := ItemNo;
                    recPackItemList2."Item Name" := recItem.Description;
                    recPackItemList2.VALIDATE(Quantity, Qty);
                    recPackItemList2.INSERT;
                    recWhseShipLine."Quantity Packed" := recWhseShipLine."Quantity Packed" + Qty;
                    recWhseShipLine."Quantity To Pack" := recWhseShipLine."Qty. to Ship" + recWhseShipLine."Qty. Shipped" - recWhseShipLine."Quantity Packed";
                    recWhseShipLine.MODIFY(FALSE);

                END;
            END;
        END;
    end;


    procedure UpdateQtyToHandle(ActivityType: Integer; cdCode: Code[20]; LotNo: Code[20]; Quantity: Decimal; UsrId: Code[50]) rtnBool: Boolean
    var
        recHandHeld: Record HandHeld;
        recILE: Record "Item Ledger Entry";
    begin
        rtnBool := FALSE;
        recHandHeld.RESET;
        recHandHeld.SETRANGE(recHandHeld.Type, ActivityType);
        recHandHeld.SETRANGE(No, cdCode);
        //    recHandHeld.SETRANGE("Item No",ItemNo);
        recHandHeld.SETRANGE("Lot No", LotNo);
        IF recHandHeld.FIND('-') THEN BEGIN
            recHandHeld.CALCFIELDS("Outstanding Qty");
            //      IF recHandHeld."Outstanding Qty" >= Quantity THEN BEGIN
            recHandHeld."Qty to Handle" := Quantity;
            recHandHeld."User Id" := UsrId;
            recHandHeld.MODIFY;
            rtnBool := TRUE;
            //recHandHeld.CALCFIELDS("Outstanding Qty");
            //decOutstabding := recHandHeld."Outstanding Qty";
            //       END;
        END ELSE BEGIN
            IF ActivityType = 2 THEN BEGIN
                recILE.RESET;
                recILE.SETRANGE("Lot No.", LotNo);
                IF recILE.FINDFIRST THEN BEGIN
                    recHandHeld.RESET;
                    recHandHeld.SETRANGE(recHandHeld.Type, ActivityType);
                    recHandHeld.SETRANGE(No, cdCode);
                    recHandHeld.SETRANGE("Item No", recILE."Item No.");
                    IF recHandHeld.FIND('-') THEN BEGIN
                        recHandHeld.CALCFIELDS("Outstanding Qty");
                        //            IF recHandHeld."Outstanding Qty" >= Quantity THEN BEGIN
                        //recHandHeld."Lot No":=LotNo;
                        recHandHeld.RENAME(recHandHeld.Type, recHandHeld.No, recHandHeld."Item No", recHandHeld."Bin Code", recHandHeld."Zone Code", LotNo);
                        recHandHeld."Qty to Handle" := Quantity;
                        recHandHeld."User Id" := UsrId;
                        recHandHeld.MODIFY;
                        rtnBool := TRUE;
                        //            END;
                    END;
                END;
            END;
        END;
        /*
        recHandHeld.RESET;
        recHandHeld.SETRANGE(recHandHeld.Type,ActivityType);
        recHandHeld.SETRANGE(No,cdCode);
        recHandHeld.SETRANGE("Lot No",LotNo);
        IF  recHandHeld.FIND('-') THEN BEGIN
          IF recHandHeld."Qty to Handle" = Quantity THEN
             TEST := TRUE
          ELSE
             TEST := FALSE;
        END;
           */

    end;


    procedure ReleasePacking(cdPackingNo: Code[20])
    var
        recPackingLine: Record "Packing Line";
        recPackItemLine: Record "Packing Item List";
        recPackHeader: Record "Packing Header";
        cuPack: Codeunit Packing;
    begin
        recPackHeader.RESET;
        recPackHeader.SETRANGE(recPackHeader."Packing No.", cdPackingNo);
        IF recPackHeader.FIND('-') THEN
            cuPack.ReleasePacking(recPackHeader);
    end;


    procedure RequestShip(cdPickingNo: Code[20])
    var
        recWarehouseShip: Record "Warehouse Shipment Header";
        recPackinhHeader: Record "Packing Header";
        recTrackingNo: Record "Tracking No.";
        cuTest: Codeunit "Integration Fedex UPS";
    //rptTest: Report "FedEx Label Report";
    // rptTest1: Report "UPS Label Report";
    begin
        /*//SPD_AG       (Not In Use)
        recPackinhHeader.RESET;
        recPackinhHeader.SETRANGE(recPackinhHeader."Packing No.",cdPickingNo);
        IF recPackinhHeader.FIND('-') THEN
           recWarehouseShip.RESET;
           recWarehouseShip.SETRANGE(recWarehouseShip."No.",recPackinhHeader."Source Document No.");
           IF recWarehouseShip.FIND('-') THEN
        
        IF recWarehouseShip."Shipping Agent Code"='FEDEX' THEN BEGIN
        IF recWarehouseShip."Tracking No."='' THEN  BEGIN
        cuTest.StandardOverNight(recWarehouseShip);
        //CurrPage.UPDATE;
         COMMIT;
         rptTest.InitVar(recWarehouseShip."No.");
         rptTest.RUN;
         //REPORT.RUNMODAL(50003,FALSE,FALSE,Rec);
         END;
        END;
        IF recWarehouseShip."Shipping Agent Code"='UPS' THEN BEGIN
           recTrackingNo.RESET;
           recTrackingNo.SETRANGE("Warehouse Shipment No",recWarehouseShip."No.");
           IF NOT recTrackingNo.FIND('-') THEN BEGIN
        
          // recWarehouseShip.TESTFIELD("No. of Boxes");
        
           recWarehouseShip.TESTFIELD("Shipping Agent Service Code");
           recWarehouseShip.TESTFIELD(Status,recWarehouseShip.Status::Released);
        
           cuTest.UPSRequest(recWarehouseShip,cdPickingNo);
           COMMIT;
            rptTest1.InitVar(recWarehouseShip."No.",'');
            rptTest1.RUN;
          END;
         END;
        IF recWarehouseShip."Shipping Agent Code"='ENDICIA' THEN BEGIN
           recTrackingNo.RESET;
           recTrackingNo.SETRANGE("Warehouse Shipment No",recWarehouseShip."No.");
           IF NOT recTrackingNo.FIND('-') THEN BEGIN
        
           //recWarehouseShip.TESTFIELD("No. of Boxes");
        
           recWarehouseShip.TESTFIELD("Shipping Agent Service Code");
           recWarehouseShip.TESTFIELD(Status,recWarehouseShip.Status::Released);
        
           cuTest.EndiciaRequest(recWarehouseShip,cdPickingNo);
           COMMIT;
            rptTest1.InitVar(recWarehouseShip."No.",'');
            rptTest1.RUN;
          END;
            END;
        */

    end;


    procedure UpdateShippingInstruction(PONo: Code[20]; ItemNo: Text[20]; ItemLineNo: Integer; ShipByAirQty: Decimal; ShipByBoatQty: Decimal; HoldQty: Decimal; ShipComments: Text[200])
    var
        recPurchLine: Record "Purchase Line";
        recPurchHeader: Record "Purchase Header";
    begin
        recPurchHeader.RESET;
        recPurchHeader.SETRANGE("Document Type", recPurchLine."Document Type"::Order);
        recPurchHeader.SETRANGE("No.", PONo);
        IF NOT recPurchHeader.FIND('-') THEN BEGIN
            EXIT
        END;

        recPurchLine.RESET;
        recPurchLine.SETRANGE("Document Type", recPurchLine."Document Type"::Order);
        recPurchLine.SETRANGE("Document No.", PONo);
        recPurchLine.SETRANGE("No.", ItemNo);
        recPurchLine.SETRANGE("Line No.", ItemLineNo);
        IF NOT recPurchLine.FIND('-') THEN
            EXIT
        ELSE BEGIN
            recPurchLine."Shipped Air" := ShipByAirQty;
            recPurchLine."Shipped Boat" := ShipByBoatQty;
            recPurchLine."Shipping Hold" := HoldQty;
            recPurchLine."Shipping Comment" := ShipComments;
            recPurchLine."Last Change" := TODAY;
            recPurchLine.MODIFY;
        END;
    end;


    procedure UpdateReadyGoodsInstruction(PONo: Code[20]; ItemNo: Text[20]; ItemLineNo: Integer; ExptReadyDt: Date; BalQty: Decimal; ReadyQty: Decimal; ReadyComments: Text[200])
    var
        recPurchLine: Record "Purchase Line";
        recPurchHeader: Record "Purchase Header";
    begin
        recPurchHeader.RESET;
        recPurchHeader.SETRANGE("Document Type", recPurchLine."Document Type"::Order);
        recPurchHeader.SETRANGE("No.", PONo);
        IF NOT recPurchHeader.FIND('-') THEN BEGIN
            EXIT
        END;

        recPurchLine.RESET;
        recPurchLine.SETRANGE("Document Type", recPurchLine."Document Type"::Order);
        recPurchLine.SETRANGE("Document No.", PONo);
        recPurchLine.SETRANGE("No.", ItemNo);
        recPurchLine.SETRANGE("Line No.", ItemLineNo);
        IF NOT recPurchLine.FIND('-') THEN
            EXIT
        ELSE BEGIN
            recPurchLine."Expected Receipt Date" := ExptReadyDt;
            recPurchLine."Balance Qty" := BalQty;
            recPurchLine."Ready Goods Qty" := ReadyQty;
            recPurchLine."Ready Goods Comment" := ReadyComments;
            recPurchLine."Last Change" := TODAY;
            recPurchLine.MODIFY;
        END;
    end;


    procedure AdjustShippingInstruction(PONo: Code[20]; ItemNo: Text[20]; ItemLineNo: Integer; ShipBy: Code[10]; ShipQty: Decimal)
    var
        recPurchLine: Record "Purchase Line";
        recPurchHeader: Record "Purchase Header";
    begin
        recPurchHeader.RESET;
        recPurchHeader.SETRANGE("Document Type", recPurchLine."Document Type"::Order);
        recPurchHeader.SETRANGE("No.", PONo);
        IF NOT recPurchHeader.FIND('-') THEN BEGIN
            EXIT
        END;

        recPurchLine.RESET;
        recPurchLine.SETRANGE("Document Type", recPurchLine."Document Type"::Order);
        recPurchLine.SETRANGE("Document No.", PONo);
        recPurchLine.SETRANGE("No.", ItemNo);
        recPurchLine.SETRANGE("Line No.", ItemLineNo);
        IF NOT recPurchLine.FIND('-') THEN BEGIN
            EXIT
        END;
        IF ShipBy = 'AIR' THEN BEGIN
            recPurchLine.VALIDATE(recPurchLine."Shipped Air", -ShipQty);
        END;
        IF ShipBy = 'BOAT' THEN BEGIN
            recPurchLine.VALIDATE(recPurchLine."Shipped Boat", -ShipQty);
        END;
        recPurchLine.MODIFY;

        IF recPurchHeader.Status = recPurchHeader.Status::Open THEN BEGIN
            recPurchHeader.Status := recPurchHeader.Status::Released;
        END;
    end;


    procedure CreateNOPCustomer(Name: Text[50]; Email: Text[80]; AdminComment: Text[250]; HasShopingCart: Boolean; Active: Boolean; Deleated: Text; CustomerPriceGroup: Code[20])
    var
        recCustomer: Record Customer;
    begin
        recCustomer.INIT;
        recCustomer."No." := '';
        recCustomer.Name := Name;
        recCustomer.AdminComments := AdminComment;
        recCustomer.HasShoppingCartItems := HasShopingCart;
        recCustomer.Active := Active;
        recCustomer."E-Mail" := Email;
        IF Deleated = '' THEN
            recCustomer.Blocked := recCustomer.Blocked::" "
        ELSE
            recCustomer.Blocked := recCustomer.Blocked::All;
        recCustomer."Customer Price Group" := CustomerPriceGroup;
        recCustomer.INSERT(TRUE);
    end;


    procedure InsertTrackingSpecificationPurNAV(DocNo: Code[20]; DocLineNo: Integer; Qty: Decimal; SerialNo: Code[20]; LotNo: Code[20]; DocketNo: Text[50]; ShipVia: Text[30])
    var
        recReservationEntry: Record "Reservation Entry";
        EntryNo: Integer;
        recPurchLine: Record "Purchase Line";
        recItem: Record Item;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        recPurchHeader: Record "Purchase Header";
        cuSalesRelease: Codeunit "Release Purchase Document";
        decQty: Decimal;
    begin

        recPurchHeader.RESET;
        recPurchHeader.SETRANGE("Document Type", recPurchLine."Document Type"::Order);
        recPurchHeader.SETRANGE("No.", DocNo);
        IF recPurchHeader.FIND('-') THEN BEGIN
            recPurchHeader.SetHideValidationDialog(TRUE);
            cuSalesRelease.Reopen(recPurchHeader);
        END;


        recPurchLine.RESET;
        recPurchLine.SETRANGE("Document Type", recPurchLine."Document Type"::Order);
        recPurchLine.SETRANGE("Document No.", DocNo);
        recPurchLine.SETRANGE("Line No.", DocLineNo);
        IF NOT recPurchLine.FIND('-') THEN
            EXIT
        ELSE BEGIN

            recPurchHeader.RESET;
            recPurchHeader.SETRANGE("Document Type", recPurchLine."Document Type"::Order);
            recPurchHeader.SETRANGE("No.", DocNo);
            IF recPurchHeader.FIND('-') THEN BEGIN
                recPurchHeader.SetHideValidationDialog(TRUE);
                decQty := 0;
                Qty := Qty * recPurchLine."Qty. per Unit of Measure";

                recReservationEntry.RESET;
                recReservationEntry.SETRANGE("Source ID", DocNo);
                recReservationEntry.SETRANGE(recReservationEntry.Positive, TRUE);
                recReservationEntry.SETRANGE(recReservationEntry."Source Type", 39);
                recReservationEntry.SETRANGE(recReservationEntry."Source Subtype", 1);
                //recReservationEntry.SETRANGE(recReservationEntry."Lot No.",LotNo);
                recReservationEntry.SETRANGE(recReservationEntry."Reservation Status", recReservationEntry."Reservation Status"::Surplus);
                recReservationEntry.SETRANGE(recReservationEntry."Source Ref. No.", DocLineNo);
                IF recReservationEntry.FIND('-') THEN
                    REPEAT
                        decQty := decQty + recReservationEntry."Quantity (Base)";
                    UNTIL recReservationEntry.NEXT = 0;
                decQty := Qty + decQty;
                IF (decQty) > recPurchLine."Outstanding Quantity" THEN
                    recPurchLine.VALIDATE(Quantity, decQty / recPurchLine."Qty. per Unit of Measure" + recPurchLine."Quantity Received");
                recPurchLine.VALIDATE("Qty. to Receive", decQty / recPurchLine."Qty. per Unit of Measure");
                recPurchLine.MODIFY;


                decQty := 0;
                recReservationEntry.RESET;
                recReservationEntry.SETRANGE("Source ID", DocNo);
                recReservationEntry.SETRANGE(recReservationEntry.Positive, TRUE);
                recReservationEntry.SETRANGE(recReservationEntry."Source Type", 39);
                recReservationEntry.SETRANGE(recReservationEntry."Source Subtype", 1);
                recReservationEntry.SETRANGE(recReservationEntry."Lot No.", LotNo);
                recReservationEntry.SETRANGE(recReservationEntry."Reservation Status", recReservationEntry."Reservation Status"::Surplus);
                recReservationEntry.SETRANGE(recReservationEntry."Source Ref. No.", DocLineNo);
                IF recReservationEntry.FIND('-') THEN BEGIN
                    recReservationEntry.VALIDATE("Quantity (Base)", Qty);
                    recReservationEntry.MODIFY;
                END ELSE BEGIN
                    recReservationEntry.RESET;
                    IF recReservationEntry.FIND('+') THEN
                        EntryNo := recReservationEntry."Entry No." + 1
                    ELSE
                        EntryNo := 1;

                    recReservationEntry.INIT;
                    recReservationEntry.VALIDATE("Entry No.", EntryNo);
                    recReservationEntry.VALIDATE("Source ID", DocNo);
                    recReservationEntry.VALIDATE("Item No.", recPurchLine."No.");
                    recReservationEntry.VALIDATE("Variant Code", recPurchLine."Variant Code");
                    recReservationEntry.VALIDATE("Source Type", 39);
                    recReservationEntry.VALIDATE("Source Subtype", 1);
                    recReservationEntry.VALIDATE("Reservation Status", recReservationEntry."Reservation Status"::Surplus);
                    recReservationEntry.VALIDATE("Location Code", recPurchLine."Location Code");
                    recReservationEntry.VALIDATE("Source Ref. No.", DocLineNo);
                    recReservationEntry.VALIDATE(Positive, TRUE);
                    IF recPurchLine.Type = recPurchLine.Type::Item THEN BEGIN
                        IF LotNo <> '' THEN
                            recReservationEntry.VALIDATE("Lot No.", LotNo)
                        ELSE BEGIN
                            recItem.GET(recPurchLine."No.");
                            recItem.TESTFIELD("Lot Nos.");
                            recReservationEntry.VALIDATE("Lot No.", NoSeriesMgt.GetNextNo(recItem."Lot Nos.", WORKDATE, TRUE));
                        END;
                    END;
                    recReservationEntry.VALIDATE("Dylot No.", DocNo);
                    recReservationEntry.VALIDATE("Quantity (Base)", Qty);
                    recReservationEntry.VALIDATE("Qty. per Unit of Measure", recPurchLine."Qty. per Unit of Measure");
                    recReservationEntry.VALIDATE(recReservationEntry."Shipment Date", recPurchLine."Requested Receipt Date");
                    recReservationEntry.VALIDATE("Item Tracking", recReservationEntry."Item Tracking"::"Lot No.");
                    recReservationEntry.INSERT;
                    recPurchHeader."Consignment No." := DocketNo;
                    recPurchHeader."Ship Via" := ShipVia;
                    recPurchHeader.MODIFY(FALSE);

                END;
            END;
        END;

        recPurchHeader.RESET;
        recPurchHeader.SETRANGE("Document Type", recPurchLine."Document Type"::Order);
        recPurchHeader.SETRANGE("No.", DocNo);
        IF recPurchHeader.FIND('-') THEN BEGIN
            recPurchHeader.SetHideValidationDialog(TRUE);
            cuSalesRelease.RUN(recPurchHeader);
        END;
    end;


    procedure InsertTransferOrderNAV(DocketNo: Text[30]; ShipVia: Text[30])
    var
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        recILE: Record "Item Ledger Entry";
        LineNo: Integer;
        InvtSetup: Record "Inventory Setup";
        cuNoSeries: Codeunit NoSeriesManagement;
        ILE: Record "Item Ledger Entry";
        TOSRE: Record "Reservation Entry";
        TORRE: Record "Reservation Entry";
    begin
        PurchRcptHeader.RESET;
        PurchRcptHeader.SETRANGE("Consignment No.", DocketNo);
        IF PurchRcptHeader.FIND('-') THEN BEGIN
            REPEAT
                PurchRcptLine.RESET;
                PurchRcptLine.SETRANGE("Document No.", PurchRcptHeader."No.");
                PurchRcptLine.SETFILTER(Quantity, '>%1', 0);
                IF PurchRcptLine.FIND('-') THEN
                    REPEAT
                        TransferHeader.RESET;
                        TransferHeader.SETRANGE("Consignment No.", DocketNo);
                        IF NOT TransferHeader.FIND('-') THEN BEGIN
                            TransferHeader.INIT;
                            InvtSetup.GET();
                            TransferHeader.VALIDATE("No.", '');
                            TransferHeader.INSERT(TRUE);
                            TransferHeader.VALIDATE("Transfer-from Code", PurchRcptLine."Location Code");
                            TransferHeader.VALIDATE("Transfer-to Code", 'SYOSSET');
                            TransferHeader.VALIDATE("Posting Date", TODAY);
                            TransferHeader.VALIDATE("Consignment No.", DocketNo);
                            TransferHeader.VALIDATE("Ship Via", ShipVia);
                            TransferHeader.MODIFY;

                            TransferLine.RESET;
                            TransferLine.SETRANGE("Document No.", TransferHeader."No.");
                            IF TransferLine.FIND('+') THEN
                                LineNo := TransferLine."Line No." + 10000
                            ELSE
                                LineNo := 10000;

                            TransferLine.INIT;
                            TransferLine.VALIDATE("Document No.", TransferHeader."No.");
                            //TransferLine.VALIDATE("Transfer-from Code",TransferHeader."Transfer-from Code");
                            //TransferLine.VALIDATE("Transfer-to Code",TransferHeader."Transfer-to Code");
                            TransferLine.VALIDATE("Line No.", LineNo);
                            TransferLine.VALIDATE("Item No.", PurchRcptLine."No.");
                            TransferLine.VALIDATE(Quantity, PurchRcptLine.Quantity);

                            TransferLine.VALIDATE("Purchase Receipt No.", PurchRcptLine."Document No.");
                            TransferLine.VALIDATE("Purchase Receipt Line No.", PurchRcptLine."Line No.");
                            TransferLine.INSERT;
                            //END;
                            ILE.RESET;
                            ILE.SETRANGE("Document Type", ILE."Document Type"::"Purchase Receipt");
                            ILE.SETRANGE("Document No.", TransferLine."Purchase Receipt No.");
                            ILE.SETRANGE("Document Line No.", TransferLine."Purchase Receipt Line No.");
                            IF ILE.FINDFIRST THEN BEGIN
                                REPEAT
                                    TOSRE.INIT;
                                    TOSRE.VALIDATE("Source ID", TransferLine."Document No.");
                                    TOSRE.VALIDATE("Source Ref. No.", TransferLine."Purchase Receipt Line No.");
                                    TOSRE.VALIDATE(Positive, false);
                                    TOSRE.VALIDATE("Source Type", 5741);
                                    TOSRE.VALIDATE("Source Subtype", 0);
                                    TOSRE.VALIDATE("Reservation Status", TOSRE."Reservation Status"::Surplus);
                                    TOSRE.VALIDATE("Item No.", TransferLine."Item No.");
                                    TOSRE.VALIDATE("Location Code", TransferHeader."Transfer-from Code");
                                    TOSRE.VALIDATE(Quantity, -ILE.Quantity);
                                    TOSRE.VALIDATE("Lot No.", ILE."Lot No.");
                                    TOSRE.Validate("Shipment Date", TransferLine."Shipment Date");
                                    TOSRE.Insert;

                                    TORRE.INIT;
                                    TORRE.VALIDATE("Source ID", TransferLine."Document No.");
                                    TORRE.VALIDATE("Source Ref. No.", TransferLine."Purchase Receipt Line No.");
                                    TORRE.VALIDATE(Positive, true);
                                    TORRE.VALIDATE("Source Type", 5741);
                                    TORRE.VALIDATE("Source Subtype", 1);
                                    TORRE.VALIDATE("Reservation Status", TORRE."Reservation Status"::Surplus);
                                    TORRE.VALIDATE("Item No.", TransferLine."Item No.");
                                    TORRE.VALIDATE("Location Code", TransferHeader."Transfer-to Code");
                                    TORRE.VALIDATE(Quantity, ILE.Quantity);
                                    TORRE.VALIDATE("Lot No.", ILE."Lot No.");
                                    TORRE.VALIDATE("Expected Receipt Date", TransferLine."Receipt Date");
                                    TORRE.Insert;
                                UNTIL ILE.NEXT = 0;
                            END;
                        END ELSE BEGIN
                            TransferLine.RESET;
                            TransferLine.SETRANGE("Document No.", TransferHeader."No.");
                            IF TransferLine.FIND('+') THEN
                                LineNo := TransferLine."Line No." + 10000
                            ELSE
                                LineNo := 10000;

                            TransferLine.INIT;
                            TransferLine.VALIDATE("Document No.", TransferHeader."No.");
                            //TransferLine.VALIDATE("Transfer-from Code",TransferHeader."Transfer-from Code");
                            //TransferLine.VALIDATE("Transfer-to Code",TransferHeader."Transfer-to Code");
                            TransferLine.VALIDATE("Line No.", LineNo);
                            TransferLine.VALIDATE("Item No.", PurchRcptLine."No.");
                            TransferLine.VALIDATE(Quantity, PurchRcptLine.Quantity);
                            TransferLine.VALIDATE("Purchase Receipt No.", PurchRcptLine."Document No.");
                            TransferLine.VALIDATE("Purchase Receipt Line No.", PurchRcptLine."Line No.");
                            TransferLine.INSERT;

                            ILE.RESET;
                            ILE.SETRANGE("Document Type", ILE."Document Type"::"Purchase Receipt");
                            ILE.SETRANGE("Document No.", TransferLine."Purchase Receipt No.");
                            ILE.SETRANGE("Document Line No.", TransferLine."Purchase Receipt Line No.");
                            IF ILE.FINDFIRST THEN BEGIN
                                REPEAT
                                    TOSRE.INIT;
                                    TOSRE.VALIDATE("Source ID", TransferLine."Document No.");
                                    TOSRE.VALIDATE("Source Ref. No.", TransferLine."Purchase Receipt Line No.");
                                    TOSRE.VALIDATE(Positive, false);
                                    TOSRE.VALIDATE("Source Type", 5741);
                                    TOSRE.VALIDATE("Source Subtype", 0);
                                    TOSRE.VALIDATE("Reservation Status", TOSRE."Reservation Status"::Surplus);
                                    TOSRE.VALIDATE("Item No.", TransferLine."Item No.");
                                    TOSRE.VALIDATE("Location Code", TransferHeader."Transfer-from Code");
                                    TOSRE.VALIDATE(Quantity, -ILE.Quantity);
                                    TOSRE.VALIDATE("Lot No.", ILE."Lot No.");
                                    TOSRE.Validate("Shipment Date", TransferLine."Shipment Date");
                                    TOSRE.Insert;

                                    TORRE.INIT;
                                    TORRE.VALIDATE("Source ID", TransferLine."Document No.");
                                    TORRE.VALIDATE("Source Ref. No.", TransferLine."Purchase Receipt Line No.");
                                    TORRE.VALIDATE(Positive, true);
                                    TORRE.VALIDATE("Source Type", 5741);
                                    TORRE.VALIDATE("Source Subtype", 1);
                                    TORRE.VALIDATE("Reservation Status", TORRE."Reservation Status"::Surplus);
                                    TORRE.VALIDATE("Item No.", TransferLine."Item No.");
                                    TORRE.VALIDATE("Location Code", TransferHeader."Transfer-to Code");
                                    TORRE.VALIDATE(Quantity, ILE.Quantity);
                                    TORRE.VALIDATE("Lot No.", ILE."Lot No.");
                                    TORRE.VALIDATE("Expected Receipt Date", TransferLine."Receipt Date");
                                    TORRE.Insert;
                                UNTIL ILE.NEXT = 0;
                            END;
                        END;

                    UNTIL PurchRcptLine.NEXT = 0;
            UNTIL PurchRcptHeader.NEXT = 0;
        END;
    end;


    procedure RemoveReservationEntryNAV(DocNo: Code[20])
    var
        recReservationEntry: Record "Reservation Entry";
        EntryNo: Integer;
        recPurchLine: Record "Purchase Line";
        recItem: Record Item;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        recPurchHeader: Record "Purchase Header";
        cuSalesRelease: Codeunit "Release Purchase Document";
        decQty: Decimal;
    begin
        recPurchHeader.RESET;
        recPurchHeader.SETRANGE("Document Type", recPurchHeader."Document Type"::Order);
        recPurchHeader.SETRANGE("No.", DocNo);
        IF recPurchHeader.FIND('-') THEN BEGIN
            cuSalesRelease.Reopen(recPurchHeader);
        END;

        recReservationEntry.RESET;
        recReservationEntry.SETRANGE("Source ID", DocNo);
        recReservationEntry.SETRANGE(Positive, TRUE);
        recReservationEntry.SETRANGE("Source Type", 39);
        recReservationEntry.SETRANGE("Source Subtype", 1);
        //recReservationEntry.SETRANGE("Lot No.",LotNo);
        recReservationEntry.SETRANGE("Reservation Status", recReservationEntry."Reservation Status"::Surplus);
        //recReservationEntry.SETRANGE("Source Ref. No.",DocLineNo);
        IF recReservationEntry.FIND('-') THEN BEGIN
            REPEAT
                recReservationEntry.DELETE;
            UNTIL recReservationEntry.NEXT = 0;
        END;
        recPurchLine.RESET;
        recPurchLine.SETRANGE("Document Type", recPurchLine."Document Type"::Order);
        recPurchLine.SETRANGE("Document No.", DocNo);
        IF recPurchLine.FIND('-') THEN
            REPEAT
                recPurchLine.VALIDATE("Qty. to Receive", 0);
                recPurchLine.MODIFY;
            UNTIL recPurchLine.NEXT = 0;


        recPurchHeader.RESET;
        recPurchHeader.SETRANGE("Document Type", recPurchHeader."Document Type"::Order);
        recPurchHeader.SETRANGE("No.", DocNo);
        IF recPurchHeader.FIND('-') THEN BEGIN
            cuSalesRelease.RUN(recPurchHeader);
        END;
    end;
}

