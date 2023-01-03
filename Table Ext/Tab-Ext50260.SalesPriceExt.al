tableextension 50260 "Sales Price_Ext" extends "Price List Line"
{
    fields
    {
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            begin
                "Last Modified Date" := TODAY;
                "Last Modified User" := USERID;
                "Update Price NOP" := TRUE;
            end;
        }
        modify("Minimum Quantity")
        {
            trigger OnAfterValidate()
            begin
                "Last Modified Date" := TODAY;
                "Last Modified User" := USERID;
                "Update Price NOP" := TRUE;
            end;
        }
        field(50000; "Product Type"; Option)
        {
            OptionCaption = ',Item,Item Category';
            OptionMembers = ,Item,"Item Category";
        }
        field(50001; "Location Code"; Code[10])
        {
            TableRelation = Location;
        }
        field(50002; Expired; Boolean)
        {
        }
        field(50003; Discontinued; Option)
        {
            InitValue = Active;
            OptionCaption = 'Active,Inactive,Discontinued';
            OptionMembers = Active,Inactive,Discontinued;
        }
        field(50004; "Last Modified Date"; Date)
        {
        }
        field(50005; "Last Modified User"; Code[50])
        {
        }
        field(50006; "Update Price NOP"; Boolean)
        {
            Description = 'NOP';
        }
        field(50007; "Customer Posting Group"; Code[20])
        {
            CalcFormula = Lookup(Customer."Customer Posting Group" WHERE("No." = FIELD("Source No.")));
            Caption = 'Customer Posting Group';
            FieldClass = FlowField;
            NotBlank = false;
            TableRelation = "Customer Posting Group";
        }
        field(50008; "Special Price"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Special Price Comments"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(10; Key20; "Source Type", "Source No.", "Asset Type", "Asset No.")
        {

        }
    }
    trigger OnInsert()
    begin
        "Last Modified Date" := TODAY;
        "Last Modified User" := USERID;
        "Update Price NOP" := TRUE;
    end;

    trigger OnModify()
    begin
        "Last Modified Date" := TODAY;
        "Last Modified User" := USERID;
        "Update Price NOP" := TRUE;
    end;
}
