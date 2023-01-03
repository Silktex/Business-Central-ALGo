report 50222 "LOT Info Barcode"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50222_Report_LOTInfoBarcode.rdlc';
    Caption = 'Open SO Report';
    Description = 'Open SO Report';

    dataset
    {
        dataitem("Item wise Lot No. Information"; "Item wise Lot No. Information")
        {
            RequestFilterHeading = 'Sales Header';
            column(Item_No; "Item wise Lot No. Information"."Item No.")
            {
            }
            column(Lot_No; "Item wise Lot No. Information"."Lot No.")
            {
            }
            column(BarcodeText; BarcodeText)
            {
            }

            trigger OnAfterGetRecord()
            begin
                BarcodeText := '';
                g_barcodeItem := "Item wise Lot No. Information"."Lot No.";
                BarcodeText := CreateCode128Font(g_barcodeItem);
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
        SO = 'Sales Order';
        OrdDate = 'Order Date';
        ShipDate = 'Ship Date';
        CustName = 'Customer Name';
        ItemCode = 'Item Code';
        OrderQty = 'Ordered (Qty)';
        Balance = 'Balance';
        OnHand = 'Inventory';
        POQty = 'On PO (Qty.)';
        Div = 'Division';
        CustPoNo = 'Cust. PO No.';
        ShipVia = 'Ship Via';
        Whse = 'Whse';
        ItmDescrtxt = 'Description';
    }

    var
        recItem: Record Item;
        TotalInv: Decimal;
        POQuantity: Decimal;
        SOQuantity: Decimal;
        SOQuantityRem: Decimal;
        Divi: Text[50];
        Detail: Boolean;
        Total: Boolean;
        Both: Boolean;
        itemDesc: Text[100];
        Explocation: Code[50];
        ExpShortPcs: Boolean;
        CompInfo: Record "Company Information";
        g_barcodeItem: Text[50];
        BarcodeText: Text;


    procedure CreateCode128Font(CodeString: Text[250]) BCodeString: Text[250]
    var
        Offset: Integer;
        HighAscii: Integer;
        Total: Integer;
        iCounter: Integer;
        Holder: Integer;
        Check: Integer;
        Character: Char;
        ASCIIValue: Integer;
        CheckDigit: Integer;
    begin
        //CAP4.68/12.05.2017/BEGIN
        CLEAR(Offset);
        CLEAR(HighAscii);
        CLEAR(Total);
        CLEAR(iCounter);
        CLEAR(Holder);
        CLEAR(Check);
        CLEAR(Character);
        CLEAR(ASCIIValue);
        CLEAR(CheckDigit);

        Offset := 32;
        HighAscii := 66;
        BCodeString[1] := 353;
        Total := 104;

        FOR iCounter := 1 TO STRLEN(CodeString) DO BEGIN
            Character := CodeString[iCounter];
            ASCIIValue := Character;
            CheckDigit := ((ASCIIValue - Offset) * (iCounter));
            Total += CheckDigit;
            BCodeString[iCounter + 1] := ASCIIValue;
        END;

        Check := Total MOD 103;
        Holder := 0;

        IF (Check + Offset >= 127) THEN BEGIN
            Holder := Check + Offset + HighAscii;
            CASE Check OF
                95:
                    Holder := 8216;
                96:
                    Holder := 8217;
                97:
                    Holder := 8220;
                98:
                    Holder := 8221;
                99:
                    Holder := 8226;
                100:
                    Holder := 8211;
                101:
                    Holder := 8212;
                102:
                    Holder := 732;
            END;
        END ELSE
            Holder := Check + Offset;

        BCodeString[STRLEN(BCodeString) + 1] := Holder;
        Holder := 106 + Offset + HighAscii;
        BCodeString[STRLEN(BCodeString) + 1] := 339;
        CLEAR(iCounter);
        FOR iCounter := 1 TO STRLEN(BCodeString) DO
            IF BCodeString[iCounter] = 32 THEN
                BCodeString[iCounter] := 8364;
        EXIT(BCodeString);
        //CAP4.68/12.05.2017/END
    end;
}

