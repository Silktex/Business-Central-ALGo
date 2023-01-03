codeunit 50209 "Release Sales Document_Ext"
{
    var
        recUserSetup: Record "User Setup";
        RecSalesLinePresent: Record "Sales Line";

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Release Sales Document", 'OnAfterManualReleaseSalesDoc', '', false, false)]
    local procedure OnAfterManualReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    var
        UserSetup: Record "User Setup";
        SendSmtpMail: Codeunit SmtpMail_Ext;
        LocText001: Label 'Do you want to send email?';
    begin
        //Ashwini
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) AND (SalesHeader."Location Code" <> 'MATRL BANK') THEN BEGIN
            IF UserSetup.GET(USERID) AND UserSetup."Sent Mail Sales Order" THEN BEGIN
                IF GUIALLOWED AND CONFIRM(LocText001, FALSE) THEN BEGIN
                    SendSmtpMail.SendSalesOrderAsPDF(SalesHeader);
                END;
            END;
        END;
        // Ashwini
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Release Sales Document", 'OnBeforeReopenSalesDoc', '', false, false)]
    local procedure OnBeforeReopenSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean)
    begin
        //SKNAV11.00 : Begin
        recUserSetup.GET(USERID);
        IF NOT recUserSetup."Allow Reopen Sales Doc." THEN
            ERROR('You Do not have permission to reopen sales order please contact your system admin');
        //SKNAV11.00 : End
    end;

    procedure InsertResourceFunction(var DocNo: Code[20]; var CustomerNo: Code[20])
    var
        recSaLine: Record "Sales Line";
        recResource: Record "BACKING TABLE FOR NAV";
        RecSalesLinePresent: Record "Sales Line";
        LineNo: Integer;
        SalesLine: Record "Sales Line";
        Cust: Record Customer;
        resourceCreated: Boolean;
    begin
        RecSalesLinePresent.RESET;
        RecSalesLinePresent.SETRANGE("Document No.", DocNo);
        RecSalesLinePresent.SETRANGE(Type, RecSalesLinePresent.Type::Item);
        RecSalesLinePresent.SETRANGE("Resource Line Created", FALSE);
        IF RecSalesLinePresent.FINDSET THEN BEGIN
            REPEAT

                //1
                resourceCreated := FALSE;
                recResource.RESET;
                recResource.SETRANGE(recResource."Customer Type", recResource."Customer Type"::Customer);
                recResource.SETRANGE(recResource."Customer Code", CustomerNo);
                recResource.SETRANGE("Product Type", recResource."Product Type"::Item);
                recResource.SETRANGE("Product Code", RecSalesLinePresent."No.");
                IF recResource.FINDSET THEN BEGIN
                    REPEAT
                        LineNo := 0;
                        recSaLine.RESET;
                        recSaLine.SETRANGE("Document No.", DocNo);
                        recSaLine.SETRANGE("No.", RecSalesLinePresent."No.");
                        recSaLine.SETRANGE("Line No.", RecSalesLinePresent."Line No.");
                        IF recSaLine.FINDFIRST THEN
                            LineNo := recSaLine."Line No.";


                        SalesLine.INIT;
                        SalesLine."Document Type" := RecSalesLinePresent."Document Type";
                        SalesLine.VALIDATE("Document No.", RecSalesLinePresent."Document No.");

                        SalesLine."Line No." := LineNo + 5000;
                        SalesLine.Type := SalesLine.Type::Resource;
                        SalesLine.VALIDATE("No.", recResource."Resc. Code");
                        SalesLine.VALIDATE("Location Code", RecSalesLinePresent."Location Code");
                        SalesLine.VALIDATE("Original Quantity", RecSalesLinePresent."Original Quantity");
                        SalesLine.VALIDATE(Quantity, RecSalesLinePresent.Quantity);
                        SalesLine.VALIDATE("Qty. to Ship", RecSalesLinePresent."Qty. to Ship");
                        SalesLine.VALIDATE("Qty. to Invoice", RecSalesLinePresent."Qty. to Invoice");
                        IF recResource."Resc. Price" <> 0 THEN
                            SalesLine.VALIDATE("Unit Price", recResource."Resc. Price");
                        IF NOT SalesLine.INSERT THEN
                            SalesLine.MODIFY;
                    UNTIL recResource.NEXT = 0;
                    resourceCreated := TRUE;
                END;

                //2
                IF resourceCreated = FALSE THEN BEGIN
                    recResource.RESET;
                    recResource.SETRANGE(recResource."Customer Type", recResource."Customer Type"::Customer);
                    recResource.SETRANGE(recResource."Customer Code", CustomerNo);
                    recResource.SETRANGE("Product Type", recResource."Product Type"::"Item Category Code");
                    recResource.SETRANGE("Product Code", RecSalesLinePresent."Item Category Code");
                    IF recResource.FINDSET THEN BEGIN
                        REPEAT
                            LineNo := 0;
                            recSaLine.RESET;
                            recSaLine.SETRANGE("Document No.", DocNo);
                            recSaLine.SETRANGE("No.", RecSalesLinePresent."No.");
                            recSaLine.SETRANGE("Line No.", RecSalesLinePresent."Line No.");
                            IF recSaLine.FINDFIRST THEN
                                LineNo := recSaLine."Line No.";

                            SalesLine.INIT;
                            SalesLine."Document Type" := RecSalesLinePresent."Document Type";
                            SalesLine.VALIDATE("Document No.", RecSalesLinePresent."Document No.");

                            SalesLine."Line No." := LineNo + 5000;
                            SalesLine.Type := SalesLine.Type::Resource;
                            SalesLine.VALIDATE("No.", recResource."Resc. Code");
                            SalesLine.VALIDATE("Location Code", RecSalesLinePresent."Location Code");
                            SalesLine.VALIDATE("Original Quantity", RecSalesLinePresent."Original Quantity");
                            SalesLine.VALIDATE(Quantity, RecSalesLinePresent.Quantity);
                            SalesLine.VALIDATE("Qty. to Ship", RecSalesLinePresent."Qty. to Ship");
                            SalesLine.VALIDATE("Qty. to Invoice", RecSalesLinePresent."Qty. to Invoice");
                            IF recResource."Resc. Price" <> 0 THEN
                                SalesLine.VALIDATE("Unit Price", recResource."Resc. Price");
                            IF NOT SalesLine.INSERT THEN
                                SalesLine.MODIFY;
                        UNTIL recResource.NEXT = 0;
                        resourceCreated := TRUE;
                    END;
                END;

                //3
                IF resourceCreated = FALSE THEN BEGIN
                    Cust.GET(CustomerNo);
                    recResource.RESET;
                    recResource.SETRANGE(recResource."Customer Type", recResource."Customer Type"::"Customer Posting Group");
                    recResource.SETRANGE(recResource."Customer Code", Cust."Customer Posting Group");
                    recResource.SETRANGE("Product Type", recResource."Product Type"::Item);
                    recResource.SETRANGE("Product Code", RecSalesLinePresent."No.");
                    IF recResource.FINDSET THEN BEGIN
                        REPEAT
                            LineNo := 0;
                            recSaLine.RESET;
                            recSaLine.SETRANGE("Document No.", DocNo);
                            recSaLine.SETRANGE("No.", RecSalesLinePresent."No.");
                            recSaLine.SETRANGE("Line No.", RecSalesLinePresent."Line No.");
                            IF recSaLine.FINDFIRST THEN
                                LineNo := recSaLine."Line No.";


                            SalesLine.INIT;
                            SalesLine."Document Type" := RecSalesLinePresent."Document Type";
                            SalesLine.VALIDATE("Document No.", RecSalesLinePresent."Document No.");
                            SalesLine."Line No." := LineNo + 5000;
                            SalesLine.Type := SalesLine.Type::Resource;
                            SalesLine.VALIDATE("No.", recResource."Resc. Code");
                            SalesLine.VALIDATE("Location Code", RecSalesLinePresent."Location Code");
                            SalesLine.VALIDATE("Original Quantity", RecSalesLinePresent."Original Quantity");
                            SalesLine.VALIDATE(Quantity, RecSalesLinePresent.Quantity);
                            SalesLine.VALIDATE("Qty. to Ship", RecSalesLinePresent."Qty. to Ship");
                            SalesLine.VALIDATE("Qty. to Invoice", RecSalesLinePresent."Qty. to Invoice");
                            IF recResource."Resc. Price" <> 0 THEN
                                SalesLine.VALIDATE("Unit Price", recResource."Resc. Price");
                            IF NOT SalesLine.INSERT THEN
                                SalesLine.MODIFY;
                        UNTIL recResource.NEXT = 0;
                        resourceCreated := TRUE;
                    END;
                END;

                //4
                IF resourceCreated = FALSE THEN BEGIN
                    Cust.GET(CustomerNo);
                    recResource.RESET;
                    recResource.SETRANGE(recResource."Customer Type", recResource."Customer Type"::"Customer Posting Group");
                    recResource.SETRANGE(recResource."Customer Code", Cust."Customer Posting Group");
                    recResource.SETRANGE("Product Type", recResource."Product Type"::"Item Category Code");
                    recResource.SETRANGE("Product Code", RecSalesLinePresent."Item Category Code");
                    IF recResource.FINDSET THEN BEGIN
                        REPEAT
                            LineNo := 0;
                            recSaLine.RESET;
                            recSaLine.SETRANGE("Document No.", DocNo);
                            recSaLine.SETRANGE("No.", RecSalesLinePresent."No.");
                            recSaLine.SETRANGE("Line No.", RecSalesLinePresent."Line No.");
                            IF recSaLine.FINDFIRST THEN
                                LineNo := recSaLine."Line No.";


                            SalesLine.INIT;
                            SalesLine."Document Type" := RecSalesLinePresent."Document Type";
                            SalesLine.VALIDATE("Document No.", RecSalesLinePresent."Document No.");
                            SalesLine."Line No." := LineNo + 5000;
                            SalesLine.Type := SalesLine.Type::Resource;
                            SalesLine.VALIDATE("No.", recResource."Resc. Code");
                            SalesLine.VALIDATE("Location Code", RecSalesLinePresent."Location Code");
                            SalesLine.VALIDATE("Original Quantity", RecSalesLinePresent."Original Quantity");
                            SalesLine.VALIDATE(Quantity, RecSalesLinePresent.Quantity);
                            SalesLine.VALIDATE("Qty. to Ship", RecSalesLinePresent."Qty. to Ship");
                            SalesLine.VALIDATE("Qty. to Invoice", RecSalesLinePresent."Qty. to Invoice");
                            IF recResource."Resc. Price" <> 0 THEN
                                SalesLine.VALIDATE("Unit Price", recResource."Resc. Price");
                            IF NOT SalesLine.INSERT THEN
                                SalesLine.MODIFY;
                        UNTIL recResource.NEXT = 0;
                        resourceCreated := TRUE;
                    END;
                END;


                //5
                IF resourceCreated = FALSE THEN BEGIN
                    recResource.RESET;
                    recResource.SETRANGE(recResource."Customer Type", recResource."Customer Type"::"All Customers");
                    recResource.SETRANGE("Product Type", recResource."Product Type"::Item);
                    recResource.SETRANGE("Product Code", RecSalesLinePresent."No.");
                    IF recResource.FINDSET THEN BEGIN
                        REPEAT
                            LineNo := 0;
                            recSaLine.RESET;
                            recSaLine.SETRANGE("Document No.", DocNo);
                            recSaLine.SETRANGE("No.", RecSalesLinePresent."No.");
                            recSaLine.SETRANGE("Line No.", RecSalesLinePresent."Line No.");
                            IF recSaLine.FINDFIRST THEN
                                LineNo := recSaLine."Line No.";


                            SalesLine.INIT;
                            SalesLine."Document Type" := RecSalesLinePresent."Document Type";
                            SalesLine.VALIDATE("Document No.", RecSalesLinePresent."Document No.");
                            SalesLine."Line No." := LineNo + 5000;
                            SalesLine.Type := SalesLine.Type::Resource;
                            SalesLine.VALIDATE("No.", recResource."Resc. Code");
                            SalesLine.VALIDATE("Location Code", RecSalesLinePresent."Location Code");
                            SalesLine.VALIDATE("Original Quantity", RecSalesLinePresent."Original Quantity");
                            SalesLine.VALIDATE(Quantity, RecSalesLinePresent.Quantity);
                            SalesLine.VALIDATE("Qty. to Ship", RecSalesLinePresent."Qty. to Ship");
                            SalesLine.VALIDATE("Qty. to Invoice", RecSalesLinePresent."Qty. to Invoice");
                            IF recResource."Resc. Price" <> 0 THEN
                                SalesLine.VALIDATE("Unit Price", recResource."Resc. Price");
                            IF NOT SalesLine.INSERT THEN
                                SalesLine.MODIFY;
                        UNTIL recResource.NEXT = 0;
                        resourceCreated := TRUE;
                    END;
                END;


                //6
                IF resourceCreated = FALSE THEN BEGIN
                    recResource.RESET;
                    recResource.SETRANGE(recResource."Customer Type", recResource."Customer Type"::"All Customers");
                    recResource.SETRANGE("Product Type", recResource."Product Type"::"Item Category Code");
                    recResource.SETRANGE("Product Code", RecSalesLinePresent."Item Category Code");
                    IF recResource.FINDSET THEN BEGIN
                        REPEAT
                            LineNo := 0;
                            recSaLine.RESET;
                            recSaLine.SETRANGE("Document No.", DocNo);
                            recSaLine.SETRANGE("No.", RecSalesLinePresent."No.");
                            recSaLine.SETRANGE("Line No.", RecSalesLinePresent."Line No.");
                            IF recSaLine.FINDFIRST THEN
                                LineNo := recSaLine."Line No.";


                            SalesLine.INIT;
                            SalesLine."Document Type" := RecSalesLinePresent."Document Type";
                            SalesLine.VALIDATE("Document No.", RecSalesLinePresent."Document No.");
                            SalesLine."Line No." := LineNo + 5000;
                            SalesLine.Type := SalesLine.Type::Resource;
                            SalesLine.VALIDATE("No.", recResource."Resc. Code");
                            SalesLine.VALIDATE("Location Code", RecSalesLinePresent."Location Code");
                            SalesLine.VALIDATE("Original Quantity", RecSalesLinePresent."Original Quantity");
                            SalesLine.VALIDATE(Quantity, RecSalesLinePresent.Quantity);
                            SalesLine.VALIDATE("Qty. to Ship", RecSalesLinePresent."Qty. to Ship");
                            SalesLine.VALIDATE("Qty. to Invoice", RecSalesLinePresent."Qty. to Invoice");
                            IF recResource."Resc. Price" <> 0 THEN
                                SalesLine.VALIDATE("Unit Price", recResource."Resc. Price");
                            IF NOT SalesLine.INSERT THEN
                                SalesLine.MODIFY;
                        UNTIL recResource.NEXT = 0;
                        resourceCreated := TRUE;
                    END;
                END;
                RecSalesLinePresent."Resource Line Created" := TRUE;
                RecSalesLinePresent.MODIFY;
            UNTIL RecSalesLinePresent.NEXT = 0;

        END;
    end;

}
