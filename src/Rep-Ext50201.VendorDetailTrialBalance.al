reportextension 50201 VendorDetailTrialBalance extends "Vendor - Detail Trial Balance"
{
    dataset
    {
    }
    trigger OnPreReport()
    begin
        //     IF (StartDate1 <> 0D) AND (EndDate1 <> 0D) THEN
        //         VendDateFilter := FORMAT(StartDate1) + '..' + FORMAT(EndDate1);
    end;

    var
        StartDate1: Date;
        EndDate1: Date;

    procedure Init(StartDate: Date; EndDate: Date)
    begin
        StartDate1 := StartDate;
        EndDate1 := EndDate
    end;
}
