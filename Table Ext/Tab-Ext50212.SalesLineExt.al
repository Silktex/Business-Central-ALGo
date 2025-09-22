tableextension 50212 "Sales Line_Ext" extends "Sales Line"
{
    fields
    {
        field(50006; "Quantity Variance %"; Decimal)
        {
        }
        field(50007; "Original Quantity"; Decimal)
        {

            trigger OnValidate()
            begin
                TestStatusOpen;
                VALIDATE(Quantity, "Original Quantity");
            end;
        }
        field(50008; "Customer Item No."; Text[30])
        {
        }
        field(50049; "Expiry Date"; Date)
        {
            Description = 'SPD MS 050815';
        }
        field(50050; Observation; Code[10])
        {
            Description = 'spdspl sushant';
            TableRelation = "Return Reason";
        }
        field(50051; "Ship to Finisher"; Date)
        {
            Description = 'Ravi';
        }
        field(50052; "Ship from Finisher"; Date)
        {
            Description = 'Ravi';
        }
        field(50053; "Minimum Qty"; Decimal)
        {
            Description = 'Ravi';
        }
        field(50054; Priority; Option)
        {
            Description = 'Ravi';
            InitValue = "Sea 3";
            OptionCaption = ' ,Air 1,Air 2,Air 3,Sea 1,Sea 2,Sea 3';
            OptionMembers = " ","Air 1","Air 2","Air 3","Sea 1","Sea 2","Sea 3";
        }
        field(50055; Comments; Text[100])
        {
            Description = 'Ravi';
        }
        field(50056; "Resource Line Created"; Boolean)
        {
            Description = 'Ravi';
        }
        field(50057; "Packing Header No."; Code[20])
        {
            Description = 'RaviVoid';
        }
        field(50058; "Sales Invoice No."; Code[20])
        {
            Description = 'Ravi';
        }
        field(50059; "Shipping Agent Service Des"; Text[100])
        {
            CalcFormula = Lookup("Shipping Agent Services".Description WHERE("Shipping Agent Code" = FIELD("Shipping Agent Code"), Code = FIELD("Shipping Agent Service Code")));
            FieldClass = FlowField;
        }
        field(50060; "Comment Status"; Option)
        {
            Description = 'Ravi';
            OptionCaption = ' ,Partial,Complete';
            OptionMembers = " ",Partial,Complete;
        }
        field(50061; Status; Enum "Sales Document Status")
        {
            CalcFormula = Lookup("Sales Header".Status WHERE("Document Type" = FIELD("Document Type"), "No." = FIELD("Document No.")));
            Caption = 'Status';
            Description = 'Handheld';
            FieldClass = FlowField;
        }
        field(50062; Backing; Option)
        {
            Caption = 'Backing';
            Description = 'Ravi05-04-2019';
            Editable = false;
            OptionMembers = " ",Prebacked,"To be Backed","TO BE BACKED+C6","Alta is Required","TO BE BACKED+PILLING TREATMENT","TO BE BACKED+C0 FINISH","C0 Finish";
        }
        field(50063; FinalQty; Decimal)
        {
            Caption = 'Backing';
            Description = 'Ravi05-04-2019';
            Editable = false;
            //OptionMembers = " ",Prebacked,"To be Backed";
        }
    }
    var
        ModifyFromTracking1: Boolean;

    procedure InitLine(ModifyFromTracking: Boolean)
    begin
        ModifyFromTracking1 := ModifyFromTracking;
    end;
}
