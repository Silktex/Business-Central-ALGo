tableextension 50001 "SLK Reg. Whse. Activity Line" extends "Registered Whse. Activity Line"
{
    fields
    {
        field(50000; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Unit Price" where("Document Type" = filter(Order), "Document No." = field("Source No."), "Line No." = field("Source Line No.")));
            Editable = false;
        }
    }
}
