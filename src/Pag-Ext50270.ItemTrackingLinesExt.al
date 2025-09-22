pageextension 50270 "Item Tracking Lines_Ext" extends "Item Tracking Lines"
{
    layout
    {
        addafter("Appl.-from Item Entry")
        {
            field("Quality Grade"; Rec."Quality Grade")
            {
                ApplicationArea = all;
            }
            field("Dylot No."; Rec."Dylot No.")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter(Action64)
        {
            action(PrintLabel)
            {
                Caption = 'Print Label';
                Image = NewReceipt;
                Promoted = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    //  ReportLabel: Report "Print PHP Label";
                    ILE: Record "Item Ledger Entry" temporary;
                begin
                    ReservationEntry.Reset;
                    ReservationEntry.SetRange("Source Type", Rec."Source Type");
                    ReservationEntry.SetRange("Source ID", Rec."Source ID");
                    ReservationEntry.SetRange("Source Ref. No.", Rec."Source Ref. No.");
                    ReservationEntry.SetRange(Positive, true);
                    if ReservationEntry.FindSet then begin
                        REPORT.Run(REPORT::"Item Label Print RE", true, true, ReservationEntry);
                        Message('Printed Successfully');
                    end;
                end;
            }
        }
    }
    trigger OnClosePage()
    begin
        //SPDSAUACCQTYSALE BEGIN
        CheckActualQuantityMin(TotalTrackingSpecification);
        //SPDSAUACCQTYSALE END
    end;

    var
        decUnitPrice: Decimal;
        ReservationEntry: Record "Reservation Entry";

    procedure CheckActualQuantity(recTrackingSpecification: Record "Tracking Specification")
    var
        recSalesLine: Record "Sales Line";
        recSalesHeader: Record "Sales Header";
        recTrackingSpecification1: Record "Tracking Specification";
        SalesRelease: Codeunit "Release Sales Document";
        decQuantity: Decimal;
        decLineDiscountPer: Decimal;
    begin
        decQuantity := recTrackingSpecification."Quantity (Base)";
        recSalesHeader.Reset;
        recSalesHeader.SetRange("Document Type", recSalesHeader."Document Type"::Order);
        recSalesHeader.SetRange("No.", recTrackingSpecification."Source ID");
        if recSalesHeader.Find('-') then begin

            recSalesLine.Reset;
            recSalesLine.SetRange("Document Type", recSalesLine."Document Type"::Order);
            recSalesLine.SetRange("Document No.", recTrackingSpecification."Source ID");
            recSalesLine.SetRange("Line No.", recTrackingSpecification."Source Ref. No.");
            if recSalesLine.Find('-') then begin

                if
                   (Abs(decQuantity) > (recSalesLine."Original Quantity")) then begin
                    //SalesRelease.Reopen(recSalesHeader);
                    recSalesHeader.Status := recSalesHeader.Status::Open;
                    recSalesHeader.Modify();
                    decLineDiscountPer := recSalesLine."Line Discount %";
                    recSalesLine.Validate(Quantity, Abs(decQuantity));
                    recSalesLine.Validate("Line Discount %", decLineDiscountPer);
                    recSalesLine.Modify(false);
                    recSalesHeader.Status := recSalesHeader.Status::Released;
                    recSalesHeader.Modify();
                    //SalesRelease.Run(recSalesHeader);
                    recSalesHeader.Modify(false);
                end;
            end;
        end;
    end;

    procedure CheckSalesLineQuantity(recTrackingSpecification: Record "Tracking Specification"): Decimal
    var
        recSalesLine: Record "Sales Line";
        recSalesHeader: Record "Sales Header";
        recTrackingSpecification1: Record "Tracking Specification";
        SalesRelease: Codeunit "Release Sales Document";
        decQuantity: Decimal;
    begin
        decQuantity := 0;
        recSalesHeader.Reset;
        recSalesHeader.SetRange("Document Type", recSalesHeader."Document Type"::Order);
        recSalesHeader.SetRange("No.", recTrackingSpecification."Source ID");
        if recSalesHeader.Find('-') then begin

            recSalesLine.Reset;
            recSalesLine.SetRange("Document Type", recSalesLine."Document Type"::Order);
            recSalesLine.SetRange("Document No.", recTrackingSpecification."Source ID");
            recSalesLine.SetRange("Line No.", recTrackingSpecification."Source Ref. No.");
            if recSalesLine.Find('-') then begin

                decQuantity := recSalesLine.Quantity * recSalesLine."Quantity Variance %" / 100
            end;
        end;
        exit(decQuantity);
    end;

    procedure CheckActualQuantityMin(recTrackingSpecification: Record "Tracking Specification")
    var
        recSalesLine: Record "Sales Line";
        recSalesHeader: Record "Sales Header";
        recTrackingSpecification1: Record "Tracking Specification";
        SalesRelease: Codeunit "Release Sales Document";
        decQuantity: Decimal;
        decLineDiscountPer: Decimal;
    begin
        decQuantity := recTrackingSpecification."Quantity (Base)";
        recSalesHeader.Reset;
        recSalesHeader.SetRange("Document Type", recSalesHeader."Document Type"::Order);
        recSalesHeader.SetRange("No.", recTrackingSpecification."Source ID");
        recSalesHeader.SetRange(Status, recSalesHeader.Status::Released);
        if recSalesHeader.Find('-') then begin

            recSalesLine.Reset;
            recSalesLine.SetRange("Document Type", recSalesLine."Document Type"::Order);
            recSalesLine.SetRange("Document No.", recTrackingSpecification."Source ID");
            recSalesLine.SetRange("Line No.", recTrackingSpecification."Source Ref. No.");
            //recSalesLine.SETRANGE(Status",recSalesLine.Status::Release);
            if recSalesLine.Find('-') then begin
                if Abs(decQuantity) <= (recSalesLine."Original Quantity") then begin
                    //SalesRelease.Reopen(recSalesHeader);
                    recSalesHeader.Status := recSalesHeader.Status::Open;
                    recSalesHeader.Modify();
                    recSalesLine.Validate(Quantity, Abs(recSalesLine."Original Quantity"));
                    recSalesLine.Modify(false);
                    //SalesRelease.Run(recSalesHeader);
                    recSalesHeader.Status := recSalesHeader.Status::Released;
                    //recSalesHeader.Modify();
                    recSalesHeader.Modify(false);
                end;
            end;
        end;
        recSalesHeader.Reset;
        recSalesHeader.SetRange("Document Type", recSalesHeader."Document Type"::Order);
        recSalesHeader.SetRange("No.", recTrackingSpecification."Source ID");
        recSalesHeader.SetRange(Status, recSalesHeader.Status::Open);
        if recSalesHeader.Find('-') then begin

            recSalesLine.Reset;
            recSalesLine.SetRange("Document Type", recSalesLine."Document Type"::Order);
            recSalesLine.SetRange("Document No.", recTrackingSpecification."Source ID");
            recSalesLine.SetRange("Line No.", recTrackingSpecification."Source Ref. No.");
            //recSalesLine.SETRANGE("Status",recSalesLine.Status::Open);
            if recSalesLine.Find('-') then begin
                if Abs(decQuantity) <= (recSalesLine."Original Quantity") then begin
                    //SalesRelease.Reopen(recSalesHeader);
                    decLineDiscountPer := recSalesLine."Line Discount %";
                    recSalesLine.Validate(Quantity, Abs(recSalesLine."Original Quantity"));
                    recSalesLine.Validate("Line Discount %", decLineDiscountPer);
                    recSalesLine.Modify(false);
                    //SalesRelease.RUN(recSalesHeader);
                    //recSalesHeader.MODIFY(FALSE);

                end;

            end;
        end;
    end;

    procedure CheckActualUnitPrice(recTrackingSpecification: Record "Tracking Specification")
    var
        recSalesLine: Record "Sales Line";
        recSalesHeader: Record "Sales Header";
        recTrackingSpecification1: Record "Tracking Specification";
        SalesRelease: Codeunit "Release Sales Document";
        decQuantity: Decimal;
    begin
        decUnitPrice := 0;
        recSalesHeader.Reset;
        recSalesHeader.SetRange("Document Type", recSalesHeader."Document Type"::Order);
        recSalesHeader.SetRange("No.", recTrackingSpecification."Source ID");
        if recSalesHeader.Find('-') then begin

            recSalesLine.Reset;
            recSalesLine.SetRange("Document Type", recSalesLine."Document Type"::Order);
            recSalesLine.SetRange("Document No.", recTrackingSpecification."Source ID");
            recSalesLine.SetRange("Line No.", recTrackingSpecification."Source Ref. No.");
            if recSalesLine.Find('-') then begin
                decUnitPrice := recSalesLine."Unit Price";
            end;
        end;
    end;

    procedure UpdateActualUnitPrice(recTrackingSpecification: Record "Tracking Specification")
    var
        recSalesLine: Record "Sales Line";
        recSalesHeader: Record "Sales Header";
        recTrackingSpecification1: Record "Tracking Specification";
        SalesRelease: Codeunit "Release Sales Document";
        decQuantity: Decimal;
    begin
        recSalesHeader.Reset;
        recSalesHeader.SetRange("Document Type", recSalesHeader."Document Type"::Order);
        recSalesHeader.SetRange("No.", recTrackingSpecification."Source ID");
        if recSalesHeader.Find('-') then begin

            recSalesLine.Reset;
            recSalesLine.SetRange("Document Type", recSalesLine."Document Type"::Order);
            recSalesLine.SetRange("Document No.", recTrackingSpecification."Source ID");
            recSalesLine.SetRange("Line No.", recTrackingSpecification."Source Ref. No.");
            if recSalesLine.Find('-') then begin
                if recSalesHeader.Status = recSalesHeader.Status::Released then begin
                    //SalesRelease.Reopen(recSalesHeader);
                    recSalesHeader.Status := recSalesHeader.Status::Open;
                    recSalesHeader.Modify();
                    recSalesLine."Unit Price" := decUnitPrice;
                    recSalesLine.Modify;
                    recSalesHeader.Status := recSalesHeader.Status::Released;
                    recSalesHeader.Modify();
                    //SalesRelease.Run(recSalesHeader);
                end;
            end;
        end;
    end;

}
