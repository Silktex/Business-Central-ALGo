xmlport 50000 "bin update"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(Bin; Bin)
            {
                XmlName = 'BIN';
                fieldelement(location; Bin."Location Code")
                {
                }
                fieldelement(code; Bin.Code)
                {
                }
                fieldelement(zonecode; Bin."Zone Code")
                {
                }
                fieldelement(bintype; Bin."Bin Type Code")
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

