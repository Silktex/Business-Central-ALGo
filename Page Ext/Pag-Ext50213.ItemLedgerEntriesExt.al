pageextension 50213 "Item Ledger Entries_Ext" extends "Item Ledger Entries"
{
    Editable = true;
    layout
    {
        addbefore("Posting Date")
        {
            field("ETA Date"; Rec."ETA Date")
            {
                ApplicationArea = all;
            }
        }
        modify("Posting Date")
        {
            Editable = false;
        }
        modify("Entry Type")
        {
            Editable = false;
        }
        modify("Document Type")
        {
            Editable = false;
        }
        modify("Document No.")
        {
            Editable = false;
        }
        modify("Document Line No.")
        {
            Editable = false;
        }
        modify("Item No.")
        {
            Editable = false;
        }
        modify("Variant Code")
        {
            Editable = false;
        }
        modify("Return Reason Code")
        {
            Editable = false;
        }
        modify("Global Dimension 1 Code")
        {
            Editable = false;
        }
        modify("Global Dimension 2 Code")
        {
            Editable = false;
        }
        modify("Expiration Date")
        {
            Editable = false;
        }
        modify("Serial No.")
        {
            Editable = false;
        }
        modify("Lot No.")
        {
            Editable = false;
        }
        addafter("Lot No.")
        {
            field("Dylot No."; Rec."Dylot No.")
            {
                Editable = false;
                ApplicationArea = all;
            }
        }
        modify("Location Code")
        {
            Editable = false;
        }
        modify(Quantity)
        {
            Editable = false;
        }
        modify("Invoiced Quantity")
        {
            Editable = false;
        }
        modify("Remaining Quantity")
        {
            Editable = false;
        }
        modify("Shipped Qty. Not Returned")
        {
            Editable = false;
        }
        modify("Reserved Quantity")
        {
            Editable = false;
        }
        modify("Qty. per Unit of Measure")
        {
            Editable = false;
        }
        modify("Sales Amount (Expected)")
        {
            Editable = false;
        }
        modify("Completely Invoiced")
        {
            Editable = false;
        }
        modify(Open)
        {
            Editable = false;
        }
        modify("Drop Shipment")
        {
            Editable = false;
        }
        modify("Assemble to Order")
        {
            Editable = false;
        }
        modify("Applied Entry to Adjust")
        {
            Editable = false;
        }
        modify("Prod. Order Comp. Line No.")
        {
            Editable = false;
        }
        modify("Entry No.")
        {
            Editable = false;
        }
        modify("Job No.")
        {
            Editable = false;
        }
        modify("Job Task No.")
        {
            Editable = false;
        }

        addfirst(factboxes)
        {
            part(BinInventory; "Bin Inventory")
            {
                ApplicationArea = All;
                SubPageLink = "Item No." = FIELD("Item No."),
                              "Variant Code" = FIELD("Variant Code"),
                              "Location Code" = FIELD("Location Code"),
                              "Lot No. Filter" = field("Lot No.");
            }
        }

    }

    actions
    {
        addafter("Application Worksheet")
        {
            action(PrintLabel)
            {
                Caption = 'Print Label';
                Image = NewReceipt;
                Promoted = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                // ReportLabel: Report "Print PHP Label";
                begin
                    CurrPage.SetSelectionFilter(recILE);
                    //REPORT.RUN(REPORT::"Item Label Print",FALSE,FALSE,recILE);
                    PrintLable(Rec."Item No.", Rec."Lot No.", Rec."Remaining Quantity");
                end;
            }


        }
        addafter("&Value Entries")
        {
            action("&Bin Contents")
            {
                ApplicationArea = All;
                Caption = '&Bin Contents';
                Image = BinContent;
                RunObject = Page "Bin Content";
                RunPageLink = "Location Code" = field("Location Code"), "Item No." = FIELD("Item No."), "Lot No. Filter" = field("Lot No.");
                RunPageView = SORTING("Item No.");
                ToolTip = 'View the quantities of the item in each bin where it exists. You can see all the important parameters relating to bin content, and you can modify certain bin content parameters in this window.';
            }
        }


    }
    var
        //  ReportLabel: Report "Print PHP Label";
        recILE: Record "Item Ledger Entry";

    procedure PrintLable(ItemCode: Code[20]; LotNo: Code[20]; Qty: Decimal)
    var
        DataText: BigText;
        DataStream: InStream;
        // MemoryStream: DotNet MemoryStream;
        //Bytes: DotNet Array;
        //Convert: DotNet Convert;
        //Base64String: Text;
        TempBlob: Codeunit "Temp Blob";
        OStream: OutStream;
        txtSend: Text;
        recItem: Record Item;
        PrinterSelection: Record "Printer Selection";
        FileName: Text;
    begin
        FileName := '';
        recItem.Get(ItemCode);
        txtSend := ('^XA' +
                   '^MMT' +
                   '^PW477' +
                   '^LL0203' +
                   '^LS0' +
                   '^FO5,10^BX,10,200' +
                   '^FD' + LotNo + '^FS' +
                   '^BCN,50,Y,N,N' +
                   '^FT180,0^A0N,34,33^FH\^FD' + LotNo + '^FS' +
                   '^FT10,180^A0N,34,31^FH\^FD' + recItem.Description + '^FS' +
                   '^FT180,110^A0N,34,33^FH\^FDQty:^FS' +
                   '^FT240,110^A0N,34,33^FH\^FD' + Format(Qty) + ' Yards^FS' +
                   '^XZ');

        TempBlob.CreateOutStream(OStream);
        OStream.WriteText(txtSend);
        Clear(DataText);
        Clear(DataStream);
        TempBlob.CreateInStream(DataStream);
        FileName := recItem."No." + '.txt';
        DownloadFromStream(DataStream, '', '', '', FileName);
        //VR code replace by export text file
        /*
        MemoryStream := MemoryStream.MemoryStream();
        CopyStream(MemoryStream, DataStream);
        Base64String := Convert.ToBase64String(MemoryStream.ToArray);
        DataText.AddText(Base64String);
        //MESSAGE(Base64String);

        PrinterSelection.Reset;
        PrinterSelection.SetRange(PrinterSelection."Report ID", 50065);
        if PrinterSelection.FindFirst then;

        ZebraConnection := ZebraTCPConnection.TcpConnection(PrinterSelection."Label Printer IP", 9100);
        ZebraConnection.Open();
        Bytes := Convert.FromBase64String(Base64String);
        ZebraConnection.Write(Bytes);
        ZebraConnection.Close();
*/

    end;
}
