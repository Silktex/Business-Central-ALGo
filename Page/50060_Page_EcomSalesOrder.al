page 50060 "Ecom Sales Order"
{
    Caption = 'Ecom Sales Order';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Document Type" = FILTER(Order),
                            "Short Close" = FILTER(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Sell-to Phone No."; rec."Sell-to Phone No.")
                {
                    ApplicationArea = all;
                }
                field("Sell-to E-Mail"; rec."Sell-to E-Mail")
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = all;
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Sell-to Contact No."; Rec."Sell-to Contact No.")
                {
                    ApplicationArea = all;
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
                    ApplicationArea = all;
                    QuickEntry = false;
                }
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                }
                field("Sell-to Address 2"; Rec."Sell-to Address 2")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                }
                field("Sell-to City"; Rec."Sell-to City")
                {
                    ApplicationArea = all;
                    QuickEntry = false;
                }
                field("Sell-to County"; Rec."Sell-to County")
                {
                    ApplicationArea = all;
                    Caption = 'Sell-to State / ZIP Code';
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                }
                field("Sell-to Contact"; Rec."Sell-to Contact")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    QuickEntry = false;
                    Visible = false;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                    QuickEntry = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    QuickEntry = false;
                    Visible = false;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = all;
                    NotBlank = true;
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = all;
                }
                field("Quote No."; Rec."Quote No.")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                    Visible = false;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                    QuickEntry = false;

                    trigger OnValidate()
                    begin
                        SalespersonCodeOnAfterValidate;
                    end;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
            }
            part(SalesLines; "Sales Order Subform NOP")
            {
                ApplicationArea = all;
                Editable = DynamicEditable;
                SubPageLink = "Document No." = FIELD("No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        BilltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Bill-to Contact No."; Rec."Bill-to Contact No.")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                    Visible = false;
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                    Visible = false;
                }
                field("Bill-to Address 2"; Rec."Bill-to Address 2")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                    Visible = false;
                }
                field("Bill-to City"; Rec."Bill-to City")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Bill-to County"; Rec."Bill-to County")
                {
                    ApplicationArea = all;
                    Caption = 'State / ZIP Code';
                    Visible = false;
                }
                field("Bill-to Post Code"; Rec."Bill-to Post Code")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                    Visible = false;
                }
                field("Bill-to Contact"; Rec."Bill-to Contact")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                    Visible = false;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                }
                field("Payment Discount %"; Rec."Payment Discount %")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Pmt. Discount Date"; Rec."Pmt. Discount Date")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                    Visible = false;
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                    Visible = false;
                }
                field("Direct Debit Mandate ID"; Rec."Direct Debit Mandate ID")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Credit Card No."; Rec."Credit Card No.")
                {
                    ApplicationArea = all;
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = all;
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                }
                field("Ship-to Address 2"; Rec."Ship-to Address 2")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = all;
                }
                field("Ship-to County"; Rec."Ship-to County")
                {
                    ApplicationArea = all;
                    Caption = 'Ship-to State / ZIP Code';
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = all;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                }
                field("Shipping Time"; Rec."Shipping Time")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                }
                field("Ship-to UPS Zone"; Rec."Ship-to UPS Zone")
                {
                    ApplicationArea = all;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                }
                field("Outbound Whse. Handling Time"; Rec."Outbound Whse. Handling Time")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = all;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                    ApplicationArea = all;
                }
                field("Late Order Shipping"; Rec."Late Order Shipping")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                }
                field("Package Tracking No."; Rec."Package Tracking No.")
                {
                    ApplicationArea = all;
                }
                field("Tracking No."; Rec."Tracking No.")
                {
                    ApplicationArea = all;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                }
                field("Shipping Advice"; Rec."Shipping Advice")
                {
                    ApplicationArea = all;
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
                    ApplicationArea = all;
                }
                field(AddressValidated; Rec.AddressValidated)
                {
                    ApplicationArea = all;
                }
            }
        }
        area(factboxes)
        {
            part(Control1903720907; "Sales Hist. Sell-to FactBox")
            {
                ApplicationArea = all;
                SubPageLink = "No." = FIELD("Sell-to Customer No.");
                Visible = true;
            }
            part(Control1902018507; "Customer Statistics FactBox")
            {
                ApplicationArea = all;
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                Visible = false;
            }
            part(Control1900316107; "Customer Details FactBox")
            {
                ApplicationArea = all;
                SubPageLink = "No." = FIELD("Sell-to Customer No.");
                Visible = false;
            }
            part(Control1906127307; "Sales Line FactBox")
            {
                ApplicationArea = all;
                Provider = SalesLines;
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
                Visible = true;
            }
            part(Control1901314507; "Item Invoicing FactBox")
            {
                ApplicationArea = all;
                Provider = SalesLines;
                SubPageLink = "No." = FIELD("No.");
                Visible = false;
            }
            part(Control1906354007; "Approval FactBox")
            {
                ApplicationArea = all;
                SubPageLink = "Table ID" = CONST(36),
                              "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
                Visible = false;
            }
            part(Control1907012907; "Resource Details FactBox")
            {
                ApplicationArea = all;
                Provider = SalesLines;
                SubPageLink = "No." = FIELD("No.");
                Visible = false;
            }
            part(Control1901796907; "Item Warehouse FactBox")
            {
                ApplicationArea = all;
                Provider = SalesLines;
                SubPageLink = "No." = FIELD("No.");
                Visible = false;
            }
            part(Control1907234507; "Sales Hist. Bill-to FactBox")
            {
                ApplicationArea = all;
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                Visible = false;
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
                action(Card)
                {
                    ApplicationArea = all;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = FIELD("Sell-to Customer No.");
                    ShortCutKey = 'Shift+F7';
                }
                action(Dimensions)
                {
                    ApplicationArea = all;
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
                action(CopyComment)
                {
                    ApplicationArea = all;
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
                    ApplicationArea = all;
                    Caption = 'Credit Cards Transaction Lo&g Entries';
                    Image = CreditCardLog;
                    RunObject = Page "DO Payment Trans. Log Entries";
                    RunPageLink = "Document No." = FIELD("No."),
                                  "Customer No." = FIELD("Bill-to Customer No.");
                }
                action(Prices)
                {
                    ApplicationArea = all;
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
                    ApplicationArea = all;
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
            }
            group(Warehouse)
            {
                Caption = 'Warehouse';
                Image = Warehouse;
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
            }
            group(Prepayment)
            {
                Caption = 'Prepayment';
                Image = Prepayment;
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
                    ApplicationArea = all;
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
                    ApplicationArea = all;
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
                action(SendMail)
                {
                    ApplicationArea = all;
                    Caption = 'Send Mail';
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Calculate &Invoice Discount")
                {
                    ApplicationArea = all;
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc;
                    end;
                }
                action("Get St&d. Cust. Sales Codes")
                {
                    ApplicationArea = all;
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
                    ApplicationArea = all;
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
                    ApplicationArea = all;
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
                    ApplicationArea = all;
                    Caption = 'Archi&ve Document';
                    Image = Archive;

                    trigger OnAction()
                    begin
                        ArchiveManagement.ArchiveSalesDocument(Rec);
                        CurrPage.Update(false);
                    end;
                }
                action(ShortClose)
                {
                    ApplicationArea = all;
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
                    ApplicationArea = all;
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
                action("Demand Overview")
                {
                    ApplicationArea = all;
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
                    ApplicationArea = all;
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
                group(Authorize)
                {
                    Caption = 'Authorize';
                    Image = AuthorizeCreditCard;
                    action(Action256)
                    {
                        ApplicationArea = all;
                        Caption = 'Authorize';
                        Image = AuthorizeCreditCard;

                        trigger OnAction()
                        begin
                            // Rec.Authorize;
                        end;
                    }
                    action("Void A&uthorize")
                    {
                        ApplicationArea = all;
                        Caption = 'Void A&uthorize';
                        Image = VoidCreditCard;

                        trigger OnAction()
                        begin
                            // Rec.Void;
                        end;
                    }
                }
            }
            group(Action3)
            {
                Caption = 'Warehouse';
                Image = Warehouse;
                action("Create Inventor&y Put-away / Pick")
                {
                    ApplicationArea = all;
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
                //Rocket functionlity removed
                // action(RocketShipItValidateAddress)
                // {
                //     ApplicationArea = all;
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
                        PostTr(CODEUNIT::"Sales-Post (Yes/No)");

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
                        PostTr(CODEUNIT::"Sales-Post + Print");

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

                    trigger OnAction()
                    begin
                        Rec."Posting Date" := WorkDate;
                        REPORT.RunModal(REPORT::"Batch Post Sales Orders", true, true, Rec);
                        CurrPage.Update(false);
                    end;
                }
                action("Remove From Job Queue")
                {
                    ApplicationArea = all;
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
                        ApplicationArea = all;
                        Caption = 'Prepayment &Test Report';
                        Ellipsis = true;
                        Image = PrepaymentSimulation;

                        trigger OnAction()
                        begin
                            ReportPrint.PrintSalesHeaderPrepmt(Rec);
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
                    ApplicationArea = all;
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
                    ApplicationArea = all;
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
                    ApplicationArea = all;
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
                action("Sales Order With Comment")
                {
                    ApplicationArea = all;
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
                ApplicationArea = all;
                Caption = 'Drop Shipment Status';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Drop Shipment Status";
            }
            action("Picking List by Order")
            {
                ApplicationArea = all;
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
    //     if ((Rec."Ship-to Country/Region Code" = 'US') or (Rec."Ship-to Country/Region Code" = 'CA')) and (not Rec.AddressValidated) and (Rec.Status.AsInteger() <> 1) then begin
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
        SalesPost: Codeunit "Sales-Post";
        decAmount: Decimal;
        DataText: BigText;
        IntLength: Integer;
        Authentication: Text[1024];
        CapturedAmount: Decimal;
        blnOverride: Boolean;
        recTrackingNo: Record "Tracking No.";
        pgTrackingNo: Page "Tracking No";
        cuTest: Codeunit "Integration Fedex UPS";

    local procedure PostTr(PostingCodeunitID: Integer)
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

