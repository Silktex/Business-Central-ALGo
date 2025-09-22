page 50066 "NOP Sales Payment"
{
    Caption = 'NOP Sales Payment';
    DataCaptionFields = "Customer No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Cust. Ledger Entry";
    SourceTableView = WHERE("Future/Paid Invoice" = CONST(false),
                            "Document Type" = FILTER(Invoice));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = StyleTxt;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = StyleTxt;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sales Payment No."; Rec."Sales Payment No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    var
        Navigate: Page Navigate;
        StyleTxt: Text;
        SalesOrderNo: Code[20];
        SIH: Record "Sales Invoice Header";
}

