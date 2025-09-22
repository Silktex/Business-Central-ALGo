codeunit 60003 "DO Payment Card Validation"
{

    trigger OnRun()
    begin
    end;

    var
        Text001: Label '''Invalid card type.''';
        Text002: Label '%1 must not contain spaces.';
        Text003: Label 'The specified %1 is not valid.';
        Text004: Label '%1 can only contain digits.';
        Text005: Label 'You must specify %1.';
        Text006: Label 'Validation rule does not allow spaces.';
        Text007: Label '%1 does not meet the required length.';
        Text008: Label '%1 exceeds the maximum length.';


    procedure ValidateCreditCard(CardNumber: Text[30]; CardTypeName: Text[20])
    var
        DOPaymentCardType: Record "DO Payment Card Type";
    begin
        IF NOT DOPaymentCardType.GET(CardTypeName) THEN
            ERROR(Text001);

        ValidateCreditCardType(CardNumber, DOPaymentCardType);
    end;


    procedure ValidateCreditCardType(CardNumber: Text[30]; DOPaymentCardType: Record "DO Payment Card Type")
    var
        DOPaymentCreditCard: Record "DO Payment Credit Card";
        "Integer": Integer;
        IsValid: Boolean;
        I: Integer;
    begin
        IF NOT DOPaymentCardType."Allow Spaces" THEN
            IF STRPOS(CardNumber, ' ') > 0 THEN
                ERROR(Text002, DOPaymentCreditCard.FIELDCAPTION("Credit Card Number"));

        IF DOPaymentCardType."Numeric Only" THEN
            FOR I := 1 TO STRLEN(CardNumber) DO BEGIN
                IF (COPYSTR(CardNumber, I, 1) <> ' ') AND (NOT EVALUATE(Integer, COPYSTR(CardNumber, I, 1))) THEN
                    ERROR(Text004, DOPaymentCreditCard.FIELDCAPTION("Credit Card Number"));
            END;

        IF DOPaymentCardType."Min. Length" > 0 THEN
            IF STRLEN(CardNumber) < DOPaymentCardType."Min. Length" THEN
                ERROR(Text007, DOPaymentCreditCard.FIELDCAPTION("Credit Card Number"));

        IF DOPaymentCardType."Max. Length" > 0 THEN
            IF STRLEN(CardNumber) > DOPaymentCardType."Max. Length" THEN
                ERROR(Text008, DOPaymentCreditCard.FIELDCAPTION("Credit Card Number"));

        IsValid := TRUE;
        IF DOPaymentCardType."Validation Rule" > 0 THEN
            CASE DOPaymentCardType."Validation Rule" OF
                1:
                    IsValid := IsModulus10(CardNumber);
                ELSE
                    ERROR(Text005, DOPaymentCreditCard.FIELDCAPTION(Type));
            END;

        IF NOT IsValid THEN
            ERROR(Text003, DOPaymentCreditCard.FIELDCAPTION("Credit Card Number"));
    end;


    procedure IsModulus10(CardNo: Text[30]): Boolean
    var
        I: Integer;
        IntegerValue: Integer;
        SumValue: Integer;
    begin
        WHILE STRLEN(CardNo) MOD 2 <> 0 DO
            CardNo := '0' + CardNo;

        IF STRPOS(CardNo, ' ') > 0 THEN
            ERROR(Text006);

        FOR I := 0 TO STRLEN(CardNo) - 1 DO
            IF I MOD 2 = 0 THEN BEGIN
                EVALUATE(IntegerValue, COPYSTR(CardNo, I + 1, 1));
                IF (IntegerValue * 2) > 9 THEN
                    SumValue := SumValue + (1 + ((IntegerValue * 2) MOD 10))
                ELSE
                    SumValue := SumValue + IntegerValue * 2;
            END ELSE BEGIN
                EVALUATE(IntegerValue, COPYSTR(CardNo, I + 1, 1));
                SumValue := SumValue + IntegerValue;
            END;

        IF SumValue MOD 10 <> 0 THEN
            EXIT(FALSE);

        EXIT(TRUE);
    end;
}

