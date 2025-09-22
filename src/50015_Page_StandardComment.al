page 50015 "Standard Comment"
{
    PageType = List;
    SourceTable = "Standard Comment";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Product Code"; Rec."Product Code")
                {
                    ApplicationArea = All;
                }
                field("Sales Type"; Rec."Sales Type")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if (Rec."Sales Type" = 0) or (Rec."Sales Type" = Rec."Sales Type"::"All Customer") then
                            blSalesType := false
                        else
                            blSalesType := true;
                    end;
                }
                field("Sales Code"; Rec."Sales Code")
                {
                    ApplicationArea = All;
                    Editable = blSalesType;
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                }
                field(Internal; Rec.Internal)
                {
                    ApplicationArea = All;
                }
                field(External; Rec.External)
                {
                    ApplicationArea = All;
                }
                field("Comment 2"; Rec."Comment 2")
                {
                    ApplicationArea = All;
                }
                field(External2; Rec.External2)
                {
                    ApplicationArea = All;
                }
                field("Comment 3"; Rec."Comment 3")
                {
                    ApplicationArea = All;
                }
                field(External3; Rec.External3)
                {
                    ApplicationArea = All;
                }
                field("Comment 4"; Rec."Comment 4")
                {
                    ApplicationArea = All;
                }
                field(External4; Rec.External4)
                {
                    ApplicationArea = All;
                }
                field("Comment 5"; Rec."Comment 5")
                {
                    ApplicationArea = All;
                }
                field(External5; Rec.External5)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Move)
            {
                Caption = 'Migrate';
                ApplicationArea = All;
                trigger OnAction()
                var
                    UPGStdCmt: Record "UPG Standard Comment";
                    StdComts: Record "Standard Comment";
                begin
                    StdComts.Reset();
                    if StdComts.FindSet() then begin
                        repeat
                            UPGStdCmt.Init();
                            UPGStdCmt.TransferFields(StdComts);
                            UPGStdCmt.Insert();
                        until StdComts.Next() = 0;
                    end else begin
                        UPGStdCmt.Reset();
                        if UPGStdCmt.FindSet() then
                            repeat
                                StdComts.Init();
                                StdComts.TransferFields(UPGStdCmt);
                                StdComts.Insert();
                            until UPGStdCmt.Next() = 0;
                    end;
                    CurrPage.Update();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if (Rec."Sales Type" = 0) or (Rec."Sales Type" = Rec."Sales Type"::"All Customer") then
            blSalesType := false
        else
            blSalesType := true;
    end;

    trigger OnOpenPage()
    begin
        if (Rec."Sales Type" = 0) or (Rec."Sales Type" = Rec."Sales Type"::"All Customer") then
            blSalesType := false
        else
            blSalesType := true;
    end;

    var
        blSalesType: Boolean;
}

