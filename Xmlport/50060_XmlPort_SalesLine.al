xmlport 50060 "Sales Line"
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
            tableelement("Sales Line"; "Sales Line")
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'SalesLine';
                UseTemporary = true;
                fieldattribute(DocumentType; "Sales Line"."Document Type")
                {
                }
                fieldattribute(DocumentNo; "Sales Line"."Document No.")
                {
                }
                fieldattribute(LineNo; "Sales Line"."Line No.")
                {
                }
                fieldattribute(Type; "Sales Line".Type)
                {
                }
                fieldattribute(ItemNo; "Sales Line"."No.")
                {
                }
                fieldattribute(Quantity; "Sales Line".Quantity)
                {
                }
                fieldattribute(UnitPrice; "Sales Line"."Unit Price")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    /*IF recCust.GET(Customer."No.") THEN BEGIN
                       recCust.VALIDATE("Customer Posting Group",Customer."Customer Posting Group");
                       recCust.MODIFY(FALSE);
                      END;
                     */
                    recSalesLine.INIT;
                    recSalesLine.VALIDATE("Document Type", "Sales Line"."Document Type"::Order);
                    recSalesLine.VALIDATE("Document No.", "Sales Line"."Document No.");
                    recSalesLine.VALIDATE("Line No.", "Sales Line"."Line No.");
                    recSalesLine.VALIDATE(Type, "Sales Line".Type);
                    recSalesLine.VALIDATE("No.", "Sales Line"."No.");
                    recSalesLine.VALIDATE(Quantity, "Sales Line".Quantity);
                    recSalesLine.VALIDATE("Unit Price", "Sales Line"."Unit Price");
                    IF NOT recSalesLine.INSERT THEN
                        recSalesLine.MODIFY;

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
        recSalesLine: Record "Sales Line";

    //[Scope('Internal')]
    procedure CreateReservEntry(ItemJL: Record "Item Journal Line")
    var
        REntry: Record "Reservation Entry";
        ENo: Integer;
    begin
    end;
}

