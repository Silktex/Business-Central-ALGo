pageextension 50219 "Purchase Order_Ext" extends "Purchase Order"
{
    layout
    {
        modify("Buy-from Vendor No.")
        {
            Importance = Standard;
        }
        addafter("Buy-from Vendor Name")
        {
            field("Buy-from Vendor Name 2"; Rec."Buy-from Vendor Name 2")
            {
                ApplicationArea = all;
            }
        }
        modify("Posting Date")
        {
            Importance = Standard;
        }
        modify("Vendor Order No.")
        {
            Importance = Standard;
        }
        modify("Vendor Shipment No.")
        {
            Importance = Additional;
        }
        addafter(Status)
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = all;
            }
            field("ETA Date"; Rec."ETA Date")
            {
                ApplicationArea = all;
            }
            field("Document Type"; Rec."Document Type")
            {
                Visible = false;
                ApplicationArea = all;
            }
            field(Amount; Rec.Amount)
            {
                Visible = false;
                ApplicationArea = all;
            }
        }
        modify("Ship-to UPS Zone")
        {
            Visible = true;
            ApplicationArea = all;
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
                    ReportHelper: Codeunit SmtpMail_Ext;
                    Name: Text[50];
                    FileName: Text[250];
                    ToFile: Text[250];
                    PurchaseHeader: Record "Purchase Header";
                    RecRef: RecordRef;
                    OutStreamValue: OutStream;
                    InStreamValue: InStream;
                    Tempblob: Codeunit "Temp Blob";
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    Name := StrSubstNo('%1.pdf', rec."No.");
                    CUMail.PurchOrderOutlook(Rec, Name);
                    //REPORT.SaveAsPdf(50010, FileName, Rec);
                    //ToFile := ReportHelper.DownloadToClientFileName(FileName, ToFile);
                    //CUMail.NewMessage('','','Order','',ToFile,TRUE);

                    //FILE.Erase(FileName);
                end;
            }
        }
        addafter(MoveNegativeLines)
        {
            action(Prices)
            {
                Caption = 'Prices';
                Image = Price;
                RunObject = Page "Price List Line New";
                // RunPageLink = "Sales Type" = CONST(Customer),
                //               "Sales Code" = FIELD("Sell-to Customer No.");
                RunPageLink = "Source Type" = filter(Vendor),
                              "Source No." = FIELD("Buy-from Vendor No.");
                RunPageView = SORTING("Source Type", "Source No.");
                ApplicationArea = all;

            }
            action(ShortClose)
            {
                ApplicationArea = all;

                trigger OnAction()
                begin
                    Rec.TestField("Reason Code");
                    recSalesLine.Reset;
                    recSalesLine.SetRange("Document Type", Rec."Document Type");
                    recSalesLine.SetRange("Document No.", Rec."No.");
                    if recSalesLine.Find('-') then
                        repeat

                            if recSalesLine."Quantity Received" <> recSalesLine."Quantity Invoiced" then
                                Error('Qty Invoiced must be %1 on Line No. %2', recSalesLine."Quantity Received", recSalesLine."Line No.");
                        until recSalesLine.Next = 0;
                    if not Confirm('Do you want to short Close', false, true) then
                        exit;
                    Rec.SetHideValidationDialog(true);
                    Rec."Short Close" := true;
                    Rec.Delete(true);
                end;
            }

        }
        addafter(SendCustom)
        {
            action("Open PO Report")
            {
                Caption = 'Open PO Report';
                Description = 'Open PO Report';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                ToolTip = 'Open PO Report';
                ApplicationArea = all;

                trigger OnAction()
                var
                    recPurchLine: Record "Purchase Line";
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    recPurchLine.Reset;
                    recPurchLine.SetRange(recPurchLine."Document No.", Rec."No.");
                    if recPurchLine.FindFirst then
                        REPORT.RunModal(50011, true, true, recPurchLine);
                    Rec.Reset;
                end;
            }
            action("Urgent Goods Requirement")
            {
                Caption = 'Urgent Goods Requirement';
                Description = 'Urgent Goods Requirement';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Urgent Goods Requirement";
                ToolTip = 'Urgent Goods Requirement New';
                ApplicationArea = all;
            }
        }
    }
    var
        recSalesLine: Record "Purchase Line";
}
