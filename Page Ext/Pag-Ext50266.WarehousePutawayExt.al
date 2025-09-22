pageextension 50266 "Warehouse Put-away_Ext" extends "Warehouse Put-away"
{
    actions
    {
        addafter("&Print")
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
                    RepImportPutAway.Run;
                end;
            }
        }
    }
    var
        ExcelBuff: Record "Excel Buffer";
        RepImportPutAway: Report "Import Put Away Bins";
        Text001: Label 'Put Away Import';

    procedure CreateExcelBook()
    begin
        ExcelBuff.CreateNewBook(Text001);
        ExcelBuff.WriteSheet(Text001, CompanyName, UserId);
        ExcelBuff.CloseBook;
        ExcelBuff.SetFriendlyFilename('Put Away Import Format');
        ExcelBuff.OpenExcel;
        //ExcelBuff.GiveUserControl;
    end;

    procedure MakeExcelDataHeader()
    begin
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn('Action Type', false, 'Action Type', true, false, true, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('No.', false, 'No.', true, false, true, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Line No.', false, 'Line No.', true, false, true, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Item No.', false, 'Item No.', true, false, true, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Description', false, 'Description', true, false, true, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Lot No.', false, 'Lot No.', true, false, true, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Location Code', false, 'Location Code', true, false, true, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Zone Code', false, 'Zone Code', true, false, true, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Bin Code', false, 'Bin Code', true, false, true, '', ExcelBuff."Cell Type"::Text);
    end;

    procedure MakeExcelDataLine(No: Code[10])
    var
        WarehouseActivityLine: Record "Warehouse Activity Line";
    begin
        WarehouseActivityLine.Reset;
        WarehouseActivityLine.SetRange("Activity Type", WarehouseActivityLine."Activity Type"::"Put-away");
        WarehouseActivityLine.SetRange("Action Type", WarehouseActivityLine."Action Type"::Place);
        WarehouseActivityLine.SetRange(WarehouseActivityLine."No.", No);
        if WarehouseActivityLine.FindSet then begin
            repeat
                ExcelBuff.NewRow;
                ExcelBuff.AddColumn(WarehouseActivityLine."Action Type", false, 'Action Type', true, true, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WarehouseActivityLine."No.", false, 'No.', true, true, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WarehouseActivityLine."Line No.", false, 'Line No.', true, true, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WarehouseActivityLine."Item No.", false, 'Item No.', true, true, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WarehouseActivityLine.Description, false, 'Description', true, true, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WarehouseActivityLine."Lot No.", false, 'Lot No.', true, true, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WarehouseActivityLine."Location Code", false, 'Location Code', true, true, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WarehouseActivityLine."Zone Code", false, 'Zone Code', false, false, false, '', ExcelBuff."Cell Type"::Text);
                ExcelBuff.AddColumn(WarehouseActivityLine."Bin Code", false, 'Bin Code', false, false, false, '', ExcelBuff."Cell Type"::Text);

            until WarehouseActivityLine.Next = 0;
        end;
    end;
}
