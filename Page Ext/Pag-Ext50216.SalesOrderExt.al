pageextension 50216 SalesOrder_Ext extends "Sales Order"
{

    layout
    {
        addafter("Sell-to Contact")
        {
            field("PI Contact"; Rec."PI Contact")
            {
                ApplicationArea = all;
            }
        }
        addafter("Promised Delivery Date")
        {
            field("Expiry Date"; Rec."Expiry Date")
            {
                ApplicationArea = all;
            }
        }
        addafter(Status)
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = all;
            }
            field("Commission Override"; Rec."Commission Override")
            {
                Importance = Additional;
                ApplicationArea = all;

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
                Editable = blnOverride;
                Importance = Additional;
                ApplicationArea = all;
            }
            field(Priority; Rec.Priority)
            {
                ApplicationArea = all;
            }
            field("Charges Pay By"; Rec."Charges Pay By")
            {
                ApplicationArea = all;
            }

        }
        addafter("CFDI Relation")
        {
            field("Project Name"; Rec."Project Name")
            {
                ApplicationArea = all;
            }
            field("Proj Owner 1"; Rec."Proj Owner 1")
            {
                ApplicationArea = all;
            }
            field("Proj Owner 2"; Rec."Proj Owner 2")
            {
                ApplicationArea = all;
            }
            field("Project Location"; Rec."Project Location")
            {
                ApplicationArea = all;
            }
            field(Specifier; Rec.Specifier)
            {
                ApplicationArea = all;
            }
            field("Specifier Name"; Rec."Specifier Name")
            {
                ApplicationArea = all;
            }
            field("Physical Order Loc"; Rec."Physical Order Loc")
            {
                ApplicationArea = all;
            }
            field("Order Status"; Rec."Order Status")
            {
                ApplicationArea = all;
            }
            field("No insurance"; Rec."No insurance")
            {

                ApplicationArea = all;
            }
        }
        addafter("Payment Method Code")
        {
            field("Credit Card No."; Rec."Credit Card No.")
            {
                ApplicationArea = all;
            }
            field(GetCreditcardNumber; Rec.GetCreditcardNumber)
            {
                Caption = 'Cr. Card Number (Last 4 Digits)';
                ApplicationArea = all;
            }
        }
        addafter("Package Tracking No.")
        {
            field("Box Code"; Rec."Box Code")
            {
                ApplicationArea = all;
            }
            field("RocketShip Tracking No."; Rec."RocketShip Tracking No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Shipping Advice")
        {
            field(Residential; Rec.Residential)
            {
                ApplicationArea = all;
            }
            field(AddressValidated; Rec.AddressValidated)
            {
                ApplicationArea = all;
            }
        }
        addafter(Control1901314507)
        {
            part(CustomerAgingFactBox; "Customer Aging FactBox")
            {
                Caption = 'Customer Aging';
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                ApplicationArea = all;
            }
        }

        addlast(General)
        {
            field("Project Type"; Rec."Project Type")
            {
                ApplicationArea = All;
                Visible = ShowProjectInfo;
            }
            field("Project Phase"; Rec."Project Phase")
            {
                ApplicationArea = All;
                Visible = ShowProjectInfo;
            }
            field("Project Description"; Rec."Project Description")
            {
                ApplicationArea = All;
                Visible = ShowProjectInfo;
                MultiLine = true;
            }
            field("Third Party"; Rec."Third Party")
            {
                ApplicationArea = All;
            }
            field("Third Party Account No."; Rec."Third Party Account No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Co&mments")
        {
            action("Freight Update")
            {
                ApplicationArea = all;

                trigger OnAction()
                var
                    SalesLine: Record "Sales Line";
                    ItemTotalQtyShipped: Decimal;
                    FreightTotalQtyShipped: Decimal;
                    FreightTotalQty: Decimal;
                begin
                    ItemTotalQtyShipped := 0;
                    SalesLine.Reset;
                    SalesLine.SetRange("Document Type", Rec."Document Type");
                    SalesLine.SetRange("Document No.", Rec."No.");
                    SalesLine.SetRange(Type, SalesLine.Type::Item);
                    if SalesLine.FindFirst then
                        repeat
                            ItemTotalQtyShipped += SalesLine."Quantity Shipped";
                        until SalesLine.Next = 0;

                    FreightTotalQtyShipped := 0;
                    FreightTotalQty := 0;
                    SalesLine.Reset;
                    SalesLine.SetRange("Document Type", Rec."Document Type");
                    SalesLine.SetRange("Document No.", Rec."No.");
                    SalesLine.SetRange(Type, SalesLine.Type::Resource);
                    SalesLine.SetRange("No.", 'FREIGHT SURCHARGE');
                    if SalesLine.FindFirst then begin
                        FreightTotalQtyShipped += SalesLine."Quantity Shipped";
                        FreightTotalQty += SalesLine.Quantity;

                        IF FreightTotalQty < (ItemTotalQtyShipped - FreightTotalQtyShipped) Then begin
                            SalesLine.Validate(Quantity, (ItemTotalQtyShipped - FreightTotalQtyShipped));
                            SalesLine.Validate("Qty. to Ship", (ItemTotalQtyShipped - FreightTotalQtyShipped));

                        End else
                            SalesLine.Validate("Qty. to Ship", (ItemTotalQtyShipped - FreightTotalQtyShipped));


                        SalesLine.Modify();
                    end;
                end;
            }

            action(CopyComment)
            {
                Caption = 'Copy Standard Comment';
                Ellipsis = true;
                Image = ViewComments;
                ApplicationArea = all;

                trigger OnAction()
                begin
                    //ERROR('Process is under construction.');
                    //>>Ashwini
                    //Copy Header Comment
                    recStandardComment.Reset;
                    recStandardComment.SetRange(recStandardComment."Product Code", '');
                    if recStandardComment."Sales Type" <> 0 then begin
                        recStandardComment.SetRange(recStandardComment."Sales Type", recStandardComment."Sales Type"::Customer);
                        recStandardComment.SetRange(recStandardComment."Sales Code", Rec."Sell-to Customer No.");
                    end else
                        recStandardComment.SetRange(recStandardComment."Sales Type", recStandardComment."Sales Type"::"All Customer");

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
        }
        addafter(AssemblyOrders)
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
                    Name: Text[50];
                    FileName: Text[250];
                    ToFile: Text[250];
                begin
                    IF Rec."Location Code" <> 'MATRL BANK' then begin
                        CurrPage.SetSelectionFilter(Rec);
                        CUMail.SalesOrderOutlook(Rec, '');
                    end;
                end;
            }
        }
        addbefore(Release)
        {
            action(InsertResourceLines)
            {
                Caption = 'Insert Resource Lines';
                Image = InsertAccount;
                Promoted = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    ReleaseSalesDoc: Codeunit "Release Sales Document_Ext";
                begin
                    ReleaseSalesDoc.InsertResourceFunction(Rec."No.", Rec."Sell-to Customer No.");
                end;
            }
            action("BACKING TABLE FOR NAV")
            {
                Caption = 'BACKING TABLE FOR NAV';
                ApplicationArea = all;
                Image = Resource;
                Promoted = true;
                RunObject = Page "BACKING TABLE FOR NAV";
                RunPageLink = "Customer Type" = CONST(Customer),
                                  "Customer Code" = FIELD("Sell-to Customer No.");
                RunPageView = SORTING("Customer Type", "Customer Code", "Product Type", "Product Code", "Resc. Code");
            }
        }
        addafter(Action21)
        {
            group("Customer Address")
            {
                Caption = 'Customer Address';
                Image = ReleaseDoc;
                action(CopySellltoAddress)
                {
                    Caption = 'Copy Sell to Address';
                    Image = Copy;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        outFile: File;
                        Istream1: InStream;
                        Line: Text;
                        Text1: array[10] of Text[1024];
                        OStream: OutStream;
                        outStream1: OutStream;
                        Country: Record "Country/Region";
                        TempBlob: Codeunit "Temp Blob";
                        FileName: Text;
                    begin
                        Clear(outStream1);
                        FileName := 'SellToCustomerAdd.txt';
                        TempBlob.CreateOutStream(OStream, TextEncoding::UTF8);
                        OStream.WriteText(Rec."Sell-to Contact");
                        OStream.WriteText();
                        OStream.WriteText(Rec."Sell-to Customer Name");
                        OStream.WriteText();
                        OStream.WriteText(Rec."Sell-to Address");
                        OStream.WriteText();
                        OStream.WriteText(Rec."Sell-to Address 2");
                        OStream.WriteText();
                        OStream.WriteText(Rec."Sell-to City" + ', ' + Rec."Sell-to County" + ', ' + Rec."Sell-to Post Code");
                        OStream.WriteText();
                        if Rec."Sell-to County" <> 'US' then begin
                            Country.Get(Rec."Sell-to County");
                            OStream.WriteText(Country.Name);
                            OStream.WriteText();
                        end;
                        TempBlob.CreateInStream(Istream1, TextEncoding::UTF8);
                        DownloadFromStream(Istream1, '', '', '', FileName);
                    end;
                }
                action(CopyShiptoAddress)
                {
                    Caption = 'Copy Ship to Address';
                    Image = Copy;
                    Promoted = false;
                    ApplicationArea = all;

                    trigger OnAction()
                    var
                        outFile: File;
                        Istream1: InStream;
                        Line: Text;
                        Text1: array[10] of Text[1024];
                        OStream: OutStream;
                        outStream1: OutStream;
                        Country: Record "Country/Region";
                        TempBlob: Codeunit "Temp Blob";
                        FileName: Text;
                    begin
                        Clear(outStream1);
                        FileName := 'ShipToCustomerAdd.txt';
                        TempBlob.CreateOutStream(OStream, TextEncoding::UTF8);

                        OStream.WriteText(Rec."Ship-to Contact");
                        OStream.WriteText();
                        OStream.WriteText(Rec."Ship-to Name");
                        OStream.WriteText();
                        OStream.WriteText(Rec."Ship-to Address");
                        OStream.WriteText();
                        OStream.WriteText(Rec."Ship-to Address 2");
                        OStream.WriteText();
                        OStream.WriteText(Rec."Ship-to City" + ', ' + Rec."Ship-to County" + ', ' + Rec."Ship-to Post Code");
                        OStream.WriteText();
                        if Rec."Ship-to County" <> 'US' then begin
                            Country.Get(Rec."Ship-to County");
                            OStream.WriteText(Country.Name);
                            OStream.WriteText();
                        end;
                        TempBlob.CreateInStream(Istream1, TextEncoding::UTF8);
                        DownloadFromStream(Istream1, '', '', '', FileName);
                    end;
                }
            }
        }
        addafter("Send IC Sales Order")
        {
            action(ShortClose)
            {
                Image = Close;
                ApplicationArea = all;

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
                Image = Track;
                ApplicationArea = all;

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
        addafter(CancelApprovalRequest)
        {
            action("Credit Cards Transaction Lo&g Entries")
            {
                Caption = 'Credit Cards Transaction Lo&g Entries';
                Image = CreditCardLog;
                RunObject = Page "DO Payment Trans. Log Entries";
                RunPageLink = "Document No." = FIELD("No."),
                                  "Customer No." = FIELD("Bill-to Customer No.");
                ApplicationArea = all;
            }
            action("Multi Payment")
            {
                Caption = 'Multi Payment';
                Image = AuthorizeCreditCard;
                ApplicationArea = all;
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
        addafter("Create &Warehouse Shipment")
        {
            action(HandheldShipingLevel)
            {
                Caption = 'Handheld Shipping Level Print';
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;

                trigger OnAction()
                var
                    recWhseShptLines: Record "Warehouse Shipment Line";
                    WarehouseShipmentHeader: Record "Warehouse Shipment Header";
                    rptTest: Report "Print Shipping Lable HandHeld";
                begin
                    recWhseShptLines.Reset;
                    recWhseShptLines.SetRange("Source No.", Rec."No.");
                    if recWhseShptLines.FindFirst then begin
                        Clear(rptTest);
                        rptTest.InitVar(recWhseShptLines."No.");
                        rptTest.Run;

                    end;
                end;
            }
            action("FedEx Address Validation")
            {
                Caption = 'FedEx Address Validation';
                Image = "Action";
                ApplicationArea = all;

                trigger OnAction()
                begin
                    if ((Rec."Ship-to Country/Region Code" = 'US') or (Rec."Ship-to Country/Region Code" = 'CA')) and (not Rec.AddressValidated) and (Rec.Status.AsInteger() <> 1) then
                        AddressValidation.USAddressValidationJsonSalesOrder(Rec);
                end;
            }
            action(StandardComment)
            {
                Caption = 'Standard Comment';
                Ellipsis = true;
                Image = ViewComments;
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
                Rec."Posting Date" := WorkDate();
                Rec.Validate("Posting Date");
                Rec.Modify();
            end;
        }
        modify(PostAndNew)
        {
            Visible = false;
        }
        modify("Work Order")
        {
            Visible = false;
        }
        modify("Pick Instruction")
        {
            Visible = false;
        }
        addafter("Pick Instruction")
        {
            action(SalesOrderPrint)
            {
                Caption = 'Sales Order Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;

                trigger OnAction()
                var
                    recSalesHeader: Record "Sales Header";
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    REPORT.Run(50123, true, false, Rec);
                    //REPORT.RUN(50126,TRUE,TRUE,Rec);
                end;
            }
            action(SalesOrderPrintword)
            {
                Caption = 'Sales Order Print - Word';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;

                trigger OnAction()
                var
                    recSalesHeader: Record "Sales Header";
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    REPORT.Run(50124, true, false, Rec);
                    //REPORT.RUN(50126,TRUE,TRUE,Rec);
                end;
            }
        }
        addafter(AttachAsPDF)
        {
            action(Prices)
            {
                Caption = 'Prices';
                Image = Price;
                Promoted = true;
                RunObject = Page "Price List Line New";
                // RunPageLink = "Sales Type" = CONST(Customer),
                //               "Sales Code" = FIELD("Sell-to Customer No.");
                RunPageLink = "Source Type" = filter(Customer),
                              "Source No." = FIELD("Sell-to Customer No.");
                RunPageView = SORTING("Source Type", "Source No.");
                ApplicationArea = all;
            }
            action(RefundPayment)
            {
                Visible = false;
                ApplicationArea = all;
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
                        DataText.AddText(Encrypt(Format(AuthenticationID))); //vishal
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
        }
        addlast("Create Purchase Document")
        {
            action(CreateTansOrder)
            {
                ApplicationArea = Suite;
                Caption = 'Create New Transfer Order';
                Image = Document;
                ToolTip = 'Create transfer orders to get the items that are required by this sales document, minus any quantity that is already available.';

                trigger OnAction()
                var
                    TransDocFromSalesDoc: Codeunit "SLK Create Trans. Ord. from SO";
                begin
                    TransDocFromSalesDoc.Run(Rec);
                end;
            }

            action(AppendTansOrder)
            {
                ApplicationArea = Suite;
                Caption = 'Add to Existing Transfer Order';
                Image = Document;
                ToolTip = 'Create transfer orders to get the items that are required by this sales document, minus any quantity that is already available.';

                trigger OnAction()
                var
                    TransferHeader: Record "Transfer Header";
                    TransDocFromSalesDoc: Codeunit "SLK Create Trans. Ord. from SO";
                begin
                    TransferHeader.SetRange("Transfer-to Code", Rec."Location Code");
                    if Page.RunModal(0, TransferHeader) = Action::LookupOK then begin
                        Clear(TransDocFromSalesDoc);
                        TransDocFromSalesDoc.SetTransferHeader(TransferHeader."No.", false);
                        TransDocFromSalesDoc.Run(Rec);
                    end;
                end;
            }
        }

        addlast(processing)
        {
            group(Stax)
            {
                Caption = 'Stax';
                Image = Payment;

                action(CreatePayLink)
                {
                    ApplicationArea = All;
                    Caption = 'Create Payment Link';
                    Image = SetupPayment;

                    trigger OnAction()
                    var
                        StaxPayLinkRep: Report "SLK Create Stax Payment Link";
                    begin
                        Clear(StaxPayLinkRep);
                        StaxPayLinkRep.SetInitReport(1, Rec."No.");
                        StaxPayLinkRep.RunModal();
                    end;
                }
                action(PaymentLink)
                {
                    ApplicationArea = All;
                    Image = ElectronicPayment;
                    Caption = 'Payment Link';

                    RunObject = page "TLI Stax Payment Links";
                    RunPageLink = "Document Type" = filter(1), "Document No." = field("No.");
                    RunPageMode = View;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SRSetup.Get();
        ShowProjectInfo := SRSetup."Show Project Info";

        Rec.SETRANGE("Date Filter", 0D, WORKDATE - 1);
        Rec.SetRange("Short Close", false);
        IF Rec."Commission Override" THEN
            blnOverride := TRUE
        ELSE
            blnOverride := FALSE;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        IF Rec."Commission Override" THEN
            blnOverride := TRUE
        ELSE
            blnOverride := FALSE;
    end;

    var
        SRSetup: Record "Sales & Receivables Setup";
        ShowProjectInfo: Boolean;
        recSalesCommentLine: Record "Sales Comment Line";
        recSalesCommentLine1: Record "Sales Comment Line";
        recStandardComment: Record "Standard Comment";
        recSalesLine1: Record "Sales Line";
        LineNo: Integer;
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
        // Xmlhttp: Automation;
        Result: Boolean;
        txtURL: Text;
        recCompInfo: Record "Company Information";
        AddressValidation: Codeunit "Address Validation";

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
