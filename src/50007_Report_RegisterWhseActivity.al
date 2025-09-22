report 50007 RegisterWhseActivity
{
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem(WhseActLinePut; "Warehouse Activity Line")
        {
            DataItemTableView = WHERE("HandHeld Line Created" = FILTER(false), "Activity Type" = FILTER("Put-away"), "Action Type" = FILTER(Place));

            trigger OnAfterGetRecord()
            begin
                IF WhseActHeader.GET("Activity Type", "No.") THEN BEGIN
                    recHandHeld.RESET;
                    recHandHeld.INIT;
                    recHandHeld.VALIDATE(Type, recHandHeld.Type::"Put-away");
                    recHandHeld.VALIDATE(No, "No.");
                    recHandHeld.VALIDATE("Item No", "Item No.");
                    recHandHeld.VALIDATE("Action Type", "Action Type"::Place);
                    recHandHeld.VALIDATE("Bin Code", "Bin Code");
                    recHandHeld.VALIDATE("Zone Code", "Zone Code");
                    recHandHeld.VALIDATE("Lot No", "Lot No.");
                    //recHandHeld.VALIDATE("Lot No",'LOT6420');
                    recHandHeld.VALIDATE(Quantity, WhseActLinePut.Quantity);
                    recHandHeld.VALIDATE("User Id", WhseActHeader."Assigned User ID");
                    recHandHeld.VALIDATE("Qty to Handle", 0);
                    recHandHeld.VALIDATE("Line No", "Line No.");
                    recHandHeld.VALIDATE(Description, WhseActLinePut.Description);
                    recHandHeld.VALIDATE("Location Code", "Location Code");
                    recHandHeld.Open := TRUE;
                    recHandHeld."Creation Time" := TIME;
                    recHandHeld.INSERT;
                    WhseActLinePut."HandHeld Line Created" := TRUE;
                    WhseActLinePut.MODIFY;
                END;
            end;
        }
        dataitem(WhseActLinePick; "Warehouse Activity Line")
        {
            DataItemTableView = WHERE("HandHeld Line Created" = FILTER(false), "Activity Type" = FILTER(Pick), "Action Type" = FILTER(Take));

            trigger OnAfterGetRecord()
            begin
                IF WhseActHeader.GET("Activity Type", "No.") THEN BEGIN
                    recHandHeld.RESET;
                    recHandHeld.INIT;
                    recHandHeld.VALIDATE(Type, recHandHeld.Type::Pick);
                    recHandHeld.VALIDATE(No, "No.");
                    recHandHeld.VALIDATE("Item No", "Item No.");
                    recHandHeld.VALIDATE("Action Type", "Action Type"::Take);
                    recHandHeld.VALIDATE("Bin Code", "Bin Code");
                    recHandHeld.VALIDATE("Zone Code", "Zone Code");
                    recHandHeld.VALIDATE("Lot No", "Lot No.");
                    //recHandHeld.VALIDATE("Lot No",'LOT6420');
                    recHandHeld.VALIDATE(Quantity, WhseActLinePick.Quantity);
                    recHandHeld.VALIDATE("User Id", WhseActHeader."Assigned User ID");
                    recHandHeld.VALIDATE("Qty to Handle", 0);
                    recHandHeld.VALIDATE("Line No", "Line No.");
                    recHandHeld.VALIDATE(Description, WhseActLinePick.Description);
                    recHandHeld.VALIDATE("Location Code", "Location Code");
                    recHandHeld.Open := TRUE;
                    recHandHeld."Creation Time" := TIME;
                    recHandHeld.INSERT;
                    WhseActLinePick."HandHeld Line Created" := TRUE;
                    WhseActLinePick.MODIFY;

                END;
            end;
        }
        dataitem(HandHeldPut; HandHeld)
        {
            DataItemTableView = WHERE(Type = CONST("Put-away"), "Qty to Handle" = FILTER(<> 0));

            trigger OnAfterGetRecord()
            begin

                WhseActLine1.RESET;
                WhseActLine1.SETRANGE("Activity Type", Type);
                WhseActLine1.SETRANGE("No.", No);
                WhseActLine1.SETRANGE("Hand Held Line Updated", FALSE);
                IF WhseActLine1.FIND('-') THEN
                    REPEAT
                        WhseActLine1.VALIDATE("Qty. to Handle", 0);
                        WhseActLine1.MODIFY;
                    UNTIL WhseActLine1.NEXT = 0;

                IF WhseActLine.GET(HandHeldPut.Type, HandHeldPut.No, HandHeldPut."Line No") THEN BEGIN
                    WhseActLine1.RESET;
                    WhseActLine1.SETRANGE("Activity Type", WhseActLine."Activity Type");
                    WhseActLine1.SETRANGE("Action Type", WhseActLine."Action Type"::Place);
                    WhseActLine1.SETRANGE("Line No.", WhseActLine."Line No.");
                    WhseActLine1.SETRANGE("Zone Code", "Zone Code");
                    WhseActLine1.SETRANGE("No.", WhseActLine."No.");
                    WhseActLine1.SETRANGE(WhseActLine1."Source No.", WhseActLine."Source No.");
                    WhseActLine1.SETRANGE(WhseActLine1."Source Line No.", WhseActLine."Source Line No.");
                    IF WhseActLine1.FIND('-') THEN BEGIN
                        //REPEAT
                        WhseActLine1.VALIDATE("Qty. to Handle", "Qty to Handle");
                        WhseActLine1."Hand Held User Id" := "User Id";
                        WhseActLine1."Hand Held Line Updated" := TRUE;
                        WhseActLine1.MODIFY(TRUE);
                        //UNTIL WhseActLine1.NEXT=0;
                    END;
                    WhseActLine1.RESET;
                    WhseActLine1.SETRANGE("Activity Type", WhseActLine."Activity Type");
                    WhseActLine1.SETRANGE("Action Type", WhseActLine."Action Type"::Take);
                    WhseActLine1.SETRANGE("No.", WhseActLine."No.");
                    WhseActLine1.SETRANGE("Lot No.", WhseActLine."Lot No.");
                    WhseActLine1.SETRANGE(WhseActLine1."Source No.", WhseActLine."Source No.");
                    WhseActLine1.SETRANGE(WhseActLine1."Source Line No.", WhseActLine."Source Line No.");
                    IF WhseActLine1.FIND('-') THEN BEGIN

                        //REPEAT

                        WhseActLine1.VALIDATE("Qty. to Handle", "Qty to Handle");
                        WhseActLine1.VALIDATE("Lot No.", "Lot No");
                        WhseActLine1."Hand Held User Id" := "User Id";
                        WhseActLine1."Hand Held Line Updated" := TRUE;

                        WhseActLine1.MODIFY(TRUE);
                        //UNTIL WhseActLine1.NEXT=0;
                    END;

                END;
                IF WhseActHeader.GET(Type, No) THEN BEGIN
                    WhseActHeader.Scanned := TRUE;
                    WhseActHeader.MODIFY;
                END;
                IF HandHeldPut."Qty to Handle" = HandHeldPut.Quantity THEN
                    HandHeldPut.DELETE
                //  ELSE IF HandHeldPut."Qty to Handle"-HandHeldPut.Quantity < 0 THEN
                //      HandHeldPut.DELETE
                ELSE BEGIN
                    HandHeldPut.Quantity := HandHeldPut.Quantity - HandHeldPut."Qty to Handle";
                    HandHeldPut."Qty to Handle" := 0;
                    HandHeldPut.MODIFY;
                END;
            end;

            trigger OnPreDataItem()
            begin
                IF HHUsrId <> '' THEN
                    SETRANGE("User Id", HHUsrId);
                IF PUDocNo <> '' THEN
                    SETRANGE(No, PUDocNo);
            end;
        }
        dataitem(HandHeldPick; HandHeld)
        {
            DataItemTableView = WHERE(Type = CONST(Pick), "Qty to Handle" = FILTER(<> 0));

            trigger OnAfterGetRecord()
            begin

                WhseActLine1.RESET;
                WhseActLine1.SETRANGE("Activity Type", Type);
                WhseActLine1.SETRANGE("No.", No);
                WhseActLine1.SETRANGE("Hand Held Line Updated", FALSE);
                IF WhseActLine1.FIND('-') THEN
                    REPEAT
                        WhseActLine1.VALIDATE("Qty. to Handle", 0);
                        WhseActLine1.MODIFY;
                    UNTIL WhseActLine1.NEXT = 0;

                IF WhseActLine.GET(Type, No, "Line No") THEN BEGIN
                    WhseActLine1.RESET;
                    WhseActLine1.SETRANGE("Activity Type", WhseActLine."Activity Type");
                    WhseActLine1.SETRANGE("Action Type", WhseActLine."Action Type"::Take);
                    WhseActLine1.SETRANGE("Line No.", WhseActLine."Line No.");
                    WhseActLine1.SETRANGE("Zone Code", "Zone Code");

                    WhseActLine1.SETRANGE("No.", WhseActLine."No.");
                    WhseActLine1.SETRANGE(WhseActLine1."Source No.", WhseActLine."Source No.");
                    WhseActLine1.SETRANGE(WhseActLine1."Source Line No.", WhseActLine."Source Line No.");
                    //WhseActLine1.SETRANGE(WhseActLine1."Line No.",WhseActLine."Line No."+10000);//TR
                    IF WhseActLine1.FIND('-') THEN BEGIN
                        //REPEAT
                        WhseActLine1.VALIDATE("Lot No.", "Lot No");
                        WhseActLine1.VALIDATE("Qty. to Handle", "Qty to Handle");
                        WhseActLine1."Hand Held User Id" := "User Id";
                        WhseActLine1."Hand Held Line Updated" := TRUE;
                        WhseActLine1.MODIFY(TRUE);
                        //UNTIL WhseActLine1.NEXT=0;

                    END;
                    WhseActLine1.RESET;
                    WhseActLine1.SETRANGE("Activity Type", WhseActLine."Activity Type");
                    WhseActLine1.SETRANGE("Action Type", WhseActLine."Action Type"::Place);
                    WhseActLine1.SETRANGE("No.", WhseActLine."No.");
                    //   WhseActLine1.SETRANGE("Lot No.",WhseActLine."Lot No.");
                    WhseActLine1.SETRANGE(WhseActLine1."Source No.", WhseActLine."Source No.");
                    WhseActLine1.SETRANGE(WhseActLine1."Source Line No.", WhseActLine."Source Line No.");
                    IF WhseActLine1.FIND('-') THEN BEGIN
                        //REPEAT
                        WhseActLine1.VALIDATE("Lot No.", "Lot No");
                        WhseActLine1.VALIDATE("Qty. to Handle", "Qty to Handle");
                        WhseActLine1."Hand Held User Id" := "User Id";
                        WhseActLine1."Hand Held Line Updated" := TRUE;
                        WhseActLine1.MODIFY(TRUE);
                        //UNTIL WhseActLine1.NEXT=0;

                    END;

                END;
                IF WhseActHeader.GET(Type, No) THEN BEGIN
                    WhseActHeader.Scanned := TRUE;
                    WhseActHeader.MODIFY;
                END;

                IF HandHeldPick."Qty to Handle" = HandHeldPick.Quantity THEN
                    HandHeldPick.DELETE
                ELSE
                    IF HandHeldPut."Qty to Handle" - HandHeldPut.Quantity < 0 THEN
                        HandHeldPut.DELETE
                    ELSE BEGIN
                        HandHeldPick.Quantity := HandHeldPick.Quantity - HandHeldPick."Qty to Handle";
                        HandHeldPick."Qty to Handle" := 0;
                        HandHeldPick.MODIFY;
                    END;
            end;

            trigger OnPreDataItem()
            begin
                IF HHUsrId <> '' THEN
                    SETRANGE("User Id", HHUsrId);
                IF PUDocNo <> '' THEN
                    SETRANGE(No, PUDocNo);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin

        WhseActHeader.RESET;
        IF PUDocNo <> '' THEN
            WhseActHeader.SETRANGE("No.", PUDocNo);
        WhseActHeader.SETRANGE(Scanned, TRUE);
        IF WhseActHeader.FIND('-') THEN BEGIN
            REPEAT
                RegisterWhseAct(WhseActHeader.Type.AsInteger(), WhseActHeader."No.");
            UNTIL WhseActHeader.NEXT = 0;
        END;
        WhseActHeader.RESET;
        IF PUDocNo <> '' THEN
            WhseActHeader.SETRANGE("No.", PUDocNo);
        WhseActHeader.SETRANGE(Scanned, TRUE);
        IF WhseActHeader.FIND('-') THEN BEGIN
            REPEAT
                WhseActHeader.Scanned := FALSE;
                WhseActHeader.MODIFY;
            UNTIL WhseActHeader.NEXT = 0;
        END;
    end;

    var
        WhseActLine: Record "Warehouse Activity Line";
        WhseActLine1: Record "Warehouse Activity Line";
        WhseActHeader: Record "Warehouse Activity Header";
        WhseRegisterActivityYesNo: Codeunit "Whse.-Act.-RegisterWe (Yes/No)";
        recHandHeld: Record HandHeld;
        HHUsrId: Code[50];
        PUDocNo: Code[20];


    procedure RegisterWhseAct(ActivityType: Integer; DocNo: Code[20])
    var
        recWhseActivityLine: Record "Warehouse Activity Line";
        WhseActivLine: Record "Warehouse Activity Line";
    begin

        recWhseActivityLine.RESET;
        recWhseActivityLine.SETRANGE(recWhseActivityLine."Activity Type", ActivityType);
        recWhseActivityLine.SETRANGE("No.", DocNo);
        IF HHUsrId <> '' THEN
            recWhseActivityLine.SETRANGE(recWhseActivityLine."Hand Held User Id", HHUsrId);

        recWhseActivityLine.SETRANGE(Breakbulk);
        IF recWhseActivityLine.FINDSET THEN BEGIN
            WhseActivLine.COPY(recWhseActivityLine);
            WhseRegisterActivityYesNo.HHUsrId(HHUsrId);
            WhseRegisterActivityYesNo.RUN(WhseActivLine);
        END;
    end;


    procedure GetHHUsrId(UsrId: Code[50]; DocNo: Code[20])
    begin
        HHUsrId := UsrId;
        PUDocNo := DocNo;
    end;
}

