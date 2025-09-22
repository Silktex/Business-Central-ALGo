xmlport 50061 "Purchase Header"
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
            tableelement("Purchase Header"; "Purchase Header")
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'PurchaseHeader';
                UseTemporary = true;
                fieldattribute(DocumentType; "Purchase Header"."Document Type")
                {
                }
                fieldattribute(DocumentNo; "Purchase Header"."No.")
                {
                }
                fieldattribute(VendorNo; "Purchase Header"."Buy-from Vendor No.")
                {
                }
                fieldattribute(LocationCode; "Purchase Header"."Location Code")
                {
                }
                fieldattribute(OrderDate; "Purchase Header"."Order Date")
                {
                }
                fieldattribute(PaymentTerms; "Purchase Header"."Payment Terms Code")
                {
                }
                fieldattribute(PurchaserCode; "Purchase Header"."Purchaser Code")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    /*IF recCust.GET(Customer."No.") THEN BEGIN
                       recCust.VALIDATE("Customer Posting Group",Customer."Customer Posting Group");
                       recCust.MODIFY(FALSE);
                      END;
                     */
                    //recPurchHeader.RESET;
                    recPurchHeader.INIT;
                    recPurchHeader.VALIDATE("Document Type", "Purchase Header"."Document Type");
                    recPurchHeader.VALIDATE("No.", "Purchase Header"."No.");
                    recPurchHeader.VALIDATE("Order Date", "Purchase Header"."Order Date");
                    //recPurchHeader.VALIDATE("Posting Date","Sales Header"."Posting Date");
                    recPurchHeader.VALIDATE("Document Date", "Purchase Header"."Order Date");
                    //recPurchHeader.VALIDATE("Receipt Date","Purchase Header"."Purchase Date");

                    recPurchHeader.VALIDATE("Buy-from Vendor No.", "Purchase Header"."Buy-from Vendor No.");
                    recPurchHeader.VALIDATE("Location Code", "Purchase Header"."Location Code");


                    //recPurchHeader.VALIDATE("Bill-to Customer No.","Sales Header"."Bill-to Customer No.");
                    recPurchHeader.VALIDATE("Payment Terms Code", "Purchase Header"."Payment Terms Code");
                    recPurchHeader.VALIDATE("Purchaser Code", "Purchase Header"."Purchaser Code");
                    IF NOT recPurchHeader.INSERT THEN
                        recPurchHeader.MODIFY;

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
        recPurchHeader: Record "Purchase Header";
        recSTA: Record "Ship-to Address";
}

