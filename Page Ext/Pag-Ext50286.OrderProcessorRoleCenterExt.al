pageextension 50286 OrderProcessorRoleCenter_Ext extends "Order Processor Role Center"
{
    actions
    {
        addafter("Navi&gate")
        {
            action(MIS)
            {
                Caption = 'MIS';
                Image = Report2;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "MIS Report";
                ApplicationArea = all;
            }
        }
    }
}
