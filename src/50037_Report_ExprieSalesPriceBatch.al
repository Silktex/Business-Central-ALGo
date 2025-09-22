report 50037 "Exprie Sales Price Batch"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                SalesCode := "No.";
                FutureExpirePriceDays := "Sales Price Expire Days";

                IF FutureExpirePrice = FALSE THEN BEGIN
                    recSalesPrice.RESET;
                    recSalesPrice.SETRANGE(recSalesPrice."Source No.", SalesCode);
                    IF recSalesPrice.FINDFIRST THEN BEGIN
                        REPEAT
                            recSalesPrice.Expired := FALSE;
                            recSalesPrice.MODIFY;
                        UNTIL recSalesPrice.NEXT = 0;
                    END;




                    recSalesPrice.RESET;
                    recSalesPrice.SETRANGE(recSalesPrice."Source No.", SalesCode);
                    IF recSalesPrice.FINDFIRST THEN BEGIN
                        REPEAT
                            IF (recSalesPrice."Ending Date" <> 0D) AND (recSalesPrice."Ending Date" < TODAY) THEN BEGIN
                                /*
                                int := 0;
                                SalesPrice.RESET;
                                SalesPrice.SETCURRENTKEY("Sales Type","Sales Code","Product Type","Item No.");
                                SalesPrice.ASCENDING(FALSE);
                                SalesPrice.SETRANGE("Sales Type",SalesPrice."Sales Type"::Customer);
                                SalesPrice.SETRANGE("Sales Code",SalesCode);
                                SalesPrice.SETRANGE("Product Type",recSalesPrice."Product Type"::"Product Group");
                                SalesPrice.SETRANGE("Item No.",recSalesPrice."Item No.");
                                IF SalesPrice.FINDSET THEN BEGIN
                                  REPEAT
                                    int +=1;
                                    IF (int =1) AND (SalesPrice."Ending Date" <> 0D) AND (SalesPrice."Ending Date" < TODAY) THEN BEGIN
                                       SalesPrice.Expired := TRUE;
                                       SalesPrice.MODIFY;
                                    END;
                                  UNTIL (SalesPrice.NEXT=0) OR (int=1);
                                END;

                                int := 0;
                                SalesPrice.RESET;
                                SalesPrice.SETCURRENTKEY("Sales Type","Sales Code","Product Type","Item No.");
                                SalesPrice.ASCENDING(FALSE);
                                SalesPrice.SETRANGE("Sales Type",SalesPrice."Sales Type"::Customer);
                                SalesPrice.SETRANGE("Sales Code",SalesCode);
                                SalesPrice.SETRANGE("Product Type",recSalesPrice."Product Type"::"Product Group");
                                SalesPrice.SETRANGE("Item No.",recSalesPrice."Item No.");
                                IF SalesPrice.FINDSET THEN BEGIN
                                  REPEAT
                                    int +=1;
                                    IF (int =2) AND (SalesPrice."Ending Date" <> 0D) AND (SalesPrice."Ending Date" < TODAY) AND (SalesPrice."Ending Date" = recSalesPrice."Ending Date")
                                       AND (SalesPrice."Minimum Quantity" <> 0) THEN BEGIN
                                       SalesPrice.Expired := TRUE;
                                       SalesPrice.MODIFY;
                                    END;
                                  UNTIL (SalesPrice.NEXT=0) OR (int=2);
                                END;
                                 */

                                Key1 := '';
                                Key := '';
                                PriceExpired := FALSE;
                                SalesPrice.RESET;
                                SalesPrice.SETCURRENTKEY("Source Type", "Source No.", "Asset Type", "Asset No.");
                                SalesPrice.ASCENDING(FALSE);
                                SalesPrice.SETRANGE("Source Type", SalesPrice."Source Type"::Customer);
                                SalesPrice.SETRANGE("Source No.", SalesCode);
                                SalesPrice.SETRANGE("Asset Type", recSalesPrice."Asset Type"::"Item Category");
                                SalesPrice.SETRANGE("Asset No.", recSalesPrice."Asset No.");
                                IF SalesPrice.FINDSET THEN BEGIN
                                    REPEAT
                                        IF (SalesPrice."Ending Date" <> 0D) AND (SalesPrice."Ending Date" > TODAY) THEN
                                            Key := SalesPrice."Source No." + SalesPrice."Asset No." + FORMAT(SalesPrice."Minimum Quantity");

                                        IF (PriceExpired = FALSE) AND (SalesPrice."Ending Date" <> 0D) AND (SalesPrice."Ending Date" < TODAY) THEN BEGIN
                                            Key1 := SalesPrice."Source No." + SalesPrice."Asset No." + FORMAT(SalesPrice."Minimum Quantity");
                                            IF (Key1 <> Key) THEN BEGIN
                                                SalesPrice.Expired := TRUE;
                                                PriceExpired := TRUE;
                                                SalesPrice.MODIFY;
                                            END;
                                        END;
                                    UNTIL (SalesPrice.NEXT = 0);
                                END;

                                ///For Item
                                int := 0;
                                SalesPrice.RESET;
                                SalesPrice.SETCURRENTKEY("Source Type", "Source No.", "Asset Type", "Asset No.");
                                SalesPrice.ASCENDING(FALSE);
                                SalesPrice.SETRANGE("Source Type", SalesPrice."Source Type"::Customer);
                                SalesPrice.SETRANGE("Source No.", SalesCode);
                                SalesPrice.SETRANGE("Asset Type", recSalesPrice."Asset Type"::"Item");
                                SalesPrice.SETRANGE("Asset No.", recSalesPrice."Asset No.");
                                IF SalesPrice.FINDSET THEN BEGIN
                                    REPEAT
                                        int += 1;
                                        IF (int = 1) AND (SalesPrice."Ending Date" <> 0D) AND (SalesPrice."Ending Date" < TODAY) THEN BEGIN
                                            SalesPrice.Expired := TRUE;
                                            SalesPrice.MODIFY;
                                        END;
                                    UNTIL (SalesPrice.NEXT = 0) OR (int = 1);
                                END;

                            END;
                        UNTIL recSalesPrice.NEXT = 0;
                    END;
                END ELSE BEGIN
                    IF FutureExpirePrice THEN BEGIN
                        recSalesPrice.RESET;
                        recSalesPrice.SETRANGE(recSalesPrice."Source No.", SalesCode);
                        IF recSalesPrice.FINDFIRST THEN BEGIN
                            REPEAT
                                recSalesPrice.Expired := FALSE;
                                recSalesPrice.MODIFY;
                            UNTIL recSalesPrice.NEXT = 0;
                        END;

                        recSalesPrice.RESET;
                        recSalesPrice.SETRANGE(recSalesPrice."Source No.", SalesCode);
                        IF recSalesPrice.FINDFIRST THEN BEGIN
                            REPEAT
                                IF (recSalesPrice."Ending Date" <> 0D) AND (recSalesPrice."Ending Date" < TODAY + FutureExpirePriceDays) THEN BEGIN
                                    int := 0;
                                    SalesPrice.RESET;
                                    SalesPrice.SETCURRENTKEY("Source Type", "Source No.", "Asset Type", "Asset No.");
                                    SalesPrice.ASCENDING(FALSE);
                                    SalesPrice.SETRANGE("Source Type", SalesPrice."Source Type"::Customer);
                                    SalesPrice.SETRANGE("Source No.", SalesCode);
                                    SalesPrice.SETRANGE("Asset Type", recSalesPrice."Asset Type"::"Item Category");
                                    SalesPrice.SETRANGE("Asset No.", recSalesPrice."Asset No.");
                                    IF SalesPrice.FINDSET THEN BEGIN
                                        REPEAT
                                            int += 1;
                                            IF (int = 1) AND (SalesPrice."Ending Date" <> 0D) AND (SalesPrice."Ending Date" < TODAY + FutureExpirePriceDays) THEN BEGIN
                                                SalesPrice.Expired := TRUE;
                                                SalesPrice.MODIFY;
                                            END;
                                        UNTIL (SalesPrice.NEXT = 0) OR (int = 1);
                                    END;

                                    int := 0;
                                    SalesPrice.RESET;
                                    SalesPrice.SETCURRENTKEY("Source Type", "Source No.", "Asset Type", "Asset No.");
                                    SalesPrice.ASCENDING(FALSE);
                                    SalesPrice.SETRANGE("Source Type", SalesPrice."Source Type"::Customer);
                                    SalesPrice.SETRANGE("Source No.", SalesCode);
                                    SalesPrice.SETRANGE("Asset Type", recSalesPrice."Asset Type"::"Item Category");
                                    SalesPrice.SETRANGE("Asset No.", recSalesPrice."Asset No.");
                                    IF SalesPrice.FINDSET THEN BEGIN
                                        REPEAT
                                            int += 1;
                                            IF (int = 2) AND (SalesPrice."Ending Date" <> 0D) AND (SalesPrice."Ending Date" < TODAY + FutureExpirePriceDays) AND (SalesPrice."Ending Date" = recSalesPrice."Ending Date")
                                               AND (SalesPrice."Minimum Quantity" <> 0) THEN BEGIN
                                                SalesPrice.Expired := TRUE;
                                                SalesPrice.MODIFY;
                                            END;
                                        UNTIL (SalesPrice.NEXT = 0) OR (int = 2);
                                    END;
                                    ///For Item
                                    int := 0;
                                    SalesPrice.RESET;
                                    SalesPrice.SETCURRENTKEY("Source Type", "Source No.", "Asset Type", "Asset No.");
                                    SalesPrice.ASCENDING(FALSE);
                                    SalesPrice.SETRANGE("Source Type", SalesPrice."Source Type"::Customer);
                                    SalesPrice.SETRANGE("Source No.", SalesCode);
                                    SalesPrice.SETRANGE("Asset Type", recSalesPrice."Asset Type"::"Item");
                                    SalesPrice.SETRANGE("Asset No.", recSalesPrice."Asset No.");
                                    IF SalesPrice.FINDSET THEN BEGIN
                                        REPEAT
                                            int += 1;
                                            IF (int = 1) AND (SalesPrice."Ending Date" <> 0D) AND (SalesPrice."Ending Date" < TODAY + FutureExpirePriceDays) THEN BEGIN
                                                SalesPrice.Expired := TRUE;
                                                SalesPrice.MODIFY;
                                            END;
                                        UNTIL (SalesPrice.NEXT = 0) OR (int = 1);
                                    END;

                                END;
                            UNTIL recSalesPrice.NEXT = 0;
                        END;
                    END;
                END;

            end;

            trigger OnPreDataItem()
            begin
                MESSAGE('Done');


                recExpirceSalesPrice.RESET;
                recExpirceSalesPrice.SETRANGE(recExpirceSalesPrice."Source Type", recExpirceSalesPrice."Source Type"::Customer);
                IF recExpirceSalesPrice.FINDSET THEN BEGIN
                    CLEAR(pageExpiredSalesPrices);
                    pageExpiredSalesPrices.SetRecFilters;
                    pageExpiredSalesPrices.SETRECORD(recExpirceSalesPrice);

                    pageExpiredSalesPrices.RUN;
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    Caption = 'Option';
                    field(SalesCode; SalesCode)
                    {
                        Caption = 'Customer No.';
                        Editable = true;
                        TableRelation = Customer;
                        Visible = false;
                        ApplicationArea = all;
                    }
                    field(FutureExpirePrice; FutureExpirePrice)
                    {
                        Caption = 'Future Expire Price';
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        recSalesPrice: Record "Price List Line";
        updated: Boolean;
        SalesCode: Code[20];
        SalesPrice: Record "Price List Line";
        int: Integer;
        FutureExpirePrice: Boolean;
        FutureExpirePriceDays: Integer;
        pageExpiredSalesPrices: Page "Expired Sales Prices";
        recExpirceSalesPrice: Record "Price List Line";
        PriceExpired: Boolean;
        MinimumQuantity: Decimal;
        "Key": Text;
        Key1: Text;


    procedure SetValue(var L_SalesCode: Code[20])
    begin
        SalesCode := L_SalesCode;
    end;
}
