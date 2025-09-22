pageextension 50258 "Transfer Order_Ext" extends "Transfer Order"
{
    layout
    {
        addafter("Assigned User ID")
        {
            field("Link To SO"; Rec."Sales Order No")
            {
                ApplicationArea = all;
            }
        }
        addafter(Status)
        {
            field("Consignment No."; Rec."Consignment No.")
            {
                ApplicationArea = all;
            }
            field("Ship Via"; Rec."Ship Via")
            {
                ApplicationArea = all;
            }
            field("Expected Receipt Days"; Rec."Expected Receipt Days")
            {
                ApplicationArea = all;
            }
            field("Expected Receipt Date"; Rec."Expected Receipt Date")
            {
                ApplicationArea = all;
            }
            field("Charges Pay By"; Rec."Charges Pay By")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        modify("&Print")
        {
            Visible = false;
        }
        addafter("&Print")
        {
            action("&Print1")
            {
                ApplicationArea = Location;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category8;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    DocPrint: Codeunit "Document-Print";
                    RecSalesHdr: record "sales header";
                begin
                    //SPD MS
                    TrnsHdr.Reset;
                    if TrnsHdr.Get(Rec."No.") then begin
                        if Rec."Sales Order No" <> '' then begin
                            RecSalesHdr.Reset;
                            RecSalesHdr.SetRange(RecSalesHdr."No.", Rec."Sales Order No");
                            if RecSalesHdr.Find('-') then
                                REPORT.Run(50033, true, false, RecSalesHdr);
                        end
                        else
                            DocPrint.PrintTransferHeader(Rec);
                    end;
                end;
            }
        }
        addafter("Get Bin Content")
        {
            action("Get SO Lines")
            {
                Caption = 'Get SO Lines';
                Ellipsis = true;
                Image = Sales;
                ApplicationArea = all;

                trigger OnAction()
                var
                    BinContent: Record "Bin Content";
                    GetBinContent: Report "Whse. Get Bin Content";
                begin
                    //SPD MS 050815
                    Clear(OrdNo);
                    Clear(FromLoc);
                    Clear(ToLoc);
                    Clear(InTnst);
                    OrdNo := Rec."No.";
                    Rec37.Reset;
                    Rec37.SetRange(Rec37."Document No.", Rec."Sales Order No");
                    Rec37.SetFilter(Rec37.Type, '%1', Rec37.Type::Item);
                    if Rec37.Find('-') then
                        repeat
                            Rec.CreateTransferLinesSO(OrdNo, Rec37.Quantity, Rec37."No.", Rec37."Line No.");
                        until Rec37.Next = 0;
                end;
            }
        }
    }
    var

        Rec37: Record "Sales Line";
        OrdNo: Code[20];
        FromLoc: Code[10];
        ToLoc: Code[10];
        InTnst: Code[10];
        TrnsHdr: Record "Transfer Header";
}
