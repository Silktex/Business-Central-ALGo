table 50012 "TLI Stax Payment Link"
{
    Caption = 'Stax Payment Link';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Order,Invoice,Payment,Refund';
            OptionMembers = " ","Order",Invoice,Payment,Refund;
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(3; "Payment Link Id"; Text[100])
        {
            Caption = 'Payment Link Id';
        }
        field(4; "Tiny Url"; Text[250])
        {
            Caption = 'Tiny Url';
        }
        field(5; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,Generated,Success,Failed,Cancelled';
            OptionMembers = " ",Generated,Success,Failed,Cancelled;
        }
        field(6; Active; Boolean)
        {
            Caption = 'Active';
        }
        field(7; "Common Name"; Text[100])
        {
            Caption = 'Common Name';
        }
        field(8; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(9; "Total Sales"; Decimal)
        {
            Caption = 'Total Sales';
        }
        field(10; "Total Transactions"; Decimal)
        {
            Caption = 'Total Transactions';
        }
        field(11; Message; Text[100])
        {
            Caption = 'Message';
        }
    }
    keys
    {
        key(PK; "Document Type", "Document No.")
        {
            Clustered = true;
        }
    }
}
