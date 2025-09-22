report 50225 "Batch For Open PO"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Purchase Line"; "Purchase Line")
        {
            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE(Type = FILTER(Item), Quantity = FILTER(<> 0), "Outstanding Quantity" = FILTER(<> 0), "Location Code" = FILTER('SYOSSET'), "Avoid Error" = CONST(false), "Special Order" = CONST(false));
            RequestFilterFields = "Document No.", "No.";

            trigger OnAfterGetRecord()
            begin

                rec39.RESET;
                rec39.SETRANGE(rec39."Document Type", rec39."Document Type"::Order);
                rec39.SETRANGE(rec39."Document No.", "Purchase Line"."Document No.");
                rec39.SETRANGE(rec39."No.", "Purchase Line"."No.");
                rec39.SETFILTER(rec39."Location Code", '%1', 'SYOSSET');
                rec39.SETFILTER(rec39.Quantity, '<>%1', 0);
                rec39.SETFILTER(rec39."Outstanding Quantity", '<>%1', 0);
                //rec39.SETFILTER(rec39."No.",'<>%1|%2','I10210-001|I10716-024');
                IF rec39.FIND('-') THEN BEGIN
                    /*  rec337.RESET;
                      rec337.SETRANGE(rec337."Source ID",rec39."Document No.");
                      rec337.SETRANGE(rec337."Item No.",rec39."No.");
                      if rec337.find('-') then
                      repeat
                       rec337.delete;
                      until rec337.next = 0;  */

                    rec39."Location Code" := 'TRANSIT';
                    rec39.MODIFY;
                    rec39.VALIDATE(rec39."Location Code");

                END;

            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        rec39: Record "Purchase Line";
        rec337: Record "Reservation Entry";
}

