report 50082 "Add Postage in Stamps"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            var
                ReturnRespnceMessage: Text;
            begin
                //Meghna BEGIN
                GetToken(ReturnRespnceMessage);
                AddBalance(ReturnRespnceMessage, PurchaseAmount, ControlTotal, IntegratorTxID);
                //Meghna END
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(PurchaseAmount; PurchaseAmount)
                {
                    Caption = 'Purchase Amount';
                    ApplicationArea = all;
                }
                field(LastPurchaseAmount; LastPurchaseAmount)
                {
                    Caption = 'Last Purchase Amount';
                    Editable = false;
                    ApplicationArea = all;
                }
                field(ControlTotal; ControlTotal)
                {
                    Caption = 'Control Total';
                    Editable = false;
                    ApplicationArea = all;
                }
                field(IntegratorTxID; IntegratorTxID)
                {
                    Caption = 'Integrator TxID';
                    Editable = false;
                    ApplicationArea = all;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        LastPurchaseAmount: Decimal;
        PurchaseAmount: Decimal;
        ControlTotal: Decimal;
        IntegratorTxID: Code[20];
        CompInfo: Record "Company Information";

    local procedure GetToken(var ReturnRespnceMessage: Text)
    var
        // Stamps: DotNet ShippingServices;
        // ReturnMessage: Text;
        // bl: Boolean;
        // RetAuthenticateUser: DotNet RetAuthenticateUser;
        // jsonstring: Text;
        URL: Text;
    begin
        // CompInfo.GET();
        // jsonstring := '{'
        //   + '"Credentials":{'
        //     + '"IntegrationID":"' + CompInfo."Stamps Integration ID" + '",'
        //     + '"Username":"' + CompInfo."Stamps Username" + '",'
        //     + '"Password":"' + CompInfo."Stamps Password" + '"'
        //   + '}'
        // + '}';

        // //URL := 'https://swsim.stamps.com/swsim/swsimv101.asmx';
        // URL := CompInfo."Stamps URL";

        // Stamps := Stamps.ShippingServices();
        // RetAuthenticateUser := Stamps.AuthenticateUser(jsonstring, URL);
        // bl := RetAuthenticateUser.Status();
        // ReturnMessage := RetAuthenticateUser.Message();
        // ReturnRespnceMessage := RetAuthenticateUser.Authenticator;
    end;

    local procedure AddBalance(ReturnRespnceMessage: Text; decPurchaseAmount: Decimal; decControlTotal: Decimal; txtIntegratorTxID: Code[20])
    var
    // Stamps: DotNet ShippingServices;
    // AddBalancetxtLabeljsonstring: Text;
    // RetMessage: Text;
    // bl: Boolean;
    // ReturnMessage: Text;
    // RetPurchasePostage: DotNet RetPurchasePostage;
    // URL: Text;
    begin
        // CompInfo.GET();
        // AddBalancetxtLabeljsonstring := '{'
        //   + '"Item": "' + ReturnRespnceMessage + '",'
        //   + '"PurchaseAmount": "' + FORMAT(decPurchaseAmount) + '",'
        //   + '"ControlTotal": "' + FORMAT(decControlTotal) + '",'
        //   + '"MI": null,'
        //   + '"IntegratorTxID": "' + FORMAT(txtIntegratorTxID) + '",'
        //   + '"SendEmail": 1'
        // + '}';

        // URL := CompInfo."Stamps URL";

        // Stamps := Stamps.ShippingServices();
        // RetPurchasePostage := Stamps.PurchasePostage(AddBalancetxtLabeljsonstring, URL);
        // bl := RetPurchasePostage.Status();
        // IF bl THEN
        //     MESSAGE('Purchase Postage Amount %1 added successfully', decPurchaseAmount)
        // ELSE
        //     MESSAGE('Not Connecting Stamps please try Again');
    end;


    procedure AddControlTotal(locControlTotal: Decimal; locLastPurchaseAmount: Decimal; locIntegratorTxID: Code[20])
    begin
        ControlTotal := locControlTotal;
        LastPurchaseAmount := locLastPurchaseAmount;
        IntegratorTxID := locIntegratorTxID;
    end;
}

