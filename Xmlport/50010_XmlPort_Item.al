xmlport 50010 Item
{

    schema
    {
        textelement(Root)
        {
            tableelement(Item; Item)
            {
                XmlName = 'recItem';
                fieldattribute(ItemNo; Item."No.")
                {
                }
                fieldattribute(ItemDescription; Item.Description)
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}

