page 50007 "Comment sales New"
{
    PageType = List;
    SourceTable = "Sales Comment New";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = all;
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        //OrderNo :=GETFILTER("No.");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine;
    end;

    trigger OnOpenPage()
    begin
        Rec.Reset;
        Rec.DeleteAll;
        //IF GETFILTER("No.") = '' THEN
        //EXIT;

        if recSalesHeader.Get(recSalesHeader."Document Type"::Order, OrderNo) then;
        //IF recSalesHeader.GET(recSalesHeader."Document Type"::Order,"No.") THEN;

        for intLineCount := 1 to 50 do begin
            txtComment[intLineCount] := '';
        end;
        intLineCount := 0;
        txtProductGroup := '';
        recSalesLine.Reset;
        recSalesLine.SetCurrentKey("Document Type", "Document No.", "Item Category Code");
        recSalesLine.SetRange("Document Type", recSalesHeader."Document Type");
        recSalesLine.SetRange("Document No.", recSalesHeader."No.");
        if recSalesLine.Find('-') then begin
            //txtProductGroup:=recSalesLine."Product Group Code";
            repeat
                if recSalesLine.Quantity - recSalesLine."Quantity Shipped" > 0 then
                    if (txtProductGroup <> recSalesLine."Item Category Code") and (recSalesLine."Item Category Code" <> '') then begin
                        recStandardComment.Reset;
                        recStandardComment.SetRange("Product Code", recSalesLine."Item Category Code");
                        recStandardComment.SetFilter(recStandardComment."From Date", '%1|<%2', 0D, recSalesHeader."Posting Date");
                        recStandardComment.SetRange(recStandardComment."Sales Type", recStandardComment."Sales Type"::Customer);
                        recStandardComment.SetRange(recStandardComment."Sales Code", recSalesHeader."Sell-to Customer No.");
                        if recStandardComment.Find('-') then begin
                            if recStandardComment.Comment <> '' then begin
                                intLineCount := intLineCount + 10000;
                                Rec.Init;
                                Rec."Document Type" := recSalesHeader."Document Type".AsInteger();
                                Rec."No." := recSalesHeader."No.";
                                Rec."Document Line No." := recSalesLine."Line No.";
                                Rec."Line No." := intLineCount;
                                Rec.Date := WorkDate;
                                Rec.Code := 'Txt' + Format(intLineCount);
                                Rec.Comment := recStandardComment.Comment;
                                Rec.Insert;
                                // txtComment[intLineCount]:=recStandardComment.Comment;//+' '+recStandardComment."Comment 2";
                            end;
                            if recStandardComment."Comment 2" <> '' then begin
                                intLineCount := intLineCount + 10000;
                                Rec.Init;
                                Rec."Document Type" := recSalesHeader."Document Type".AsInteger();
                                Rec."No." := recSalesHeader."No.";
                                Rec."Document Line No." := recSalesLine."Line No.";
                                Rec."Line No." := intLineCount;
                                Rec.Date := WorkDate;
                                Rec.Code := 'Txt' + Format(intLineCount);
                                Rec.Comment := recStandardComment."Comment 2";
                                Rec.Insert;
                                //txtComment[intLineCount]:=recStandardComment."Comment 2";//+' '+recStandardComment."Comment 2";
                            end;
                            if recStandardComment."Comment 3" <> '' then begin
                                intLineCount := intLineCount + 10000;
                                Rec.Init;
                                Rec."Document Type" := recSalesHeader."Document Type".AsInteger();
                                Rec."No." := recSalesHeader."No.";
                                Rec."Document Line No." := recSalesLine."Line No.";
                                Rec."Line No." := intLineCount;
                                Rec.Date := WorkDate;
                                Rec.Code := 'Txt' + Format(intLineCount);
                                Rec.Comment := recStandardComment."Comment 3";
                                Rec.Insert;
                                //txtComment[intLineCount]:=recStandardComment."Comment 3";//+' '+recStandardComment."Comment 2";
                            end;
                            if recStandardComment."Comment 4" <> '' then begin
                                intLineCount := intLineCount + 10000;
                                Rec.Init;
                                Rec."Document Type" := recSalesHeader."Document Type".AsInteger();
                                Rec."No." := recSalesHeader."No.";
                                Rec."Document Line No." := recSalesLine."Line No.";
                                Rec."Line No." := intLineCount;
                                Rec.Date := WorkDate;
                                Rec.Code := 'Txt' + Format(intLineCount);
                                Rec.Comment := recStandardComment."Comment 4";
                                Rec.Insert;
                                //txtComment[intLineCount]:=recStandardComment."Comment 4";//+' '+recStandardComment."Comment 2";
                            end;
                            if recStandardComment."Comment 5" <> '' then begin
                                intLineCount := intLineCount + 10000;
                                Rec.Init;
                                Rec."Document Type" := recSalesHeader."Document Type".AsInteger();
                                Rec."No." := recSalesHeader."No.";
                                Rec."Document Line No." := recSalesLine."Line No.";
                                Rec."Line No." := intLineCount;
                                Rec.Date := WorkDate;
                                Rec.Code := 'Txt' + Format(intLineCount);
                                Rec.Comment := recStandardComment."Comment 5";
                                Rec.Insert;
                                //txtComment[intLineCount]:=recStandardComment."Comment 5";//+' '+recStandardComment."Comment 2";
                            end;
                            txtProductGroup := recSalesLine."Item Category Code";
                        end else begin
                            Clear(txtComment);
                            recStandardComment.Reset;
                            recStandardComment.SetRange("Product Code", recSalesLine."Item Category Code");
                            recStandardComment.SetFilter(recStandardComment."From Date", '%1|<%2', 0D, recSalesHeader."Posting Date");
                            recStandardComment.SetRange(recStandardComment."Sales Type", recStandardComment."Sales Type"::"All Customer");
                            //recStandardComment.SETRANGE(recStandardComment."Sales Code","Sell-to Customer No.");
                            if recStandardComment.Find('-') then begin
                                if recStandardComment.Comment <> '' then begin
                                    intLineCount := intLineCount + 10000;
                                    Rec.Init;
                                    Rec."Document Type" := recSalesHeader."Document Type".AsInteger();
                                    Rec."No." := recSalesHeader."No.";
                                    Rec."Document Line No." := recSalesLine."Line No.";
                                    Rec."Line No." := intLineCount;
                                    Rec.Date := WorkDate;
                                    Rec.Code := 'Txt' + Format(intLineCount);
                                    Rec.Comment := recStandardComment.Comment;
                                    Rec.Insert;
                                    //txtComment[intLineCount]:=recStandardComment.Comment;//+' '+recStandardComment."Comment 2";
                                end;
                                if recStandardComment."Comment 2" <> '' then begin
                                    intLineCount := intLineCount + 10000;
                                    Rec.Init;
                                    Rec."Document Type" := recSalesHeader."Document Type".AsInteger();
                                    Rec."No." := recSalesHeader."No.";
                                    Rec."Document Line No." := recSalesLine."Line No.";
                                    Rec."Line No." := intLineCount;
                                    Rec.Date := WorkDate;
                                    Rec.Code := 'Txt' + Format(intLineCount);
                                    Rec.Comment := recStandardComment."Comment 2";
                                    Rec.Insert;
                                    //txtComment[intLineCount]:=recStandardComment."Comment 2";//+' '+recStandardComment."Comment 2";
                                end;
                                if recStandardComment."Comment 3" <> '' then begin
                                    intLineCount := intLineCount + 10000;
                                    Rec.Init;
                                    Rec."Document Type" := recSalesHeader."Document Type".AsInteger();
                                    Rec."No." := recSalesHeader."No.";
                                    Rec."Document Line No." := recSalesLine."Line No.";
                                    Rec."Line No." := intLineCount;
                                    Rec.Date := WorkDate;
                                    Rec.Code := 'Txt' + Format(intLineCount);
                                    Rec.Comment := recStandardComment."Comment 3";
                                    Rec.Insert;
                                    //txtComment[intLineCount]:=recStandardComment."Comment 3";//+' '+recStandardComment."Comment 2";
                                end;
                                if recStandardComment."Comment 4" <> '' then begin
                                    intLineCount := intLineCount + 10000;
                                    Rec.Init;
                                    Rec."Document Type" := recSalesHeader."Document Type".AsInteger();
                                    Rec."No." := recSalesHeader."No.";
                                    Rec."Document Line No." := recSalesLine."Line No.";
                                    Rec."Line No." := intLineCount;
                                    Rec.Date := WorkDate;
                                    Rec.Code := 'Txt' + Format(intLineCount);
                                    Rec.Comment := recStandardComment."Comment 4";
                                    Rec.Insert;
                                    //txtComment[intLineCount]:=recStandardComment."Comment 4";//+' '+recStandardComment."Comment 2";
                                end;
                                if recStandardComment."Comment 5" <> '' then begin
                                    intLineCount := intLineCount + 10000;
                                    Rec.Init;
                                    Rec."Document Type" := recSalesHeader."Document Type".AsInteger();
                                    Rec."No." := recSalesHeader."No.";
                                    Rec."Document Line No." := recSalesLine."Line No.";
                                    Rec."Line No." := intLineCount;
                                    Rec.Date := WorkDate;
                                    Rec.Code := 'Txt' + Format(intLineCount);
                                    Rec.Comment := recStandardComment."Comment 5";
                                    Rec.Insert;
                                    //txtComment[intLineCount]:=recStandardComment."Comment 5";//+' '+recStandardComment."Comment 2";
                                end;
                                txtProductGroup := recSalesLine."Item Category Code";
                            end else begin
                                recStandardComment.Reset;
                                recStandardComment.SetRange("Product Code", recSalesLine."Item Category Code");
                                recStandardComment.SetFilter(recStandardComment."From Date", '%1|<%2', 0D, recSalesHeader."Posting Date");
                                recStandardComment.SetRange(recStandardComment."Sales Type", recStandardComment."Sales Type"::"Customer Price Group");
                                recStandardComment.SetRange(recStandardComment."Sales Code", recSalesHeader."Customer Price Group");
                                if recStandardComment.Find('-') then begin
                                    if recStandardComment.Comment <> '' then begin
                                        intLineCount := intLineCount + 10000;
                                        Rec.Init;
                                        Rec."Document Type" := recSalesHeader."Document Type".AsInteger();
                                        Rec."No." := recSalesHeader."No.";
                                        Rec."Document Line No." := recSalesLine."Line No.";
                                        Rec."Line No." := intLineCount;
                                        Rec.Date := WorkDate;
                                        Rec.Code := 'Txt' + Format(intLineCount);
                                        Rec.Comment := recStandardComment.Comment;
                                        Rec.Insert;
                                        //txtComment[intLineCount]:=recStandardComment.Comment;//+' '+recStandardComment."Comment 2";
                                    end;
                                    if recStandardComment."Comment 2" <> '' then begin
                                        intLineCount := intLineCount + 10000;
                                        Rec.Init;
                                        Rec."Document Type" := recSalesHeader."Document Type".AsInteger();
                                        Rec."No." := recSalesHeader."No.";
                                        Rec."Document Line No." := recSalesLine."Line No.";
                                        Rec."Line No." := intLineCount;
                                        Rec.Date := WorkDate;
                                        Rec.Code := 'Txt' + Format(intLineCount);
                                        Rec.Comment := recStandardComment."Comment 2";
                                        Rec.Insert;
                                        //txtComment[intLineCount]:=recStandardComment."Comment 2";//+' '+recStandardComment."Comment 2";
                                    end;
                                    if recStandardComment."Comment 3" <> '' then begin
                                        intLineCount := intLineCount + 10000;
                                        Rec.Init;
                                        Rec."Document Type" := recSalesHeader."Document Type".AsInteger();
                                        Rec."No." := recSalesHeader."No.";
                                        Rec."Document Line No." := recSalesLine."Line No.";
                                        Rec."Line No." := intLineCount;
                                        Rec.Date := WorkDate;
                                        Rec.Code := 'Txt' + Format(intLineCount);
                                        Rec.Comment := recStandardComment."Comment 3";
                                        Rec.Insert;
                                        //txtComment[intLineCount]:=recStandardComment."Comment 3";//+' '+recStandardComment."Comment 2";
                                    end;
                                    if recStandardComment."Comment 4" <> '' then begin
                                        intLineCount := intLineCount + 10000;
                                        Rec.Init;
                                        Rec."Document Type" := recSalesHeader."Document Type".AsInteger();
                                        Rec."No." := recSalesHeader."No.";
                                        Rec."Document Line No." := recSalesLine."Line No.";
                                        Rec."Line No." := intLineCount;
                                        Rec.Date := WorkDate;
                                        Rec.Code := 'Txt' + Format(intLineCount);
                                        Rec.Comment := recStandardComment."Comment 4";
                                        Rec.Insert;
                                        //txtComment[intLineCount]:=recStandardComment."Comment 4";//+' '+recStandardComment."Comment 2";
                                    end;
                                    if recStandardComment."Comment 5" <> '' then begin
                                        intLineCount := intLineCount + 10000;
                                        Rec.Init;
                                        Rec."Document Type" := recSalesHeader."Document Type".AsInteger();
                                        Rec."No." := recSalesHeader."No.";
                                        Rec."Document Line No." := recSalesLine."Line No.";
                                        Rec."Line No." := intLineCount;
                                        Rec.Date := WorkDate;
                                        Rec.Code := 'Txt' + Format(intLineCount);
                                        Rec.Comment := recStandardComment."Comment 5";
                                        Rec.Insert;
                                        //txtComment[intLineCount]:=recStandardComment."Comment 5";//+' '+recStandardComment."Comment 2";
                                    end;
                                    txtProductGroup := recSalesLine."Item Category Code";
                                end;
                            end;
                        end;
                    end;
            until recSalesLine.Next = 0;
        end;
        recStandardComment.Reset;
        recStandardComment.SetFilter("Product Code", '');
        recStandardComment.SetFilter(recStandardComment."From Date", '%1|<%2', 0D, recSalesHeader."Posting Date");
        recStandardComment.SetRange(recStandardComment."Sales Type", recStandardComment."Sales Type"::Customer);
        recStandardComment.SetRange(recStandardComment."Sales Code", recSalesHeader."Sell-to Customer No.");
        if recStandardComment.Find('-') then begin
            if recStandardComment.Comment <> '' then begin
                intLineCount := intLineCount + 10000;
                Rec.Init;
                Rec."Document Type" := recSalesHeader."Document Type".AsInteger();
                Rec."No." := recSalesHeader."No.";
                Rec."Document Line No." := recSalesLine."Line No.";
                Rec."Line No." := intLineCount;
                Rec.Date := WorkDate;
                Rec.Code := 'Txt' + Format(intLineCount);
                Rec.Comment := recStandardComment.Comment;
                Rec.Insert;
                //txtComment[intLineCount]:=recStandardComment.Comment;//+' '+recStandardComment."Comment 2";
            end;
            if recStandardComment."Comment 2" <> '' then begin
                intLineCount := intLineCount + 10000;
                Rec.Init;
                Rec."Document Type" := recSalesHeader."Document Type".AsInteger();
                Rec."No." := recSalesHeader."No.";
                Rec."Document Line No." := recSalesLine."Line No.";
                Rec."Line No." := intLineCount;
                Rec.Date := WorkDate;
                Rec.Code := 'Txt' + Format(intLineCount);
                Rec.Comment := recStandardComment."Comment 2";
                Rec.Insert;
                //txtComment[intLineCount]:=recStandardComment."Comment 2";//+' '+recStandardComment."Comment 2";
            end;
            if recStandardComment."Comment 3" <> '' then begin
                intLineCount := intLineCount + 10000;
                Rec.Init;
                Rec."Document Type" := recSalesHeader."Document Type".AsInteger();
                Rec."No." := recSalesHeader."No.";
                Rec."Document Line No." := recSalesLine."Line No.";
                Rec."Line No." := intLineCount;
                Rec.Date := WorkDate;
                Rec.Code := 'Txt' + Format(intLineCount);
                Rec.Comment := recStandardComment."Comment 3";
                Rec.Insert;
                //txtComment[intLineCount]:=recStandardComment."Comment 3";//+' '+recStandardComment."Comment 2";
            end;
            if recStandardComment."Comment 4" <> '' then begin
                intLineCount := intLineCount + 10000;
                Rec.Init;
                Rec."Document Type" := recSalesHeader."Document Type".AsInteger();
                Rec."No." := recSalesHeader."No.";
                Rec."Document Line No." := recSalesLine."Line No.";
                Rec."Line No." := intLineCount;
                Rec.Date := WorkDate;
                Rec.Code := 'Txt' + Format(intLineCount);
                Rec.Comment := recStandardComment."Comment 4";
                Rec.Insert;
                //txtComment[intLineCount]:=recStandardComment."Comment 4";//+' '+recStandardComment."Comment 2";
            end;
            if recStandardComment."Comment 5" <> '' then begin
                intLineCount := intLineCount + 10000;
                Rec.Init;
                Rec."Document Type" := recSalesHeader."Document Type".AsInteger();
                Rec."No." := recSalesHeader."No.";
                Rec."Document Line No." := recSalesLine."Line No.";
                Rec."Line No." := intLineCount;
                Rec.Date := WorkDate;
                Rec.Code := 'Txt' + Format(intLineCount);
                Rec.Comment := recStandardComment."Comment 5";
                Rec.Insert;
                //txtComment[intLineCount]:=recStandardComment."Comment 5";//+' '+recStandardComment."Comment 2";
            end;
        end;
    end;

    var
        intLineCount: Integer;
        txtProductGroup: Code[20];
        recStandardComment: Record "Standard Comment";
        txtComment: array[256] of Text[250];
        intCommentLine: Integer;
        recSalesHeader: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        OrderNo: Code[20];


    procedure FilterFind(DocNo: Code[20])
    begin
        OrderNo := DocNo;
    end;
}

