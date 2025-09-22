codeunit 50003 "Purch.-Post (Yes/No) Por"
{
    TableNo = "Purchase Header";

    trigger OnRun()
    begin
        PurchHeader.COPY(Rec);
        Code;
        Rec := PurchHeader;
    end;

    var
        Text000: Label '&Receive,&Invoice,Receive &and Invoice';
        Text001: Label 'Do you want to post the %1?';
        Text002: Label '&Ship,&Invoice,Ship &and Invoice';
        PurchHeader: Record "Purchase Header";
        Selection: Integer;
        cuPurchPost: Codeunit "Purch.-Post";

    local procedure "Code"()
    var
        PurchSetup: Record "Purchases & Payables Setup";
        PurchPostViaJobQueue: Codeunit "Purchase Post via Job Queue";
    begin
        //WITH PurchHeader DO BEGIN
        CASE PurchHeader."Document Type" OF
            PurchHeader."Document Type"::Order:
                BEGIN
                    /*Selection := STRMENU(Text000,3);
                    IF Selection = 0 THEN
                      EXIT;
                    Receive := Selection IN [1,3];
                    Invoice := Selection IN [2,3];*/
                    PurchHeader.Receive := TRUE;
                    PurchHeader.Invoice := FALSE;

                END;
        /* "Document Type"::"Return Order":
           BEGIN
             Selection := STRMENU(Text002,3);
             IF Selection = 0 THEN
               EXIT;
             Ship := Selection IN [1,3];
             Invoice := Selection IN [2,3];
           END
         ELSE
           IF NOT
              CONFIRM(
                Text001,FALSE,
                "Document Type")
           THEN
             EXIT; */
        END;
        PurchHeader."Print Posted Documents" := FALSE;

        CLEAR(cuPurchPost);
        cuPurchPost.RUN(PurchHeader);
        //END;

        /*PurchSetup.GET;
        IF PurchSetup."Post with Job Queue" THEN
          PurchPostViaJobQueue.EnqueuePurchDoc(PurchHeader)
        ELSE
          CODEUNIT.RUN(CODEUNIT::"Purch.-Post",PurchHeader);
      ;*/

    end;
}

