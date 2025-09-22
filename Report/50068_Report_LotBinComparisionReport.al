report 50068 "Lot & Bin Comparision Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50068_Report_LotBinComparisionReport.rdlc';

    dataset
    {
        dataitem("Bin Content"; "Bin Content")
        {
            CalcFields = "Quantity (Base)";
            DataItemTableView = SORTING("Item No.") WHERE("Location Code" = CONST('BOMMASANDR'));
            RequestFilterFields = "Item No.";
            column(ItemNo; "Bin Content"."Item No.")
            {
            }
            column(ItmDescription; ItmDescription)
            {
            }
            column(LocationCode; "Bin Content"."Location Code")
            {
            }
            column(Bin_Code; "Bin Content"."Bin Code")
            {
            }
            column(Quantity; ItemInv)
            {
            }
            column(BinQuantity; "Bin Content"."Quantity (Base)")
            {
            }

            trigger OnAfterGetRecord()
            begin
                ItemInv := 0;
                ItmDescription := '';
                Item.SETRANGE("No.", "Bin Content"."Item No.");
                Item.SETFILTER("Location Filter", "Bin Content"."Location Code");
                IF Item.FINDFIRST THEN BEGIN
                    Item.CALCFIELDS(Inventory);
                    ItemInv := Item.Inventory;
                    ItmDescription := Item.Description;
                END;
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
        //CreateExcelBook;
    end;

    trigger OnPreReport()
    begin
        //MakeExcelDataHeader;
    end;

    var
        ExcelBuff: Record "Excel Buffer" temporary;
        Text0001: Label 'Lot Report';
        Item: Record Item;
        ItmDescription: Text[100];
        ItmDescription2: Text[100];
        ItemInv: Decimal;


    procedure CreateExcelBook()
    begin

        //ExcelBuff.CreateBook('', Text0001);
        ExcelBuff.CreateNewBook(Text0001);
        ExcelBuff.WriteSheet(Text0001, COMPANYNAME, USERID);
        ExcelBuff.CloseBook;
        ExcelBuff.OpenExcel;
        //ExcelBuff.GiveUserControl;
    end;


    procedure MakeExcelDataHeader()
    begin
        /*
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn("Item Ledger Entry".FIELDCAPTION("Lot No."),FALSE,'',TRUE,TRUE,FALSE,'',ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn("Item Ledger Entry".FIELDCAPTION("Item No."),FALSE,'',TRUE,TRUE,FALSE,'',ExcelBuff."Cell Type"::Text);
        ///ExcelBuff.AddColumn('Description2',FALSE,'',TRUE,TRUE,FALSE,'',ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn("Item Ledger Entry".FIELDCAPTION(Description),FALSE,'',TRUE,TRUE,FALSE,'',ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn("Item Ledger Entry".FIELDCAPTION("Location Code"),FALSE,'',TRUE,TRUE,FALSE,'',ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn("Item Ledger Entry".FIELDCAPTION("Remaining Quantity"),FALSE,'',TRUE,TRUE,FALSE,'',ExcelBuff."Cell Type"::Text);
        */

    end;


    procedure MakeExcelDataBody()
    begin
        /*
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn("Item Ledger Entry"."Lot No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn("Item Ledger Entry"."Item No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(ItmDescription,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuff."Cell Type"::Text);
        //ExcelBuff.AddColumn(ItmDescription2,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn("Item Ledger Entry"."Location Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn("Item Ledger Entry"."Remaining Quantity",FALSE,'',FALSE,FALSE,FALSE,'#0.00',ExcelBuff."Cell Type"::Number);
        */

    end;
}

