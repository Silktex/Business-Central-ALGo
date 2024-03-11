pageextension 50287 "Sales Quotes_Ext" extends "Sales Quotes"
{
    layout
    {
        addafter("External Document No.")
        {

            field("Work Description"; WorkDescription)
            {
                ApplicationArea = all;
                Importance = Additional;
                MultiLine = true;
                ShowCaption = true;
                ToolTip = 'Specifies the products or service being offered';

                trigger OnValidate()
                begin
                    rec.SetWorkDescription(WorkDescription);
                end;
            }
            field("Project Name"; Rec."Project Name")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter(CreateTask)
        {
            action("Open SQ Report")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Open SQ Report";
                Visible = ShowSilkReport;
                ApplicationArea = all;
            }
            action("Open SQ Report POSH")
            {
                Image = "Report";
                Promoted = true;
                Visible = ShowPoshReport;
                PromotedCategory = "Report";
                RunObject = Report "Open SQ Report POSH";
                ApplicationArea = all;
            }
        }
    }
    trigger OnOpenPage()
    var
        compInfo: Record "Company Information";
    begin

        compInfo.get();
        IF compInfo."Report Selection" = compInfo."Report Selection"::Slik then
            ShowSilkReport := true;
        IF compInfo."Report Selection" = compInfo."Report Selection"::POSH then
            ShowPoshReport := true;
    end;

    trigger OnAfterGetRecord()
    var
        compInfo: Record "Company Information";
    BEGIN
        WorkDescription := Rec.GetWorkDescription;
        compInfo.get();
        IF compInfo."Report Selection" = compInfo."Report Selection"::Slik then
            ShowSilkReport := true;
        IF compInfo."Report Selection" = compInfo."Report Selection"::POSH then
            ShowPoshReport := true;
    END;

    var
        WorkDescription: Text;
        ShowSilkReport: Boolean;
        ShowPoshReport: Boolean;
}
