codeunit 50008 ecomPortal
{

    trigger OnRun()
    begin
    end;

    var
        WhseActivityRegister: Codeunit "Whse.-Activity-Register";
        WMSMgt: Codeunit "WMS Management";
        WhseActivLine: Record "Warehouse Activity Line";
        cuIntegrationFedexUPS: Codeunit "Integration Fedex UPS";
        Text002: Label 'The document %1 is not supported.';
        text001: Label '10.10.1.39';
        "Key": Label 'c4LvuJL5jnMaQA2C';
        Password: Label 'GtJhVpwzFs1IczW7a1Rrqoxbi';
        MeterNo: Label '107459103';
        AccountNo: Label '122898849';
        RateText01: Label 'http://wwwapps.ups.com/ctc/htmlTool?accept_UPS_license_agreement=yes&UPS_HTML_License=7BAF5EAE471A8706&10_action=4&14_origCountry=US&origCity=Syosset&15_origPostal=11791&billToUPS=yes&47_rate_chart=%20Regular%20Daily%20Pickup&';
        webserverIP: Label '192.168.1.228:51212';
        RocketShipIP: Label 'localhost:59999';
        SpecialService: BigText;


    procedure CreateNOPCustomer(Name: Text[50]; Email: Text[80]; AdminComment: Text[250]; HasShopingCart: Boolean; Active: Boolean; Deleated: Text; CustomerPriceGroup: Code[20])
    var
        recCustomer: Record Customer;
    begin
        recCustomer.INIT;
        recCustomer."No." := '';
        recCustomer.Name := Name;
        recCustomer.AdminComments := AdminComment;
        recCustomer.HasShoppingCartItems := HasShopingCart;
        recCustomer.Active := Active;
        recCustomer."E-Mail" := Email;
        IF Deleated = '' THEN
            recCustomer.Blocked := recCustomer.Blocked::" "
        ELSE
            recCustomer.Blocked := recCustomer.Blocked::All;
        recCustomer."Customer Price Group" := CustomerPriceGroup;
        recCustomer.INSERT(TRUE);
    end;


    procedure CreateSalesOrderHeader(CustomerId: Code[20]; BillingAddressId: Code[20]; ShippingAddressId: Code[20]; CustomerCurrencyCode: Code[10]; ShippingMethod: Code[20]; CreatedOnUtc: Text[30]; PaymentMethod: Code[20]) OrderGuid: Code[20]
    var
        recSalesOrder: Record "Sales Header";
        CreatedOnUtcDate: Date;
        CreatedOnUtcDateTime: DateTime;
    begin
        recSalesOrder.INIT;
        recSalesOrder.VALIDATE("Document Type", recSalesOrder."Document Type"::Order);
        recSalesOrder.VALIDATE("No.", '');

        EVALUATE(CreatedOnUtcDateTime, CreatedOnUtc);
        CreatedOnUtcDate := DT2DATE(CreatedOnUtcDateTime);

        recSalesOrder.VALIDATE("Posting Date", CreatedOnUtcDate);
        recSalesOrder.VALIDATE("Order Date", CreatedOnUtcDate);
        recSalesOrder.VALIDATE("Document Date", CreatedOnUtcDate);

        recSalesOrder.VALIDATE("Sell-to Customer No.", CustomerId);
        recSalesOrder.VALIDATE("Bill-to Customer No.", BillingAddressId);
        recSalesOrder.VALIDATE("Ship-to Code", ShippingAddressId);

        recSalesOrder.VALIDATE("Currency Code", CustomerCurrencyCode);

        recSalesOrder.VALIDATE("Shipment Method Code", ShippingMethod);
        recSalesOrder.VALIDATE("Payment Method Code", PaymentMethod);

        recSalesOrder.INSERT(TRUE);

        EXIT(recSalesOrder."No.");
    end;


    procedure CreateSalesOrderLine(OrderId: Code[20]; ProductId: Code[20]; Quantity: Decimal; UnitPriceExclTax: Decimal; PriceInclTax: Decimal; ItemWeight: Decimal) Return: Boolean
    var
        recSalesOrderLine: Record "Sales Line";
        LineNo: Integer;
        SalesOrderLine: Record "Sales Line";
    begin
        LineNo := 0;
        SalesOrderLine.RESET;
        SalesOrderLine.SETRANGE("Document Type", recSalesOrderLine."Document Type"::Order);
        SalesOrderLine.SETRANGE("Document No.", OrderId);
        IF SalesOrderLine.FINDLAST THEN
            LineNo := SalesOrderLine."Line No.";


        recSalesOrderLine.INIT;
        recSalesOrderLine.VALIDATE("Document Type", recSalesOrderLine."Document Type"::Order);
        recSalesOrderLine.VALIDATE("Document No.", OrderId);
        recSalesOrderLine."Line No." := LineNo + 10000;
        recSalesOrderLine.VALIDATE(Type, recSalesOrderLine.Type::Item);
        recSalesOrderLine.VALIDATE("No.", ProductId);
        recSalesOrderLine.VALIDATE(Quantity, Quantity);
        recSalesOrderLine.VALIDATE("Original Quantity", Quantity);
        recSalesOrderLine.VALIDATE("Unit Price", UnitPriceExclTax);
        recSalesOrderLine.VALIDATE("Line Amount", PriceInclTax);
        recSalesOrderLine.VALIDATE("Net Weight", ItemWeight);
        IF recSalesOrderLine.INSERT(TRUE) THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;


    procedure HandHeldLogin(UserName: Text[30]; Password: Text[30]) ReturnValue: Boolean
    var
        HandHeldLogin: Record "Handheld Login";
        CheckLogin: Boolean;
    begin

        CheckLogin := FALSE;
        HandHeldLogin.RESET;
        HandHeldLogin.SETRANGE(HandHeldLogin."User Name", UserName);
        HandHeldLogin.SETRANGE(HandHeldLogin.Password, Password);
        IF HandHeldLogin.FINDFIRST THEN
            CheckLogin := TRUE
        ELSE
            CheckLogin := FALSE;

        EXIT(CheckLogin);
    end;


    procedure CreateSalesReturnOrderHeader(CustomerId: Code[20]; BillingAddressId: Code[20]; ShippingAddressId: Code[20]; CustomerCurrencyCode: Code[10]; ShippingMethod: Code[20]; CreatedOnUtc: Date; PaymentMethod: Code[20]; SalesOrderNo: Code[20]) OrderGuid: Code[20]
    var
        recSalesOrder: Record "Sales Header";
    begin
        recSalesOrder.INIT;
        recSalesOrder.VALIDATE("Document Type", recSalesOrder."Document Type"::"Return Order");
        recSalesOrder.VALIDATE("No.", '');
        recSalesOrder.VALIDATE("Order Date", CreatedOnUtc);
        recSalesOrder.VALIDATE("Sell-to Customer No.", CustomerId);
        recSalesOrder.VALIDATE("Document Date", CreatedOnUtc);
        recSalesOrder.VALIDATE("Bill-to Customer No.", BillingAddressId);
        recSalesOrder.VALIDATE("Ship-to Code", ShippingAddressId);

        recSalesOrder.VALIDATE("Currency Code", CustomerCurrencyCode);
        recSalesOrder.VALIDATE("Shipment Method Code", ShippingMethod);
        recSalesOrder.VALIDATE("Payment Method Code", PaymentMethod);
        recSalesOrder.VALIDATE("Sales Order No.", SalesOrderNo);

        recSalesOrder.INSERT(TRUE);

        EXIT(recSalesOrder."No.");
    end;


    procedure CreateSalesReturnOrderLine(OrderId: Code[20]; ProductId: Code[20]; Quantity: Decimal; UnitPriceExclTax: Decimal; PriceInclTax: Decimal; ItemWeight: Decimal; SalesInvoiceNo: Code[20]) Return: Boolean
    var
        recSalesOrderLine: Record "Sales Line";
        LineNo: Integer;
        SalesOrderLine: Record "Sales Line";
    begin
        LineNo := 0;
        SalesOrderLine.RESET;
        SalesOrderLine.SETRANGE("Document Type", recSalesOrderLine."Document Type"::"Return Order");
        SalesOrderLine.SETRANGE("Document No.", OrderId);
        IF SalesOrderLine.FINDLAST THEN
            LineNo := SalesOrderLine."Line No.";


        recSalesOrderLine.INIT;
        recSalesOrderLine.VALIDATE("Document Type", recSalesOrderLine."Document Type"::"Return Order");
        recSalesOrderLine.VALIDATE("Document No.", OrderId);
        recSalesOrderLine."Line No." := LineNo + 10000;
        recSalesOrderLine.VALIDATE(Type, recSalesOrderLine.Type::Item);
        recSalesOrderLine.VALIDATE("No.", ProductId);
        recSalesOrderLine.VALIDATE(Quantity, Quantity);
        recSalesOrderLine.VALIDATE("Unit Price", UnitPriceExclTax);
        recSalesOrderLine.VALIDATE("Line Amount", PriceInclTax);
        recSalesOrderLine.VALIDATE("Net Weight", ItemWeight);
        recSalesOrderLine.VALIDATE("Sales Invoice No.", SalesInvoiceNo);
        IF recSalesOrderLine.INSERT(TRUE) THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;


    procedure CreateWarehouseShipment(DocumentNo: Code[20])
    var
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound_Ext";
        SH: Record "Sales Header";
    begin
        SH.RESET;
        SH.SETRANGE("No.", DocumentNo);
        IF SH.FINDFIRST THEN BEGIN
            GetSourceDocOutbound.CreateFromSalesOrderHendheld(SH);

            IF NOT SH.FIND('=><') THEN
                SH.INIT;

        END;
    end;


    procedure RegisterActivityYesNo(SalesOrderNo: Code[20]) Return: Text[250]
    var
        WhseActivLine: Record "Warehouse Activity Line";
        recWhseActivLine: Record "Warehouse Activity Line";
        recPackingHeader: Record "Packing Header";
    begin
        recPackingHeader.RESET;
        recPackingHeader.SETRANGE(recPackingHeader."Sales Order No.", SalesOrderNo);
        IF NOT recPackingHeader.FINDFIRST THEN
            EXIT('Please Create Pack first ');

        recWhseActivLine.RESET;
        //recWhseActivLine.SETRANGE("Source Document",recWhseActivLine."Source Document"::"Sales Order");
        recWhseActivLine.SETRANGE("Source No.", SalesOrderNo);
        IF recWhseActivLine.FINDSET THEN BEGIN
            WhseActivLine.COPY(recWhseActivLine);
            WhseActivLine.FILTERGROUP(3);
            WhseActivLine.SETRANGE(Breakbulk);
            WhseActivLine.FILTERGROUP(0);
            cuIntegrationFedexUPS.WhseRegisterActivityYesNo(WhseActivLine);
            recWhseActivLine.RESET;
            recWhseActivLine.SETCURRENTKEY("Activity Type", "No.", "Sorting Sequence No.");
            recWhseActivLine.FILTERGROUP(4);
            recWhseActivLine.SETRANGE("Activity Type", WhseActivLine."Activity Type");
            recWhseActivLine.SETRANGE("No.", WhseActivLine."No.");
            recWhseActivLine.FILTERGROUP(3);
            recWhseActivLine.SETRANGE(Breakbulk, FALSE);
            recWhseActivLine.FILTERGROUP(0);
        END;
    end;


    procedure CodeHandheld(WhseActivityNo: Code[20])
    var
        recWhseActivLine: Record "Warehouse Activity Line";
    begin
        recWhseActivLine.RESET;
        recWhseActivLine.SETRANGE("No.", WhseActivityNo);
        IF recWhseActivLine.FINDSET THEN BEGIN
            //WITH recWhseActivLine DO BEGIN
            IF (recWhseActivLine."Activity Type" = recWhseActivLine."Activity Type"::"Invt. Movement") AND
               NOT (recWhseActivLine."Source Document" IN [recWhseActivLine."Source Document"::" ", recWhseActivLine."Source Document"::"Prod. Consumption", recWhseActivLine."Source Document"::"Assembly Consumption"])
            THEN
                ERROR(Text002, recWhseActivLine."Source Document");

            WMSMgt.CheckBalanceQtyToHandle(recWhseActivLine);
            WhseActivityRegister.RUN(recWhseActivLine);
            CLEAR(WhseActivityRegister);
        END;
    END;
    //end;


    procedure ShipRequestHandHeld(WareHouseNo: Code[20]) Return: Text[250]
    var
        WareHouseShipmentHeader: Record "Warehouse Shipment Header";
        recPackingHeader: Record "Packing Header";
        recShipReqTrackingNo: Record "Tracking No.";
        recPrinterSelection: Record "Printer Selection";
        PageWareHouseShipment: Page "Warehouse Shipment";
        //cuTest: Codeunit "Integration Handheld";
        rptTest: Report "FedEx Label Report Handheld";
        recTrackingNo: Record "Tracking No.";
    //rptTest1: Report "UPS Label Report Handheld";
    begin
        //VR code not in use
        // WareHouseShipmentHeader.RESET;
        // WareHouseShipmentHeader.SETRANGE(WareHouseShipmentHeader."No.", WareHouseNo);
        // IF WareHouseShipmentHeader.FINDFIRST THEN BEGIN
        //     IF WareHouseShipmentHeader."Shipping Agent Code" = 'FEDEX' THEN BEGIN
        //         IF WareHouseShipmentHeader."Tracking No." = '' THEN BEGIN
        //             cuTest.StandardOverNight(WareHouseShipmentHeader);
        //             COMMIT;
        //             CLEAR(rptTest);
        //             rptTest.InitVar(WareHouseNo);
        //             rptTest.RUN;
        //         END;
        //     END;

        //     IF WareHouseShipmentHeader."Shipping Agent Code" = 'UPS' THEN BEGIN
        //         IF WareHouseShipmentHeader."Tracking No." = '' THEN BEGIN
        //             cuTest.UPSRequest(WareHouseShipmentHeader);
        //             COMMIT;
        //             rptTest1.InitVar(WareHouseNo, '');
        //             rptTest1.RUN;
        //         END;
        //     END;

        //     IF WareHouseShipmentHeader."Shipping Agent Code" = 'ENDICIA' THEN BEGIN
        //         IF WareHouseShipmentHeader."Tracking No." = '' THEN BEGIN
        //             IF WareHouseShipmentHeader."Label Type" = 0 THEN
        //                 cuTest.EndiciaRequest(WareHouseShipmentHeader, WareHouseShipmentHeader."Packing List No.");
        //             COMMIT;
        //             rptTest1.InitVar(WareHouseNo, '');
        //             rptTest1.RUN;
        //         END;
        //     END;

        //     ///SLEEP(2000);
        //     //PageWareHouseShipment.PrintLableHandheld(WareHouseNo);
        // END;
        // EXIT('Shipment Level Printed Sucessfuly');
    end;


    procedure CreatePackHandHeld(WareHouseNo: Code[20]) ERROR: Text[250]
    var
        WareHouseShipmentHeader: Record "Warehouse Shipment Header";
        RecPackingHead: Record "Packing Header";
        ReleaseWhseShptDoc: Codeunit "Whse.-Shipment Release";
        recWhseShptLines: Record "Warehouse Shipment Line";
        recPackingHeader: Record "Packing Header";
        recPackingLine: Record "Packing Line";
        recSH: Record "Sales Header";
    begin
        WareHouseShipmentHeader.RESET;
        WareHouseShipmentHeader.SETRANGE(WareHouseShipmentHeader."No.", WareHouseNo);
        IF WareHouseShipmentHeader.FINDFIRST THEN BEGIN
            IF WareHouseShipmentHeader.Status = WareHouseShipmentHeader.Status::Open THEN
                ReleaseWhseShptDoc.Release(WareHouseShipmentHeader);


            WareHouseShipmentHeader.CALCFIELDS("Packing List No.");
            IF WareHouseShipmentHeader."Packing List No." = '' THEN BEGIN
                RecPackingHead.RESET;
                RecPackingHead.INIT;
                //RecPackingHead.VALIDATE(RecPackingHead."Source Document Type",RecPackingHead."Source Document Type"::"Warehouse Shipment");
                RecPackingHead.VALIDATE(RecPackingHead."Source Document No.", WareHouseNo);
                recWhseShptLines.RESET;
                //recWhseShptLines.SETRANGE(recWhseShptLines."Source Document",recWhseShptLines."Source Document"::"Sales Order");
                recWhseShptLines.SETRANGE(recWhseShptLines."No.", WareHouseNo);
                IF recWhseShptLines.FINDFIRST THEN
                    RecPackingHead.VALIDATE(RecPackingHead."Sales Order No.", recWhseShptLines."Source No.");
                IF recWhseShptLines."Source Document" = recWhseShptLines."Source Document"::"Outbound Transfer" THEN
                    RecPackingHead.VALIDATE("Source Document Type", RecPackingHead."Source Document Type"::"Transfer Order");
                IF recWhseShptLines."Source Document" = recWhseShptLines."Source Document"::"Sales Order" THEN
                    RecPackingHead.VALIDATE(RecPackingHead."Source Document Type", RecPackingHead."Source Document Type"::"Sales Order");
                RecPackingHead.INSERT(TRUE);
                WareHouseShipmentHeader."Packing List No." := RecPackingHead."Packing No.";
                WareHouseShipmentHeader.MODIFY;
                ///Release Packing Status BEGIN
                RecPackingHead.Status := RecPackingHead.Status::Release;
                IF recSH.GET(recSH."Document Type"::Order, recWhseShptLines."Source No.") THEN
                    RecPackingHead."Charges Pay By" := FORMAT(recSH."Charges Pay By");
                RecPackingHead.MODIFY;
                ///Release Packing Status END

            END ELSE BEGIN
                EXIT('Packing List already created. Do you want to open?');
            END;
        END;
    end;


    procedure BoxFilledHandHeld(PackingNo: Code[20]; BoxCode: Code[20]; NoOfLots: Decimal; Weight: Decimal; GrossWeight: Decimal) Return: Text[250]
    var
        PackingLine: Record "Packing Line";
        LineNo: Integer;
        recPackingHeader: Record "Packing Header";
    begin
        LineNo := 0;
        PackingLine.RESET;
        PackingLine.SETRANGE(PackingLine."Packing No.", PackingNo);
        IF PackingLine.FINDLAST THEN
            LineNo := PackingLine."Line No.";


        PackingLine.RESET;
        PackingLine.INIT;
        PackingLine.VALIDATE("Packing No.", PackingNo);
        PackingLine."Line No." := LineNo + 10000;
        PackingLine.VALIDATE("Box Code", BoxCode);
        PackingLine.VALIDATE("No. Of  Lots", NoOfLots);
        PackingLine.Weight := Weight;
        PackingLine."Gross Weight" := GrossWeight;
        PackingLine.INSERT;

        recPackingHeader.RESET;
        recPackingHeader.SETRANGE("Packing No.", PackingLine."Packing No.");
        IF recPackingHeader.FINDFIRST THEN
            CalculateInsuredValue(recPackingHeader."Source Document No.");

        EXIT('Done');
    end;


    procedure FinishPackHandHeld(PackingNo: Code[20]) Return: Text[250]
    var
        recPackingHeader: Record "Packing Header";
        recPackingLine: Record "Packing Line";
        WareHouseShipmentHeader: Record "Warehouse Shipment Header";
        pgWareHouseShipment: Record "Warehouse Shipment Header";
        WhseShptLine: Record "Warehouse Shipment Line";
        WhsePostShptShipInvoice: Codeunit "Whse.-Post Shipment (Yes/No)";
        WhsePostShipment: Codeunit "Whse.-Post Shipment";
        recWarehouseActivityLine: Record "Warehouse Activity Line";
        recWarehouseActivityHeader: Record "Warehouse Activity Header";
    begin
        recPackingHeader.RESET;
        recPackingHeader.SETRANGE(recPackingHeader."Packing No.", PackingNo);
        IF recPackingHeader.FINDFIRST THEN BEGIN
            recPackingLine.RESET;
            recPackingLine.SETRANGE("Packing No.", recPackingHeader."Packing No.");
            IF recPackingLine.FINDFIRST THEN
                WareHouseShipmentHeader.RESET;
            WareHouseShipmentHeader.SETRANGE(WareHouseShipmentHeader."No.", recPackingHeader."Source Document No.");
            IF WareHouseShipmentHeader.FINDFIRST THEN BEGIN
                //IF (WareHouseShipmentHeader."Shipping Agent Code" <> '') THEN BEGIN
                IF (recPackingLine."Tracking No." <> '') THEN BEGIN
                    WhseShptLine.RESET;
                    WhseShptLine.SETRANGE(WhseShptLine."No.", WareHouseShipmentHeader."No.");
                    IF WhseShptLine.FINDSET THEN BEGIN
                        WhsePostShipment.SetPostingSettings(FALSE);
                        WhsePostShipment.SetPrint(FALSE);
                        WhsePostShipment.RUN(WhseShptLine);
                        WhsePostShipment.GetResultMessage;
                        CLEAR(WhsePostShipment);
                    END;



                    recPackingHeader.Status := recPackingHeader.Status::Closed;
                    recPackingHeader.MODIFY;

                    WareHouseShipmentHeader.RESET;
                    WareHouseShipmentHeader.SETRANGE(WareHouseShipmentHeader."No.", recPackingHeader."Source Document No.");
                    IF WareHouseShipmentHeader.FINDFIRST THEN BEGIN
                        WhseShptLine.RESET;
                        WhseShptLine.SETRANGE(WhseShptLine."No.", WareHouseShipmentHeader."No.");
                        WhseShptLine.SETFILTER("Qty. Outstanding", '<>%1', 0);
                        IF WhseShptLine.FINDSET THEN BEGIN
                            //Bug Fixed Begin
                            recWarehouseActivityLine.RESET;
                            recWarehouseActivityLine.SETRANGE("Source No.", WhseShptLine."Source No.");
                            IF recWarehouseActivityLine.FINDSET THEN BEGIN

                                recWarehouseActivityHeader.RESET;
                                recWarehouseActivityHeader.SETRANGE("No.", recWarehouseActivityLine."No.");
                                IF recWarehouseActivityHeader.FINDSET THEN
                                    recWarehouseActivityHeader.DELETEALL;
                                recWarehouseActivityLine.DELETEALL;

                                WhseShptLine.DELETEALL;
                                WareHouseShipmentHeader.DELETEALL;

                            END;
                            //Bug Fixed End
                        END;
                    END;

                    EXIT('Done');
                    //END ELSE
                    //EXIT('First Print the Shipping Level');
                END ELSE BEGIN
                    WhseShptLine.RESET;
                    WhseShptLine.SETRANGE(WhseShptLine."No.", WareHouseShipmentHeader."No.");
                    IF WhseShptLine.FINDSET THEN BEGIN
                        WhsePostShipment.SetPostingSettings(FALSE);
                        WhsePostShipment.SetPrint(FALSE);
                        WhsePostShipment.RUN(WhseShptLine);
                        WhsePostShipment.GetResultMessage;
                        CLEAR(WhsePostShipment);
                    END;



                    recPackingHeader.Status := recPackingHeader.Status::Closed;
                    recPackingHeader.MODIFY;

                    WareHouseShipmentHeader.RESET;
                    WareHouseShipmentHeader.SETRANGE(WareHouseShipmentHeader."No.", recPackingHeader."Source Document No.");
                    IF WareHouseShipmentHeader.FINDFIRST THEN BEGIN
                        WhseShptLine.RESET;
                        WhseShptLine.SETRANGE(WhseShptLine."No.", WareHouseShipmentHeader."No.");
                        WhseShptLine.SETFILTER("Qty. Outstanding", '<>%1', 0);
                        IF WhseShptLine.FINDSET THEN BEGIN
                            //Bug Fixed Begin
                            recWarehouseActivityLine.RESET;
                            recWarehouseActivityLine.SETRANGE("Source No.", WhseShptLine."Source No.");
                            IF recWarehouseActivityLine.FINDSET THEN BEGIN

                                recWarehouseActivityHeader.RESET;
                                recWarehouseActivityHeader.SETRANGE("No.", recWarehouseActivityLine."No.");
                                IF recWarehouseActivityHeader.FINDSET THEN
                                    recWarehouseActivityHeader.DELETEALL;
                                recWarehouseActivityLine.DELETEALL;

                                WhseShptLine.DELETEALL;
                                WareHouseShipmentHeader.DELETEALL;

                            END;
                            //Bug Fixed End
                        END;
                    END;

                    EXIT('Done');

                END;
            END;
        END;
    end;


    procedure InsertNewPickingLines(OrderNo: Code[20]; PickingNo: Code[20]; ItemNo: Code[20]; LotNo: Code[20]; Qty: Decimal; LineNo: Integer) Return: Text[250]
    var
        recWarehouseActivityLine: Record "Warehouse Activity Line";
        NewWarehouseActivityLine: Record "Warehouse Activity Line";
    begin
        recWarehouseActivityLine.RESET;
        recWarehouseActivityLine.SETRANGE(recWarehouseActivityLine."Source No.", OrderNo);
        recWarehouseActivityLine.SETRANGE(recWarehouseActivityLine."Activity Type", recWarehouseActivityLine."Activity Type"::Pick);
        recWarehouseActivityLine.SETRANGE(recWarehouseActivityLine."No.", PickingNo);
        recWarehouseActivityLine.SETRANGE(recWarehouseActivityLine."Item No.", ItemNo);
        recWarehouseActivityLine.SETRANGE(recWarehouseActivityLine."Line No.", LineNo);
        IF recWarehouseActivityLine.FINDSET THEN BEGIN

            recWarehouseActivityLine.VALIDATE("Lot No.", LotNo);
            IF Qty <> 0 THEN BEGIN
                recWarehouseActivityLine.VALIDATE(Quantity, Qty);
                recWarehouseActivityLine.MODIFY;

                NewWarehouseActivityLine.RESET;
                NewWarehouseActivityLine.SETRANGE("Source No.", OrderNo);
                NewWarehouseActivityLine.SETRANGE("Activity Type", recWarehouseActivityLine."Activity Type"::Pick);
                NewWarehouseActivityLine.SETRANGE("No.", PickingNo);
                NewWarehouseActivityLine.SETRANGE("Item No.", ItemNo);
                NewWarehouseActivityLine.SETRANGE("Lot No.", LotNo);
                NewWarehouseActivityLine.SETRANGE("Action Type", NewWarehouseActivityLine."Action Type"::Place);
                IF NewWarehouseActivityLine.FINDSET THEN
                    NewWarehouseActivityLine.VALIDATE(Quantity, Qty);
                NewWarehouseActivityLine.MODIFY;
            END;

            EXIT('Done');
        END;
    end;


    procedure InsertBinInPickingLines(OrderNo: Code[20]; PickingNo: Code[20]; ItemNo: Code[20]; BinCode: Code[20]; LineNo: Integer) Return: Text[250]
    var
        recWarehouseActivityLine: Record "Warehouse Activity Line";
        NewWarehouseActivityLine: Record "Warehouse Activity Line";
    begin
        recWarehouseActivityLine.RESET;
        recWarehouseActivityLine.SETRANGE("Source No.", OrderNo);
        recWarehouseActivityLine.SETRANGE("Activity Type", recWarehouseActivityLine."Activity Type"::Pick);
        recWarehouseActivityLine.SETRANGE("Action Type", recWarehouseActivityLine."Action Type"::Take);
        recWarehouseActivityLine.SETRANGE("No.", PickingNo);
        recWarehouseActivityLine.SETRANGE("Item No.", ItemNo);
        recWarehouseActivityLine.SETRANGE("Line No.", LineNo);
        IF recWarehouseActivityLine.FINDSET THEN BEGIN
            recWarehouseActivityLine.VALIDATE("Bin Code", BinCode);
            recWarehouseActivityLine.MODIFY;
            EXIT('Bin Code insert');
        END ELSE
            EXIT('Bin Code Not insert');
    end;


    procedure DeleteNewPickingLines(OrderNo: Code[20]; PickingNo: Code[20]; ItemNo: Code[20]; LineNo: Integer) Return: Text[250]
    var
        recWarehouseActivityLine: Record "Warehouse Activity Line";
        WarehouseActivityLine: Record "Warehouse Activity Line";
        recWarehouseActivityHeader: Record "Warehouse Activity Header";
        recWSH: Record "Warehouse Shipment Header";
        recWSL: Record "Warehouse Shipment Line";
    begin
        recWarehouseActivityLine.RESET;
        recWarehouseActivityLine.SETRANGE(recWarehouseActivityLine."Source No.", OrderNo);
        recWarehouseActivityLine.SETRANGE(recWarehouseActivityLine."Activity Type", recWarehouseActivityLine."Activity Type"::Pick);
        recWarehouseActivityLine.SETRANGE(recWarehouseActivityLine."Action Type", recWarehouseActivityLine."Action Type"::Take);
        recWarehouseActivityLine.SETRANGE(recWarehouseActivityLine."No.", PickingNo);
        recWarehouseActivityLine.SETRANGE(recWarehouseActivityLine."Item No.", ItemNo);
        recWarehouseActivityLine.SETRANGE(recWarehouseActivityLine."Line No.", LineNo);
        IF recWarehouseActivityLine.FINDSET THEN BEGIN
            recWarehouseActivityLine.DELETEALL;

            recWarehouseActivityLine.RESET;
            recWarehouseActivityLine.SETRANGE(recWarehouseActivityLine."Source No.", OrderNo);
            recWarehouseActivityLine.SETRANGE(recWarehouseActivityLine."Activity Type", recWarehouseActivityLine."Activity Type"::Pick);
            recWarehouseActivityLine.SETRANGE(recWarehouseActivityLine."Action Type", recWarehouseActivityLine."Action Type"::Place);
            recWarehouseActivityLine.SETRANGE(recWarehouseActivityLine."No.", PickingNo);
            recWarehouseActivityLine.SETRANGE(recWarehouseActivityLine."Item No.", ItemNo);
            recWarehouseActivityLine.SETRANGE(recWarehouseActivityLine."Line No.", LineNo + 10000);
            IF recWarehouseActivityLine.FINDSET THEN BEGIN
                recWarehouseActivityLine.DELETEALL;

                WarehouseActivityLine.RESET;
                WarehouseActivityLine.SETRANGE("Source No.", OrderNo);
                WarehouseActivityLine.SETRANGE("Activity Type", WarehouseActivityLine."Activity Type"::Pick);
                WarehouseActivityLine.SETRANGE("No.", PickingNo);
                IF NOT WarehouseActivityLine.FINDFIRST THEN BEGIN
                    recWarehouseActivityHeader.RESET;
                    recWarehouseActivityHeader.SETRANGE("No.", PickingNo);
                    IF recWarehouseActivityHeader.FINDSET THEN
                        recWarehouseActivityHeader.DELETEALL;
                    recWSH.RESET;
                    recWSH.SETRANGE("No.", recWarehouseActivityLine."Whse. Document No.");
                    IF recWSH.FINDSET THEN BEGIN
                        recWSL.RESET;
                        recWSL.SETRANGE(recWSL."No.", recWSH."No.");
                        IF recWSL.FINDSET THEN BEGIN
                            recWSL.DELETEALL;
                            recWSH.DELETE;
                            WarehouseActivityLine.DELETEALL;
                        END;
                    END;
                END;

                EXIT('Done');
            END;
        END;
    end;


    procedure HandheldPrintRequest(recWhsShipHeaderNo: Code[20]; var txtSend: Text; var ShipingAgentCode: Text[50]; var ShipmentTrackingNo: Text[30]; LineNo: Integer) return: Boolean
    var
        recCustomer: Record Customer;
        txtPaymentType: Text[30];
        ResponsibleCountry: Code[10];
        ResponsiblePost: Code[20];
        ResponsibleState: Code[20];
        ResponsibleCity: Code[20];
        ResponsibleAddress: Text[50];
        ResponsiblePhone: Text[30];
        ResponsibleCompany: Text[50];
        ResponsibleEmail: Text[50];
        ResponsiblePerson: Text[50];
        ResponsibleAccNo: Text[30];
        decNetWeigh: Decimal;
        recSalesLine: Record "Sales Line";
        decAmount: Decimal;
        txtAmount: Text[25];
        recSalesHeader: Record "Sales Header";
        recWhseShipLine: Record "Warehouse Shipment Line";
        recBoxMaster: Record "Box Master";
        txtPackageDetail: BigText;
        intNo: Integer;
        txtPackagedet: array[5] of Text[1000];
        intLength: Integer;
        SalesRelease: Codeunit "Release Sales Document";
        txtMessage: Text[500];
        txtYear: Text[10];
        txtMonth: Text[10];
        txtDate: Text[10];
        intDate: Integer;
        intMonth: Integer;
        intYear: Integer;
        recShipAgentService: Record "Shipping Agent Services";
        txtShipService: Text[100];
        recShiptoAddress: Record "Ship-to Address";
        ShiptoName: Text[50];
        ShiptoAddress: Text[50];
        ShiptoAddress2: Text[50];
        ShiptoEmail: Text[50];
        ShiptoPhone: Text[30];
        ShiptoState: Text[30];
        ShiptoCountry: Text[30];
        ShiptoPostCode: Text[30];
        ShiptoContact: Text[50];
        ShiptoAccount: Code[20];
        ShiptoCity: Text[30];
        txtShipTime: Text[50];
        intLineNo: Integer;
        recSalesShipHeader: Record "Sales Shipment Header";
        WhseSetup: Record "Warehouse Setup";
        SpecialServiceTxt: array[10] of Text;
        outFile: File;
        outStream1: OutStream;
        //streamWriter: DotNet StreamWriter;
        //encoding: DotNet Encoding;
        recTrackingNo: Record "Tracking No.";
        ShiptoResidential: Text[5];
        recPackingHeader: Record "Packing Header";
        recPackingLine: Record "Packing Line";
        i: Integer;
        recWhsShipHeader: Record "Warehouse Shipment Header";
        "********": Integer;
        // Xmlhttp: Automation;
        Result: Boolean;
        //locautXmlDoc: Automation;
        Result1: Boolean;
        //ResultNode: Automation;
        //DecodeXSLT: Automation;
        //locautXmlDoc1: Automation;
        getAllResponseHeaders: Text;
        Position: Integer;
        Position1: Integer;
        data: Text[1000];
        data1: Text[1000];
        int: Integer;
        ImportXmlFile: File;
        XmlINStream: InStream;
        // Xmlhttp1: Automation;
        recSH: Record "Sales Header";
        //xmlHttpre: Automation;
        responseStream: Text[250];
        Picture: BigText;
        Picture1: BigText;
        //Bytes: DotNet Array;
        //Convert: DotNet Convert;
        //MemoryStream: DotNet MemoryStream;
        OStream: OutStream;
        text1: Text[30];
        //Stream: Automation;
        //abpAutBytes: DotNet Array;
        //abpAutMemoryStream: DotNet MemoryStream;
        abpOutStream: OutStream;
        //abpAutConvertBase64: DotNet Convert;
        //abpRecTempBlob: Record TempBlob temporary;
        recCompeny: Record "Company Information";
        recLocation: Record Location;
        recCompanyInfo: Record "Company Information";
        IStream: InStream;
        recItem: Record Item;
        TotalAmount: Decimal;
        TotalAmount1: Text;
        SpecialService: BigText;
        CompanyName: Text[80];
        txtSignature: Text[30];
        intLen: Integer;
        intCount: Integer;
        txtDeliveryAcceptance: Text[250];
        txtCodAmount: Text[30];
        txtInsurance: Text[250];
        txtInsuredAmount: Text[100];
        decInsuredAmount: Decimal;
        SpecialService1: Text[1000];
        txtInsurance1: Text[1000];
        Pos: Integer;
        Pos1: Integer;
        txtAmountString: Text[1024];
        blnGenerateNote: Boolean;
        WhseActivLine: Record "Warehouse Activity Line";
        cuNOPPoratal: Codeunit "Whse.-Act.-RegisterWe (Yes/No)";
        CustNo: Code[20];
        ReturnString: BigText;
        txtCOD: Text[10];
        UPSUSERNAME: Label 'silktex';
        UPSPASSWORD: Label 'Crafts12';
        UPSLICENCE: Label 'ACE923D1E3142AC6';
        cdPickingNo: Code[20];
    begin
        recPackingHeader.RESET;
        //recPackingHeader.SETRANGE("Source Document Type",recPackingHeader."Source Document Type"::"Warehouse Shipment");
        recPackingHeader.SETRANGE("Source Document No.", recWhsShipHeaderNo);
        recPackingHeader.SETRANGE("Void Entry", FALSE);
        IF recPackingHeader.FINDFIRST THEN
            recPackingLine.RESET;
        //recPackingLine.SETRANGE("Source Document Type",recPackingLine."Source Document Type"::"Warehouse Shipment");
        recPackingLine.SETRANGE("Source Document No.", recWhsShipHeaderNo);
        recPackingLine.SETRANGE("Packing No.", recPackingHeader."Packing No.");
        recPackingLine.SETRANGE("Line No.", LineNo);
        IF recPackingLine.FINDFIRST THEN
            ShipmentTrackingNo := recPackingLine."Tracking No.";

        recWhsShipHeader.RESET;
        recWhsShipHeader.SETRANGE("No.", recWhsShipHeaderNo);
        IF recWhsShipHeader.FINDFIRST THEN BEGIN //recWhsShipHeader BEGIN
                                                 ///***************************************************************************************
            //FEDEX BEGIN
            IF recWhsShipHeader."Shipping Agent Code" = 'FEDEX' THEN BEGIN
                ShipingAgentCode := 'FEDEX';
                //IF recWhsShipHeader."Tracking No."='' THEN  BEGIN //Tracking No. BEGIN
                IF ShipmentTrackingNo = '' THEN BEGIN //Tracking No. BEGIN

                    IF recWhsShipHeader."Track On Header" THEN BEGIN //TrackOnHeader BEGIN
                        recWhseShipLine.RESET;
                        recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
                        IF recWhseShipLine.FIND('-') THEN;
                        intDate := DATE2DMY(recWhsShipHeader."Shipment Date", 1);
                        intMonth := DATE2DMY(recWhsShipHeader."Shipment Date", 2);
                        intYear := DATE2DMY(recWhsShipHeader."Shipment Date", 3);
                        txtDate := FORMAT(intDate);
                        txtMonth := FORMAT(intMonth);
                        txtYear := FORMAT(intYear);
                        IF intYear < 100 THEN
                            txtYear := '20' + txtYear;
                        IF STRLEN(txtMonth) < 2 THEN
                            txtMonth := '0' + txtMonth;
                        IF STRLEN(txtDate) < 2 THEN
                            txtDate := '0' + txtDate;
                        recSalesHeader.RESET;
                        IF recSalesHeader.GET(recWhseShipLine."Source Subtype", recWhseShipLine."Source No.") THEN;
                        recCompanyInfo.GET;
                        IF recSalesHeader."Ship-to Code" <> '' THEN BEGIN

                            recCustomer.GET(recSalesHeader."Sell-to Customer No.");
                            recShiptoAddress.GET(recSalesHeader."Sell-to Customer No.", recSalesHeader."Ship-to Code");
                            ShiptoName := recShiptoAddress.Name;
                            ShiptoAddress := recShiptoAddress.Address;
                            ShiptoAddress2 := recShiptoAddress."Address 2";
                            ShiptoCity := recShiptoAddress.City;
                            ShiptoState := recShiptoAddress.County;
                            ShiptoAccount := recShiptoAddress."Shipping Account No.";
                            IF ShiptoAccount = '' THEN
                                ShiptoAccount := recCustomer."Shipping Account No.";
                            IF recShiptoAddress."Third Party" THEN
                                txtPaymentType := 'THIRD_PARTY';
                            ShiptoPostCode := recShiptoAddress."Post Code";
                            ShiptoCountry := recShiptoAddress."Country/Region Code";
                            ShiptoEmail := recShiptoAddress."E-Mail";
                            ShiptoContact := recShiptoAddress.Contact;
                            ShiptoPhone := recShiptoAddress."Phone No.";
                            ShiptoResidential := 'false';
                            IF recShiptoAddress.Residential THEN
                                ShiptoResidential := 'true';
                        END ELSE BEGIN
                            recCustomer.GET(recSalesHeader."Sell-to Customer No.");
                            ShiptoName := recCustomer.Name;
                            ShiptoAddress := recCustomer.Address;
                            ShiptoAddress2 := recCustomer."Address 2";
                            ShiptoCity := recCustomer.City;
                            ShiptoState := recCustomer.County;
                            ShiptoAccount := recCustomer."Shipping Account No.";
                            ShiptoPostCode := recCustomer."Post Code";

                            ShiptoCountry := recCustomer."Country/Region Code";
                            ShiptoEmail := recCustomer."E-Mail";
                            ShiptoContact := recCustomer.Contact;
                            ShiptoPhone := recCustomer."Phone No.";
                            ShiptoResidential := 'false';
                            IF recCustomer.Residential THEN
                                ShiptoResidential := 'true';
                        END;

                        ShiptoName := AttributetoString(ShiptoName);
                        ShiptoAddress := AttributetoString(ShiptoAddress);
                        ShiptoAddress2 := AttributetoString(ShiptoAddress2);
                        ShiptoEmail := AttributetoString(ShiptoEmail);
                        ShiptoContact := AttributetoString(ShiptoContact);

                        recLocation.GET(recSalesHeader."Location Code");
                        //ShiptoAccount:=recLocation."FedEx Account";
                        //ShiptoAccount:=AttributetoString(ShiptoAccount);


                        recShipAgentService.GET(recWhsShipHeader."Shipping Agent Code", recWhsShipHeader."Shipping Agent Service Code");
                        txtShipService := recShipAgentService.Description;

                        recPackingHeader.RESET;
                        //recPackingHeader.SETRANGE("Source Document Type",recPackingHeader."Source Document Type"::"Warehouse Shipment");
                        recPackingHeader.SETRANGE("Source Document No.", recWhsShipHeader."No.");
                        IF recPackingHeader.FINDFIRST THEN
                            recPackingHeader.CALCFIELDS("Gross Weight");
                        recPackingHeader.CALCFIELDS("No. of Boxes");
                        recPackingLine.RESET;
                        //recPackingLine.SETRANGE("Source Document Type",recPackingLine."Source Document Type"::"Warehouse Shipment");
                        recPackingLine.SETRANGE("Source Document No.", recWhsShipHeader."No.");
                        recPackingLine.SETRANGE("Packing No.", recPackingHeader."Packing No.");
                        recPackingLine.SETRANGE("Line No.", LineNo);
                        IF recPackingLine.FINDFIRST THEN
                            recBoxMaster.RESET;
                        IF recBoxMaster.GET(recPackingLine."Box Code") THEN;

                        decNetWeigh := 0;
                        intNo := 0;
                        TotalAmount := 0;
                        recWhseShipLine.RESET;
                        recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
                        recWhseShipLine.SETFILTER("Qty. to Ship", '<>%1', 0);
                        IF recWhseShipLine.FIND('-') THEN BEGIN
                            REPEAT
                                recItem.GET(recWhseShipLine."Item No.");
                                decNetWeigh := decNetWeigh + recWhseShipLine."Qty. to Ship" * recItem.Weight;
                                intNo += 1;
                                recSalesLine.RESET;
                                recSalesLine.SETRANGE("Document No.", recWhseShipLine."Source No.");
                                recSalesLine.SETRANGE("Line No.", recWhseShipLine."Source Line No.");
                                IF recSalesLine.FIND('-') THEN BEGIN
                                    REPEAT
                                        TotalAmount := TotalAmount + recWhseShipLine."Qty. to Ship" * recSalesLine."Unit Price";
                                    UNTIL recSalesLine.NEXT = 0;
                                END;
                            UNTIL recWhseShipLine.NEXT = 0;
                        END;

                        TotalAmount1 := '';
                        TotalAmount1 := FORMAT(TotalAmount);
                        IF recWhsShipHeader."COD Amount" <> 0 THEN
                            TotalAmount1 := FORMAT(recWhsShipHeader."COD Amount");
                        TotalAmount1 := DELCHR(TotalAmount1, '=', ',');


                        IF recWhsShipHeader."Cash On Delivery" THEN BEGIN //Cash On Delivery BEGIN
                            CLEAR(SpecialService);   //Tarun
                            IF recWhsShipHeader."Signature Required" THEN BEGIN
                                SpecialService.ADDTEXT('<SpecialServicesRequested>' +
                                '<SpecialServiceTypes>COD</SpecialServiceTypes>' +
                                '<SpecialServiceTypes>DELIVERY_ON_INVOICE_ACCEPTANCE</SpecialServiceTypes>' +
                                '<CodDetail>' +
                                '<CodCollectionAmount>' +
                                '<Currency>USD</Currency>' +
                                '<Amount>' + TotalAmount1 + '</Amount>' +
                                '</CodCollectionAmount>' +
                                '<CollectionType>ANY</CollectionType>' +
                                '<FinancialInstitutionContactAndAddress>' +
                                '<Contact>' +
                                '<PersonName>' + ShiptoContact + '</PersonName>' +
                                '<CompanyName>' + ShiptoName + '</CompanyName>' +
                                '<PhoneNumber>' + ShiptoPhone + '</PhoneNumber>' +
                                '</Contact>' +
                                '<Address>' +
                                '<StreetLines>' + ShiptoAddress + ' ' + ShiptoAddress2 + '</StreetLines>' +
                                '<City>' + ShiptoCity + '</City>' +
                                '<StateOrProvinceCode>' + ShiptoState + '</StateOrProvinceCode>' +
                                '<PostalCode>' + ShiptoPostCode + '</PostalCode>' +
                                '<CountryCode>' + ShiptoCountry + '</CountryCode>' +
                                '<Residential>' + ShiptoResidential + '</Residential>' +
                                '</Address>' +
                                '</FinancialInstitutionContactAndAddress>' +
                                '<RemitToName>' + ShiptoContact + '</RemitToName>' +
                                //'</CodDetail>'+
                                '<DeliveryOnInvoiceAcceptanceDetail>' +
                                '<Recipient>' +
                                '<AccountNumber>' + ShiptoAccount + '</AccountNumber>' +
                                '<Contact>' +
                                '<PersonName>' + ShiptoContact + '</PersonName>' +
                               '<CompanyName>' + recCompanyInfo.Name + '</CompanyName>' +
                                '<PhoneNumber>' + ShiptoPhone + '</PhoneNumber>' +
                                '</Contact>' +
                                '<Address>' +
                                '<StreetLines>' + ShiptoAddress + ' ' + ShiptoAddress2 + '</StreetLines>' +
                                '<City>' + ShiptoCity + '</City>' +
                                '<StateOrProvinceCode>' + ShiptoState + '</StateOrProvinceCode>' +
                                '<PostalCode>' + ShiptoPostCode + '</PostalCode>' +
                                '<CountryCode>' + ShiptoCountry + '</CountryCode>' +
                                '<Residential>' + ShiptoResidential + '</Residential>' +
                                '</Address>' +
                                '</Recipient>' +
                                '</DeliveryOnInvoiceAcceptanceDetail>' +
                               '</CodDetail>' +
                                '</SpecialServicesRequested>');
                            END ELSE BEGIN
                                SpecialService.ADDTEXT('<SpecialServicesRequested>' +
                                '<SpecialServiceTypes>COD</SpecialServiceTypes>' +
                                '<CodDetail>' +
                                '<CodCollectionAmount>' +
                                '<Currency>USD</Currency>' +
                                '<Amount>' + TotalAmount1 + '</Amount>' +
                                '</CodCollectionAmount>' +
                                '<CollectionType>ANY</CollectionType>' +
                                '</CodDetail>' +
                                '</SpecialServicesRequested>');
                            END;

                        END;
                        //TrackOnHeader END

                        intLen := SpecialService.LENGTH;
                        FOR intCount := 1 TO 10 DO BEGIN //intCount BEGIN
                            SpecialServiceTxt[intCount] := '';
                        END; //intCount END
                        IF intLen <> 0 THEN
                            SpecialService.GETSUBTEXT(SpecialServiceTxt[1], 1, 200);
                        IF intLen > 200 THEN
                            SpecialService.GETSUBTEXT(SpecialServiceTxt[2], 201, 400);
                        IF intLen > 400 THEN
                            SpecialService.GETSUBTEXT(SpecialServiceTxt[3], 401, 600);
                        IF intLen > 600 THEN
                            SpecialService.GETSUBTEXT(SpecialServiceTxt[4], 601, 800);
                        IF intLen > 800 THEN
                            SpecialService.GETSUBTEXT(SpecialServiceTxt[5], 801, 1000);
                        IF intLen > 1000 THEN
                            SpecialService.GETSUBTEXT(SpecialServiceTxt[6], 1001, 1200);
                        IF intLen > 1200 THEN
                            SpecialService.GETSUBTEXT(SpecialServiceTxt[7], 1201, 1400);
                        IF intLen > 1400 THEN
                            SpecialService.GETSUBTEXT(SpecialServiceTxt[8], 1401, 1600);
                        IF intLen > 1600 THEN
                            SpecialService.GETSUBTEXT(SpecialServiceTxt[9], 1601, 1800);
                        IF intLen > 1800 THEN
                            SpecialService.GETSUBTEXT(SpecialServiceTxt[10], 1801, 2000);


                        // IF ISCLEAR(Xmlhttp) THEN
                        //     Result := CREATE(Xmlhttp, TRUE, TRUE);

                        //Charges Pay By BEGIN
                        IF recPackingHeader."Charges Pay By" = 'SENDER' THEN BEGIN
                            //ResponsibleAccNo:=AccountNo;
                            ResponsibleAccNo := recLocation."FedEx Account";
                            ResponsiblePerson := recLocation.Contact;
                            ResponsibleEmail := recLocation."E-Mail";
                            txtPaymentType := 'SENDER';
                        END ELSE BEGIN
                            ResponsibleAccNo := recCustomer."Shipping Account No.";
                            ResponsiblePerson := recCustomer.Contact;
                            ResponsibleEmail := recCustomer."E-Mail";
                            IF txtPaymentType <> 'THIRD_PARTY' THEN
                                txtPaymentType := 'RECIPIENT';
                        END;
                        //Charges Pay By END
                        ResponsiblePerson := AttributetoString(ResponsiblePerson);
                        ResponsibleEmail := AttributetoString(ResponsibleEmail);


                        decInsuredAmount := recWhsShipHeader."Insurance Amount";
                        IF decInsuredAmount <> 0 THEN
                            txtInsuredAmount := DELCHR(FORMAT(decInsuredAmount), '=', ',')
                        ELSE
                            txtInsuredAmount := '';
                        //Insurance Amount BEGIN
                        IF recWhsShipHeader."Insurance Amount" > 0 THEN BEGIN
                            txtInsurance1 :=
                            '<TotalInsuredValue>' +
                                    '<Currency>USD</Currency>' +
                                    '<Amount>' + (txtInsuredAmount) + '</Amount>' +
                            '</TotalInsuredValue>';

                            txtInsurance :=
                            '<GroupPackageCount>1</GroupPackageCount>' +
                            '<InsuredValue>' +
                                    '<Currency>USD</Currency>' +
                                    '<Amount>' + (txtInsuredAmount) + '</Amount>' +
                            '</InsuredValue>';
                        END ELSE BEGIN
                            txtInsurance := '';
                            txtInsurance1 := '';
                        END;
                        //Insurance Amount END

                        txtShipTime := FORMAT(recWhsShipHeader."Shipment Time", 0, '<Hours24,2><Filler Character,0>:<Minutes,2>:<Seconds,2>');
                        txtSend := ('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://fedex.com/ws/ship/v13">' +
                        '<soapenv:Body>' +
                        '<ProcessShipmentRequest xmlns="http://fedex.com/ws/ship/v13">' +
                        '<WebAuthenticationDetail>' +
                        '<UserCredential>' +
                        '<Key>' + Key + '</Key>' +
                        '<Password>' + Password + '</Password>' +
                        '</UserCredential>' +
                        '</WebAuthenticationDetail>' +
                        '<ClientDetail>' +
                        '<AccountNumber>' + recLocation."FedEx Account" + '</AccountNumber>' +
                        '<MeterNumber>' + MeterNo + '</MeterNumber>' +
                        '</ClientDetail>' +
                        '<TransactionDetail>' +
                        '<CustomerTransactionId>' + recSalesHeader."No." + '</CustomerTransactionId>' +
                        '</TransactionDetail>' +
                        '<Version>' +
                        '<ServiceId>ship</ServiceId>' +
                        '<Major>13</Major>' +
                        '<Intermediate>0</Intermediate>' +
                        '<Minor>0</Minor>' +
                        '</Version>' +
                        '<RequestedShipment>' +
                        '<ShipTimestamp>' + txtYear + '-' + txtMonth + '-' + txtDate + 'T' + txtShipTime + '-05:00</ShipTimestamp>' +
                        '<DropoffType>REGULAR_PICKUP</DropoffType>' +
                        '<ServiceType>' + txtShipService + '</ServiceType>' +
                        '<PackagingType>YOUR_PACKAGING</PackagingType>' +
                        txtInsurance1 +
                        '<Shipper>' +
                        '<AccountNumber>' + recLocation."FedEx Account" + '</AccountNumber>' +
                        '<Contact>' +
                        '<PersonName>' + recLocation.Contact + '</PersonName>' +
                        '<CompanyName>' + recCompeny.Name + '</CompanyName>' +
                        '<PhoneNumber>' + recLocation."Phone No." + '</PhoneNumber>' +
                        '<EMailAddress>' + recLocation."E-Mail" + '</EMailAddress>' +
                        '</Contact>' +
                        '<Address>' +
                        '<StreetLines>' + recLocation.Address + '</StreetLines>' +
                        '<City>' + recLocation.City + '</City>' +
                        '<StateOrProvinceCode>' + recLocation.County + '</StateOrProvinceCode>' +
                        '<PostalCode>' + recLocation."Post Code" + '</PostalCode>' +
                        '<CountryCode>' + recLocation."Country/Region Code" + '</CountryCode>' +
                        '</Address>' +
                        '</Shipper>' +
                        '<Recipient>' +
                        '<AccountNumber>' + ShiptoAccount + '</AccountNumber>' +
                        '<Contact>' +
                        '<PersonName>' + ShiptoContact + '</PersonName>' +
                        '<CompanyName>' + ShiptoName + '</CompanyName>' +
                        '<PhoneNumber>' + ShiptoPhone + '</PhoneNumber>' +
                        '<EMailAddress>' + ShiptoEmail + '</EMailAddress>' +
                        '</Contact>' +
                        '<Address>' +
                        '<StreetLines>' + ShiptoAddress + ' ' + ShiptoAddress2 + '</StreetLines>' +
                        '<City>' + ShiptoCity + '</City>' +
                        '<StateOrProvinceCode>' + ShiptoState + '</StateOrProvinceCode>' +
                        '<PostalCode>' + ShiptoPostCode + '</PostalCode>' +
                        '<CountryCode>' + ShiptoCountry + '</CountryCode>' +
                        '<Residential>' + ShiptoResidential + '</Residential>' +
                        '</Address>' +
                        '</Recipient>' +
                        '<ShippingChargesPayment>' +

                        '<PaymentType>' + txtPaymentType + '</PaymentType>' +
                        '<Payor>' +
                        '<ResponsibleParty>' +
                        '<AccountNumber>' + ResponsibleAccNo + '</AccountNumber>' +
                        '<Contact>' +
                        '<PersonName>' + ResponsiblePerson + '</PersonName>' +
                        '<EMailAddress>' + ResponsibleEmail + '</EMailAddress>' +
                        '</Contact>' +
                        '</ResponsibleParty>' +
                        '</Payor>' +
                        '</ShippingChargesPayment>' +
                        '<LabelSpecification>' +
                        '<LabelFormatType>COMMON2D</LabelFormatType>' +
                        '<ImageType>ZPLII</ImageType>' +
                        '<LabelStockType>STOCK_4X6</LabelStockType>' +
                        '</LabelSpecification>' +
                        '<RateRequestTypes>LIST</RateRequestTypes>' +
                        '<PackageCount>' + FORMAT(recPackingHeader."No. of Boxes") + '</PackageCount>' +
                        '<RequestedPackageLineItems>' +
                        '<SequenceNumber>1</SequenceNumber>' +//txtInsurance+ //Tarun
                         '<Weight>' +
                         '<Units>LB</Units>' +
                         '<Value>' + FORMAT(recPackingHeader."Gross Weight") + '</Value>' +
                         '</Weight>' +
                         '<Dimensions>' +
                         '<Length>' + FORMAT(recBoxMaster.Length) + '</Length>' +
                         '<Width>' + FORMAT(recBoxMaster.Width) + '</Width>' +
                         '<Height>' + FORMAT(recBoxMaster.Height) + '</Height>' +
                         '<Units>IN</Units>' +
                         '</Dimensions>' +
                         '<PhysicalPackaging>BOX</PhysicalPackaging>' +
                         '<ItemDescription>' + recWhseShipLine.Description + '</ItemDescription>' +
                         '<CustomerReferences>' +
                         '<CustomerReferenceType>CUSTOMER_REFERENCE</CustomerReferenceType>' +
                         '<Value>' + recWhsShipHeader."External Document No." + '</Value>' +
                         '</CustomerReferences>' +
                         SpecialServiceTxt[1] + SpecialServiceTxt[2] + SpecialServiceTxt[3] + SpecialServiceTxt[4] + SpecialServiceTxt[5] +
                         SpecialServiceTxt[6] + SpecialServiceTxt[7] + SpecialServiceTxt[8] + SpecialServiceTxt[9] + SpecialServiceTxt[10] +
                         '</RequestedPackageLineItems>' +
                         '</RequestedShipment>' +
                         '</ProcessShipmentRequest>' +
                         '</soapenv:Body>' +
                         '</soapenv:Envelope>');

                    END;//Cash On Delivery END
                END;//Tracking No. END
                EXIT(TRUE);
            END;
            //FEDEX END

            ///***************************************************************************************
            //UPS Start
            IF recWhsShipHeader."Shipping Agent Code" = 'UPS' THEN BEGIN
                ShipingAgentCode := 'UPS';

                // CLEAR(Xmlhttp);
                // IF ISCLEAR(Xmlhttp) THEN
                //     Result := CREATE(Xmlhttp, TRUE, TRUE);
                Position := 0;
                TotalAmount := 0;
                TotalAmount := 0;
                recWhseShipLine.RESET;
                recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
                recWhseShipLine.SETFILTER("Qty. to Ship", '<>%1', 0);
                recWhseShipLine.SETRANGE("Source Type", 37);
                recWhseShipLine.SETRANGE("Source Subtype", 1);
                IF recWhseShipLine.FIND('-') THEN BEGIN
                    REPEAT
                        recSalesLine.RESET;
                        recSalesLine.SETRANGE("Document No.", recWhseShipLine."Source No.");
                        recSalesLine.SETRANGE("Line No.", recWhseShipLine."Source Line No.");

                        IF recSalesLine.FIND('-') THEN BEGIN
                            REPEAT
                                TotalAmount := TotalAmount + recWhseShipLine."Qty. to Ship" * recSalesLine."Unit Price";

                            UNTIL recSalesLine.NEXT = 0;
                        END;
                    UNTIL recWhseShipLine.NEXT = 0;
                END;
                IF recWhsShipHeader."Insurance Amount" <> 0 THEN
                    txtInsurance := 'Yes'
                ELSE
                    txtInsurance := 'No';


                IF recWhsShipHeader."Cash On Delivery" THEN
                    txtCOD := 'Yes'
                ELSE
                    txtCOD := 'No';
                IF recWhsShipHeader."Signature Required" THEN
                    txtSignature := 'Yes'
                ELSE
                    txtSignature := 'No';
                recWhseShipLine.RESET;
                recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
                IF recWhseShipLine.FIND('-') THEN;
                recSalesHeader.RESET;
                IF recSalesHeader.GET(recWhseShipLine."Source Subtype", recWhseShipLine."Source No.") THEN;
                CustNo := recSalesHeader."Sell-to Customer No.";
                TotalAmount1 := FORMAT(recWhsShipHeader."Insurance Amount");
                TotalAmount1 := DELCHR(TotalAmount1, '=', ',');
                txtCodAmount := FORMAT(TotalAmount);
                IF recWhsShipHeader."COD Amount" <> 0 THEN
                    txtCodAmount := FORMAT(recWhsShipHeader."COD Amount");

                txtCodAmount := DELCHR(txtCodAmount, '=', ',');

                recPackingHeader.RESET;
                // recPackingHeader.SETRANGE("Source Document Type",recPackingHeader."Source Document Type"::"Warehouse Shipment");
                recPackingHeader.SETRANGE("Source Document No.", recWhsShipHeaderNo);
                recPackingHeader.SETRANGE("Void Entry", FALSE);
                IF recPackingHeader.FINDFIRST THEN
                    recPackingHeader.CALCFIELDS("No. of Boxes");

                recPackingLine.RESET;
                // recPackingLine.SETRANGE("Source Document Type",recPackingLine."Source Document Type"::"Warehouse Shipment");
                recPackingLine.SETRANGE("Source Document No.", recWhsShipHeaderNo);
                recPackingLine.SETRANGE("Packing No.", recPackingHeader."Packing No.");
                recPackingLine.SETRANGE("Line No.", LineNo);
                IF recPackingLine.FINDFIRST THEN BEGIN
                    IF recPackingHeader."Charges Pay By" = 'SENDER' THEN
                        recWhsShipHeader."Charges Pay By" := recWhsShipHeader."Charges Pay By"::SENDER;
                    IF recPackingHeader."Charges Pay By" = 'RECEIVER' THEN
                        recWhsShipHeader."Charges Pay By" := recWhsShipHeader."Charges Pay By"::RECEIVER;

                    recWhsShipHeader."Box Code" := recPackingLine."Box Code";
                    recWhsShipHeader."Gross Weight" := recPackingLine."Gross Weight";
                    recWhsShipHeader."No. of Boxes" := recPackingHeader."No. of Boxes";
                    recWhsShipHeader.MODIFY;
                END;

                txtSend := ('http://' + webserverIP + '/UPSShipping.ashx?Action=SaveShipping&userName=' + UPSUSERNAME + '&password=' + UPSPASSWORD + '&licenseNo=' + UPSLICENCE + '&wSNo=' + recWhsShipHeader."No." + '&custNo=' + CustNo +
                '&Insu=' + txtInsurance + '&InsuAmount=' + TotalAmount1 + '&COD=' + txtCOD + '&CODAmount=' + txtCodAmount + '&ServiceCode=' + recWhsShipHeader."Shipping Agent Service Code" + '&Signature=' + txtSignature + '&LineNo=' + FORMAT(LineNo));
                EXIT(TRUE);
            END;
            //UPS END

            ///***************************************************************************************
            //ENDICIA Start
            IF recWhsShipHeader."Shipping Agent Code" = 'ENDICIA' THEN BEGIN
                ShipingAgentCode := 'ENDICIA';
                recPackingHeader.RESET;
                //recPackingHeader.SETRANGE("Source Document Type",recPackingHeader."Source Document Type"::"Warehouse Shipment");
                recPackingHeader.SETRANGE("Source Document No.", recWhsShipHeader."No.");
                IF recPackingHeader.FINDFIRST THEN
                    cdPickingNo := recPackingHeader."Packing No.";

                // CLEAR(Xmlhttp);
                // IF ISCLEAR(Xmlhttp) THEN
                //     Result := CREATE(Xmlhttp, TRUE, TRUE);
                Position := 0;
                TotalAmount := 0;
                TotalAmount := 0;
                recWhseShipLine.RESET;
                recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
                recWhseShipLine.SETFILTER("Qty. to Ship", '<>%1', 0);
                recWhseShipLine.SETRANGE("Source Type", 37);
                recWhseShipLine.SETRANGE("Source Subtype", 1);
                IF recWhseShipLine.FIND('-') THEN BEGIN
                    REPEAT
                        recSalesLine.RESET;
                        recSalesLine.SETRANGE("Document No.", recWhseShipLine."Source No.");
                        recSalesLine.SETRANGE("Line No.", recWhseShipLine."Source Line No.");
                        IF recSalesLine.FIND('-') THEN BEGIN
                            REPEAT
                                TotalAmount := TotalAmount + recWhseShipLine."Qty. to Ship" * recSalesLine."Unit Price";
                            UNTIL recSalesLine.NEXT = 0;
                        END;
                    UNTIL recWhseShipLine.NEXT = 0;
                END;
                IF recWhsShipHeader."Insurance Amount" <> 0 THEN
                    txtInsurance := 'Yes'
                ELSE
                    txtInsurance := 'No';


                IF recWhsShipHeader."Cash On Delivery" THEN
                    txtCOD := 'Yes'
                ELSE
                    txtCOD := 'No';
                IF recWhsShipHeader."Signature Required" THEN
                    txtSignature := 'Yes'
                ELSE
                    txtSignature := 'No';
                recWhseShipLine.RESET;
                recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
                IF recWhseShipLine.FIND('-') THEN;
                recSalesHeader.RESET;
                IF recSalesHeader.GET(recWhseShipLine."Source Subtype", recWhseShipLine."Source No.") THEN;
                CustNo := recSalesHeader."Sell-to Customer No.";
                TotalAmount1 := FORMAT(recWhsShipHeader."Insurance Amount");
                TotalAmount1 := DELCHR(TotalAmount1, '=', ',');
                txtCodAmount := FORMAT(TotalAmount);
                IF recWhsShipHeader."COD Amount" <> 0 THEN
                    txtCodAmount := FORMAT(recWhsShipHeader."COD Amount");

                txtCodAmount := DELCHR(txtCodAmount, '=', ',');

                IF recWhsShipHeader."Label Type" = recWhsShipHeader."Label Type"::Domestic THEN BEGIN
                    txtSend := ('http://silk4:47471/EndeciaHandler.ashx?Action=SaveShipping&COD=' + txtCOD + '&CODAmount=' + txtCodAmount + '&wSNo=' + recWhsShipHeader."No." + '&Insu=' + txtInsurance + '&InsuAmount=' + TotalAmount1 +
                                '&custNo=' + CustNo + '&AdultSign=' + txtSignature + '&MailClass=' + recWhsShipHeader."Shipping Agent Service Code");

                END ELSE
                    IF recWhsShipHeader."Label Type" = recWhsShipHeader."Label Type"::International THEN BEGIN
                        txtSend := ('http://silk4:54444/EndeciaInternational.ashx?Action=SaveShipping&COD=' + txtCOD + '&CODAmount=' + txtCodAmount + '&wSNo=' + recWhsShipHeader."No." + '&Insu=' + txtInsurance + '&InsuAmount=' + TotalAmount1 +
                                    '&custNo=' + CustNo + '&AdultSign=' + txtSignature + '&MailClass=' + recWhsShipHeader."Shipping Agent Service Code" + '&packNo=' + cdPickingNo);
                    END;

                EXIT(TRUE);
            END;
            //ENDICIA END

        END; //recWhsShipHeader END
    end;


    procedure HandheldPrintResponce(recWhsShipHeaderNo: Code[20]; responseText: Text; LineNo: Integer) Return: Text[250]
    var
        recCustomer: Record Customer;
        txtPaymentType: Text[30];
        ResponsibleCountry: Code[10];
        ResponsiblePost: Code[20];
        ResponsibleState: Code[20];
        ResponsibleCity: Code[20];
        ResponsibleAddress: Text[50];
        ResponsiblePhone: Text[30];
        ResponsibleCompany: Text[50];
        ResponsibleEmail: Text[50];
        ResponsiblePerson: Text[50];
        ResponsibleAccNo: Text[30];
        decNetWeigh: Decimal;
        recSalesLine: Record "Sales Line";
        decAmount: Decimal;
        txtAmount: Text[25];
        recSalesHeader: Record "Sales Header";
        recWhseShipLine: Record "Warehouse Shipment Line";
        recBoxMaster: Record "Box Master";
        txtPackageDetail: BigText;
        intNo: Integer;
        txtPackagedet: array[5] of Text[1000];
        intLength: Integer;
        SalesRelease: Codeunit "Release Sales Document";
        txtMessage: Text[500];
        txtYear: Text[10];
        txtMonth: Text[10];
        txtDate: Text[10];
        intDate: Integer;
        intMonth: Integer;
        intYear: Integer;
        recShipAgentService: Record "Shipping Agent Services";
        txtShipService: Text[100];
        recShiptoAddress: Record "Ship-to Address";
        ShiptoName: Text[50];
        ShiptoAddress: Text[50];
        ShiptoAddress2: Text[50];
        ShiptoEmail: Text[50];
        ShiptoPhone: Text[30];
        ShiptoState: Text[30];
        ShiptoCountry: Text[30];
        ShiptoPostCode: Text[30];
        ShiptoContact: Text[50];
        ShiptoAccount: Code[20];
        ShiptoCity: Text[30];
        txtShipTime: Text[50];
        intLineNo: Integer;
        recSalesShipHeader: Record "Sales Shipment Header";
        WhseSetup: Record "Warehouse Setup";
        SpecialServiceTxt: array[10] of Text[1000];
        outFile: File;
        outStream1: OutStream;
        //streamWriter: DotNet StreamWriter;
        //encoding: DotNet Encoding;
        recTrackingNo: Record "Tracking No.";
        ShiptoResidential: Text[5];
        recPackingHeader: Record "Packing Header";
        recPackingLine: Record "Packing Line";
        i: Integer;
        recWhsShipHeader: Record "Warehouse Shipment Header";
        "*************": Integer;
        //Xmlhttp: Automation;
        Result: Boolean;
        //locautXmlDoc: Automation;
        Result1: Boolean;
        //ResultNode: Automation;
        //DecodeXSLT: Automation;
        //locautXmlDoc1: Automation;
        getAllResponseHeaders: Text;
        Position: Integer;
        Position1: Integer;
        data: Text[1000];
        data1: Text[1000];
        int: Integer;
        ImportXmlFile: File;
        XmlINStream: InStream;
        //Xmlhttp1: Automation;
        recSH: Record "Sales Header";
        //xmlHttpre: Automation;
        responseStream: Text[250];
        Picture: BigText;
        Picture1: BigText;
        //Bytes: DotNet Array;
        //Convert: DotNet Convert;
        //MemoryStream: DotNet MemoryStream;
        OStream: OutStream;
        text1: Text[30];
        //Stream: Automation;
        //abpAutBytes: DotNet Array;
        //abpAutMemoryStream: DotNet MemoryStream;
        abpOutStream: OutStream;
        //abpAutConvertBase64: DotNet Convert;
        //abpRecTempBlob: Record TempBlob temporary;
        recCompeny: Record "Company Information";
        recLocation: Record Location;
        recCompanyInfo: Record "Company Information";
        IStream: InStream;
        recItem: Record Item;
        TotalAmount: Decimal;
        TotalAmount1: Text;
        SpecialService: BigText;
        CompanyName: Text[80];
        txtSignature: Text[30];
        intLen: Integer;
        intCount: Integer;
        txtDeliveryAcceptance: Text[250];
        txtCodAmount: Text[30];
        txtInsurance: Text[250];
        txtInsuredAmount: Text[100];
        decInsuredAmount: Decimal;
        SpecialService1: Text[1000];
        txtInsurance1: Text[1000];
        Pos: Integer;
        Pos1: Integer;
        txtAmountString: Text[1024];
        blnGenerateNote: Boolean;
        WhseActivLine: Record "Warehouse Activity Line";
        cuNOPPoratal: Codeunit "Whse.-Act.-RegisterWe (Yes/No)";
        rptTest: Report "FedEx Label Report Handheld";
    begin
        // recWhsShipHeader.RESET;
        // recWhsShipHeader.SETRANGE("No.", recWhsShipHeaderNo);
        // IF recWhsShipHeader.FINDFIRST THEN BEGIN
        //     //FEDEX Start
        //     IF recWhsShipHeader."Shipping Agent Code" = 'FEDEX' THEN BEGIN

        //         Position := STRPOS(responseText, '<Image>');
        //         Position := Position + 7;
        //         Position1 := STRPOS(responseText, '</Image>');
        //         CLEAR(Picture1);
        //         Picture1.ADDTEXT(responseText);
        //         Picture1.GETSUBTEXT(Picture1, Position, Position1 - Position);
        //         Bytes := Convert.FromBase64String(Picture1);
        //         MemoryStream := MemoryStream.MemoryStream(Bytes);
        //         recWhsShipHeader.Picture.CREATEOUTSTREAM(OStream);
        //         MemoryStream.WriteTo(OStream);
        //         WhseSetup.GET();

        //         recPackingHeader.RESET;
        //         ///recPackingHeader.SETRANGE("Source Document Type",recPackingHeader."Source Document Type"::"Warehouse Shipment");
        //         recPackingHeader.SETRANGE("Source Document No.", recWhsShipHeader."No.");
        //         IF recPackingHeader.FINDFIRST THEN
        //             recPackingHeader.CALCFIELDS("Gross Weight");
        //         recPackingHeader.CALCFIELDS("No. of Boxes");
        //         txtPaymentType := recPackingHeader."Charges Pay By";

        //         IF txtPaymentType = 'SENDER' THEN BEGIN
        //             IF STRPOS(responseText, '<RateType>PAYOR_LIST_PACKAGE</RateType>') > 0 THEN BEGIN
        //                 Pos := STRPOS(responseText, '<RateType>PAYOR_LIST_PACKAGE</RateType>');
        //                 Pos1 := Pos + 1000;
        //                 txtAmountString := COPYSTR(responseText, Pos, Pos1 - Pos);
        //                 Position := STRPOS(txtAmountString, '<TotalNetFedExCharge>');
        //                 Position := Position + 53;
        //                 Position1 := STRPOS(txtAmountString, '</Amount></TotalNetFedExCharge>');
        //                 txtAmount := COPYSTR(txtAmountString, Position, Position1 - Position);

        //                 txtAmount := COPYSTR(txtAmountString, Position, Position1 - Position);
        //                 EVALUATE(decAmount, txtAmount);
        //             END ELSE BEGIN
        //                 Position := STRPOS(responseText, '<TotalNetFedExCharge>');
        //                 Position := Position + 53;
        //                 Position1 := STRPOS(responseText, '</Amount></TotalNetFedExCharge>');
        //                 txtAmount := COPYSTR(responseText, Position, Position1 - Position);
        //                 EVALUATE(decAmount, txtAmount);
        //             END;
        //         END;

        //         Position := STRPOS(responseText, '<TrackingNumber>');
        //         Position := Position + 16;
        //         Position1 := STRPOS(responseText, '</TrackingNumber>');
        //         txtAmount := COPYSTR(responseText, Position, Position1 - Position);
        //         recWhsShipHeader."Tracking No." := txtAmount;
        //         recWhsShipHeader.MODIFY(FALSE);

        //         recWhseShipLine.RESET;
        //         recWhseShipLine.SETRANGE("No.", recWhsShipHeader."No.");
        //         IF recWhseShipLine.FINDFIRST THEN;

        //         recSalesHeader.RESET;
        //         IF recSalesHeader.GET(recWhseShipLine."Source Subtype", recWhseShipLine."Source No.") THEN;

        //         SalesRelease.Reopen(recSalesHeader);
        //         recSalesHeader.SetHideValidationDialog(TRUE);
        //         recSalesHeader.VALIDATE("Tracking No.", recWhsShipHeader."Tracking No.");
        //         recSalesHeader.VALIDATE("Tracking Status", recWhsShipHeader."Tracking Status");
        //         recSalesHeader.VALIDATE("No. of Boxes", recPackingHeader."No. of Boxes");


        //         IF txtPaymentType = 'SENDER' THEN BEGIN
        //             recSalesLine.RESET;
        //             recSalesLine.SETRANGE("Document Type", recSalesLine."Document Type"::Order);
        //             recSalesLine.SETRANGE("Document No.", recSalesHeader."No.");
        //             IF recSalesLine.FIND('+') THEN BEGIN
        //                 intLineNo := recSalesLine."Line No.";
        //                 recSalesLine.INIT;
        //                 recSalesLine.VALIDATE("Document Type", recSalesHeader."Document Type");
        //                 recSalesLine.VALIDATE("Document No.", recSalesHeader."No.");
        //                 recSalesLine.VALIDATE(Type, recSalesLine.Type::Resource);
        //                 recSalesLine.VALIDATE("Line No.", intLineNo + 10000);
        //                 recSalesLine.VALIDATE("No.", 'FREIGHT');
        //                 recSalesLine.VALIDATE(Description, 'Against Warehouse shipment No. ' + recWhsShipHeader."No.");
        //                 recSalesLine.VALIDATE(Quantity, 1);
        //                 recSalesLine.VALIDATE("Unit Price", decAmount + recWhsShipHeader."Handling Charges" + recWhsShipHeader."Insurance Charges");
        //                 recSalesLine.INSERT;
        //             END;
        //         END;
        //         recSalesHeader.MODIFY;
        //         SalesRelease.RUN(recSalesHeader);

        //         recPackingHeader.RESET;
        //         //recPackingHeader.SETRANGE("Source Document Type",recPackingHeader."Source Document Type"::"Warehouse Shipment");
        //         recPackingHeader.SETRANGE("Source Document No.", recWhsShipHeader."No.");
        //         IF recPackingHeader.FINDFIRST THEN BEGIN
        //             recPackingHeader."Freight Amount" := decAmount;
        //             recPackingHeader."Tracking No." := txtAmount;
        //             recPackingHeader."Sales Order No." := recSalesHeader."No.";
        //             recPackingHeader."Service Name" := 'FEDEX';
        //             //recPackingHeader."Charges Pay By":=txtPaymentType;
        //             recPackingHeader."Handling Charges" := recWhsShipHeader."Handling Charges";
        //             recPackingHeader."Insurance Charges" := recWhsShipHeader."Insurance Charges";
        //             recPackingHeader."Cash On Delivery" := recWhsShipHeader."Cash On Delivery";
        //             recPackingHeader."Signature Required" := recWhsShipHeader."Signature Required";
        //             recPackingHeader."Shipping Agent Service Code" := recWhsShipHeader."Shipping Agent Service Code";
        //             recPackingHeader."Shipping Account No" := recWhsShipHeader."Shipping Account No.";
        //             recPackingHeader."COD Amount" := recWhsShipHeader."COD Amount";
        //             recPackingHeader."Insurance Value" := recWhsShipHeader."Insurance Amount";
        //             //recPackingHeader."Third Party" :=    recWhsShipHeader."Third Party";
        //             //recPackingHeader."Third Party Account No." :=    recWhsShipHeader."Third Party Account No.";
        //             recPackingHeader.MODIFY;

        //             recPackingLine.RESET;
        //             //recPackingLine.SETRANGE("Source Document Type",recPackingLine."Source Document Type"::"Warehouse Shipment");
        //             recPackingLine.SETRANGE("Source Document No.", recWhsShipHeader."No.");
        //             recPackingLine.SETRANGE("Packing No.", recPackingHeader."Packing No.");
        //             recPackingLine.SETRANGE("Line No.", LineNo);
        //             IF recPackingLine.FINDFIRST THEN BEGIN
        //                 recPackingLine."Sales Order No." := recSalesHeader."No.";
        //                 recPackingLine."Shipping Agent Service Code" := recWhsShipHeader."Shipping Agent Service Code";
        //                 recPackingLine."Tracking No." := txtAmount;
        //                 Bytes := Convert.FromBase64String(Picture1);
        //                 MemoryStream := MemoryStream.MemoryStream(Bytes);
        //                 recPackingLine.Image.CREATEOUTSTREAM(OStream);
        //                 MemoryStream.WriteTo(OStream);
        //                 recPackingLine.MODIFY;
        //             END;

        //         END;
        //         EXIT('Tracking No. Insert Sucessfuly');
        //     END;
        //     //FEDEX END


        // END;
    end;


    procedure AttributetoString(txtString: Text[250]): Text[250]
    var
        text001: Label '''';
    begin
        txtString := ReplaceString(txtString, '&', '&amp;');
        txtString := ReplaceString(txtString, '<', '&lt;');
        txtString := ReplaceString(txtString, '>', '&gt;');
        txtString := ReplaceString(txtString, '"', '&quot;');
        txtString := ReplaceString(txtString, 'text001', '&apos;');
        EXIT(txtString);
    end;


    procedure ReplaceString(String: Text[250]; FindWhat: Text[250]; ReplaceWith: Text[250]): Text[250]
    begin
        IF STRPOS(String, FindWhat) > 0 THEN BEGIN
            IF FindWhat = '&' THEN BEGIN
                // strPosition:=STRPOS(String,FindWhat);
                String := DELSTR(String, STRPOS(String, FindWhat)) + ReplaceWith + COPYSTR(String, STRPOS(String, FindWhat) + STRLEN(FindWhat))
            END ELSE BEGIN

                WHILE STRPOS(String, FindWhat) > 0 DO
                    String := DELSTR(String, STRPOS(String, FindWhat)) + ReplaceWith + COPYSTR(String, STRPOS(String, FindWhat) + STRLEN(FindWhat));
            END;
        END;
        EXIT(String);
    end;


    procedure HandheldPrintLable(recWhsShipHeaderNo: Code[20]; var txtSend: Text; var txtPrinterName: Text[250]; LineNo: Integer) Return: Text[250]
    begin
        // var
        //     DataText: BigText;
        //     DataStream: InStream;
        //     TrackingNo: Text[30];
        //     Xmlhttp: Automation;
        //     Result: Boolean;
        //     SpecialService: BigText;
        //     intCount: Integer;
        //     txtImageText: Text[1000];
        //     MemoryStream: DotNet MemoryStream;
        //     Bytes: DotNet Array;
        //     Convert: DotNet Convert;
        //     JSonMgt: Codeunit "Dynamics.is JSon Mgt.";
        //     recPackingLine: Record "Packing Line";
        //     recPrinterSelection: Record "Printer Selection";
        //     PrintServerIP: Text[250];
        //     WhseShipHeader: Record "Warehouse Shipment Header";
        //     recTrackingNo: Record "Tracking No.";
        // begin
        //     WhseShipHeader.RESET;
        //     WhseShipHeader.SETRANGE("No.", recWhsShipHeaderNo);
        //     WhseShipHeader.SETRANGE("Shipping Agent Code", 'UPS');
        //     IF WhseShipHeader.FINDFIRST THEN BEGIN
        //         recTrackingNo.RESET;
        //         recTrackingNo.SETRANGE("Warehouse Shipment No", WhseShipHeader."No.");
        //         IF recTrackingNo.FINDFIRST THEN BEGIN
        //             recPackingLine.RESET;
        //             //recPackingLine.SETRANGE("Source Document Type",recPackingLine."Source Document Type"::"Warehouse Shipment");
        //             recPackingLine.SETRANGE(recPackingLine."Source Document No.", WhseShipHeader."No.");
        //             recPackingLine.SETRANGE(recPackingLine."Void Entry", FALSE);
        //             recPackingLine.SETRANGE("Line No.", LineNo);
        //             IF recPackingLine.FINDSET THEN BEGIN
        //                 recPackingLine."Tracking No." := recTrackingNo."Tracking No.";
        //                 recTrackingNo.CALCFIELDS(Image);
        //                 recPackingLine.Image := recTrackingNo.Image;
        //                 recPackingLine.MODIFY;
        //             END;
        //         END;
        //     END;

        //     recPackingLine.RESET;
        //     //recPackingLine.SETRANGE("Source Document Type",recPackingLine."Source Document Type"::"Warehouse Shipment");
        //     recPackingLine.SETRANGE(recPackingLine."Source Document No.", recWhsShipHeaderNo);
        //     recPackingLine.SETRANGE(recPackingLine."Void Entry", FALSE);
        //     recPackingLine.SETRANGE("Line No.", LineNo);
        //     IF recPackingLine.FIND('-') THEN BEGIN
        //         REPEAT
        //             CLEAR(DataText);
        //             recPackingLine.CALCFIELDS(Image);
        //             IF recPackingLine.Image.HASVALUE THEN BEGIN
        //                 recPackingLine.Image.CREATEINSTREAM(DataStream);
        //                 MemoryStream := MemoryStream.MemoryStream();
        //                 COPYSTREAM(MemoryStream, DataStream);
        //                 Bytes := MemoryStream.GetBuffer();
        //                 DataText.ADDTEXT(Convert.ToBase64String(Bytes));

        //                 //sending printing to print server directly
        //                 recPrinterSelection.RESET;
        //                 recPrinterSelection.SETRANGE("User ID", USERID);
        //                 recPrinterSelection.SETRANGE(recPrinterSelection.RocketShip, TRUE);
        //                 IF recPrinterSelection.FINDFIRST THEN BEGIN
        //                     txtPrinterName := recPrinterSelection."RocketShipIt Printer URL";
        //                     PrintServerIP := recPrinterSelection."Label Printer IP";
        //                 END ELSE BEGIN
        //                     recPrinterSelection.RESET;
        //                     recPrinterSelection.SETRANGE(recPrinterSelection.RocketShip, TRUE);
        //                     IF recPrinterSelection.FINDFIRST THEN BEGIN
        //                         txtPrinterName := recPrinterSelection."RocketShipIt Printer URL";
        //                         PrintServerIP := recPrinterSelection."Label Printer IP";
        //                     END;
        //                 END;
        //                 //*****sending print to print server via php url/******************************
        //                 //*****txtPrinterName:= http://192.168.8.11:59998/PrintLabel_XML.php;//********
        //                 //*****PrintServerIP:= 96.56.129.131:59998;//**********************************
        //                 /*
        //                 txtSend := ('<printLabel>'+
        //                             '<cmdType>label</cmdType>'+
        //                             '<rsServerUrl>http://'+PrintServerIP+'</rsServerUrl>'+
        //                             '<base64Label>'+FORMAT(DataText)+'</base64Label>'+
        //                             '</printLabel>');
        //                  */
        //             END;
        //         UNTIL recPackingLine.NEXT = 0;
        //         EXIT('Shipment Level Printed Sucessfuly');
        //     END;

    end;


    procedure GetWarehouseOtherInfo(WhsShipHeaderNo: Code[20]; var decHandlingCharges: Decimal; var decInsuranceCharges: Decimal; var decInsuredValue: Decimal; var blCashOnDelivery: Boolean; var decCODAmount: Decimal; var blSignatureRequired: Boolean; var cdShippingAccountNo: Code[20]; var blThirdParty: Boolean; var cdThirdPartyAccountNo: Code[20]) return: Boolean
    var
        recWhsShipHeader: Record "Warehouse Shipment Header";
    begin
        recWhsShipHeader.RESET;
        recWhsShipHeader.SETRANGE("No.", WhsShipHeaderNo);
        IF recWhsShipHeader.FINDFIRST THEN BEGIN
            decHandlingCharges := recWhsShipHeader."Handling Charges";
            decInsuranceCharges := recWhsShipHeader."Insurance Charges";
            decInsuredValue := recWhsShipHeader."Insurance Amount";
            blCashOnDelivery := recWhsShipHeader."Cash On Delivery";
            decCODAmount := recWhsShipHeader."COD Amount";

            blSignatureRequired := recWhsShipHeader."Signature Required";
            cdShippingAccountNo := recWhsShipHeader."Shipping Account No.";
            blThirdParty := recWhsShipHeader."Third Party";
            cdThirdPartyAccountNo := recWhsShipHeader."Third Party Account No.";
            //recWhsShipHeader.MODIFY;
            EXIT(TRUE);
        END;
    end;


    procedure SalesOrderRelease(SONumber: Code[20]) return: Boolean
    var
        SalesRelease: Codeunit "Release Sales Document";
        recSalesHeader: Record "Sales Header";
    begin
        recSalesHeader.RESET;
        recSalesHeader.SETRANGE(recSalesHeader."Document Type", recSalesHeader."Document Type"::Order);
        recSalesHeader.SETRANGE(recSalesHeader."No.", SONumber);
        IF recSalesHeader.FINDFIRST THEN BEGIN
            SalesRelease.RUN(recSalesHeader);

            IF recSalesHeader.Status = recSalesHeader.Status::Released THEN
                EXIT(TRUE)
            ELSE
                EXIT(FALSE);
        END;
    end;


    procedure UpdateWarehouseOtherInfo(WhsShipHeaderNo: Code[20]; var decHandlingCharges: Decimal; var decInsuranceCharges: Decimal; var decInsuredValue: Decimal; var blCashOnDelivery: Boolean; var decCODAmount: Decimal; var blSignatureRequired: Boolean; var cdShippingAccountNo: Code[20]; var blThirdParty: Boolean; var cdThirdPartyAccountNo: Code[20]) return: Boolean
    var
        recWhsShipHeader: Record "Warehouse Shipment Header";
    begin
        recWhsShipHeader.RESET;
        recWhsShipHeader.SETRANGE("No.", WhsShipHeaderNo);
        IF recWhsShipHeader.FINDFIRST THEN BEGIN
            recWhsShipHeader."Handling Charges" := decHandlingCharges;

            recWhsShipHeader."Insurance Charges" := decInsuranceCharges;
            recWhsShipHeader."Insurance Amount" := decInsuredValue;

            recWhsShipHeader."Cash On Delivery" := blCashOnDelivery;
            recWhsShipHeader."COD Amount" := decCODAmount;

            recWhsShipHeader."Signature Required" := blSignatureRequired;
            recWhsShipHeader."Shipping Account No." := cdShippingAccountNo;

            recWhsShipHeader."Third Party" := blThirdParty;
            recWhsShipHeader."Third Party Account No." := cdThirdPartyAccountNo;
            recWhsShipHeader.MODIFY;
            EXIT(TRUE);
        END;
    end;


    procedure DeletePackingLines(PackingNo: Code[20]; LineNo: Integer) Return: Text[250]
    var
        recPackingLine: Record "Packing Line";
    begin
        recPackingLine.RESET;
        recPackingLine.SETRANGE("Packing No.", PackingNo);
        recPackingLine.SETRANGE("Line No.", LineNo);
        IF recPackingLine.FINDFIRST THEN BEGIN
            recPackingLine.DELETEALL;
            EXIT('Done');
        END;
    end;


    procedure PrintWarehouseShipment(PostedShipmentNO: Code[20]) Return: Text[30]
    var
        NewString: Text[250];
        Path1: Text[250];
        PSH: Record "Sales Shipment Header";
        tempblob: Codeunit "Temp Blob";
        Outstream: OutStream;
        Instream: InStream;
        RecRef: RecordRef;
        Base64Convert: Codeunit "Base64 Convert";
        RetrunValue: Text;
    begin
        //VR code comment will after migration
        NewString := CONVERTSTR(PostedShipmentNO, '/', '-');
        //Path1 := 'D:\Navneet\'+NewString+'.pdf';
        //Path1 := 'C:\HandHeld\PDF\'+NewString+'.pdf';
        // Path1 := 'C:\inetpub\wwwroot\cftNAVLive\PDF\' + NewString + '.pdf';

        PSH.RESET;
        PSH.SETRANGE("No.", PostedShipmentNO);
        IF PSH.FINDFIRST THEN BEGIN
            tempblob.CreateOutStream(Outstream, TextEncoding::UTF8);
            RecRef.GetTable(PSH);

            Report.SaveAs(10077, '', ReportFormat::Pdf, Outstream, RecRef);
            tempblob.CreateInStream(Instream);
            Instream.ReadText(RetrunValue);
            //REPORT.SAVEAS(10077, Path1, PSH);
            //DownloadFromStream(Instream, '', '', '', NewString);
            //EXIT('Report Saved');
            exit(Base64Convert.ToBase64(RetrunValue));
        END ELSE
            EXIT('Report Not Saved');
    end;


    procedure TransferOrderRelease(TONumber: Code[20]) return: Boolean
    var
        recTransferHeader: Record "Transfer Header";
        TransferOrderRelease: Codeunit "Release Transfer Document";
    begin
        recTransferHeader.RESET;
        recTransferHeader.SETRANGE("No.", TONumber);
        IF recTransferHeader.FINDFIRST THEN BEGIN
            TransferOrderRelease.RUN(recTransferHeader);
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    end;


    procedure CalculateInsuredValue(WhseShipLineNo: Code[20])
    var
        recWhseShipLine: Record "Warehouse Shipment Line";
        TotalAmount: Decimal;
        recSalesLine: Record "Sales Line";
        WhseShipHeader: Record "Warehouse Shipment Header";
    begin
        TotalAmount := 0;
        recWhseShipLine.RESET;
        recWhseShipLine.SETRANGE("No.", WhseShipLineNo);
        recWhseShipLine.SETFILTER("Qty. to Ship", '<>%1', 0);
        IF recWhseShipLine.FIND('-') THEN BEGIN
            REPEAT
                recSalesLine.RESET;
                recSalesLine.SETRANGE("Document No.", recWhseShipLine."Source No.");
                recSalesLine.SETRANGE("Line No.", recWhseShipLine."Source Line No.");
                IF recSalesLine.FIND('-') THEN BEGIN
                    REPEAT
                        TotalAmount := TotalAmount + ((recWhseShipLine."Qty. to Ship" * recSalesLine."Unit Price")
                         - (recWhseShipLine."Qty. to Ship" * recSalesLine."Unit Price" * recSalesLine."Line Discount %") / 100);
                    UNTIL recSalesLine.NEXT = 0;
                END;
            UNTIL recWhseShipLine.NEXT = 0;
        END;

        WhseShipHeader.RESET;
        WhseShipHeader.SETRANGE("No.", WhseShipLineNo);
        IF WhseShipHeader.FINDFIRST THEN BEGIN
            WhseShipHeader."Insurance Amount" := ROUND(TotalAmount, 2);
            //WhseShipHeader."COD Amount":=TotalAmount;
            WhseShipHeader.MODIFY;
        END;
    end;


    procedure TOWhsePostRcptYesNo(WhseRcptNo: Code[20]) Result: Boolean
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
        WhsePostReceiptYesNo: Codeunit "Whse.-Post Receipt (Yes/No)";
        WarehouseReceiptLine: Record "Warehouse Receipt Line";
        WhsePostReceipt: Codeunit "Whse.-Post Receipt";
    begin
        WarehouseReceiptLine.RESET;
        WarehouseReceiptLine.SETRANGE("No.", WhseRcptNo);
        IF WarehouseReceiptLine.FINDSET THEN BEGIN
            WhseRcptLine.COPY(WarehouseReceiptLine);
            WhsePostReceipt.RUN(WhseRcptLine);
            WhsePostReceipt.GetResultMessage;
            CLEAR(WhsePostReceipt);
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    end;


    procedure InsertBinInPutAwaylines(TransferOrderNo: Code[20]; PutAwayNo: Code[20]; ItemNo: Code[20]; BinCode: Code[20]; LineNo: Integer) Return: Boolean
    var
        recWarehouseActivityLine: Record "Warehouse Activity Line";
        NewWarehouseActivityLine: Record "Warehouse Activity Line";
    begin
        recWarehouseActivityLine.RESET;
        recWarehouseActivityLine.SETRANGE("Source No.", TransferOrderNo);
        recWarehouseActivityLine.SETRANGE("Activity Type", recWarehouseActivityLine."Activity Type"::"Put-away");
        //recWarehouseActivityLine.SETRANGE("Action Type",recWarehouseActivityLine."Action Type"::Place);
        recWarehouseActivityLine.SETRANGE("No.", PutAwayNo);
        recWarehouseActivityLine.SETRANGE("Item No.", ItemNo);
        recWarehouseActivityLine.SETRANGE("Line No.", LineNo);
        IF recWarehouseActivityLine.FINDSET THEN BEGIN
            recWarehouseActivityLine.VALIDATE("Bin Code", BinCode);
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    end;


    procedure RegisterPutAwayYesNo(TransferOrderNo: Code[20]; PutAwayNo: Code[20]) Result: Boolean
    var
        WhseActivLine: Record "Warehouse Activity Line";
        WhseRegisterPutAwayYesNo: Codeunit "Whse.-Act.-Register (Yes/No)";
        WhseActivityRegister: Codeunit "Whse.-Activity-Register";
    begin
        WhseActivLine.RESET;
        WhseActivLine.SETRANGE("Source No.", TransferOrderNo);
        WhseActivLine.SETRANGE(WhseActivLine."No.", PutAwayNo);
        IF WhseActivLine.FINDSET THEN BEGIN
            //WhseRegisterPutAwayYesNo.RUN(WhseActivLine);
            WhseActivityRegister.RUN(WhseActivLine);
            CLEAR(WhseActivityRegister);

            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    end;


    procedure TransferPostShipment(TransferOrderNo: Code[20]) Result: Boolean
    var
        TransHeader: Record "Transfer Header";
        TransferPostShipment: Codeunit "TransferOrder-Post Shipment";
    begin
        TransHeader.RESET;
        TransHeader.SETRANGE("No.", TransferOrderNo);
        IF TransHeader.FINDSET THEN BEGIN
            TransferPostShipment.RUN(TransHeader);
            CLEAR(TransferPostShipment);
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    end;


    procedure TransferPostReceipt(TransferOrderNo: Code[20]) Result: Boolean
    var
        TransHeader: Record "Transfer Header";
        TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
    begin
        TransHeader.RESET;
        TransHeader.SETRANGE("No.", TransferOrderNo);
        IF TransHeader.FINDSET THEN BEGIN
            TransferPostReceipt.RUN(TransHeader);
            CLEAR(TransferPostReceipt);
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    end;


    procedure CreateTOWhsRcpt(TransferOrderNo: Code[20]) Result: Boolean
    var
        GetSourceDocInbound: Codeunit "Get Source Doc. INbound_Ext";
        TransHeader: Record "Transfer Header";
    begin
        TransHeader.RESET;
        TransHeader.SETRANGE("No.", TransferOrderNo);
        IF TransHeader.FINDSET THEN BEGIN
            GetSourceDocInbound.CreateFromInbndTransferOrderHandHeld(TransHeader);
            CLEAR(GetSourceDocInbound);
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    end;


    procedure CreateTransferWarehouseShipment(DocumentNo: Code[20]) Result: Boolean
    var
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound_Ext";
        TH: Record "Transfer Header";
    begin
        TH.RESET;
        TH.SETRANGE("No.", DocumentNo);
        IF TH.FINDFIRST THEN BEGIN
            GetSourceDocOutbound.CreateFromOutbndTransferOrderHendheld(TH);
            IF NOT TH.FIND('=><') THEN
                TH.INIT;
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    end;


    procedure CreateTOPackHandHeld(WareHouseNo: Code[20]) ERROR: Text[250]
    var
        WareHouseShipmentHeader: Record "Warehouse Shipment Header";
        RecPackingHead: Record "Packing Header";
        ReleaseWhseShptDoc: Codeunit "Whse.-Shipment Release";
        recWhseShptLines: Record "Warehouse Shipment Line";
        recPackingHeader: Record "Packing Header";
        recPackingLine: Record "Packing Line";
        recTH: Record "Transfer Header";
    begin
        WareHouseShipmentHeader.RESET;
        WareHouseShipmentHeader.SETRANGE(WareHouseShipmentHeader."No.", WareHouseNo);
        IF WareHouseShipmentHeader.FINDFIRST THEN BEGIN
            IF WareHouseShipmentHeader.Status = WareHouseShipmentHeader.Status::Open THEN
                ReleaseWhseShptDoc.Release(WareHouseShipmentHeader);


            WareHouseShipmentHeader.CALCFIELDS("Packing List No.");
            IF WareHouseShipmentHeader."Packing List No." = '' THEN BEGIN
                RecPackingHead.RESET;
                RecPackingHead.INIT;
                RecPackingHead.VALIDATE(RecPackingHead."Source Document Type", RecPackingHead."Source Document Type"::"Warehouse Shipment");
                RecPackingHead.VALIDATE(RecPackingHead."Source Document No.", WareHouseNo);
                recWhseShptLines.RESET;
                recWhseShptLines.SETRANGE(recWhseShptLines."Source Document", recWhseShptLines."Source Document"::"Outbound Transfer");
                recWhseShptLines.SETRANGE(recWhseShptLines."No.", WareHouseNo);
                IF recWhseShptLines.FINDFIRST THEN
                    RecPackingHead.VALIDATE(RecPackingHead."Sales Order No.", recWhseShptLines."Source No.");
                RecPackingHead.INSERT(TRUE);
                WareHouseShipmentHeader."Packing List No." := RecPackingHead."Packing No.";
                WareHouseShipmentHeader.MODIFY;
                ///Release Packing Status BEGIN
                RecPackingHead.Status := RecPackingHead.Status::Release;
                IF recTH.GET(recWhseShptLines."Source No.") THEN
                    RecPackingHead."Charges Pay By" := FORMAT(recTH."Charges Pay By");
                RecPackingHead.MODIFY;
                ///Release Packing Status END

            END ELSE BEGIN
                EXIT('Packing List already created. Do you want to open?');
            END;
        END;
    end;


    procedure TOFinishPickButton(TransferOrderNo: Code[20]) Return: Text[250]
    var
        WhseActivLine: Record "Warehouse Activity Line";
        recWhseActivLine: Record "Warehouse Activity Line";
        recPackingHeader: Record "Packing Header";
    begin
        recPackingHeader.RESET;
        recPackingHeader.SETRANGE(recPackingHeader."Sales Order No.", TransferOrderNo);
        IF NOT recPackingHeader.FINDFIRST THEN
            EXIT('Please Create Pack first ');

        recWhseActivLine.RESET;
        recWhseActivLine.SETRANGE("Source Document", recWhseActivLine."Source Document"::"Outbound Transfer");
        recWhseActivLine.SETRANGE("Source No.", TransferOrderNo);
        IF recWhseActivLine.FINDSET THEN BEGIN
            WhseActivLine.COPY(recWhseActivLine);
            WhseActivLine.FILTERGROUP(3);
            WhseActivLine.SETRANGE(Breakbulk);
            WhseActivLine.FILTERGROUP(0);
            cuIntegrationFedexUPS.WhseRegisterActivityYesNo(WhseActivLine);
            recWhseActivLine.RESET;
            recWhseActivLine.SETCURRENTKEY("Activity Type", "No.", "Sorting Sequence No.");
            recWhseActivLine.FILTERGROUP(4);
            recWhseActivLine.SETRANGE("Activity Type", WhseActivLine."Activity Type");
            recWhseActivLine.SETRANGE("No.", WhseActivLine."No.");
            recWhseActivLine.FILTERGROUP(3);
            recWhseActivLine.SETRANGE(Breakbulk, FALSE);
            recWhseActivLine.FILTERGROUP(0);
        END;
    end;


    procedure UPSTrackingPackingLine(WhseCode: Code[20]; TrackingNo: Text[30]; Image: BigText; LineNo: Integer)
    var
        recTrackingNo: Record "Tracking No.";
        // Bytes: DotNet Array;
        // Convert: DotNet Convert;
        // MemoryStream: DotNet MemoryStream;
        OStream: OutStream;
        //rptTest1: Report "UPS Label Report";
        OrderNo: Code[20];
        WhseShipHeader: Record "Warehouse Shipment Header";
        recPackingLine: Record "Packing Line";
    begin
        WhseShipHeader.RESET;
        WhseShipHeader.SETRANGE("No.", WhseCode);
        WhseShipHeader.SETRANGE("Shipping Agent Code", 'UPS');
        IF WhseShipHeader.FINDFIRST THEN BEGIN
            recPackingLine.RESET;
            recPackingLine.SETRANGE(recPackingLine."Source Document No.", WhseShipHeader."No.");
            recPackingLine.SETRANGE(recPackingLine."Void Entry", FALSE);
            recPackingLine.SETRANGE("Line No.", LineNo);
            IF recPackingLine.FINDSET THEN BEGIN
                recPackingLine."Tracking No." := TrackingNo;
                // Bytes := Convert.FromBase64String(Image); //VR
                // MemoryStream := MemoryStream.MemoryStream(Bytes); //VR
                recPackingLine.Image.CREATEOUTSTREAM(OStream);
                Image.Write(OStream);
                //MemoryStream.WriteTo(OStream); //VR
                recPackingLine.MODIFY;
            END;
        END;
    end;


    procedure MovementWorksheetImport(LocationCode: Code[20]; ItemNo: Code[20]; FromZoneCode: Code[20]; FromBinCode: Code[20]; decQuantity: Decimal; LotNo: Code[20]) Return: Boolean
    var
        WhseWorksheetLine: Record "Whse. Worksheet Line";
        WhseItemTrackingLine: Record "Whse. Item Tracking Line";
    begin
        WhseWorksheetLine.RESET;
        WhseWorksheetLine.SETRANGE("Worksheet Template Name", 'MOVEMENT');
        WhseWorksheetLine.SETRANGE(Name, 'DEFAULT');
        IF WhseWorksheetLine.FINDFIRST THEN
            WhseWorksheetLine.DELETEALL;

        WhseItemTrackingLine.RESET;
        WhseItemTrackingLine.SETRANGE("Source Batch Name", 'MOVEMENT');
        WhseItemTrackingLine.SETRANGE("Source ID", 'DEFAULT');
        WhseItemTrackingLine.SETRANGE("Source Type", 7326);
        IF WhseItemTrackingLine.FINDFIRST THEN
            WhseItemTrackingLine.DELETEALL;

        WhseWorksheetLine.INIT;
        WhseWorksheetLine.VALIDATE("Worksheet Template Name", 'MOVEMENT');
        WhseWorksheetLine.VALIDATE(Name, 'DEFAULT');
        WhseWorksheetLine.VALIDATE("Location Code", LocationCode);
        WhseWorksheetLine.VALIDATE("Item No.", ItemNo);
        WhseWorksheetLine.VALIDATE("Line No.", 10000);
        WhseWorksheetLine.VALIDATE("From Zone Code", FromZoneCode);
        WhseWorksheetLine.VALIDATE("From Bin Code", FromBinCode);
        WhseWorksheetLine.VALIDATE(Quantity, decQuantity);
        //WhseWorksheetLine.VALIDATE("To Zone Code", ToZoneCode);
        //WhseWorksheetLine.VALIDATE("To Bin Code", ToBinCode);
        WhseWorksheetLine.INSERT(TRUE);

        WhseItemTrackingLine.INIT;
        WhseItemTrackingLine.VALIDATE("Source Batch Name", 'MOVEMENT');
        WhseItemTrackingLine.VALIDATE("Source ID", 'DEFAULT');
        WhseItemTrackingLine.VALIDATE("Source Ref. No.", 10000);
        WhseItemTrackingLine.VALIDATE("Source Type", 7326);
        WhseItemTrackingLine.VALIDATE("Location Code", LocationCode);
        WhseItemTrackingLine.VALIDATE("Item No.", ItemNo);
        WhseItemTrackingLine.VALIDATE("Lot No.", LotNo);
        WhseItemTrackingLine.VALIDATE("Quantity (Base)", decQuantity);
        IF WhseItemTrackingLine.INSERT(TRUE) THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;


    procedure CreateMovement(var Result: Text) Return: Boolean
    var
        WhseWkshLine: Record "Whse. Worksheet Line";
        Text001: Label 'There is nothing to handle.';
        //CreateMovFromWhseSource: Report "Whse.-Source - Create Doc Hand";
        WarehouseActivityLine: Record "Warehouse Activity Line";
        ActivityNo: Code[20];
        WhseWorksheetLine: Record "Whse. Worksheet Line";
        WhseActivityRegister: Codeunit "Whse.-Activity-Register";
    begin
        WhseWorksheetLine.RESET;
        WhseWorksheetLine.SETRANGE("Worksheet Template Name", 'MOVEMENT');
        WhseWorksheetLine.SETRANGE(Name, 'DEFAULT');
        IF WhseWorksheetLine.FINDFIRST THEN
            WhseWkshLine.COPY(WhseWorksheetLine);
        WhseWorksheetLine.AutofillQtyToHandle(WhseWkshLine);

        WhseWkshLine.SETFILTER(Quantity, '>0');
        WhseWkshLine.COPYFILTERS(WhseWorksheetLine);
        IF WhseWkshLine.FINDFIRST THEN BEGIN
            //WhseWorksheetLine.MovementCreate(WhseWkshLine);
            // CreateMovFromWhseSource.SetWhseWkshLine(WhseWkshLine);
            //CreateMovFromWhseSource.RUN;
            //ActivityNo := CreateMovFromWhseSource.GetActivityNo;

            WarehouseActivityLine.RESET;
            WarehouseActivityLine.SETRANGE("Activity Type", WarehouseActivityLine."Activity Type"::Movement);
            //WarehouseActivityLine.SETRANGE(WarehouseActivityLine."No.",ActivityNo);
            IF WarehouseActivityLine.FINDLAST THEN
                //CODEUNIT.RUN(CODEUNIT::"Whse.-Act.-Register (Yes/No)",WarehouseActivityLine);
                WhseActivityRegister.RUN(WarehouseActivityLine);
            Result := 'Movement ' + ActivityNo + ' is Created or Registered';
            EXIT(TRUE);
        END ELSE BEGIN
            Result := Text001;
            EXIT(FALSE);
        END;
    end;


    procedure UpdateInvtoryHandheld(LocationCode: Code[20]; ItemCode: Code[20]; LotNo: Code[20]; ItemDesc: Text[50]) Return: Boolean
    var
        ILE: Record "Inventory Status Handheld";
        WarehouseEntry: Record "Warehouse Entry";
    begin
        WarehouseEntry.RESET;
        IF LocationCode <> '' THEN
            WarehouseEntry.SETRANGE("Location Code", LocationCode);
        IF ItemCode <> '' THEN
            WarehouseEntry.SETRANGE("Item No.", ItemCode);
        IF LotNo <> '' THEN
            WarehouseEntry.SETRANGE("Lot No.", LotNo);
        IF ItemDesc <> '' THEN
            WarehouseEntry.SETRANGE("Item Name", '*@%1@*', ItemDesc);
        IF WarehouseEntry.FINDFIRST THEN BEGIN
            REPEAT
                ILE.RESET;
                ILE.SETRANGE("Item No.", WarehouseEntry."Item No.");
                ILE.SETRANGE("Location code", WarehouseEntry."Location Code");
                ILE.SETRANGE("Zone Code", WarehouseEntry."Zone Code");
                ILE.SETRANGE("Bin Code", WarehouseEntry."Bin Code");
                ILE.SETRANGE("Lot No.", WarehouseEntry."Lot No.");
                IF NOT ILE.FINDFIRST THEN BEGIN
                    ILE.INIT;
                    ILE."Item No." := WarehouseEntry."Item No.";
                    ILE."Location code" := WarehouseEntry."Location Code";
                    ILE."Zone Code" := WarehouseEntry."Zone Code";
                    ILE."Bin Code" := WarehouseEntry."Bin Code";
                    ILE."Lot No." := WarehouseEntry."Lot No.";
                    IF NOT ILE.INSERT THEN
                        ILE.MODIFY;
                END;
            UNTIL WarehouseEntry.NEXT = 0;
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    end;


    procedure CreateWhsePhyInv(LocationCode: Code[20]; ItemNo: Code[20]; ZoneCode: Code[20]; BinCode: Code[20]; decQuantity: Decimal; LotNo: Code[20]; var WhseDocNo: Code[20]; var WhseLineNo: Integer) Return: Boolean
    var
        WarehouseJournalLine: Record "Warehouse Journal Line";
        WhseJnlBatch: Record "Warehouse Journal Batch";
        NextDocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        LineNo: Integer;
        Location: Record Location;
        Bin: Record Bin;
    begin
        WarehouseJournalLine.RESET;
        WarehouseJournalLine.SETRANGE("Journal Template Name", 'PHYSINVT');
        WarehouseJournalLine.SETRANGE("Journal Batch Name", 'SYOSSET');
        WarehouseJournalLine.SETRANGE("Location Code", LocationCode);
        IF WarehouseJournalLine.FINDSET THEN
            WarehouseJournalLine.DELETEALL;


        WarehouseJournalLine.RESET;
        WarehouseJournalLine.SETRANGE("Journal Template Name", 'PHYSINVT');
        WarehouseJournalLine.SETRANGE("Journal Batch Name", 'SYOSSET');
        WarehouseJournalLine.SETRANGE("Location Code", LocationCode);
        IF WarehouseJournalLine.FINDLAST THEN
            LineNo := WarehouseJournalLine."Line No." + 10000
        ELSE
            LineNo := 10000;

        WhseJnlBatch.GET('PHYSINVT', 'SYOSSET', LocationCode);
        IF WhseJnlBatch."No. Series" <> '' THEN
            NextDocNo := NoSeriesMgt.GetNextNo(WhseJnlBatch."No. Series", TODAY, FALSE)
        ELSE
            EXIT(FALSE);

        WarehouseJournalLine.INIT;
        WarehouseJournalLine.VALIDATE("Journal Template Name", 'PHYSINVT');
        WarehouseJournalLine.VALIDATE("Journal Batch Name", 'SYOSSET');
        WarehouseJournalLine.VALIDATE("Source Code", 'WHPHYSINVT');
        WarehouseJournalLine.VALIDATE("Location Code", LocationCode);
        WarehouseJournalLine."Whse. Document No." := NextDocNo;
        WarehouseJournalLine.VALIDATE("Whse. Document Type", WarehouseJournalLine."Whse. Document Type"::"Whse. Phys. Inventory");
        WarehouseJournalLine.VALIDATE("Line No.", LineNo);
        WarehouseJournalLine.VALIDATE("Item No.", ItemNo);
        WarehouseJournalLine.VALIDATE("Registering Date", TODAY);
        Location.GET(LocationCode);
        Bin.GET(Location.Code, Location."Adjustment Bin Code");
        WarehouseJournalLine."From Bin Code" := BinCode;
        WarehouseJournalLine."From Zone Code" := ZoneCode;
        WarehouseJournalLine."From Bin Type Code" := Bin."Bin Type Code";
        WarehouseJournalLine.VALIDATE("To Zone Code", ZoneCode);
        WarehouseJournalLine.VALIDATE("To Bin Code", BinCode);
        WarehouseJournalLine.VALIDATE("Zone Code", ZoneCode);
        WarehouseJournalLine.VALIDATE("Bin Code", BinCode);
        WarehouseJournalLine.VALIDATE("Lot No.", LotNo);
        WarehouseJournalLine.VALIDATE(Quantity, -decQuantity);
        WarehouseJournalLine.VALIDATE("Qty. (Base)", -decQuantity);
        WarehouseJournalLine.VALIDATE("Phys. Inventory", TRUE);
        WarehouseJournalLine."Qty. (Calculated)" := decQuantity;
        WarehouseJournalLine."Qty. (Calculated) (Base)" := decQuantity;

        WhseDocNo := WarehouseJournalLine."Whse. Document No.";
        WhseLineNo := LineNo;
        IF WarehouseJournalLine.INSERT(TRUE) THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;


    procedure RegisterWhsePhyInv(LocationCode: Code[20]; WhseDocNo: Code[20]; WhseLineNo: Integer; var FinalResult: Text) Result: Boolean
    var
        WarehouseJournalLine: Record "Warehouse Journal Line";
        CalcWhseAdjmt: Report "Calculate Whse. Ajst Handheld";
        ItemJournalLine: Record "Item Journal Line";
        IJL: Record "Item Journal Line";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Batch";
        Post: Boolean;
        WhseJnlRegisterBatch: Codeunit "Whse. Jnl.-Register Batch";
        WhsePost: Boolean;
        ItemCode: Code[20];
    begin
        WarehouseJournalLine.RESET;
        WarehouseJournalLine.SETRANGE("Journal Template Name", 'PHYSINVT');
        WarehouseJournalLine.SETRANGE("Journal Batch Name", 'SYOSSET');
        WarehouseJournalLine.SETRANGE("Location Code", LocationCode);
        WarehouseJournalLine.SETRANGE("Whse. Document No.", WhseDocNo);
        WarehouseJournalLine.SETRANGE("Line No.", WhseLineNo);
        IF WarehouseJournalLine.FINDSET THEN BEGIN
            ItemCode := WarehouseJournalLine."Item No.";
            WhsePost := WhseJnlRegisterBatch.RUN(WarehouseJournalLine);
            FinalResult := 'Register ' + FORMAT(WhsePost);
        END;

        IF WhsePost THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;


    procedure CreateItemJunl(LocationCode: Code[20]; ItemCode: Code[20]; var ItemJounlNo: Code[20]) Result: Boolean
    var
        WarehouseJournalLine: Record "Warehouse Journal Line";
        CalcWhseAdjmt: Report "Calculate Whse. Ajst Handheld";
        ItemJournalLine: Record "Item Journal Line";
        IJL: Record "Item Journal Line";
    begin
        //Create Item Journal
        ItemJournalLine.INIT;
        ItemJournalLine."Journal Template Name" := 'ITEM';
        ItemJournalLine."Journal Batch Name" := 'DEFAULT';
        ItemJournalLine."Source Code" := 'ITEMJNL';
        ItemJournalLine."Location Code" := LocationCode;
        IF NOT ItemJournalLine.INSERT THEN BEGIN
            ItemJournalLine.MODIFY;
            CalcWhseAdjmt.SetItemJnlLine(ItemJournalLine);
            CalcWhseAdjmt.SetItemNo(ItemCode);
            CalcWhseAdjmt.RUN;
            CLEAR(CalcWhseAdjmt);
            COMMIT;
        END ELSE BEGIN
            CalcWhseAdjmt.SetItemJnlLine(ItemJournalLine);
            CalcWhseAdjmt.SetItemNo(ItemCode);
            CalcWhseAdjmt.RUN;
            CLEAR(CalcWhseAdjmt);
            COMMIT;
        END;

        IJL.RESET;
        IJL.SETRANGE("Journal Template Name", 'ITEM');
        IJL.SETRANGE("Journal Batch Name", 'DEFAULT');
        IJL.SETRANGE("Source Code", 'ITEMJNL');
        IJL.SETRANGE("Location Code", LocationCode);
        IJL.SETRANGE("Item No.", ItemCode);
        IF IJL.FINDFIRST THEN BEGIN
            ItemJounlNo := IJL."Document No.";
            EXIT(TRUE);
        END ELSE BEGIN
            EXIT(FALSE);
        END;
    end;


    procedure PostItemJunl(LocationCode: Code[20]; ItemCode: Code[20]; ItemJounlNo: Code[20]; var FinalResult: Text) Result: Boolean
    var
        IJL: Record "Item Journal Line";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Batch";
        Post: Boolean;
    begin
        //Post Item Journal
        IJL.RESET;
        IJL.SETRANGE("Journal Template Name", 'ITEM');
        IJL.SETRANGE("Journal Batch Name", 'DEFAULT');
        IJL.SETRANGE("Source Code", 'ITEMJNL');
        IJL.SETRANGE("Location Code", LocationCode);
        IJL.SETRANGE("Item No.", ItemCode);
        IJL.SETRANGE("Document No.", ItemJounlNo);
        IF IJL.FINDFIRST THEN BEGIN
            Post := ItemJnlPostLine.RUN(IJL);
        END;

        IF Post THEN BEGIN
            FinalResult := 'Item Journal Post ' + FORMAT(Post);
            EXIT(TRUE);
        END ELSE BEGIN
            FinalResult := 'Item Journal Post ' + FORMAT(Post);
            EXIT(FALSE);
        END;
    end;


    procedure CreateWhseReclaJunl(LocationCode: Code[20]; ItemNo: Code[20]; ZoneCode: Code[20]; BinCode: Code[20]; decQuantity: Decimal; LotNo: Code[20]; var WhseDocNo: Code[20]; var WhseLineNo: Integer; var TrackingEntryNo: Integer) Return: Boolean
    var
        WarehouseJournalLine: Record "Warehouse Journal Line";
        WhseJnlBatch: Record "Warehouse Journal Batch";
        NextDocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        LineNo: Integer;
        Location: Record Location;
        Bin: Record Bin;
        WhseItemTrackingLine: Record "Whse. Item Tracking Line";
        WhseItemTrackingLine1: Record "Whse. Item Tracking Line";
    begin
        WarehouseJournalLine.RESET;
        WarehouseJournalLine.SETRANGE("Journal Template Name", 'RECLASS');
        WarehouseJournalLine.SETRANGE("Journal Batch Name", 'SYOSSET');
        WarehouseJournalLine.SETRANGE("Location Code", LocationCode);
        IF WarehouseJournalLine.FINDSET THEN BEGIN
            WarehouseJournalLine.DELETEALL;

            WhseItemTrackingLine.RESET;
            WhseItemTrackingLine.SETRANGE("Source Batch Name", 'RECLASS');
            WhseItemTrackingLine.SETRANGE("Source ID", 'SYOSSET');
            WhseItemTrackingLine.SETRANGE("Source Ref. No.", 10000);
            WhseItemTrackingLine.SETRANGE("Source Type", 7311);
            WhseItemTrackingLine.SETRANGE("Location Code", LocationCode);
            WhseItemTrackingLine.SETRANGE("Item No.", ItemNo);
            WhseItemTrackingLine.SETRANGE("Lot No.", LotNo);
            IF WhseItemTrackingLine.FINDSET THEN
                WhseItemTrackingLine.DELETEALL;

        END;

        WarehouseJournalLine.RESET;
        WarehouseJournalLine.SETRANGE("Journal Template Name", 'RECLASS');
        WarehouseJournalLine.SETRANGE("Journal Batch Name", 'SYOSSET');
        WarehouseJournalLine.SETRANGE("Location Code", LocationCode);
        IF WarehouseJournalLine.FINDLAST THEN
            LineNo := WarehouseJournalLine."Line No." + 10000
        ELSE
            LineNo := 10000;

        WhseJnlBatch.GET('RECLASS', 'SYOSSET', LocationCode);
        IF WhseJnlBatch."No. Series" <> '' THEN
            NextDocNo := NoSeriesMgt.GetNextNo(WhseJnlBatch."No. Series", TODAY, FALSE)
        ELSE
            EXIT(FALSE);

        WarehouseJournalLine.INIT;
        WarehouseJournalLine.VALIDATE("Journal Template Name", 'RECLASS');
        WarehouseJournalLine.VALIDATE("Journal Batch Name", 'SYOSSET');
        WarehouseJournalLine.VALIDATE("Source Code", 'WHRCLSSJNL');
        WarehouseJournalLine."Entry Type" := WarehouseJournalLine."Entry Type"::Movement;
        WarehouseJournalLine.VALIDATE("Location Code", LocationCode);
        WarehouseJournalLine."Whse. Document No." := NextDocNo;
        WarehouseJournalLine.VALIDATE("Whse. Document Type", WarehouseJournalLine."Whse. Document Type"::"Whse. Journal");
        WarehouseJournalLine.VALIDATE("Line No.", LineNo);
        WarehouseJournalLine.VALIDATE("Item No.", ItemNo);
        WarehouseJournalLine.VALIDATE("Registering Date", TODAY);
        Location.GET(LocationCode);
        Bin.GET(Location.Code, Location."Adjustment Bin Code");
        WarehouseJournalLine."From Bin Code" := BinCode;
        WarehouseJournalLine."From Zone Code" := ZoneCode;
        WarehouseJournalLine."From Bin Type Code" := 'STORAGE';
        WarehouseJournalLine.VALIDATE("To Zone Code", ZoneCode);
        WarehouseJournalLine.VALIDATE("To Bin Code", BinCode);

        //WarehouseJournalLine.VALIDATE("Zone Code", ZoneCode);
        //WarehouseJournalLine.VALIDATE("Bin Code", BinCode);
        //WarehouseJournalLine.VALIDATE("Lot No.", LotNo);
        WarehouseJournalLine.VALIDATE(Quantity, decQuantity);
        WhseDocNo := WarehouseJournalLine."Whse. Document No.";
        WhseLineNo := LineNo;
        IF WarehouseJournalLine.INSERT(TRUE) THEN;

        WhseItemTrackingLine1.RESET;
        IF WhseItemTrackingLine1.FINDLAST THEN
            TrackingEntryNo := WhseItemTrackingLine1."Entry No." + 1
        ELSE
            TrackingEntryNo := 1;

        WhseItemTrackingLine.INIT;
        WhseItemTrackingLine."Entry No." := TrackingEntryNo;
        WhseItemTrackingLine.VALIDATE("Source Batch Name", 'RECLASS');
        WhseItemTrackingLine.VALIDATE("Source ID", LocationCode);
        WhseItemTrackingLine.VALIDATE("Source Ref. No.", 10000);
        WhseItemTrackingLine.VALIDATE("Source Type", 7311);
        WhseItemTrackingLine.VALIDATE("Location Code", LocationCode);
        WhseItemTrackingLine.VALIDATE("Item No.", ItemNo);
        WhseItemTrackingLine.VALIDATE("Lot No.", LotNo);
        WhseItemTrackingLine.VALIDATE("Quantity (Base)", decQuantity);
        IF WhseItemTrackingLine.INSERT(TRUE) THEN BEGIN
            EXIT(TRUE)
        END ELSE
            EXIT(FALSE);
    end;


    procedure UpdateNewLotReclaJunl(TrackingEntryNo: Integer; WhseDocNo: Code[20]; WhseLineNo: Integer; LocationCode: Code[20]; ItemNo: Code[20]; LotNo: Code[20]; NewLotNo: Code[20]; decQuantity: Decimal) Return: Boolean
    var
        WhseItemTrackingLine: Record "Whse. Item Tracking Line";
    begin
        WhseItemTrackingLine.RESET;
        WhseItemTrackingLine.SETRANGE("Source Batch Name", 'RECLASS');
        WhseItemTrackingLine.SETRANGE("Source ID", LocationCode);
        WhseItemTrackingLine.SETRANGE("Source Ref. No.", WhseLineNo);
        WhseItemTrackingLine.SETRANGE("Source Type", 7311);
        WhseItemTrackingLine.SETRANGE("Location Code", LocationCode);
        WhseItemTrackingLine.SETRANGE("Item No.", ItemNo);
        WhseItemTrackingLine.SETRANGE("Lot No.", LotNo);
        WhseItemTrackingLine.SETRANGE("Entry No.", TrackingEntryNo);
        IF WhseItemTrackingLine.FINDFIRST THEN BEGIN
            WhseItemTrackingLine.VALIDATE("Quantity (Base)", decQuantity);
            WhseItemTrackingLine.VALIDATE("New Lot No.", NewLotNo);
            WhseItemTrackingLine.MODIFY;
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    end;


    procedure RegisterWhseReclaJunl(LocationCode: Code[20]; WhseDocNo: Code[20]; WhseLineNo: Integer; var FinalResult: Text) Result: Boolean
    var
        WarehouseJournalLine: Record "Warehouse Journal Line";
        CalcWhseAdjmt: Report "Calculate Whse. Ajst Handheld";
        ItemJournalLine: Record "Item Journal Line";
        IJL: Record "Item Journal Line";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Batch";
        Post: Boolean;
        WhseJnlRegisterBatch: Codeunit "Whse. Jnl.-Register Batch";
        WhsePost: Boolean;
    begin
        WarehouseJournalLine.RESET;
        WarehouseJournalLine.SETRANGE("Journal Template Name", 'RECLASS');
        WarehouseJournalLine.SETRANGE("Journal Batch Name", 'SYOSSET');
        WarehouseJournalLine.SETRANGE("Location Code", LocationCode);
        WarehouseJournalLine.SETRANGE("Whse. Document No.", WhseDocNo);
        WarehouseJournalLine.SETRANGE("Line No.", WhseLineNo);
        IF WarehouseJournalLine.FINDSET THEN BEGIN
            WhsePost := WhseJnlRegisterBatch.RUN(WarehouseJournalLine);
            FinalResult := 'Register ' + FORMAT(WhsePost);
        END;

        IF WhsePost THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;


    procedure InsertLabelImage(OrderNo: Code[20]; WhseCode: Code[20]; PackingNo: Code[20]; LineNo: Integer; TrackingNo: Text[30]; Image: BigText; TransactionID: Text[30])
    var
        recTrackingNo: Record "Tracking No.";
        // Bytes: DotNet Array;
        // Convert: DotNet Convert;
        // MemoryStream: DotNet MemoryStream;
        OStream: OutStream;
        //rptTest1: Report "UPS Label Report";
        recPackingHeader: Record "Packing Header";
        recPackingLine: Record "Packing Line";
        recWhseHeader: Record "Warehouse Shipment Header";
    begin
        IF recPackingHeader.GET(PackingNo) THEN BEGIN
            recPackingHeader."Tracking No." := TrackingNo;
            recPackingHeader.MODIFY;
            recPackingLine.RESET;
            recPackingLine.SETRANGE(recPackingLine."Packing No.", PackingNo);
            recPackingLine.SETRANGE("Line No.", LineNo);
            recPackingLine.SETRANGE("Tracking No.", TrackingNo);
            IF recPackingLine.FINDFIRST THEN BEGIN
                // Bytes := Convert.FromBase64String(Image); //VR
                // MemoryStream := MemoryStream.MemoryStream(Bytes); //VR
                recPackingLine.Image.CREATEOUTSTREAM(OStream);
                //MemoryStream.WriteTo(OStream); //VR
                Image.Write(OStream);
                recPackingLine.MODIFY;
            END;
        END;

        recWhseHeader.RESET;
        recWhseHeader.SETRANGE("No.", WhseCode);
        IF recWhseHeader.FINDFIRST THEN BEGIN
            recWhseHeader."Tracking No." := TrackingNo;
            recWhseHeader.MODIFY;
        END;

        recTrackingNo.RESET;
        recTrackingNo.SETRANGE(recTrackingNo."Warehouse Shipment No", WhseCode);
        recTrackingNo.SETRANGE("Tracking No.", TrackingNo);
        IF recTrackingNo.FIND('-') THEN BEGIN
            recTrackingNo."Source Document No." := OrderNo;
            recTrackingNo."Transaction No." := TransactionID;
            // Bytes := Convert.FromBase64String(Image); //VR
            // MemoryStream := MemoryStream.MemoryStream(Bytes); //VR
            recTrackingNo.Image.CREATEOUTSTREAM(OStream);
            //MemoryStream.WriteTo(OStream); //VR
            Image.Write(OStream);
            recTrackingNo.MODIFY;
        END;
    end;


    procedure InsertFreightLineinSO(SalesOrderNo: Code[20]; WhsShipHeaderNo: Code[20]; decAmount: Decimal) Result: Boolean
    var
        recSalesHeader: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        SalesLine: Record "Sales Line";
        SalesRelease: Codeunit "Release Sales Document";
        recWhsShipHeader: Record "Warehouse Shipment Header";
        intLineNo: Integer;
    begin
        recWhsShipHeader.RESET;
        recWhsShipHeader.SETRANGE("No.", WhsShipHeaderNo);
        IF recWhsShipHeader.FINDFIRST THEN;
        recSalesHeader.RESET;
        recSalesHeader.SETRANGE("Document Type", recSalesHeader."Document Type"::Order);
        recSalesHeader.SETRANGE("No.", SalesOrderNo);
        IF recSalesHeader.FINDFIRST THEN BEGIN
            SalesRelease.Reopen(recSalesHeader);
            recSalesHeader.SetHideValidationDialog(TRUE);
            recSalesHeader.VALIDATE("Charges Pay By", recWhsShipHeader."Charges Pay By");
            recSalesHeader.VALIDATE("Tracking No.", recWhsShipHeader."Tracking No.");
            recSalesHeader.VALIDATE("Tracking Status", recWhsShipHeader."Tracking Status");
            recSalesHeader.VALIDATE("Box Code", recWhsShipHeader."Box Code");
            recSalesHeader.VALIDATE("No. of Boxes", recWhsShipHeader."No. of Boxes");
            IF recWhsShipHeader."Charges Pay By" = recWhsShipHeader."Charges Pay By"::SENDER THEN BEGIN
                recSalesLine.RESET;
                recSalesLine.SETRANGE("Document Type", recSalesLine."Document Type"::Order);
                recSalesLine.SETRANGE("Document No.", recSalesHeader."No.");
                IF recSalesLine.FIND('+') THEN BEGIN
                    intLineNo := recSalesLine."Line No.";
                    SalesLine.INIT;
                    SalesLine.VALIDATE("Document Type", recSalesHeader."Document Type");
                    SalesLine.VALIDATE("Document No.", recSalesHeader."No.");
                    SalesLine.VALIDATE(Type, recSalesLine.Type::Resource);
                    SalesLine.VALIDATE("Line No.", intLineNo + 10000);
                    SalesLine.VALIDATE("No.", 'FREIGHT');
                    SalesLine.VALIDATE(Description, 'Against Warehouse shipment No. ' + WhsShipHeaderNo);
                    SalesLine.VALIDATE(Quantity, 1);
                    SalesLine.VALIDATE("Unit Price", decAmount + recWhsShipHeader."Handling Charges" + recWhsShipHeader."Insurance Charges");
                    SalesLine.INSERT;
                END;
            END;
            recSalesHeader.MODIFY;
            SalesRelease.RUN(recSalesHeader);
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    end;


    procedure WarehousePackingSlip(WhseShipmentNo: Code[10]; var DataText: BigText)
    var
        txtSend: Text;
        ComInfo: Record "Company Information";
        SSH: Record "Sales Shipment Header";
        txtLine: Text;
        L: Integer;
        RWAL: Record "Registered Whse. Activity Line";
        DataStream: InStream;
        Result: Boolean;
        txtSendData: array[255] of Text;
        PageCount: Integer;
        MaxLinePerPage: Integer;
        LineCounter: Integer;
        TotalRecCount: Integer;
        ExpectedPageCount: Integer;
        PageCounter: Integer;
        RecCounter: Integer;
    begin
        SSH.RESET;
        SSH.SETRANGE("Warehouse Shipment No.", WhseShipmentNo);
        IF SSH.FINDFIRST THEN;

        MaxLinePerPage := 40;
        L := 365;
        txtLine := '';
        RWAL.RESET;
        RWAL.SETRANGE("Activity Type", RWAL."Activity Type"::Pick);
        RWAL.SETRANGE("Action Type", RWAL."Action Type"::Take);
        RWAL.SETRANGE("Whse. Document Type", RWAL."Whse. Document Type"::Shipment);
        RWAL.SETRANGE("Whse. Document No.", WhseShipmentNo);
        IF RWAL.FINDSET THEN BEGIN
            TotalRecCount := RWAL.COUNT;
            EVALUATE(ExpectedPageCount, FORMAT(ROUND(TotalRecCount / MaxLinePerPage, 1, '>')));
            LineCounter := 0;
            RecCounter := 0;
            PageCounter := 1;
            txtLine := txtLine + HeaderData(WhseShipmentNo, SSH);

            REPEAT
                RecCounter += 1;
                LineCounter += 1;

                L += 20;
                txtLine += '^FX|***Line row Variables***|^FS' +
                          '^FO20,' + FORMAT(L) + '^FD' + RWAL."Lot No." + '^FS' +
                          '^FO180,' + FORMAT(L) + '^FD' + RWAL.Description + '^FS' +
                          '^FO450,' + FORMAT(L) + '^FD' + FORMAT(RWAL.Quantity) + '^FS' +
                          '^FO550,' + FORMAT(L) + '^FD' + RWAL.Description + '^FS';

                IF (LineCounter = MaxLinePerPage) AND (RecCounter <> TotalRecCount) THEN BEGIN
                    txtLine := txtLine + '' + '^XZ';

                    txtLine := txtLine + HeaderData(WhseShipmentNo, SSH);
                    LineCounter := 0;
                    L := 365;
                    PageCounter += 1;
                END;


            UNTIL RWAL.NEXT = 0;

            //txtLine := txtLine+''+'^XZ';
            txtLine := txtLine + '' + '^PQ2^LH0,0^XZ';
        END;
        DataText.ADDTEXT(txtLine);
    end;

    local procedure HeaderData(WhseShipmentNo: Code[20]; SSH: Record "Sales Shipment Header"): Text
    var
        HeaderText: Text;
        ComInfo: Record "Company Information";
        Contact: Record Contact;
    begin
        ComInfo.GET();
        Contact.RESET;
        Contact.SETRANGE(Contact."No.", SSH."Sell-to Contact No.");
        IF Contact.FINDFIRST THEN;

        HeaderText := ('^XA' +
                  '^FX|***Label Length & Font Size 20***|^FS' +
                  '^LL1371^PW812' +
                  '^CFG, 20' +
                  '^FB812,1,0,C,0^FO0,10^FDPACKING LIST^FS' +
                  '^CFA,30' +
                  '^FB812,1,0,C,0^FO0,80^FDShipment# ' + WhseShipmentNo + '^FS' +
                  '^CFA,15' +
                  '^FX|***From Variables***|^FS' +
                  '^FO20,110^FDFrom:^FS' +
                  '^FO20,130^FD' + ComInfo.Name + '^FS' +
                  '^FO20,150^FD' + ComInfo.Address + ' ' + ComInfo."Address 2" + '^FS' +
                  '^FO20,170^FD' + ComInfo.City + ' ' + ComInfo.County + ' ' + ComInfo."Post Code" + '^FS' +
                  '^FO20,190^FDPhone:  ' + ComInfo."Phone No." + '^FS' +
                  '^FO20,210^FDemail:  ' + ComInfo."E-Mail" + '^FS' +

                  '^FX|***Ship To variables***|^FS' +
                  '^FO420,110^FDShip To:^FS' +
                  '^FO420,130^FD' + SSH."Ship-to Name" + '^FS' +
                  '^FO420,150^FD' + SSH."Ship-to Address" + ' ' + SSH."Ship-to Address 2" + '^FS' +
                  '^FO420,170^FD' + SSH."Ship-to City" + ' ' + SSH."Ship-to County" + ' ' + SSH."Ship-to Post Code" + '^FS' +
                  '^FO420,190^FDPhone: ' + Contact."Phone No." + '^FS' +
                  '^FO420,210^FDemail: ' + Contact."E-Mail" + '^FS' +

                  '^FX|***Terms and other info***|^FS' +
                  '^FO20,240^FDPO# 212322^FS' +
                  //'^FO20,260^FDPO Date: Dec 9, 2020^FS'+
                  //'^FO20,260^FDTrack# 1Z14X92606421231^FS'+
                  '^FO20,260^FDTrack# ' + FORMAT(SSH."Package Tracking No.") + '^FS' +

                  '^FO420,240^FDTerms: ' + SSH."Payment Terms Code" + '^FS' +
                  '^FO420,260^FDShip Date: ' + FORMAT(SSH."Shipment Date") + '^FS' +
                  '^FO420,280^FDSO# ' + SSH."Order No." + '^FS' +

                  '^FX|***HEADER DARK HORIZONTAL LINE***|^FS' +
                  '^FO3,300^GB800,5,5^FS' +

                   '^FX|***Line Row Labels***|^FS' +
                   '^FO20,320^FDRoll No^FS' +
                   '^FO180,320^FDOur Item^FS' +
                   '^FO450,320^FDQty^FS' +
                   '^FO550,320^FDCustomer Item^FS' +
                   '^FX|***Fixed Line***|^FS' +
                   //'^FO3,345^GB800,1,1^FS'+'');
                   '^FO3,345^GB800,1,1^FS' +
                   '^LH0,150' + '');
        EXIT(HeaderText);
    end;
}

