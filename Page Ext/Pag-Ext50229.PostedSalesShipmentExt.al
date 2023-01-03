pageextension 50229 "Posted Sales Shipment_Ext" extends "Posted Sales Shipment"
{
    layout
    {
        addafter("Responsibility Center")
        {
            field("Project Name"; Rec."Project Name")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter(PrintCertificateofSupply)
        {
            action("Tracking No")
            {
                ApplicationArea = all;

                trigger OnAction()
                var
                    TrackingNo: Record "Tracking No.";
                begin
                    TrackingNo.Reset;
                    TrackingNo.SetRange(TrackingNo."Source Document No.", Rec."Order No.");
                    if TrackingNo.FindFirst then
                        PAGE.Run(PAGE::"Tracking No", TrackingNo);
                end;
            }
            //NOP Functionality removed
            // action(SyncNOPSS)
            // {
            //     Caption = 'Sync NOP Sales Shipment';
            //     Image = Stop;
            //     Promoted = true;
            //     ApplicationArea = all;

            //     trigger OnAction()
            //     begin
            //         ///NOP Commerce BEGIN
            //         recCompInfo.Get();
            //         if recCompInfo."NOP Sync URL Activate" then begin
            //             if IsClear(Xmlhttp) then
            //                 Result := Create(Xmlhttp, true, true);
            //             txtURL := recCompInfo."NOP Sync URL" + 'api/syncsingleshipment/' + Rec."Order No.";
            //             //txtURL :='http://182.74.91.210:97/api/syncsingleshipment/'+Rec."Order No.";
            //             Xmlhttp.open('GET', txtURL, false);
            //             Xmlhttp.send('');
            //             Message('%1', Xmlhttp.responseText);
            //         end;
            //         ///NOP Commerce END
            //     end;
            // }
        }
        addafter("Update Document")
        {
            action(PackingSlip)
            {
                Caption = 'Packing Slip';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;

                trigger OnAction()
                var
                    recSalesHeader: Record "Sales Header";
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    REPORT.Run(50081, true, false, Rec);
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec."Tracking No." := '';
        recPWSL.RESET;
        recPWSL.SETRANGE("Posted Source Document", recPWSL."Posted Source Document"::"Posted Shipment");
        recPWSL.SETRANGE("Posted Source No.", Rec."No.");
        IF recPWSL.FIND('-') THEN
            recTrackingNo.RESET;
        recTrackingNo.SETRANGE(recTrackingNo."Warehouse Shipment No", recPWSL."Whse. Shipment No.");
        IF recTrackingNo.FIND('-') THEN
            Rec."Tracking No." := recTrackingNo."Tracking No.";
    end;

    trigger OnAfterGetRecord()
    BEGIN
        Rec."Tracking No." := '';
        recPWSL.RESET;
        recPWSL.SETRANGE("Posted Source Document", recPWSL."Posted Source Document"::"Posted Shipment");
        recPWSL.SETRANGE("Posted Source No.", Rec."No.");
        IF recPWSL.FIND('-') THEN
            recTrackingNo.RESET;
        recTrackingNo.SETRANGE(recTrackingNo."Warehouse Shipment No", recPWSL."Whse. Shipment No.");
        IF recTrackingNo.FIND('-') THEN
            Rec."Tracking No." := recTrackingNo."Tracking No.";
    END;

    var
        recPWSL: Record "Posted Whse. Shipment Line";
        recTrackingNo: Record "Tracking No.";
        // Xmlhttp: Automation;
        Result: Boolean;
        txtURL: Text;
        recCompInfo: Record "Company Information";
}
