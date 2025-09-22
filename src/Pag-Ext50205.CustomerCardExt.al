pageextension 50205 CustomerCard_Ext extends "Customer Card"
{
    layout
    {
        modify(Name)
        {
            trigger OnBeforeValidate()
            begin
                IF (Rec.Name <> xRec.Name) THEN
                    Rec.AddressValidated := FALSE;
            end;
        }
        modify("Name 2")
        {
            Visible = true;
        }
        addafter("Last Date Modified")
        {
            field("Future Old Invoice"; Rec."Future Old Invoice")
            {
                Visible = false;
                ApplicationArea = all;
            }
            field("Sales Price Expire Days"; Rec."Sales Price Expire Days")
            {
                ApplicationArea = all;
            }
            field("No insurance"; Rec."No insurance")
            {
                ApplicationArea = all;
            }

        }
        addafter(General)
        {
            group("ECOM Fields")
            {
                Caption = 'ECOM Fields';
                field(HasShoppingCartItems; Rec.HasShoppingCartItems)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Published; Rec.Published)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        moveafter(HasShoppingCartItems; Balance)
        modify(Balance)
        {
            Visible = true;

        }
        moveafter(Published; "Disable Search by Name")
        modify("Disable Search by Name")
        {
            Visible = true;
        }
        modify(Address)
        {
            CaptionML = ENU = 'Address',
                           ESM = 'Direcci¢n',
                           FRC = 'Adresse',
                           ENC = 'Address';

            trigger OnbeforeValidate()
            begin
                if (Rec.Address <> xRec.Address) then begin
                    Rec.AddressValidated := false;
                end
            end;
        }
        modify("Address 2")
        {
            trigger OnBeforeValidate()
            begin
                if (Rec."Address 2" <> xRec."Address 2") then begin
                    Rec.AddressValidated := false;
                end
            end;
        }
        modify(City)
        {
            trigger OnBeforeValidate()
            begin
                if (Rec.City <> xRec.City) then begin
                    Rec.AddressValidated := false;
                end
            end;
        }
        addafter("E-Mail")
        {
            field("Email CC"; Rec."Email CC")
            {
                ApplicationArea = all;
            }
        }
        addafter("Preferred Bank Account Code")
        {
            field("Schedule Day"; Rec."Schedule Day")
            {
                ApplicationArea = all;
            }
        }
        addafter("Base Calendar Code")
        {
            field("Shipping Account No."; Rec."Shipping Account No.")
            {
                Caption = 'FedEx Account No.';
                ApplicationArea = all;
            }
            field("UPS Account No."; Rec."UPS Account No.")
            {
                ApplicationArea = all;
            }
            field(Residential; Rec.Residential)
            {
                ApplicationArea = all;
            }
            field(AddressValidated; Rec.AddressValidated)
            {
                ApplicationArea = all;
            }
        }
        addafter(CustomerStatisticsFactBox)
        {
            part(CustomerAgingFactBox; "Customer Aging FactBox")
            {
                Caption = 'Customer Aging';
                ApplicationArea = all;
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
            }
        }
        addbefore("Primary Contact No.")
        {
            field("PI Contact"; Rec."PI Contact")
            {
                ApplicationArea = all;
            }
        }
        addlast(Payments)
        {
            field("Stax Customer ID"; Rec."Stax Customer ID")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addbefore("Post Cash Receipts")
        {
            action("FedEx Address Validation")
            {
                Caption = 'FedEx Address Validation';
                Image = "Action";
                ApplicationArea = all;

                trigger OnAction()
                begin
                    if ((Rec."Country/Region Code" = 'US') or (Rec."Country/Region Code" = 'CA')) and (not Rec.AddressValidated) then
                        AddressValidation.USAddressValidationJsonCustomer(Rec, '');
                end;
            }
        }
        addafter("Sales Journal")
        {
            action(SaleDetail)
            {
                Caption = 'Sale Detail';
                Image = LedgerEntries;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Ecom Customer List";
                RunPageOnRec = true;
                ApplicationArea = all;
            }
        }

        modify("Aged Accounts Receivable")
        {
            Visible = false;
        }
        addbefore("Customer Labels")
        {
            action("Aged Accounts Receivable Ext")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Aged Accounts Receivable';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                ToolTip = 'View, print, or save an overview of when customer payments are due or overdue, divided into four periods. You must specify the date you want aging calculated from and the length of the period that each column will contain data for.';

                trigger OnAction()
                begin
                    RunReport(REPORT::"Aged Accounts Receivable Ext", rec."No.");
                end;
            }

        }
    }

    trigger OnClosePage()
    var
        myAnswer: Integer;
        //Xmlhttp: Automation;
        Result: Boolean;
        txtURL: Text;
    begin
        if ((Rec."Country/Region Code" = 'US') or (Rec."Country/Region Code" = 'CA')) and (not Rec.AddressValidated) then
            AddressValidation.USAddressValidationJsonCustomer(Rec, '');
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        Rec.TestField("Country/Region Code");
        Rec.TestField("Phone No.");
    end;

    var
        cuTest: Codeunit "Integration Fedex UPS";
        //  Xmlhttp: Automation;
        //HttpWebResponse: DotNet WebResponse;
        RecCompanyInfo: Record "Company Information";
        Result: Boolean;
        txtURL: Text;
        recCompInfo: Record "Company Information";
        AddressValidation: Codeunit "Address Validation";

    procedure CreateNOPCustomer(Name: Text[50]; Email: Text[80]; AdminComment: Text[250]; HasShopingCart: Boolean; Active: Boolean; Deleated: Text; CustomerPriceGroup: Code[20])
    var
        recCustomer: Record Customer;
    begin
        recCustomer.Init;
        recCustomer."No." := '';
        recCustomer.Name := Name;
        recCustomer.AdminComments := AdminComment;
        recCustomer.HasShoppingCartItems := HasShopingCart;
        recCustomer.Active := Active;
        recCustomer."E-Mail" := Email;
        if Deleated = '' then
            recCustomer.Blocked := recCustomer.Blocked::" "
        else
            recCustomer.Blocked := recCustomer.Blocked::All;
        recCustomer."Customer Price Group" := CustomerPriceGroup;
        recCustomer.Insert(true);
    end;

}
