xmlport 50070 "Import Item Reclacificaion"
{
    DefaultFieldsValidation = false;
    Format = VariableText;
    Permissions = TableData Customer = rimd;
    TextEncoding = MSDOS;
    TransactionType = Update;

    schema
    {
        textelement(ROOT)
        {
            tableelement("Item Journal Line"; "Item Journal Line")
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'ItemJnl';
                UseTemporary = true;
                fieldattribute(DocNo; "Item Journal Line"."Document No.")
                {
                }
                fieldattribute(PostDate; "Item Journal Line"."Posting Date")
                {
                }
                fieldattribute(ItemNo; "Item Journal Line"."Item No.")
                {
                }
                fieldattribute(ItemName; "Item Journal Line".Description)
                {
                }
                fieldattribute(Loc; "Item Journal Line"."Location Code")
                {
                }
                fieldattribute(Qty; "Item Journal Line".Quantity)
                {
                }
                fieldattribute(UnitAmt; "Item Journal Line"."Unit Amount")
                {
                }
                fieldattribute(LotNo; "Item Journal Line"."Lot No.")
                {
                }
                fieldattribute(SerialNo; "Item Journal Line"."Serial No.")
                {
                }
                fieldattribute(Dim1; "Item Journal Line"."Shortcut Dimension 1 Code")
                {
                }
                fieldattribute(ItemCongi1; "Item Journal Line"."Dylot No.")
                {
                }
                fieldattribute(ItemCongi2; "Item Journal Line"."ETA Date")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    IJ.RESET;
                    IJ.SETRANGE(IJ."Journal Template Name", 'RECLASS');
                    IJ.SETRANGE(IJ."Journal Batch Name", 'DEFAULT');
                    IF IJ.FINDLAST THEN
                        LineNo := IJ."Line No."
                    ELSE
                        LineNo := 0;

                    IJL.INIT;
                    IJL."Journal Template Name" := 'RECLASS';
                    IJL."Journal Batch Name" := 'DEFAULT';
                    IJL."Line No." := LineNo + 10000;
                    IJL."Source Code" := 'RECLASSJNL';
                    IF IJL.INSERT(TRUE) THEN;

                    IJL.VALIDATE(IJL."Posting Date", "Item Journal Line"."Posting Date");
                    IJL.VALIDATE(IJL."Entry Type", IJL."Entry Type"::Transfer);
                    //IJL.VALIDATE(IJL."Document No.","Item Journal Line"."Document No.");
                    IJL.VALIDATE(IJL."Item No.", "Item Journal Line"."Item No.");
                    IJL.VALIDATE(IJL.Description, "Item Journal Line".Description);
                    IJL.VALIDATE("Location Code", "Item Journal Line"."Location Code");
                    IJL.VALIDATE(IJL.Quantity, "Item Journal Line".Quantity);
                    IJL.VALIDATE(IJL."Unit of Measure Code", "Item Journal Line"."Unit of Measure Code");
                    //IJL.VALIDATE(IJL."Applies-to Entry","Item Journal Line"."Applies-to Entry");

                    IJL.MODIFY(TRUE);

                    IF "Item Journal Line"."Lot No." <> '' THEN BEGIN
                        IJL.VALIDATE(IJL."Lot No.", "Item Journal Line"."Lot No.");
                        CreateReservEntry(IJL);
                    END;
                end;
            }
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

    var
        PostDate: Date;
        ItemNo: Code[20];
        Qty: Decimal;
        Loc: Code[10];
        IJL: Record "Item Journal Line";
        LineNo: Integer;
        EType: Integer;
        DocNumber: Code[20];
        SCode: Code[20];
        MRPrice: Decimal;
        Lotno: Code[20];
        UCost: Decimal;
        VendNo: Code[20];
        ReturnFrom: Text[30];
        BinCode: Code[10];
        Vend: Code[20];
        Length: Decimal;
        Serial: Code[20];
        LotDC: Code[20];
        Varnt: Code[20];
        GCode: Code[20];
        IJ: Record "Item Journal Line";
        RE: Record "Reservation Entry";
        ExtDocNo: Code[20];
        JobType: Option " ","Block Printing",Embroidery,Fusing,Swarsky,"Dyeing & Printing",Sampling,Lacing,Calendering,Waterfall,Book,Hanger;
        LinNo: Integer;
        recCust: Record Customer;
        recSalesHeader: Record "Sales Header";
        recSTA: Record "Ship-to Address";


    procedure CreateReservEntry(ItemJL: Record "Item Journal Line")
    var
        REntry: Record "Reservation Entry";
        ENo: Integer;
    begin
        RE.RESET;
        IF RE.FINDLAST THEN
            ENo := RE."Entry No." + 1
        ELSE
            ENo := 1;

        REntry.INIT;
        REntry."Entry No." := ENo;
        REntry.VALIDATE("Item No.", ItemJL."Item No.");
        REntry.VALIDATE("Location Code", ItemJL."Location Code");
        REntry."Reservation Status" := REntry."Reservation Status"::Prospect;
        REntry."Source Type" := DATABASE::"Item Journal Line";
        IF ItemJL."Entry Type".AsInteger() = 2 THEN
            REntry."Source Subtype" := 2;
        IF ItemJL."Entry Type".AsInteger() = 3 THEN
            REntry."Source Subtype" := 3;
        REntry."Source ID" := ItemJL."Journal Template Name";
        REntry."Source Batch Name" := ItemJL."Journal Batch Name";
        REntry."Source Ref. No." := ItemJL."Line No.";
        REntry.VALIDATE(REntry."Qty. per Unit of Measure", ItemJL."Qty. per Unit of Measure");
        REntry.VALIDATE(REntry."Lot No.", ItemJL."Lot No.");
        REntry.VALIDATE(REntry."Serial No.", ItemJL."Serial No.");
        REntry."Created By" := USERID;
        IF ItemJL."Entry Type" = ItemJL."Entry Type"::"Positive Adjmt." THEN BEGIN
            REntry.VALIDATE(REntry.Positive, TRUE);
            REntry.VALIDATE(REntry.Quantity, ItemJL.Quantity);
            REntry."Quantity (Base)" := (ItemJL.Quantity * ItemJL."Qty. per Unit of Measure");
            REntry."Qty. to Handle (Base)" := (ItemJL.Quantity * ItemJL."Qty. per Unit of Measure");
            REntry."Qty. to Invoice (Base)" := (ItemJL.Quantity * ItemJL."Qty. per Unit of Measure");
            REntry.Positive := TRUE;
        END;
        IF ItemJL."Entry Type" = ItemJL."Entry Type"::"Negative Adjmt." THEN BEGIN
            REntry.VALIDATE(REntry.Quantity, -ItemJL.Quantity);
            REntry."Quantity (Base)" := -(ItemJL.Quantity * ItemJL."Qty. per Unit of Measure");
            REntry."Qty. to Handle (Base)" := -(ItemJL.Quantity * ItemJL."Qty. per Unit of Measure");
            REntry."Qty. to Invoice (Base)" := -(ItemJL.Quantity * ItemJL."Qty. per Unit of Measure");
            REntry.Positive := FALSE;
        END;
        REntry.INSERT;
    end;
}

