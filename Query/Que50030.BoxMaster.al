query 50030 "Box Master"
{
    Caption = 'Box Master';
    QueryType = Normal;

    elements
    {
        dataitem(BoxMaster; "Box Master")
        {
            column(BoxCode; "Box Code")
            {
            }
            column(BoxWeight; "Box Weight")
            {
            }
            column(Description; Description)
            {
            }
            column(Height; Height)
            {
            }
            column(Length; Length)
            {
            }
            column(ShippingAgentServiceCode; "Shipping Agent Service Code")
            {
            }
            column(ShowinHandheld; "Show in Handheld")
            {
            }
            column(Width; Width)
            {
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
