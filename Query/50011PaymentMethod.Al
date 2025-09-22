query 50011 "Payment Method"
{
    QueryType = Normal;

    elements
    {
        dataitem(Payment_Method; "Payment Method")
        {
            column(Code; Code) { }
            column(Description; Description) { }
            column(Bal__Account_Type; "Bal. Account Type") { }
            column(Bal__Account_No_; "Bal. Account No.") { }
            column(Payment_Processor; "Payment Processor") { }
            column(Direct_Debit; "Direct Debit") { }
            column(Direct_Debit_Pmt__Terms_Code; "Direct Debit Pmt. Terms Code")
            { }
            column(Pmt__Export_Line_Definition; "Pmt. Export Line Definition")
            { }
            // column(Bank_Data_Conversion_Pmt__Type; "Bank Data Conversion Pmt. Type")
            // { }
            //column(Use_for_Invoicing; "LTI Use for Invoicing") { }
            column(Last_Modified_Date_Time; "Last Modified Date Time") { }
            column(Id; SystemId) { }
            column(SAT_Payment_Method_Code; "SAT Payment Method Code") { }
            column(SAT_Method_of_Payment; "SAT Method of Payment") { }
        }
    }

    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}