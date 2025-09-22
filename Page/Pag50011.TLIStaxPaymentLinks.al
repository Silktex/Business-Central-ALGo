page 50011 "TLI Stax Payment Links"
{
    ApplicationArea = All;
    Caption = 'Stax Payment Links';
    PageType = List;
    SourceTable = "TLI Stax Payment Link";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Common Name"; Rec."Common Name")
                {
                    ToolTip = 'Specifies the value of the Common Name field.', Comment = '%';
                }
                field("Payment Link Id"; Rec."Payment Link Id")
                {
                    ToolTip = 'Specifies the value of the Payment Link Id field.', Comment = '%';
                }
                field("Tiny Url"; Rec."Tiny Url")
                {
                    ToolTip = 'Specifies the value of the Tiny Url field.', Comment = '%';
                }

                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field(Active; Rec.Active)
                {
                    ToolTip = 'Specifies the value of the Active field.', Comment = '%';
                }
                field("Total Sales"; Rec."Total Sales")
                {
                    ToolTip = 'Specifies the value of the Total Sales field.', Comment = '%';
                }
                field("Total Transactions"; Rec."Total Transactions")
                {
                    ToolTip = 'Specifies the value of the Total Transactions field.', Comment = '%';
                }
                field(Message; Rec.Message)
                {
                    ToolTip = 'Specifies the value of the Message field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GetPayLink)
            {
                ApplicationArea = All;
                Caption = 'Get Payment Link Info';
                Image = "Invoicing-Payment";

                trigger OnAction()
                var
                    StaxPaymentMgmt: Codeunit "TLI Stax Payment Handler";
                    ConfirmCreateLinkMsg: Label 'Are you sure to create payment link?', Locked = true;
                begin
                    Clear(StaxPaymentMgmt);
                    if StaxPaymentMgmt.GetPaymentLinkInfo(Rec) then
                        CurrPage.Update(false);
                end;
            }
            action(UpdatePaid)
            {
                ApplicationArea = All;
                Caption = 'Update Paid';
                Image = PriceAdjustment;

                trigger OnAction()
                var
                    ConfirmPaidMsg: Label 'Are you sure to mark record as paid?', Locked = true;
                begin
                    if not Confirm(ConfirmPaidMsg) then
                        exit;
                    Rec.TestField(Status, Rec.Status::Generated);
                    Rec.Status := Rec.Status::Success;
                    Rec.Message := 'Paid by Client';
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
            action(UpdateFailed)
            {
                ApplicationArea = All;
                Caption = 'Update Failed';
                Image = UnApply;

                trigger OnAction()
                var
                    ConfirmFailedMsg: Label 'Are you sure to mark record as Failed?', Locked = true;
                begin
                    if not Confirm(ConfirmFailedMsg) then
                        exit;
                    Rec.TestField(Status, Rec.Status::Generated);
                    Rec.Status := Rec.Status::Failed;
                    Rec.Message := 'Payment Failed';
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
            action(UpdateCancelled)
            {
                ApplicationArea = All;
                Caption = 'Update Cancelled';
                Image = CancelLine;

                trigger OnAction()
                var
                    ConfirmCanceleMsg: Label 'Are you sure to mark record as Cancelled?', Locked = true;
                begin
                    if not Confirm(ConfirmCanceleMsg) then
                        exit;
                    Rec.TestField(Status, Rec.Status::Generated);
                    Rec.Status := Rec.Status::Cancelled;
                    Rec.Message := 'Cancelled.';
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }

            action(DeleteLine)
            {
                ApplicationArea = All;
                Caption = 'Delete Line';
                Image = Delete;

                trigger OnAction()
                var
                    StaxPaymentMgmt: Codeunit "TLI Stax Payment Handler";
                    ConfirmDelMsg: Label 'Are you sure to delete selected line?', Locked = true;
                begin
                    if not Confirm(ConfirmDelMsg) then
                        exit;

                    Clear(StaxPaymentMgmt);
                    if StaxPaymentMgmt.DelPaymentLinkInfo(Rec) then begin
                        Rec.Delete(true);
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
        area(Promoted)
        {
            actionref(GetPayLink_P; GetPayLink)
            {
            }
            actionref(UpdatePaid_P; UpdatePaid)
            {
            }
            actionref(UpdateFailed_P; UpdateFailed)
            {
            }
            actionref(UpdateCancelled_P; UpdateCancelled)
            {
            }
        }
    }
}
