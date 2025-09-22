report 50055 "STK PLACEMENT11"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {

            trigger OnAfterGetRecord()
            begin
                recSalesInvHdr.RESET;
                recSalesInvHdr.SETRANGE(recSalesInvHdr."Sell-to Customer No.", Customer."No.");
                recSalesInvHdr.SETRANGE(recSalesInvHdr."Campaign No.", 'PLACEMENT');
                IF FromDate <> 0D THEN
                    recSalesInvHdr.SETRANGE(recSalesInvHdr."Posting Date", FromDate, ToDate);
                IF recSalesInvHdr.FINDFIRST THEN
                    REPEAT
                        recSalesInvLine.RESET;
                        recSalesInvLine.SETRANGE(recSalesInvLine."Document No.", recSalesInvHdr."No.");
                        recSalesInvLine.SETFILTER(recSalesInvLine.Quantity, '<>%1', 0);
                        IF recSalesInvLine.FINDFIRST THEN
                            REPEAT
                                recSalesInvLine1.RESET;
                                recSalesInvLine1.SETRANGE(recSalesInvLine1."Sell-to Customer No.", recSalesInvHdr."Sell-to Customer No.");
                                IF FromDate <> 0D THEN
                                    recSalesInvLine1.SETRANGE(recSalesInvLine1."Posting Date", FromDate, ToDate);
                                recSalesInvLine1.SETFILTER(recSalesInvLine1."Document No.", '<>%1', recSalesInvHdr."No.");
                                recSalesInvLine1.SETRANGE(recSalesInvLine1.Type, recSalesInvLine.Type);
                                recSalesInvLine1.SETRANGE(recSalesInvLine1."No.", recSalesInvLine."No.");
                                recSalesInvLine1.SETRANGE(recSalesInvLine1."Location Code", recSalesInvLine."Location Code");
                                recSalesInvLine1.CALCSUMS(recSalesInvLine1.Quantity, recSalesInvLine1.Amount);
                                ItemCrossReference.RESET;
                                ItemCrossReference.SETRANGE(ItemCrossReference."Item No.", recSalesInvLine."No.");
                                ItemCrossReference.SETRANGE(ItemCrossReference."Reference Type", ItemCrossReference."Reference Type"::Customer);
                                ItemCrossReference.SETRANGE(ItemCrossReference."Reference Type No.", recSalesInvHdr."Sell-to Customer No.");
                                //ItemCrossReference.SETFILTER(ItemCrossReference."Placement End Date",'>=%1',FromDate);
                                IF ItemCrossReference.FINDLAST THEN;
                                MakeExcelDataBody;
                            UNTIL recSalesInvLine.NEXT = 0;
                    UNTIL recSalesInvHdr.NEXT = 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    Caption = 'Option';
                    field(FromDate; FromDate)
                    {
                        Caption = 'From Date';
                        ApplicationArea = all;
                    }
                    field(ToDate; ToDate)
                    {
                        Caption = 'To Date';
                        ApplicationArea = all;
                    }
                }
            }
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
        IF FromDate <> 0D THEN
            IF ToDate = 0D THEN
                ERROR('Please Check Date');
        ExcelBuff.RESET;
        ExcelBuff.DELETEALL;
        MakeExcelDataHeader;
    end;

    var
        ExcelBuff: Record "Excel Buffer";
        recSalesInvHdr: Record "Sales Invoice Header";
        recSalesInvLine: Record "Sales Invoice Line";
        Text0001: Label 'STK PLACEMENT';
        recSalesInvLine1: Record "Sales Invoice Line";
        ItemCrossReference: Record "Item Reference";
        FromDate: Date;
        ToDate: Date;


    procedure CreateExcelBook()
    begin
        //ExcelBuff.CreateBook('', Text0001);
        ExcelBuff.CreateNewBook(Text0001);
        ExcelBuff.WriteSheet(Text0001, COMPANYNAME, USERID);
        ExcelBuff.CloseBook;
        ExcelBuff.OpenExcel;
        // ExcelBuff.GiveUserControl;
    end;


    procedure MakeExcelDataHeader()
    begin
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn('Customer No.', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Customer Name', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Invoice No.', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Type', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('No.', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Description', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Placement Date', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('UOM', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Placement Quantity', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        //ExcelBuff.AddColumn('Unit Price',FALSE,'',TRUE,TRUE,FALSE,'',ExcelBuff."Cell Type"::Text);
        //ExcelBuff.AddColumn('Discount',FALSE,'',TRUE,TRUE,FALSE,'',ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Placement Amount', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Reorder Quantity', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Reorder Amount', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Continuity', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn('Campaign No.', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuff."Cell Type"::Text);
    end;


    procedure MakeExcelDataBody()
    begin
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn(Customer."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(Customer.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(recSalesInvHdr."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(recSalesInvLine.Type, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(recSalesInvLine."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(recSalesInvLine.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(FORMAT(recSalesInvHdr."Posting Date"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Date);
        ExcelBuff.AddColumn(recSalesInvLine."Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
        ExcelBuff.AddColumn(FORMAT(recSalesInvLine.Quantity), FALSE, '', FALSE, FALSE, FALSE, '##,#0.00', ExcelBuff."Cell Type"::Number);
        //ExcelBuff.AddColumn(FORMAT(recSalesInvLine."Unit Price"),FALSE,'',FALSE,FALSE,FALSE,'##,#0.00',ExcelBuff."Cell Type"::Number);
        //ExcelBuff.AddColumn(FORMAT(recSalesInvLine."Line Discount Amount")+FORMAT(recSalesInvLine."Inv. Discount Amount"),FALSE,'',FALSE,FALSE,FALSE,'##,#0.00',ExcelBuff."Cell Type"::Number);
        ExcelBuff.AddColumn(FORMAT(recSalesInvLine.Amount), FALSE, '', FALSE, FALSE, FALSE, '##,#0.00', ExcelBuff."Cell Type"::Number);
        ExcelBuff.AddColumn(recSalesInvLine1.Quantity, FALSE, '', FALSE, FALSE, FALSE, '##,#0.00', ExcelBuff."Cell Type"::Number);
        ExcelBuff.AddColumn(recSalesInvLine1.Amount, FALSE, '', FALSE, FALSE, FALSE, '##,#0.00', ExcelBuff."Cell Type"::Number);
        ExcelBuff.AddColumn(ItemCrossReference."Placement End Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Date);
        ExcelBuff.AddColumn(recSalesInvHdr."Campaign No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuff."Cell Type"::Text);
    end;
}

