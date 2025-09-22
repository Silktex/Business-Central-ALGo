report 50050 "CFT Packing List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50050_Report_CFTPackingList.rdlc';
    Caption = 'Work Order';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.", "Sell-to Customer No.";
            RequestFilterHeading = 'Sales Order';
            dataitem(PageLoop; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(No1_SalesHeader; "Sales Header"."No.")
                {
                }
                column(ShipmentDate_SalesHeader; FORMAT("Sales Header"."Shipment Date"))
                {
                }
                column(CompInfo_Picture; CompInfo.Picture)
                {
                }
                column(CompInfo_Name; CompInfo.Name)
                {
                }
                column(CompInfo_Address; CompInfo.Address)
                {
                }
                column(CompInfo_City; CompInfo.City)
                {
                }
                column(CompInfo_PostCode; CompInfo."Post Code")
                {
                }
                column(CompInfo_County; CompInfo.County)
                {
                }
                column(CompInfo_PhoneNo; CompInfo."Phone No.")
                {
                }
                column(SalesHeader_BilltoCustomerNo; "Sales Header"."Bill-to Customer No.")
                {
                }
                column(SalesHeader_BilltoName; "Sales Header"."Bill-to Name")
                {
                }
                column(SalesHeader_BilltoAddress; "Sales Header"."Bill-to Address")
                {
                }
                column(SalesHeader_BilltoCity; "Sales Header"."Bill-to City")
                {
                }
                column(SalesHeader_BilltoCounty; "Sales Header"."Bill-to County")
                {
                }
                column(SalesHeaderBilltoPostCode; "Sales Header"."Bill-to Post Code")
                {
                }
                column(SalesHeader_SelltoCustomerNo; "Sales Header"."Sell-to Customer No.")
                {
                }
                column(SalesHeader_ShiptoCode; "Sales Header"."Ship-to Code")
                {
                }
                column(SalesHeader_ShiptoName; "Sales Header"."Ship-to Name")
                {
                }
                column(SalesHeader_ShiptoAddress; "Sales Header"."Ship-to Address")
                {
                }
                column(SalesHeader_ShiptoCity; "Sales Header"."Ship-to City")
                {
                }
                column(SalesHeader_ShiptoCounty; "Sales Header"."Ship-to County")
                {
                }
                column(SalesHeader_ShiptoPostCode; "Sales Header"."Ship-to Post Code")
                {
                }
                column(SalesHeaderShipmentMethodCode; "Sales Header"."Shipment Method Code")
                {
                }
                column(SalesHeaderShippingAgentCode; "Sales Header"."Shipping Agent Code" + '  ' + "Sales Header"."Shipping Agent Service Code" + ' ' + FTAcc)
                {
                }
                column(SalesHeader_ExternalDocumentNo; "Sales Header"."External Document No.")
                {
                }
                column(CustAddr1; CustAddr[1])
                {
                }
                column(CustAddr2; CustAddr[2])
                {
                }
                column(CustAddr3; CustAddr[3])
                {
                }
                column(CustAddr4; CustAddr[4])
                {
                }
                column(CustAddr5; CustAddr[5])
                {
                }
                column(CustAddr6; CustAddr[6])
                {
                }
                column(CustAddr7; CustAddr[7])
                {
                }
                column(CustAddr8; CustAddr[8])
                {
                }
                column(ShipmentDateCaption; ShipmentDateCaptionLbl)
                {
                }
                column(SalesOrderNoCaption; SalesOrderNoCaptionLbl)
                {
                }
                column(PageNoCaption; PageNoCaptionLbl)
                {
                }
                column(WorkOrderCaption; WorkOrderCaptionLbl)
                {
                }
                dataitem("Sales Line"; "Sales Line")
                {
                    DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                    DataItemLinkReference = "Sales Header";
                    DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE("Outstanding Quantity" = FILTER(> 0));
                    column(No_SalesLine; "No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Description_SalesLine; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(Quantity_SalesLine; "Outstanding Quantity")
                    {
                        IncludeCaption = true;
                    }
                    column(UnitofMeasure_SalesLine; "Unit of Measure")
                    {
                        IncludeCaption = true;
                    }
                    column(Type_SalesLine; Type)
                    {
                        IncludeCaption = true;
                    }
                    column(QtyworkPostSalesOrderCptn; QtyworkPostSalesOrderCptnLbl)
                    {
                    }
                    column(QuantityUsedCaption; QuantityUsedCaptionLbl)
                    {
                    }
                    column(UnitofMeasureCaption; UnitofMeasureCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF NOT ShowResource THEN BEGIN
                            IF Type = Type::Resource THEN
                                CurrReport.SKIP;
                        END;

                        IF NOT ShowGL THEN BEGIN
                            IF Type = Type::"G/L Account" THEN
                                CurrReport.SKIP;
                        END;

                        IF PrintToExcel THEN
                            MakeWOLine;
                    end;

                    trigger OnPostDataItem()
                    begin
                        IF PrintToExcel AND NOT HasWorkOrderLineRange AND NOT ISEMPTY THEN BEGIN
                            ExcelBuf.EndRange;
                            ExcelBuf.CreateRange('WorkOrderLineRange');
                            HasWorkOrderLineRange := TRUE;
                        END;
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF PrintToExcel THEN
                            MakeWOLineHeader;
                    end;
                }
                dataitem("Sales Comment Line"; "Sales Comment Line")
                {
                    DataItemLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("No.");
                    DataItemLinkReference = "Sales Header";
                    DataItemTableView = WHERE("Document Line No." = CONST(0));
                    column(Date_SalesCommentLine; FORMAT(Date))
                    {
                    }
                    column(Code_SalesCommentLine; Code)
                    {
                        IncludeCaption = true;
                    }
                    column(Comment_SalesCommentLine; Comment)
                    {
                        IncludeCaption = true;
                    }
                    column(CommentsCaption; CommentsCaptionLbl)
                    {
                    }
                    column(SalesCommentLineDtCptn; SalesCommentLineDtCptnLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF PrintToExcel THEN
                            MakeWOCommentLine;
                    end;

                    trigger OnPostDataItem()
                    begin
                        IF PrintToExcel AND NOT HasWorkOrderCommentLineRange AND NOT ISEMPTY THEN BEGIN
                            ExcelBuf.EndRange;
                            ExcelBuf.CreateRange('WorkOrderCommentLineRange');
                            HasWorkOrderCommentLineRange := TRUE;
                        END;
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF PrintToExcel THEN
                            MakeWOCommentLineHeader;
                    end;
                }
                dataitem("Extra Lines"; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(NoCaption; NoCaptionLbl)
                    {
                    }
                    column(DescriptionCaption; DescriptionCaptionLbl)
                    {
                    }
                    column(QuantityCaption; QuantityCaptionLbl)
                    {
                    }
                    column(UnitofMeasureCaptionControl33; UnitofMeasureCaptionControl33Lbl)
                    {
                    }
                    column(DateCaption; DateCaptionLbl)
                    {
                    }
                    column(workPostdItemorResJnlCptn; workPostdItemorResJnlCptnLbl)
                    {
                    }
                    column(TypeCaption; TypeCaptionLbl)
                    {
                    }

                    trigger OnPostDataItem()
                    begin
                        IF PrintToExcel AND NOT HasWorkOrderExtraLineRange AND NOT ISEMPTY THEN BEGIN
                            ExcelBuf.EndRange;
                            ExcelBuf.CreateRange('WorkOrderExtraLineRange');
                            HasWorkOrderExtraLineRange := TRUE;

                            ExcelBuf.NewRow;
                            ExcelBuf.NewRow;
                            ExcelBuf.NewRow;
                            ExcelBuf.NewRow;
                        END;
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF PrintToExcel THEN
                            MakeWOExtraLineHeader;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                FormatAddr.SalesHeaderBillTo(CustAddr, "Sales Header");
                FTAcc := '';
                IF recCustomer.GET("Bill-to Customer No.") THEN BEGIN
                    IF "Shipping Agent Code" = 'FEDEX' THEN
                        FTAcc := recCustomer."Shipping Account No."
                    ELSE
                        IF "Shipping Agent Code" = 'UPS' THEN
                            FTAcc := recCustomer."UPS Account No."
                        ELSE
                            FTAcc := '';
                END;
                IF PrintToExcel THEN
                    MakeWOHeader;
            end;

            trigger OnPreDataItem()
            begin
                CompInfo.GET;
                CompInfo.CALCFIELDS(Picture);
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
                    Caption = 'Options';
                    field(PrintToExcel; PrintToExcel)
                    {
                        Caption = 'Print to Excel';
                        Visible = false;
                        ApplicationArea = all;
                    }
                    field(ShowResource; ShowResource)
                    {
                        Caption = 'Show Resource';
                        ApplicationArea = all;
                    }
                    field(ShowGL; ShowGL)
                    {
                        Caption = 'Show G/L Account';
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
            ShowResource := TRUE;
            ShowGL := TRUE;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        IF PrintToExcel THEN BEGIN
            ExcelBuf.WriteSheet(Text000, COMPANYNAME, USERID);
            ExcelBuf.CloseBook;
            ExcelBuf.SetFriendlyFilename(Text000);
            ExcelBuf.OpenExcel;

            // IF NOT "Sales Header".ISEMPTY THEN BEGIN
            //     IF NOT "Sales Line".ISEMPTY THEN
            //         ExcelBuf.AutoFit('WorkOrderLineRange');
            //     IF NOT "Sales Line".ISEMPTY THEN
            //         ExcelBuf.BorderAround('WorkOrderLineRange');
            //     IF NOT "Sales Comment Line".ISEMPTY THEN
            //         ExcelBuf.BorderAround('WorkOrderCommentLineRange');
            //     IF NOT "Sales Line".ISEMPTY THEN
            //         ExcelBuf.BorderAround('WorkOrderExtraLineRange');
            // END;

            //ExcelBuf.GiveUserControl;
            ERROR('');
        END;
    end;

    trigger OnPreReport()
    begin
        IF PrintToExcel THEN
            ExcelBuf.CreateNewBook(Text000);
        //ExcelBuf.CreateBook('', Text000);
    end;

    var
        Text000: Label 'Shipment Advice';
        Text001: Label 'Sales Order No.';
        Text002: Label 'Quantity used during work (Posted with the Sales Order)';
        Text003: Label 'Quantity Used';
        Text004: Label 'Comments';
        Text005: Label 'Extra Item/Resource used during work (Posted with Item or Resource Journals)';
        CompInfo: Record "Company Information";
        ExcelBuf: Record "Excel Buffer" temporary;
        recCustomer: Record Customer;
        FormatAddr: Codeunit "Format Address";
        CustAddr: array[8] of Text[50];
        FTAcc: Code[20];
        PrintToExcel: Boolean;
        Text006: Label 'Date';
        HasWorkOrderExtraLineRange: Boolean;
        HasWorkOrderCommentLineRange: Boolean;
        HasWorkOrderLineRange: Boolean;
        ShipmentDateCaptionLbl: Label 'Shipment Date';
        SalesOrderNoCaptionLbl: Label 'Sales Order No.';
        PageNoCaptionLbl: Label 'Page';
        WorkOrderCaptionLbl: Label 'Shipment Advice';
        QtyworkPostSalesOrderCptnLbl: Label 'Quantity used during work (Posted with the Sales Order)';
        QuantityUsedCaptionLbl: Label 'Quantity Used';
        UnitofMeasureCaptionLbl: Label 'Unit of Measure';
        CommentsCaptionLbl: Label 'Comments';
        SalesCommentLineDtCptnLbl: Label 'Date';
        NoCaptionLbl: Label 'No.';
        DescriptionCaptionLbl: Label 'Description';
        QuantityCaptionLbl: Label 'Quantity';
        UnitofMeasureCaptionControl33Lbl: Label 'Unit of Measure';
        DateCaptionLbl: Label 'Date';
        workPostdItemorResJnlCptnLbl: Label 'Extra Item/Resource used during work (Posted with Item or Resource Journals)';
        TypeCaptionLbl: Label 'Type';
        ShowResource: Boolean;
        ShowGL: Boolean;

    local procedure MakeWOHeader()
    begin
        ExcelBuf.NewRow;

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CustAddr[1], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Text001), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Header"."No.", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CustAddr[2], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Header".FIELDCAPTION("Shipment Date"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Header"."Shipment Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CustAddr[3], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CustAddr[4], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CustAddr[5], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CustAddr[6], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CustAddr[7], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CustAddr[8], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    local procedure MakeWOLineHeader()
    begin
        IF "Sales Line".ISEMPTY THEN
            EXIT;

        ExcelBuf.NewRow;
        ExcelBuf.NewRow;

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(FORMAT(Text002), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION(Type), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.StartRange;
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("No."), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION(Description), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION(Quantity), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("Unit of Measure"), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Text003), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("Unit of Measure"), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
    end;

    local procedure MakeWOLine()
    begin
        IF "Sales Line".ISEMPTY THEN
            EXIT;

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(FORMAT("Sales Line".Type), FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line"."No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".Description, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".Quantity, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Line"."Unit of Measure", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
    end;

    local procedure MakeWOCommentLineHeader()
    begin
        IF "Sales Comment Line".ISEMPTY THEN
            EXIT;

        ExcelBuf.NewRow;
        ExcelBuf.NewRow;

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(FORMAT(Text004), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Sales Comment Line".FIELDCAPTION(Code), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.StartRange;

        ExcelBuf.AddColumn("Sales Comment Line".FIELDCAPTION(Comment), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Comment Line".FIELDCAPTION(Date), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
    end;

    local procedure MakeWOCommentLine()
    begin
        IF "Sales Comment Line".ISEMPTY THEN
            EXIT;

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Sales Comment Line".Code, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Comment Line".Comment, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Comment Line".Date, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Date);
    end;

    local procedure MakeWOExtraLineHeader()
    begin
        IF "Sales Line".ISEMPTY THEN
            EXIT;

        ExcelBuf.NewRow;
        ExcelBuf.NewRow;

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(FORMAT(Text005), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION(Type), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.StartRange;
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("No."), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION(Description), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION(Quantity), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("Unit of Measure"), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Text006), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
    end;
}

