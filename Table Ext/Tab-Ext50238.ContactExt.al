tableextension 50238 Contact_Ext extends Contact
{
    fields
    {
        field(50003; "Mail To"; Boolean)
        {

            trigger OnValidate()
            begin
                IF "Mail To" THEN BEGIN
                    "Mail CC" := FALSE;
                    "Mail BCC" := FALSE;
                END;
            end;
        }
        field(50004; "Mail CC"; Boolean)
        {

            trigger OnValidate()
            begin
                IF "Mail CC" THEN BEGIN
                    "Mail BCC" := FALSE;
                    "Mail To" := FALSE;
                END;
            end;
        }
        field(50005; "Mail BCC"; Boolean)
        {

            trigger OnValidate()
            begin
                IF "Mail BCC" THEN BEGIN
                    "Mail CC" := FALSE;
                    "Mail To" := FALSE;
                END;
            end;
        }
        field(50006; "Sales Order"; Boolean)
        {
        }
        field(50007; "Sales Invoice"; Boolean)
        {
        }
        field(50008; "Customer Ledger"; Boolean)
        {
        }
        field(50009; "Purchase Order"; Boolean)
        {
        }
        field(50010; "Vendor Ledger"; Boolean)
        {
        }
        field(50011; "Sales Shipment"; Boolean)
        {
        }
        field(50012; "Credit Card Contact"; Boolean)
        {
        }
        field(50013; "Sales Price Expire Days"; Integer)
        {
        }
        field(50014; Published; Boolean)
        {
            Description = 'ECOM';
        }
        field(50015; "Expired Price"; Boolean)
        {
            Description = 'Expired Price';
        }
        field(50050; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            trigger OnValidate()
            var
                ContBussRel: Record "Contact Business Relation";
                MyCont: Record Contact;
            begin
                ContBussRel.SetRange("Link to Table", ContBussRel."Link to Table"::Customer);
                ContBussRel.SetRange("No.", "Customer No.");
                if ContBussRel.FindSet() then
                    repeat
                        if MyCont.get(ContBussRel."Contact No.") then
                            if MyCont.Type = MyCont.Type::Company then
                                if Rec.Type <> Rec.Type::Company then
                                    Rec.Validate("Company No.", ContBussRel."Contact No.");
                    until ContBussRel.Next() = 0;
            end;
        }
        field(50051; "Entity ID"; code[20])
        {
            caption = 'Entity Id';
        }
    }
}
