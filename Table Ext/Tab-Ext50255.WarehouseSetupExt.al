tableextension 50255 "Warehouse Setup_Ext" extends "Warehouse Setup"
{
    fields
    {
        field(50000; "Image Path"; Text[100])
        {
        }
        field(50001; "Packing No."; Code[10])
        {
            TableRelation = "No. Series";
        }
    }
}
