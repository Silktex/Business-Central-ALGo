pageextension 50278 "Whse. Phys. Invt. Journal_Ext" extends "Whse. Phys. Invt. Journal"
{
    layout
    {
        addbefore("Registering Date")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("Register and &Print")
        {
            action(ImportWhsePhysInvtJnl)
            {
                Caption = 'Import Whse Phys Invt Jnl';
                Ellipsis = true;
                Image = "Order";
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                ApplicationArea = all;

                trigger OnAction()
                var
                    Selection: Integer;
                begin
                    Selection := StrMenu(Text002, 2);
                    if Selection = 1 then begin
                        ExcelBuff.Reset;
                        ExcelBuff.DeleteAll;
                        CreateExcelBook;
                    end else
                        RepImportWhsePhysInvtJnl.Run;
                end;
            }
        }
    }

    var
        Text001: Label 'Whse Phy Inv Journal Import';
        Text002: Label 'Export Format,Import Data';
        ExcelBuff: Record "Excel Buffer";
        RepImportWhsePhysInvtJnl: Report "Import Whse Phys Invt Jnl";
        WhseJournalLine: Record "Warehouse Journal Line";

    procedure CreateExcelBook()
    begin
        MakeExcelDataHeader;
        CreateExcelBody;
        ExcelBuff.CreateNewBook(Text001);
        ExcelBuff.WriteSheet(Text001, CompanyName, UserId);
        ExcelBuff.CloseBook;
        ExcelBuff.SetFriendlyFilename('Whse Phy Inv Journal Import Format');
        ExcelBuff.OpenExcel;
        // ExcelBuff.GiveUserControl;
    end;

    procedure MakeExcelDataHeader()
    begin
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn('Journal Template Name', false, 'Journal Template Name', true, true, false, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Journal Batch Name', false, 'Journal Batch Name', true, true, false, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Location Code', false, 'Location Code', true, true, false, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Line No', false, 'Line No', true, true, false, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Whse. Document No.', false, 'Whse. Document No.', true, true, false, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Registering Date', false, 'Registering Date', true, true, false, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Item No.', false, 'Item No.', true, true, false, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Unit of Measure Code', false, 'Unit of Measure Code', true, true, false, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Lot No.', false, 'Lot No.', true, true, false, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Zone Code', false, 'Zone Code', true, true, false, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Bin Code', false, 'Bin Code', true, true, false, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Qty. (Phys. Inventory)', false, 'Qty. (Phys. Inventory)', true, true, false, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Quantity', false, 'Quantity', true, true, false, '', ExcelBuff."Cell Type"::Text);
    end;

    procedure CreateExcelBody()
    begin
        WhseJournalLine.Reset;
        WhseJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        WhseJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        WhseJournalLine.SetRange("Location Code", Rec."Location Code");
        if WhseJournalLine.FindSet then begin
            repeat
                ExcelBuff.NewRow;
                ExcelBuff.AddColumn(WhseJournalLine."Journal Template Name", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WhseJournalLine."Journal Batch Name", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WhseJournalLine."Location Code", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WhseJournalLine."Line No.", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WhseJournalLine."Whse. Document No.", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WhseJournalLine."Registering Date", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WhseJournalLine."Item No.", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WhseJournalLine."Unit of Measure Code", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WhseJournalLine."Lot No.", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WhseJournalLine."Zone Code", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WhseJournalLine."Bin Code", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WhseJournalLine."Qty. (Phys. Inventory)", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WhseJournalLine.Quantity, false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
            until WhseJournalLine.Next = 0;
        end;
    end;
}
