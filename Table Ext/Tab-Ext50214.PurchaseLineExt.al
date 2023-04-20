tableextension 50214 PurchaseLine_Ext extends "Purchase Line"
{
    fields
    {
        field(50000; "Quantity Variance %"; Decimal)
        {
        }
        field(50001; "Original Quantity"; Decimal)
        {

            trigger OnValidate()
            begin
                TestStatusOpen;
                VALIDATE(Quantity, "Original Quantity");
            end;
        }
        field(50023; "Avoid Error"; Boolean)
        {
        }
        field(50024; "Ready Goods Qty"; Decimal)
        {
        }
        field(50025; "Last Change"; Date)
        {
        }
        field(50026; "Ready Goods Comment"; Text[200])
        {
            Caption = 'Mill Comments/ Dtd.Dt.';
        }
        field(50027; "ETA Date"; Date)
        {
        }
        field(50028; "Shipped Air"; Decimal)
        {
        }
        field(50029; "Shipped Boat"; Decimal)
        {
        }
        field(50030; "Balance Qty"; Decimal)
        {
        }
        field(50031; "Priority Qty"; Decimal)
        {
        }
        field(50032; "Priority Date"; Date)
        {
        }
        field(50033; "Shipping Hold"; Decimal)
        {
        }
        field(50034; "Shipping Comment"; Text[200])
        {
        }
        field(50035; Comment; Text[250])
        {
        }

        field(50036; Backing; Option)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Backing WHERE("No." = Field("No.")));
            Caption = 'Backing';
            OptionMembers = " ",Prebacked,"To be Backed","TO BE BACKED+C6","Alta is Required";

            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
        }
        field(50060; "Priority Qty 2"; Decimal)
        {
        }
        field(50061; "Priority Date 2"; Date)
        {
        }
        field(50062; "Priority Qty 3"; Decimal)
        {
        }
        field(50063; "Priority Date 3"; Date)
        {
        }
        field(50064; "Comment for Vendor"; Text[250])
        {
            Caption = 'Silk crafts comments dtd.';
        }
        field(50100; "Ready Goods Date"; Date)
        {
        }
        field(50101; "Balance Qty Date"; Date)
        {
        }
    }
}
