page 50005 ILE
{
    PageType = List;
    SourceTable = "Item Ledger Entry";
    SourceTableView = WHERE("Remaining Quantity" = FILTER(<> 0));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = All;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                }
                field(VendorCodeSC; VendorCode(Rec))
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Code';
                }
                field(VendorNameSC; VendorName(Rec))
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Name';
                }
            }
        }
    }

    actions
    {
    }

    procedure VendorCode(ItemLedEntry: Record "Item Ledger Entry"): Code[20]
    var
        ItemApplicationEntry: Record "Item Application Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        /*ItemApplicationEntry.RESET;
        ItemApplicationEntry.SETRANGE(ItemApplicationEntry."Item Ledger Entry No.","Entry No.");
        IF ItemApplicationEntry.FINDFIRST THEN BEGIN
        
        END;
        */
        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetFilter(ItemLedgerEntry."Lot No.", '<>%1&%2', '', ItemLedEntry."Lot No.");
        ItemLedgerEntry.SetRange(ItemLedgerEntry."Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
        if ItemLedgerEntry.FindFirst then
            exit(ItemLedgerEntry."Source No.");

    end;

    procedure VendorName(ItemLedEntry: Record "Item Ledger Entry"): Text[100]
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        Vendor: Record Vendor;
    begin
        /*ItemApplicationEntry.RESET;
        ItemApplicationEntry.SETRANGE(ItemApplicationEntry."Item Ledger Entry No.","Entry No.");
        IF ItemApplicationEntry.FINDFIRST THEN BEGIN
        
        END;
        */
        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetFilter(ItemLedgerEntry."Lot No.", '<>%1&%2', '', ItemLedEntry."Lot No.");
        ItemLedgerEntry.SetRange(ItemLedgerEntry."Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
        if ItemLedgerEntry.FindFirst then begin
            if Vendor.Get(ItemLedgerEntry."Source No.") then
                exit(Vendor.Name);
        end;

    end;
}

