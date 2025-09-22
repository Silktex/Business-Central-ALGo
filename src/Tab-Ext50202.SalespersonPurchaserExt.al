tableextension 50202 SalespersonPurchaser_Ext extends "Salesperson/Purchaser"
{
    fields
    {
        field(50000; "Mail To"; Boolean)
        {

            trigger OnValidate()
            begin
                IF "Mail To" THEN BEGIN
                    "Mail CC" := FALSE;
                    "Mail BCC" := FALSE;
                END;
            end;
        }
        field(50001; "Mail CC"; Boolean)
        {

            trigger OnValidate()
            begin
                IF "Mail CC" THEN BEGIN
                    "Mail To" := FALSE;
                    "Mail BCC" := FALSE;
                END;
            end;
        }
        field(50002; "Mail BCC"; Boolean)
        {

            trigger OnValidate()
            begin
                IF "Mail BCC" THEN BEGIN
                    "Mail To" := FALSE;
                    "Mail CC" := FALSE;
                END;
            end;
        }
        field(50003; "Sales Order"; Boolean)
        {
        }
        field(50004; "Sales Shipment"; Boolean)
        {
        }
        field(50005; "Sales Invoice"; Boolean)
        {
        }
        field(50008; Comment; Text[150])
        {
            DataClassification = ToBeClassified;
            Description = 'Ecom';
        }
        field(50010; Address; Text[50])
        {
            Caption = 'Address';
            Description = 'Ecom';
        }
        field(50011; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
            Description = 'Ecom';
        }
        field(50012; City; Text[30])
        {
            Caption = 'City';
            Description = 'Ecom';
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(50013; "Post Code"; Code[20])
        {
            Caption = 'ZIP Code';
            Description = 'Ecom';
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code" ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(50014; County; Text[30])
        {
            Caption = 'State';
            Description = 'Ecom';
        }
        field(50015; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            Description = 'Ecom';
            TableRelation = "Country/Region";
        }
        field(50016; Active; Boolean)
        {
            Description = 'Ecom';
        }
        field(50017; Published; Boolean)
        {
            Description = 'ECOM';
        }

        field(50018; "Active MIS"; Boolean)
        {
            Description = 'Active MIS';
        }

    }
}
