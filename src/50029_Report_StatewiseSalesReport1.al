report 50029 "State wise Sales Report1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/50029_Report_StatewiseSalesReport1.rdlc';

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", County, "Country/Region Code";
            column(Name_CompInfo; CompInfo.Name)
            {
            }
            column(Address_CompInfo; CompInfo.Address)
            {
            }
            column(City_CompInfo; CompInfo.City)
            {
            }
            column(PostCode_CompInfo; CompInfo."Post Code")
            {
            }
            column(County_CompInfo; CompInfo.County)
            {
            }
            column(CountryRegionCode_CompInfo; CompInfo."Country/Region Code")
            {
            }
            column(PhoneNo_CompInfo; CompInfo."Phone No.")
            {
            }
            column(No_Customer; "No.")
            {
            }
            column(Name_Customer; Name)
            {
            }
            column(County_Customer; County)
            {
            }
            column(CountryRegionCode_Customer; "Country/Region Code")
            {
            }
            column(CountryName; CountryName)
            {
            }
            column(WithoutInvoice; WithoutInvoice)
            {
            }
            column(StateWiseTotal; StateWiseTotal)
            {
            }
            column(CountryWise; CountryWise)
            {
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                CalcFields = Amount;
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = WHERE("Document Type" = FILTER(Invoice));
                RequestFilterFields = "Posting Date";
                column(CustomerNo_CustLedgerEntry; "Customer No.")
                {
                }
                column(DocumentNo_CustLedgerEntry; "Document No.")
                {
                }
                column(Amount_CustLedgerEntry; Amount)
                {
                }
                column(DocumentType_CustLedgerEntry; "Document Type")
                {
                }
                column(DueDate_CustLedgerEntry; FORMAT("Due Date"))
                {
                }
                column(PostingDate_CustLedgerEntry; FORMAT("Posting Date"))
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                IF recCountery.GET(Customer."Country/Region Code") THEN
                    CountryName := recCountery.Name;
            end;

            trigger OnPreDataItem()
            begin
                CompInfo.GET;
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
                    field(WithoutInvoice; WithoutInvoice)
                    {
                        Caption = 'Without Invoice Detail';
                        ApplicationArea = all;

                        trigger OnValidate()
                        begin
                            IF WithoutInvoice = TRUE THEN BEGIN
                                StateWiseTotal := FALSE;
                                CountryWise := FALSE;
                            END;
                        end;
                    }
                    field(StateWiseTotal; StateWiseTotal)
                    {
                        Caption = 'State Wise Total';
                        ApplicationArea = all;

                        trigger OnValidate()
                        begin
                            IF StateWiseTotal = TRUE THEN BEGIN
                                WithoutInvoice := FALSE;
                                CountryWise := FALSE;
                            END;
                        end;
                    }
                    field(CountryWise; CountryWise)
                    {
                        Caption = 'Country Wise Total';
                        ApplicationArea = all;

                        trigger OnValidate()
                        begin
                            IF CountryWise = TRUE THEN BEGIN
                                StateWiseTotal := FALSE;
                                WithoutInvoice := FALSE;
                            END;
                        end;
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
        lblStateCode = 'County';
        lblCustomerName = 'Customer Name';
        lblCustomerNo = 'Customer No.';
        lblPostingDate = 'Posting Date';
        lblDueDate = 'Due Date';
        lblDocumentType = 'Document Type';
        lblAmount = 'Amount';
        lblTotalfor = 'Total for';
        lblTotal = 'Total';
        lblInvoiceNo = 'Invoice No.';
        lblCountry = 'Country';
    }

    var
        CompInfo: Record "Company Information";
        WithoutInvoice: Boolean;
        StateWiseTotal: Boolean;
        CountryWise: Boolean;
        recCountery: Record "Country/Region";
        CountryName: Text[50];
}

