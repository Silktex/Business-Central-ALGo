page 50080 "Completed Sales Order List"
{
    Caption = 'Completed Sales Order List';
    CardPageID = "Sales Order";
    Editable = false;
    PageType = List;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Document Type" = CONST(Order),
                            "Short Close" = FILTER(true));
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = all;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Sell-to Contact"; Rec."Sell-to Contact")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Bill-to Post Code"; Rec."Bill-to Post Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Bill-to Contact"; Rec."Bill-to Contact")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                    Visible = true;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(SalesPersonName; SalesPersonName)
                {
                    ApplicationArea = all;
                    Caption = 'Sales Person Name';
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Campaign No."; Rec."Campaign No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Payment Discount %"; Rec."Payment Discount %")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Shipping Advice"; Rec."Shipping Advice")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Completely Shipped"; Rec."Completely Shipped")
                {
                    ApplicationArea = all;
                }
                field("Job Queue Status"; Rec."Job Queue Status")
                {
                    ApplicationArea = all;
                    Visible = JobQueueActive;
                }
                field(MailSentCount; MailCountFN(Rec."No."))
                {
                    ApplicationArea = all;
                    Caption = 'Mail Sent Count';

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
                    ApplicationArea = all;
                    Caption = 'Last Mail Sent on';
                }
            }
        }
        area(factboxes)
        {
            part(Control1902018507; "Customer Statistics FactBox")
            {
                ApplicationArea = all;
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                Visible = true;
            }
            part(Control1900316107; "Customer Details FactBox")
            {
                ApplicationArea = all;
                SubPageLink = "No." = FIELD("Sell-to Customer No.");
                Visible = true;
            }
            part(CustomerAgingFactBox; "Customer Aging FactBox")
            {
                ApplicationArea = all;
                Caption = 'Customer Aging';
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = all;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = all;
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("O&rder")
            {
                Caption = 'O&rder';
                Image = "Order";
                action(Dimensions)
                {
                    ApplicationArea = all;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                    end;
                }
                action(Statistics)
                {
                    ApplicationArea = all;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        Rec.CalcInvDiscForHeader;
                        Commit;
                        if Rec."Tax Area Code" = '' then
                            PAGE.RunModal(PAGE::"Sales Order Statistics", Rec)
                        else
                            PAGE.RunModal(PAGE::"Sales Order Stats.", Rec)
                    end;
                }
                action("A&pprovals")
                {
                    ApplicationArea = all;
                    Caption = 'A&pprovals';
                    Image = Approvals;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.SetRecordFilters(DATABASE::"Sales Header", Rec."Document Type".AsInteger(), Rec."No.");
                        ApprovalEntries.Run;
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = all;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                }
                action(CreateMail)
                {
                    ApplicationArea = all;
                    Caption = 'Create Mail';
                    Ellipsis = true;
                    Image = Email;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        CUMail: Codeunit Mail_Ext;
                        Name: Text[50];
                        FileName: Text[250];
                        ToFile: Text[250];
                        lSalesHeader: Record "Sales Header";
                    begin
                        lSalesHeader := Rec;
                        IF lSalesHeader."Location Code" <> 'MATRL BANK' then begin
                            CurrPage.SetSelectionFilter(lSalesHeader);
                            CUMail.SalesOrderOutlook(lSalesHeader, '');
                        end;
                    end;
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
                action("S&hipments")
                {
                    ApplicationArea = all;
                    Caption = 'S&hipments';
                    Image = Shipment;
                    RunObject = Page "Posted Sales Shipments";
                    RunPageLink = "Order No." = FIELD("No.");
                    RunPageView = SORTING("Order No.");
                }
                action(Invoices)
                {
                    ApplicationArea = all;
                    Caption = 'Invoices';
                    Image = Invoice;
                    RunObject = Page "Posted Sales Invoices";
                    RunPageLink = "Order No." = FIELD("No.");
                    RunPageView = SORTING("Order No.");
                }
                action("Prepa&yment Invoices")
                {
                    ApplicationArea = all;
                    Caption = 'Prepa&yment Invoices';
                    Image = PrepaymentInvoice;
                    RunObject = Page "Posted Sales Invoices";
                    RunPageLink = "Prepayment Order No." = FIELD("No.");
                    RunPageView = SORTING("Prepayment Order No.");
                }
                action("Prepayment Credi&t Memos")
                {
                    ApplicationArea = all;
                    Caption = 'Prepayment Credi&t Memos';
                    Image = PrepaymentCreditMemo;
                    RunObject = Page "Posted Sales Credit Memos";
                    RunPageLink = "Prepayment Order No." = FIELD("No.");
                    RunPageView = SORTING("Prepayment Order No.");
                }
                action(StandardComment)
                {
                    ApplicationArea = all;
                    Caption = 'Standard Comment';
                    Ellipsis = true;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        CommentsalesNew: Page "Comment sales New";
                    begin
                        CommentsalesNew.FilterFind(Rec."No.");
                        CommentsalesNew.Run;
                    end;
                }
            }
            group(Warehouse)
            {
                Caption = 'Warehouse';
                Image = Warehouse;
                action("Whse. Shipment Lines")
                {
                    ApplicationArea = all;
                    Caption = 'Whse. Shipment Lines';
                    Image = ShipmentLines;
                    RunObject = Page "Whse. Shipment Lines";
                    RunPageLink = "Source Type" = CONST(37),
                                  "Source Subtype" = FIELD("Document Type"),
                                  "Source No." = FIELD("No.");
                    RunPageView = SORTING("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                }
                action("In&vt. Put-away/Pick Lines")
                {
                    ApplicationArea = all;
                    Caption = 'In&vt. Put-away/Pick Lines';
                    Image = PickLines;
                    RunObject = Page "Warehouse Activity List";
                    RunPageLink = "Source Document" = CONST("Sales Order"),
                                  "Source No." = FIELD("No.");
                    RunPageView = SORTING("Source Document", "Source No.", "Location Code");
                }
            }
        }
        area(processing)
        {
            group(Release)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action("Re&lease")
                {
                    ApplicationArea = all;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualRelease(Rec);
                    end;
                }
                action("Re&open")
                {
                    ApplicationArea = all;
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualReopen(Rec);
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Pla&nning")
                {
                    ApplicationArea = all;
                    Caption = 'Pla&nning';
                    Image = Planning;

                    trigger OnAction()
                    var
                        SalesOrderPlanningForm: Page "Sales Order Planning";
                    begin
                        SalesOrderPlanningForm.SetSalesOrder(Rec."No.");
                        SalesOrderPlanningForm.RunModal;
                    end;
                }
                action("Order &Promising")
                {
                    ApplicationArea = all;
                    Caption = 'Order &Promising';
                    Image = OrderPromising;

                    trigger OnAction()
                    var
                        OrderPromisingLine: Record "Order Promising Line" temporary;
                    begin
                        OrderPromisingLine.SetRange("Source Type", Rec."Document Type");
                        OrderPromisingLine.SetRange("Source ID", Rec."No.");
                        PAGE.RunModal(PAGE::"Order Promising Lines", OrderPromisingLine);
                    end;
                }
                action("Send A&pproval Request")
                {
                    ApplicationArea = all;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalsMgmt.CheckSalesApprovalPossible(Rec) then
                            ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                    end;
                }
                action("Cancel Approval Re&quest")
                {
                    ApplicationArea = all;
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                    begin
                        ApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
                        WorkflowWebhookMgt.FindAndCancel(Rec.RecordId);
                    end;
                }
                action("Send IC Sales Order Cnfmn.")
                {
                    ApplicationArea = all;
                    Caption = 'Send IC Sales Order Cnfmn.';
                    Image = IntercompanyOrder;

                    trigger OnAction()
                    var
                        ICInOutboxMgt: Codeunit ICInboxOutboxMgt;
                        PurchaseHeader: Record "Purchase Header";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalsMgmt.PrePostApprovalCheckSales(Rec) then
                            ICInOutboxMgt.SendSalesDoc(Rec, false);
                    end;
                }
            }
            group(Action3)
            {
                Caption = 'Warehouse';
                Image = Warehouse;
                action("Create Inventor&y Put-away/Pick")
                {
                    ApplicationArea = all;
                    Caption = 'Create Inventor&y Put-away/Pick';
                    Ellipsis = true;
                    Image = CreatePutawayPick;

                    trigger OnAction()
                    begin
                        Rec.CreateInvtPutAwayPick;

                        if not Rec.Find('=><') then
                            Rec.Init;
                    end;
                }
                action("Create &Whse. Shipment")
                {
                    ApplicationArea = all;
                    Caption = 'Create &Whse. Shipment';
                    Image = NewShipment;

                    trigger OnAction()
                    var
                        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
                    begin
                        GetSourceDocOutbound.CreateFromSalesOrder(Rec);

                        if not Rec.Find('=><') then
                            Rec.Init;
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("P&ost")
                {
                    ApplicationArea = all;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Rec."Posting Date" := Today;
                        Rec.SendToPosting(CODEUNIT::"Sales-Post (Yes/No)");
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = all;
                    Caption = 'Post and &Print';
                    Ellipsis = true;
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        Rec."Posting Date" := Today;
                        Rec.SendToPosting(CODEUNIT::"Sales-Post + Print");
                    end;
                }
                action("Test Report")
                {
                    ApplicationArea = all;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintSalesHeader(Rec);
                    end;
                }
                action("Post &Batch")
                {
                    ApplicationArea = all;
                    Caption = 'Post &Batch';
                    Ellipsis = true;
                    Image = PostBatch;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec."Posting Date" := Today;
                        REPORT.RunModal(REPORT::"Batch Post Sales Orders", true, true, Rec);
                        CurrPage.Update(false);
                    end;
                }
                action("Remove From Job Queue")
                {
                    ApplicationArea = all;
                    Caption = 'Remove From Job Queue';
                    Image = RemoveLine;
                    Visible = JobQueueActive;

                    trigger OnAction()
                    begin
                        Rec.CancelBackgroundPosting;
                    end;
                }
            }
            group("&Print")
            {
                Caption = '&Print';
                Image = Print;
                action("Order Confirmation")
                {
                    ApplicationArea = all;
                    Caption = 'Order Confirmation';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Rec36: Record "Sales Header";
                    begin
                        //DocPrint.PrintSalesOrder(Rec,Usage::"Order Confirmation");
                        CurrPage.SetSelectionFilter(Rec36);
                        REPORT.Run(50123, true, false, Rec36);
                    end;
                }
                action("Work Order")
                {
                    ApplicationArea = all;
                    Caption = 'Work Order';
                    Ellipsis = true;
                    Image = Print;

                    trigger OnAction()
                    begin
                        DocPrint.PrintSalesOrder(Rec, Usage::"Work Order");
                    end;
                }
                action("Pick Instruction")
                {
                    ApplicationArea = all;
                    Caption = 'Pick Instruction';
                    Image = Print;

                    trigger OnAction()
                    begin
                        DocPrint.PrintSalesOrder(Rec, Usage::"Pick Instruction");
                    end;
                }
                action(CFTPackingList)
                {
                    ApplicationArea = all;
                    Caption = 'CFT Packing List';
                    Ellipsis = true;
                    Image = Print;

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(Rec);
                        REPORT.Run(50050, true, true, Rec);
                        Rec.Reset;
                    end;
                }
                action(SendEmailPDF)
                {
                    ApplicationArea = all;
                    Caption = 'Send Email PDF';
                    Image = SendEmailPDF;

                    trigger OnAction()
                    var
                        SendSmtpMail: Codeunit SmtpMail_Ext;
                        UserSetup: Record "User Setup";
                        TEXT001: Label 'You are not authorized.';
                    begin
                        if UserSetup.Get(UserId) and UserSetup."Sent Mail Sales Order" then begin
                            IF rec."Location Code" <> 'MATRL BANK' THEN BEGIN
                                CurrPage.SetSelectionFilter(Rec);
                                Rec.Copy(Rec);
                                if Rec.FindFirst then
                                    repeat
                                        SendSmtpMail.SendSalesOrderAsPDF(Rec);
                                    until Rec.Next = 0;
                            END;
                            Rec.Reset;
                            CurrPage.Update(true);
                        end else
                            Message(TEXT001);
                    end;
                }
                action(ImportSalesOrder)
                {
                    ApplicationArea = all;
                    Caption = 'Import Sales Order';
                    Ellipsis = true;
                    Image = "Order";
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

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
        }
        area(reporting)
        {
            action("Sales Reservation Avail.")
            {
                ApplicationArea = all;
                Caption = 'Sales Reservation Avail.';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Sales Reservation Avail.";
            }
            action(OpenSOReport)
            {
                ApplicationArea = all;
                Caption = 'Open SO Report';
                Description = 'Open SO Report';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Open SO Report";
                ToolTip = 'Open SO Report';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SalesPersonName := SalesPersonNames(Rec."Salesperson Code");
    end;

    trigger OnOpenPage()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        if UserMgt.GetSalesFilter <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetSalesFilter);
            Rec.FilterGroup(0);
        end;

        Rec.SetRange("Date Filter", 0D, WorkDate - 1);

        JobQueueActive := SalesSetup.JobQueueActive;
    end;

    var
        DocPrint: Codeunit "Document-Print";
        ReportPrint: Codeunit "Test Report-Print";
        UserMgt: Codeunit "User Setup Management";
        Usage: Option "Order Confirmation","Work Order","Pick Instruction";
        [InDataSet]
        JobQueueActive: Boolean;
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

