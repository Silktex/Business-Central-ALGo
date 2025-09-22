report 50006 "Change Vendor-Purchase Order"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                IF (OrderNo <> '') AND (ToVendor <> '') THEN BEGIN
                    recPurchaseHeader.RESET;
                    recPurchaseHeader.SETRANGE(recPurchaseHeader."Document Type", recPurchaseHeader."Document Type"::Order);
                    recPurchaseHeader.SETRANGE(recPurchaseHeader."No.", OrderNo);
                    IF recPurchaseHeader.FINDFIRST THEN BEGIN
                        recPurchaseLine.RESET;
                        recPurchaseLine.SETRANGE(recPurchaseLine."Document Type", recPurchaseHeader."Document Type");
                        recPurchaseLine.SETRANGE(recPurchaseLine."Document No.", recPurchaseHeader."No.");
                        IF recPurchaseLine.FINDFIRST THEN
                            REPEAT
                                IF recPurchaseLine."Qty. Rcd. Not Invoiced" <> 0 THEN
                                    ERROR(Text001, recPurchaseLine."Document No.", recPurchaseLine."Line No.", recPurchaseLine."No.", recPurchaseLine."Qty. Rcd. Not Invoiced");
                            UNTIL recPurchaseLine.NEXT = 0;

                        recVendor.GET(ToVendor);
                        IF ChangePayTo THEN BEGIN
                            recPurchaseHeader."Buy-from Vendor No." := recVendor."No.";
                            recPurchaseHeader."Buy-from Vendor Name" := recVendor.Name;
                            recPurchaseHeader."Buy-from Vendor Name 2" := recVendor."Name 2";
                            recPurchaseHeader."Buy-from Address" := recVendor.Address;
                            recPurchaseHeader."Buy-from Address 2" := recVendor."Address 2";
                            recPurchaseHeader."Buy-from City" := recVendor.City;
                            recPurchaseHeader."Buy-from Contact" := recVendor.Contact;
                            recPurchaseHeader."Buy-from Post Code" := recVendor."Post Code";
                            recPurchaseHeader."Buy-from County" := recVendor.County;
                            recPurchaseHeader."Buy-from Country/Region Code" := recVendor."Country/Region Code";
                            recPurchaseHeader."Buy-from IC Partner Code" := recVendor."IC Partner Code";
                            recPurchaseHeader."Buy-from Contact No." := recVendor.Contact;
                        END;
                        IF ChangePayTo THEN BEGIN
                            recPurchaseHeader."Pay-to Vendor No." := recVendor."No.";
                            recPurchaseHeader."Pay-to Name" := recVendor.Name;
                            recPurchaseHeader."Pay-to Name 2" := recVendor."Name 2";
                            recPurchaseHeader."Pay-to Address" := recVendor.Address;
                            recPurchaseHeader."Pay-to Address 2" := recVendor."Address 2";
                            recPurchaseHeader."Pay-to City" := recVendor.City;
                            recPurchaseHeader."Pay-to Contact" := recVendor.Contact;
                            recPurchaseHeader."Pay-to Post Code" := recVendor."Post Code";
                            recPurchaseHeader."Pay-to County" := recVendor.County;
                            recPurchaseHeader."Pay-to Country/Region Code" := recVendor."Country/Region Code";
                            recPurchaseHeader."Pay-to IC Partner Code" := recVendor."IC Partner Code";
                            recPurchaseHeader."Pay-to Contact No." := recVendor.Contact;
                        END;
                        recPurchaseHeader.MODIFY(TRUE);

                        recPurchaseLine.RESET;
                        recPurchaseLine.SETRANGE(recPurchaseLine."Document Type", recPurchaseHeader."Document Type");
                        recPurchaseLine.SETRANGE(recPurchaseLine."Document No.", recPurchaseHeader."No.");
                        IF recPurchaseLine.FINDFIRST THEN
                            REPEAT
                                recPurchaseLine."Buy-from Vendor No." := recVendor."No.";
                                recPurchaseLine."Pay-to Vendor No." := recVendor."No.";
                                recPurchaseLine.MODIFY(TRUE);
                            UNTIL recPurchaseLine.NEXT = 0;
                    END;
                    MESSAGE('Done');
                END ELSE
                    ERROR('Please select Order No. and Change to');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(ChangeVendor)
                {
                    Caption = 'Change Vendor';
                    field(OrderNo; OrderNo)
                    {
                        Caption = 'Order No';
                        TableRelation = "Purchase Header"."No.";
                        ApplicationArea = all;

                        trigger OnValidate()
                        var
                            recPurchaseHdr: Record "Purchase Header";
                        begin
                            IF OrderNo <> '' THEN BEGIN
                                recPurchaseHdr.RESET;
                                recPurchaseHdr.SETRANGE(recPurchaseHdr."Document Type", recPurchaseHdr."Document Type"::Order);
                                recPurchaseHdr.SETRANGE(recPurchaseHdr."No.", OrderNo);
                                IF recPurchaseHdr.FINDFIRST THEN BEGIN
                                    FromVendor := recPurchaseHdr."Buy-from Vendor No.";
                                    VendorName := recPurchaseHdr."Buy-from Vendor Name";
                                END;
                            END;
                        end;
                    }
                    field(FromVendor; FromVendor)
                    {
                        Caption = 'From Vendor';
                        Editable = false;
                        ApplicationArea = all;
                    }
                    field(VendorName; VendorName)
                    {
                        Caption = 'Vendor Name';
                        Editable = false;
                        ApplicationArea = all;
                    }
                    field(ToVendor; ToVendor)
                    {
                        Caption = 'To Vendor';
                        TableRelation = Vendor."No.";
                        ApplicationArea = all;
                    }
                    field(ChangeBuyFrom; ChangeBuyFrom)
                    {
                        Caption = 'Change Buy From';
                        ApplicationArea = all;
                    }
                    field(ChangePayTo; ChangePayTo)
                    {
                        Caption = 'Change Pay To';
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            ChangeBuyFrom := TRUE;
            ChangePayTo := TRUE;
        end;
    }

    labels
    {
    }

    var
        recPurchaseHeader: Record "Purchase Header";
        recPurchaseLine: Record "Purchase Line";
        recVendor: Record Vendor;
        FromVendor: Code[20];
        VendorName: Text[100];
        ToVendor: Code[20];
        OrderNo: Code[20];
        ChangeBuyFrom: Boolean;
        ChangePayTo: Boolean;
        Text001: Label 'Please check your document\Order %1\Line No. %2\ Item No. %3\Qty Receved not Invoiced %4';
}

