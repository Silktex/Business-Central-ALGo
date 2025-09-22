codeunit 50014 "Sedular POSH"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        CASE Rec."Parameter String" OF
            'MIS':
                CUSmtpMail.SendMISAsPDFPOSH();
        END;
        //CUSmtpMail.SendMISAsPDF;
    end;

    var
        CUSmtpMail: Codeunit SmtpMail_Ext;
}

