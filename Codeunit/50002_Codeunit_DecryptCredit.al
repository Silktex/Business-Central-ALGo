codeunit 50002 "Decrypt Credit"
{

    trigger OnRun()
    begin
    end;

    var
        //EncryptionMgt: Codeunit "Encryption Management";
        recWhseHeader: Record "Warehouse Shipment Line";


    procedure Decryptl(CreditCardNumber: Code[20]) txtData: Text[1024]
    var
        DoPaymentCredit: Record "DO Payment Credit Card Number";
    begin
        DoPaymentCredit.GET(CreditCardNumber);
        txtData := DoPaymentCredit.GetDataNew(DoPaymentCredit);
        EXIT(txtData);
    end;


    procedure DecryptEntry(Value: Text[1024]): Text[1024]
    begin
        EXIT(Decrypt(Value));
    end;

    procedure UPSTracking(WhseCode: Code[20]; TrackingNo: Text[30]; Image: BigText)
    var
        recTrackingNo: Record "Tracking No.";
        // Bytes: DotNet Array;
        // Convert: DotNet Convert;
        // MemoryStream: DotNet MemoryStream;
        OStream: OutStream;
        //rptTest1: Report "UPS Label Report";
        OrderNo: Code[20];
    begin


        recWhseHeader.RESET;
        recWhseHeader.SETRANGE(recWhseHeader."No.", WhseCode);
        IF recWhseHeader.FIND('-') THEN BEGIN
            OrderNo := recWhseHeader."Source No.";
        END;

        recTrackingNo.RESET;
        recTrackingNo.SETRANGE(recTrackingNo."Warehouse Shipment No", WhseCode);
        recTrackingNo.SETRANGE("Tracking No.", TrackingNo);
        IF NOT recTrackingNo.FIND('-') THEN BEGIN
            recTrackingNo.INIT;
            recTrackingNo."Warehouse Shipment No" := WhseCode;
            recTrackingNo."Tracking No." := TrackingNo;
            recTrackingNo."Source Document No." := OrderNo;
            recTrackingNo."Service Name" := 'UPS';

            // Bytes := Convert.FromBase64String(Image);
            // MemoryStream := MemoryStream.MemoryStream(Bytes);
            // recTrackingNo.Image.CREATEOUTSTREAM(OStream);
            // MemoryStream.WriteTo(OStream);

            recTrackingNo.INSERT;
        END;
        //rptTest1.InitVar(WhseCode,TrackingNo);
        //rptTest1.RUN;
    end;


    procedure EndiciaTracking(WhseCode: Code[20]; TrackingNo: Text[30]; Image: BigText; TransactionNo: Text[30]; cdPickingNo: Code[20])
    var
        recTrackingNo: Record "Tracking No.";
        // Bytes: DotNet Array;
        // Convert: DotNet Convert;
        // MemoryStream: DotNet MemoryStream;
        OStream: OutStream;
        //rptTest1: Report "UPS Label Report";
        OrderNo: Code[20];
        recPackingHeader: Record "Packing Header";
    begin
        //ENDINT1.0
        IF recPackingHeader.GET(cdPickingNo) THEN BEGIN
            recPackingHeader."Tracking No." := TrackingNo;
            recPackingHeader.MODIFY;
        END;
        //ENDINT1.0

        recWhseHeader.RESET;
        recWhseHeader.SETRANGE(recWhseHeader."No.", WhseCode);
        IF recWhseHeader.FIND('-') THEN BEGIN
            OrderNo := recWhseHeader."Source No.";
        END;

        recTrackingNo.RESET;
        recTrackingNo.SETRANGE(recTrackingNo."Warehouse Shipment No", WhseCode);
        recTrackingNo.SETRANGE("Tracking No.", TrackingNo);
        IF NOT recTrackingNo.FIND('-') THEN BEGIN
            recTrackingNo.INIT;
            recTrackingNo."Warehouse Shipment No" := WhseCode;
            recTrackingNo."Tracking No." := TrackingNo;
            recTrackingNo."Source Document No." := OrderNo;
            recTrackingNo."Service Name" := 'ENDICIA';
            recTrackingNo."Transaction No." := TransactionNo;
            // Bytes := Convert.FromBase64String(Image);
            // MemoryStream := MemoryStream.MemoryStream(Bytes);
            // recTrackingNo.Image.CREATEOUTSTREAM(OStream);
            // MemoryStream.WriteTo(OStream);
            recTrackingNo.INSERT;
        END;
        //rptTest1.InitVar(WhseCode,TrackingNo);
        //rptTest1.RUN;
    end;

    //VR code not in use
    procedure UPSTrackingPackingLine(WhseCode: Code[20]; TrackingNo: Text[30]; Image: BigText; LineNo: Integer)
    var
        recTrackingNo: Record "Tracking No.";
        // Bytes: DotNet Array;
        // Convert: DotNet Convert;
        // MemoryStream: DotNet MemoryStream;
        OStream: OutStream;
        // rptTest1: Report "UPS Label Report";
        OrderNo: Code[20];
        WhseShipHeader: Record "Warehouse Shipment Header";
        recPackingLine: Record "Packing Line";
    begin
        WhseShipHeader.RESET;
        WhseShipHeader.SETRANGE("No.", WhseCode);
        WhseShipHeader.SETRANGE("Shipping Agent Code", 'UPS');
        IF WhseShipHeader.FINDFIRST THEN BEGIN
            recPackingLine.RESET;
            recPackingLine.SETRANGE(recPackingLine."Source Document No.", WhseShipHeader."No.");
            recPackingLine.SETRANGE(recPackingLine."Void Entry", FALSE);
            recPackingLine.SETRANGE("Line No.", LineNo);
            IF recPackingLine.FINDSET THEN BEGIN
                recPackingLine."Tracking No." := TrackingNo;
                // Bytes := Convert.FromBase64String(Image);
                // MemoryStream := MemoryStream.MemoryStream(Bytes);
                // recPackingLine.Image.CREATEOUTSTREAM(OStream);
                // MemoryStream.WriteTo(OStream);
                recPackingLine.MODIFY;
            END;
        END;
    end;


    procedure AddressUpdateCust()
    begin
    end;
}

