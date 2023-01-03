report 50001 "Return Authorization new"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50001_Report_ReturnAuthorizationnew.rdlc';
    Caption = 'Return Authorization';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST("Return Order"));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Sell-to Customer No.", "Bill-to Customer No.", "Ship-to Code", "No. Printed";
            RequestFilterHeading = 'Return Order';
            column(Sales_Header_Document_Type; "Document Type")
            {
            }
            column(Sales_Header_No_; "No.")
            {
            }
            column(CompanyInfoPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyInfoAddress_N_1; CompanyInfo.Address)
            {
            }
            column(CompanyInfoAddress_N_2; CompanyInfo.City + ' ' + CompanyInfo.County + ' ' + CompanyInfo."Post Code")
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE("Document Type" = CONST("Return Order"));
                dataitem(SalesLineComments; "Sales Comment Line")
                {
                    DataItemLink = "No." = FIELD("Document No."), "Document Line No." = FIELD("Line No.");
                    DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = CONST("Return Order"), "Print On Return Authorization" = CONST(True));

                    trigger OnAfterGetRecord()
                    begin
                        WITH TempSalesLine DO BEGIN
                            INIT;
                            "Document Type" := "Sales Header"."Document Type";
                            "Document No." := "Sales Header"."No.";
                            "Line No." := HighestLineNo + 10;
                            HighestLineNo := "Line No.";
                        END;
                        IF STRLEN(Comment) <= MAXSTRLEN(TempSalesLine.Description) THEN BEGIN
                            TempSalesLine.Description := Comment;
                            TempSalesLine."Description 2" := '';
                        END ELSE BEGIN
                            SpacePointer := MAXSTRLEN(TempSalesLine.Description) + 1;
                            WHILE (SpacePointer > 1) AND (Comment[SpacePointer] <> ' ') DO
                                SpacePointer := SpacePointer - 1;
                            IF SpacePointer = 1 THEN
                                SpacePointer := MAXSTRLEN(TempSalesLine.Description) + 1;
                            TempSalesLine.Description := COPYSTR(Comment, 1, SpacePointer - 1);
                            TempSalesLine."Description 2" := COPYSTR(COPYSTR(Comment, SpacePointer + 1), 1, MAXSTRLEN(TempSalesLine."Description 2"));
                        END;
                        TempSalesLine.INSERT;
                    end;
                }

                trigger OnAfterGetRecord()
                begin


                    TempSalesLine := "Sales Line";
                    TempSalesLine.INSERT;
                    HighestLineNo := "Line No.";


                    txtRetuenDesc := '';
                    recReturnReason.RESET;
                    recReturnReason.SETRANGE(Code, TempSalesLine."Return Reason Code");
                    IF recReturnReason.FIND('-') THEN BEGIN
                        REPEAT
                            txtRetuenDesc := recReturnReason.Description
                        UNTIL recReturnReason.NEXT = 0;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    TempSalesLine.RESET;
                    TempSalesLine.DELETEALL;
                end;
            }
            dataitem("Sales Comment Line"; "Sales Comment Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = CONST("Return Order"), "Print On Return Authorization" = CONST(True), "Document Line No." = CONST(0));

                trigger OnAfterGetRecord()
                begin
                    WITH TempSalesLine DO BEGIN
                        INIT;
                        "Document Type" := "Sales Header"."Document Type";
                        "Document No." := "Sales Header"."No.";
                        "Line No." := HighestLineNo + 1000;
                        HighestLineNo := "Line No.";
                    END;
                    IF STRLEN(Comment) <= MAXSTRLEN(TempSalesLine.Description) THEN BEGIN
                        TempSalesLine.Description := Comment;
                        TempSalesLine."Description 2" := '';
                    END ELSE BEGIN
                        SpacePointer := MAXSTRLEN(TempSalesLine.Description) + 1;
                        WHILE (SpacePointer > 1) AND (Comment[SpacePointer] <> ' ') DO
                            SpacePointer := SpacePointer - 1;
                        IF SpacePointer = 1 THEN
                            SpacePointer := MAXSTRLEN(TempSalesLine.Description) + 1;
                        TempSalesLine.Description := COPYSTR(Comment, 1, SpacePointer - 1);
                        TempSalesLine."Description 2" := COPYSTR(COPYSTR(Comment, SpacePointer + 1), 1, MAXSTRLEN(TempSalesLine."Description 2"));
                    END;
                    TempSalesLine.INSERT;
                end;

                trigger OnPreDataItem()
                begin
                    WITH TempSalesLine DO BEGIN
                        INIT;
                        "Document Type" := "Sales Header"."Document Type";
                        "Document No." := "Sales Header"."No.";
                        "Line No." := HighestLineNo + 1000;
                        HighestLineNo := "Line No.";
                    END;
                end;
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(ExternalDoc; "Sales Header"."External Document No.")
                    {
                    }
                    column(CompanyAddress_1_; CompanyAddress[1])
                    {
                    }
                    column(CompanyAddress_2_; CompanyAddress[2])
                    {
                    }
                    column(CompanyAddress_3_; CompanyAddress[3])
                    {
                    }
                    column(CompanyAddress_4_; CompanyAddress[4])
                    {
                    }
                    column(CompanyAddress_5_; CompanyAddress[5])
                    {
                    }
                    column(CompanyAddress_6_; CompanyAddress[6])
                    {
                    }
                    column(CopyTxt; CopyTxt)
                    {
                    }
                    column(BillToAddress_1_; BillToAddress[1])
                    {
                    }
                    column(BillToAddress_2_; BillToAddress[2])
                    {
                    }
                    column(BillToAddress_3_; BillToAddress[3])
                    {
                    }
                    column(BillToAddress_4_; BillToAddress[4])
                    {
                    }
                    column(BillToAddress_5_; BillToAddress[5])
                    {
                    }
                    column(BillToAddress_6_; BillToAddress[6])
                    {
                    }
                    column(BillToAddress_7_; BillToAddress[7])
                    {
                    }
                    column(Sales_Header___Shipment_Date_; "Sales Header"."Shipment Date")
                    {
                    }
                    column(ShipToAddress_1_; ShipToAddress[1])
                    {
                    }
                    column(ShipToAddress_2_; ShipToAddress[2])
                    {
                    }
                    column(ShipToAddress_3_; ShipToAddress[3])
                    {
                    }
                    column(ShipToAddress_4_; ShipToAddress[4])
                    {
                    }
                    column(ShipToAddress_5_; ShipToAddress[5])
                    {
                    }
                    column(ShipToAddress_6_; ShipToAddress[6])
                    {
                    }
                    column(ShipToAddress_7_; ShipToAddress[7])
                    {
                    }
                    column(Sales_Header___Bill_to_Customer_No__; "Sales Header"."Bill-to Customer No.")
                    {
                    }
                    column(Sales_Header___Your_Reference_; "Sales Header"."Your Reference")
                    {
                    }
                    column(SalesPurchPerson_Name; SalesPurchPerson.Name)
                    {
                    }
                    column(Sales_Header___No__; "Sales Header"."No.")
                    {
                    }
                    column(Sales_Header___Document_Date_; "Sales Header"."Document Date")
                    {
                    }
                    column(CurrReport_PAGENO; CurrReport.PAGENO)
                    {
                    }
                    column(CompanyAddress_7_; CompanyAddress[7])
                    {
                    }
                    column(CompanyAddress_8_; CompanyAddress[8])
                    {
                    }
                    column(BillToAddress_8_; BillToAddress[8])
                    {
                    }
                    column(ShipToAddress_8_; ShipToAddress[8])
                    {
                    }
                    column(ShipmentMethod_Description; ShipmentMethod.Description)
                    {
                    }
                    column(Sales_Header___Order_Date_; "Sales Header"."Order Date")
                    {
                    }
                    column(TaxRegLabel; TaxRegLabel)
                    {
                    }
                    column(TaxRegNo; TaxRegNo)
                    {
                    }
                    column(CopyNo; CopyNo)
                    {
                    }
                    column(PageLoop_Number; Number)
                    {
                    }
                    column(SoldCaption; SoldCaptionLbl)
                    {
                    }
                    column(To_Caption; To_CaptionLbl)
                    {
                    }
                    column(Ship_DateCaption; Ship_DateCaptionLbl)
                    {
                    }
                    column(Customer_IDCaption; Customer_IDCaptionLbl)
                    {
                    }
                    column(P_O__NumberCaption; P_O__NumberCaptionLbl)
                    {
                    }
                    column(SalesPersonCaption; SalesPersonCaptionLbl)
                    {
                    }
                    column(ShipCaption; ShipCaptionLbl)
                    {
                    }
                    column(To_Caption_Control89; To_Caption_Control89Lbl)
                    {
                    }
                    column(RETURN_AUTHORIZATIONCaption; RETURN_AUTHORIZATIONCaptionLbl)
                    {
                    }
                    column(Return_Authorization_Number_Caption; Return_Authorization_Number_CaptionLbl)
                    {
                    }
                    column(Return_Authorization_Date_Caption; Return_Authorization_Date_CaptionLbl)
                    {
                    }
                    column(Page_Caption; Page_CaptionLbl)
                    {
                    }
                    column(Ship_ViaCaption; Ship_ViaCaptionLbl)
                    {
                    }
                    column(P_O__DateCaption; P_O__DateCaptionLbl)
                    {
                    }
                    dataitem(Comment; "Integer")
                    {
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = SORTING(Number);
                        column(NewComment; txtComment[intCommentLine])
                        {
                        }
                        column(CommentGroup; intCommentLine)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            intCommentLine := intCommentLine + 1;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SETRANGE(Number, 1, intLineCount1);
                            intCommentLine := 0;
                        end;
                    }
                    dataitem(SalesLine; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(TempSalesLine__No__; TempSalesLine."No.")
                        {
                        }
                        column(TempSalesLine__Unit_of_Measure_; TempSalesLine."Unit of Measure")
                        {
                        }
                        column(TempSalesLine_Quantity; TempSalesLine.Quantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(TempSalesLine_Description_________TempSalesLine__Description_2_; TempSalesLine.Description + ' ' + TempSalesLine."Description 2")
                        {
                        }
                        column(SalesLine_Number; Number)
                        {
                        }
                        column(Item_No_Caption; Item_No_CaptionLbl)
                        {
                        }
                        column(TempSalesLine_Line_No; TempSalesLine."Line No.")
                        {
                        }
                        column(UnitCaption; UnitCaptionLbl)
                        {
                        }
                        column(DescriptionCaption; DescriptionCaptionLbl)
                        {
                        }
                        column(QuantityCaption; QuantityCaptionLbl)
                        {
                        }
                        column(TempSalesLine_ReasonCode; TempSalesLine."Return Reason Code")
                        {
                        }
                        column(TempSalesLine_Price; TempSalesLine."Unit Price")
                        {
                        }
                        column(TempSalesLine_Amount; TempSalesLine.Amount)
                        {
                        }
                        column(txtRetuenDesc; txtRetuenDesc)
                        {
                        }
                        dataitem(SalesLineComments1; "Integer")
                        {
                            DataItemLinkReference = SalesLine;
                            DataItemTableView = SORTING(Number);
                            column(recSalesLineComments_Comment; recSalesLineComments.Comment)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                IF Number = 1 THEN
                                    recSalesLineComments.FINDSET
                                ELSE
                                    recSalesLineComments.NEXT;
                            end;

                            trigger OnPreDataItem()
                            begin
                                recSalesLineComments.SETRANGE(recSalesLineComments."Document Type", TempSalesLine."Document Type");
                                recSalesLineComments.SETRANGE(recSalesLineComments."No.", TempSalesLine."Document No.");
                                recSalesLineComments.SETRANGE(recSalesLineComments."Document Line No.", TempSalesLine."Line No.");
                                SETRANGE(Number, 1, recSalesLineComments.COUNT);
                                //MESSAGE('%1',recSalesLineComments.COUNT);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            OnLineNumber := OnLineNumber + 1;
                            WITH TempSalesLine DO BEGIN
                                IF OnLineNumber = 1 THEN
                                    FIND('-')
                                ELSE
                                    NEXT;

                                IF Type = 0 THEN BEGIN
                                    "No." := '';
                                    "Unit of Measure" := '';
                                    "Line Amount" := 0;
                                    "Inv. Discount Amount" := 0;
                                    Quantity := 0;
                                END ELSE
                                    IF Type = Type::"G/L Account" THEN
                                        "No." := '';
                            END;

                            /*
                            FOR intLineCount2:=1 TO 50 DO BEGIN
                              txtComment2[intLineCount1]:='';
                            END;
                              intLineCount2:=0;
                            
                              recSalesCommentLine2.RESET;
                              recSalesCommentLine2.SETRANGE("Document Type",recSalesCommentLine2."Document Type"::"Return Order");
                              recSalesCommentLine2.SETRANGE(recSalesCommentLine2."No.",TempSalesLine."Document No.");
                              recSalesCommentLine2.SETFILTER("Document Line No.",'<>%1',0);
                              recSalesCommentLine2.SETRANGE("Line No.",TempSalesLine."Line No.");
                              IF recSalesCommentLine2.FIND('-') THEN BEGIN  REPEAT
                                 IF recSalesCommentLine2.Comment<>'' THEN BEGIN
                                    intLineCount2:=intLineCount2+1;
                                    txtComment2[intLineCount2]:=recSalesCommentLine2.Comment;
                                 END;
                                UNTIL recSalesCommentLine2.NEXT=0;
                              END;
                             */

                        end;

                        trigger OnPreDataItem()
                        begin
                            NumberOfLines := TempSalesLine.COUNT;
                            SETRANGE(Number, 1, NumberOfLines);
                            OnLineNumber := 0;
                            PrintFooter := FALSE;
                        end;
                    }
                    dataitem(SalesHeaderComments; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(recSalesHeaderComments_Comment; recSalesHeaderComments.Comment)
                        {
                        }
                        dataitem("<Sales Comment Line1>"; "Sales Comment Line")
                        {
                            DataItemLink = "No." = FIELD("No.");
                            DataItemLinkReference = "Sales Line";
                            DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.");
                            column(Comment_SalesCommentLine1; "<Sales Comment Line1>".Comment)
                            {
                            }
                            column(DocumentLineNo_SalesCommentLine1; "<Sales Comment Line1>"."Document Line No.")
                            {
                            }
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF Number = 1 THEN
                                recSalesHeaderComments.FINDSET
                            ELSE
                                recSalesHeaderComments.NEXT;
                        end;

                        trigger OnPreDataItem()
                        begin
                            recSalesHeaderComments.SETRANGE(recSalesHeaderComments."Document Type", "Sales Header"."Document Type");
                            recSalesHeaderComments.SETRANGE(recSalesHeaderComments."No.", "Sales Header"."No.");
                            recSalesHeaderComments.SETRANGE(recSalesHeaderComments."Document Line No.", 0);
                            SETRANGE(Number, 1, recSalesHeaderComments.COUNT);
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    CurrReport.PAGENO := 1;

                    IF CopyNo = NoLoops THEN BEGIN
                        IF NOT CurrReport.PREVIEW THEN
                            SalesPrinted.RUN("Sales Header");
                        CurrReport.BREAK;
                    END;
                    CopyNo := CopyNo + 1;
                    IF CopyNo = 1 THEN // Original
                        CLEAR(CopyTxt)
                    ELSE
                        CopyTxt := Text000;
                end;

                trigger OnPreDataItem()
                begin
                    NoLoops := 1 + ABS(NoCopies);
                    IF NoLoops <= 0 THEN
                        NoLoops := 1;
                    CopyNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                FOR intLineCount1 := 1 TO 50 DO BEGIN
                    txtComment[intLineCount1] := '';
                END;
                intLineCount1 := 0;

                recSalesCommentLine.RESET;
                recSalesCommentLine.SETRANGE("Document Type", recSalesCommentLine."Document Type"::"Return Order");
                recSalesCommentLine.SETRANGE(recSalesCommentLine."No.", "No.");
                recSalesCommentLine.SETRANGE(recSalesCommentLine."Document Line No.", 0);
                IF recSalesCommentLine.FIND('-') THEN BEGIN
                    REPEAT
                        IF recSalesCommentLine.Comment <> '' THEN BEGIN
                            intLineCount1 := intLineCount1 + 1;
                            txtComment[intLineCount1] := recSalesCommentLine.Comment;
                        END;
                    UNTIL recSalesCommentLine.NEXT = 0;
                END;



                IF PrintCompany THEN BEGIN
                    IF RespCenter.GET("Responsibility Center") THEN BEGIN
                        FormatAddress.RespCenter(CompanyAddress, RespCenter);
                        CompanyInformation."Phone No." := RespCenter."Phone No.";
                        CompanyInformation."Fax No." := RespCenter."Fax No.";
                    END;
                END;
                if "Language Code" <> '' then
                    CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

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

                FormatAddress.SalesHeaderSellTo(BillToAddress, "Sales Header");
                FormatAddress.SalesHeaderShipTo(ShipToAddress, ShipToAddress, "Sales Header");

                IF LogInteraction THEN
                    IF NOT CurrReport.PREVIEW THEN BEGIN
                        IF "Bill-to Contact No." <> '' THEN
                            SegManagement.LogDocument(
                              18, "No.", 0, 0, DATABASE::Contact, "Bill-to Contact No.",
                              "Salesperson Code", "Campaign No.", "Posting Description", '')
                        ELSE
                            SegManagement.LogDocument(
                              18, "No.", 0, 0, DATABASE::Customer, "Bill-to Customer No.",
                              "Salesperson Code", "Campaign No.", "Posting Description", '');
                    END;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(Picture);
                CompanyInformation.GET;
                IF PrintCompany THEN
                    FormatAddress.Company(CompanyAddress, CompanyInformation)
                ELSE
                    CLEAR(CompanyAddress);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoCopies; NoCopies)
                    {
                        Caption = 'Number of Copies';
                        ApplicationArea = all;
                    }
                    field(PrintCompany; PrintCompany)
                    {
                        Caption = 'Print Company Address';
                        ApplicationArea = all;
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := TRUE;
        end;

        trigger OnOpenPage()
        begin
            /* reactivate when HQ comes up with a code number for return authorizations
            LogInteraction := SegManagement.FindInteractTmplCode(2) <> '';
            */
            LogInteractionEnable := LogInteraction;

        end;
    }

    labels
    {
    }

    var
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        TempSalesLine: Record "Sales Line" temporary;
        RespCenter: Record "Responsibility Center";
        Language: Codeunit Language;
        CompanyAddress: array[8] of Text[50];
        BillToAddress: array[8] of Text[50];
        ShipToAddress: array[8] of Text[50];
        CopyTxt: Text[10];
        PrintCompany: Boolean;
        PrintFooter: Boolean;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        HighestLineNo: Integer;
        SpacePointer: Integer;
        SalesPrinted: Codeunit "Sales-Printed";
        FormatAddress: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        Text000: Label 'COPY';
        LogInteraction: Boolean;
        TaxRegNo: Text[30];
        TaxRegLabel: Text[30];
        [InDataSet]
        LogInteractionEnable: Boolean;
        SoldCaptionLbl: Label 'Sold';
        To_CaptionLbl: Label 'To:';
        Ship_DateCaptionLbl: Label 'Ship Date';
        Customer_IDCaptionLbl: Label 'Customer ID';
        P_O__NumberCaptionLbl: Label 'P.O. Number';
        SalesPersonCaptionLbl: Label 'SalesPerson';
        ShipCaptionLbl: Label 'Ship';
        To_Caption_Control89Lbl: Label 'To:';
        RETURN_AUTHORIZATIONCaptionLbl: Label 'RETURN AUTHORIZATION';
        Return_Authorization_Number_CaptionLbl: Label 'Return Authorization Number:';
        Return_Authorization_Date_CaptionLbl: Label 'Return Authorization Date:';
        Page_CaptionLbl: Label 'Page:';
        Ship_ViaCaptionLbl: Label 'Ship Via';
        P_O__DateCaptionLbl: Label 'P.O. Date';
        Item_No_CaptionLbl: Label 'Item No.';
        UnitCaptionLbl: Label 'Unit';
        DescriptionCaptionLbl: Label 'Description';
        QuantityCaptionLbl: Label 'Quantity';
        recReturnReason: Record "Return Reason";
        txtRetuenDesc: Text[250];
        CompanyInfo: Record "Company Information";
        txtComment: array[256] of Text[250];
        intLineCount1: Integer;
        intCommentLine: Integer;
        recSalesCommentLine: Record "Sales Comment Line";
        intLineCount2: Integer;
        txtComment2: array[256] of Text[250];
        recSalesCommentLine2: Record "Sales Comment Line";
        intCommentLine2: Integer;
        recSalesLineComments: Record "Sales Comment Line";
        recSalesHeaderComments: Record "Sales Comment Line";
}

