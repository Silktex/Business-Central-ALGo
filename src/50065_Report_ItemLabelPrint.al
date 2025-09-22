report 50065 "Item Label Print"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50065_Report_ItemLabelPrint.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            RequestFilterFields = "Item No.", "Posting Date", "Document No.", "Location Code", "Lot No.";
            column(ItemNo_ItemLedgerEntry; "Item Ledger Entry"."Item No.")
            {
            }
            column(LotNo_ItemLedgerEntry; "Item Ledger Entry"."Lot No.")
            {
            }
            column(Quantity_ItemLedgerEntry; "Item Ledger Entry"."Remaining Quantity")
            {
            }
            column(Desc; Desc)
            {
            }
            column(QR_Code_ILE; "Item Ledger Entry"."QR Code")
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
                // QROrder("Item Ledger Entry");
                "Item Ledger Entry".CALCFIELDS("QR Code");
                // >> QR

                IF recItem.GET("Item Ledger Entry"."Item No.") THEN BEGIN
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


    // procedure QROrder(ILE: Record "Item Ledger Entry")
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

