codeunit 50004 Sedular
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        CASE Rec."Parameter String" OF
            'MIS':
                CUSmtpMail.SendMISAsPDF;
        END;
    end;

    var
        CUSmtpMail: Codeunit SmtpMail_Ext;
}

