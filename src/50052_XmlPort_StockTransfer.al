xmlport 50052 "Stock Transfer"
{
    DefaultFieldsValidation = false;
    Format = VariableText;
    TransactionType = Update;

    schema
    {
        textelement(root)
        {
            tableelement("Transfer Line"; "Transfer Line")
            {
                AutoUpdate = true;
                XmlName = 'TransferLine';
                fieldattribute(TransferOrderNo; "Transfer Line"."Document No.")
                {
                    FieldValidate = yes;
                }
                fieldattribute(ItemNo; "Transfer Line"."Item No.")
                {
                    FieldValidate = yes;
                }
                fieldattribute(ItemQuantity; "Transfer Line".Quantity)
                {
                    FieldValidate = yes;
                }
                textelement(lotno)
                {
                    XmlName = 'LotNo';
                }

                trigger OnAfterInsertRecord()
                begin
                    recTransferLine.RESET;
                    recTransferLine.SETRANGE("Document No.", DocumentNo);
                    recTransferLine.SETRANGE("Item No.", ItemNo);
                    IF recTransferLine.FINDFIRST THEN BEGIN
                        recTransferLine.Quantity := recTransferLine.Quantity + Qty;
                        recTransferLine.VALIDATE(Quantity);
                        recTransferLine.MODIFY;
                    END ELSE BEGIN
                        recTransferLine1.RESET;
                        recTransferLine1.SETRANGE("Document No.", DocumentNo);
                        IF recTransferLine1.FINDLAST THEN
                            LineNo := recTransferLine1."Line No."
                        ELSE
                            LineNo := 0;

                        recTransferLine.INIT;
                        recTransferLine."Document No." := DocumentNo;
                        recTransferLine."Line No." := LineNo + 10000;
                        recTransferLine.VALIDATE("Item No.", ItemNo);
                        recTransferLine.Quantity := recTransferLine.Quantity + Qty;
                        recTransferLine.VALIDATE(recTransferLine.Quantity);
                        IF NOT recTransferLine.INSERT THEN
                            recTransferLine.MODIFY;
                    END;
                end;
            }
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

    var
        recTransferLine: Record "Transfer Line";
        recTransferLine1: Record "Transfer Line";
        LineNo: Integer;
        DocumentNo: Code[20];
        ItemNo: Code[20];
        Qty: Decimal;
}

