page 50063 "Ecom Sales Invoice"
{
    Caption = 'Ecom Sales Invoice';
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
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = all;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                    Editable = false;
                    StyleExpr = StyleTxt;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    StyleExpr = StyleTxt;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Inv. Discount (LCY)"; Rec."Inv. Discount (LCY)")
                {
                    ApplicationArea = all;
                    Caption = 'Discount';
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

