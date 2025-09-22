report 50048 "Update Customer in Contacts"
{
    ApplicationArea = All;
    Caption = 'Update Customer in Contacts';
    UsageCategory = Administration;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Contact; Contact)
        {
            trigger OnPreDataItem()
            begin
                MKTSetup.Get();
                if GuiAllowed then
                    Win.Open(Dialog);
            end;

            trigger OnAfterGetRecord()
            begin
                if GuiAllowed then
                    Win.Update(1, "No.");

                if "Customer No." = '' then begin
                    if "Company No." <> '' then
                        ContBussRel.SetRange("Contact No.", "Company No.")
                    else
                        ContBussRel.SetRange("Contact No.", "No.");
                    if MKTSetup."Bus. Rel. Code for Customers" <> '' then
                        ContBussRel.SetRange("Business Relation Code", MKTSetup."Bus. Rel. Code for Customers");
                    ContBussRel.SetRange("Link to Table", ContBussRel."Link to Table"::Customer);
                    if ContBussRel.FindFirst() then begin
                        "Customer No." := ContBussRel."No.";
                        Modify();
                    end;
                end;
            end;

            trigger OnPostDataItem()
            begin
                if GuiAllowed then
                    Win.Close();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    var
        ContBussRel: Record "Contact Business Relation";
        MKTSetup: Record "Marketing Setup";
        Win: Dialog;
        Dialog: Label 'Processing #1#################################';
}
