tableextension 50232 "Ship-to Address_Ext" extends "Ship-to Address"
{
    fields
    {
        field(50000; "Shipping Account No."; Code[20])
        {
        }
        field(50001; "UPS Account No."; Code[20])
        {
        }
        field(50002; "Third Party"; Boolean)
        {
        }
        field(50003; "Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(50004; "Use Default"; Boolean)
        {

            trigger OnValidate()
            begin
                IF "Use Default" THEN BEGIN
                    recShiptoAdd.RESET;
                    recShiptoAdd.SETRANGE("Customer No.", "Customer No.");
                    recShiptoAdd.SETFILTER(Code, '<>%1', Code);
                    recShiptoAdd.SETRANGE("Use Default", TRUE);
                    IF recShiptoAdd.FIND('-') THEN
                        ERROR('Already Set Default for ship code %1', recShiptoAdd.Code);
                END;
            end;
        }
        field(50005; Residential; Boolean)
        {
        }
        field(50006; AddressValidated; Boolean)
        {
        }
        field(50007; "Payment Terms Code"; Code[10])
        {
            TableRelation = "Payment Terms";
        }
        field(50008; "NOP Insert"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'NOP_18';
        }

    }

    var
        recShiptoAdd: Record "Ship-to Address";
        // Xmlhttp: Automation;
        Result: Boolean;
        txtURL: Text;
        recCompInfo: Record "Company Information";

    trigger OnDelete()
    begin
        //Tarun not in use
        //NOP Commerce BEGIN
        // recCompInfo.GET();
        // IF recCompInfo."NOP Sync URL Activate" THEN BEGIN
        //     IF ISCLEAR(Xmlhttp) THEN
        //         Result := CREATE(Xmlhttp, TRUE, TRUE);
        //     txtURL := recCompInfo."NOP Sync URL" + 'api/singlecustomeraddresssyncfromnav/' + Rec.Code + '/' + Rec."Customer No.";
        //     //txtURL :='http://localhost:80/api/singlecustomeraddresssyncfromnav/'+Rec.Code+'/'+Rec."Customer No.";
        //     Xmlhttp.open('GET', txtURL, FALSE);
        //     Xmlhttp.send('');
        //     MESSAGE('%1', Xmlhttp.responseText);
        // END;
        //NOP Commerce END
    end;

    trigger OnAfterModify()
    begin
        IF ("Shipping Agent Code" = 'FEDEX') AND ("Shipping Agent Service Code" = 'GROUND') AND (Residential) THEN
            "Shipping Agent Service Code" := '9 GRND HOM';

        //Tarun not in use
        // //NOP Commerce BEGIN
        // recCompInfo.GET();
        // IF recCompInfo."NOP Sync URL Activate" THEN BEGIN
        //     //IF ("No." <> xRec."No.") OR (Name <> xRec.Name) OR (AdminComments <> xRec.AdminComments) OR (HasShoppingCartItems <> xRec.HasShoppingCartItems) OR
        //     // (Active <> xRec.Active) OR ("E-Mail" <>  xRec."E-Mail") OR (Blocked <> xRec.Blocked) OR ("Customer Price Group" <> xRec."Customer Price Group") THEN BEGIN
        //     IF ISCLEAR(Xmlhttp) THEN
        //         Result := CREATE(Xmlhttp, TRUE, TRUE);
        //     txtURL := recCompInfo."NOP Sync URL" + 'api/singlecustomeraddresssyncfromnav/' + Rec.Code + '/' + Rec."Customer No.";
        //     //txtURL :='http://localhost:80/api/singlecustomeraddresssyncfromnav/'+Rec.Code+'/'+Rec."Customer No.";
        //     Xmlhttp.open('GET', txtURL, FALSE);
        //     Xmlhttp.send('');
        //     MESSAGE('%1', Xmlhttp.responseText);
        //     //END;
        // END;
        // //NOP Commerce END
    end;
}
