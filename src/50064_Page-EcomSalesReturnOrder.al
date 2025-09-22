page 50064 "Ecom Sales Return Order"
{
    Caption = 'Ecom Sales Return Order';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Document Type" = FILTER("Return Order"),
                            "Short Close" = FILTER(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Sell-to Contact No."; Rec."Sell-to Contact No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        if Rec.GetFilter("Sell-to Contact No.") = xRec."Sell-to Contact No." then
                            if Rec."Sell-to Contact No." <> xRec."Sell-to Contact No." then
                                Rec.SetRange("Sell-to Contact No.");
                    end;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Sell-to Address 2"; Rec."Sell-to Address 2")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Sell-to City"; Rec."Sell-to City")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }
                field("Sell-to County"; Rec."Sell-to County")
                {
                    ApplicationArea = All;
                    Caption = 'Sell-to State / ZIP Code';
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Sell-to Contact"; Rec."Sell-to Contact")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("No. of Archived Versions"; Rec."No. of Archived Versions")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    QuickEntry = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Promised Delivery Date"; Rec."Promised Delivery Date")
                {
                    ApplicationArea = All;
                    Importance = Standard;
                    NotBlank = true;
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = All;
                }
                field("Quote No."; Rec."Quote No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    QuickEntry = false;

                    trigger OnValidate()
                    begin
                        SalespersonCodeOnAfterValidate;
                    end;
                }
                field("Campaign No."; Rec."Campaign No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Opportunity No."; Rec."Opportunity No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Job Queue Status"; Rec."Job Queue Status")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    QuickEntry = false;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Commission Override"; Rec."Commission Override")
                {
                    ApplicationArea = All;
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        if Rec."Commission Override" then
                            if not Confirm('Do you want to override commision Amount', true) then
                                Error('Commision Override must be no');

                        if Rec."Commission Override" then
                            blnOverride := true
                        else
                            blnOverride := false;
                    end;
                }
                field("Commision %"; Rec."Commision %")
                {
                    ApplicationArea = All;
                    Editable = blnOverride;
                    Importance = Additional;
                }
            }
            part(SalesLines; "Sales Return Order Subform NOP")
            {
                ApplicationArea = All;
                Editable = DynamicEditable;
                SubPageLink = "Document No." = FIELD("No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        BilltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Bill-to Contact No."; Rec."Bill-to Contact No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Bill-to Address 2"; Rec."Bill-to Address 2")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Bill-to City"; Rec."Bill-to City")
                {
                    ApplicationArea = All;
                }
                field("Bill-to County"; Rec."Bill-to County")
                {
                    ApplicationArea = All;
                    Caption = 'State / ZIP Code';
                }
                field("Bill-to Post Code"; Rec."Bill-to Post Code")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Bill-to Contact"; Rec."Bill-to Contact")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        ShortcutDimension2CodeOnAfterV;
                    end;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Payment Discount %"; Rec."Payment Discount %")
                {
                    ApplicationArea = All;
                }
                field("Pmt. Discount Date"; Rec."Pmt. Discount Date")
                {
                    ApplicationArea = All;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = All;
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Direct Debit Mandate ID"; Rec."Direct Debit Mandate ID")
                {
                    ApplicationArea = All;
                }
                field("Credit Card No."; Rec."Credit Card No.")
                {
                    ApplicationArea = All;
                }
                field(GetCreditcardNumber; Rec.GetCreditcardNumber)
                {
                    ApplicationArea = All;
                    Caption = 'Cr. Card Number (Last 4 Digits)';
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Ship-to Address 2"; Rec."Ship-to Address 2")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = All;
                }
                field("Ship-to County"; Rec."Ship-to County")
                {
                    ApplicationArea = All;
                    Caption = 'Ship-to State / ZIP Code';
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Shipping Time"; Rec."Shipping Time")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Ship-to UPS Zone"; Rec."Ship-to UPS Zone")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Outbound Whse. Handling Time"; Rec."Outbound Whse. Handling Time")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = All;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                    ApplicationArea = All;
                }
                field("Late Order Shipping"; Rec."Late Order Shipping")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Package Tracking No."; Rec."Package Tracking No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Shipping Advice"; Rec."Shipping Advice")
                {
                    ApplicationArea = All;
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        if Rec."Shipping Advice" <> xRec."Shipping Advice" then
                            if not Confirm(Text001, false, Rec.FieldCaption("Shipping Advice")) then
                                Error(Text002);
                    end;
                }
                field(Residential; Rec.Residential)
                {
                    ApplicationArea = All;
                }
                field(AddressValidated; Rec.AddressValidated)
                {
                    ApplicationArea = All;
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        Clear(ChangeExchangeRate);
                        if Rec."Posting Date" <> 0D then
                            ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date")
                        else
                            ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", WorkDate);
                        if ChangeExchangeRate.RunModal = ACTION::OK then begin
                            Rec.Validate("Currency Factor", ChangeExchangeRate.GetParameter);
                            CurrPage.Update;
                        end;
                        Clear(ChangeExchangeRate);
                    end;
                }
                field("EU 3-Party Trade"; Rec."EU 3-Party Trade")
                {
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                }
                field("Transaction Specification"; Rec."Transaction Specification")
                {
                    ApplicationArea = All;
                }
                field("Transport Method"; Rec."Transport Method")
                {
                    ApplicationArea = All;
                }
                field("Exit Point"; Rec."Exit Point")
                {
                    ApplicationArea = All;
                }
                field("Area"; Rec.Area)
                {
                    ApplicationArea = All;
                }
            }
            group(Control1900201301)
            {
                Caption = 'Prepayment';
                field("Prepayment %"; Rec."Prepayment %")
                {
                    ApplicationArea = All;
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        Prepayment37OnAfterValidate;
                    end;
                }
                field("Compress Prepayment"; Rec."Compress Prepayment")
                {
                    ApplicationArea = All;
                }
                field("Prepmt. Payment Terms Code"; Rec."Prepmt. Payment Terms Code")
                {
                    ApplicationArea = All;
                }
                field("Prepayment Due Date"; Rec."Prepayment Due Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Prepmt. Payment Discount %"; Rec."Prepmt. Payment Discount %")
                {
                    ApplicationArea = All;
                }
                field("Prepmt. Pmt. Discount Date"; Rec."Prepmt. Pmt. Discount Date")
                {
                    ApplicationArea = All;
                }
                field("Prepmt. Include Tax"; Rec."Prepmt. Include Tax")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(Control1903720907; "Sales Hist. Sell-to FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Sell-to Customer No.");
                Visible = true;
            }
            part(Control1902018507; "Customer Statistics FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                Visible = false;
            }
            part(Control1900316107; "Customer Details FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Sell-to Customer No.");
                Visible = false;
            }
            part(Control1906127307; "Sales Line FactBox")
            {
                ApplicationArea = All;
                Provider = SalesLines;
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
                Visible = true;
            }
            part(Control1901314507; "Item Invoicing FactBox")
            {
                ApplicationArea = All;
                Provider = SalesLines;
                SubPageLink = "No." = FIELD("No.");
                Visible = false;
            }
            part(Control1906354007; "Approval FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = CONST(36),
                              "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
                Visible = false;
            }
            part(Control1907012907; "Resource Details FactBox")
            {
                ApplicationArea = All;
                Provider = SalesLines;
                SubPageLink = "No." = FIELD("No.");
                Visible = false;
            }
            part(Control1901796907; "Item Warehouse FactBox")
            {
                ApplicationArea = All;
                Provider = SalesLines;
                SubPageLink = "No." = FIELD("No.");
                Visible = false;
            }
            part(Control1907234507; "Sales Hist. Bill-to FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                Visible = false;
            }
            part(CustomerAgingFactBox; "Customer Aging FactBox")
            {
                ApplicationArea = All;
                Caption = 'Customer Aging';
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
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
                action(Statistics)
                {
                    ApplicationArea = All;
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
                action(Card)
                {
                    ApplicationArea = All;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = FIELD("Sell-to Customer No.");
                    ShortCutKey = 'Shift+F7';
                }
                action(Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
                action("A&pprovals")
                {
                    ApplicationArea = All;
                    Caption = 'A&pprovals';
                    Image = Approvals;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.SetRecordfilters(DATABASE::"Sales Header", Rec."Document Type".AsInteger(), Rec."No.");
                        ApprovalEntries.Run;
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                }
                action(CopyComment)
                {
                    ApplicationArea = All;
                    Caption = 'Copy Standard Comment';
                    Ellipsis = true;
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        Error('Process is under construction.');
                        //>>Ashwini
                        //Copy Header Comment
                        recStandardComment.Reset;
                        recStandardComment.SetRange(recStandardComment."Product Code", '');
                        recStandardComment.SetRange(recStandardComment."Sales Type", recStandardComment."Sales Type"::Customer);
                        recStandardComment.SetRange(recStandardComment."Sales Code", Rec."Sell-to Customer No.");
                        if recStandardComment.FindFirst then begin
                            if recStandardComment.Comment <> '' then begin
                                FiltrtCommtLine;
                                recSalesCommentLine.SetRange(recSalesCommentLine."Document Line No.", 0);
                                recSalesCommentLine.SetRange(recSalesCommentLine.Comment, recStandardComment.Comment);
                                if not recSalesCommentLine.FindFirst then begin
                                    recSalesCommentLine1.Reset;
                                    recSalesCommentLine1.SetRange(recSalesCommentLine1."Document Type", Rec."Document Type");
                                    recSalesCommentLine1.SetRange(recSalesCommentLine1."No.", Rec."No.");
                                    recSalesCommentLine1.SetRange(recSalesCommentLine1."Document Line No.", 0);
                                    if recSalesCommentLine1.FindLast then
                                        LineNo := recSalesCommentLine1."Line No."
                                    else
                                        LineNo := 0;
                                    InsertCom(LineNo, 0, recStandardComment.Comment, recStandardComment.External);
                                end;
                            end;

                            if recStandardComment."Comment 2" <> '' then begin
                                FiltrtCommtLine;
                                recSalesCommentLine.SetRange(recSalesCommentLine."Document Line No.", 0);
                                recSalesCommentLine.SetRange(recSalesCommentLine.Comment, recStandardComment."Comment 2");
                                if not recSalesCommentLine.FindFirst then begin
                                    recSalesCommentLine1.Reset;
                                    recSalesCommentLine1.SetRange(recSalesCommentLine1."Document Type", Rec."Document Type");
                                    recSalesCommentLine1.SetRange(recSalesCommentLine1."No.", Rec."No.");
                                    recSalesCommentLine1.SetRange(recSalesCommentLine1."Document Line No.", 0);
                                    if recSalesCommentLine1.FindLast then
                                        LineNo := recSalesCommentLine1."Line No."
                                    else
                                        LineNo := 0;
                                    InsertCom(LineNo, 0, recStandardComment."Comment 2", recStandardComment.External);
                                end;
                            end;

                            if recStandardComment."Comment 3" <> '' then begin
                                FiltrtCommtLine;
                                recSalesCommentLine.SetRange(recSalesCommentLine."Document Line No.", 0);
                                recSalesCommentLine.SetRange(recSalesCommentLine.Comment, recStandardComment."Comment 3");
                                if not recSalesCommentLine.FindFirst then begin
                                    recSalesCommentLine1.Reset;
                                    recSalesCommentLine1.SetRange(recSalesCommentLine1."Document Type", Rec."Document Type");
                                    recSalesCommentLine1.SetRange(recSalesCommentLine1."No.", Rec."No.");
                                    recSalesCommentLine1.SetRange(recSalesCommentLine1."Document Line No.", 0);
                                    if recSalesCommentLine1.FindLast then
                                        LineNo := recSalesCommentLine1."Line No."
                                    else
                                        LineNo := 0;
                                    InsertCom(LineNo, 0, recStandardComment."Comment 3", recStandardComment.External);
                                end;
                            end;

                            if recStandardComment."Comment 4" <> '' then begin
                                FiltrtCommtLine;
                                recSalesCommentLine.SetRange(recSalesCommentLine."Document Line No.", 0);
                                recSalesCommentLine.SetRange(recSalesCommentLine.Comment, recStandardComment."Comment 4");
                                if not recSalesCommentLine.FindFirst then begin
                                    recSalesCommentLine1.Reset;
                                    recSalesCommentLine1.SetRange(recSalesCommentLine1."Document Type", Rec."Document Type");
                                    recSalesCommentLine1.SetRange(recSalesCommentLine1."No.", Rec."No.");
                                    recSalesCommentLine1.SetRange(recSalesCommentLine1."Document Line No.", 0);
                                    if recSalesCommentLine1.FindLast then
                                        LineNo := recSalesCommentLine1."Line No."
                                    else
                                        LineNo := 0;
                                    InsertCom(LineNo, 0, recStandardComment."Comment 4", recStandardComment.External);
                                end;
                            end;

                            if recStandardComment."Comment 5" <> '' then begin
                                FiltrtCommtLine;
                                recSalesCommentLine.SetRange(recSalesCommentLine."Document Line No.", 0);
                                recSalesCommentLine.SetRange(recSalesCommentLine.Comment, recStandardComment."Comment 5");
                                if not recSalesCommentLine.FindFirst then begin
                                    recSalesCommentLine1.Reset;
                                    recSalesCommentLine1.SetRange(recSalesCommentLine1."Document Type", Rec."Document Type");
                                    recSalesCommentLine1.SetRange(recSalesCommentLine1."No.", Rec."No.");
                                    recSalesCommentLine1.SetRange(recSalesCommentLine1."Document Line No.", 0);
                                    if recSalesCommentLine1.FindLast then
                                        LineNo := recSalesCommentLine1."Line No."
                                    else
                                        LineNo := 0;
                                    InsertCom(LineNo, 0, recStandardComment."Comment 5", recStandardComment.External);
                                end;
                            end;
                        end;


                        //Copy Line comment
                        recSalesLine1.Reset;
                        recSalesLine1.SetRange(recSalesLine1."Document Type", recSalesLine1."Document Type"::Order);
                        recSalesLine1.SetRange(recSalesLine1.Type, recSalesLine1.Type::Item);
                        recSalesLine1.SetRange(recSalesLine1."Document No.", Rec."No.");
                        if recSalesLine1.FindFirst then
                            repeat
                                recStandardComment.Reset;
                                recStandardComment.SetRange(recStandardComment."Product Code", recSalesLine1."Item Category Code");
                                if recStandardComment."Sales Type" = recStandardComment."Sales Type"::Customer then
                                    recStandardComment.SetRange(recStandardComment."Sales Code", recSalesLine1."Sell-to Customer No.");
                                if recStandardComment."Sales Type" = recStandardComment."Sales Type"::"All Customer" then
                                    recStandardComment.SetRange(recStandardComment."Sales Code", '');
                                if recStandardComment."Sales Type" = recStandardComment."Sales Type"::"Customer Price Group" then
                                    recStandardComment.SetRange(recStandardComment."Sales Code", recSalesLine1."Customer Price Group");
                                if recStandardComment.FindFirst then begin
                                    if recStandardComment.Comment <> '' then begin
                                        FiltrtCommtLine;
                                        recSalesCommentLine.SetRange(recSalesCommentLine."Document Line No.", recSalesLine1."Line No.");
                                        recSalesCommentLine.SetRange(recSalesCommentLine.Comment, recStandardComment.Comment);
                                        if not recSalesCommentLine.FindFirst then begin
                                            recSalesCommentLine1.Reset;
                                            recSalesCommentLine1.SetRange(recSalesCommentLine1."Document Type", Rec."Document Type");
                                            recSalesCommentLine1.SetRange(recSalesCommentLine1."No.", Rec."No.");
                                            recSalesCommentLine1.SetRange(recSalesCommentLine1."Document Line No.", recSalesLine1."Line No.");
                                            if recSalesCommentLine1.FindLast then
                                                LineNo := recSalesCommentLine1."Line No."
                                            else
                                                LineNo := 0;
                                            InsertCom(LineNo, recSalesLine1."Line No.", recStandardComment.Comment, recStandardComment.External);
                                        end;
                                    end;

                                    if recStandardComment."Comment 2" <> '' then begin
                                        FiltrtCommtLine;
                                        recSalesCommentLine.SetRange(recSalesCommentLine."Document Line No.", recSalesLine1."Line No.");
                                        recSalesCommentLine.SetRange(recSalesCommentLine.Comment, recStandardComment."Comment 2");
                                        if not recSalesCommentLine.FindFirst then begin
                                            recSalesCommentLine1.Reset;
                                            recSalesCommentLine1.SetRange(recSalesCommentLine1."Document Type", Rec."Document Type");
                                            recSalesCommentLine1.SetRange(recSalesCommentLine1."No.", Rec."No.");
                                            recSalesCommentLine1.SetRange(recSalesCommentLine1."Document Line No.", recSalesLine1."Line No.");
                                            if recSalesCommentLine1.FindLast then
                                                LineNo := recSalesCommentLine1."Line No."
                                            else
                                                LineNo := 0;
                                            InsertCom(LineNo, recSalesLine1."Line No.", recStandardComment."Comment 2", recStandardComment.External);
                                        end;
                                    end;

                                    if recStandardComment."Comment 3" <> '' then begin
                                        FiltrtCommtLine;
                                        recSalesCommentLine.SetRange(recSalesCommentLine."Document Line No.", recSalesLine1."Line No.");
                                        recSalesCommentLine.SetRange(recSalesCommentLine.Comment, recStandardComment."Comment 3");
                                        if not recSalesCommentLine.FindFirst then begin
                                            recSalesCommentLine1.Reset;
                                            recSalesCommentLine1.SetRange(recSalesCommentLine1."Document Type", Rec."Document Type");
                                            recSalesCommentLine1.SetRange(recSalesCommentLine1."No.", Rec."No.");
                                            recSalesCommentLine1.SetRange(recSalesCommentLine1."Document Line No.", recSalesLine1."Line No.");
                                            if recSalesCommentLine1.FindLast then
                                                LineNo := recSalesCommentLine1."Line No."
                                            else
                                                LineNo := 0;
                                            InsertCom(LineNo, recSalesLine1."Line No.", recStandardComment."Comment 3", recStandardComment.External);
                                        end;
                                    end;

                                    if recStandardComment."Comment 4" <> '' then begin
                                        FiltrtCommtLine;
                                        recSalesCommentLine.SetRange(recSalesCommentLine."Document Line No.", recSalesLine1."Line No.");
                                        recSalesCommentLine.SetRange(recSalesCommentLine.Comment, recStandardComment."Comment 4");
                                        if not recSalesCommentLine.FindFirst then begin
                                            recSalesCommentLine1.Reset;
                                            recSalesCommentLine1.SetRange(recSalesCommentLine1."Document Type", Rec."Document Type");
                                            recSalesCommentLine1.SetRange(recSalesCommentLine1."No.", Rec."No.");
                                            recSalesCommentLine1.SetRange(recSalesCommentLine1."Document Line No.", recSalesLine1."Line No.");
                                            if recSalesCommentLine1.FindLast then
                                                LineNo := recSalesCommentLine1."Line No."
                                            else
                                                LineNo := 0;
                                            InsertCom(LineNo, recSalesLine1."Line No.", recStandardComment."Comment 4", recStandardComment.External);
                                        end;
                                    end;

                                    if recStandardComment."Comment 5" <> '' then begin
                                        FiltrtCommtLine;
                                        recSalesCommentLine.SetRange(recSalesCommentLine."Document Line No.", recSalesLine1."Line No.");
                                        recSalesCommentLine.SetRange(recSalesCommentLine.Comment, recStandardComment."Comment 5");
                                        if not recSalesCommentLine.FindFirst then begin
                                            recSalesCommentLine1.Reset;
                                            recSalesCommentLine1.SetRange(recSalesCommentLine1."Document Type", Rec."Document Type");
                                            recSalesCommentLine1.SetRange(recSalesCommentLine1."No.", Rec."No.");
                                            recSalesCommentLine1.SetRange(recSalesCommentLine1."Document Line No.", recSalesLine1."Line No.");
                                            if recSalesCommentLine1.FindLast then
                                                LineNo := recSalesCommentLine1."Line No."
                                            else
                                                LineNo := 0;
                                            InsertCom(LineNo, recSalesLine1."Line No.", recStandardComment."Comment 5", recStandardComment.External);
                                        end;
                                    end;
                                end;
                            until recSalesLine1.Next = 0;
                        //<<Ashwini
                    end;
                }
                action("Credit Cards Transaction Lo&g Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Cards Transaction Lo&g Entries';
                    Image = CreditCardLog;
                    RunObject = Page "DO Payment Trans. Log Entries";
                    RunPageLink = "Document No." = FIELD("No."),
                                  "Customer No." = FIELD("Bill-to Customer No.");
                }
                action(Prices)
                {
                    ApplicationArea = All;
                    Caption = 'Prices';
                    Image = Price;
                    Promoted = true;
                    RunObject = Page "Sales Prices";
                    RunPageLink = "Sales Type" = CONST(Customer),
                                  "Sales Code" = FIELD("Sell-to Customer No.");
                    RunPageView = SORTING("Sales Type", "Sales Code");
                }
                action("Assembly Orders")
                {
                    ApplicationArea = All;
                    Caption = 'Assembly Orders';
                    Image = AssemblyOrder;

                    trigger OnAction()
                    var
                        AssembleToOrderLink: Record "Assemble-to-Order Link";
                    begin
                        AssembleToOrderLink.ShowAsmOrders(Rec);
                    end;
                }
            }
            group(Documents)
            {

                Caption = 'Documents';
                Image = Documents;
                action("S&hipments")
                {
                    ApplicationArea = All;
                    Caption = 'S&hipments';
                    Image = Shipment;
                    RunObject = Page "Posted Sales Shipments";
                    RunPageLink = "Order No." = FIELD("No.");
                    RunPageView = SORTING("Order No.");
                }
                action(Invoices)
                {
                    ApplicationArea = All;
                    Caption = 'Invoices';
                    Image = Invoice;
                    RunObject = Page "Posted Sales Invoices";
                    RunPageLink = "Order No." = FIELD("No.");
                    RunPageView = SORTING("Order No.");
                }
            }
            group(Warehouse)
            {

                Caption = 'Warehouse';
                Image = Warehouse;
                action("In&vt. Put-away/Pick Lines")
                {
                    ApplicationArea = All;
                    Caption = 'In&vt. Put-away/Pick Lines';
                    Image = PickLines;
                    RunObject = Page "Warehouse Activity List";
                    RunPageLink = "Source Document" = CONST("Sales Order"),
                                  "Source No." = FIELD("No.");
                    RunPageView = SORTING("Source Document", "Source No.", "Location Code");
                }
                action("Whse. Shipment Lines")
                {
                    ApplicationArea = All;
                    Caption = 'Whse. Shipment Lines';
                    Image = ShipmentLines;
                    RunObject = Page "Whse. Shipment Lines";
                    RunPageLink = "Source Type" = CONST(37),
                                  "Source Subtype" = FIELD("Document Type"),
                                  "Source No." = FIELD("No.");
                    RunPageView = SORTING("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                }
            }
            group(Prepayment)
            {
                Caption = 'Prepayment';
                Image = Prepayment;
                action("Prepa&yment Invoices")
                {
                    ApplicationArea = All;
                    Caption = 'Prepa&yment Invoices';
                    Image = PrepaymentInvoice;
                    RunObject = Page "Posted Sales Invoices";
                    RunPageLink = "Prepayment Order No." = FIELD("No.");
                    RunPageView = SORTING("Prepayment Order No.");
                }
                action("Prepayment Credi&t Memos")
                {
                    ApplicationArea = All;
                    Caption = 'Prepayment Credi&t Memos';
                    Image = PrepaymentCreditMemo;
                    RunObject = Page "Posted Sales Credit Memos";
                    RunPageLink = "Prepayment Order No." = FIELD("No.");
                    RunPageView = SORTING("Prepayment Order No.");
                }
            }
        }
        area(processing)
        {
            group(Action21)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(InsertResourceLines)
                {
                    ApplicationArea = All;
                    Caption = 'Insert Resource Lines';
                    Image = InsertAccount;
                    Promoted = true;

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document_Ext";
                    begin
                        ReleaseSalesDoc.InsertResourceFunction(Rec."No.", Rec."Sell-to Customer No.");
                    end;
                }
                action("BACKING TABLE FOR NAV")
                {
                    ApplicationArea = All;
                    Caption = 'BACKING TABLE FOR NAV';
                    Image = Resource;
                    Promoted = true;
                    RunObject = Page "BACKING TABLE FOR NAV";
                    RunPageLink = "Customer Type" = CONST(Customer),
                                  "Customer Code" = FIELD("Sell-to Customer No.");
                    RunPageView = SORTING("Customer Type", "Customer Code", "Product Type", "Product Code", "Resc. Code");
                }
                action(Release)
                {
                    ApplicationArea = All;
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
                    ApplicationArea = All;
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
                action(SendMail)
                {
                    ApplicationArea = All;
                    Caption = 'Send Mail';
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Calculate &Invoice Discount")
                {
                    ApplicationArea = All;
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc;
                    end;
                }
                action("Get St&d. Cust. Sales Codes")
                {
                    ApplicationArea = All;
                    Caption = 'Get St&d. Cust. Sales Codes';
                    Ellipsis = true;
                    Image = CustomerCode;

                    trigger OnAction()
                    var
                        StdCustSalesCode: Record "Standard Customer Sales Code";
                    begin
                        StdCustSalesCode.InsertSalesLines(Rec);
                    end;
                }
                action(CopyDocument)
                {
                    ApplicationArea = All;
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CopySalesDoc.SetSalesHeader(Rec);
                        CopySalesDoc.RunModal;
                        Clear(CopySalesDoc);
                    end;
                }
                action("Move Negative Lines")
                {
                    ApplicationArea = All;
                    Caption = 'Move Negative Lines';
                    Ellipsis = true;
                    Image = MoveNegativeLines;

                    trigger OnAction()
                    begin
                        Clear(MoveNegSalesLines);
                        MoveNegSalesLines.SetSalesHeader(Rec);
                        MoveNegSalesLines.RunModal;
                        MoveNegSalesLines.ShowDocument;
                    end;
                }
                action("Archive Document")
                {
                    ApplicationArea = All;
                    Caption = 'Archi&ve Document';
                    Image = Archive;

                    trigger OnAction()
                    begin
                        ArchiveManagement.ArchiveSalesDocument(Rec);
                        CurrPage.Update(false);
                    end;
                }
                action("Send IC Sales Order")
                {
                    AccessByPermission = TableData "IC G/L Account" = R;
                    ApplicationArea = Intercompany;
                    Caption = 'Send IC Sales Order';
                    Image = IntercompanyOrder;
                    ToolTip = 'Send the sales order to the intercompany outbox or directly to the intercompany partner if automatic transaction sending is enabled.';

                    trigger OnAction()
                    var
                        ICInOutboxMgt: Codeunit ICInboxOutboxMgt;
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalsMgmt.PrePostApprovalCheckSales(Rec) then
                            ICInOutboxMgt.SendSalesDoc(Rec, false);
                    end;
                }
                action(ShortClose)
                {
                    ApplicationArea = All;
                    Image = Close;

                    trigger OnAction()
                    begin
                        Rec.TestField("Reason Code");
                        recSalesLine.Reset;
                        recSalesLine.SetRange("Document Type", Rec."Document Type");
                        recSalesLine.SetRange("Document No.", Rec."No.");
                        recSalesLine.SetRange(Type, recSalesLine.Type::Item);
                        if recSalesLine.Find('-') then
                            repeat

                                if recSalesLine."Quantity Shipped" <> recSalesLine."Quantity Invoiced" then
                                    Error('Qty Invoiced must be %1 on Line No. %2', recSalesLine."Quantity Shipped", recSalesLine."Line No.");
                            until recSalesLine.Next = 0;
                        if not Confirm('Do you want to short Close', false, true) then
                            exit;
                        Rec.SetHideValidationDialog(true);
                        Rec."Short Close" := true;
                        Rec.Delete(true);
                    end;
                }
                action("Tracking No")
                {
                    ApplicationArea = All;
                    Image = Track;

                    trigger OnAction()
                    begin
                        recTrackingNo.SetCurrentKey("Source Document No.");
                        recTrackingNo.SetRange(recTrackingNo."Source Document No.", Rec."No.");
                        //recTrackingNo."Source Document No." := "No.";

                        pgTrackingNo.SetTableView(recTrackingNo);
                        pgTrackingNo.Init(Rec."No.");
                        pgTrackingNo.Run;
                    end;
                }
            }
            group(Plan)
            {
                Caption = 'Plan';
                Image = Planning;
                action("Order &Promising")
                {
                    ApplicationArea = All;
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
                action("Demand Overview")
                {
                    ApplicationArea = All;
                    Caption = 'Demand Overview';
                    Image = Forecast;

                    trigger OnAction()
                    var
                        DemandOverview: Page "Demand Overview";
                    begin
                        DemandOverview.SetCalculationParameter(true);
                        DemandOverview.Initialize(0D, 1, Rec."No.", '', '');
                        DemandOverview.RunModal;
                    end;
                }
                action("Pla&nning")
                {
                    ApplicationArea = All;
                    Caption = 'Pla&nning';
                    Image = Planning;

                    trigger OnAction()
                    var
                        SalesPlanForm: Page "Sales Order Planning";
                    begin
                        SalesPlanForm.SetSalesOrder(Rec."No.");
                        SalesPlanForm.RunModal;
                    end;
                }
            }
            group(Request)
            {
                Caption = 'Request';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalsMgmt.CheckSalesApprovalPossible(Rec) then
                            ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {

                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                    begin
                        ApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
                        WorkflowWebhookMgt.FindAndCancel(Rec.RecordId);
                    end;
                }
                group(Authorize)
                {
                    Caption = 'Authorize';
                    Image = AuthorizeCreditCard;
                    action(Action256)
                    {
                        ApplicationArea = All;
                        Caption = 'Authorize';
                        Image = AuthorizeCreditCard;

                        trigger OnAction()
                        begin
                            //Rec.Authorize;
                        end;
                    }
                    action("Void A&uthorize")
                    {
                        ApplicationArea = All;
                        Caption = 'Void A&uthorize';
                        Image = VoidCreditCard;

                        trigger OnAction()
                        begin
                            //  Rec.Void;
                        end;
                    }
                }
                action(RefundPayment)
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Authentication := '';
                        AuthenticationID := '';
                        if SalesPost.IsOnlinePayment(Rec) then begin
                            Rec.TestField("Credit Card No.");
                            Rec.CalcFields(Amount);
                            DPTLE.Reset;
                            DPTLE.SetRange("Document Type", Rec."Document Type");
                            DPTLE.SetRange("Document No.", Rec."No.");
                            DPTLE.SetRange(DPTLE."Transaction Status", DPTLE."Transaction Status"::Refunded);
                            if DPTLE.Find('-') then
                                Error('Already Refund')
                            else begin
                                DPTLE.Reset;
                                DPTLE.SetRange("Document Type", Rec."Document Type");
                                DPTLE.SetRange("Document No.", Rec."No.");
                                DPTLE.SetRange(DPTLE."Transaction Status", DPTLE."Transaction Status"::Captured);
                                if DPTLE.Find('-') then
                                    AuthenticationID := Format(DPTLE."Refund No.")
                                else
                                    Error('Entry Not Found');
                            end;
                            Clear(DataText);
                            DataText.AddText(Encrypt(Format(AuthenticationID))); //Vishal
                            IntLength := DataText.Length;
                            //FOR i:=1 to 8 DO BEGIN
                            DataText.GetSubText(Authentication, 1);
                            //Authentication

                            HyperLink('http://192.168.1.228:57474/PayNow.aspx?PayId=' + Authentication + '&OID=Refund');
                        end else begin
                            Error('Payment Method Code is not defined for online Payment');
                        end;
                    end;
                }
                action("Multiple Payment")
                {
                    ApplicationArea = All;
                    Caption = 'MultiPayment';

                    trigger OnAction()
                    var
                        recMP: Record "Multiple Payment";
                        pgMP: Page "Multiple Credit Card Payment";
                    begin

                        Rec.TestField("Bill-to Customer No.");
                        Rec.TestField("Payment Method Code");
                        //TESTFIELD("Multiple Payment");
                        Rec.TestField("Credit Card No.");
                        recMP.Reset;
                        recMP.SetRange("Document Type", Rec."Document Type");
                        recMP.SetRange("Order No.", Rec."No.");
                        recMP.SetRange("Customer No.", Rec."Bill-to Customer No.");
                        if recMP.FindSet then;
                        pgMP.SetTableView(recMP);
                        pgMP.Run;
                    end;
                }
            }
            group(Action3)
            {
                Caption = 'Warehouse';
                Image = Warehouse;
                action("Create Inventor&y Put-away / Pick")
                {
                    ApplicationArea = All;
                    Caption = 'Create Inventor&y Put-away / Pick';
                    Ellipsis = true;
                    Image = CreateInventoryPickup;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.CreateInvtPutAwayPick;

                        if not Rec.Find('=><') then
                            Rec.Init;
                    end;
                }
                action("Create &Whse. Shipment")
                {
                    ApplicationArea = All;
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
                //Rocket functionlity removed
                // action(RocketShipItValidateAddress)
                // {
                //     ApplicationArea = All;
                //     Caption = 'RS Validate Address';
                //     Image = "Action";

                //     trigger OnAction()
                //     begin
                //         if ((Rec."Ship-to Country/Region Code" = 'US') or (Rec."Ship-to Country/Region Code" = 'CA')) and (not AddressValidated) and (Status <> 1) then
                //             cuTest.RocketShipItAddressVerification('', '', Rec."No.");
                //     end;
                // }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Post)
                {
                    ApplicationArea = All;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        /*recSalesLine.RESET;
                        recSalesLine.SETRANGE("Document Type","Document Type");
                        recSalesLine.SETRANGE("Document No.","No.");
                        recSalesLine.SETRANGE(Type,recSalesLine.Type::Resource);
                        IF recSalesLine.FINDFIRST THEN
                          REPEAT
                            IF (recSalesLine."Quantity Shipped"<>recSalesLine."Qty. to Invoice") THEN
                              IF NOT CONFIRM('Qty Shipped does not match Qty to invoice. Proceed(Y/N)',FALSE,TRUE) THEN
                                  EXIT;
                          UNTIL recSalesLine.NEXT=0;*/

                        Rec."Posting Date" := WorkDate;
                        PostTR(CODEUNIT::"Sales-Post (Yes/No)");

                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = All;
                    Caption = 'Post and &Print';
                    Ellipsis = true;
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        /*recSalesLine.RESET;
                        recSalesLine.SETRANGE("Document Type","Document Type");
                        recSalesLine.SETRANGE("Document No.","No.");
                        recSalesLine.SETRANGE(Type,recSalesLine.Type::Resource);
                        IF recSalesLine.FINDFIRST THEN
                          REPEAT
                            IF (recSalesLine."Quantity Shipped"<>recSalesLine."Qty. to Invoice") THEN
                              IF NOT CONFIRM('Qty Shipped does not match Qty to invoice. Proceed(Y/N)',FALSE,TRUE) THEN
                                  EXIT;
                          UNTIL recSalesLine.NEXT=0;*/

                        Rec."Posting Date" := WorkDate;
                        PostTR(CODEUNIT::"Sales-Post + Print");

                    end;
                }
                action("Test Report")
                {
                    ApplicationArea = All;
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
                    ApplicationArea = All;
                    Caption = 'Post &Batch';
                    Ellipsis = true;
                    Image = PostBatch;

                    trigger OnAction()
                    begin
                        Rec."Posting Date" := WorkDate;
                        REPORT.RunModal(REPORT::"Batch Post Sales Orders", true, true, Rec);
                        CurrPage.Update(false);
                    end;
                }
                action("Remove From Job Queue")
                {
                    ApplicationArea = All;
                    Caption = 'Remove From Job Queue';
                    Image = RemoveLine;
                    Visible = JobQueueVisible;

                    trigger OnAction()
                    begin
                        Rec.CancelBackgroundPosting;
                    end;
                }
                group("Prepa&yment")
                {
                    Caption = 'Prepa&yment';
                    Image = Prepayment;
                    action("Prepayment &Test Report")
                    {
                        ApplicationArea = Prepayments;
                        Caption = 'Prepayment &Test Report';
                        Ellipsis = true;
                        Image = PrepaymentSimulation;
                        ToolTip = 'Preview the prepayment transactions that will results from posting the sales document as invoiced. ';

                        trigger OnAction()
                        begin
                            ReportPrint.PrintSalesHeaderPrepmt(Rec);
                        end;
                    }
                    action(PostPrepaymentInvoice)
                    {
                        ApplicationArea = Prepayments;
                        Caption = 'Post Prepayment &Invoice';
                        Ellipsis = true;
                        Image = PrepaymentPost;
                        ToolTip = 'Post the specified prepayment information. ';

                        trigger OnAction()
                        var
                            SalesPostYNPrepmt: Codeunit "Sales-Post Prepayment (Yes/No)";
                        begin
                            if ApprovalsMgmt.PrePostApprovalCheckSales(Rec) then
                                SalesPostYNPrepmt.PostPrepmtInvoiceYN(Rec, false);
                        end;
                    }
                    action("Post and Print Prepmt. Invoic&e")
                    {
                        ApplicationArea = Prepayments;
                        Caption = 'Post and Print Prepmt. Invoic&e';
                        Ellipsis = true;
                        Image = PrepaymentPostPrint;
                        ToolTip = 'Post the specified prepayment information and print the related report. ';

                        trigger OnAction()
                        var
                            SalesPostYNPrepmt: Codeunit "Sales-Post Prepayment (Yes/No)";
                        begin
                            if ApprovalsMgmt.PrePostApprovalCheckSales(Rec) then
                                SalesPostYNPrepmt.PostPrepmtInvoiceYN(Rec, true);
                        end;
                    }
                    action(PostPrepaymentCreditMemo)
                    {
                        ApplicationArea = Prepayments;
                        Caption = 'Post Prepayment &Credit Memo';
                        Ellipsis = true;
                        Image = PrepaymentPost;
                        ToolTip = 'Create and post a credit memo for the specified prepayment information.';

                        trigger OnAction()
                        var
                            SalesPostYNPrepmt: Codeunit "Sales-Post Prepayment (Yes/No)";
                        begin
                            if ApprovalsMgmt.PrePostApprovalCheckSales(Rec) then
                                SalesPostYNPrepmt.PostPrepmtCrMemoYN(Rec, false);
                        end;
                    }
                    action("Post and Print Prepmt. Cr. Mem&o")
                    {
                        ApplicationArea = Prepayments;
                        Caption = 'Post and Print Prepmt. Cr. Mem&o';
                        Ellipsis = true;
                        Image = PrepaymentPostPrint;
                        ToolTip = 'Create and post a credit memo for the specified prepayment information and print the related report.';

                        trigger OnAction()
                        var
                            SalesPostYNPrepmt: Codeunit "Sales-Post Prepayment (Yes/No)";
                        begin
                            if ApprovalsMgmt.PrePostApprovalCheckSales(Rec) then
                                SalesPostYNPrepmt.PostPrepmtCrMemoYN(Rec, true);
                        end;
                    }
                }
            }
            group("&Print")
            {
                Caption = '&Print';
                Image = Print;
                action("Order Confirmation")
                {
                    ApplicationArea = All;
                    Caption = 'Order Confirmation';
                    Ellipsis = true;
                    Image = Print;

                    trigger OnAction()
                    var
                        Rec36: Record "Sales Header";
                    begin
                        //SPD MS 030915
                        //DocPrint.PrintSalesOrder(Rec,Usage::"Order Confirmation");

                        CurrPage.SetSelectionFilter(Rec36);
                        REPORT.Run(50123, true, false, Rec36);
                    end;
                }
                action(ManufaturingOrder)
                {
                    ApplicationArea = All;
                    Caption = 'Manufaturing Order';
                    Description = 'Manufaturing Order';
                    Ellipsis = true;
                    Enabled = false;
                    Image = Print;
                    Promoted = true;
                    ToolTip = 'Manufaturing Order';
                    Visible = false;

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(Rec);
                        REPORT.Run(50201, true, true, Rec);
                    end;
                }
                action(CFTPackingList)
                {
                    ApplicationArea = All;
                    Caption = 'CFT Packing List';
                    Ellipsis = true;
                    Image = Print;

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(Rec);
                        REPORT.Run(50050, true, true, Rec);
                    end;
                }
                action("Work Order")
                {
                    ApplicationArea = All;
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
                    ApplicationArea = All;
                    Caption = 'Pick Instruction';
                    Image = Print;

                    trigger OnAction()
                    begin
                        DocPrint.PrintSalesOrder(Rec, Usage::"Pick Instruction");
                    end;
                }
                action("Sales Order With Comment")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Order With Comment';
                    Image = Print;

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(Rec);
                        REPORT.Run(50201, true, true, Rec);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Drop Shipment Status")
            {
                ApplicationArea = All;
                Caption = 'Drop Shipment Status';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Drop Shipment Status";
            }
            action("Picking List by Order")
            {
                ApplicationArea = All;
                Caption = 'Picking List by Order';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Picking List by Order";
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        DynamicEditable := CurrPage.Editable;
    end;

    trigger OnAfterGetRecord()
    begin
        JobQueueVisible := Rec."Job Queue Status" = Rec."Job Queue Status"::"Scheduled for Posting";

        if Rec."Commission Override" then
            blnOverride := true
        else
            blnOverride := false;
    end;
    //Rocket functionlity removed
    // trigger OnClosePage()
    // var
    //     myAnswer: Integer;
    // begin
    //     if ((Rec."Ship-to Country/Region Code" = 'US') or (Rec."Ship-to Country/Region Code" = 'CA')) and (not AddressValidated) and (Status <> 1) then begin
    //         myAnswer := DIALOG.StrMenu('Yes', 3, 'Validate Address?');
    //         if (myAnswer = 1) then begin
    //             cuTest.RocketShipItAddressVerification('', '', Rec."No.");
    //         end;
    //     end;
    // end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        exit(Rec.ConfirmDeletion);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.CheckCreditMaxBeforeInsert;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetSalesFilter;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetSalesFilter <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetSalesFilter);
            Rec.FilterGroup(0);
        end;

        Rec.SetRange("Date Filter", 0D, WorkDate - 1);

        if Rec."Commission Override" then
            blnOverride := true
        else
            blnOverride := false;
    end;

    var
        Text000: Label 'Unable to execute this function while in view only mode.';
        CopySalesDoc: Report "Copy Sales Document";
        MoveNegSalesLines: Report "Move Negative Sales Lines";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ReportPrint: Codeunit "Test Report-Print";
        DocPrint: Codeunit "Document-Print";
        ArchiveManagement: Codeunit ArchiveManagement;
        ChangeExchangeRate: Page "Change Exchange Rate";
        UserMgt: Codeunit "User Setup Management";
        recSalesCommentLine: Record "Sales Comment Line";
        recSalesCommentLine1: Record "Sales Comment Line";
        recStandardComment: Record "Standard Comment";
        recSalesLine1: Record "Sales Line";
        LineNo: Integer;
        Usage: Option "Order Confirmation","Work Order","Pick Instruction";


        JobQueueVisible: Boolean;
        Text001: Label 'Do you want to change %1 in all related records in the warehouse?';
        Text002: Label 'The update has been interrupted to respect the warning.';
        DynamicEditable: Boolean;
        recSalesLine: Record "Sales Line";
        AuthenticationID: Text[30];
        DPTLE: Record "DO Payment Trans. Log Entry";
        EntryNo: Integer;
        SalesPost: Codeunit SalesPost_Ext;
        decAmount: Decimal;
        DataText: BigText;
        // EncryptionMgt: Codeunit "Encryption Management";
        IntLength: Integer;
        Authentication: Text[1024];
        CapturedAmount: Decimal;
        blnOverride: Boolean;
        recTrackingNo: Record "Tracking No.";
        pgTrackingNo: Page "Tracking No";
        cuTest: Codeunit "Integration Fedex UPS";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;

    local procedure PostTR(PostingCodeunitID: Integer)
    begin
        Rec.SendToPosting(PostingCodeunitID);
        if Rec."Job Queue Status" = Rec."Job Queue Status"::"Scheduled for Posting" then
            CurrPage.Close;
        CurrPage.Update(false);
    end;

    procedure UpdateAllowed(): Boolean
    begin
        if CurrPage.Editable = false then
            Error(Text000);
        exit(true);
    end;

    local procedure ApproveCalcInvDisc()
    begin
        CurrPage.SalesLines.PAGE.ApproveCalcInvDisc;
    end;

    local procedure SelltoCustomerNoOnAfterValidat()
    begin
        if Rec.GetFilter("Sell-to Customer No.") = xRec."Sell-to Customer No." then
            if Rec."Sell-to Customer No." <> xRec."Sell-to Customer No." then
                Rec.SetRange("Sell-to Customer No.");
        CurrPage.Update;
    end;

    local procedure SalespersonCodeOnAfterValidate()
    begin
        CurrPage.SalesLines.PAGE.UpdateForm(true);
    end;

    local procedure BilltoCustomerNoOnAfterValidat()
    begin
        CurrPage.Update;
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.Update;
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.Update;
    end;

    local procedure Prepayment37OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    procedure FiltrtCommtLine()
    begin
        recSalesCommentLine.Reset;
        recSalesCommentLine.SetRange(recSalesCommentLine."Document Type", Rec."Document Type");
        recSalesCommentLine.SetRange(recSalesCommentLine."No.", Rec."No.");
    end;

    procedure InsertCom(LnNo: Integer; DocLineNo: Integer; Comm: Text[250]; ExternalPrint: Boolean)
    begin
        recSalesCommentLine.Init;
        recSalesCommentLine."Document Type" := Rec."Document Type";
        recSalesCommentLine."No." := Rec."No.";
        recSalesCommentLine."Document Line No." := DocLineNo;
        recSalesCommentLine."Line No." := LnNo + 10000;
        recSalesCommentLine.Date := WorkDate;
        recSalesCommentLine.Comment := Comm;
        if ExternalPrint then begin
            recSalesCommentLine."Print On Shipment" := true;
            recSalesCommentLine."Print On Invoice" := true;
        end;
        recSalesCommentLine.Insert(true);
    end;
}

