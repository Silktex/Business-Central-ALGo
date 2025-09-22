xmlport 50059 "Sales Header"
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
            tableelement("Sales Header"; "Sales Header")
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'SalesHeader';
                UseTemporary = true;
                fieldattribute(DocumentType; "Sales Header"."Document Type")
                {
                }
                fieldattribute(DocumentNo; "Sales Header"."No.")
                {
                }
                fieldattribute(SellToCustomer; "Sales Header"."Sell-to Customer No.")
                {
                }
                fieldattribute(LocationCode; "Sales Header"."Location Code")
                {
                }
                fieldattribute(PostingDate; "Sales Header"."Posting Date")
                {
                }
                fieldattribute(ShipmentDate; "Sales Header"."Shipment Date")
                {
                }
                fieldattribute(BillToCustomer; "Sales Header"."Bill-to Customer No.")
                {
                }
                fieldattribute(ShiptoCode; "Sales Header"."Ship-to Code")
                {
                }
                fieldattribute(OrderDate; "Sales Header"."Order Date")
                {
                }
                fieldattribute(PaymentTerms; "Sales Header"."Payment Terms Code")
                {
                }
                fieldattribute(ShipMethodCode; "Sales Header"."Shipment Method Code")
                {
                }
                fieldattribute(SalesPersonCode; "Sales Header"."Salesperson Code")
                {
                }
                fieldattribute(ExternalDoc; "Sales Header"."External Document No.")
                {
                }
                fieldattribute(PaymentMethod; "Sales Header"."Payment Method Code")
                {
                }
                fieldattribute(ShipAgent; "Sales Header"."Shipping Agent Code")
                {
                }
                fieldattribute(DocumentDate; "Sales Header"."Document Date")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    /*IF recCust.GET(Customer."No.") THEN BEGIN
                       recCust.VALIDATE("Customer Posting Group",Customer."Customer Posting Group");
                       recCust.MODIFY(FALSE);
                      END;
                     */
                    //recSalesHeader.RESET;
                    recSalesHeader.INIT;
                    recSalesHeader.VALIDATE("Document Type", "Sales Header"."Document Type");
                    recSalesHeader.VALIDATE("No.", "Sales Header"."No.");
                    recSalesHeader.VALIDATE("Order Date", "Sales Header"."Order Date");
                    //recSalesHeader.VALIDATE("Posting Date","Sales Header"."Posting Date");
                    recSalesHeader.VALIDATE("Document Date", "Sales Header"."Document Date");
                    recSalesHeader.VALIDATE("Shipment Date", "Sales Header"."Shipment Date");

                    recSalesHeader.VALIDATE("Sell-to Customer No.", "Sales Header"."Sell-to Customer No.");
                    recSalesHeader.VALIDATE("Location Code", "Sales Header"."Location Code");


                    recSalesHeader.VALIDATE("Bill-to Customer No.", "Sales Header"."Bill-to Customer No.");
                    recSTA.RESET;
                    recSTA.SETRANGE(recSTA."Customer No.", "Sales Header"."Sell-to Customer No.");
                    recSTA.SETRANGE(recSTA.Code, "Sales Header"."Ship-to Code");
                    IF recSTA.FIND('-') THEN
                        recSalesHeader.VALIDATE("Ship-to Code", "Sales Header"."Ship-to Code");
                    recSalesHeader.VALIDATE("Payment Terms Code", "Sales Header"."Payment Terms Code");
                    recSalesHeader.VALIDATE("Shipment Method Code", "Sales Header"."Shipment Method Code");
                    recSalesHeader.VALIDATE("Salesperson Code", "Sales Header"."Salesperson Code");
                    recSalesHeader.VALIDATE("External Document No.", "Sales Header"."External Document No.");
                    recSalesHeader.VALIDATE("Payment Method Code", "Sales Header"."Payment Method Code");
                    recSalesHeader.VALIDATE("Shipping Agent Code", "Sales Header"."Shipping Agent Code");
                    IF NOT recSalesHeader.INSERT THEN
                        recSalesHeader.MODIFY;

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
}

