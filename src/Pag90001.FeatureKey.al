page 80001 "Feature Key"
{
    ApplicationArea = All;
    Caption = 'Feature Key';
    PageType = List;
    SourceTable = "Feature Key";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Can Try"; Rec."Can Try")
                {
                    ToolTip = 'Specifies the value of the Get started field.';
                    ApplicationArea = All;
                }
                field("Data Update Required"; Rec."Data Update Required")
                {
                    ToolTip = 'Specifies the value of the Data Update Required field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'The name of the new capability or change in design.';
                    ApplicationArea = All;
                }
                field(Enabled; Rec.Enabled)
                {
                    ToolTip = 'Specifies whether the feature is enabled for all users or for none. The change takes effect the next time each user signs in.';
                    ApplicationArea = All;
                }
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.';
                    ApplicationArea = All;
                }
                field("Is One Way"; Rec."Is One Way")
                {
                    ToolTip = 'Specifies the value of the Is One Way field.';
                    ApplicationArea = All;
                }
                field("Learn More Link"; Rec."Learn More Link")
                {
                    ToolTip = 'Specifies the value of the Learn more field.';
                    ApplicationArea = All;
                }
                field("Mandatory By"; Rec."Mandatory By")
                {
                    ToolTip = 'Specifies a future software version and approximate date when this feature is automatically enabled for all users and cannot be disabled. Until this future version, the feature is optional.';
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.';
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
