report 50271 "Sales Commision Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50271_Report_SalesCommisionReport.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Sales Invoice Line"; "Sales Invoice Line")
        {
            DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = FILTER(Item));
            RequestFilterFields = "Sell-to Customer No.", "Document No.", "Posting Date";
            column(InvoiceType; InvoiceType)
            {
            }
            column(Invoice_No; "Sales Invoice Line"."Document No.")
            {
            }
            column(Invoice_Date; "Sales Invoice Line"."Posting Date")
            {
            }
            column(Customer_Code; "Sales Invoice Line"."Sell-to Customer No.")
            {
            }
            column(Customer_Name; InvoiceCustomer.Name)
            {
            }
            column(SKU; "Sales Invoice Line"."No.")
            {
            }
            column(Description; "Sales Invoice Line".Description)
            {
            }
            column(Shipped; "Sales Invoice Line".Quantity)
            {
            }
            column(Inv; "Sales Invoice Line"."Unit Price")
            {
            }
            column(Total; "Sales Invoice Line"."Line Amount")
            {
            }
            column(Line_No; "Sales Invoice Line"."Line No.")
            {
            }
            column(ResLineNo; ResLineNo)
            {
            }
            column(Backing_Charge; BackingCharge)
            {
            }

            trigger OnAfterGetRecord()
            begin
                InvoiceType := 'Invoice';
                IF InvoiceCustomer.GET("Sales Invoice Line"."Sell-to Customer No.") THEN;

                ResLineNo := 0;
                BackingCharge := 0;
                SIL.RESET;
                SIL.SETRANGE("Document No.", "Document No.");
                SIL.SETRANGE(Type, SIL.Type::Resource);
                SIL.SETFILTER("Line No.", '>%1', "Line No.");
                IF SIL.FINDFIRST THEN BEGIN
                    ResLineNo := SIL."Line No.";
                    BackingCharge := SIL."Line Amount";
                END;
            end;
        }
        dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
        {
            DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = FILTER(Item));
            RequestFilterFields = "Sell-to Customer No.", "Document No.", "Posting Date";
            column(CrMemoType; CrMemoType)
            {
            }
            column(CrMemo_No; "Sales Cr.Memo Line"."Document No.")
            {
            }
            column(CrMemo_Date; "Sales Cr.Memo Line"."Posting Date")
            {
            }
            column(CrMemo_Customer_Code; "Sales Cr.Memo Line"."Sell-to Customer No.")
            {
            }
            column(CrMemo_Customer_Name; CrMemoCustomer.Name)
            {
            }
            column(CrMemo_SKU; "Sales Cr.Memo Line"."No.")
            {
            }
            column(CrMemo_Description; "Sales Cr.Memo Line".Description)
            {
            }
            column(CrMemo_Shipped; "Sales Cr.Memo Line".Quantity)
            {
            }
            column(CrMemo_Inv; "Sales Cr.Memo Line"."Unit Price")
            {
            }
            column(CrMemo_Total; "Sales Cr.Memo Line"."Line Amount")
            {
            }
            column(CrMemo_Backing_Charge; CrMemoBackingCharge)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CrMemoType := 'Credit Memo';
                IF CrMemoCustomer.GET("Sales Cr.Memo Line"."Sell-to Customer No.") THEN;

                CrMemoBackingCharge := 0;
                SCL.RESET;
                SCL.SETRANGE("Document No.", "Document No.");
                SCL.SETRANGE(Type, SCL.Type::Resource);
                SCL.SETFILTER("Line No.", '>%1', "Line No.");
                IF SCL.FINDFIRST THEN BEGIN
                    CrMemoBackingCharge := SCL."Line Amount";
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

    var
        InvoiceType: Text;
        InvoiceCustomer: Record Customer;
        BackingCharge: Decimal;
        TotalInvoiceValue: Decimal;
        CrMemoType: Text;
        CrMemoCustomer: Record Customer;
        CrMemoBackingCharge: Decimal;
        SIL: Record "Sales Invoice Line";
        ResLineNo: Integer;
        SCL: Record "Sales Cr.Memo Line";
}

