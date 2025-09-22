report 50272 "Purchase Commision Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50272_Report_PurchaseCommisionReport.rdlc';

    dataset
    {
        dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
        {
            DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = FILTER(Item));
            RequestFilterFields = "Buy-from Vendor No.", "Document No.", "Posting Date";
            column(InvoiceType; InvoiceType)
            {
            }
            column(Invoice_No; "Purch. Inv. Line"."Document No.")
            {
            }
            column(Invoice_Date; "Purch. Inv. Line"."Posting Date")
            {
            }
            column(Customer_Code; "Purch. Inv. Line"."Buy-from Vendor No.")
            {
            }
            column(Customer_Name; InvoiceVendor.Name)
            {
            }
            column(SKU; "Purch. Inv. Line"."No.")
            {
            }
            column(Description; "Purch. Inv. Line".Description)
            {
            }
            column(Shipped; "Purch. Inv. Line".Quantity)
            {
            }
            column(Inv; "Purch. Inv. Line"."Unit Price (LCY)")
            {
            }
            column(Total; "Purch. Inv. Line"."Line Amount")
            {
            }
            column(Line_No; "Purch. Inv. Line"."Line No.")
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
                IF InvoiceVendor.GET("Purch. Inv. Line"."Buy-from Vendor No.") THEN;
                /*
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
                */

            end;
        }
        dataitem("Purch. Cr. Memo Line"; "Purch. Cr. Memo Line")
        {
            DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = FILTER(Item));
            RequestFilterFields = "Buy-from Vendor No.", "Document No.", "Posting Date";
            column(CrMemoType; CrMemoType)
            {
            }
            column(CrMemo_No; "Purch. Cr. Memo Line"."Document No.")
            {
            }
            column(CrMemo_Date; "Purch. Cr. Memo Line"."Posting Date")
            {
            }
            column(CrMemo_Customer_Code; "Purch. Cr. Memo Line"."Buy-from Vendor No.")
            {
            }
            column(CrMemo_Customer_Name; CrMemoVendor.Name)
            {
            }
            column(CrMemo_SKU; "Purch. Cr. Memo Line"."No.")
            {
            }
            column(CrMemo_Description; "Purch. Cr. Memo Line".Description)
            {
            }
            column(CrMemo_Shipped; "Purch. Cr. Memo Line".Quantity)
            {
            }
            column(CrMemo_Inv; "Purch. Cr. Memo Line"."Unit Price (LCY)")
            {
            }
            column(CrMemo_Total; "Purch. Cr. Memo Line"."Line Amount")
            {
            }
            column(CrMemo_Backing_Charge; CrMemoBackingCharge)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CrMemoType := 'Credit Memo';
                IF CrMemoVendor.GET("Purch. Cr. Memo Line"."Buy-from Vendor No.") THEN;

                /*
                CrMemoBackingCharge := 0;
                SCL.RESET;
                SCL.SETRANGE("Document No.", "Document No.");
                SCL.SETRANGE(Type, SCL.Type::Resource);
                SCL.SETFILTER("Line No.", '>%1', "Line No.");
                IF SCL.FINDFIRST THEN BEGIN
                  CrMemoBackingCharge := SCL."Line Amount";
                END;
                */

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
        InvoiceVendor: Record Vendor;
        BackingCharge: Decimal;
        TotalInvoiceValue: Decimal;
        CrMemoType: Text;
        CrMemoVendor: Record Vendor;
        CrMemoBackingCharge: Decimal;
        SIL: Record "Purch. Inv. Line";
        ResLineNo: Integer;
        SCL: Record "Purch. Cr. Memo Line";
}

