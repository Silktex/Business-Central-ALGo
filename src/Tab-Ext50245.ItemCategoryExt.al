tableextension 50245 "Item Category_Ext" extends "Item Category"
{
    fields
    {
        field(50000; "Parent Category Old"; Code[10])
        {
            Caption = 'Parent Category';
            DataClassification = ToBeClassified;
            TableRelation = "Item Category";

            trigger OnValidate()
            var
                ItemCategory: Record "Item Category";
                ItemAttributeManagement: Codeunit "Item Attribute Management";
                ParentCategory: Code[10];
                CyclicInheritanceErr: Label 'An item category cannot be a parent of itself or any of its children.';
            begin
                ParentCategory := "Parent Category";
                WHILE ItemCategory.GET(ParentCategory) DO BEGIN
                    IF ItemCategory.Code = Code THEN
                        ERROR(CyclicInheritanceErr);
                    ParentCategory := ItemCategory."Parent Category";
                END;
                ItemAttributeManagement.UpdateCategoryAttributesAfterChangingParentCategory(Code, "Parent Category", xRec."Parent Category");
            end;
        }
    }
}
