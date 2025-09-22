codeunit 50012 "SLK Barcode Management"
{

    SingleInstance = false;

    procedure EncodeEAN13(pcodBarcode: Code[250]; pintSize: Integer; pblnVertical: Boolean; var precTmpTempBlob: Codeunit "Temp Blob")
    var
        lintCheckDigit: Integer;
        lcodBarInclCheckD: Code[13];
        ltxtWeight: Text[12];
        ltxtSentinel: Text[3];
        ltxtCenterGuard: Text[6];
        ltxtParEnc: array[10] of Text[6];
        ltxtSetEnc: array[10, 10] of Text[7];
        lintCount: Integer;
        lintCoding: Integer;
        lintNumber: Integer;
        ltxtBarcode: Text[30];
        lintLines: Integer;
        lintBars: Integer;
        loutBmpHeaderOutStream: OutStream;
    begin
        CLEAR(bxtBarcodeBinary);
        CLEAR(precTmpTempBlob);
        ltxtSentinel := '101';
        ltxtCenterGuard := '01010';
        ltxtWeight := '131313131313';

        IF STRLEN(pcodBarcode) <> 12 THEN
            ERROR(ErrorLengthLbl, 12);

        IF NOT (pintSize IN [1, 2, 3, 4, 5]) THEN
            ERROR(ErrorSizeLbl);

        FOR lintCount := 1 TO STRLEN(pcodBarcode) DO
            IF NOT (pcodBarcode[lintCount] IN ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']) THEN
                ERROR(ErrrorNumberLbl);

        InitEAN813(ltxtParEnc, ltxtSetEnc);

        //CALCULATE CHECKDIGIT
        lintCheckDigit := STRCHECKSUM(pcodBarcode, ltxtWeight, 10);

        //PAYLOAD TO ENCODE
        lcodBarInclCheckD := COPYSTR(pcodBarcode, 2, STRLEN(pcodBarcode)) + FORMAT(lintCheckDigit);

        //EAN PARITY ENCODING TABLE
        EVALUATE(lintCoding, FORMAT(pcodBarcode[1]));
        lintCoding += 1;

        //ADD START SENTINEL
        bxtBarcodeBinary.ADDTEXT(ltxtSentinel);

        FOR lintCount := 1 TO STRLEN(lcodBarInclCheckD) DO BEGIN

            //ADD CENTERGUARD
            IF lintCount = 7 THEN
                bxtBarcodeBinary.ADDTEXT(ltxtCenterGuard);

            EVALUATE(lintNumber, FORMAT(lcodBarInclCheckD[lintCount]));

            IF lintCount <= 6 THEN BEGIN
                ltxtBarcode := ltxtParEnc[lintCoding];
                CASE ltxtBarcode[lintCount] OF
                    'O':
                        bxtBarcodeBinary.ADDTEXT(ltxtSetEnc[lintNumber + 1] [1]);
                    'E':
                        bxtBarcodeBinary.ADDTEXT(ltxtSetEnc[lintNumber + 1] [2]);
                END;
            END ELSE
                bxtBarcodeBinary.ADDTEXT(ltxtSetEnc[lintNumber + 1] [3]);

        END;

        //ADD STOP SENTINEL
        bxtBarcodeBinary.ADDTEXT(ltxtSentinel);

        lintBars := bxtBarcodeBinary.LENGTH;
        lintLines := ROUND(lintBars * 0.25, 1, '>');

        precTmpTempBlob.CreateOutStream(loutBmpHeaderOutStream);

        //WRITING HEADER
        CreateBMPHeader(loutBmpHeaderOutStream, lintBars, lintLines, pintSize, pblnVertical);

        //WRITE BARCODE DETAIL
        CreateBarcodeDetail(lintLines, pintSize, pblnVertical, loutBmpHeaderOutStream);
    end;


    procedure EncodeCode128(pcodBarcode: Code[1024]; pintSize: Integer; pblnVertical: Boolean; var TempCompanyInformation: Record "Company Information" temporary)
    var
        TempEDCCode12839: Record "SLK Code 128/39" temporary;
        lintCount1: Integer;
        lcharCurrentCharSet: Char;
        lintWeightSum: Integer;
        lintCount2: Integer;
        lintConvInt: Integer;
        ltxtTerminationBar: Text[2];
        lintCheckDigit: Integer;
        lintConvInt1: Integer;
        lintConvInt2: Integer;
        lblnnumber: Boolean;
        lintLines: Integer;
        lintBars: Integer;
        loutBmpHeaderOutStream: OutStream;
    begin
        CLEAR(bxtBarcodeBinary);
        CLEAR(TempCompanyInformation);
        CLEAR(TempEDCCode12839);
        TempEDCCode12839.DeleteAll();
        CLEAR(lcharCurrentCharSet);
        ltxtTerminationBar := '11';

        IF NOT (pintSize IN [1, 2, 3, 4, 5]) THEN
            ERROR(ErrorSizeLbl);

        InitCode128(TempEDCCode12839);

        FOR lintCount1 := 1 TO STRLEN(pcodBarcode) DO BEGIN
            lintCount2 += 1;
            lblnnumber := FALSE;
            TempEDCCode12839.Reset();

            IF EVALUATE(lintConvInt1, FORMAT(pcodBarcode[lintCount1])) THEN
                lblnnumber := EVALUATE(lintConvInt2, FORMAT(pcodBarcode[lintCount1 + 1]));

            //A '.' IS EVALUATED AS A 0, EXTRA CHECK NEEDED
            IF FORMAT(pcodBarcode[lintCount1]) = '.' THEN
                lblnnumber := FALSE;

            IF FORMAT(pcodBarcode[lintCount1 + 1]) = '.' THEN
                lblnnumber := FALSE;

            IF lblnnumber AND (lintConvInt1 IN [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) AND (lintConvInt2 IN [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) THEN BEGIN
                IF (lcharCurrentCharSet <> 'C') THEN BEGIN
                    IF (lintCount1 = 1) THEN BEGIN
                        TempEDCCode12839.GET('STARTC');
                        EVALUATE(lintConvInt, TempEDCCode12839.Value);
                        lintWeightSum := lintConvInt;
                    END ELSE BEGIN
                        TempEDCCode12839.GET('CODEC');
                        EVALUATE(lintConvInt, TempEDCCode12839.Value);
                        lintWeightSum += lintConvInt * lintCount2;
                        lintCount2 += 1;
                    END;

                    bxtBarcodeBinary.ADDTEXT(FORMAT(TempEDCCode12839.Encoding));
                    lcharCurrentCharSet := 'C';
                END;
            END ELSE
                IF lcharCurrentCharSet <> 'A' THEN BEGIN
                    IF (lintCount1 = 1) THEN BEGIN
                        TempEDCCode12839.GET('STARTA');
                        EVALUATE(lintConvInt, TempEDCCode12839.Value);
                        lintWeightSum := lintConvInt;
                    END ELSE BEGIN
                        //CODEA
                        TempEDCCode12839.GET('FNC4');
                        EVALUATE(lintConvInt, TempEDCCode12839.Value);
                        lintWeightSum += lintConvInt * lintCount2;
                        lintCount2 += 1;
                    END;

                    bxtBarcodeBinary.ADDTEXT(FORMAT(TempEDCCode12839.Encoding));
                    lcharCurrentCharSet := 'A';
                END;

            CASE lcharCurrentCharSet OF
                'A':
                    BEGIN
                        TempEDCCode12839.GET(FORMAT(pcodBarcode[lintCount1]));

                        EVALUATE(lintConvInt, TempEDCCode12839.Value);

                        lintWeightSum += lintConvInt * lintCount2;
                        bxtBarcodeBinary.ADDTEXT(FORMAT(TempEDCCode12839.Encoding));
                    END;
                'C':
                    BEGIN
                        TempEDCCode12839.RESET();
                        TempEDCCode12839.SETCURRENTKEY(Value);
                        TempEDCCode12839.SetRange(Value, (FORMAT(pcodBarcode[lintCount1]) + FORMAT(pcodBarcode[lintCount1 + 1])));
                        TempEDCCode12839.FINDFIRST();

                        EVALUATE(lintConvInt, TempEDCCode12839.Value);
                        lintWeightSum += lintConvInt * lintCount2;

                        bxtBarcodeBinary.ADDTEXT(FORMAT(TempEDCCode12839.Encoding));
                        lintCount1 += 1;
                    END;
            END;
        END;

        lintCheckDigit := lintWeightSum MOD 103;

        //ADD CHECK DIGIT
        TempEDCCode12839.Reset();
        TempEDCCode12839.SETCURRENTKEY(Value);

        IF lintCheckDigit <= 9 THEN
            TempEDCCode12839.SetRange(Value, '0' + FORMAT(lintCheckDigit))
        ELSE
            TempEDCCode12839.SetRange(Value, FORMAT(lintCheckDigit));

        TempEDCCode12839.FINDFIRST();
        bxtBarcodeBinary.ADDTEXT(FORMAT(TempEDCCode12839.Encoding));

        //ADD STOP CHARACTER
        TempEDCCode12839.GET('STOP');
        bxtBarcodeBinary.ADDTEXT(FORMAT(TempEDCCode12839.Encoding));

        //ADD TERMINATION BAR
        bxtBarcodeBinary.ADDTEXT(ltxtTerminationBar);

        lintBars := bxtBarcodeBinary.LENGTH;
        lintLines := ROUND(lintBars * 0.25, 1, '>');

        TempCompanyInformation.Picture.CREATEOUTSTREAM(loutBmpHeaderOutStream);

        //WRITING HEADER
        CreateBMPHeader(loutBmpHeaderOutStream, lintBars, lintLines, pintSize, pblnVertical);

        //WRITE BARCODE DETAIL
        CreateBarcodeDetail(lintLines, pintSize, pblnVertical, loutBmpHeaderOutStream);
    end;


    procedure EncodeCode39(pcodBarcode: Code[1024]; pintSize: Integer; pblnCheckDigit: Boolean; pblnVertical: Boolean; var precTmpTempBlob: Codeunit "Temp Blob")
    var
        TempEDCCode12839: Record "SLK Code 128/39" temporary;
        lintCount1: Integer;
        lintSum: Integer;
        lintConvInt: Integer;
        lintCheckDigit: Integer;
        lintLines: Integer;
        lintBars: Integer;
        loutBmpHeaderOutStream: OutStream;
    begin
        CLEAR(bxtBarcodeBinary);
        CLEAR(precTmpTempBlob);
        CLEAR(TempEDCCode12839);
        TempEDCCode12839.DeleteAll();
        lintSum := 0;

        IF NOT (pintSize IN [1, 2, 3, 4, 5]) THEN
            ERROR(ErrorSizeLbl);

        InitCode39(TempEDCCode12839);

        //CALCULATE CHECK DIGIT
        IF pblnCheckDigit THEN BEGIN
            FOR lintCount1 := 1 TO STRLEN(pcodBarcode) DO BEGIN
                TempEDCCode12839.GET(FORMAT(pcodBarcode[lintCount1]));
                EVALUATE(lintConvInt, TempEDCCode12839.Value);
                lintSum += lintConvInt;
            END;
            lintCheckDigit := lintSum MOD 43;
            pcodBarcode := pcodBarcode + FORMAT(lintCheckDigit);
        END;

        //ADD START CHARACTER
        TempEDCCode12839.GET('*');
        bxtBarcodeBinary.ADDTEXT(FORMAT(TempEDCCode12839.Encoding));

        //ADD SEPERATOR
        bxtBarcodeBinary.ADDTEXT('0');

        FOR lintCount1 := 1 TO STRLEN(pcodBarcode) DO BEGIN
            //ADD SEPERATOR
            bxtBarcodeBinary.ADDTEXT('0');

            TempEDCCode12839.GET(FORMAT(pcodBarcode[lintCount1]));
            bxtBarcodeBinary.ADDTEXT(FORMAT(TempEDCCode12839.Encoding));
        END;

        //ADD SEPERATOR
        bxtBarcodeBinary.ADDTEXT('0');


        //ADD STOP CHARACTER
        TempEDCCode12839.GET('*');
        bxtBarcodeBinary.ADDTEXT(FORMAT(TempEDCCode12839.Encoding));

        lintBars := bxtBarcodeBinary.LENGTH;
        lintLines := ROUND(lintBars * 0.25, 1, '>');

        precTmpTempBlob.CREATEOUTSTREAM(loutBmpHeaderOutStream);

        //WRITING HEADER
        CreateBMPHeader(loutBmpHeaderOutStream, lintBars, lintLines, pintSize, pblnVertical);

        //WRITE BARCODE DETAIL
        CreateBarcodeDetail(lintLines, pintSize, pblnVertical, loutBmpHeaderOutStream);
    end;


    procedure EncodeEAN8(pcodBarcode: Code[250]; pintSize: Integer; pblnVertical: Boolean; var precTmpTempBlob: Codeunit "Temp Blob")
    var
        ltxtWeight: Text[12];
        ltxtSentinel: Text[3];
        ltxtCenterGuard: Text[6];
        ltxtParEnc: array[10] of Text[6];
        ltxtSetEnc: array[10, 10] of Text[7];
        lintCheckDigit: Integer;
        lintCount: Integer;
        lintNumber: Integer;
        lintBars: Integer;
        lintLines: Integer;
        loutBmpHeaderOutStream: OutStream;
        lcodBarInclCheckD: Code[8];
    begin
        CLEAR(bxtBarcodeBinary);
        CLEAR(precTmpTempBlob);
        ltxtSentinel := '101';
        ltxtCenterGuard := '01010';
        ltxtWeight := '3131313';

        IF STRLEN(pcodBarcode) <> 7 THEN
            ERROR(ErrorLengthLbl, 7);

        IF NOT (pintSize IN [1, 2, 3, 4, 5]) THEN
            ERROR(ErrorSizeLbl);

        FOR lintCount := 1 TO STRLEN(pcodBarcode) DO
            IF NOT (pcodBarcode[lintCount] IN ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']) THEN
                ERROR(ErrrorNumberLbl);


        InitEAN813(ltxtParEnc, ltxtSetEnc);

        //CALCULATE CHECKDIGIT
        lintCheckDigit := STRCHECKSUM(pcodBarcode, ltxtWeight, 10);

        //PAYLOAD TO ENCODE
        lcodBarInclCheckD := pcodBarcode + FORMAT(lintCheckDigit);

        //ADD START SENTINEL
        bxtBarcodeBinary.ADDTEXT(ltxtSentinel);

        FOR lintCount := 1 TO STRLEN(lcodBarInclCheckD) DO BEGIN
            //ADD CENTERGUARD
            IF lintCount = 5 THEN
                bxtBarcodeBinary.ADDTEXT(ltxtCenterGuard);

            EVALUATE(lintNumber, FORMAT(lcodBarInclCheckD[lintCount]));

            IF lintCount <= 4 THEN
                bxtBarcodeBinary.ADDTEXT(ltxtSetEnc[lintNumber + 1] [1])
            ELSE
                bxtBarcodeBinary.ADDTEXT(ltxtSetEnc[lintNumber + 1] [3]);

        END;

        //ADD STOP SENTINEL
        bxtBarcodeBinary.ADDTEXT(ltxtSentinel);

        lintBars := bxtBarcodeBinary.LENGTH;
        lintLines := ROUND(lintBars * 0.25, 1, '>');

        precTmpTempBlob.CREATEOUTSTREAM(loutBmpHeaderOutStream);

        //WRITING HEADER
        CreateBMPHeader(loutBmpHeaderOutStream, lintBars, lintLines, pintSize, pblnVertical);

        //WRITE BARCODE DETAIL
        CreateBarcodeDetail(lintLines, pintSize, pblnVertical, loutBmpHeaderOutStream);
    end;

    local procedure CreateBMPHeader(var poutBmpHeaderOutStream: OutStream; pintCols: Integer; pintRows: Integer; pintSize: Integer; pblnVertical: Boolean)
    var
        charInf: Char;
        lintResolution: Integer;
        lintWidth: Integer;
        lintHeight: Integer;
    begin

        lintResolution := ROUND(2835 / pintSize, 1, '=');

        IF pblnVertical THEN BEGIN
            lintWidth := pintRows * pintSize;
            lintHeight := pintCols;
        END ELSE BEGIN
            lintWidth := pintCols * pintSize;
            lintHeight := pintRows * pintSize;
        END;

        charInf := 'B';
        poutBmpHeaderOutStream.WRITE(charInf, 1);
        charInf := 'M';
        poutBmpHeaderOutStream.WRITE(charInf, 1);
        poutBmpHeaderOutStream.WRITE(54 + pintRows * pintCols * 3, 4); //SIZE BMP
        poutBmpHeaderOutStream.WRITE(0, 4); //APPLICATION SPECIFIC
        poutBmpHeaderOutStream.WRITE(54, 4); //OFFSET DATA PIXELS
        poutBmpHeaderOutStream.WRITE(40, 4); //NUMBER OF BYTES IN HEADER FROM THIS POINT
        poutBmpHeaderOutStream.WRITE(lintWidth, 4); //WIDTH PIXEL
        poutBmpHeaderOutStream.WRITE(lintHeight, 4); //HEIGHT PIXEL
        poutBmpHeaderOutStream.WRITE(65536 * 24 + 1, 4); //COLOR DEPTH
        poutBmpHeaderOutStream.WRITE(0, 4); //NO. OF COLOR PANES & BITS PER PIXEL
        poutBmpHeaderOutStream.WRITE(0, 4); //SIZE BMP DATA
        poutBmpHeaderOutStream.WRITE(lintResolution, 4); //HORIZONTAL RESOLUTION
        poutBmpHeaderOutStream.WRITE(lintResolution, 4); //VERTICAL RESOLUTION
        poutBmpHeaderOutStream.WRITE(0, 4); //NO. OF COLORS IN PALETTE
        poutBmpHeaderOutStream.WRITE(0, 4); //IMPORTANT COLORS
    end;

    local procedure CreateBarcodeDetail(pintLines: Integer; pintSize: Integer; pblnVertical: Boolean; var poutBmpHeaderOutStream: OutStream)
    var
        lintLineLoop: Integer;
        lintBarLoop: Integer;
        ltxtByte: Text[1];
        lchar: Char;
        lintChainFiller: Integer;
        lintSize: Integer;
    begin
        IF pblnVertical THEN
            FOR lintBarLoop := 1 TO (bxtBarcodeBinary.LENGTH) DO BEGIN

                FOR lintLineLoop := 1 TO (pintLines * pintSize) DO BEGIN
                    bxtBarcodeBinary.GETSUBTEXT(ltxtByte, lintBarLoop, 1);

                    IF ltxtByte = '1' THEN
                        lchar := 0
                    ELSE
                        //lchar := 255;
                        lchar := 253;

                    poutBmpHeaderOutStream.WRITE(lchar, 1);
                    poutBmpHeaderOutStream.WRITE(lchar, 1);
                    poutBmpHeaderOutStream.WRITE(lchar, 1);
                END;

                FOR lintChainFiller := 1 TO (lintLineLoop MOD 4) DO BEGIN
                    //Adding 0 bytes if needed - line end
                    lchar := 0;
                    poutBmpHeaderOutStream.WRITE(lchar, 1);
                END;
            END
        ELSE
            FOR lintLineLoop := 1 TO pintLines * pintSize DO BEGIN
                FOR lintBarLoop := 1 TO bxtBarcodeBinary.LENGTH DO BEGIN
                    bxtBarcodeBinary.GETSUBTEXT(ltxtByte, lintBarLoop, 1);

                    IF ltxtByte = '1' THEN
                        lchar := 0
                    ELSE
                        //lchar := 255;
                        lchar := 253;

                    FOR lintSize := 1 TO pintSize DO BEGIN
                        //Putting Pixel: Black or White
                        poutBmpHeaderOutStream.WRITE(lchar, 1);
                        poutBmpHeaderOutStream.WRITE(lchar, 1);
                        poutBmpHeaderOutStream.WRITE(lchar, 1);
                    END
                END;

                FOR lintChainFiller := 1 TO ((lintBarLoop * pintSize) MOD 4) DO BEGIN
                    //Adding 0 bytes if needed - line end
                    lchar := 0;
                    poutBmpHeaderOutStream.WRITE(lchar, 1);
                END;
            END;
    end;

    local procedure InitEAN813(var ptxtParEnc: array[10] of Text[6]; var ptxtSetEnc: array[10, 10] of Text[7])
    begin
        //INIT CONSTANTS
        //0
        ptxtParEnc[1] := 'OOOOOO';
        //1
        ptxtParEnc[2] := 'OOEOEE';
        //2
        ptxtParEnc[3] := 'OOEEOE';
        //3
        ptxtParEnc[4] := 'OOEEEO';
        //4
        ptxtParEnc[5] := 'OEOOEE';
        //5
        ptxtParEnc[6] := 'OEEOOE';
        //6
        ptxtParEnc[7] := 'OEEEOO';
        //7
        ptxtParEnc[8] := 'OEOEOE';
        //8
        ptxtParEnc[9] := 'OEOEEO';
        //9
        ptxtParEnc[10] := 'OEEOEO';

        //0
        ptxtSetEnc[1] [1] := '0001101';
        ptxtSetEnc[1] [2] := '0100111';
        ptxtSetEnc[1] [3] := '1110010';
        //1
        ptxtSetEnc[2] [1] := '0011001';
        ptxtSetEnc[2] [2] := '0110011';
        ptxtSetEnc[2] [3] := '1100110';
        //2
        ptxtSetEnc[3] [1] := '0010011';
        ptxtSetEnc[3] [2] := '0011011';
        ptxtSetEnc[3] [3] := '1101100';
        //3
        ptxtSetEnc[4] [1] := '0111101';
        ptxtSetEnc[4] [2] := '0100001';
        ptxtSetEnc[4] [3] := '1000010';
        //4
        ptxtSetEnc[5] [1] := '0100011';
        ptxtSetEnc[5] [2] := '0011101';
        ptxtSetEnc[5] [3] := '1011100';
        //5
        ptxtSetEnc[6] [1] := '0110001';
        ptxtSetEnc[6] [2] := '0111001';
        ptxtSetEnc[6] [3] := '1001110';
        //6
        ptxtSetEnc[7] [1] := '0101111';
        ptxtSetEnc[7] [2] := '0000101';
        ptxtSetEnc[7] [3] := '1010000';
        //7
        ptxtSetEnc[8] [1] := '0111011';
        ptxtSetEnc[8] [2] := '0010001';
        ptxtSetEnc[8] [3] := '1000100';
        //8
        ptxtSetEnc[9] [1] := '0110111';
        ptxtSetEnc[9] [2] := '0001001';
        ptxtSetEnc[9] [3] := '1001000';
        //9
        ptxtSetEnc[10] [1] := '0001011';
        ptxtSetEnc[10] [2] := '0010111';
        ptxtSetEnc[10] [3] := '1110100';
    end;

    local procedure InitCode128(var TempEDCCode12839: Record "SLK Code 128/39" temporary)
    begin
        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := ' ';
        TempEDCCode12839.CharB := ' ';
        TempEDCCode12839.CharC := ' ';
        TempEDCCode12839.Value := '00';
        TempEDCCode12839.Encoding := '11011001100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '!';
        TempEDCCode12839.CharB := '!';
        TempEDCCode12839.CharC := '01';
        TempEDCCode12839.Value := '01';
        TempEDCCode12839.Encoding := '11001101100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '"';
        TempEDCCode12839.CharB := '"';
        TempEDCCode12839.CharC := '02';
        TempEDCCode12839.Value := '02';
        TempEDCCode12839.Encoding := '11001100110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '#';
        TempEDCCode12839.CharB := '#';
        TempEDCCode12839.CharC := '03';
        TempEDCCode12839.Value := '03';
        TempEDCCode12839.Encoding := '10010011000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '$';
        TempEDCCode12839.CharB := '$';
        TempEDCCode12839.CharC := '04';
        TempEDCCode12839.Value := '04';
        TempEDCCode12839.Encoding := '10010001100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '%';
        TempEDCCode12839.CharB := '%';
        TempEDCCode12839.CharC := '05';
        TempEDCCode12839.Value := '05';
        TempEDCCode12839.Encoding := '10001001100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '&';
        TempEDCCode12839.CharB := '&';
        TempEDCCode12839.CharC := '06';
        TempEDCCode12839.Value := '06';
        TempEDCCode12839.Encoding := '10011001000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '''';
        TempEDCCode12839.CharB := '''';
        TempEDCCode12839.CharC := '07';
        TempEDCCode12839.Value := '07';
        TempEDCCode12839.Encoding := '10011000100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '(';
        TempEDCCode12839.CharB := '(';
        TempEDCCode12839.CharC := '08';
        TempEDCCode12839.Value := '08';
        TempEDCCode12839.Encoding := '10001100100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := ')';
        TempEDCCode12839.CharB := ')';
        TempEDCCode12839.CharC := '09';
        TempEDCCode12839.Value := '09';
        TempEDCCode12839.Encoding := '11001001000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '*';
        TempEDCCode12839.CharB := '*';
        TempEDCCode12839.CharC := '10';
        TempEDCCode12839.Value := '10';
        TempEDCCode12839.Encoding := '11001000100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '+';
        TempEDCCode12839.CharB := '+';
        TempEDCCode12839.CharC := '11';
        TempEDCCode12839.Value := '11';
        TempEDCCode12839.Encoding := '11000100100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := ',';
        TempEDCCode12839.CharB := ',';
        TempEDCCode12839.CharC := '12';
        TempEDCCode12839.Value := '12';
        TempEDCCode12839.Encoding := '10110011100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '-';
        TempEDCCode12839.CharB := '-';
        TempEDCCode12839.CharC := '13';
        TempEDCCode12839.Value := '13';
        TempEDCCode12839.Encoding := '10011011100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '.';
        TempEDCCode12839.CharB := '.';
        TempEDCCode12839.CharC := '14';
        TempEDCCode12839.Value := '14';
        TempEDCCode12839.Encoding := '10011001110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '/';
        TempEDCCode12839.CharB := '/';
        TempEDCCode12839.CharC := '15';
        TempEDCCode12839.Value := '15';
        TempEDCCode12839.Encoding := '10111001100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '0';
        TempEDCCode12839.CharB := '0';
        TempEDCCode12839.CharC := '16';
        TempEDCCode12839.Value := '16';
        TempEDCCode12839.Encoding := '10011101100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '1';
        TempEDCCode12839.CharB := '1';
        TempEDCCode12839.CharC := '17';
        TempEDCCode12839.Value := '17';
        TempEDCCode12839.Encoding := '10011100110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '2';
        TempEDCCode12839.CharB := '2';
        TempEDCCode12839.CharC := '18';
        TempEDCCode12839.Value := '18';
        TempEDCCode12839.Encoding := '11001110010';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '3';
        TempEDCCode12839.CharB := '3';
        TempEDCCode12839.CharC := '19';
        TempEDCCode12839.Value := '19';
        TempEDCCode12839.Encoding := '11001011100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '4';
        TempEDCCode12839.CharB := '4';
        TempEDCCode12839.CharC := '20';
        TempEDCCode12839.Value := '20';
        TempEDCCode12839.Encoding := '11001001110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '5';
        TempEDCCode12839.CharB := '5';
        TempEDCCode12839.CharC := '21';
        TempEDCCode12839.Value := '21';
        TempEDCCode12839.Encoding := '11011100100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '6';
        TempEDCCode12839.CharB := '6';
        TempEDCCode12839.CharC := '22';
        TempEDCCode12839.Value := '22';
        TempEDCCode12839.Encoding := '11001110100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '7';
        TempEDCCode12839.CharB := '7';
        TempEDCCode12839.CharC := '23';
        TempEDCCode12839.Value := '23';
        TempEDCCode12839.Encoding := '11101101110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '8';
        TempEDCCode12839.CharB := '8';
        TempEDCCode12839.CharC := '24';
        TempEDCCode12839.Value := '24';
        TempEDCCode12839.Encoding := '11101001100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '9';
        TempEDCCode12839.CharB := '9';
        TempEDCCode12839.CharC := '25';
        TempEDCCode12839.Value := '25';
        TempEDCCode12839.Encoding := '11100101100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := ':';
        TempEDCCode12839.CharB := ':';
        TempEDCCode12839.CharC := '26';
        TempEDCCode12839.Value := '26';
        TempEDCCode12839.Encoding := '11100100110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := ';';
        TempEDCCode12839.CharB := ';';
        TempEDCCode12839.CharC := '27';
        TempEDCCode12839.Value := '27';
        TempEDCCode12839.Encoding := '11101100100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '<';
        TempEDCCode12839.CharB := '<';
        TempEDCCode12839.CharC := '28';
        TempEDCCode12839.Value := '28';
        TempEDCCode12839.Encoding := '11100110100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '=';
        TempEDCCode12839.CharB := '=';
        TempEDCCode12839.CharC := '29';
        TempEDCCode12839.Value := '29';
        TempEDCCode12839.Encoding := '11100110010';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '>';
        TempEDCCode12839.CharB := '>';
        TempEDCCode12839.CharC := '30';
        TempEDCCode12839.Value := '30';
        TempEDCCode12839.Encoding := '11011011000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '?';
        TempEDCCode12839.CharB := '?';
        TempEDCCode12839.CharC := '31';
        TempEDCCode12839.Value := '31';
        TempEDCCode12839.Encoding := '11011000110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '@';
        TempEDCCode12839.CharB := '@';
        TempEDCCode12839.CharC := '32';
        TempEDCCode12839.Value := '32';
        TempEDCCode12839.Encoding := '11000110110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'A';
        TempEDCCode12839.CharB := 'A';
        TempEDCCode12839.CharC := '33';
        TempEDCCode12839.Value := '33';
        TempEDCCode12839.Encoding := '10100011000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'B';
        TempEDCCode12839.CharB := 'B';
        TempEDCCode12839.CharC := '34';
        TempEDCCode12839.Value := '34';
        TempEDCCode12839.Encoding := '10001011000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'C';
        TempEDCCode12839.CharB := 'C';
        TempEDCCode12839.CharC := '35';
        TempEDCCode12839.Value := '35';
        TempEDCCode12839.Encoding := '10001000110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'D';
        TempEDCCode12839.CharB := 'D';
        TempEDCCode12839.CharC := '36';
        TempEDCCode12839.Value := '36';
        TempEDCCode12839.Encoding := '10110001000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'E';
        TempEDCCode12839.CharB := 'E';
        TempEDCCode12839.CharC := '37';
        TempEDCCode12839.Value := '37';
        TempEDCCode12839.Encoding := '10001101000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'F';
        TempEDCCode12839.CharB := 'F';
        TempEDCCode12839.CharC := '38';
        TempEDCCode12839.Value := '38';
        TempEDCCode12839.Encoding := '10001100010';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'G';
        TempEDCCode12839.CharB := 'G';
        TempEDCCode12839.CharC := '39';
        TempEDCCode12839.Value := '39';
        TempEDCCode12839.Encoding := '11010001000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'H';
        TempEDCCode12839.CharB := 'H';
        TempEDCCode12839.CharC := '40';
        TempEDCCode12839.Value := '40';
        TempEDCCode12839.Encoding := '11000101000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'I';
        TempEDCCode12839.CharB := 'I';
        TempEDCCode12839.CharC := '41';
        TempEDCCode12839.Value := '41';
        TempEDCCode12839.Encoding := '11000100010';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'J';
        TempEDCCode12839.CharB := 'J';
        TempEDCCode12839.CharC := '42';
        TempEDCCode12839.Value := '42';
        TempEDCCode12839.Encoding := '10110111000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'K';
        TempEDCCode12839.CharB := 'K';
        TempEDCCode12839.CharC := '43';
        TempEDCCode12839.Value := '43';
        TempEDCCode12839.Encoding := '10110001110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'L';
        TempEDCCode12839.CharB := 'L';
        TempEDCCode12839.CharC := '44';
        TempEDCCode12839.Value := '44';
        TempEDCCode12839.Encoding := '10001101110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'M';
        TempEDCCode12839.CharB := 'M';
        TempEDCCode12839.CharC := '45';
        TempEDCCode12839.Value := '45';
        TempEDCCode12839.Encoding := '10111011000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'N';
        TempEDCCode12839.CharB := 'N';
        TempEDCCode12839.CharC := '46';
        TempEDCCode12839.Value := '46';
        TempEDCCode12839.Encoding := '10111000110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'O';
        TempEDCCode12839.CharB := 'O';
        TempEDCCode12839.CharC := '47';
        TempEDCCode12839.Value := '47';
        TempEDCCode12839.Encoding := '10001110110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'P';
        TempEDCCode12839.CharB := 'P';
        TempEDCCode12839.CharC := '48';
        TempEDCCode12839.Value := '48';
        TempEDCCode12839.Encoding := '11101110110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'Q';
        TempEDCCode12839.CharB := 'Q';
        TempEDCCode12839.CharC := '49';
        TempEDCCode12839.Value := '49';
        TempEDCCode12839.Encoding := '11010001110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'R';
        TempEDCCode12839.CharB := 'R';
        TempEDCCode12839.CharC := '50';
        TempEDCCode12839.Value := '50';
        TempEDCCode12839.Encoding := '11000101110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'S';
        TempEDCCode12839.CharB := 'S';
        TempEDCCode12839.CharC := '51';
        TempEDCCode12839.Value := '51';
        TempEDCCode12839.Encoding := '11011101000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'T';
        TempEDCCode12839.CharB := 'T';
        TempEDCCode12839.CharC := '52';
        TempEDCCode12839.Value := '52';
        TempEDCCode12839.Encoding := '11011100010';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'U';
        TempEDCCode12839.CharB := 'U';
        TempEDCCode12839.CharC := '53';
        TempEDCCode12839.Value := '53';
        TempEDCCode12839.Encoding := '11011101110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'V';
        TempEDCCode12839.CharB := 'V';
        TempEDCCode12839.CharC := '54';
        TempEDCCode12839.Value := '54';
        TempEDCCode12839.Encoding := '11101011000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'W';
        TempEDCCode12839.CharB := 'W';
        TempEDCCode12839.CharC := '55';
        TempEDCCode12839.Value := '55';
        TempEDCCode12839.Encoding := '11101000110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'X';
        TempEDCCode12839.CharB := 'X';
        TempEDCCode12839.CharC := '56';
        TempEDCCode12839.Value := '56';
        TempEDCCode12839.Encoding := '11100010110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'Y';
        TempEDCCode12839.CharB := 'Y';
        TempEDCCode12839.CharC := '57';
        TempEDCCode12839.Value := '57';
        TempEDCCode12839.Encoding := '11101101000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'Z';
        TempEDCCode12839.CharB := 'Z';
        TempEDCCode12839.CharC := '58';
        TempEDCCode12839.Value := '58';
        TempEDCCode12839.Encoding := '11101100010';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '[';
        TempEDCCode12839.CharB := '[';
        TempEDCCode12839.CharC := '59';
        TempEDCCode12839.Value := '59';
        TempEDCCode12839.Encoding := '11100011010';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '\';
        TempEDCCode12839.CharB := '\';
        TempEDCCode12839.CharC := '60';
        TempEDCCode12839.Value := '60';
        TempEDCCode12839.Encoding := '11101111010';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := ']';
        TempEDCCode12839.CharB := ']';
        TempEDCCode12839.CharC := '61';
        TempEDCCode12839.Value := '61';
        TempEDCCode12839.Encoding := '11001000010';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '^';
        TempEDCCode12839.CharB := '^';
        TempEDCCode12839.CharC := '62';
        TempEDCCode12839.Value := '62';
        TempEDCCode12839.Encoding := '11110001010';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '_';
        TempEDCCode12839.CharB := '_';
        TempEDCCode12839.CharC := '63';
        TempEDCCode12839.Value := '63';
        TempEDCCode12839.Encoding := '10100110000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'NUL';
        TempEDCCode12839.CharB := '`';
        TempEDCCode12839.CharC := '64';
        TempEDCCode12839.Value := '64';
        TempEDCCode12839.Encoding := '10100001100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'SOH';
        TempEDCCode12839.CharB := 'a';
        TempEDCCode12839.CharC := '65';
        TempEDCCode12839.Value := '65';
        TempEDCCode12839.Encoding := '10010110000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'STX';
        TempEDCCode12839.CharB := 'b';
        TempEDCCode12839.CharC := '66';
        TempEDCCode12839.Value := '66';
        TempEDCCode12839.Encoding := '10010000110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'ETX';
        TempEDCCode12839.CharB := 'c';
        TempEDCCode12839.CharC := '67';
        TempEDCCode12839.Value := '67';
        TempEDCCode12839.Encoding := '10000101100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'EOT';
        TempEDCCode12839.CharB := 'd';
        TempEDCCode12839.CharC := '68';
        TempEDCCode12839.Value := '68';
        TempEDCCode12839.Encoding := '10000100110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'ENQ';
        TempEDCCode12839.CharB := 'e';
        TempEDCCode12839.CharC := '69';
        TempEDCCode12839.Value := '69';
        TempEDCCode12839.Encoding := '10110010000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'ACK';
        TempEDCCode12839.CharB := 'f';
        TempEDCCode12839.CharC := '70';
        TempEDCCode12839.Value := '70';
        TempEDCCode12839.Encoding := '10110000100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'BEL';
        TempEDCCode12839.CharB := 'g';
        TempEDCCode12839.CharC := '71';
        TempEDCCode12839.Value := '71';
        TempEDCCode12839.Encoding := '10011010000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'BS';
        TempEDCCode12839.CharB := 'h';
        TempEDCCode12839.CharC := '72';
        TempEDCCode12839.Value := '72';
        TempEDCCode12839.Encoding := '10011000010';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'HT';
        TempEDCCode12839.CharB := 'i';
        TempEDCCode12839.CharC := '73';
        TempEDCCode12839.Value := '73';
        TempEDCCode12839.Encoding := '10000110100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'LF';
        TempEDCCode12839.CharB := 'j';
        TempEDCCode12839.CharC := '74';
        TempEDCCode12839.Value := '74';
        TempEDCCode12839.Encoding := '10000110010';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'VT';
        TempEDCCode12839.CharB := 'k';
        TempEDCCode12839.CharC := '75';
        TempEDCCode12839.Value := '75';
        TempEDCCode12839.Encoding := '11000010010';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'FF';
        TempEDCCode12839.CharB := 'l';
        TempEDCCode12839.CharC := '76';
        TempEDCCode12839.Value := '76';
        TempEDCCode12839.Encoding := '11001010000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'CR';
        TempEDCCode12839.CharB := 'm';
        TempEDCCode12839.CharC := '77';
        TempEDCCode12839.Value := '77';
        TempEDCCode12839.Encoding := '11110111010';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'SO';
        TempEDCCode12839.CharB := 'n';
        TempEDCCode12839.CharC := '78';
        TempEDCCode12839.Value := '78';
        TempEDCCode12839.Encoding := '11000010100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'SI';
        TempEDCCode12839.CharB := 'o';
        TempEDCCode12839.CharC := '79';
        TempEDCCode12839.Value := '79';
        TempEDCCode12839.Encoding := '10001111010';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'DLE';
        TempEDCCode12839.CharB := 'p';
        TempEDCCode12839.CharC := '80';
        TempEDCCode12839.Value := '80';
        TempEDCCode12839.Encoding := '10100111100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'DC1';
        TempEDCCode12839.CharB := 'q';
        TempEDCCode12839.CharC := '81';
        TempEDCCode12839.Value := '81';
        TempEDCCode12839.Encoding := '10010111100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'DC2';
        TempEDCCode12839.CharB := 'r';
        TempEDCCode12839.CharC := '82';
        TempEDCCode12839.Value := '82';
        TempEDCCode12839.Encoding := '10010011110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'DC3';
        TempEDCCode12839.CharB := 's';
        TempEDCCode12839.CharC := '83';
        TempEDCCode12839.Value := '83';
        TempEDCCode12839.Encoding := '10111100100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'DC4';
        TempEDCCode12839.CharB := 't';
        TempEDCCode12839.CharC := '84';
        TempEDCCode12839.Value := '84';
        TempEDCCode12839.Encoding := '10011110100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'NAK';
        TempEDCCode12839.CharB := 'u';
        TempEDCCode12839.CharC := '85';
        TempEDCCode12839.Value := '85';
        TempEDCCode12839.Encoding := '10011110010';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'SYN';
        TempEDCCode12839.CharB := 'v';
        TempEDCCode12839.CharC := '86';
        TempEDCCode12839.Value := '86';
        TempEDCCode12839.Encoding := '11110100100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'ETB';
        TempEDCCode12839.CharB := 'w';
        TempEDCCode12839.CharC := '87';
        TempEDCCode12839.Value := '87';
        TempEDCCode12839.Encoding := '11110010100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'CAN';
        TempEDCCode12839.CharB := 'x';
        TempEDCCode12839.CharC := '88';
        TempEDCCode12839.Value := '88';
        TempEDCCode12839.Encoding := '11110010010';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'EM';
        TempEDCCode12839.CharB := 'y';
        TempEDCCode12839.CharC := '89';
        TempEDCCode12839.Value := '89';
        TempEDCCode12839.Encoding := '11011011110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'SUB';
        TempEDCCode12839.CharB := 'z';
        TempEDCCode12839.CharC := '90';
        TempEDCCode12839.Value := '90';
        TempEDCCode12839.Encoding := '11011110110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'ESC';
        TempEDCCode12839.CharB := '{';
        TempEDCCode12839.CharC := '91';
        TempEDCCode12839.Value := '91';
        TempEDCCode12839.Encoding := '11110110110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'FS';
        TempEDCCode12839.CharB := '|';
        TempEDCCode12839.CharC := '92';
        TempEDCCode12839.Value := '92';
        TempEDCCode12839.Encoding := '10101111000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'GS';
        TempEDCCode12839.CharB := '}';
        TempEDCCode12839.CharC := '93';
        TempEDCCode12839.Value := '93';
        TempEDCCode12839.Encoding := '10100011110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'RS';
        TempEDCCode12839.CharB := '~';
        TempEDCCode12839.CharC := '94';
        TempEDCCode12839.Value := '94';
        TempEDCCode12839.Encoding := '10001011110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'US';
        TempEDCCode12839.CharB := 'DEL';
        TempEDCCode12839.CharC := '95';
        TempEDCCode12839.Value := '95';
        TempEDCCode12839.Encoding := '10111101000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'FNC3';
        TempEDCCode12839.CharB := 'FNC3';
        TempEDCCode12839.CharC := '96';
        TempEDCCode12839.Value := '96';
        TempEDCCode12839.Encoding := '10111100010';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'FNC2';
        TempEDCCode12839.CharB := 'FNC2';
        TempEDCCode12839.CharC := '97';
        TempEDCCode12839.Value := '97';
        TempEDCCode12839.Encoding := '11110101000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'SHIFT';
        TempEDCCode12839.CharB := 'SHIFT';
        TempEDCCode12839.CharC := '98';
        TempEDCCode12839.Value := '98';
        TempEDCCode12839.Encoding := '11110100010';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'CODEC';
        TempEDCCode12839.CharB := 'CODEC';
        TempEDCCode12839.CharC := '99';
        TempEDCCode12839.Value := '99';
        TempEDCCode12839.Encoding := '10111011110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'CODEB';
        TempEDCCode12839.CharB := 'FNC4';
        TempEDCCode12839.CharC := 'CODEB';
        TempEDCCode12839.Value := '100';
        TempEDCCode12839.Encoding := '10111101110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'FNC4';
        TempEDCCode12839.CharB := 'CODEA';
        TempEDCCode12839.CharC := 'CODEA';
        TempEDCCode12839.Value := '101';
        TempEDCCode12839.Encoding := '11101011110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'FNC1';
        TempEDCCode12839.CharB := 'FNC1';
        TempEDCCode12839.CharC := 'FNC1';
        TempEDCCode12839.Value := '102';
        TempEDCCode12839.Encoding := '11110101110';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'STARTA';
        TempEDCCode12839.CharB := 'STARTA';
        TempEDCCode12839.CharC := 'STARTA';
        TempEDCCode12839.Value := '103';
        TempEDCCode12839.Encoding := '11010000100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'STARTB';
        TempEDCCode12839.CharB := 'STARTB';
        TempEDCCode12839.CharC := 'STARTB';
        TempEDCCode12839.Value := '104';
        TempEDCCode12839.Encoding := '11010010000';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'STARTC';
        TempEDCCode12839.CharB := 'STARTC';
        TempEDCCode12839.CharC := 'STARTC';
        TempEDCCode12839.Value := '105';
        TempEDCCode12839.Encoding := '11010011100';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'STOP';
        TempEDCCode12839.CharB := 'STOP';
        TempEDCCode12839.CharC := 'STOP';
        TempEDCCode12839.Value := '';
        TempEDCCode12839.Encoding := '11000111010';
        TempEDCCode12839.INSERT();
    end;

    local procedure InitCode39(var TempEDCCode12839: Record "SLK Code 128/39" temporary)
    begin
        //THIS IS NOT THE EXTENDED CODE 39 ENCODING TABLE!
        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '0';
        TempEDCCode12839.Value := '0';
        TempEDCCode12839.Encoding := '101001101101';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '1';
        TempEDCCode12839.Value := '1';
        TempEDCCode12839.Encoding := '110100101011';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '2';
        TempEDCCode12839.Value := '2';
        TempEDCCode12839.Encoding := '101100101011';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '3';
        TempEDCCode12839.Value := '3';
        TempEDCCode12839.Encoding := '110110010101';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '4';
        TempEDCCode12839.Value := '4';
        TempEDCCode12839.Encoding := '101001101011';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '5';
        TempEDCCode12839.Value := '5';
        TempEDCCode12839.Encoding := '110100110101';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '6';
        TempEDCCode12839.Value := '6';
        TempEDCCode12839.Encoding := '101100110101';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '7';
        TempEDCCode12839.Value := '7';
        TempEDCCode12839.Encoding := '101001011011';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '8';
        TempEDCCode12839.Value := '8';
        TempEDCCode12839.Encoding := '110100101101';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '9';
        TempEDCCode12839.Value := '9';
        TempEDCCode12839.Encoding := '101100101101';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'A';
        TempEDCCode12839.Value := '10';
        TempEDCCode12839.Encoding := '110101001011';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'B';
        TempEDCCode12839.Value := '11';
        TempEDCCode12839.Encoding := '101101001011';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'C';
        TempEDCCode12839.Value := '12';
        TempEDCCode12839.Encoding := '110110100101';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'D';
        TempEDCCode12839.Value := '13';
        TempEDCCode12839.Encoding := '101011001011';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'E';
        TempEDCCode12839.Value := '14';
        TempEDCCode12839.Encoding := '110101100101';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'F';
        TempEDCCode12839.Value := '15';
        TempEDCCode12839.Encoding := '101101100101';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'G';
        TempEDCCode12839.Value := '16';
        TempEDCCode12839.Encoding := '101010011011';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'H';
        TempEDCCode12839.Value := '17';
        TempEDCCode12839.Encoding := '110101001101';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'I';
        TempEDCCode12839.Value := '18';
        TempEDCCode12839.Encoding := '101101001101';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'J';
        TempEDCCode12839.Value := '19';
        TempEDCCode12839.Encoding := '101011001101';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'K';
        TempEDCCode12839.Value := '20';
        TempEDCCode12839.Encoding := '110101010011';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'L';
        TempEDCCode12839.Value := '21';
        TempEDCCode12839.Encoding := '101101010011';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'M';
        TempEDCCode12839.Value := '22';
        TempEDCCode12839.Encoding := '110110101001';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'N';
        TempEDCCode12839.Value := '23';
        TempEDCCode12839.Encoding := '101011010011';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'O';
        TempEDCCode12839.Value := '24';
        TempEDCCode12839.Encoding := '110101101001';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'P';
        TempEDCCode12839.Value := '25';
        TempEDCCode12839.Encoding := '101101101001';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'Q';
        TempEDCCode12839.Value := '26';
        TempEDCCode12839.Encoding := '101010110011';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'R';
        TempEDCCode12839.Value := '27';
        TempEDCCode12839.Encoding := '110101011001';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'S';
        TempEDCCode12839.Value := '28';
        TempEDCCode12839.Encoding := '101101011001';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'T';
        TempEDCCode12839.Value := '29';
        TempEDCCode12839.Encoding := '101011011001';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'U';
        TempEDCCode12839.Value := '30';
        TempEDCCode12839.Encoding := '110010101011';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'V';
        TempEDCCode12839.Value := '31';
        TempEDCCode12839.Encoding := '100110101011';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'W';
        TempEDCCode12839.Value := '32';
        TempEDCCode12839.Encoding := '110011010101';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'X';
        TempEDCCode12839.Value := '33';
        TempEDCCode12839.Encoding := '100101101011';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'Y';
        TempEDCCode12839.Value := '34';
        TempEDCCode12839.Encoding := '110010110101';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := 'Z';
        TempEDCCode12839.Value := '35';
        TempEDCCode12839.Encoding := '100110110101';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '-';
        TempEDCCode12839.Value := '36';
        TempEDCCode12839.Encoding := '100101011011';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '.';
        TempEDCCode12839.Value := '37';
        TempEDCCode12839.Encoding := '110010101101';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := ' ';
        TempEDCCode12839.Value := '38';
        TempEDCCode12839.Encoding := '100110101101';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '$';
        TempEDCCode12839.Value := '39';
        TempEDCCode12839.Encoding := '100100100101';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '/';
        TempEDCCode12839.Value := '40';
        TempEDCCode12839.Encoding := '100100101001';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '+';
        TempEDCCode12839.Value := '41';
        TempEDCCode12839.Encoding := '100101001001';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '%';
        TempEDCCode12839.Value := '42';
        TempEDCCode12839.Encoding := '101001001001';
        TempEDCCode12839.INSERT();

        TempEDCCode12839.INIT();
        TempEDCCode12839.CharA := '*';
        TempEDCCode12839.Value := '';
        TempEDCCode12839.Encoding := '100101101101';
        TempEDCCode12839.INSERT();
    end;


    procedure EncodeCode128128(pcodBarcode: Code[1024]; pintSize: Integer; pblnVertical: Boolean; var precTmpTempBlob: Codeunit "Temp Blob")
    var
        TempEDCCode12839: Record "SLK Code 128/39" temporary;
        lintCount1: Integer;
        lcharCurrentCharSet: Char;
        lintWeightSum: Integer;
        lintCount2: Integer;
        lintConvInt: Integer;
        ltxtTerminationBar: Text[2];
        lintCheckDigit: Integer;
        lintConvInt1: Integer;
        lintConvInt2: Integer;
        lblnnumber: Boolean;
        lintLines: Integer;
        lintBars: Integer;
        loutBmpHeaderOutStream: OutStream;
    begin
        CLEAR(bxtBarcodeBinary);
        CLEAR(precTmpTempBlob);
        CLEAR(TempEDCCode12839);
        TempEDCCode12839.DeleteAll();
        CLEAR(lcharCurrentCharSet);
        ltxtTerminationBar := '11';

        IF NOT (pintSize IN [1, 2, 3, 4, 5]) THEN
            ERROR(ErrorSizeLbl);

        InitCode128(TempEDCCode12839);

        FOR lintCount1 := 1 TO STRLEN(pcodBarcode) DO BEGIN
            lintCount2 += 1;
            lblnnumber := FALSE;
            TempEDCCode12839.Reset();

            IF EVALUATE(lintConvInt1, FORMAT(pcodBarcode[lintCount1])) THEN
                lblnnumber := EVALUATE(lintConvInt2, FORMAT(pcodBarcode[lintCount1 + 1]));

            //A '.' IS EVALUATED AS A 0, EXTRA CHECK NEEDED
            IF FORMAT(pcodBarcode[lintCount1]) = '.' THEN
                lblnnumber := FALSE;

            IF FORMAT(pcodBarcode[lintCount1 + 1]) = '.' THEN
                lblnnumber := FALSE;

            IF lblnnumber AND (lintConvInt1 IN [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) AND (lintConvInt2 IN [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) THEN BEGIN
                IF (lcharCurrentCharSet <> 'C') THEN BEGIN
                    IF (lintCount1 = 1) THEN BEGIN
                        TempEDCCode12839.GET('STARTC');
                        EVALUATE(lintConvInt, TempEDCCode12839.Value);
                        lintWeightSum := lintConvInt;
                    END ELSE BEGIN
                        TempEDCCode12839.GET('CODEC');
                        EVALUATE(lintConvInt, TempEDCCode12839.Value);
                        lintWeightSum += lintConvInt * lintCount2;
                        lintCount2 += 1;
                    END;

                    bxtBarcodeBinary.ADDTEXT(FORMAT(TempEDCCode12839.Encoding));
                    lcharCurrentCharSet := 'C';
                END;
            END ELSE
                IF lcharCurrentCharSet <> 'A' THEN BEGIN
                    IF (lintCount1 = 1) THEN BEGIN
                        TempEDCCode12839.GET('STARTA');
                        EVALUATE(lintConvInt, TempEDCCode12839.Value);
                        lintWeightSum := lintConvInt;
                    END ELSE BEGIN
                        //CODEA
                        TempEDCCode12839.GET('FNC4');
                        EVALUATE(lintConvInt, TempEDCCode12839.Value);
                        lintWeightSum += lintConvInt * lintCount2;
                        lintCount2 += 1;
                    END;

                    bxtBarcodeBinary.ADDTEXT(FORMAT(TempEDCCode12839.Encoding));
                    lcharCurrentCharSet := 'A';
                END;

            CASE lcharCurrentCharSet OF
                'A':
                    BEGIN
                        TempEDCCode12839.GET(FORMAT(pcodBarcode[lintCount1]));

                        EVALUATE(lintConvInt, TempEDCCode12839.Value);

                        lintWeightSum += lintConvInt * lintCount2;
                        bxtBarcodeBinary.ADDTEXT(FORMAT(TempEDCCode12839.Encoding));
                    END;
                'C':
                    BEGIN
                        TempEDCCode12839.Reset();
                        TempEDCCode12839.SETCURRENTKEY(Value);
                        TempEDCCode12839.SetRange(Value, (FORMAT(pcodBarcode[lintCount1]) + FORMAT(pcodBarcode[lintCount1 + 1])));
                        TempEDCCode12839.FINDFIRST();

                        EVALUATE(lintConvInt, TempEDCCode12839.Value);
                        lintWeightSum += lintConvInt * lintCount2;

                        bxtBarcodeBinary.ADDTEXT(FORMAT(TempEDCCode12839.Encoding));
                        lintCount1 += 1;
                    END;
            END;
        END;

        lintCheckDigit := lintWeightSum MOD 103;

        //ADD CHECK DIGIT
        TempEDCCode12839.Reset();
        TempEDCCode12839.SETCURRENTKEY(Value);

        IF lintCheckDigit <= 9 THEN
            TempEDCCode12839.SetRange(Value, '0' + FORMAT(lintCheckDigit))
        ELSE
            TempEDCCode12839.SetRange(Value, FORMAT(lintCheckDigit));

        TempEDCCode12839.FINDFIRST();
        bxtBarcodeBinary.ADDTEXT(FORMAT(TempEDCCode12839.Encoding));

        //ADD STOP CHARACTER
        TempEDCCode12839.GET('STOP');
        bxtBarcodeBinary.ADDTEXT(FORMAT(TempEDCCode12839.Encoding));

        //ADD TERMINATION BAR
        bxtBarcodeBinary.ADDTEXT(ltxtTerminationBar);

        lintBars := bxtBarcodeBinary.LENGTH;
        lintLines := ROUND(lintBars * 0.25, 1, '>');

        precTmpTempBlob.CREATEOUTSTREAM(loutBmpHeaderOutStream);

        //WRITING HEADER
        CreateBMPHeader(loutBmpHeaderOutStream, lintBars, lintLines, pintSize, pblnVertical);

        //WRITE BARCODE DETAIL
        CreateBarcodeDetail(lintLines, pintSize, pblnVertical, loutBmpHeaderOutStream);
    end;

    var
        bxtBarcodeBinary: BigText;
        ErrorSizeLbl: Label 'Valid values for the barcode size are 1, 2, 3, 4 & 5';
        ErrorLengthLbl: Label 'Value to encode should be %1 digits.', Comment = '%1 Integer';
        ErrrorNumberLbl: Label 'Only numbers allowed.';
}
