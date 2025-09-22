report 50019 "Lot Report1"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING("Item No.", "Posting Date") ORDER(Ascending) WHERE("Remaining Quantity" = FILTER(<> 0));
            RequestFilterFields = "Item No.", "Posting Date", "Document No.", "Item Category Code";

            trigger OnAfterGetRecord()
            begin
                IF Itm.GET("Item No.") THEN BEGIN
                    ItmDescription := Itm.Description;
                    ItmDescription2 := Itm."Description 2";
                END;
                MakeExcelDataBody;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        CreateExcelBook;
    end;

    trigger OnPreReport()
    begin
        MakeExcelDataHeader;
    end;

    var
        ExcelBuff: Record "Excel Buffer" temporary;
        Text0001: Label 'Lot Report';
        Text0002: Label 'Data';
        Itm: Record Item;
        ItmDescription: Text[100];
        ItmDescription2: Text[100];


    procedure CreateExcelBook()
    begin
        // ExcelBuff.CreateBook('', Text0001);
        ExcelBuff.CreateNewBook(Text0001);
        ExcelBuff.WriteSheet(Text0001, COMPANYNAME, USERID);
        ExcelBuff.CloseBook;
        ExcelBuff.SetFriendlyFilename(Text0001);
        ExcelBuff.OpenExcel;
        //ExcelBuff.GiveUserControl;
    end;


    procedure MakeExcelDataHeader()
    begin
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn("Item Ledger Entry".FIELDCAPTION("Item No."), FALSE, 'Item Number', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn("Item Ledger Entry".FIELDCAPTION(Description), FALSE, 'Item Description', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Description2', FALSE, 'Item Description2', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn("Item Ledger Entry".FIELDCAPTION("Lot No."), FALSE, 'Lot Number', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn("Item Ledger Entry".FIELDCAPTION("Remaining Quantity"), FALSE, 'Remaining Quantity', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
    end;


    procedure MakeExcelDataBody()
    begin
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn("Item Ledger Entry"."Item No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(ItmDescription, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(ItmDescription2, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn("Item Ledger Entry"."Lot No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn("Item Ledger Entry"."Remaining Quantity", FALSE, '', FALSE, FALSE, FALSE, '#0.00', ExcelBuff."Cell Type"::Number);
    end;
}

