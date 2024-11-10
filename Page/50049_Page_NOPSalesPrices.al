//Discard Function
// page 50049 "NOP Sales Prices"
// {
//     Caption = 'Sales Prices';
//     DataCaptionExpression = GetCaption;
//     DelayedInsert = true;
//     PageType = Worksheet;
//     SaveValues = true;
//     SourceTable = "Sales Price";

//     layout
//     {
//         area(content)
//         {
//             repeater(Control1)
//             {
//                 ShowCaption = false;
//                 field("Sales Type"; Rec."Sales Type")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Sales Code"; Rec."Sales Code")
//                 {
//                     ApplicationArea = All;
//                     Editable = "Sales CodeEditable";
//                 }
//                 field("Product Type"; Rec."Product Type")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Item No."; Rec."Item No.")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Product Code';
//                 }
//                 field("Currency Code"; Rec."Currency Code")
//                 {
//                     ApplicationArea = All;
//                     Visible = false;
//                 }
//                 field("Unit of Measure Code"; Rec."Unit of Measure Code")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Minimum Quantity"; Rec."Minimum Quantity")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Unit Price"; Rec."Unit Price")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Starting Date"; Rec."Starting Date")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Ending Date"; Rec."Ending Date")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Price Includes VAT"; Rec."Price Includes VAT")
//                 {
//                     ApplicationArea = All;
//                     Visible = false;
//                 }
//                 field("Allow Line Disc."; Rec."Allow Line Disc.")
//                 {
//                     ApplicationArea = All;
//                     Visible = false;
//                 }
//                 field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
//                 {
//                     ApplicationArea = All;
//                     Visible = false;
//                 }
//                 field("VAT Bus. Posting Gr. (Price)"; Rec."VAT Bus. Posting Gr. (Price)")
//                 {
//                     ApplicationArea = All;
//                     Visible = false;
//                 }
//                 field("Location Code"; Rec."Location Code")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(txtSalesCodeDesc; txtSalesCodeDesc)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Sales Code Description';
//                     Editable = false;
//                 }
//                 field(txtProductdes; txtProductdes)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Product Group Type';
//                 }
//                 field(decStandardPrice; decStandardPrice)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Product Group Price';
//                 }
//                 field(Discontinued; Rec.Discontinued)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Last Modified Date"; Rec."Last Modified Date")
//                 {
//                     ApplicationArea = All;
//                     Editable = false;
//                 }
//                 field("Last Modified User"; Rec."Last Modified User")
//                 {
//                     ApplicationArea = All;
//                     Editable = false;
//                 }
//                 field("Update Price NOP"; Rec."Update Price NOP")
//                 {
//                     ApplicationArea = All;
//                 }
//             }
//         }
//     }

//     actions
//     {
//     }

//     trigger OnAfterGetCurrRecord()
//     begin
//         "Sales CodeEditable" := Rec."Sales Type" <> Rec."Sales Type"::"All Customers"
//     end;

//     trigger OnAfterGetRecord()
//     begin
//         if Rec."Sales Type" = Rec."Sales Type"::"Customer Price Group" then begin
//             if recCustPrice.Get(Rec."Sales Code") then
//                 txtSalesCodeDesc := recCustPrice.Description
//             else
//                 txtSalesCodeDesc := '';

//         end else begin
//             if Rec."Sales Type" = Rec."Sales Type"::Customer then begin
//                 if recCustomer.Get(Rec."Sales Code") then
//                     txtSalesCodeDesc := recCustomer.Name
//                 else
//                     txtSalesCodeDesc := '';
//             end else begin
//                 if Rec."Sales Type" = Rec."Sales Type"::Campaign then begin
//                     if recCampaign.Get(Rec."Sales Code") then
//                         txtSalesCodeDesc := recCampaign.Description
//                     else
//                         txtSalesCodeDesc := '';
//                 end;
//             end;
//         end;

//         txtProductdes := '';
//         decStandardPrice := 0;
//         if Rec."Sales Type" = Rec."Sales Type"::Customer then begin
//             recCust.Get(Rec."Sales Code");
//             recSalesPrice.Reset;
//             recSalesPrice.SetRange("Sales Type", recSalesPrice."Sales Type"::"Customer Price Group");
//             recSalesPrice.SetRange("Sales Code", recCust."Customer Price Group");
//             //recSalesPrice.SETRANGE("Product Type",recSalesPrice."Product Type"::"Product Group");
//             recSalesPrice.SetRange("Item No.", Rec."Item No.");
//             if recSalesPrice.FindSet then begin
//                 repeat
//                     txtProductdes := recSalesPrice."Sales Code";
//                     decStandardPrice := recSalesPrice."Unit Price";
//                 until recSalesPrice.Next = 0;
//             end;
//         end;
//     end;

//     trigger OnInit()
//     begin
//         SalesCodeFilterCtrlEnable := true;
//         "Sales CodeEditable" := true;
//     end;

//     trigger OnOpenPage()
//     begin
//         //GetRecFilters;
//         //SetRecFilters;
//     end;

//     var
//         Cust: Record Customer;
//         CustPriceGr: Record "Customer Price Group";
//         Campaign: Record Campaign;
//         SalesTypeFilter: Option Customer,"Customer Price Group","All Customers",Campaign,"None";
//         SalesCodeFilter: Text[250];
//         ItemNoFilter: Text[250];
//         StartingDateFilter: Text[30];
//         CurrencyCodeFilter: Text[250];
//         Text000: Label 'All Customers';
//         Text001: Label 'No %1 within the filter %2.';
//         
//         "Sales CodeEditable": Boolean;
//         
//         SalesCodeFilterCtrlEnable: Boolean;
//         txtSalesCodeDesc: Text[50];
//         recCustPrice: Record "Customer Price Group";
//         recCampaign: Record Campaign;
//         recCustomer: Record Customer;
//         recSalesPrice: Record "Sales Price";
//         txtProductdes: Text[50];
//         decStandardPrice: Decimal;
//         recCust: Record Customer;
//         Expired: Boolean;

//     procedure GetRecFilters()
//     begin
//         if Rec.GetFilters <> '' then begin
//             if Rec.GetFilter("Sales Type") <> '' then
//                 SalesTypeFilter := GetSalesTypeFilter
//             else
//                 SalesTypeFilter := SalesTypeFilter::None;

//             SalesCodeFilter := Rec.GetFilter("Sales Code");
//             ItemNoFilter := Rec.GetFilter("Item No.");
//             CurrencyCodeFilter := Rec.GetFilter("Currency Code");
//         end;

//         Evaluate(StartingDateFilter, Rec.GetFilter("Starting Date"));
//     end;

//     procedure SetRecFilters()
//     begin
//         SalesCodeFilterCtrlEnable := true;

//         if SalesTypeFilter <> SalesTypeFilter::None then
//             Rec.SetRange("Sales Type", SalesTypeFilter)
//         else
//             Rec.SetRange("Sales Type");

//         if SalesTypeFilter in [SalesTypeFilter::"All Customers", SalesTypeFilter::None] then begin
//             SalesCodeFilterCtrlEnable := false;
//             SalesCodeFilter := '';
//         end;

//         if SalesCodeFilter <> '' then
//             Rec.SetFilter("Sales Code", SalesCodeFilter)
//         else
//             Rec.SetRange("Sales Code");

//         if StartingDateFilter <> '' then
//             Rec.SetFilter("Starting Date", StartingDateFilter)
//         else
//             Rec.SetRange("Starting Date");

//         if ItemNoFilter <> '' then begin
//             Rec.SetFilter("Item No.", ItemNoFilter);
//         end else
//             Rec.SetRange("Item No.");

//         if CurrencyCodeFilter <> '' then begin
//             Rec.SetFilter("Currency Code", CurrencyCodeFilter);
//         end else
//             Rec.SetRange("Currency Code");

//         case SalesTypeFilter of
//             SalesTypeFilter::Customer:
//                 CheckFilters(DATABASE::Customer, SalesCodeFilter);
//             SalesTypeFilter::"Customer Price Group":
//                 CheckFilters(DATABASE::"Customer Price Group", SalesCodeFilter);
//             SalesTypeFilter::Campaign:
//                 CheckFilters(DATABASE::Campaign, SalesCodeFilter);
//         end;
//         CheckFilters(DATABASE::Item, ItemNoFilter);
//         CheckFilters(DATABASE::Currency, CurrencyCodeFilter);

//         CurrPage.Update(false);
//     end;

//     procedure GetCaption(): Text[250]
//     var
//         ObjTransl: Record "Object Translation";
//         SourceTableName: Text[100];
//         SalesSrcTableName: Text[100];
//         Description: Text[250];
//     begin
//         GetRecFilters;
//         "Sales CodeEditable" := Rec."Sales Type" <> Rec."Sales Type"::"All Customers";

//         SourceTableName := '';
//         if ItemNoFilter <> '' then
//             SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 27);

//         SalesSrcTableName := '';
//         case SalesTypeFilter of
//             SalesTypeFilter::Customer:
//                 begin
//                     SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 18);
//                     Cust."No." := SalesCodeFilter;
//                     if Cust.Find then
//                         Description := Cust.Name;
//                 end;
//             SalesTypeFilter::"Customer Price Group":
//                 begin
//                     SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 6);
//                     CustPriceGr.Code := SalesCodeFilter;
//                     if CustPriceGr.Find then
//                         Description := CustPriceGr.Description;
//                 end;
//             SalesTypeFilter::Campaign:
//                 begin
//                     SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 5071);
//                     Campaign."No." := SalesCodeFilter;
//                     if Campaign.Find then
//                         Description := Campaign.Description;
//                 end;
//             SalesTypeFilter::"All Customers":
//                 begin
//                     SalesSrcTableName := Text000;
//                     Description := '';
//                 end;
//         end;

//         if SalesSrcTableName = Text000 then
//             exit(StrSubstNo('%1 %2 %3', SalesSrcTableName, SourceTableName, ItemNoFilter));
//         exit(StrSubstNo('%1 %2 %3 %4 %5', SalesSrcTableName, SalesCodeFilter, Description, SourceTableName, ItemNoFilter));
//     end;

//     procedure CheckFilters(TableNo: Integer; FilterTxt: Text[250])
//     var
//         FilterRecordRef: RecordRef;
//         FilterFieldRef: FieldRef;
//     begin
//         if FilterTxt = '' then
//             exit;
//         Clear(FilterRecordRef);
//         Clear(FilterFieldRef);
//         FilterRecordRef.Open(TableNo);
//         FilterFieldRef := FilterRecordRef.Field(1);
//         FilterFieldRef.SetFilter(FilterTxt);
//         if FilterRecordRef.IsEmpty then
//             Error(Text001, FilterRecordRef.Caption, FilterTxt);
//     end;

//     local procedure SalesCodeFilterOnAfterValidate()
//     begin
//         CurrPage.SaveRecord;
//         SetRecFilters;
//     end;

//     local procedure SalesTypeFilterOnAfterValidate()
//     begin
//         CurrPage.SaveRecord;
//         SalesCodeFilter := '';
//         SetRecFilters;
//     end;

//     local procedure StartingDateFilterOnAfterValid()
//     begin
//         CurrPage.SaveRecord;
//         SetRecFilters;
//     end;

//     local procedure ItemNoFilterOnAfterValidate()
//     begin
//         CurrPage.SaveRecord;
//         SetRecFilters;
//     end;

//     local procedure CurrencyCodeFilterOnAfterValid()
//     begin
//         CurrPage.SaveRecord;
//         SetRecFilters;
//     end;

//     local procedure GetSalesTypeFilter(): Integer
//     begin
//         case Rec.GetFilter("Sales Type") of
//             Format(Rec."Sales Type"::Customer):
//                 exit(0);
//             Format(Rec."Sales Type"::"Customer Price Group"):
//                 exit(1);
//             Format(Rec."Sales Type"::"All Customers"):
//                 exit(2);
//             Format(Rec."Sales Type"::Campaign):
//                 exit(3);
//         end;
//     end;
// }

