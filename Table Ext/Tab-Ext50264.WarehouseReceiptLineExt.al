tableextension 50264 "Warehouse Receipt Line_Ext" extends "Warehouse Receipt Line"
{
    fields
    {
        modify("Qty. to Receive")
        {
            trigger OnBeforeValidate()
            begin
                CheckSourceDocLineReceived;
                InitOutstandingQtysReceive;
            end;
        }
        field(50000; "ETA Date"; Date)
        {
        }
    }

    var
        decQty: Decimal;

    procedure CheckSourceDocLineQty()
    var
        WhseQtyOutstanding: Decimal;
        WhseRcptLine: Record "Warehouse Receipt Line";
        recPurchHeader: Record "Purchase Header";
        recPurchLine: Record "Purchase Line";
        PurchRelease: Codeunit "Release Purchase Document";
    begin

        WhseQtyOutstanding := 0;
        WhseRcptLine.SETCURRENTKEY("Source Type");
        WhseRcptLine.SETRANGE("Source Type", "Source Type");
        WhseRcptLine.SETRANGE("Source Subtype", "Source Subtype");
        WhseRcptLine.SETRANGE("Source No.", "Source No.");
        WhseRcptLine.SETRANGE("Source Line No.", "Source Line No.");
        //WhseRcptLine.CALCSUMS("Qty. Outstanding (Base)");
        IF WhseRcptLine.FIND('-') THEN
            REPEAT
                IF (WhseRcptLine."No." <> "No.") OR
                   (WhseRcptLine."Line No." <> "Line No.")
                THEN BEGIN

                    //SPDSAUQV001 BEGIN
                    WhseQtyOutstanding := WhseQtyOutstanding + WhseRcptLine."Qty. Received";
                END;
            UNTIL WhseRcptLine.NEXT = 0;
        CASE "Source Type" OF
            DATABASE::"Purchase Line":
                BEGIN
                    //SPDSAUQV001 BEGIN
                    recPurchHeader.GET("Source Subtype", "Source No.");
                    PurchRelease.Reopen(recPurchHeader);

                    recPurchLine.GET("Source Subtype", "Source No.", "Source Line No.");

                    IF ABS(recPurchLine.Quantity) < WhseQtyOutstanding + Quantity THEN BEGIN
                        // decVarianceQuantity:=SalesLine."Original Quantity"-SalesLine."Outstanding Quantity";
                        IF (recPurchLine."Original Quantity" * recPurchLine."Quantity Variance %" / 100 + recPurchLine."Original Quantity") < WhseQtyOutstanding + Quantity THEN
                            ERROR('Quantity Can not be greater Than %1', FORMAT(recPurchLine."Original Quantity" * recPurchLine."Quantity Variance %" / 100 + recPurchLine."Original Quantity"));
                        recPurchLine.VALIDATE(Quantity, WhseQtyOutstanding + Quantity);
                        recPurchLine.MODIFY;
                    END;
                    PurchRelease.RUN(recPurchHeader);
                    //SPDSAUQV001 END
                END;
        END;
    end;

    procedure InitOutstandingQtysReceive()
    begin
        "Qty. Outstanding" := "Qty. to Receive";
        decQty := CalcQty("Qty. to Receive");
        //"Qty. Outstanding (Base)" := decQty - "Qty. Received (Base)";//Fix Tarun

    end;

    procedure CheckSourceDocLineReceived()
    var
        WhseQtyOutstanding: Decimal;
        WhseRcptLine: Record "Warehouse Receipt Line";
        recPurchHeader: Record "Purchase Header";
        recPurchLine: Record "Purchase Line";
        PurchRelease: Codeunit "Release Purchase Document";
    begin

        WhseQtyOutstanding := 0;
        WhseRcptLine.SETCURRENTKEY("Source Type");
        WhseRcptLine.SETRANGE("Source Type", "Source Type");
        WhseRcptLine.SETRANGE("Source Subtype", "Source Subtype");
        WhseRcptLine.SETRANGE("Source No.", "Source No.");
        WhseRcptLine.SETRANGE("Source Line No.", "Source Line No.");
        //WhseRcptLine.CALCSUMS("Qty. Outstanding (Base)");//Change Tarun

        IF WhseRcptLine.FIND('-') THEN
            REPEAT

                //SPDSAUQV001 BEGIN
                WhseQtyOutstanding := WhseQtyOutstanding + WhseRcptLine."Qty. Received";

            UNTIL WhseRcptLine.NEXT = 0;
        CASE "Source Type" OF
            DATABASE::"Purchase Line":
                BEGIN
                    //SPDSAUQV001 BEGIN
                    recPurchHeader.GET("Source Subtype", "Source No.");
                    PurchRelease.Reopen(recPurchHeader);

                    recPurchLine.GET("Source Subtype", "Source No.", "Source Line No.");

                    IF ABS(recPurchLine.Quantity) < WhseQtyOutstanding + "Qty. to Receive" THEN BEGIN
                        // decVarianceQuantity:=SalesLine."Original Quantity"-SalesLine."Outstanding Quantity";
                        IF (recPurchLine."Original Quantity" * recPurchLine."Quantity Variance %" / 100 + recPurchLine."Original Quantity") < WhseQtyOutstanding + "Qty. to Receive" THEN
                            ERROR('Quantity Can not be greater Than %1', FORMAT(recPurchLine."Original Quantity" * recPurchLine."Quantity Variance %" / 100 + recPurchLine."Original Quantity" - WhseQtyOutstanding));
                        recPurchLine.VALIDATE(Quantity, WhseQtyOutstanding + "Qty. to Receive");
                        recPurchLine.MODIFY;
                    END;
                    IF ABS(recPurchLine."Original Quantity") >= WhseQtyOutstanding + "Qty. to Receive" THEN BEGIN
                        // decVarianceQuantity:=SalesLine."Original Quantity"-SalesLine."Outstanding Quantity";
                        recPurchLine.VALIDATE(Quantity, recPurchLine."Original Quantity");
                        recPurchLine.MODIFY;
                    END;

                    PurchRelease.RUN(recPurchHeader);
                    //SPDSAUQV001 END
                END;
        END;
    end;

    procedure CalcQty(QtyBase: Decimal): Decimal
    begin
        TESTFIELD("Qty. per Unit of Measure");
        EXIT(ROUND(QtyBase / "Qty. per Unit of Measure", 0.00001));
    end;
}
