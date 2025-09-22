codeunit 50205 "Purch.-Post (Yes/No)_Ext"
{

    var
        ReceiveInvoiceQst: Label '&Receive,&Invoice,Receive &and Invoice';
        PostConfirmQst: Label 'Do you want to post the %1?', Comment = '%1 = Document Type';
        ShipInvoiceQst: Label '&Ship,&Invoice,Ship &and Invoice';
        NothingToPostErr: Label 'There is nothing to post.';

    //OnBeforeCheckHeaderPostingType

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch.-Post (Yes/No)", 'OnBeforeConfirmPost', '', false, false)]
    local procedure OnBeforeConfirmPost(var PurchaseHeader: Record "Purchase Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer)
    var
        PurchSetup: Record "Purchases & Payables Setup";
        PurchPostViaJobQueue: Codeunit "Purchase Post via Job Queue";
    begin
        if not HideDialog then
            if not ConfirmPost(PurchaseHeader, DefaultOption) then
                exit;

        PurchSetup.Get();
        if PurchSetup."Post with Job Queue" then
            PurchPostViaJobQueue.EnqueuePurchDoc(PurchaseHeader)
        else begin
            CODEUNIT.Run(CODEUNIT::"Purch.-Post", PurchaseHeader);
        end;
        IsHandled := true;
    end;

    local procedure ConfirmPost(var PurchaseHeader: Record "Purchase Header"; DefaultOption: Integer): Boolean
    var
        ConfirmManagement: Codeunit "Confirm Management";
        Selection: Integer;
    begin
        if DefaultOption > 3 then
            DefaultOption := 3;
        if DefaultOption <= 0 then
            DefaultOption := 1;

        // with PurchaseHeader do begin
        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::Order:
                begin
                    //SKNAV11.00 : Begin
                    /*
                    Selection := StrMenu(ReceiveInvoiceQst, DefaultOption);
                    if Selection = 0 then
                        exit(false);
                    PurchaseHeader.Receive := Selection in [1, 3];
                    PurchaseHeader.Invoice := Selection in [2, 3];
                    */
                    PurchaseHeader.Receive := TRUE;
                    PurchaseHeader.Invoice := FALSE;//SC-TIC-55 Begin
                    //PurchaseHeader.Invoice := true;//SC-TIC-55 Begin
                    //SKNAV11.00 : End
                end;
            PurchaseHeader."Document Type"::"Return Order":
                begin
                    Selection := StrMenu(ShipInvoiceQst, DefaultOption);
                    if Selection = 0 then
                        exit(false);
                    PurchaseHeader.Ship := Selection in [1, 3];
                    PurchaseHeader.Invoice := Selection in [2, 3];
                end
            else
                if not ConfirmManagement.GetResponseOrDefault(
                     StrSubstNo(PostConfirmQst, LowerCase(Format(PurchaseHeader."Document Type"))), true)
                then
                    exit(false);
        end;
        PurchaseHeader."Print Posted Documents" := false;
        //PurchaseHeader."Posted Tax Document" := true;
        //end;
        exit(true);
    end;

}
