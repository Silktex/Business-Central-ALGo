codeunit 50020 "QR Code Management"
{
    TableNo = "Sales Header";

    trigger OnRun()
    var
        CompanyInfo: Record Company;
        SalesHeader: Record "Sales Header";
        TempBlob: Codeunit "Temp Blob";
        QRCodeInput: Text[1024];
        QRCodeFileName: Text[1024];
        Cust: Record Customer;
    begin
        // Save a QR code image into a file in a temporary folder

        SalesHeader := Rec;

        // Get Customer Information
        Cust.GET(SalesHeader."Sell-to Customer No.");
        Cust.CALCFIELDS("Balance (LCY)");

        // Assign QR Code Information for scanning
        QRCodeInput := CreateQRCodeInput(Cust.Name, Cust."Phone No.", Cust."E-Mail", Cust."Balance (LCY)");
        QRCodeFileName := GetQRCode(QRCodeInput);
        QRCodeFileName := MoveToMagicPath(QRCodeFileName); // To avoid confirmation dialogue on RTC

        // Load the image from file into the BLOB field
        CLEAR(TempBlob);
        ThreeTierMgt.BLOBImport(TempBlob, QRCodeFileName);
        IF TempBlob.HASVALUE THEN BEGIN
            //    SalesHeader."QR Code" := TempBlob.Blob;
            SalesHeader.MODIFY;
        END;

        // Erase the temporary file
        // IF NOT ISSERVICETIER THEN
        //     IF EXISTS(QRCodeFileName) THEN
        //         ERASE(QRCodeFileName);

        //Rec := SalesHeader;
    end;

    var
        ThreeTierMgt: Codeunit "File Management";


    procedure CreateQRCodeInput(Name: Text[80]; PhoneNo: Text[80]; EMail: Text[80]; Balance: Decimal) QRCodeInput: Text[1024]
    begin
        QRCodeInput :=
          'Invoice No.:' +
          'Name:' + Name + ';' +
          'Tel:' + PhoneNo + ';' +
          'EMAIL:' + EMail + ';' +
          'Balance:' + FORMAT(Balance) + ';';
    end;


    procedure GetQRCode(QRCodeInput: Text[1024]) QRCodeFileName: Text[1024]
    var
    // [RunOnClient]
    // IBarCodeProvider: DotNet IBarcodeProvider;
    begin
        // GetBarCodeProvider(IBarCodeProvider);
        // QRCodeFileName := IBarCodeProvider.GetBarcode(QRCodeInput);
    end;


    // procedure GetBarCodeProvider(var IBarCodeProvider: DotNet IBarcodeProvider)
    // var
    // // [RunOnClient]
    // // QRCodeProvider: DotNet QRCodeProvider;
    // begin
    //     // QRCodeProvider := QRCodeProvider.QRCodeProvider;
    //     // IBarCodeProvider := QRCodeProvider;
    // end;


    procedure MoveToMagicPath(SourceFileName: Text[1024]) DestinationFileName: Text[1024]
    var
    //FileSystemObject: Automation;
    begin
        // User Temp Path

        // DestinationFileName := ThreeTierMgt.ClientTempFileName('');
        // IF ISCLEAR(FileSystemObject) THEN
        //     CREATE(FileSystemObject, TRUE, TRUE);
        // FileSystemObject.MoveFile(SourceFileName, DestinationFileName);
    end;


    procedure QROrder(SalesHeader: Record "Sales Header")
    var
        TempBlob: Codeunit "Temp Blob";
        QRCodeInput: Text[1024];
        QRCodeFileName: Text[1024];
        Cust: Record Customer;
        instream: InStream;
    begin
        Cust.GET(SalesHeader."Sell-to Customer No.");
        Cust.CALCFIELDS("Balance (LCY)");
        QRCodeInput := CreateQRCodeInputNew(SalesHeader."No.");
        QRCodeFileName := GetQRCode(QRCodeInput);
        QRCodeFileName := MoveToMagicPath(QRCodeFileName);

        CLEAR(TempBlob);
        ThreeTierMgt.BLOBImport(TempBlob, QRCodeFileName);
        IF TempBlob.HASVALUE THEN BEGIN
            TempBlob.CreateInStream(instream);
            SalesHeader."QR Code".CreateInStream(instream);
            SalesHeader.MODIFY;
        END;

        // IF NOT ISSERVICETIER THEN
        //     IF EXISTS(QRCodeFileName) THEN
        //         ERASE(QRCodeFileName);
    end;


    procedure CreateQRCodeInputNew(OrderNo: Code[20]) QRCodeInput: Text[1024]
    begin
        QRCodeInput := OrderNo;
    end;

    var
    //bar :Interface ba
}

