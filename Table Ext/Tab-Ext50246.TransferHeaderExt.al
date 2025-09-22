tableextension 50246 "TransferHeader_Ext" extends "Transfer Header"
{
    fields
    {
        field(50001; "Sales Order No"; Code[20])
        {
            Description = 'SPD MS 050815';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = FILTER(Order));
        }
        field(50002; "Consignment No."; Text[30])
        {
        }
        field(50003; "Ship Via"; Code[20])
        {
        }
        field(50004; "Expected Receipt Days"; DateFormula)
        {

            trigger OnValidate()
            begin
                IF "Posting Date" <> 0D THEN BEGIN
                    "Expected Receipt Date" := CALCDATE("Expected Receipt Days", "Posting Date");
                END;
            end;
        }
        field(50005; "Expected Receipt Date"; Date)
        {
        }
        field(50100; "Charges Pay By"; Option)
        {
            Description = 'Handheld';
            OptionCaption = ' ,SENDER,RECEIVER';
            OptionMembers = " ",SENDER,RECEIVER;
        }
    }
    procedure CreateTransferLinesSO(var TONo: Code[20]; var Qty: Decimal; var ItemCode: Code[20]; var LineNo: Integer)
    var
        Rec5741: Record "Transfer Line";
        Rec5740: Record "Transfer Header";
    begin
        Rec5740.RESET;
        Rec5740.SETRANGE(Rec5740."No.", TONo);
        IF Rec5740.FIND('-') THEN BEGIN
            Rec5741.INIT;
            /*
            CLEAR(LineNo);
            IF Rec5741.FINDLAST = FALSE THEN
              LineNo := 10000
             ELSE
              LineNo := Rec5741."Line No." + 10000;
            */
            Rec5741."Document No." := TONo;
            Rec5741."Line No." := LineNo;
            Rec5741."Item No." := ItemCode;
            Rec5741.VALIDATE(Rec5741."Item No.");
            Rec5741.Quantity := Qty;
            Rec5741.VALIDATE(Rec5741.Quantity);
            Rec5741."Transfer-from Code" := Rec5740."Transfer-from Code";
            Rec5741.VALIDATE(Rec5741."Transfer-from Code");
            Rec5741."Transfer-to Code" := Rec5740."Transfer-to Code";
            Rec5741.VALIDATE(Rec5741."Transfer-to Code");
            Rec5741."In-Transit Code" := Rec5740."In-Transit Code";
            Rec5741.VALIDATE(Rec5741."In-Transit Code");


            Rec5741.INSERT;
        END;

    end;
}
