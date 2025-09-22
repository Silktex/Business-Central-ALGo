page 50103 "Vendor Ledger Entries Vendor D"
{
    Caption = 'Vendor Ledger Entries';
    DataCaptionFields = "Vendor No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Vendor Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
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
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Message to Recipient"; Rec."Message to Recipient")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = All;
                }
                field("Payment Reference"; Rec."Payment Reference")
                {
                    ApplicationArea = All;
                }
                field("Creditor No."; Rec."Creditor No.")
                {
                    ApplicationArea = All;
                }
                field("Original Amount"; Rec."Original Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Original Amt. (LCY)"; Rec."Original Amt. (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Remaining Amt. (LCY)"; Rec."Remaining Amt. (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                }
                field("Pmt. Discount Date"; Rec."Pmt. Discount Date")
                {
                    ApplicationArea = All;
                }
                field("Pmt. Disc. Tolerance Date"; Rec."Pmt. Disc. Tolerance Date")
                {
                    ApplicationArea = All;
                }
                field("Original Pmt. Disc. Possible"; Rec."Original Pmt. Disc. Possible")
                {
                    ApplicationArea = All;
                }
                field("Remaining Pmt. Disc. Possible"; Rec."Remaining Pmt. Disc. Possible")
                {
                    ApplicationArea = All;
                }
                field("Max. Payment Tolerance"; Rec."Max. Payment Tolerance")
                {
                    ApplicationArea = All;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("On Hold"; Rec."On Hold")
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Reversed by Entry No."; Rec."Reversed by Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Reversed Entry No."; Rec."Reversed Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("IRS 1099 Code"; Rec."IRS 1099 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("IRS 1099 Amount"; Rec."IRS 1099 Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Exported to Payment File"; Rec."Exported to Payment File")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action("Applied E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Applied E&ntries';
                    Image = Approve;
                    RunObject = Page "Applied Vendor Entries";
                    RunPageOnRec = true;
                }
                action(Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
                action("Detailed &Ledger Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Detailed &Ledger Entries';
                    Image = View;
                    RunObject = Page "Detailed Vendor Ledg. Entries";
                    RunPageLink = "Vendor Ledger Entry No." = FIELD("Entry No."),
                                  "Vendor No." = FIELD("Vendor No.");
                    RunPageView = SORTING("Vendor Ledger Entry No.", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(ActionApplyEntries)
                {
                    ApplicationArea = All;
                    Caption = 'Apply Entries';
                    Image = ApplyEntries;
                    ShortCutKey = 'Shift+F11';

                    trigger OnAction()
                    var
                        VendLedgEntry: Record "Vendor Ledger Entry";
                        VendEntryApplyPostEntries: Codeunit "VendEntry-Apply Posted Entries";
                    begin
                        VendLedgEntry.Copy(Rec);
                        VendEntryApplyPostEntries.ApplyVendEntryFormEntry(VendLedgEntry);
                        Rec := VendLedgEntry;
                        CurrPage.Update;
                    end;
                }
                separator(Action66)
                {

                }
                action(UnapplyEntries)
                {
                    ApplicationArea = All;
                    Caption = 'Unapply Entries';
                    Ellipsis = true;
                    Image = UnApply;

                    trigger OnAction()
                    var
                        VendEntryApplyPostedEntries: Codeunit "VendEntry-Apply Posted Entries";
                    begin
                        VendEntryApplyPostedEntries.UnApplyVendLedgEntry(Rec."Entry No.");
                    end;
                }
                separator(Action68)
                {
                }
                action(ReverseTransaction)
                {
                    ApplicationArea = All;
                    Caption = 'Reverse Transaction';
                    Ellipsis = true;
                    Image = ReverseRegister;

                    trigger OnAction()
                    var
                        ReversalEntry: Record "Reversal Entry";
                    begin
                        Clear(ReversalEntry);
                        if Rec.Reversed then
                            ReversalEntry.AlreadyReversedEntry(Rec.TableCaption, Rec."Entry No.");
                        if Rec."Journal Batch Name" = '' then
                            ReversalEntry.TestFieldError;
                        Rec.TestField("Transaction No.");
                        ReversalEntry.ReverseTransaction(Rec."Transaction No.");
                    end;
                }
            }
            action("&Navigate")
            {
                ApplicationArea = All;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.Run;
                end;
            }
            action("Incoming Document")
            {
                ApplicationArea = All;
                Caption = 'Incoming Document';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    IncomingDocument: Record "Incoming Document";
                begin
                    //IncomingDocument.HyperlinkToDocument(Rec."Document No.", Rec."Posting Date");
                    IncomingDocument.ShowCard(Rec."Document No.", Rec."Posting Date");
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleTxt := Rec.SetStyle;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CODEUNIT.Run(CODEUNIT::"Vend. Entry-Edit", Rec);
        exit(false);
    end;

    var
        Navigate: Page Navigate;
        StyleTxt: Text;
}

