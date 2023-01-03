report 50125 "Sales Order New Ashwini"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50125_Report_SalesOrderNewAshwini.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.");
            RequestFilterFields = "No.", "Sell-to Customer No.";
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(No_SalesHeader; "Sales Header"."No.")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(CopyText; CopyText)
                    {
                    }
                    column(PageText; Text005)
                    {
                    }
                    column(PageNoText; Text006)
                    {
                    }
                    column(OrderText; OrderText)
                    {
                    }
                    column(Name_CompInfo; CompInfo.Name)
                    {
                    }
                    column(Name2_CompInfo; CompInfo."Name 2")
                    {
                    }
                    column(Address_CompInsfo; CompInfo.Address)
                    {
                    }
                    column(Address2_CompInfo; CompInfo."Address 2")
                    {
                    }
                    column(City_CompInfo; CompInfo.City)
                    {
                    }
                    column(PostCode_CompInfo; CompInfo."Post Code")
                    {
                    }
                    column(County_CompInfo; CompInfo.County)
                    {
                    }
                    column(CountryRegionCode_CompInfo; CompInfo."Country/Region Code")
                    {
                    }
                    column(OrderNo_SalesHeader; "Sales Header"."No.")
                    {
                    }
                    column(OrderDate_SalesHeader; "Sales Header"."Order Date")
                    {
                    }
                    column(ExternalDocumentNo_SalesHeader; "Sales Header"."External Document No.")
                    {
                    }
                    column(Name_SalesPurchPerson; SalesPurchPerson.Name)
                    {
                    }
                    column(ShippingAgentCode_SalesHeader; "Sales Header"."Shipping Agent Code")
                    {
                    }
                    column(ShippingAgentServiceCode_SalesHeader; "Sales Header"."Shipping Agent Service Code" + ' ' + AccNo)
                    {
                    }
                    column(RequestedDeliveryDate_SalesHeader; "Sales Header"."Requested Delivery Date")
                    {
                    }
                    column(ShipmentMethodCode_SalesHeader; "Sales Header"."Shipment Method Code")
                    {
                    }
                    column(Description_PaymentTerms; PaymentTerms.Description)
                    {
                    }
                    column(Priority_SalesHeader; "Sales Header".Priority)
                    {
                    }
                    column(BilltoCustomerNo_SalesHeader; "Sales Header"."Bill-to Customer No.")
                    {
                    }
                    column(BilltoName_SalsesHeader; "Sales Header"."Bill-to Name")
                    {
                    }
                    column(BilltoName2_SalesHeader; "Sales Header"."Bill-to Name 2")
                    {
                    }
                    column(BilltoAddress_SalesHeader; "Sales Header"."Bill-to Address")
                    {
                    }
                    column(BilltoAddress2_SalesHeader; "Sales Header"."Bill-to Address 2")
                    {
                    }
                    column(BilltoCity_SalesHeader; "Sales Header"."Bill-to City")
                    {
                    }
                    column(BilltoPostCode_SalesHeader; "Sales Header"."Bill-to Post Code")
                    {
                    }
                    column(BilltoCounty_SalesHeader; "Sales Header"."Bill-to County")
                    {
                    }
                    column(BilltoCountry_RegionCode_SalesHeader; "Sales Header"."Bill-to Country/Region Code")
                    {
                    }
                    column(BilltoContactNo_SalesHeader; "Sales Header"."Bill-to Contact No.")
                    {
                    }
                    column(BilltoContact_SalesHeader; "Sales Header"."Bill-to Contact")
                    {
                    }
                    column(Name_recCountry; recCountry.Name)
                    {
                    }
                    column(ShiptoCode_SalesHeader; "Sales Header"."Ship-to Code")
                    {
                    }
                    column(ShiptoName_SalesHeader; "Sales Header"."Ship-to Name")
                    {
                    }
                    column(ShiptoName2_SalesHeader; "Sales Header"."Ship-to Name 2")
                    {
                    }
                    column(ShiptoAddress_SalesHeader; "Sales Header"."Ship-to Address")
                    {
                    }
                    column(ShiptoAddress2_SalesHeader; "Sales Header"."Ship-to Address 2")
                    {
                    }
                    column(ShiptoCity_SalesHeader; "Sales Header"."Ship-to City")
                    {
                    }
                    column(ShiptoPostCode_SalesHeader; "Sales Header"."Ship-to Post Code")
                    {
                    }
                    column(ShiptoCounty_SalesHeader; "Sales Header"."Ship-to County")
                    {
                    }
                    column(ShiptoCountryRegionCode_SalesHeader; "Sales Header"."Ship-to Country/Region Code")
                    {
                    }
                    column(ShiptoContact_SalesHeader; "Sales Header"."Ship-to Contact")
                    {
                    }
                    column(Name_recCountry2; recCountry2.Name)
                    {
                    }
                    column(CreditLimit_recCustomer; recCustomer."Credit Limit (LCY)")
                    {
                    }
                    column(Balance_recCustomer; recCustomer.Balance)
                    {
                    }
                    column(Order_Amt; Order_Amt)
                    {
                    }
                    column(DUE_BAL; DUE_BAL)
                    {
                    }
                    column(dec0_30; dec0_30)
                    {
                    }
                    column(dec31_60; dec31_60)
                    {
                    }
                    column(dec61_90; dec61_90)
                    {
                    }
                    column(decOver90; decOver90)
                    {
                    }
                    column(SubTotal; SubTotal)
                    {
                    }
                    column(DiscAmount; DiscAmount)
                    {
                    }
                    dataitem("Sales Line"; "Sales Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE("Outstanding Quantity" = FILTER(<> 0));
                        column(Type_SalesLine; "Sales Line".Type)
                        {
                        }
                        column(No_SalesLine; "Sales Line"."No.")
                        {
                        }
                        column(Description_SalesLine; "Sales Line".Description)
                        {
                        }
                        column(UnitofMeasure_SalesLine; "Sales Line"."Unit of Measure")
                        {
                        }
                        column(OutstandingQuantity_SalesLine; "Sales Line"."Outstanding Quantity")
                        {
                        }
                        column(CrossReferenceNo_SalesLine; "Sales Line"."Cross-Reference No.")
                        {
                        }
                        column(MinimumQty_SalesLine; "Sales Line"."Minimum Qty")
                        {
                        }
                        column(UnitPrice_SalesLine; "Sales Line"."Unit Price")
                        {
                        }
                        column(LineDiscountAmount_SalesLine; "Sales Line"."Line Discount Amount")
                        {
                        }
                        column(Amount_SalesLine; ("Sales Line"."Outstanding Quantity" * "Sales Line"."Unit Price") - "Sales Line"."Line Discount Amount")
                        {
                        }
                        dataitem(CommentLine; "Sales Comment Line")
                        {
                            DataItemLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("Document No."), "Document Line No." = FIELD("Line No.");
                            DataItemLinkReference = "Sales Line";
                            DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") ORDER(Ascending);
                            column(DocumentLineNo_CommentLine; "Document Line No.")
                            {
                            }
                            column(Comment_CommentLine; Comment)
                            {
                            }
                        }
                    }
                    dataitem(CommentHeader; "Sales Comment Line")
                    {
                        DataItemLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("No.");
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") ORDER(Ascending) WHERE("Document Line No." = CONST(0));
                        column(DocumentLineNo_CommentHeader; CommentHeader."Document Line No.")
                        {
                        }
                        column(Comment_CommentHeader; CommentHeader.Comment)
                        {
                        }
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    CopyText := Text001;
                    IF CopyLoop.Number > 1 THEN BEGIN
                        IF CopyLoop.Number = 2 THEN
                            CopyText := Text002
                        ELSE
                            IF CopyLoop.Number = 3 THEN
                                CopyText := Text003
                            ELSE
                                CopyText := Text004;
                        OutputNo += 1;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := ABS(NoOfCopies) + 1;
                    CopyText := '';
                    CopyLoop.SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CompInfo.GET;

                IF "Salesperson Code" = '' THEN
                    CLEAR(SalesPurchPerson)
                ELSE
                    SalesPurchPerson.GET("Salesperson Code");

                IF "Payment Terms Code" = '' THEN
                    CLEAR(PaymentTerms)
                ELSE
                    PaymentTerms.GET("Payment Terms Code");

                IF "Shipment Method Code" = '' THEN
                    CLEAR(ShipmentMethod)
                ELSE
                    ShipmentMethod.GET("Shipment Method Code");


                IF ("Sell-to Country/Region Code" <> '') AND ("Sell-to Country/Region Code" <> 'US') THEN
                    recCountry.GET("Sell-to Country/Region Code");

                IF ("Ship-to Country/Region Code" <> '') AND ("Ship-to Country/Region Code" <> 'US') THEN
                    recCountry2.GET("Ship-to Country/Region Code");
                IF "Payment Terms Code" <> '' THEN
                    recPmtTerm.GET("Payment Terms Code");

                recCustomer.GET("Sales Header"."Sell-to Customer No.");

                IF "Shipping Agent Code" = 'UPS' THEN
                    AccNo := recCustomer."UPS Account No."
                ELSE
                    IF "Shipping Agent Code" = 'FEDEX' THEN
                        AccNo := recCustomer."Shipping Account No."
                    ELSE
                        AccNo := '';

                IF "Posting Date" <> 0D THEN
                    UseDate := "Posting Date"
                ELSE
                    UseDate := WORKDATE;

                StartDate := "Sales Header"."Order Date";
                PeriodStartDate[5] := StartDate;
                PeriodStartDate[6] := 99991231D;
                FOR i2 := 4 DOWNTO 2 DO
                    PeriodStartDate[i2] := CALCDATE('<-30D>', PeriodStartDate[i2 + 1]);

                CurrReport.CREATETOTALS(CustBalanceDueLCY);
                recCustomer.CALCFIELDS(recCustomer.Balance);

                FOR i2 := 1 TO 5 DO BEGIN
                    DtldCustLedgEntry.SETCURRENTKEY("Customer No.", "Initial Entry Due Date", "Posting Date");
                    DtldCustLedgEntry.SETRANGE("Customer No.", "Sales Header"."Sell-to Customer No.");
                    DtldCustLedgEntry.SETRANGE("Posting Date", 0D, StartDate);
                    DtldCustLedgEntry.SETRANGE("Initial Entry Due Date", PeriodStartDate[i2], PeriodStartDate[i2 + 1] - 1);
                    DtldCustLedgEntry.CALCSUMS(DtldCustLedgEntry."Amount (LCY)");
                    CustBalanceDueLCY[i2] := DtldCustLedgEntry."Amount (LCY)";
                END;

                OPEN_ORDER := 0;
                Order_Amt := 0;
                recSalesHeader.RESET;
                recSalesHeader.SETRANGE(recSalesHeader."Sell-to Customer No.", "Sales Header"."Sell-to Customer No.");
                recSalesHeader.SETRANGE("Document Type", "Document Type"::Order);
                IF recSalesHeader.FIND('-') THEN
                    REPEAT
                        recSalesHeader.CALCFIELDS(recSalesHeader."Outstanding Amount ($)");
                        Order_Amt += recSalesHeader."Outstanding Amount ($)";
                    UNTIL recSalesHeader.NEXT = 0;

                DUE_BAL := 0;
                recCLE.RESET;
                recCLE.SETRANGE("Customer No.", "Sales Header"."Sell-to Customer No.");
                recCLE.SETRANGE(Open, TRUE);
                recCLE.SETFILTER("Due Date", '>%1', WORKDATE);
                IF recCLE.FIND('-') THEN
                    REPEAT
                        recCLE.CALCFIELDS(recCLE."Remaining Amount");
                        DUE_BAL += recCLE."Remaining Amount";
                    UNTIL recCLE.NEXT = 0;
                dec0_30 := 0;
                dec0_30 := CustomerAging30("Sales Header"."Sell-to Customer No.");
                dec31_60 := 0;
                dec31_60 := CustomerAging60("Sales Header"."Sell-to Customer No.");
                dec61_90 := 0;
                dec61_90 := CustomerAging90("Sales Header"."Sell-to Customer No.");
                decOver90 := 0;
                decOver90 := CustomerAging91Above("Sales Header"."Sell-to Customer No.");

                SubTotal := 0;
                DiscAmount := 0;
                recSalesLine.RESET;
                recSalesLine.SETRANGE(recSalesLine."Document Type", "Sales Header"."Document Type");
                recSalesLine.SETRANGE(recSalesLine."Document No.", "Sales Header"."No.");
                recSalesLine.SETFILTER(recSalesLine."Outstanding Quantity", '<>%1', 0);
                IF recSalesLine.FINDFIRST THEN
                    REPEAT
                        SubTotal := SubTotal + recSalesLine.Amount;
                        DiscAmount := DiscAmount + recSalesLine."Line Discount Amount";
                    UNTIL recSalesLine.NEXT = 0;

                OrderText := '';
                OrderQty := 0;
                OrderBalQty := 0;
                recSalesLine1.RESET;
                recSalesLine1.SETRANGE(recSalesLine1."Document Type", "Sales Header"."Document Type");
                recSalesLine1.SETRANGE(recSalesLine1."Document No.", "Sales Header"."No.");
                recSalesLine1.SETRANGE(recSalesLine1.Type, recSalesLine1.Type::Item);
                IF recSalesLine1.FINDFIRST THEN
                    REPEAT
                        OrderQty := OrderQty + recSalesLine1.Quantity;
                        OrderBalQty := OrderBalQty + recSalesLine1."Outstanding Quantity";
                    UNTIL recSalesLine1.NEXT = 0;
                IF OrderQty > OrderBalQty THEN
                    OrderText := 'Back Order'
                ELSE
                    OrderText := 'Sales Order';
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(NoOfCopies; NoOfCopies)
                    {
                        Caption = 'No of Copies';
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        lblSoldTo = 'Sold To :';
        lblConfirmTo = 'Confirm To :';
        lblSalesOrderNumber = 'Sales Order Number :';
        lblSalesOrderDate = 'Sales Order Date :';
        lblCustomerPO = 'Customer P.O. :';
        lblPODate = 'P.O. Date :';
        lblSalesperson = 'Salesperson :';
        lblShipVia = 'Ship Via :';
        iblShipDate = 'Ship Date :';
        lblIncoterms = 'Incoterms :';
        lblPriority = 'Priority :';
        lblNo = 'No.';
        lblItem = 'Item';
        lblAlias = 'Alias';
        lblNotes = 'Notes';
        lblMinQty = 'Min. Qty.';
        lblQty = 'Qty.';
        lblUnitPrice = 'Unit Price';
        lblDisc = '$ Disc.';
        lblTotalPrice = 'Total Price';
        lblApprovedBy = 'Approved By -----------------------------';
        lblPackedBy = 'Packed By -----------------------------';
        lblInvoicedBy = 'Invoiced By -----------------------------';
        lblCrLimit = 'Cr. Limit';
        lblOpenSO = 'Open SO';
        lblTotalBalance = 'Total Balance';
        lblCurrentBalance = 'Current Balance';
        lbl0_30Days = '0-30 Days';
        lbl31_60Days = '31-60 Days';
        lbl61_90Days = '61-90 Days';
        lblOver90Days = 'Over 90 Days';
        lblSubtotal = 'Subtotal :';
        lblDiscount = 'Discount :';
        lblTotal = 'Total :';
    }

    trigger OnInitReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompInfo: Record "Company Information";
        CompanyInfo: Record "Company Information";
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        OutputNo: Integer;
        Text001: Label 'Customer Copy';
        Text002: Label 'Accounts Copy';
        Text003: Label 'Duplicate Copy';
        Text004: Label 'Extra Copy';
        Text005: Label 'Page';
        Text006: Label '%1 of %2';
        SalesPurchPerson: Record "Salesperson/Purchaser";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        recCountry: Record "Country/Region";
        recCountry2: Record "Country/Region";
        recPmtTerm: Record "Payment Terms";
        recCustomer: Record Customer;
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        recSalesHeader: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recCLE: Record "Cust. Ledger Entry";
        recSalesLine1: Record "Sales Line";
        OrderQty: Decimal;
        OrderBalQty: Decimal;
        OrderText: Text[50];
        SubTotal: Decimal;
        DiscAmount: Decimal;
        AccNo: Text[30];
        UseDate: Date;
        StartDate: Date;
        PeriodStartDate: array[6] of Date;
        i2: Integer;
        CustBalanceDueLCY: array[5] of Decimal;
        OPEN_ORDER: Integer;
        Order_Amt: Decimal;
        DUE_BAL: Decimal;
        dec0_30: Decimal;
        dec31_60: Decimal;
        dec61_90: Decimal;
        decOver90: Decimal;
        CurrentBalance: Decimal;


    procedure CurrrntBal(CustomerNo: Code[20]): Decimal
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        BalanceAmt: Decimal;
    begin
        CustLedgEntry.SETCURRENTKEY("Customer No.", "Due Date");
        CustLedgEntry.SETRANGE("Customer No.", "Sales Header"."Sell-to Customer No.");
        CustLedgEntry.SETFILTER("Due Date", '%..', WORKDATE);
        IF CustLedgEntry.FINDFIRST THEN
            REPEAT
                CustLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");
                BalanceAmt += CustLedgEntry."Remaining Amt. (LCY)";
            UNTIL CustLedgEntry.NEXT = 0;
        EXIT(BalanceAmt);
    end;


    procedure CustomerAging30(CustomerNo: Code[20]): Decimal
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        BalanceAmt: Decimal;
    begin
        CustLedgEntry.SETCURRENTKEY("Customer No.", "Due Date");
        CustLedgEntry.SETRANGE("Customer No.", "Sales Header"."Sell-to Customer No.");
        CustLedgEntry.SETRANGE("Due Date", CALCDATE('<-30D>', WORKDATE), CALCDATE('<-1D>', WORKDATE));
        IF CustLedgEntry.FINDFIRST THEN
            REPEAT
                CustLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");
                BalanceAmt += CustLedgEntry."Remaining Amt. (LCY)";
            UNTIL CustLedgEntry.NEXT = 0;
        EXIT(BalanceAmt);
    end;


    procedure CustomerAging60(CustomerNo: Code[20]): Decimal
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        BalanceAmt: Decimal;
    begin
        CustLedgEntry.SETCURRENTKEY("Customer No.", "Due Date");
        CustLedgEntry.SETRANGE("Customer No.", "Sales Header"."Sell-to Customer No.");
        CustLedgEntry.SETRANGE("Due Date", CALCDATE('<-60D>', WORKDATE), CALCDATE('<-31D>', WORKDATE));
        IF CustLedgEntry.FINDFIRST THEN
            REPEAT
                CustLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");
                BalanceAmt += CustLedgEntry."Remaining Amt. (LCY)";
            UNTIL CustLedgEntry.NEXT = 0;
        EXIT(BalanceAmt);
    end;


    procedure CustomerAging90(CustomerNo: Code[20]): Decimal
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        BalanceAmt: Decimal;
    begin
        CustLedgEntry.SETCURRENTKEY("Customer No.", "Due Date");
        CustLedgEntry.SETRANGE("Customer No.", "Sales Header"."Sell-to Customer No.");
        CustLedgEntry.SETRANGE("Due Date", CALCDATE('<-90D>', WORKDATE), CALCDATE('<-61D>', WORKDATE));
        IF CustLedgEntry.FINDFIRST THEN
            REPEAT
                CustLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");
                BalanceAmt += CustLedgEntry."Remaining Amt. (LCY)";
            UNTIL CustLedgEntry.NEXT = 0;
        EXIT(BalanceAmt);
    end;


    procedure CustomerAging91Above(CustomerNo: Code[20]): Decimal
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        BalanceAmt: Decimal;
    begin
        CustLedgEntry.SETCURRENTKEY("Customer No.", "Due Date");
        CustLedgEntry.SETRANGE("Customer No.", "Sales Header"."Sell-to Customer No.");
        CustLedgEntry.SETRANGE("Due Date", 0D, CALCDATE('<-91D>', WORKDATE));
        IF CustLedgEntry.FINDFIRST THEN
            REPEAT
                CustLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");
                BalanceAmt += CustLedgEntry."Remaining Amt. (LCY)";
            UNTIL CustLedgEntry.NEXT = 0;
        EXIT(BalanceAmt);
    end;
}

