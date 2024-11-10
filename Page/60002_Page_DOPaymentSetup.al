page 60002 "DO Payment Setup"
{
    Caption = 'Microsoft Dynamics ERP Payment Services Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "DO Payment Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Authorization Required"; Rec."Authorization Required")
                {
                    ApplicationArea = all;
                }
                field("Days Before Authoriz. Expiry"; Rec."Days Before Authoriz. Expiry")
                {
                    ApplicationArea = all;
                }
            }
            group("Additional Charges")
            {
                Caption = 'Additional Charges';
                field("Charge Type"; Rec."Charge Type")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        MCAIsEnabled := Rec."Charge Type" = Rec."Charge Type"::Percent;
                    end;
                }
                field("Charge Value"; Rec."Charge Value")
                {
                    ApplicationArea = all;
                }
                field("Max. Charge Amount (LCY)"; Rec."Max. Charge Amount (LCY)")
                {
                    Enabled = MCAIsEnabled;
                    ApplicationArea = all;
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Credit Card Nos."; Rec."Credit Card Nos.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        MCAIsEnabled := Rec."Charge Type" = Rec."Charge Type"::Percent;
    end;

    trigger OnInit()
    begin
        MCAIsEnabled := true;
    end;

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;

    var

        MCAIsEnabled: Boolean;
}

