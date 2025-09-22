page 50072 "Lot No. List Handheld"
{
    DataCaptionExpression = GetCaption;
    DataCaptionFields = "Item No.";
    PageType = List;
    SourceTable = "Item Ledger Entry";
    SourceTableView = WHERE("Remaining Quantity" = FILTER(<> 0));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = All;
                    Caption = 'Total Quantity';
                    Editable = false;
                    Visible = true;
                }
                field("Total Requested-HH"; Rec."Total Requested-HH")
                {
                    ApplicationArea = All;
                    Caption = 'Total Requested Quantity';
                }
                field("Total AvailableQuantity"; TotalAvailableQuantity)
                {
                    ApplicationArea = All;
                    Caption = 'Total Available Quantity';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        TotalAvailableQuantity := Rec."Remaining Quantity" + Rec."Total Requested-HH";
    end;

    var
        Navigate: Page Navigate;
        TotalAvailableQuantity: Decimal;

    procedure GetCaption(): Text[250]
    var
        GLSetup: Record "General Ledger Setup";
        ObjTransl: Record "Object Translation";
        Item: Record Item;
        ProdOrder: Record "Production Order";
        Cust: Record Customer;
        Vend: Record Vendor;
        Dimension: Record Dimension;
        DimValue: Record "Dimension Value";
        SourceTableName: Text[100];
        SourceFilter: Text[200];
        Description: Text[100];
    begin
        Description := '';

        case true of
            Rec.GetFilter("Item No.") <> '':
                begin
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 27);
                    SourceFilter := Rec.GetFilter("Item No.");
                    if MaxStrLen(Item."No.") >= StrLen(SourceFilter) then
                        if Item.Get(SourceFilter) then
                            Description := Item.Description;
                end;
            (Rec.GetFilter("Order No.") <> '') and (Rec."Order Type" = Rec."Order Type"::Production):
                begin
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 5405);
                    SourceFilter := Rec.GetFilter("Order No.");
                    if MaxStrLen(ProdOrder."No.") >= StrLen(SourceFilter) then
                        if ProdOrder.Get(ProdOrder.Status::Released, SourceFilter) or
                           ProdOrder.Get(ProdOrder.Status::Finished, SourceFilter)
                        then begin
                            SourceTableName := StrSubstNo('%1 %2', ProdOrder.Status, SourceTableName);
                            Description := ProdOrder.Description;
                        end;
                end;
            Rec.GetFilter("Source No.") <> '':
                case Rec."Source Type" of
                    Rec."Source Type"::Customer:
                        begin
                            SourceTableName :=
                              ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 18);
                            SourceFilter := Rec.GetFilter("Source No.");
                            if MaxStrLen(Cust."No.") >= StrLen(SourceFilter) then
                                if Cust.Get(SourceFilter) then
                                    Description := Cust.Name;
                        end;
                    Rec."Source Type"::Vendor:
                        begin
                            SourceTableName :=
                              ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 23);
                            SourceFilter := Rec.GetFilter("Source No.");
                            if MaxStrLen(Vend."No.") >= StrLen(SourceFilter) then
                                if Vend.Get(SourceFilter) then
                                    Description := Vend.Name;
                        end;
                end;
            Rec.GetFilter("Global Dimension 1 Code") <> '':
                begin
                    GLSetup.Get;
                    Dimension.Code := GLSetup."Global Dimension 1 Code";
                    SourceFilter := Rec.GetFilter("Global Dimension 1 Code");
                    SourceTableName := Dimension.GetMLName(GlobalLanguage);
                    if MaxStrLen(DimValue.Code) >= StrLen(SourceFilter) then
                        if DimValue.Get(GLSetup."Global Dimension 1 Code", SourceFilter) then
                            Description := DimValue.Name;
                end;
            Rec.GetFilter("Global Dimension 2 Code") <> '':
                begin
                    GLSetup.Get;
                    Dimension.Code := GLSetup."Global Dimension 2 Code";
                    SourceFilter := Rec.GetFilter("Global Dimension 2 Code");
                    SourceTableName := Dimension.GetMLName(GlobalLanguage);
                    if MaxStrLen(DimValue.Code) >= StrLen(SourceFilter) then
                        if DimValue.Get(GLSetup."Global Dimension 2 Code", SourceFilter) then
                            Description := DimValue.Name;
                end;
            Rec.GetFilter("Document Type") <> '':
                begin
                    SourceTableName := Rec.GetFilter("Document Type");
                    SourceFilter := Rec.GetFilter("Document No.");
                    Description := Rec.GetFilter("Document Line No.");
                end;
        end;
        exit(StrSubstNo('%1 %2 %3', SourceTableName, SourceFilter, Description));
    end;
}

