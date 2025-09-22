pageextension 50295 PaymentMethods_Ext extends "Payment Methods"
{

    layout
    {
        addafter("Direct Debit Pmt. Terms Code")
        {
            field("Payment Processor"; Rec."Payment Processor")
            {
                ApplicationArea = all;
            }
        }
    }
}
