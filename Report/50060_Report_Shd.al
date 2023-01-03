report 50060 Shd
{
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Statment; Statment)
                {
                    Caption = 'Send Statment';
                    ApplicationArea = all;
                }
                field(Reorder; Reorder)
                {
                    Caption = 'Save Reorder Report on FTP';
                    ApplicationArea = all;
                }
                field(MISReport; MISReport)
                {
                    Caption = 'Send Mail  MIS Report';
                    ApplicationArea = all;
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            Statment := TRUE;
            Reorder := TRUE;
            MISReport := TRUE;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        IF Statment THEN
            REPORT.RUN(REPORT::"Statment Scheduler");
        // IF Reorder THEN
        //     REPORT.RUN(REPORT::"Reorder Shd");
        IF MISReport THEN
            CUSmtpMail.SendMISAsPDF;
    end;

    var
        CUSmtpMail: Codeunit SmtpMail_Ext;
        Statment: Boolean;
        Reorder: Boolean;
        MISReport: Boolean;
}

