page 60003 "DO Payment Credit Card"
{
    Caption = 'Credit Card';
    PageType = Card;
    SourceTable = "DO Payment Credit Card";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Card Holder Name"; Rec."Card Holder Name")
                {
                    ApplicationArea = all;
                }
                field(creditCardNumber; creditCardNumber)
                {
                    Caption = 'Number';
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        //Rec.UpdateCardType(creditCardNumber);
                        Rec.SetCreditCardNumber(creditCardNumber);
                        creditCardNumber := Rec."Credit Card Number"
                    end;
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    Caption = 'Expiry Date (MMYY)';
                    ApplicationArea = all;
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = all;
                }
                field("Cvc No."; Rec."Cvc No.")
                {
                    Caption = 'CVV No.';
                    ApplicationArea = all;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        creditCardNumber := Rec."Credit Card Number";
                    end;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
                ApplicationArea = all;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Credit Card")
            {
                Caption = '&Credit Card';
                Image = CreditCard;
                action("Transaction Log E&ntries")
                {
                    Caption = 'Transaction Log E&ntries';
                    Image = Log;
                    RunObject = Page "DO Payment Trans. Log Entries";
                    RunPageLink = "Credit Card No." = FIELD("No.");
                    ShortCutKey = 'Ctrl+F7';
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        creditCardNumber := Rec."Credit Card Number";
    end;

    var
        creditCardNumber: Text[30];
        DOPaymentCardValidation: Codeunit "DO Payment Card Validation";


    procedure UpdateCardType(CardNumber: Text[30])
    var
        intCardValue: array[8] of Integer;
        I: Integer;
        txtCardValue: array[8] of Text[10];
        intCardValue8: Integer;
        intCardValue4: Integer;
    begin
        for I := 1 to 8 do begin
            Evaluate(intCardValue[I], CopyStr(CardNumber, I, 1));
            //ERROR(Text004,DOPaymentCreditCard.FIELDCAPTION("Credit Card Number"));
            txtCardValue[I] := Format(intCardValue[I]);
        end;
        Evaluate(intCardValue8, CopyStr(CardNumber, 1, 8));
        Evaluate(intCardValue4, CopyStr(CardNumber, 1, 4));
        if (intCardValue[1] = 3) and ((intCardValue[2] = 4) or (intCardValue[2] = 7)) then
            Rec.Validate(Type, 'AMERICAN EXPRESS')
        else
            if (intCardValue[1] = 5) and ((intCardValue[2] >= 1) and (intCardValue[2] <= 5)) then
                Rec.Validate(Type, 'MASTER CARD')
            else
                if intCardValue[1] = 4 then
                    Rec.Validate(Type, 'VISA')
                else
                    if ((intCardValue8 >= 60110000) and (intCardValue8 <= 60119999)) or ((intCardValue8 >= 65000000) and (intCardValue8 <= 65999999)) or ((intCardValue8 >= 62212600) and (intCardValue8 <= 62292599)) then
                        Rec.Validate(Type, 'DISCOVER')
                    else
                        if (intCardValue4 = 2014) or (intCardValue4 = 2149) then
                            Rec.Validate(Type, 'ENROUTE')
                        else
                            if ((intCardValue4 = 3088) or (intCardValue4 = 3096) or (intCardValue4 = 3112) or (intCardValue4 = 3158) or (intCardValue4 = 3337)) or ((intCardValue8 >= 35280000) and (intCardValue8 <= 35899999)) then
                                Rec.Validate(Type, 'JCB')
                            else
                                if (intCardValue[1] = 3) and ((intCardValue[2] = 0) or (intCardValue[2] = 6) or (intCardValue[2] = 8)) then
                                    Rec.Validate(Type, 'DINERS CLUB');
    end;
}

