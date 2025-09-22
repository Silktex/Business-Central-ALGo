report 70007 "Shipped Goods Report Manual"
{
    DefaultLayout = RDLC;
    RDLCLayout = './POSH Report/70007_Report_ShippedGoodsReportManual.rdlc';
    Caption = 'Shipped Goods Report';
    Description = 'Open SO Report';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Salesperson Code", "No.", "Posting Date", "Location Code";
            RequestFilterHeading = 'Sales Invoice Header';
            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(CompanyAddr2; CompanyAddr[2])
            {
            }
            column(CompanyAddr3; CompanyAddr[3])
            {
            }
            column(CompanyAddr4; CompanyAddr[4])
            {
            }
            column(CompanyAddr5; CompanyAddr[5])
            {
            }
            column("Filter"; 'Date Period ' + GETFILTER("Posting Date"))
            {
            }
            column(SalesHeader_Salesperson_Code; "Sales Invoice Header"."Salesperson Code")
            {
            }
            column(Salesperson_Name; SalespersonName)
            {
            }
            column(SalesHeader_Customer_Code; "Sales Invoice Header"."Sell-to Customer No.")
            {
            }
            column(SalesHeader_Sell_to_Contact; "Sales Invoice Header"."Sell-to Contact")
            {
            }
            column(SalesHeader_Sell_to_Contact_Name; "Sales Invoice Header"."Sell-to Contact No.")
            {
            }
            column(SalesHeader_Sell_to_Address; "Sales Invoice Header"."Sell-to Address" + ' ' + "Sales Invoice Header"."Sell-to Address 2" + ', ' + "Sales Invoice Header"."Sell-to City" + ', ' + "Sales Invoice Header"."Sell-to County" + ', ' + "Sales Invoice Header"."Sell-to Post Code")
            {
            }
            column(SalesHeader_Project_Name; "Sales Invoice Header"."Project Name")
            {
            }
            column(SelltocustomerEmail; SelltocustomerEmail)
            {
            }
            column(Sell_to_Contact_Phone_No; SelltoContactPhoneNo)
            {
            }
            column(SalesHeader_Customer_Name; "Sales Invoice Header"."Sell-to Customer Name")
            {
            }
            column(SalesHeader_Order_No; "Sales Invoice Header"."No.")
            {
            }
            column(SalesHeader_Externa_Document_No; "Sales Invoice Header"."External Document No.")
            {
            }
            column(SalesHeader_Order_Date; FORMAT("Sales Invoice Header"."Order Date"))
            {
            }
            column(SalesHeader_Ship_Date; FORMAT("Sales Invoice Header"."Posting Date"))
            {
            }
            column(SalesHeader_Tracking_No; "Sales Invoice Header"."Tracking No.")
            {
            }
            column(Specifier_Name; SpecifierName)
            {
            }
            column(Specifier_Contact; "Sales Invoice Header"."Specifier Contact No.")
            {
            }
            column(Specifier_Contact_Name; SpecifierContactName)
            {
            }
            column(SpecifierContactEmail; SpecifierContactEmail)
            {
            }
            column(Specifier_Location_Code; SpecifierCustomerLocation)
            {
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending) WHERE(Quantity = FILTER(<> 0), Type = FILTER(Item));
                column(SalesLine_Order_Date; FORMAT("Sales Invoice Header"."Order Date"))
                {
                }
                column(SalesLine_Quantity; SOQuantity)
                {
                }
                column(Divi; Divi)
                {
                }
                column(Total; Total)
                {
                }
                column(Item_Code; "Sales Invoice Line"."No.")
                {
                }
                column(Unit_Price; "Sales Invoice Line"."Unit Price")
                {
                }
                column(itemDesc; itemDesc)
                {
                }
                column(AmountSalesOrder; AmountSalesOrder)
                {
                }

                trigger OnAfterGetRecord()
                var
                    recCustomer: Record Customer;
                begin

                    SOQuantity := QuantityOnSO("Document No.", "No.", "Variant Code", "Location Code");
                    AmountSalesOrder := AmountOnSO("Document No.", "No.", "Variant Code", "Location Code");

                    IF recCustomer.GET("Sell-to Customer No.") THEN
                        Divi := recCustomer."Customer Posting Group";
                    IF recItem.GET("No.") THEN
                        itemDesc := recItem.Description;
                end;

                trigger OnPreDataItem()
                begin
                    SETFILTER("No.", '%1', 'P*');
                end;
            }

            trigger OnAfterGetRecord()
            begin

                SalespersonName := '';
                recSalesperson.RESET;
                recSalesperson.SETRANGE(recSalesperson.Code, "Sales Invoice Header"."Salesperson Code");
                IF recSalesperson.FINDFIRST THEN
                    SalespersonName := recSalesperson.Name;

                SelltoContactPhoneNo := '';
                contact.RESET;
                contact.SETRANGE(contact."No.", "Sales Invoice Header"."Sell-to Contact No.");
                IF contact.FINDFIRST THEN begin
                    SelltoContactPhoneNo := contact."Phone No.";
                    SelltocustomerEmail := contact."E-Mail";
                End;

                if SelltocustomerEmail = '' then begin
                    customer.RESET;
                    customer.SETRANGE(customer."No.", "Sales Invoice Header"."Sell-to Customer No.");
                    IF customer.FINDFIRST THEN
                        SelltocustomerEmail := customer."E-Mail";
                end;

                SpecifierContactEmail := '';
                SpecifierContactName := '';
                SpecifierContact.RESET;
                SpecifierContact.SETRANGE("No.", "Sales Invoice Header"."Specifier Contact No.");
                IF SpecifierContact.FINDFIRST THEN BEGIN
                    SpecifierContactEmail := SpecifierContact."E-Mail";
                    SpecifierContactName := SpecifierContact.Name;
                END;
                SpecifierCustomerLocation := '';
                SpecifierName := '';
                SpecifierCustomer.RESET;
                SpecifierCustomer.SETRANGE("No.", "Sales Invoice Header".Specifier);
                IF SpecifierCustomer.FINDFIRST THEN BEGIN
                    SpecifierCustomerLocation := SpecifierCustomer.Address + ' ' + SpecifierCustomer."Address 2" + ', ' + SpecifierCustomer.City + ', ' + SpecifierCustomer.County + ', ' + SpecifierCustomer."Post Code";
                    SpecifierName := SpecifierCustomer.Name;
                END;
            end;

            trigger OnPreDataItem()
            begin
                ///SETRANGE("Order Date",WORKDATE-7,WORKDATE-1);
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

    trigger OnPreReport()
    begin
        CompanyInfo.GET();
        CompanyAddr[1] := CompanyInfo.Name;
        CompanyAddr[2] := CompanyInfo.Address;
        CompanyAddr[3] := CompanyInfo.City + ', ' + CompanyInfo.County + ' ' + CompanyInfo."Post Code";
        CompanyAddr[4] := 'T: ' + CompanyInfo."Phone No.";
        CompanyAddr[5] := 'E: ' + CompanyInfo."E-Mail";
    end;

    var
        recItem: Record Item;
        SOQuantity: Decimal;
        Divi: Text[50];
        Detail: Boolean;
        Total: Boolean;
        Both: Boolean;
        itemDesc: Text[100];
        Explocation: Code[50];
        ExpShortPcs: Boolean;
        SalespersonName: Text[50];
        recSalesperson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyAddr: array[8] of Text[50];
        SelltoContactPhoneNo: Code[50];
        contact: Record Contact;
        customer: Record Customer;
        SelltocustomerEmail: Text[100];
        AmountSalesOrder: Decimal;
        SpecifierContact: Record Contact;
        SpecifierContactName: Text;
        SpecifierContactEmail: Text[100];
        SpecifierCustomer: Record Customer;
        SpecifierCustomerLocation: Text;
        SpecifierName: Text;


    procedure QuantityOnSO(DocNo: Code[20]; ItemNo: Code[20]; VarrientCode: Code[20]; LocationCode: Code[20]): Decimal
    var
        recSalesLine: Record "Sales Invoice Line";
        SoQty: Decimal;
    begin
        SoQty := 0;
        recSalesLine.RESET;
        recSalesLine.SETCURRENTKEY(Type, "No.");
        recSalesLine.SETRANGE(recSalesLine."Document No.", DocNo);
        recSalesLine.SETRANGE(recSalesLine.Type, recSalesLine.Type::Item);
        recSalesLine.SETRANGE(recSalesLine."No.", ItemNo);
        recSalesLine.SETRANGE(recSalesLine."Variant Code", VarrientCode);
        recSalesLine.SETRANGE(recSalesLine."Location Code", LocationCode);
        IF recSalesLine.FINDFIRST THEN
            REPEAT
                SoQty += recSalesLine.Quantity;
            UNTIL recSalesLine.NEXT = 0;
        EXIT(SoQty);
    end;


    procedure AmountOnSO(DocNo: Code[20]; ItemNo: Code[20]; VarrientCode: Code[20]; LocationCode: Code[20]): Decimal
    var
        recSalesLine: Record "Sales Invoice Line";
        SoAmount: Decimal;
    begin
        SoAmount := 0;
        recSalesLine.RESET;
        recSalesLine.SETCURRENTKEY(Type, "No.");
        recSalesLine.SETRANGE(recSalesLine."Document No.", DocNo);
        recSalesLine.SETRANGE(recSalesLine.Type, recSalesLine.Type::Item);
        recSalesLine.SETRANGE(recSalesLine."No.", ItemNo);
        recSalesLine.SETRANGE(recSalesLine."Variant Code", VarrientCode);
        recSalesLine.SETRANGE(recSalesLine."Location Code", LocationCode);
        IF recSalesLine.FINDFIRST THEN
            REPEAT
                SoAmount += recSalesLine.Amount;
            UNTIL recSalesLine.NEXT = 0;
        EXIT(SoAmount);
    end;
}

