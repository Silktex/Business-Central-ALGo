tableextension 50267 "Posted WhseShipmentHeader_Ext" extends "Posted Whse. Shipment Header"
{
    fields
    {
        field(50000; "Freight Amount"; Decimal)
        {
        }
        field(50007; Picture; BLOB)
        {
        }
        field(50055; "Third Party"; Boolean)
        {
        }
        field(50056; "Third Party Account No."; Code[20])
        {
        }
    }
}
