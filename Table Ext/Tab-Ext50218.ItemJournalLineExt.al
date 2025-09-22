tableextension 50218 "Item Journal Line_Ext" extends "Item Journal Line"
{
    fields
    {
        field(50000; "Quality Grade"; Option)
        {
            OptionCaption = ' ,A,B,C,D,E,F,X';
            OptionMembers = " ",A,B,C,D,E,F,X;
        }
        field(50001; "Dylot No."; Code[20])
        {
        }
        field(50002; "ETA Date"; Date)
        {
        }

    }
}
