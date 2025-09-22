pageextension 70005 PriceListLineReviewExt extends "Price List Line Review"
{
    layout
    {
        // Add changes to page layout here
        addafter("Unit Price")
        {
            field(VATBusPostingGrPrice; Rec."VAT Bus. Posting Gr. (Price)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the default VAT business posting group code.';
            }
            field("Special Price"; Rec."Special Price")
            {
                ApplicationArea = all;
            }
            field("Special Price Comments"; Rec."Special Price Comments")
            {
                ApplicationArea = all;
            }

            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = all;
            }
            field(txtSalesCodeDesc; txtSalesCodeDesc)
            {
                Caption = 'Sales Code Description';
                Editable = false;
                ApplicationArea = all;
            }
            field("Customer Posting Group"; Rec."Customer Posting Group")
            {
                ApplicationArea = all;
            }
            field(txtProductdes; txtProductdes)
            {
                Caption = 'Product Group Type';
                ApplicationArea = all;
            }
            field(decStandardPrice; decStandardPrice)
            {
                Caption = 'Product Group Price';
                ApplicationArea = all;
            }
            field(Discontinued; Rec.Discontinued)
            {
                ApplicationArea = all;
            }
            field("Last Modified Date"; Rec."Last Modified Date")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("Last Modified User"; Rec."Last Modified User")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field(ContinuityStartDate; ContinuityStartDate)
            {
                Caption = 'Continuity Start Date';
                ApplicationArea = all;
            }
            field(ContinuityEndDate; ContinuityEndDate)
            {
                Caption = 'Continuity End Date';
                ApplicationArea = all;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        IF Rec."Source Type" = Rec."Source Type"::"Customer Price Group" THEN BEGIN
            IF recCustPrice.GET(Rec."Source No.") THEN
                txtSalesCodeDesc := recCustPrice.Description
            ELSE
                txtSalesCodeDesc := '';

        END ELSE BEGIN
            IF Rec."Source Type" = Rec."Source Type"::Customer THEN BEGIN
                IF recCustomer.GET(Rec."Source No.") THEN
                    txtSalesCodeDesc := recCustomer.Name
                ELSE
                    txtSalesCodeDesc := '';
            END ELSE BEGIN
                IF Rec."Source Type" = Rec."Source Type"::Campaign THEN BEGIN
                    IF recCampaign.GET(Rec."Source No.") THEN
                        txtSalesCodeDesc := recCampaign.Description
                    ELSE
                        txtSalesCodeDesc := '';
                END;
            END;
        END;

        txtProductdes := '';
        decStandardPrice := 0;
        IF Rec."Source Type" = Rec."Source Type"::Customer THEN BEGIN
            recCust.GET(Rec."Source No.");
            recSalesPrice.RESET;
            recSalesPrice.SETRANGE("Source Type", recSalesPrice."Source Type"::"Customer Price Group");
            recSalesPrice.SETRANGE("Source No.", recCust."Customer Price Group");
            //recSalesPrice.SETRANGE("Asset Type",recSalesPrice."Product Type"::"Product Group");
            recSalesPrice.SETRANGE("Asset No.", Rec."Asset No.");
            recSalesPrice.SETFILTER("Starting Date", '<=%1', WORKDATE);
            recSalesPrice.SETFILTER("Ending Date", '>=%1', WORKDATE);
            IF recSalesPrice.FINDSET THEN BEGIN
                REPEAT
                    txtProductdes := recSalesPrice."Source No.";
                    decStandardPrice := recSalesPrice."Unit Price";
                UNTIL recSalesPrice.NEXT = 0;
            END;
        END;

        //A/17.04.2019/SCST000001
        ContinuityStartDate := 0D;
        ContinuityEndDate := 0D;
        IF Rec."Asset Type" = Rec."Asset Type"::Item THEN BEGIN
            ItemCrossReference.RESET;
            ItemCrossReference.SETRANGE(ItemCrossReference."Item No.", Rec."Asset No.");
            IF ItemCrossReference.FINDFIRST THEN BEGIN
                ContinuityStartDate := ItemCrossReference."Palcement Start Date";
                ContinuityEndDate := ItemCrossReference."Placement End Date";
            END;
        END;

        IF Rec."Asset Type" = Rec."Asset Type"::"Item Category" THEN BEGIN
            recItem.RESET;
            //recItem.SETRANGE("Product Group Code","Item No.");
            recItem.SETRANGE("Item Category Code", Rec."Asset No.");
            IF recItem.FINDSET THEN BEGIN
                ItemCrossReference.RESET;
                ItemCrossReference.SETRANGE("Item No.", recItem."No.");

                IF ItemCrossReference.FINDSET THEN BEGIN
                    IF (ItemCrossReference."Palcement Start Date" <> 0D) AND (ItemCrossReference."Placement End Date" <> 0D) THEN BEGIN
                        ContinuityStartDate := ItemCrossReference."Palcement Start Date";
                        ContinuityEndDate := ItemCrossReference."Placement End Date";
                    END;
                    REPEAT
                        ItemCrossReference1.RESET;
                        ItemCrossReference1.SETRANGE("Item No.", recItem."No.");
                        IF ItemCrossReference1.FINDFIRST THEN BEGIN
                            IF (ItemCrossReference1."Placement End Date" <> 0D) AND (ItemCrossReference1."Placement End Date" < ContinuityEndDate) THEN BEGIN
                                ContinuityStartDate := ItemCrossReference1."Palcement Start Date";
                                ContinuityEndDate := ItemCrossReference1."Placement End Date";
                            END;
                        END;
                    UNTIL recItem.NEXT = 0;
                END;
            END;
        END;
        //E/17.04.2019/SCST000001
    end;


    var
        txtSalesCodeDesc: Text[50];
        recCustPrice: Record "Customer Price Group";
        recCampaign: Record Campaign;
        recCustomer: Record Customer;
        recSalesPrice: Record "Price List Line";
        txtProductdes: Text[50];
        decStandardPrice: Decimal;
        recCust: Record Customer;
        Expired: Boolean;
        ContinuityStartDate: Date;
        ContinuityEndDate: Date;
        ItemCrossReference: Record "Item Reference";
        recItem: Record Item;
        RecordFound: Boolean;
        ItemCrossReference1: Record "Item Reference";


}