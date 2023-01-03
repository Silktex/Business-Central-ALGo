report 50066 "Item Label Print RE"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50066_Report_ItemLabelPrintRE.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Reservation Entry"; "Reservation Entry")
        {
            DataItemTableView = SORTING(Description) ORDER(Ascending);
            RequestFilterFields = "Item No.", "Location Code", "Lot No.";
            column(ItemNo_ItemLedgerEntry; "Reservation Entry"."Item No.")
            {
            }
            column(LotNo_ItemLedgerEntry; "Reservation Entry"."Lot No.")
            {
            }
            column(Quantity_ItemLedgerEntry; "Reservation Entry".Quantity)
            {
            }
            column(Desc; Desc)
            {
            }
            column(QR_Code_ILE; "Reservation Entry"."QR Code")
            {
            }
            column(UOM; UOM)
            {
            }
            column(BINCode; BINCode)
            {
            }

            trigger OnAfterGetRecord()
            begin
                // << QR
                //QROrder("Reservation Entry");
                "Reservation Entry".CALCFIELDS("QR Code");
                // >> QR

                IF recItem.GET("Reservation Entry"."Item No.") THEN BEGIN
                    Desc := recItem.Description;
                    UOM := recItem."Base Unit of Measure";
                END;

                BINCode := '';
                BinContent.RESET;
                BinContent.SETFILTER("Location Code", "Location Code");
                BinContent.SETRANGE("Item No.", "Item No.");
                BinContent.SETFILTER("Lot No. Filter", "Lot No.");
                IF BinContent.FINDSET THEN BEGIN
                    BINCode := BinContent."Bin Code";
                END;
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
        lblLot = 'LOT#';
        lblItem = 'ITEM#';
        lblSKU = 'SKU#';
        lblWidth = 'WIDTH';
        lblLENGTH = 'LENGTH';
        lblRcptDT = 'RCPT DT';
    }

    var
        recItem: Record Item;
        Desc: Text[50];
        ThreeTierMgt: Codeunit "File Management";
        UOM: Text;
        BinContent: Record "Bin Content";
        BINCode: Code[20];


    procedure CreateQRCodeInput(LotNo: Text[80]) QRCodeInput: Text[1024]
    begin
        QRCodeInput :=
          'Lot No.:' + LotNo + ';';
    end;


    // procedure GetQRCode(QRCodeInput: Text[1024]) QRCodeFileName: Text[1024]
    // var
    //     [RunOnClient]
    //     IBarCodeProvider: DotNet IBarcodeProvider;
    // begin
    //     GetBarCodeProvider(IBarCodeProvider);
    //     QRCodeFileName := IBarCodeProvider.GetBarcode(QRCodeInput);
    // end;


    // procedure GetBarCodeProvider(var IBarCodeProvider: DotNet IBarcodeProvider)
    // var
    //     [RunOnClient]
    //     QRCodeProvider: DotNet QRCodeProvider;
    // begin
    //     QRCodeProvider := QRCodeProvider.QRCodeProvider;
    //     IBarCodeProvider := QRCodeProvider;
    // end;


    // procedure MoveToMagicPath(SourceFileName: Text[1024]) DestinationFileName: Text[1024]
    // var
    //     FileSystemObject: Automation;
    // begin
    //     DestinationFileName := ThreeTierMgt.ClientTempFileName('');
    //     IF ISCLEAR(FileSystemObject) THEN
    //         CREATE(FileSystemObject, TRUE, TRUE);
    //     FileSystemObject.MoveFile(SourceFileName, DestinationFileName);
    // end;


    // procedure QROrder(ILE: Record "Reservation Entry")
    // var
    //     TempBlob: Record TempBlob;
    //     QRCodeInput: Text[1024];
    //     QRCodeFileName: Text[1024];
    //     Cust: Record Customer;
    // begin
    //     QRCodeInput := CreateQRCodeInputNew(ILE."Lot No.");
    //     QRCodeFileName := GetQRCode(QRCodeInput);
    //     QRCodeFileName := MoveToMagicPath(QRCodeFileName);

    //     CLEAR(TempBlob);
    //     ThreeTierMgt.BLOBImport(TempBlob, QRCodeFileName);
    //     IF TempBlob.Blob.HASVALUE THEN BEGIN
    //         ILE."QR Code" := TempBlob.Blob;
    //         ILE.MODIFY;
    //     END;

    //     IF NOT ISSERVICETIER THEN
    //         IF EXISTS(QRCodeFileName) THEN
    //             ERASE(QRCodeFileName);
    // end;


    procedure CreateQRCodeInputNew(OrderNo: Code[20]) QRCodeInput: Text[1024]
    begin
        QRCodeInput := OrderNo;
    end;
}

