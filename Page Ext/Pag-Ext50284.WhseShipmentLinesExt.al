pageextension 50284 "Whse. Shipment Lines_Ext" extends "Whse. Shipment Lines"
{
    layout
    {
        addafter("Line No.")
        {
            field("Quantity To Pack"; Rec."Quantity To Pack")
            {
                ApplicationArea = all;
            }
            field("Qty. to Ship"; Rec."Qty. to Ship")
            {
                ApplicationArea = all;
            }
            field("Quantity Packed"; Rec."Quantity Packed")
            {
                ApplicationArea = all;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if txtPacking2 = 'PackLine' then begin
            Rec.SetCurrentKey("No.");
            Rec.FilterGroup(2);
            Rec.SetRange("No.", DocumentNo2);

            Rec.FilterGroup(0);

        end;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = ACTION::LookupOK then
            LookupOKOnPush;
    end;

    var
        PackinItem2: Record "Packing Item List";
        DocumentNo2: Code[20];
        txtPacking2: Text[30];
        FromWhseShptLine: Record "Warehouse Shipment Line";
        cuPackLine: Codeunit Packing;

    procedure Initialize(PackinItem: Record "Packing Item List"; DocumentNo: Code[20]; txtPacking: Text[30])
    begin
        PackinItem2 := PackinItem;
        DocumentNo2 := DocumentNo;
        txtPacking2 := txtPacking;
    end;

    local procedure LookupOKOnPush()
    begin
        FromWhseShptLine.Copy(Rec);
        CurrPage.SetSelectionFilter(FromWhseShptLine);
        if FromWhseShptLine.FindFirst then
            if txtPacking2 = 'PackLine' then
                cuPackLine.CreateWhsePackingLine(FromWhseShptLine, PackinItem2);
    end;
}
