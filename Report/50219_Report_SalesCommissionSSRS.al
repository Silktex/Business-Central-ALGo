report 50219 "Sales Commission SSRS"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50219_Report_SalesCommissionSSRS.rdlc';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "Customer Price Group", "Sell-to Customer No.", "Posting Date", "Salesperson Code";
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE(Quantity = FILTER(<> 0));
                RequestFilterFields = "No.";
                column(Document_Type; 'Invoice')
                {
                }
                column(Invoice_No; "Sales Invoice Header"."No.")
                {
                }
                column(InvDT; "Sales Invoice Header"."Posting Date")
                {
                }
                column(CustGroup; recCust."Customer Price Group")
                {
                }
                column(CustPostGroup; recCust."Customer Posting Group")
                {
                }
                column(CustCode; "Sales Invoice Header"."Sell-to Customer No.")
                {
                }
                column(Cust_Name; "Sales Invoice Header"."Sell-to Customer Name")
                {
                }
                column(SKU_; "Sales Invoice Line"."No.")
                {
                }
                column(ItemCode; "Sales Invoice Line".Description)
                {
                }
                column(Project_Name; "Sales Invoice Header"."Project Name")
                {
                }
                column(Shipped; "Sales Invoice Line".Quantity)
                {
                }
                column(P_Line; recItem."Product Line")
                {
                }
                column(Std; SILdecUnitPrice)
                {
                }
                column(Inv; "Sales Invoice Line"."Unit Price")
                {
                }
                column(Total; "Sales Invoice Line"."Unit Price" * "Sales Invoice Line".Quantity)
                {
                }
                column(SP_Code; SILSPCode)
                {
                }
                column(SalesPerson; SILSPName)
                {
                }
                column(Discount; SILdecUnitDiscPrice)
                {
                }
                column(InvDisc; "Sales Invoice Line"."Line Discount Amount")
                {
                }
                column(Per; SILdecComDisc)
                {
                }
                column(ComAmt; SILdecComDisc * SILdecUnitDiscPrice * "Sales Invoice Line".Quantity / 100)
                {
                }
                column(Campaign; SILCampaign)
                {
                }
                column(SIH_Specifier; "Sales Invoice Header".Specifier)
                {
                }
                column(SIH_SpecifierName; SIHSpecifierName)
                {
                }
                column(SIH_SpecifierAdd; SIHSpecifierAdd)
                {
                }
                column(SIH_SpecifierLocation; SIHSpecifierLocation)
                {
                }
                column(SIH_SpecifierPostCode; SIHSpecifierPostCode)
                {
                }
                column(SIHSpecifierContactName; SIHSpecifierContactName)
                {
                }
                column(SIHSpecifierContactEmail; SIHSpecifierContactEmail)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF NOT (("Sales Invoice Line".Type = "Sales Invoice Line".Type::Item) OR
                      (("Sales Invoice Line".Type = "Sales Invoice Line".Type::Resource) AND ("Sales Invoice Line"."No." = 'MISC'))) THEN
                        EXIT;

                    IF recCust.GET("Sales Invoice Header"."Sell-to Customer No.") THEN;
                    IF recItem.GET("Sales Invoice Line"."No.") THEN;

                    recSalesPrice.RESET;
                    recSalesPrice.SETRANGE(recSalesPrice."Source Type", recSalesPrice."Source Type"::"Customer Price Group");
                    recSalesPrice.SETRANGE(recSalesPrice."Product Type", recSalesPrice."Product Type"::"Item Category");
                    recSalesPrice.SETRANGE(recSalesPrice."Source No.", "Sales Invoice Header"."Customer Price Group");
                    recSalesPrice.SETRANGE(recSalesPrice."Asset No.", "Sales Invoice Line"."Item Category Code");
                    IF recSalesPrice.FIND('+') THEN
                        SILdecUnitPrice := recSalesPrice."Unit Price"
                    ELSE
                        SILdecUnitPrice := recItem."Unit Price";

                    SILdecInvDisc := 0;
                    SILdecUnitDiscPrice := 0;
                    SILdecUnitDiscPrice := (("Sales Invoice Line"."Unit Price" * "Sales Invoice Line".Quantity) - ABS("Sales Invoice Line"."Line Discount Amount") - ABS("Sales Invoice Line"."Inv. Discount Amount")) / "Sales Invoice Line".Quantity;

                    IF SILdecUnitPrice <> 0 THEN
                        SILdecInvDisc := ROUND((SILdecUnitDiscPrice / SILdecUnitPrice - 1) * 100, 0.1)
                    ELSE
                        SILdecInvDisc := 0;
                    IF SILdecInvDisc >= 0 THEN BEGIN
                        recSalesCommision.RESET;
                        recSalesCommision.SETRANGE("Customer Price Group", "Sales Invoice Header"."Customer Price Group");
                        recSalesCommision.SETRANGE("Product Group Code", "Sales Invoice Line"."Item Category Code");
                        recSalesCommision.SETFILTER(recSalesCommision."Discount %", '>=%1', SILdecInvDisc);
                        IF recSalesCommision.FIND('-') THEN
                            SILdecComDisc := recSalesCommision."Commision %"
                        ELSE BEGIN
                            recSalesCommision.RESET;
                            recSalesCommision.SETRANGE("Customer Price Group", '');
                            recSalesCommision.SETRANGE("Product Group Code", '');
                            recSalesCommision.SETFILTER(recSalesCommision."Discount %", '>=%1', SILdecInvDisc);
                            IF recSalesCommision.FIND('-') THEN
                                SILdecComDisc := recSalesCommision."Commision %"
                            ELSE
                                SILdecComDisc := 0;
                        END;
                    END ELSE BEGIN

                        recSalesCommision.RESET;
                        recSalesCommision.SETCURRENTKEY("Customer Price Group", "Product Group Code", "Discount %");
                        recSalesCommision.ASCENDING(FALSE);
                        recSalesCommision.SETRANGE("Customer Price Group", "Sales Invoice Header"."Customer Price Group");
                        recSalesCommision.SETRANGE("Product Group Code", "Sales Invoice Line"."Item Category Code");
                        recSalesCommision.SETFILTER(recSalesCommision."Discount %", '<=%1', SILdecInvDisc);
                        IF recSalesCommision.FIND('-') THEN
                            SILdecComDisc := recSalesCommision."Commision %"
                        ELSE BEGIN
                            recSalesCommision.RESET;
                            recSalesCommision.SETCURRENTKEY("Customer Price Group", "Product Group Code", "Discount %");
                            recSalesCommision.ASCENDING(FALSE);
                            recSalesCommision.SETRANGE("Customer Price Group", '');
                            recSalesCommision.SETRANGE("Product Group Code", '');
                            recSalesCommision.SETFILTER(recSalesCommision."Discount %", '<=%1', SCLdecInvDisc);
                            IF recSalesCommision.FIND('-') THEN
                                SILdecComDisc := recSalesCommision."Commision %"
                            ELSE
                                SILdecComDisc := 0;
                        END;
                    END;

                    IF "Sales Invoice Header"."Commission Override" THEN
                        SILdecComDisc := "Sales Invoice Header"."Commision %";

                    recSalesPerson.RESET;
                    recSalesPerson.SETRANGE(recSalesPerson.Code, "Sales Invoice Header"."Salesperson Code");
                    IF recSalesPerson.FIND('-') THEN BEGIN
                        SILSPCode := recSalesPerson.Code;
                        SILSPName := recSalesPerson.Name;
                    END ELSE BEGIN
                        SILSPCode := '';
                        SILSPName := '';
                    END;

                    recCampaign.RESET;
                    recCampaign.SETRANGE(recCampaign."No.", "Sales Invoice Header"."Campaign No.");
                    IF recCampaign.FIND('-') THEN
                        SILCampaign := recCampaign.Description
                    ELSE
                        SILCampaign := '';

                    SIHSpecifierName := '';
                    SIHSpecifierAdd := '';
                    SIHSpecifierLocation := '';
                    SIHSpecifierPostCode := '';
                    SIHSpecifier.RESET;
                    SIHSpecifier.SETRANGE("No.", "Sales Invoice Header".Specifier);
                    IF SIHSpecifier.FINDFIRST THEN BEGIN
                        SIHSpecifierName := SIHSpecifier.Name;
                        SIHSpecifierAdd := SIHSpecifier.Address + ' ' + SIHSpecifier."Address 2";
                        SIHSpecifierLocation := SIHSpecifier.City + ', ' + SIHSpecifier.County;
                        SIHSpecifierPostCode := SIHSpecifier."Post Code";
                    END;

                    SIHSpecifierContactEmail := '';
                    SIHSpecifierContactName := '';
                    SIHSpecifierContact.RESET;
                    SIHSpecifierContact.SETRANGE("No.", "Sales Invoice Header"."Specifier Contact No.");
                    IF SIHSpecifierContact.FINDFIRST THEN BEGIN
                        SIHSpecifierContactEmail := SIHSpecifierContact."E-Mail";
                        SIHSpecifierContactName := SIHSpecifierContact.Name;
                    END;
                end;
            }
        }
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "Customer Price Group", "Sell-to Customer No.", "Posting Date";
            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE(Quantity = FILTER(<> 0));
                column(SCH_Specifier; "Sales Cr.Memo Header".Specifier)
                {
                }
                column(SCH_SpecifierName; SCHSpecifierName)
                {
                }
                column(SCH_SpecifierAdd; SCHSpecifierAdd)
                {
                }
                column(SCH_SpecifierLocation; SCHSpecifierLocation)
                {
                }
                column(SCH_SpecifierPostCode; SCHSpecifierPostCode)
                {
                }
                column(SCHSpecifierContactName; SCHSpecifierContactName)
                {
                }
                column(SCHSpecifierContactEmail; SCHSpecifierContactEmail)
                {
                }
                column(SCM_Document_Type; 'Credit Memo')
                {
                }
                column(SCM_Invoice_No; "Sales Cr.Memo Header"."No.")
                {
                }
                column(SCM_InvDT; "Sales Cr.Memo Header"."Posting Date")
                {
                }
                column(SCM_CustGroup; recCust."Customer Price Group")
                {
                }
                column(SCM_CustPostGroup; recCust."Customer Posting Group")
                {
                }
                column(SCM_CustCode; "Sales Cr.Memo Header"."Sell-to Customer No.")
                {
                }
                column(SCM_Cust_Name; "Sales Cr.Memo Header"."Sell-to Customer Name")
                {
                }
                column(SCM_SKU_; "Sales Cr.Memo Line"."No.")
                {
                }
                column(SCM_ItemCode; "Sales Cr.Memo Line".Description)
                {
                }
                column(SCM_Project_Name; "Sales Cr.Memo Header"."Project Name")
                {
                }
                column(SCM_Shipped; "Sales Cr.Memo Line".Quantity)
                {
                }
                column(SCM_P_Line; recItem."Product Line")
                {
                }
                column(SCM_Std; SCLdecUnitPrice)
                {
                }
                column(SCM_Inv; "Sales Cr.Memo Line"."Unit Price")
                {
                }
                column(SCM_Total; "Sales Cr.Memo Line"."Unit Price" * "Sales Cr.Memo Line".Quantity)
                {
                }
                column(SCM_SP_Code; SCLSPCode)
                {
                }
                column(SCM_SalesPerson; SCLSPName)
                {
                }
                column(SCM_Discount; SCLdecUnitDiscPrice)
                {
                }
                column(SCM_InvDisc; "Sales Cr.Memo Line"."Line Discount Amount")
                {
                }
                column(SCM_Per; SCLdecComDisc)
                {
                }
                column(SCM_ComAmt; -SCLdecComDisc * SCLdecUnitDiscPrice * "Sales Cr.Memo Line".Quantity / 100)
                {
                }
                column(SCM_Campaign; SCLCampaign)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF NOT (("Sales Cr.Memo Line".Type = "Sales Cr.Memo Line".Type::Item) OR
                      (("Sales Cr.Memo Line".Type = "Sales Cr.Memo Line".Type::Resource) AND ("Sales Cr.Memo Line"."No." = 'MISC'))) THEN
                        EXIT;

                    IF recCust.GET("Sales Cr.Memo Header"."Sell-to Customer No.") THEN;
                    IF recItem.GET("Sales Cr.Memo Line"."No.") THEN;

                    recSalesPrice.RESET;
                    recSalesPrice.SETRANGE(recSalesPrice."Source Type", recSalesPrice."Source Type"::"Customer Price Group");
                    recSalesPrice.SETRANGE(recSalesPrice."Product Type", recSalesPrice."Product Type"::"Item Category");
                    recSalesPrice.SETRANGE(recSalesPrice."Source No.", "Sales Cr.Memo Header"."Customer Price Group");
                    recSalesPrice.SETRANGE(recSalesPrice."Asset No.", "Sales Cr.Memo Line"."Item Category Code");
                    IF recSalesPrice.FIND('+') THEN
                        SCLdecUnitPrice := recSalesPrice."Unit Price"
                    ELSE
                        SCLdecUnitPrice := recItem."Unit Price";


                    SCLdecInvDisc := 0;
                    SCLdecUnitDiscPrice := 0;
                    SCLdecUnitDiscPrice := (("Sales Cr.Memo Line"."Unit Price" * "Sales Cr.Memo Line".Quantity) - ABS("Sales Cr.Memo Line"."Line Discount Amount") - ABS("Sales Cr.Memo Line"."Inv. Discount Amount")) / "Sales Cr.Memo Line".Quantity;
                    IF SCLdecUnitPrice <> 0 THEN
                        SCLdecInvDisc := ROUND((SCLdecUnitDiscPrice / SCLdecUnitPrice - 1) * 100, 0.1)
                    ELSE
                        SCLdecInvDisc := 0;

                    IF SCLdecInvDisc >= 0 THEN BEGIN
                        recSalesCommision.RESET;
                        recSalesCommision.SETRANGE("Customer Price Group", "Sales Cr.Memo Header"."Customer Price Group");
                        recSalesCommision.SETRANGE("Product Group Code", "Sales Cr.Memo Line"."Item Category Code");
                        recSalesCommision.SETFILTER(recSalesCommision."Discount %", '>=%1', SCLdecInvDisc);
                        IF recSalesCommision.FIND('-') THEN
                            SCLdecComDisc := recSalesCommision."Commision %"
                        ELSE BEGIN
                            recSalesCommision.RESET;
                            recSalesCommision.SETRANGE("Customer Price Group", '');
                            recSalesCommision.SETRANGE("Product Group Code", '');
                            recSalesCommision.SETFILTER(recSalesCommision."Discount %", '>=%1', SCLdecInvDisc);
                            IF recSalesCommision.FIND('-') THEN
                                SCLdecComDisc := recSalesCommision."Commision %"
                            ELSE
                                SCLdecComDisc := 0;
                        END;
                    END ELSE BEGIN
                        recSalesCommision.RESET;
                        recSalesCommision.SETCURRENTKEY("Customer Price Group", "Product Group Code", "Discount %");
                        recSalesCommision.ASCENDING(FALSE);
                        recSalesCommision.SETRANGE("Customer Price Group", "Sales Cr.Memo Header"."Customer Price Group");
                        recSalesCommision.SETRANGE("Product Group Code", "Sales Cr.Memo Line"."Item Category Code");
                        recSalesCommision.SETFILTER(recSalesCommision."Discount %", '<=%1', SCLdecInvDisc);
                        IF recSalesCommision.FIND('-') THEN
                            SCLdecComDisc := recSalesCommision."Commision %"
                        ELSE BEGIN
                            recSalesCommision.RESET;
                            recSalesCommision.SETCURRENTKEY("Customer Price Group", "Product Group Code", "Discount %");
                            recSalesCommision.ASCENDING(FALSE);
                            recSalesCommision.SETRANGE("Customer Price Group", '');
                            recSalesCommision.SETRANGE("Product Group Code", '');
                            recSalesCommision.SETFILTER(recSalesCommision."Discount %", '<=%1', SCLdecInvDisc);
                            IF recSalesCommision.FIND('-') THEN
                                SCLdecComDisc := recSalesCommision."Commision %"
                            ELSE
                                SCLdecComDisc := 0;
                        END;
                    END;

                    IF "Sales Cr.Memo Header"."Commission Override" THEN
                        SCLdecComDisc := "Sales Cr.Memo Header"."Commision %";

                    recSalesPerson.RESET;
                    recSalesPerson.SETRANGE(recSalesPerson.Code, "Sales Cr.Memo Header"."Salesperson Code");
                    IF recSalesPerson.FIND('-') THEN BEGIN
                        SCLSPName := recSalesPerson.Name;
                        SCLSPCode := recSalesPerson.Code;
                    END ELSE BEGIN
                        SCLSPCode := '';
                        SCLSPName := '';
                    END;

                    recCampaign.RESET;
                    recCampaign.SETRANGE(recCampaign."No.", "Sales Cr.Memo Header"."Campaign No.");
                    IF recCampaign.FIND('-') THEN
                        SCLCampaign := recCampaign.Description
                    ELSE
                        SCLCampaign := '';

                    SCHSpecifierName := '';
                    SCHSpecifierAdd := '';
                    SCHSpecifierLocation := '';
                    SCHSpecifierPostCode := '';
                    SCHSpecifier.RESET;
                    SCHSpecifier.SETRANGE("No.", "Sales Cr.Memo Header".Specifier);
                    IF SCHSpecifier.FINDFIRST THEN BEGIN
                        SCHSpecifierName := SCHSpecifier.Name;
                        SCHSpecifierAdd := SCHSpecifier.Address + ' ' + SCHSpecifier."Address 2";
                        SCHSpecifierLocation := SCHSpecifier.City + ', ' + SCHSpecifier.County;
                        SCHSpecifierPostCode := SCHSpecifier."Post Code";
                    END;

                    SCHSpecifierContactEmail := '';
                    SCHSpecifierContactName := '';
                    SCHSpecifierContact.RESET;
                    SCHSpecifierContact.SETRANGE("No.", "Sales Cr.Memo Header"."Specifier Contact No.");
                    IF SCHSpecifierContact.FINDFIRST THEN BEGIN
                        SCHSpecifierContactEmail := SCHSpecifierContact."E-Mail";
                        SCHSpecifierContactName := SCHSpecifierContact.Name;
                    END;
                end;
            }

            trigger OnPreDataItem()
            begin
                SETFILTER("Customer Price Group", "Sales Invoice Header".GETFILTER("Customer Price Group"));
                SETFILTER("Sell-to Customer No.", "Sales Invoice Header".GETFILTER("Sell-to Customer No."));
                SETFILTER("Posting Date", "Sales Invoice Header".GETFILTER("Posting Date"));
                SETFILTER("Salesperson Code", "Sales Invoice Header".GETFILTER("Salesperson Code"));
                SETFILTER("Campaign No.", "Sales Invoice Header".GETFILTER("Campaign No."));
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
    }

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        recItem: Record Item;
        recSalesPerson: Record "Salesperson/Purchaser";
        recSalesPrice: Record "Price List Line";
        Text101: Label 'Data';
        Text102: Label 'Sales Comission';
        SILdecUnitPrice: Decimal;
        SILdecInvDisc: Decimal;
        recSalesCommision: Record "SalesPerson Commision";
        SILdecComDisc: Decimal;
        recCust: Record Customer;
        SILdecUnitDiscPrice: Decimal;
        recCampaign: Record Campaign;
        SILCampaign: Text[30];
        SILSPCode: Code[20];
        SILSPName: Text[30];
        SCLCampaign: Text[30];
        SCLSPCode: Code[20];
        SCLSPName: Text[30];
        SCLdecUnitPrice: Decimal;
        SCLdecInvDisc: Decimal;
        SCLdecComDisc: Decimal;
        SCLdecUnitDiscPrice: Decimal;
        SIHSpecifier: Record Customer;
        SCHSpecifier: Record Customer;
        SIHSpecifierName: Text;
        SIHSpecifierAdd: Text;
        SIHSpecifierLocation: Text;
        SIHSpecifierPostCode: Text;
        SCHSpecifierName: Text;
        SCHSpecifierAdd: Text;
        SCHSpecifierLocation: Text;
        SCHSpecifierPostCode: Text;
        SIHSpecifierContact: Record Contact;
        SIHSpecifierContactName: Text;
        SIHSpecifierContactEmail: Text;
        SCHSpecifierContact: Record Contact;
        SCHSpecifierContactName: Text;
        SCHSpecifierContactEmail: Text;
}

