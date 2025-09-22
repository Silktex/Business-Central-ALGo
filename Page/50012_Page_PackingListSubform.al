page 50012 "Packing List Subform"
{
    PageType = ListPart;
    SourceTable = "Packing Line";
    SourceTableView = WHERE("Void Entry" = FILTER(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Box Code"; Rec."Box Code")
                {
                    ApplicationArea = All;
                }
                field(Height; Rec.Height)
                {
                    ApplicationArea = All;
                }
                field(Width; Rec.Width)
                {
                    ApplicationArea = All;
                }
                field(Length; Rec.Length)
                {
                    ApplicationArea = All;
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = All;
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                    ApplicationArea = All;
                }
            }
            repeater(TrackingNo)
            {
                Caption = 'Tracking No.';
                field("Tracking No."; Rec."Tracking No.")
                {
                    ApplicationArea = All;
                }
                field(Image; Rec.Image)
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    var
                        OStream: OutStream;
                        InStream: InStream;
                        FileManagement: Codeunit "File Management";
                        TempBlob: Codeunit "Temp Blob";
                        FileName: Text;
                    begin
                        Rec.CalcFields(Image);
                        //TempBlob.CreateOutStream();
                        // TempBlob.DeleteAll;
                        // TempBlob.Init;
                        // TempBlob.Blob := Rec.Image;
                        // TempBlob.Insert;
                        FileName := 'Label.TXT';
                        Rec.Image.CreateInStream(InStream, TEXTENCODING::UTF8);
                        DownloadFromStream(InStream, '', '', '', FileName);
                        //FileManagement.BLOBExport(TempBlob, 'Label.TXT', true);
                    end;
                }
                field("Billed Weight"; Rec."Billed Weight")
                {
                    ApplicationArea = All;
                }
                field("Total Base Charge"; Rec."Total Base Charge")
                {
                    ApplicationArea = All;
                }
                field(INSURED_VALUE; Rec.INSURED_VALUE)
                {
                    ApplicationArea = All;
                }
                field(SIGNATURE_OPTION; Rec.SIGNATURE_OPTION)
                {
                    ApplicationArea = All;
                }
                field("Total Charges"; Rec."Total Charges")
                {
                    ApplicationArea = All;
                }
                field("Total Discounts"; Rec."Total Discounts")
                {
                    ApplicationArea = All;
                }
                field("Total Surcharge"; Rec."Total Surcharge")
                {
                    ApplicationArea = All;
                }
                field("Packing No."; Rec."Packing No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("No. Of  Lots"; Rec."No. Of  Lots")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(PackingItemList)
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Rec.ShowItemList;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.CalcFields("Shipping Agent Service Code");
    end;
}

