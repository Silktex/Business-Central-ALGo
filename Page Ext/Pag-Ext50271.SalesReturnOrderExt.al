pageextension 50271 "Sales Return Order_Ext" extends "Sales Return Order"
{
    layout
    {
        addafter(Status)
        {
            field("Commission Override"; Rec."Commission Override")
            {
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
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = all;
            }
            field("Commision %"; Rec."Commision %")
            {
                Editable = blnOverride;
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("Send IC Return Order Cnfmn.")
        {
            action(RefundPayment)
            {
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
                        DataText.AddText(Encrypt(Format(AuthenticationID)));
                        IntLength := DataText.Length;
                        //FOR i:=1 to 8 DO BEGIN
                        DataText.GetSubText(Authentication, 1);
                        //Authentication

                        HyperLink('http://192.168.1.11:57474/PayNow.aspx?PayId=' + Authentication + '&OID=Refund');
                    end else begin
                        Error('Payment Method Code is not defined for online Payment');
                    end;
                end;
            }
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

                            if recSalesLine."Return Qty. Received" <> recSalesLine."Quantity Invoiced" then
                                Error('Qty Invoiced must be %1 on Line No. %2', recSalesLine."Quantity Shipped", recSalesLine."Line No.");
                        until recSalesLine.Next = 0;
                    if not Confirm('Do you want to short Close', false, true) then
                        exit;
                    Rec.SetHideValidationDialog(true);
                    Rec."Short Close" := true;
                    Rec.Delete(true);
                end;
            }

        }
    }
    trigger OnOpenPage()
    begin
        IF Rec."Commission Override" THEN
            blnOverride := TRUE
        ELSE
            blnOverride := FALSE;
    end;

    trigger OnAfterGetRecord()
    begin
        JobQueueVisible := Rec."Job Queue Status" = Rec."Job Queue Status"::"Scheduled for Posting";
        IF Rec."Commission Override" THEN
            blnOverride := TRUE
        ELSE
            blnOverride := FALSE;
    end;

    var
        JobQueueVisible: Boolean;
        blnOverride: Boolean;
        Authentication: Text[1024];
        AuthenticationID: Text[30];
        SalesPost: Codeunit SalesPost_Ext;
        DPTLE: Record "DO Payment Trans. Log Entry";
        DataText: BigText;
        //EncryptionMgt: Codeunit "Encryption Management";
        IntLength: Integer;
        recSalesLine: Record "Sales Line";

}
