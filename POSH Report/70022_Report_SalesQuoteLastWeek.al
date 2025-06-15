report 70022 "Sales Quote Last Week"
{
    DefaultLayout = RDLC;
    RDLCLayout = './POSH Report/70022_Report_SalesQuoteLastWeek.rdlc';
    Caption = 'Sales Quote Last Week';
    Description = 'Sales Quotes Entered in Last Week';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") ORDER(Ascending) WHERE("Document Type" = CONST(Quote));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Order Date", "Salesperson Code", "Location Code", "External Document No.";
            RequestFilterHeading = 'Sales Header';

            // Define columns for basic sales quote details
            column(PrintDetails; PrintDetails)
            {
            }
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
            column(SalesHeader_No; "Sales Header"."No.")
            {
            }
            column(SalesHeader_OrderDate; FORMAT("Sales Header".GETFILTER("Order Date")))
            {
            }
            column(SalesHeader_BiltoName; "Sales Header"."Bill-to Name")
            {
            }
            column(SalesHeader_ExternalDocumentNo; "Sales Header"."External Document No.")
            {
            }
            column(SalesHeader_Salesperson_Code; "Sales Header"."Salesperson Code")
            {
            }
            column(Salesperson_Name; SalespersonName)
            {
            }
            column(SalesHeader_Customer_Code; "Sales Header"."Sell-to Customer No.")
            {
            }
            column(SalesHeader_Sell_to_Contact; "Sales Header"."Sell-to Contact")
            {
            }
            column(SalesHeader_Sell_to_Contact_Name; "Sales Header"."Sell-to Contact No.")
            {
            }
            column(SalesHeader_Sell_to_Address; "Sales Header"."Sell-to Address" + ' ' + "Sales Header"."Sell-to Address 2" + ', ' + "Sales Header"."Sell-to City" + ', ' + "Sales Header"."Sell-to County" + ', ' + "Sales Header"."Sell-to Post Code")
            {
            }
            column(SalesHeader_Project_Name; "Sales Header"."Project Name")
            {
            }
            column(SelltocustomerEmail; SelltocustomerEmail)
            {
            }
            column(Sell_to_Contact_Phone_No; SelltoContactPhoneNo)
            {
            }
            column(SalesHeader_Customer_Name; "Sales Header"."Sell-to Customer Name")
            {
            }
            column(SalesHeader_Order_No; "Sales Header"."No.")
            {
            }
            column(SalesHeader_External_Document_No; "Sales Header"."External Document No.")
            {
            }
            column(SalesHeader_Order_Date_Formatted; FORMAT("Sales Header"."Order Date"))
            {
            }
            column(SalesHeader_Ship_Date; FORMAT("Sales Header"."Shipment Date"))
            {
            }
            column(SalesHeader_Tracking_No; "Sales Header"."Package Tracking No.")
            {
            }
            column(Project_Type; "Project Type")
            {
            }
            column(Project_Name; "Project Description")
            {
            }
            column(Project_Phase; "Project Phase")
            {
            }

            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE(Quantity = FILTER(<> 0), "Outstanding Quantity" = FILTER(<> 0), Type = FILTER(Item));
                RequestFilterFields = "No.";

                // Define columns for sales line details related to the sales quote
                column(SalesLine_Order_Date; FORMAT("Sales Header"."Order Date"))
                {
                }
                column(SalesLine_No; "Sales Line"."No.")
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
                column(SalesLine_OutstandingQty_Base; SOQuantityRem)
                {
                }
                column(ItemDesc; itemDesc)
                {
                }
                column(SalesHeader_LocationCode; "Sales Line"."Location Code")
                {
                }

                trigger OnAfterGetRecord()
                var
                    recCustomer: Record Customer;
                begin
                    SalespersonName := '';
                    recSalesperson.RESET;
                    recSalesperson.SETRANGE(Code, "Sales Header"."Salesperson Code");
                    IF recSalesperson.FINDFIRST THEN
                        SalespersonName := recSalesperson.Name;

                    SOQuantity := QuantityOnSO("Document No.", "No.", "Variant Code", "Location Code");

                    IF recCustomer.GET("Sell-to Customer No.") THEN
                        Divi := recCustomer."Customer Posting Group";

                    SOQuantityRem := QuantityOnSORem("Document No.", "No.", "Variant Code", "Location Code");

                    IF recItem.GET("No.") THEN
                        itemDesc := recItem.Description;

                    SelltocustomerEmail := '';
                    SelltoContactPhoneNo := '';
                    contact.RESET;
                    contact.SETRANGE("No.", "Sales Header"."Sell-to Contact No.");
                    IF contact.FINDFIRST THEN BEGIN
                        SelltoContactPhoneNo := contact."Phone No.";
                        SelltocustomerEmail := contact."E-Mail";
                    END;

                    if SelltocustomerEmail = '' then begin
                        customer.RESET;
                        customer.SETRANGE("No.", "Sales Header"."Sell-to Customer No.");
                        IF customer.FINDFIRST THEN
                            SelltocustomerEmail := customer."E-Mail";
                    end;
                end;

            } // <- This closes the "Sales Line" dataitem

            trigger OnPreDataItem()
            var
                FromDate: Date;
                ToDate: Date;
                Today: Date;
                DayOfWeek: Integer;
            begin
                Today := WORKDATE;

                // DayOfWeek: 1 = Monday, 7 = Sunday
                DayOfWeek := DATE2DWY(Today, 1);

                // Get this week's Monday
                ToDate := Today - (DayOfWeek - 1);

                // Get last week's Monday
                FromDate := ToDate - 7;

                SETRANGE("Order Date", FromDate, ToDate - 1); // up to Sunday
            end;
        } // <- This closes the "Sales Header" dataitem
    } // <- This closes the dataset

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Option)
                {
                    Caption = 'Options';
                    field(PrintDetails; PrintDetails)
                    {
                        Caption = 'Print Details';
                        ApplicationArea = All;
                    }
                    field(Total; Total)
                    {
                        Caption = 'Show Total';
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin

        end;
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
        SOQuantity: Decimal;
        SOQuantityRem: Decimal;
        itemDesc: Text[100];
        SalespersonName: Text[50];
        recSalesperson: Record "Salesperson/Purchaser";
        Divi: Text[50];
        Total: Boolean;
        CompanyInfo: Record "Company Information";
        CompanyAddr: array[8] of Text[50];
        SelltoContactPhoneNo: Code[50];
        contact: Record Contact;
        customer: Record Customer;
        SelltocustomerEmail: Text[100];
        PrintDetails: Boolean;

    procedure QuantityOnSO(DocNo: Code[20]; ItemNo: Code[20]; VarrientCode: Code[20]; LocationCode: Code[20]): Decimal
    var
        recSalesLine: Record "Sales Line";
        SoQty: Decimal;
    begin
        SoQty := 0;
        recSalesLine.RESET;
        recSalesLine.SETRANGE("Document No.", DocNo);
        recSalesLine.SETRANGE("Document Type", recSalesLine."Document Type"::Quote);
        recSalesLine.SETRANGE(Type, recSalesLine.Type::Item);
        recSalesLine.SETRANGE("No.", ItemNo);
        recSalesLine.SETRANGE("Variant Code", VarrientCode);
        recSalesLine.SETRANGE("Location Code", LocationCode);
        IF recSalesLine.FINDFIRST THEN
            REPEAT
                SoQty += recSalesLine.Quantity;
            UNTIL recSalesLine.NEXT = 0;
        EXIT(SoQty);
    end;

    procedure QuantityOnSORem(DocNo: Code[20]; ItemNo: Code[20]; VarrientCode: Code[20]; LocationCode: Code[20]): Decimal
    var
        recSalesLine: Record "Sales Line";
        SoQty: Decimal;
    begin
        SoQty := 0;
        recSalesLine.RESET;
        recSalesLine.SETRANGE("Document No.", DocNo);
        recSalesLine.SETRANGE("Document Type", recSalesLine."Document Type"::Quote);
        recSalesLine.SETRANGE(Type, recSalesLine.Type::Item);
        recSalesLine.SETRANGE("No.", ItemNo);
        recSalesLine.SETRANGE("Variant Code", VarrientCode);
        recSalesLine.SETRANGE("Location Code", LocationCode);
        IF recSalesLine.FINDFIRST THEN
            REPEAT
                SoQty += recSalesLine."Outstanding Qty. (Base)";
            UNTIL recSalesLine.NEXT = 0;
        EXIT(SoQty);
    end;

    trigger OnPreReport()
    begin
        CompanyInfo.GET();
        CompanyAddr[1] := CompanyInfo.Name;
        CompanyAddr[2] := CompanyInfo.Address;
        CompanyAddr[3] := CompanyInfo.City + ', ' + CompanyInfo.County + ' ' + CompanyInfo."Post Code";
        CompanyAddr[4] := 'T: ' + CompanyInfo."Phone No.";
        CompanyAddr[5] := 'E: ' + CompanyInfo."E-Mail";
    end;
} // <- This closes the entire report object