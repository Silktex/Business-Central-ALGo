table 60004 "DO Payment Credit Card Number"
{
    Caption = 'DO Payment Credit Card Number';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = "DO Payment Credit Card"."No.";
        }
        field(2; Data; BLOB)
        {
            Caption = 'Data';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
    //EncryptionMgt: Codeunit "Encryption Management";


    procedure SetData(Value: Text[1024])
    var
        DataStream: OutStream;
        DataText: BigText;
    begin
        CLEAR(Data);
        DataText.ADDTEXT(Encrypt(Value)); //Vishal
        Data.CREATEOUTSTREAM(DataStream);
        DataText.WRITE(DataStream);
    end;


    procedure GetData() Value: Text[1024]
    var
        DataStream: InStream;
        DataText: BigText;
    begin
        Value := '';
        CALCFIELDS(Data);
        IF Data.HASVALUE THEN BEGIN
            Data.CREATEINSTREAM(DataStream);
            DataText.READ(DataStream);
            DataText.GETSUBTEXT(Value, 1);
        END;
        EXIT(Decrypt(Value)); ///Vishal
    end;


    procedure GetDataNew(DoPaymentCreditCard: Record "DO Payment Credit Card Number") Value: Text[1024]
    var
        DataStream: InStream;
        DataText: BigText;
    begin
        Value := '';
        DoPaymentCreditCard.CALCFIELDS(Data);
        IF DoPaymentCreditCard.Data.HASVALUE THEN BEGIN
            DoPaymentCreditCard.Data.CREATEINSTREAM(DataStream);
            DataText.READ(DataStream);
            DataText.GETSUBTEXT(Value, 1);
        END;
        EXIT(Decrypt(Value)); //Vishal
    end;
}

