tableextension 50221 "Sales Shipment Line_Ext" extends "Sales Shipment Line"
{
    fields
    {
        field(50006; "Quantity Variance %"; Decimal)
        {
        }
        field(50007; "Original Quantity"; Decimal)
        {
        }
        field(50008; "Customer Item No."; Text[30])
        {
        }
        field(50050; Observation; Code[10])
        {
            Description = 'spdspl sushant';
            TableRelation = "Return Reason";
        }
        field(50051; "Shipment Tracking No."; Text[30])
        {
            CalcFormula = Lookup("Sales Shipment Header"."Tracking No." WHERE("No." = FIELD("Document No.")));
            Description = 'NOP';
            FieldClass = FlowField;
        }
        field(50052; "Shipping Agent Code"; Code[10])
        {
            CalcFormula = Lookup("Sales Shipment Header"."Shipping Agent Code" WHERE("No." = FIELD("Document No.")));
            Caption = 'Shipping Agent Code';
            Description = 'NOP';
            FieldClass = FlowField;
            TableRelation = "Shipping Agent";
        }
    }
}
