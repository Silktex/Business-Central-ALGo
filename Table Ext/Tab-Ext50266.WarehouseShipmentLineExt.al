tableextension 50266 "Warehouse Shipment Line_Ext" extends "Warehouse Shipment Line"
{
    fields
    {
        modify("Qty. to Ship")
        {
            trigger OnAfterValidate()
            var
                recItem: Record Item;
            begin
                recItem.GET("Item No.");
                "Net Weight" := "Qty. to Ship" * recItem.Weight;
            end;
        }
        modify("Qty. Picked")
        {
            trigger OnAfterValidate()
            begin
                "Quantity To Pack" := "Qty. Picked";
            end;
        }
        field(50000; "Net Weight"; Decimal)
        {
        }
        field(50001; "Quantity To Pack"; Decimal)
        {
        }
        field(50002; "Quantity Packed"; Decimal)
        {
        }
        field(50003; "Original Quantity"; Decimal)
        {
        }
        field(50050; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(50052; "Tariff No."; Code[20])
        {
            Caption = 'Tariff No.';
            TableRelation = "Tariff Number";
        }
        field(50053; "Country/Region Purchased Code"; Code[10])
        {
            Caption = 'Country/Region Purchased Code';
            TableRelation = "Country/Region";
        }

    }
}
