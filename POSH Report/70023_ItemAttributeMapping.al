report 70023 "Item Attribute Report"
{
    Caption = 'Item Attribute Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './POSH Report/70023_ItemAttributeMapping.rdlc';

    dataset
    {
        dataitem(Map; "Item Attribute Value Mapping")
        {
            RequestFilterFields = "Table ID", "No.";

            column(TableID; "Table ID") { }
            column(No; "No.") { }
            column(LinkedRecordName; LinkedName) { }
            column(AttrNamePivot; AttrName) { }
            column(AttrValuePivot; AttrValue) { }

            trigger OnAfterGetRecord()
            var
                Item: Record Item;
                ItemCat: Record "Item Category";
                Attr: Record "Item Attribute";
                AttrVal: Record "Item Attribute Value";
            begin
                Clear(LinkedName);
                Clear(AttrName);
                Clear(AttrValue);

                // Linked record name: Item or Item Category
                case "Table ID" of
                    27:
                        if Item.Get("No.") then
                            LinkedName := Item.Description;
                    5722:
                        if ItemCat.Get("No.") then
                            LinkedName := ItemCat.Description;
                end;

                // Attribute Name
                if Attr.Get("Item Attribute ID") then
                    AttrName := Attr.Name;

                // Attribute Value
                if AttrVal.Get("Item Attribute ID", "Item Attribute Value ID") then
                    AttrValue := AttrVal.Value;
            end;
        }
    }

    var
        LinkedName: Text[100];
        AttrName: Text[100];
        AttrValue: Text[250];
}
