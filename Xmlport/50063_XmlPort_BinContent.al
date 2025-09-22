xmlport 50063 "Bin Content"
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
            tableelement("Bin Content"; "Bin Content")
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'BinContent';
                UseTemporary = true;
                fieldattribute(L; "Bin Content"."Location Code")
                {
                }
                fieldattribute(B; "Bin Content"."Bin Code")
                {
                }
                fieldattribute(I; "Bin Content"."Item No.")
                {
                }
                fieldattribute(V; "Bin Content"."Variant Code")
                {
                }
                fieldattribute(U; "Bin Content"."Unit of Measure Code")
                {
                }
                fieldattribute(BCT; "Bin Content"."Bin Type Code")
                {
                }
                fieldattribute(Z; "Bin Content"."Zone Code")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    /*
                    recBinContent.INIT;
                    recBinContent.VALIDATE("Location Code","Bin Content"."Location Code") ;
                    recBinContent.VALIDATE("Bin Code","Bin Content"."Bin Code") ;
                    recBinContent.VALIDATE("Item No.","Bin Content"."Item No.") ;
                    recBinContent.VALIDATE("Variant Code","Bin Content"."Variant Code") ;
                    recBinContent.VALIDATE("Unit of Measure Code","Bin Content"."Unit of Measure Code") ;
                    IF NOT recBinContent.INSERT THEN
                       recBinContent.MODIFY;
                    */

                    recBinContent1.RESET;
                    recBinContent1.SETRANGE("Location Code", "Bin Content"."Location Code");
                    recBinContent1.SETRANGE("Bin Code", "Bin Content"."Bin Code");
                    recBinContent1.SETRANGE("Item No.", "Bin Content"."Item No.");
                    recBinContent1.SETRANGE("Variant Code", "Bin Content"."Variant Code");
                    recBinContent1.SETRANGE("Unit of Measure Code", "Bin Content"."Unit of Measure Code");
                    IF recBinContent1.FINDFIRST THEN BEGIN
                        recBinContent1."Bin Type Code" := 'STORAGE';
                        recBinContent1."Zone Code" := 'Pick';
                        recBinContent1.MODIFY;
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
        recBinContent: Record "Bin Content";
        recBinContent1: Record "Bin Content";

    procedure CreateReservEntry(ItemJL: Record "Item Journal Line")
    var
        REntry: Record "Reservation Entry";
        ENo: Integer;
    begin
    end;
}

