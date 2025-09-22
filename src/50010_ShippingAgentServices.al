query 50010 "Shipping Agent Services"
{
    QueryType = Normal;

    elements
    {
        dataitem(Shipping_Agent_Services; "Shipping Agent Services")
        {
            column(Shipping_Agent_Code; "Shipping Agent Code")
            {

            }
            column(Code; Code)
            {

            }
            column(Description; Description)
            { }
            column(Shipping_Time; "Shipping Time")
            { }
            column(Base_Calendar_Code; "Base Calendar Code")
            { }
        }
    }

    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}