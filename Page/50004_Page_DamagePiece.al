page 50004 "Damage Piece"
{
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Item Ledger Entry";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Control1000000011)
            {
                ShowCaption = false;
                field(SearchLot; SearchLot)
                {
                    ApplicationArea = all;
                    Caption = 'Scan Lot';

                    trigger OnValidate()
                    begin
                        ItemLedgerEntry.Reset;
                        ItemLedgerEntry.SetCurrentKey("Entry No.");
                        ItemLedgerEntry.SetFilter(ItemLedgerEntry."Remaining Quantity", '<>%1', 0);
                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Lot No.", SearchLot);
                        if ItemLedgerEntry.Find('-') then
                            repeat
                                Rec.Init;
                                Rec.TransferFields(ItemLedgerEntry);
                                if Item.Get(ItemLedgerEntry."Item No.") then
                                    Rec.Description := Item.Description;
                                Rec.Insert(true);
                            until ItemLedgerEntry.Next = 0;
                        SearchLot := '';
                    end;
                }
            }
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = all;
                }
                field(VendorNo; GetVendorNo(Rec."Lot No."))
                {
                    ApplicationArea = all;
                    Caption = 'Vendor No.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.DeleteAll;
    end;

    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        Item: Record Item;
        SearchLot: Code[20];
        Desc: Text[100];

    procedure GetVendorNo(LotNo: Code[30]): Code[20]
    var
        ILE: Record "Item Ledger Entry";
    begin
        ILE.Reset;
        ILE.SetRange(ILE."Lot No.", LotNo);
        ILE.SetRange(ILE."Source Type", ILE."Source Type"::Vendor);
        ILE.SetRange(ILE."Entry Type", ILE."Entry Type"::Purchase);
        if ILE.FindFirst then
            exit(ILE."Source No.");
    end;
}

