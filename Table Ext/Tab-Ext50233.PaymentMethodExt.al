tableextension 50233 "Payment Methoy_Ext" extends "Payment Method"
{
    fields
    {
        field(50000; "Payment Processor"; Option)
        {
            Caption = 'Payment Processor';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Dynamics Online';
            OptionMembers = " ","Dynamics Online";

            trigger OnValidate()
            begin
                IF "Payment Processor" = "Payment Processor"::"Dynamics Online" THEN
                    TESTFIELD("Bal. Account Type", "Bal. Account Type"::"Bank Account");
            end;
        }
    }
}
