pageextension 50272 "Sales Return Order Subform_Ext" extends "Sales Return Order Subform"
{
    layout
    {
        addafter("Return Reason Code")
        {
            field(Observation; Rec.Observation)
            {
                ApplicationArea = all;
            }
        }
        addafter("Return Qty. to Receive")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
