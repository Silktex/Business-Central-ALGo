report 50072 "Missing Item Cross Ref"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50072_Report_MissingItemCrossRef.rdlc';

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column(Item_No; Item."No.")
            {
            }
            column(Item_Name; Item.Description)
            {
            }
            column(Item_New_Customer; txtSaveData)
            {
            }
            column(MissingCustomerCode; MissingCustomerCode)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF Item."Reorder Calculation Year" <> 0 THEN BEGIN
                    Year -= Item."Reorder Calculation Year";
                    PreviousDate := DMY2DATE(Day, Month, Year);
                END ELSE
                    PreviousDate := 0D;

                txtSaveData := '';
                SalesInvoiceLine.RESET;
                SalesInvoiceLine.SETRANGE(Type, SalesInvoiceLine.Type::Item);
                SalesInvoiceLine.SETRANGE("No.", Item."No.");
                SalesInvoiceLine.SETRANGE("Posting Date", PreviousDate, TODAY);
                SalesInvoiceLine.SETFILTER("Sell-to Customer No.", '<>%1', 'C03351');
                IF SalesInvoiceLine.FINDSET THEN
                    REPEAT
                        recCustomer.GET(SalesInvoiceLine."Sell-to Customer No.");
                        TempCustomer.INIT;
                        TempCustomer."No." := recCustomer."No.";
                        TempCustomer.Name := recCustomer.Name;
                        TempCustomer."Name 2" := recCustomer."Name 2";
                        IF TempCustomer.INSERT THEN;
                    UNTIL SalesInvoiceLine.NEXT = 0;

                SalesLine.RESET;
                SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
                SalesLine.SETRANGE(Type, SalesLine.Type::Item);
                SalesLine.SETRANGE("No.", Item."No.");
                SalesLine.SETRANGE("Posting Date", PreviousDate, TODAY);
                IF SalesLine.FINDSET THEN
                    REPEAT
                        recCustomer.GET(SalesLine."Sell-to Customer No.");
                        TempCustomer.INIT;
                        TempCustomer."No." := recCustomer."No.";
                        TempCustomer.Name := recCustomer.Name;
                        TempCustomer."Name 2" := recCustomer."Name 2";
                        IF TempCustomer.INSERT THEN;
                    UNTIL SalesLine.NEXT = 0;

                //ItemCustomerName.RESET;
                //ItemCustomerName.SETRANGE("Item No.",Item."No.");
                //ItemCustomerName.DELETEALL;

                TempCustomer.RESET;
                TempCustomer.SETFILTER("Name 2", '<>%1', '');
                IF TempCustomer.FINDSET THEN
                    REPEAT
                        ItemCustomerName2.INIT;
                        ItemCustomerName2."Item No." := Item."No.";
                        ItemCustomerName2."Customer No." := TempCustomer."No.";
                        ItemCustomerName2."Customer Name" := TempCustomer.Name;
                        ItemCustomerName2."Customer Name 2" := TempCustomer."Name 2";
                        IF NOT ItemCustomerName2.INSERT THEN
                            ItemCustomerName2.MODIFY;
                        ItemCrossReference.RESET;
                        ItemCrossReference.SETRANGE("Item No.", ItemCustomerName2."Item No.");
                        ItemCrossReference.SETRANGE("Cross-Reference Type", ItemCrossReference."Cross-Reference Type"::Customer);
                        ItemCrossReference.SETRANGE(ItemCrossReference."Cross-Reference Type No.", ItemCustomerName2."Customer No.");
                        IF NOT ItemCrossReference.FINDFIRST THEN BEGIN
                            IF MissingCustomerCode = '' THEN
                                MissingCustomerCode := ItemCustomerName2."Customer No."
                            ELSE
                                MissingCustomerCode := MissingCustomerCode + ',' + ItemCustomerName2."Customer No.";

                            IF txtSaveData = '' THEN
                                txtSaveData := ItemCustomerName2."Customer Name 2"
                            ELSE
                                txtSaveData := txtSaveData + ',' + ItemCustomerName2."Customer Name 2";
                        END;
                    UNTIL TempCustomer.NEXT = 0;


            end;

            trigger OnPreDataItem()
            begin
                Year := DATE2DMY(TODAY, 3);
                Month := DATE2DMY(TODAY, 2);
                Day := DATE2DMY(TODAY, 1);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    Visible = false;
                    field(LastCalculationYear; LastCalculationYear)
                    {
                        Caption = 'Last Calculation Year';
                        MaxValue = 5;
                        Visible = false;
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

    var
        recCustomer: Record Customer;
        SalesInvoiceLine: Record "Sales Invoice Line";
        LastCalculationYear: Integer;
        Year: Integer;
        Month: Integer;
        Day: Integer;
        PreviousDate: Date;
        txtSaveData: Text;
        TempCustomer: Record Customer temporary;
        ItemCustomerName2: Record "Item Customer Re-Order" temporary;
        ItemCustomerName: Record "Item Customer Re-Order" temporary;
        SalesLine: Record "Sales Line";
        MissingCustomerCode: Text;
        ItemCrossReference: Record "Item Cross Reference";
}

