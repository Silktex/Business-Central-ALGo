report 50270 "Show Credit card No"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50270_Report_ShowCreditcardNo.rdlc';

    dataset
    {
        dataitem("DO Payment Credit Card"; "DO Payment Credit Card")
        {
            RequestFilterFields = "No.", Type;
            column(No; "DO Payment Credit Card"."No.")
            {
            }
            column(Type; "DO Payment Credit Card".Type)
            {
            }
            column(txtCreditCardNo; txtCreditCardNo)
            {
            }
            column(ExpireDate; "DO Payment Credit Card"."Expiry Date")
            {
            }
            column(CardHolderName; "DO Payment Credit Card"."Card Holder Name")
            {
            }
            column(CustomerNo; "DO Payment Credit Card"."Customer No.")
            {
            }
            column(ContactNo; "DO Payment Credit Card"."Contact No.")
            {
            }
            column(CVCNo; "DO Payment Credit Card"."Cvc No.")
            {
            }
            column(NoSeries; "DO Payment Credit Card"."No. Series")
            {
            }

            trigger OnAfterGetRecord()
            begin
                DPCreditCard.RESET;
                DPCreditCard.SETRANGE("No.", "No.");
                IF DPCreditCard.FINDFIRST THEN BEGIN
                    DPCCN.GET(DPCreditCard."No.");
                    txtCreditCardNo := DPCCN.GetDataNew(DPCCN);
                    IF txtCreditCardNo <> '' THEN
                        DPCreditCard."Correct credit Card" := TRUE;
                    DPCreditCard.MODIFY;
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        DPCreditCard: Record "DO Payment Credit Card";
        DPCCN: Record "DO Payment Credit Card Number";
        txtCreditCardNo: Text;
}

