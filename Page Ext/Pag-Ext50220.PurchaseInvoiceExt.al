pageextension 50220 "Purchase Invoice_Ext" extends "Purchase Invoice"
{
    layout
    {
        addafter("On Hold")
        {
            field("Ship Via"; Rec."Ship Via")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        modify(Flow)
        {
            Visible = false;
        }
        modify(CreateFlow)
        {
            Visible = false;
        }
        modify(SeeFlows)
        {
            Visible = false;
        }
    }
}
