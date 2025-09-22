report 50220 "Sales Commission"
{
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "Customer Price Group", "Sell-to Customer No.", "Posting Date", "Salesperson Code";
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE(Quantity = FILTER(<> 0));
                RequestFilterFields = "No.";

                trigger OnAfterGetRecord()
                begin
                    IF NOT (("Sales Invoice Line".Type = "Sales Invoice Line".Type::Item) OR
                      (("Sales Invoice Line".Type = "Sales Invoice Line".Type::Resource) AND ("Sales Invoice Line"."No." = 'MISC'))) THEN
                        EXIT;
                    MakeExcelDataBody;
                end;
            }
        }
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            RequestFilterFields = "Customer Price Group", "Sell-to Customer No.", "Posting Date";
            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE(Quantity = FILTER(<> 0));

                trigger OnAfterGetRecord()
                begin
                    IF NOT (("Sales Cr.Memo Line".Type = "Sales Cr.Memo Line".Type::Item) OR
                      (("Sales Cr.Memo Line".Type = "Sales Cr.Memo Line".Type::Resource) AND ("Sales Cr.Memo Line"."No." = 'MISC'))) THEN
                        EXIT;

                    MakeExcelDataBody1;
                end;
            }

            trigger OnPreDataItem()
            begin

                //"Sales Cr.Memo Header".COPYFILTERS("Sales Invoice Header");
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

    trigger OnPostReport()
    begin

        CreateExcelbook
    end;

    trigger OnPreReport()
    begin
        MakeExcelInfo;
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        recItem: Record Item;
        recSalesPerson: Record "Salesperson/Purchaser";
        recSalesPrice: Record "Price List Line"; // "Sales Price";
        Text101: Label 'Data';
        Text102: Label 'Sales Comission';
        decUnitPrice: Decimal;
        decInvDisc: Decimal;
        recSalesCommision: Record "SalesPerson Commision";
        decComDisc: Decimal;
        recCust: Record Customer;
        decUnitDiscPrice: Decimal;
        recCampaign: Record Campaign;

    local procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;
        /*//ExcelBuf.AddInfoColumn(FORMAT(XYZ),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddInfoColumn(CompanyInformation.Name,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.NewRow;
        //ExcelBuf.AddInfoColumn(FORMAT(Text105),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddInfoColumn(FORMAT(Text102),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.NewRow;
        //ExcelBuf.AddInfoColumn(FORMAT(Text104),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddInfoColumn(REPORT::"Aged Accounts Receivable",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        //ExcelBuf.NewRow;
        //ExcelBuf.AddInfoColumn(FORMAT(Text106),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddInfoColumn(USERID,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.NewRow;
        //ExcelBuf.AddInfoColumn(FORMAT(Text107),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddInfoColumn(TODAY,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        //ExcelBuf.AddInfoColumn(TIME,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Time);
        //ExcelBuf.NewRow;
        //ExcelBuf.AddInfoColumn(FORMAT(Text108),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddInfoColumn(FilterString,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.NewRow;
        //ExcelBuf.AddInfoColumn(FORMAT(Text109),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddInfoColumn(DateTitle,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.NewRow;
        //ExcelBuf.AddInfoColumn(FORMAT(Text113),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddInfoColumn(PeriodEndingDate[1],FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        //ExcelBuf.NewRow;
        //ExcelBuf.AddInfoColumn(FORMAT(Text110),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        IF PrintAmountsInLocal THEN
          ExcelBuf.AddInfoColumn(FORMAT(Text112),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text)
        ELSE
          ExcelBuf.AddInfoColumn(FORMAT(Text111),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.ClearNewRow;*/
        MakeExcelDataHeader;

    end;

    local procedure MakeExcelDataHeader()
    begin

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Document Type', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Invoice#', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('InvDT', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('CustGroup', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('CustPostGroup', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('CustCode', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Cust Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        //Rahul
        ExcelBuf.AddColumn('SKU #', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        //Rahul
        ExcelBuf.AddColumn('ItemCode', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Shipped', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('P.Line', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Std$', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Inv$', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        //Rahul
        ExcelBuf.AddColumn('SP Code', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('SalesPerson', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Discount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('InvDisc', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('%', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ComAmt', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Campaign', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
    end;

    local procedure MakeExcelDataBody()
    var
        CurrencyCodeToPrint: Code[20];
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Invoice', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);

        IF recCust.GET("Sales Invoice Header"."Sell-to Customer No.") THEN;
        ExcelBuf.AddColumn(recCust."Customer Price Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(recCust."Customer Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //IF PrintDetail THEN BEGIN
        ExcelBuf.AddColumn("Sales Invoice Header"."Sell-to Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."Sell-to Customer Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //Rahul
        ExcelBuf.AddColumn("Sales Invoice Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn("Sales Invoice Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        IF recItem.GET("Sales Invoice Line"."No.") THEN;
        ExcelBuf.AddColumn(FORMAT(recItem."Product Line"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        //END ELSE
        //IF OverLimitDescription = '' THEN
        //Fix12072023 to "Price List Line"
        recSalesPrice.RESET;
        recSalesPrice.SETRANGE(recSalesPrice."Source Type", recSalesPrice."Source Type"::"Customer Price Group");
        recSalesPrice.SETRANGE(recSalesPrice."Source No.", "Sales Invoice Header"."Customer Price Group");
        recSalesPrice.SetRange("Asset Type", recSalesPrice."Asset Type"::"Item Category");
        recSalesPrice.SETRANGE(recSalesPrice."Asset No.", "Sales Invoice Line"."Item Category Code");
        IF recSalesPrice.FIND('+') THEN
            decUnitPrice := recSalesPrice."Unit Price"
        ELSE
            decUnitPrice := recItem."Unit Price";

        ExcelBuf.AddColumn(decUnitPrice, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        // ELSE
        ExcelBuf.AddColumn("Sales Invoice Line"."Unit Price", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Invoice Line"."Unit Price" * "Sales Invoice Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        decInvDisc := 0;
        decUnitDiscPrice := 0;
        decUnitDiscPrice := (("Sales Invoice Line"."Unit Price" * "Sales Invoice Line".Quantity) - ABS("Sales Invoice Line"."Line Discount Amount") - ABS("Sales Invoice Line"."Inv. Discount Amount")) / "Sales Invoice Line".Quantity;

        IF decUnitPrice <> 0 THEN
            decInvDisc := ROUND((decUnitDiscPrice / decUnitPrice - 1) * 100, 0.1)
        ELSE
            decInvDisc := 0;
        IF decInvDisc >= 0 THEN BEGIN
            recSalesCommision.RESET;
            recSalesCommision.SETRANGE("Customer Price Group", "Sales Invoice Header"."Customer Price Group");
            recSalesCommision.SETRANGE("Product Group Code", "Sales Invoice Line"."Item Category Code");
            recSalesCommision.SETFILTER(recSalesCommision."Discount %", '>=%1', decInvDisc);
            IF recSalesCommision.FIND('-') THEN
                decComDisc := recSalesCommision."Commision %"
            ELSE BEGIN
                recSalesCommision.RESET;
                recSalesCommision.SETRANGE("Customer Price Group", '');
                recSalesCommision.SETRANGE("Product Group Code", '');
                recSalesCommision.SETFILTER(recSalesCommision."Discount %", '>=%1', decInvDisc);
                IF recSalesCommision.FIND('-') THEN
                    decComDisc := recSalesCommision."Commision %"
                ELSE
                    decComDisc := 0;
            END;
        END ELSE BEGIN

            recSalesCommision.RESET;
            recSalesCommision.SETCURRENTKEY("Customer Price Group", "Product Group Code", "Discount %");
            recSalesCommision.ASCENDING(FALSE);
            recSalesCommision.SETRANGE("Customer Price Group", "Sales Invoice Header"."Customer Price Group");
            recSalesCommision.SETRANGE("Product Group Code", "Sales Invoice Line"."Item Category Code");
            recSalesCommision.SETFILTER(recSalesCommision."Discount %", '<=%1', decInvDisc);
            IF recSalesCommision.FIND('-') THEN
                decComDisc := recSalesCommision."Commision %"
            ELSE BEGIN
                recSalesCommision.RESET;
                recSalesCommision.SETCURRENTKEY("Customer Price Group", "Product Group Code", "Discount %");
                recSalesCommision.ASCENDING(FALSE);

                recSalesCommision.SETRANGE("Customer Price Group", '');
                recSalesCommision.SETRANGE("Product Group Code", '');
                recSalesCommision.SETFILTER(recSalesCommision."Discount %", '<=%1', decInvDisc);
                IF recSalesCommision.FIND('-') THEN
                    decComDisc := recSalesCommision."Commision %"
                ELSE
                    decComDisc := 0;
            END;
        END;
        IF "Sales Invoice Header"."Commission Override" THEN
            decComDisc := "Sales Invoice Header"."Commision %";

        recSalesPerson.RESET;
        recSalesPerson.SETRANGE(recSalesPerson.Code, "Sales Invoice Header"."Salesperson Code");

        IF recSalesPerson.FIND('-') THEN BEGIN
            ExcelBuf.AddColumn(recSalesPerson.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            //Rahul
            ExcelBuf.AddColumn(recSalesPerson.Code, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            //rahul

        END ELSE BEGIN
            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        END;
        ExcelBuf.AddColumn(decUnitDiscPrice, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Invoice Line"."Line Discount Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        //RAVI// ExcelBuf.AddColumn(decInvDisc,FALSE,'',FALSE,FALSE,FALSE,'#,##0.00',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(FORMAT(decComDisc) + '%', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(decComDisc * decUnitDiscPrice * "Sales Invoice Line".Quantity / 100, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);


        recCampaign.RESET;
        recCampaign.SETRANGE(recCampaign."No.", "Sales Invoice Header"."Campaign No.");
        IF recCampaign.FIND('-') THEN
            ExcelBuf.AddColumn(recCampaign.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
        ELSE
            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    local procedure CreateExcelbook()
    begin
        //ExcelBuf.CreateBookAndOpenExcel('', Text101, Text102, COMPANYNAME, USERID);
        ExcelBuf.CreateNewBook(Text101);
        ExcelBuf.WriteSheet(Text102, COMPANYNAME, USERID);
        ExcelBuf.CloseBook;
        ExcelBuf.SetFriendlyFilename(Text101);
        ExcelBuf.OpenExcel;
    end;

    local procedure MakeExcelDataBody1()
    var
        CurrencyCodeToPrint: Code[20];
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Credit Memo', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        IF recCust.GET("Sales Cr.Memo Header"."Sell-to Customer No.") THEN;
        ExcelBuf.AddColumn(recCust."Customer Price Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(recCust."Customer Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //IF PrintDetail THEN BEGIN
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Sell-to Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Sell-to Customer Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //Rahul
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn("Sales Cr.Memo Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        IF recItem.GET("Sales Cr.Memo Line"."No.") THEN;
        ExcelBuf.AddColumn(FORMAT(recItem."Product Line"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //END ELSE
        //IF OverLimitDescription = '' THEN
        //Fix12072023 to "Price List Line"
        recSalesPrice.RESET;
        recSalesPrice.SETRANGE(recSalesPrice."Source Type", recSalesPrice."Source Type"::"Customer Price Group");
        recSalesPrice.SETRANGE(recSalesPrice."Source No.", "Sales Cr.Memo Header"."Customer Price Group");
        recSalesPrice.SetRange("Asset Type", recSalesPrice."Asset Type"::"Item Category");
        recSalesPrice.SETRANGE(recSalesPrice."Asset No.", "Sales Cr.Memo Line"."Item Category Code");
        IF recSalesPrice.FIND('+') THEN
            decUnitPrice := recSalesPrice."Unit Price"
        ELSE
            decUnitPrice := recItem."Unit Price";

        ExcelBuf.AddColumn(decUnitPrice, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        // ELSE
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Unit Price", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Unit Price" * "Sales Cr.Memo Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        decInvDisc := 0;
        decUnitDiscPrice := 0;
        decUnitDiscPrice := (("Sales Cr.Memo Line"."Unit Price" * "Sales Cr.Memo Line".Quantity) - ABS("Sales Cr.Memo Line"."Line Discount Amount") - ABS("Sales Cr.Memo Line"."Inv. Discount Amount")) / "Sales Cr.Memo Line".Quantity;
        IF decUnitPrice <> 0 THEN
            decInvDisc := ROUND((decUnitDiscPrice / decUnitPrice - 1) * 100, 0.1)
        //decInvDisc:="Sales Cr.Memo Line"."Unit Price"/decUnitPrice-1
        ELSE
            decInvDisc := 0;
        IF decInvDisc >= 0 THEN BEGIN
            recSalesCommision.RESET;
            recSalesCommision.SETRANGE("Customer Price Group", "Sales Cr.Memo Header"."Customer Price Group");
            recSalesCommision.SETRANGE("Product Group Code", "Sales Cr.Memo Line"."Item Category Code");
            recSalesCommision.SETFILTER(recSalesCommision."Discount %", '>=%1', decInvDisc);
            IF recSalesCommision.FIND('-') THEN
                decComDisc := recSalesCommision."Commision %"
            ELSE BEGIN
                recSalesCommision.RESET;
                recSalesCommision.SETRANGE("Customer Price Group", '');
                recSalesCommision.SETRANGE("Product Group Code", '');
                recSalesCommision.SETFILTER(recSalesCommision."Discount %", '>=%1', decInvDisc);
                IF recSalesCommision.FIND('-') THEN
                    decComDisc := recSalesCommision."Commision %"
                ELSE
                    decComDisc := 0;
            END;
        END ELSE BEGIN

            recSalesCommision.RESET;
            recSalesCommision.SETCURRENTKEY("Customer Price Group", "Product Group Code", "Discount %");
            recSalesCommision.ASCENDING(FALSE);
            recSalesCommision.SETRANGE("Customer Price Group", "Sales Cr.Memo Header"."Customer Price Group");
            recSalesCommision.SETRANGE("Product Group Code", "Sales Cr.Memo Line"."Item Category Code");
            recSalesCommision.SETFILTER(recSalesCommision."Discount %", '<=%1', decInvDisc);
            IF recSalesCommision.FIND('-') THEN
                decComDisc := recSalesCommision."Commision %"
            ELSE BEGIN
                recSalesCommision.RESET;
                recSalesCommision.SETCURRENTKEY("Customer Price Group", "Product Group Code", "Discount %");
                recSalesCommision.ASCENDING(FALSE);

                recSalesCommision.SETRANGE("Customer Price Group", '');
                recSalesCommision.SETRANGE("Product Group Code", '');
                recSalesCommision.SETFILTER(recSalesCommision."Discount %", '<=%1', decInvDisc);
                IF recSalesCommision.FIND('-') THEN
                    decComDisc := recSalesCommision."Commision %"
                ELSE
                    decComDisc := 0;
            END;
        END;
        IF "Sales Cr.Memo Header"."Commission Override" THEN
            decComDisc := "Sales Cr.Memo Header"."Commision %";

        recSalesPerson.RESET;
        recSalesPerson.SETRANGE(recSalesPerson.Code, "Sales Cr.Memo Header"."Salesperson Code");

        IF recSalesPerson.FIND('-') THEN BEGIN
            ExcelBuf.AddColumn(recSalesPerson.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            //Rahul
            ExcelBuf.AddColumn(recSalesPerson.Code, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        END ELSE BEGIN
            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        END;
        ExcelBuf.AddColumn(decUnitDiscPrice, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Line Discount Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        //RAVI// ExcelBuf.AddColumn(decInvDisc,FALSE,'',FALSE,FALSE,FALSE,'#,##0.00',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('-' + FORMAT(decComDisc) + '%', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(-decComDisc * decUnitDiscPrice * "Sales Cr.Memo Line".Quantity / 100, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        recCampaign.RESET;
        recCampaign.SETRANGE(recCampaign."No.", "Sales Cr.Memo Header"."Campaign No.");
        IF recCampaign.FIND('-') THEN
            ExcelBuf.AddColumn(recCampaign.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
        ELSE
            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;
}

