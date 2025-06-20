pageextension 50215 "Sales Quote_Ext" extends "Sales Quote"
{
    layout
    {
        addafter(Status)
        {
            field(ExternalDocumentNo; Rec."External Document No.")
            {
                ApplicationArea = all;
            }
            field("Expiry Date"; Rec."Expiry Date")
            {
                ApplicationArea = all;
            }
            field("Proj Owner 1"; Rec."Proj Owner 1")
            {
                ApplicationArea = all;
            }
            field("Proj Owner 2"; Rec."Proj Owner 2")
            {
                ApplicationArea = all;
            }
            field("Project Name"; Rec."Project Name")
            {
                ApplicationArea = all;
            }
            field("Project Type"; Rec."Project Type")
            {
                ApplicationArea = All;
            }
            field("Project Phase"; Rec."Project Phase")
            {
                ApplicationArea = All;
            }
            field("Project Description"; Rec."Project Description")
            {
                ApplicationArea = All;
                MultiLine = true;
            }
            field("Project Location"; Rec."Project Location")
            {
                ApplicationArea = all;
            }
            field("Project City"; Rec."Project City")
            {
                ApplicationArea = All;
            }
            field("Project Size"; Rec."Project Size")
            {
                ApplicationArea = All;
            }
            field("Project Budget"; Rec."Project Budget")
            {
                ApplicationArea = All;
            }
            field("Expected Project Completion Month"; Rec.ExpectedProjectCompletionMonth)
            {
                ApplicationArea = All;
            }
            field("Expected Project Completion Year"; Rec.ExpectedProjectCompletionYear)
            {
                ApplicationArea = All;
            }
            field(Specifier; Rec.Specifier)
            {
                ApplicationArea = all;
            }
            field("Specifier Name"; Rec."Specifier Name")
            {
                ApplicationArea = all;
            }
            field("Specifier Contact No."; Rec."Specifier Contact No.")
            {
                ApplicationArea = all;
            }
            field("Quote Status"; Rec."Quote Status")
            {
                ApplicationArea = all;
            }


        }
        moveafter("Shipment Date"; "Shipping Agent Code")
        moveafter("Shipping Agent Code"; "Shipping Agent Service Code")
    }
    actions
    {
        addafter(RemoveIncomingDoc)
        {
            action("CFA Request Form")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    REPORT.Run(50034, true, false, Rec);//SPD MS
                end;
            }
        }
    }
    var
        WorkDescription: Text;
}
