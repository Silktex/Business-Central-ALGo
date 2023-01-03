pageextension 50289 "Sales Order List_Ext" extends "Sales Order List"
{
    layout
    {
        addafter("No.")
        {
            field("Short Close"; Rec."Short Close")
            {
                ApplicationArea = all;
            }
        }
        addafter("Salesperson Code")
        {
            field(SalesPersonName; SalesPersonName)
            {
                Caption = 'Sales Person Name';
                ApplicationArea = all;
            }
            field("Physical Order Loc"; Rec."Physical Order Loc")
            {
                ApplicationArea = all;
            }
        }
        addafter("Job Queue Status")
        {
            field(MailSentCount; MailCountFN(Rec."No."))
            {
                Caption = 'Mail Sent Count';
                ApplicationArea = all;

                trigger OnDrillDown()
                var
                    MailSentRec: Record "Mail Detail";
                begin
                    MailSentRec.Reset;
                    MailSentRec.SetCurrentKey("Source No.", "Date Time");
                    MailSentRec.SetRange("Source No.", Rec."No.");
                    PAGE.Run(0, MailSentRec);
                end;
            }
            field("Customer Posting Group"; Rec."Customer Posting Group")
            {
                ApplicationArea = all;
            }
            field("""LastMailSenton"; LastDateMailSentFN(Rec."No."))
            {
                Caption = 'Last Mail Sent on';
                ApplicationArea = all;
            }
        }
        addafter(Control1900316107)
        {
            part(CustomerAgingFactBox; "Customer Aging FactBox")
            {
                Caption = 'Customer Aging';
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("Co&mments")
        {
            action(CreateMail)
            {
                Caption = 'Create Mail';
                Ellipsis = true;
                Image = Email;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    CUMail: Codeunit Mail_Ext;
                    //ReportHelper: Codeunit "SMTP Mail";
                    Name: Text[50];
                    FileName: Text[250];
                    ToFile: Text[250];
                    lSalesHeader: Record "Sales Header";
                begin
                    lSalesHeader := Rec;
                    IF lSalesHeader."Location Code" <> 'MATRL BANK' THEN BEGIN
                        CurrPage.SetSelectionFilter(lSalesHeader);
                        CUMail.SalesOrderOutlook(lSalesHeader, '');
                    END;
                end;
            }
        }
        addafter("Prepayment Credi&t Memos")
        {
            action(StandardComment)
            {
                Caption = 'Standard Comment';
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    CommentsalesNew: Page "Comment sales New";
                begin
                    CommentsalesNew.FilterFind(Rec."No.");
                    CommentsalesNew.Run;
                end;
            }
        }
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                Rec."Posting Date" := Today;
            end;
        }
        modify("Post &Batch")
        {
            trigger OnBeforeAction()
            begin
                Rec."Posting Date" := Today;
            end;
        }
        addafter("Pick Instruction")
        {
            action(CFTPackingList)
            {
                Caption = 'CFT Packing List';
                Ellipsis = true;
                Image = Print;
                ApplicationArea = all;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    REPORT.Run(50050, true, true, Rec);
                    Rec.Reset;
                end;
            }
            action(SendEmailPDF)
            {
                Caption = 'Send Email PDF';
                Image = SendEmailPDF;
                ApplicationArea = all;

                trigger OnAction()
                var
                    SendSmtpMail: Codeunit SmtpMail_Ext;
                    UserSetup: Record "User Setup";
                    TEXT001: Label 'You are not authorized.';
                begin
                    if UserSetup.Get(UserId) and UserSetup."Sent Mail Sales Order" then begin
                        IF Rec."Location Code" <> 'MATRL BANK' then begin
                            CurrPage.SetSelectionFilter(Rec);
                            Rec.Copy(Rec);
                            if Rec.FindFirst then
                                repeat
                                    SendSmtpMail.SendSalesOrderAsPDF(Rec);
                                until Rec.Next = 0;
                        end;
                        Rec.Reset;
                        CurrPage.Update(true);
                    end else
                        Message(TEXT001);
                end;
            }
            action(ImportSalesOrder)
            {
                Caption = 'Import Sales Order';
                Ellipsis = true;
                Image = "Order";
                ApplicationArea = all;

                trigger OnAction()
                var
                    Selection: Integer;
                begin
                    Selection := StrMenu(Text002, 2);
                    if Selection = 1 then begin
                        ExcelBuff.Reset;
                        ExcelBuff.DeleteAll;
                        CreateExcelBook;
                    end else
                        RepImportSalesOeder.Run;
                end;
            }
        }
        modify("Print Confirmation")
        {
            Visible = false;
        }
        addafter("Print Confirmation")
        {
            action("Print ConfirmationNew")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print Confirmation';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category8;
                ToolTip = 'Print an order confirmation. A report request window opens where you can specify what to include on the print-out.';
                //Visible = NOT IsOfficeAddin;

                trigger OnAction()
                var
                    Rec36: Record "Sales Header";
                    compInfo: Record "Company Information";
                begin
                    //DocPrint.PrintSalesOrder(Rec, Usage::"Order Confirmation");
                    compInfo.get();
                    CurrPage.SetSelectionFilter(Rec36);
                    IF compInfo."Report Selection" = compInfo."Report Selection"::Slik then
                        REPORT.Run(50123, true, false, Rec36)
                    else
                        REPORT.Run(70001, true, false, Rec36)
                end;
            }
        }
        addafter("Sales Reservation Avail.")
        {
            action(OpenSOReport)
            {
                Caption = 'Open SO Report';
                Description = 'Open SO Report';
                Image = "Report";
                Visible = ShowSilkReport;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Open SO Report";
                ToolTip = 'Open SO Report';
                ApplicationArea = all;
            }
            action(OpenSOReportPOSh)
            {
                Caption = 'Open SO Report POSH';
                Description = 'Open SO Report POSH';
                Visible = ShowPoshReport;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Open SO Report POSH";
                ToolTip = 'Open SO Report';
                ApplicationArea = all;
            }
            action(ShippedGoodsReport)
            {
                Caption = 'Shipped Goods Report Manual';
                Description = 'Shipped Goods Report Manual';
                Visible = ShowPoshReport;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Shipped Goods Report Manual";
                ToolTip = 'Shipped Goods Report Manual';
                ApplicationArea = all;
            }
            action(ShippedSampleReport)
            {
                Caption = 'Shipped Sample Report Manual';
                Description = 'Shipped Sample Report Manual';
                Image = "Report";
                Visible = ShowPoshReport;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Shipped Samples Report Manual";
                ToolTip = 'Shipped Sample Report Manual';
                ApplicationArea = all;
            }
        }

    }
    trigger OnOpenPage()
    var
        compInfo: Record "Company Information";
    begin
        Rec.SetRange("Short Close", false);
        compInfo.get();
        IF compInfo."Report Selection" = compInfo."Report Selection"::Slik then
            ShowSilkReport := true;
        IF compInfo."Report Selection" = compInfo."Report Selection"::POSH then
            ShowPoshReport := true;
    end;

    trigger OnAfterGetRecord()
    var
        compInfo: Record "Company Information";
    begin
        SalesPersonName := SalesPersonNames(Rec."Salesperson Code");
        compInfo.get();
        IF compInfo."Report Selection" = compInfo."Report Selection"::Slik then
            ShowSilkReport := true;
        IF compInfo."Report Selection" = compInfo."Report Selection"::POSH then
            ShowPoshReport := true;
    end;

    var
        ShowSilkReport: Boolean;
        ShowPoshReport: Boolean;
        SalesPersonName: Text[100];
        Text001: Label 'Order Import Format';
        Text002: Label 'Export Format,Import Data';
        ExcelBuff: Record "Excel Buffer";
        RepImportSalesOeder: Report "Import Sales Order New";

    procedure SalesPersonNames(SalesPersonCode: Code[30]): Text
    var
        recSalesPurchaser: Record "Salesperson/Purchaser";
    begin
        if recSalesPurchaser.Get(SalesPersonCode) then
            exit(recSalesPurchaser.Name);
    end;

    procedure MailCountFN(RecNo: Code[20]): Integer
    var
        RecMailDetail: Record "Mail Detail";
        TotalNo: Integer;
    begin
        RecMailDetail.Reset;
        RecMailDetail.SetCurrentKey("Source No.", "Date Time");
        RecMailDetail.SetRange("Source No.", RecNo);
        if RecMailDetail.FindSet then
            TotalNo := RecMailDetail.Count;
        exit(TotalNo);
    end;

    procedure LastDateMailSentFN(OrderNo: Code[20]): DateTime
    var
        RecMailDetails: Record "Mail Detail";
        LastSentDate: DateTime;
    begin
        RecMailDetails.Reset;
        RecMailDetails.SetCurrentKey("Source No.", "Date Time");
        RecMailDetails.SetRange("Source No.", OrderNo);
        if RecMailDetails.FindLast then
            LastSentDate := RecMailDetails."Date Time";
        exit(LastSentDate);
    end;

    procedure CreateExcelBook()
    begin
        MakeExcelDataHeader;
        ExcelBuff.CreateNewBook(Text001);
        ExcelBuff.WriteSheet(Text001, CompanyName, UserId);
        ExcelBuff.CloseBook;
        ExcelBuff.SetFriendlyFilename('Order Import Format');
        ExcelBuff.OpenExcel;
        //ExcelBuff.GiveUserControl;
    end;

    procedure MakeExcelDataHeader()
    begin
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn('Order No.', false, 'Order No.', true, true, false, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Customer No.', false, 'Customer No.', true, true, false, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Type', false, 'Type', true, true, false, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Item No.', false, 'Item No.', true, true, false, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Quantity', false, 'Quantity', true, true, false, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Lot No.', false, 'Lot No.', true, true, false, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Location Code', false, 'Location Code', true, true, false, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Discount %', false, 'Discount %', true, true, false, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Unit Price', false, 'Unit Price', true, true, false, '', ExcelBuff."Cell Type"::Text);
    end;
}
