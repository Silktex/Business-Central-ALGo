pageextension 50285 "Movement Worksheet_Ext" extends "Movement Worksheet"
{
    layout
    {
        addbefore("Item No.")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("Create Movement")
        {
            action(ExporttoExcel)
            {
                Caption = 'Export to Excel';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                begin
                    ExcelBuff.Reset;
                    ExcelBuff.DeleteAll;
                    CreateExcelBook;
                end;
            }
            action(ImporttoExcel)
            {
                Caption = 'Import From Excel';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                begin
                    RepImportMovementWorksheet.Run;
                end;
            }
        }
    }
    var
        ExcelBuff: Record "Excel Buffer";
        RepImportMovementWorksheet: Report "Import Whse Movement";
        WhseJournalLine: Record "Whse. Worksheet Line";
        Text003: Label 'Movement Worksheet Import';
        Text002: Label 'Export Format,Import Data';
        recItemUOM: Record "Item Unit of Measure";
        WhseItemTrackingLine: Record "Whse. Item Tracking Line";

    procedure CreateExcelBook()
    begin
        MakeExcelDataHeader;
        CreateExcelBody;
        ExcelBuff.CreateNewBook(Text003);
        ExcelBuff.WriteSheet(Text003, CompanyName, UserId);
        ExcelBuff.CloseBook;
        ExcelBuff.SetFriendlyFilename('Movement Worksheet Import Format');
        ExcelBuff.OpenExcel;
        //ExcelBuff.GiveUserControl;
    end;

    procedure MakeExcelDataHeader()
    begin
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn('Worksheet Template Name', false, 'Worksheet Template Name', true, true, false, '', ExcelBuff."Cell Type"::Text);//1
        ExcelBuff.AddColumn('Name', false, 'Name', true, true, false, '', ExcelBuff."Cell Type"::Text);//2
        ExcelBuff.AddColumn('Location Code', false, 'Location Code', true, true, false, '', ExcelBuff."Cell Type"::Text);//3
        ExcelBuff.AddColumn('Line No', false, 'Line No', true, true, false, '', ExcelBuff."Cell Type"::Text);//4
        ExcelBuff.AddColumn('Item No.', false, 'Item No.', true, true, false, '', ExcelBuff."Cell Type"::Text);//5
        ExcelBuff.AddColumn('Description', false, 'Description', true, true, false, '', ExcelBuff."Cell Type"::Text);//6
        ExcelBuff.AddColumn('From Zone Code', false, 'From Zone Code', true, true, false, '', ExcelBuff."Cell Type"::Text);//7
        ExcelBuff.AddColumn('From Bin Code', false, 'From Bin Code', true, true, false, '', ExcelBuff."Cell Type"::Text);//8
        ExcelBuff.AddColumn('To Zone Code', false, 'To Zone Code', true, true, false, '', ExcelBuff."Cell Type"::Text);//9
        ExcelBuff.AddColumn('To Bin Code', false, 'To Bin Code', true, true, false, '', ExcelBuff."Cell Type"::Text);//10
        ExcelBuff.AddColumn('Quantity', false, 'Quantity', true, true, false, '', ExcelBuff."Cell Type"::Text);//11
        ExcelBuff.AddColumn('Qty. Outstanding', false, 'Qty. Outstanding', true, true, false, '', ExcelBuff."Cell Type"::Text);//12
        ExcelBuff.AddColumn('Qty. to Handle', false, 'Qty. to Handle', true, true, false, '', ExcelBuff."Cell Type"::Text);//13
        ExcelBuff.AddColumn('Qty. Handled', false, 'Qty. Handled', true, true, false, '', ExcelBuff."Cell Type"::Text);//14
        ExcelBuff.AddColumn('Due Date', false, 'Due Date', true, true, false, '', ExcelBuff."Cell Type"::Text);//15
        ExcelBuff.AddColumn('Unit of Measure Code', false, 'Unit of Measure Code', true, true, false, '', ExcelBuff."Cell Type"::Text);//16
        ExcelBuff.AddColumn('Available Qty. to Move', false, 'Available Qty. to Move', true, true, false, '', ExcelBuff."Cell Type"::Text);//17
        ExcelBuff.AddColumn('Lot No.', false, 'Lot No.', true, true, false, '', ExcelBuff."Cell Type"::Text);//18
        ExcelBuff.AddColumn('Lot Quantity', false, 'Lot Quantity', true, true, false, '', ExcelBuff."Cell Type"::Text);//19
        ExcelBuff.AddColumn('Deleted', false, 'Lot Quantity', true, true, false, '', ExcelBuff."Cell Type"::Text);//20
    end;

    procedure CreateExcelBody()
    begin
        WhseItemTrackingLine.Reset;
        WhseItemTrackingLine.SetRange(WhseItemTrackingLine."Source ID", Rec.Name);
        WhseItemTrackingLine.SetRange(WhseItemTrackingLine."Source Batch Name", Rec."Worksheet Template Name");
        WhseItemTrackingLine.SetRange(WhseItemTrackingLine."Source Type", 7326);
        WhseItemTrackingLine.SetRange(WhseItemTrackingLine."Location Code", Rec."Location Code");
        if WhseItemTrackingLine.FindFirst then begin
            repeat
                ExcelBuff.NewRow;
                ExcelBuff.AddColumn(WhseItemTrackingLine."Source Batch Name", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WhseItemTrackingLine."Source ID", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WhseItemTrackingLine."Location Code", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WhseItemTrackingLine."Source Ref. No.", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WhseItemTrackingLine."Item No.", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                WhseJournalLine.Reset;
                WhseJournalLine.SetRange("Worksheet Template Name", WhseItemTrackingLine."Source Batch Name");
                WhseJournalLine.SetRange(Name, WhseItemTrackingLine."Source ID");
                WhseJournalLine.SetRange("Location Code", WhseItemTrackingLine."Location Code");
                WhseJournalLine.SetRange("Item No.", WhseItemTrackingLine."Item No.");
                WhseJournalLine.SetRange("Line No.", WhseItemTrackingLine."Source Ref. No.");
                if WhseJournalLine.FindFirst then begin
                    ExcelBuff.AddColumn(WhseJournalLine.Description, false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                    ExcelBuff.AddColumn(WhseJournalLine."From Zone Code", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                    ExcelBuff.AddColumn(WhseJournalLine."From Bin Code", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                    ExcelBuff.AddColumn(WhseJournalLine."To Zone Code", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                    ExcelBuff.AddColumn(WhseJournalLine."To Bin Code", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                    ExcelBuff.AddColumn(WhseJournalLine.Quantity, false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                    ExcelBuff.AddColumn(WhseJournalLine."Qty. Outstanding", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                    ExcelBuff.AddColumn(WhseJournalLine."Qty. to Handle", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                    ExcelBuff.AddColumn(WhseJournalLine."Qty. Handled", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                    ExcelBuff.AddColumn(WhseJournalLine."Due Date", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                    ExcelBuff.AddColumn(WhseJournalLine."Unit of Measure Code", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                    if recItemUOM.Get(WhseJournalLine."Item No.", WhseJournalLine."From Unit of Measure Code") then
                        ExcelBuff.AddColumn(Round(WhseJournalLine.CheckAvailQtytoMove / recItemUOM."Qty. per Unit of Measure", 0.00001), false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                end;
                ExcelBuff.AddColumn(WhseItemTrackingLine."Lot No.", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WhseItemTrackingLine."Quantity (Base)", false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn('No', false, '', false, false, false, '', ExcelBuff."Cell Type"::Text);
            until WhseItemTrackingLine.Next = 0;
        end;
    end;
}
