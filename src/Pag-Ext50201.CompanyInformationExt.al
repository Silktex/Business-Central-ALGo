pageextension 50201 CompanyInformation_Ext extends "Company Information"
{
    layout
    {
        addafter(Picture)
        {
            field("D-U-N-S Number"; Rec."D-U-N-S Number")
            {
                ApplicationArea = all;
            }
            field("Report Selection"; Rec."Report Selection")
            {
                ApplicationArea = all;
            }

            field("Test MIS E-Mail"; Rec."Test MIS E-Mail")
            {
                ApplicationArea = all;
            }
        }
        movebefore("QST Registration No."; "Tax Area Code")
        //movebefore("Tax Registertion No.";"QST Registration No.")

        addafter(General)
        {
            group(Stamp)
            {
                Caption = 'Stamp';
                field("Stamp Postage Nos."; Rec."Stamp Postage Nos.")
                {
                    ApplicationArea = all;
                }
                field("Stamps URL"; Rec."Stamps URL")
                {
                    ApplicationArea = all;
                }
                field("Stamps Integration ID"; Rec."Stamps Integration ID")
                {
                    ApplicationArea = all;
                }
                field("Stamps Username"; Rec."Stamps Username")
                {
                    ApplicationArea = all;
                }
                field("Stamps Password"; Rec."Stamps Password")
                {
                    ApplicationArea = all;
                }
            }
            group(NOP)
            {
                Caption = 'NOP';
                field("NOP Sync URL Activate"; Rec."NOP Sync URL Activate")
                {
                    ApplicationArea = all;
                }
                field("NOP Sync URL"; Rec."NOP Sync URL")
                {
                    Caption = '<NOP Sync URL>';
                    ApplicationArea = all;
                }
            }
            group("Authorize Dot Net.")
            {
                Caption = 'Authorize Dot Net.';
                field("Address Validation URL"; Rec."Address Validation URL")
                {
                    ApplicationArea = all;
                }
                field("Auth Dot Net URL"; Rec."Auth Dot Net URL")
                {
                    ApplicationArea = all;
                }
                field(MerchantAuthenticationName; Rec.MerchantAuthenticationName)
                {
                    ApplicationArea = all;
                }
                field(MerchantTransactionKey; Rec.MerchantTransactionKey)
                {
                    ApplicationArea = all;
                }
                field("Fedex Lebal Type"; Rec."Fedex Lebal Type")
                {
                    ApplicationArea = all;
                }
            }
        }
        addafter("System Indicator")
        {
            group("System Settings")
            {
                field(IsUpdateNopDatabase; Rec.IsUpdateNopDatabase)
                {
                    ApplicationArea = all;
                }
                field(NopDataHandlerIP; Rec.NopDataHandlerIP)
                {
                    ApplicationArea = all;
                }
                field(RocketShipIP; Rec.RocketShipIP)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        addafter(Codes)
        {
            group(Stamps)
            {
                Caption = 'Stamps';
                action(AddBalance)
                {
                    ApplicationArea = Advanced;
                    Caption = 'Add Stamp Balance';
                    Image = Add;

                    trigger OnAction()
                    var
                        ReturnRespnceMessage: Text;
                        AddStampPostage: Report "Add Postage in Stamps";
                        ControlTotal: Decimal;
                        Result: Boolean;
                        LastPurchaseAmount: Decimal;
                        NoSeriesMgt: Codeunit "No. Series";
                        CompInfo: Record "Company Information";
                        IntegratorTxID: Code[20];
                    begin
                        //Meghna BEGIN
                        if IntegratorTxID = '' then begin
                            CompInfo.Get();
                            CompInfo.TestField("Stamp Postage Nos.");
                            //NoSeriesMgt.InitSeries(Rec."Stamp Postage Nos.", xRec."Stamp Postage Nos.", Today, IntegratorTxID, Rec."Stamp Postage Nos.");
                            IntegratorTxID := NoSeriesMgt.GetNextNo(rec."Stamp Postage Nos.", Today);
                            Commit;
                        end;


                        GetToken(ReturnRespnceMessage);
                        Result := GetControlTotal(ReturnRespnceMessage, ControlTotal, LastPurchaseAmount);
                        if Result then begin
                            AddStampPostage.AddControlTotal(ControlTotal, LastPurchaseAmount, IntegratorTxID);
                            AddStampPostage.RunModal();
                        end;
                        //Meghna END
                    end;
                }
                action(CheckStampsBalance)
                {
                    ApplicationArea = Advanced;
                    Caption = 'Check Stamps Balance';
                    Image = Check;

                    trigger OnAction()
                    var
                        ReturnRespnceMessage: Text;
                    begin
                        //Meghna BEGIN
                        GetToken(ReturnRespnceMessage);
                        CheckAccountInfo(ReturnRespnceMessage);
                        //Meghna END
                    end;
                }
            }
        }
    }
    var
        PurchaseAmount: Decimal;
        ControlTotal: Decimal;
        IntegratorTxID: Text;
        CompInfo: Record "Company Information";

    local procedure GetToken(var ReturnRespnceMessage: Text)
    var
        ReturnMessage: Text;
        bl: Boolean;
        jsonstring: Text;
        URL: Text;
    begin
        CompInfo.Get();
        jsonstring := '{'
          + '"Credentials":{'
            + '"IntegrationID":"' + CompInfo."Stamps Integration ID" + '",'
            + '"Username":"' + CompInfo."Stamps Username" + '",'
            + '"Password":"' + CompInfo."Stamps Password" + '"'
          + '}'
        + '}';

        URL := CompInfo."Stamps URL";

        //Stamps :=Stamps.ShippingServices();
        //RetAuthenticateUser := Stamps.AuthenticateUser(jsonstring, URL);
        //bl:= RetAuthenticateUser.Status();
        //ReturnMessage:= RetAuthenticateUser.Message();
        //ReturnRespnceMessage:= RetAuthenticateUser.Authenticator;
    end;

    local procedure CheckAccountInfo(ReturnRespnceMessage: Text)
    var
        jsonstring: Text;
        bl: Boolean;
        ReturnMessage: Text;
        txtResponse: Text;
        Control_Total: Decimal;
        Purchase_Amount: Decimal;
        URL: Text;
    begin
        CompInfo.Get();
        jsonstring := '{'
          + '"Item": "' + ReturnRespnceMessage + '"'
        + '}';

        URL := CompInfo."Stamps URL";

        //Stamps :=Stamps.ShippingServices();
        //RetGetAccountInfo := Stamps.GetAccountInfo(jsonstring,URL);
        //bl:= RetGetAccountInfo.Status();
        //ReturnMessage := RetGetAccountInfo.Message();
        //Control_Total := RetGetAccountInfo.Control_Total();
        //Purchase_Amount := RetGetAccountInfo.Purchase_Amount();
        if bl then
            Message('In your Stamps Account Purchase Amount %1 & Control Total is %2', Purchase_Amount, Control_Total)
        else
            Message('Not Getting Stamps Responce');
    end;

    local procedure GetControlTotal(ReturnRespnceMessage: Text; var Control_Total: Decimal; var Purchase_Amount: Decimal) Result: Boolean
    var
        jsonstring: Text;
        bl: Boolean;
        ReturnMessage: Text;
        txtResponse: Text;
        URL: Text;
    begin
        /*
        CompInfo.GET();
        jsonstring := '{'
          + '"Item": "'+ReturnRespnceMessage+'"'
        + '}';
        
        URL := CompInfo."Stamps URL";
        
        Stamps :=Stamps.ShippingServices();
        RetGetAccountInfo := Stamps.GetAccountInfo(jsonstring,URL);
        bl:= RetGetAccountInfo.Status();
        Control_Total := RetGetAccountInfo.Control_Total();
        Purchase_Amount := RetGetAccountInfo.Purchase_Amount();
        EXIT(bl);
        */

    end;
}
