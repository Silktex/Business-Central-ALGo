xmlport 50022 "Transfer Order Upload"
{
    DefaultFieldsValidation = false;
    Direction = Import;
    Format = VariableText;
    Permissions = TableData "Gen. Journal Line" = rimd;
    TextEncoding = WINDOWS;

    schema
    {
        textelement(root)
        {
            tableelement("Transfer Line"; "Transfer Line")
            {
                AutoUpdate = true;
                XmlName = 'TransferLine';
                UseTemporary = true;
                textattribute(TOrderNo)
                {
                }
                textattribute(TItemNo)
                {
                }
                textattribute(TQty)
                {
                }
                textattribute(TLotNo)
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    EVALUATE(DQty, TQty);
                    TransferOrderImport;
                end;

                trigger OnAfterModifyRecord()
                begin
                    EVALUATE(DQty, TQty);
                    TransferOrderImport;
                end;
            }
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

    trigger OnPostXmlPort()
    begin
        Win.CLOSE;
        MESSAGE('Uploaded Successfully');
    end;

    trigger OnPreXmlPort()
    begin
        /*"Transfer Line".DELETEALL;
        
        recTransferlLine.RESET;
        recTransferlLine.SETRANGE(recTransferlLine."Document No.",OrderNo);
        IF recTransferlLine.FINDSET THEN
          recTransferlLine.DELETEALL;
         */
        Win.OPEN(Text001, TOrderNo);

    end;

    var
        recTransferlLine: Record "Transfer Line";
        Win: Dialog;
        LineNo: Integer;
        Text001: Label 'Transfer Order Inprogress #1######################';
        DQty: Decimal;
        TransferOrderNo: Code[20];


    procedure TransferOrderImport()
    begin
        //Import Transfer Line
        recTransferlLine.RESET;
        recTransferlLine.SETRANGE(recTransferlLine."Document No.", TOrderNo);
        recTransferlLine.SETRANGE(recTransferlLine."Item No.", TItemNo);
        IF recTransferlLine.FINDFIRST THEN BEGIN
            recTransferlLine.Quantity := recTransferlLine.Quantity + DQty;
            recTransferlLine.VALIDATE(Quantity);
            recTransferlLine.VALIDATE(recTransferlLine."Qty. to Ship", recTransferlLine.Quantity);
            CreateReservation;
            recTransferlLine.MODIFY;
        END ELSE BEGIN
            recTransferlLine.RESET;
            recTransferlLine.SETRANGE(recTransferlLine."Document No.", TOrderNo);
            IF recTransferlLine.FINDLAST THEN
                LineNo := recTransferlLine."Line No."
            ELSE
                LineNo := 0;

            Win.UPDATE(1, TOrderNo);
            recTransferlLine.INIT;
            recTransferlLine."Document No." := TOrderNo;
            recTransferlLine."Line No." := LineNo + 10000;
            IF recTransferlLine.INSERT(TRUE) THEN;
            recTransferlLine.VALIDATE(recTransferlLine."Item No.", TItemNo);
            recTransferlLine.VALIDATE(Quantity, DQty);
            recTransferlLine.VALIDATE(recTransferlLine."Qty. to Ship", recTransferlLine.Quantity);
            CreateReservation;
            recTransferlLine.MODIFY(TRUE);
        END;
    end;

    procedure CreateReservation()
    var
        recReservationEntry: Record "Reservation Entry";
    begin
        recReservationEntry.RESET;
        IF recReservationEntry.FINDLAST THEN BEGIN
            recReservationEntry.INIT;
            recReservationEntry."Entry No." := recReservationEntry."Entry No." + 1;
            recReservationEntry.Positive := FALSE;
            recReservationEntry.INSERT;
            recReservationEntry.VALIDATE("Item No.", recTransferlLine."Item No.");
            recReservationEntry.VALIDATE("Location Code", recTransferlLine."Transfer-from Code");
            recReservationEntry.VALIDATE("Quantity (Base)", -DQty);
            recReservationEntry.VALIDATE("Reservation Status", recReservationEntry."Reservation Status"::Surplus);
            recReservationEntry.VALIDATE("Creation Date", WORKDATE);
            recReservationEntry.VALIDATE("Transferred from Entry No.", 0);
            recReservationEntry.VALIDATE("Source Type", 5741);
            recReservationEntry.VALIDATE("Source Subtype", 0);
            recReservationEntry.VALIDATE("Source ID", recTransferlLine."Document No.");
            recReservationEntry.VALIDATE("Source Ref. No.", recTransferlLine."Line No.");
            recReservationEntry.VALIDATE("Shipment Date", WORKDATE);
            recReservationEntry.VALIDATE("Created By", USERID);
            recReservationEntry.VALIDATE("Qty. per Unit of Measure", recTransferlLine."Qty. per Unit of Measure");
            recReservationEntry.VALIDATE(Quantity, -DQty);
            recReservationEntry.VALIDATE("Suppressed Action Msg.", FALSE);
            recReservationEntry.VALIDATE("Planning Flexibility", recReservationEntry."Planning Flexibility"::Unlimited);
            recReservationEntry.VALIDATE("Qty. to Handle (Base)", -DQty);
            recReservationEntry.VALIDATE("Qty. to Invoice (Base)", -DQty);
            recReservationEntry.VALIDATE("Disallow Cancellation", FALSE);
            recReservationEntry.VALIDATE("Lot No.", TLotNo);
            recReservationEntry.VALIDATE(Correction, FALSE);
            recReservationEntry.VALIDATE("Item Tracking", recReservationEntry."Item Tracking"::"Lot No.");
            recReservationEntry.MODIFY;

            recReservationEntry.INIT;
            recReservationEntry."Entry No." := recReservationEntry."Entry No." + 2;
            recReservationEntry.Positive := TRUE;
            recReservationEntry.INSERT;
            recReservationEntry.VALIDATE("Item No.", recTransferlLine."Item No.");
            recReservationEntry.VALIDATE("Location Code", recTransferlLine."Transfer-to Code");
            recReservationEntry.VALIDATE("Quantity (Base)", DQty);
            recReservationEntry.VALIDATE("Reservation Status", recReservationEntry."Reservation Status"::Surplus);
            recReservationEntry.VALIDATE("Creation Date", WORKDATE);
            recReservationEntry.VALIDATE("Transferred from Entry No.", 0);
            recReservationEntry.VALIDATE("Source Type", 5741);
            recReservationEntry.VALIDATE("Source Subtype", 1);
            recReservationEntry.VALIDATE("Source ID", recTransferlLine."Document No.");
            recReservationEntry.VALIDATE("Source Ref. No.", recTransferlLine."Line No.");
            recReservationEntry.VALIDATE("Expected Receipt Date", WORKDATE);
            recReservationEntry.VALIDATE("Created By", USERID);
            recReservationEntry.VALIDATE("Qty. per Unit of Measure", recTransferlLine."Qty. per Unit of Measure");
            recReservationEntry.VALIDATE(Quantity, DQty);
            recReservationEntry.VALIDATE("Suppressed Action Msg.", FALSE);
            recReservationEntry.VALIDATE("Planning Flexibility", recReservationEntry."Planning Flexibility"::Unlimited);
            recReservationEntry.VALIDATE("Qty. to Handle (Base)", DQty);
            recReservationEntry.VALIDATE("Qty. to Invoice (Base)", DQty);
            recReservationEntry.VALIDATE("Disallow Cancellation", FALSE);
            recReservationEntry.VALIDATE("Lot No.", TLotNo);
            recReservationEntry.VALIDATE(Correction, FALSE);
            recReservationEntry.VALIDATE("Item Tracking", recReservationEntry."Item Tracking"::"Lot No.");
            recReservationEntry.MODIFY;
        END;
    end;

    procedure FNTransferOrderNo(OrderNo: Code[20])
    begin
        TransferOrderNo := OrderNo;
    end;
}

