xmlport 50062 "Purchase Line"
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
            tableelement("Purchase Line"; "Purchase Line")
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'PurchLine';
                UseTemporary = true;
                fieldattribute(DocumentType; "Purchase Line"."Document Type")
                {
                }
                fieldattribute(DocumentNo; "Purchase Line"."Document No.")
                {
                }
                fieldattribute(LineNo; "Purchase Line"."Line No.")
                {
                }
                fieldattribute(Type; "Purchase Line".Type)
                {
                }
                fieldattribute(ItemNo; "Purchase Line"."No.")
                {
                }
                fieldattribute(Quantity; "Purchase Line".Quantity)
                {
                }
                fieldattribute(UnitPrice; "Purchase Line"."Direct Unit Cost")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    /*IF recCust.GET(Customer."No.") THEN BEGIN
                       recCust.VALIDATE("Customer Posting Group",Customer."Customer Posting Group");
                       recCust.MODIFY(FALSE);
                      END;
                     */
                    recPurchLine.INIT;
                    recPurchLine.VALIDATE("Document Type", "Purchase Line"."Document Type"::Order);
                    recPurchLine.VALIDATE("Document No.", "Purchase Line"."Document No.");
                    recPurchLine.VALIDATE("Line No.", "Purchase Line"."Line No.");
                    recPurchLine.VALIDATE(Type, "Purchase Line".Type);
                    recPurchLine.VALIDATE("No.", "Purchase Line"."No.");
                    recPurchLine.VALIDATE(Quantity, "Purchase Line".Quantity);
                    recPurchLine.VALIDATE("Direct Unit Cost", "Purchase Line"."Direct Unit Cost");
                    IF NOT recPurchLine.INSERT THEN
                        recPurchLine.MODIFY;

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
        recPurchLine: Record "Purchase Line";

    //[Scope('Internal')]
    procedure CreateReservEntry(ItemJL: Record "Item Journal Line")
    var
        REntry: Record "Reservation Entry";
        ENo: Integer;
    begin
    end;
}

