pageextension 50260 "Transfer Orders_Ext" extends "Transfer Orders"
{

    actions
    {
        addafter("Re&ceipts")
        {
            action(PrintLabel)
            {
                Caption = 'Print Label';
                Image = NewReceipt;
                Promoted = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    // ReportLabel: Report "Print PHP Label";
                    ILE: Record "Item Ledger Entry" temporary;
                begin
                    ReservationEntry.RESET;
                    ReservationEntry.CALCFIELDS("Item Description");
                    ReservationEntry.SETCURRENTKEY("Item Description");
                    ReservationEntry.ASCENDING();
                    ReservationEntry.SETRANGE("Source Type", 5741);
                    ReservationEntry.SETRANGE("Source ID", Rec."No.");
                    ReservationEntry.SETRANGE(Positive, TRUE);
                    IF ReservationEntry.FINDSET THEN BEGIN
                        REPEAT
                            ReservationEntry.CALCFIELDS("Item Description");
                            PrintLable(ReservationEntry."Item Description", ReservationEntry."Lot No.", ReservationEntry.Quantity);
                        UNTIL ReservationEntry.NEXT = 0;
                        //REPORT.RUN(REPORT::"Item Label Print RE",TRUE,TRUE,ReservationEntry);
                        MESSAGE('Printed Successfully');
                    END;
                end;
            }
        }
        addafter("Reo&pen")
        {
            action(ImportTransferOrder)
            {
                Caption = 'Import Transfer Order';
                Ellipsis = true;
                Image = "Order";
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                ApplicationArea = all;

                trigger OnAction()
                var
                    Selection: Integer;
                begin
                    Selection := STRMENU(Text002, 2);
                    IF Selection = 1 THEN BEGIN
                        ExcelBuff.RESET;
                        ExcelBuff.DELETEALL;
                        CreateExcelBook;
                    END ELSE
                        RepImportSalesOeder.RUN;
                end;
            }
        }
    }
    var
        ReservationEntry: Record "Reservation Entry";
        RepImportSalesOeder: Report "Import Transfer Order XML";
        ExcelBuff: Record "Excel Buffer";
        Text001: Label 'Order Import Format';
        Text002: Label 'Export Format,Import Data';


    procedure CreateExcelBook()
    begin
        MakeExcelDataHeader;
        // ExcelBuff.CreateBook('', Text001);
        ExcelBuff.CreateNewBook(Text001);
        ExcelBuff.WriteSheet(Text001, COMPANYNAME, USERID);
        ExcelBuff.CloseBook;
        ExcelBuff.SetFriendlyFilename(Text001);
        ExcelBuff.OpenExcel;
        //ExcelBuff.GiveUserControl;
    end;

    procedure MakeExcelDataHeader()
    begin
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn('Order No.', FALSE, 'Order No.', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Transfer-from Code', FALSE, 'Transfer-from Code', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Transfer-to Code', FALSE, 'Transfer-to Code', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('In-Transit Code', FALSE, 'In-Transit Code', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Item No.', FALSE, 'Item No.', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Quantity', FALSE, 'Quantity', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Lot No.', FALSE, 'Lot No.', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
    end;


    procedure PrintLable(ItemDescription: Text[50]; LotNo: Code[20]; Qty: Decimal)
    var
        DataText: BigText;
        DataStream: InStream;
        // MemoryStream: DotNet MemoryStream;
        // Bytes: DotNet Array;
        // Convert: DotNet Convert;
        Base64String: Text;
        TempBlob: Codeunit "Temp Blob";
        OStream: OutStream;
        txtSend: Text;
        // ZebraTCPConnection: DotNet TcpConnection;
        // ZebraConnection: DotNet Connection;
        recItem: Record Item;
        PrinterSelection: Record "Printer Selection";
        FileName: Text;
    begin
        //recItem.GET(ItemCode);
        txtSend := ('^XA' +
                   '^MMT' +
                   '^PW477' +
                   '^LL0203' +
                   '^LS0' +
                   '^FO5,10^BX,10,200' +
                   '^FD' + LotNo + '^FS' +
                   '^BCN,50,Y,N,N' +
                   '^FT180,0^A0N,34,33^FH\^FD' + LotNo + '^FS' +
                   '^FT10,180^A0N,34,31^FH\^FD' + ItemDescription + '^FS' +
                   '^FT180,110^A0N,34,33^FH\^FDQty:^FS' +
                   '^FT240,110^A0N,34,33^FH\^FD' + FORMAT(Qty) + ' Yards^FS' +
                   '^XZ');

        TempBlob.CreateOutStream(OStream);
        OStream.WriteText(txtSend);
        Clear(DataText);
        Clear(DataStream);
        TempBlob.CreateInStream(DataStream);
        FileName := ItemDescription + '.txt';
        DownloadFromStream(DataStream, '', '', '', FileName);
        //VR code replace by export text file
        /*
        TempBlob.INIT;
        TempBlob.Blob.CREATEOUTSTREAM(OStream);
        OStream.WRITETEXT(txtSend);
        CLEAR(DataText);
        CLEAR(DataStream);
        TempBlob.Blob.CREATEINSTREAM(DataStream);
        MemoryStream := MemoryStream.MemoryStream();
        COPYSTREAM(MemoryStream, DataStream);
        Base64String := Convert.ToBase64String(MemoryStream.ToArray);
        DataText.ADDTEXT(Base64String);
        //MESSAGE(Base64String);

        PrinterSelection.RESET;
        PrinterSelection.SETRANGE(PrinterSelection."Report ID", 50065);
        IF PrinterSelection.FINDFIRST THEN;

        ZebraConnection := ZebraTCPConnection.TcpConnection(PrinterSelection."Label Printer IP", 9100);
        ZebraConnection.Open();
        Bytes := Convert.FromBase64String(Base64String);
        ZebraConnection.Write(Bytes);
        ZebraConnection.Close();
        */
    end;

}
