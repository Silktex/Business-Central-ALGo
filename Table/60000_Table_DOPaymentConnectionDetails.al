table 60000 "DO Payment Connection Details"
{
    Caption = 'DO Payment Connection Details';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; UserName; BLOB)
        {
            Caption = 'UserName';
        }
        field(3; Password; BLOB)
        {
            Caption = 'Password';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
    //EncryptionMgt: Codeunit "Encryption Management";


    procedure SetPasswordData(Value: Text[1024])
    var
        DataStream: OutStream;
        DataText: BigText;
    begin
        CLEAR(Password);
        DataText.ADDTEXT(Encrypt(Value)); //Vishal
        Password.CREATEOUTSTREAM(DataStream);
        DataText.WRITE(DataStream);
    end;


    procedure GetPasswordData() Value: Text[1024]
    var
        DataStream: InStream;
        DataText: BigText;
    begin
        Value := '';
        CALCFIELDS(Password);
        IF Password.HASVALUE THEN BEGIN
            Password.CREATEINSTREAM(DataStream);
            DataText.READ(DataStream);
            DataText.GETSUBTEXT(Value, 1);
        END;
        EXIT(Decrypt(Value)); //Vishal
    end;
}

