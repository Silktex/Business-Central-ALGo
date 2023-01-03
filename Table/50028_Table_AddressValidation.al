table 50028 "Address Validation"
{
    DrillDownPageID = 50014;
    LookupPageID = 50014;

    fields
    {
        field(1; "Customer No."; Code[20])
        {
        }
        field(2; "Customer Name"; Text[50])
        {
        }
        field(4; "Customer Name 2"; Text[50])
        {
        }
        field(5; "Customer Address"; Text[50])
        {
        }
        field(6; "Customer Address 2"; Text[50])
        {
        }
        field(7; "Customer City"; Text[30])
        {
        }
        field(9; "Customer Phone No."; Text[30])
        {
        }
        field(35; "Customer Country/Region Code"; Code[10])
        {
        }
        field(91; "Customer Post Code"; Code[20])
        {
        }
        field(92; "Customer County"; Text[30])
        {
        }
        field(102; "Customer E-Mail"; Text[80])
        {
        }
        field(13722; "Customer State Code"; Code[10])
        {
        }
        field(55000; DPV; Boolean)
        {
        }
        field(55001; EncompassingZIP; Boolean)
        {
        }
        field(55002; InterpolatedStreetAddress; Boolean)
        {
        }
        field(55003; MultipleMatches; Boolean)
        {
        }
        field(55004; OrganizationValidated; Boolean)
        {
        }
        field(55005; PostalValidated; Boolean)
        {
        }
        field(55006; StreetAddress; Boolean)
        {
        }
        field(55007; Resolved; Boolean)
        {
        }
        field(55009; "Address State"; Text[50])
        {
        }
        field(55010; Classification; Text[50])
        {
        }
        field(55011; StreetLines; Text[100])
        {
        }
        field(55012; City; Text[30])
        {
        }
        field(55013; StateOrProvinceCode; Text[5])
        {
        }
        field(55014; PostalCode; Text[11])
        {
        }
        field(55015; UrbanizationCode; Text[30])
        {
        }
        field(55016; CountryCode; Text[5])
        {
        }
        field(55017; HighestSeverity; Text[30])
        {
        }
        field(55018; Severity; Text[30])
        {
        }
        field(55019; Message; Text[250])
        {
        }
        field(55020; "StreetLines 2"; Text[100])
        {
        }
        field(55021; "Ship-To Code"; Code[20])
        {
        }
        field(55022; "Sales Order No"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Customer No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

