report 50039 RegisterWhseActivity2
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
        /*
            WhseActHeader.RESET;
            IF PUDocNo <> '' THEN
              WhseActHeader.SETRANGE("No.",PUDocNo);
          WhseActHeader.SETRANGE(Scanned,TRUE);
          IF WhseActHeader.FIND('-') THEN BEGIN
            REPEAT
             RegisterWhseAct(WhseActHeader.Type,WhseActHeader."No.");
            UNTIL WhseActHeader.NEXT=0;
           END;
          WhseActHeader.RESET;
          IF PUDocNo <> '' THEN
            WhseActHeader.SETRANGE("No.",PUDocNo);
          WhseActHeader.SETRANGE(Scanned,TRUE);
          IF WhseActHeader.FIND('-') THEN BEGIN
            REPEAT
             WhseActHeader.Scanned:=FALSE;
             WhseActHeader.MODIFY;
            UNTIL WhseActHeader.NEXT=0;
           END;
        */

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

