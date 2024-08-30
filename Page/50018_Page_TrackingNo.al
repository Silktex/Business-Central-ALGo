page 50018 "Tracking No"
{
    PageType = List;
    SourceTable = "Tracking No.";
    SourceTableView = WHERE("Void Entry" = FILTER(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Warehouse Shipment No"; Rec."Warehouse Shipment No")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Tracking No."; Rec."Tracking No.")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Source Document No."; Rec."Source Document No.")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field(Image; Rec.Image)
                {
                    ApplicationArea = All;
                    Editable = false;

                    // trigger OnAssistEdit()
                    // var
                    //     outFile: File;
                    //     Istream1: InStream;
                    //     Line: Text;
                    //     Text1: Text;
                    //     OStream: OutStream;
                    //     FileManagement: Codeunit "File Management";
                    //     TempBlob: Codeunit "Temp Blob";// temporary;
                    //     recTrackingNo: Record "Tracking No.";
                    // begin
                    //     Rec.CalcFields(Image);
                    //     if Rec.Image.HasValue() then begin
                    //         TempBlob.FromRecord(Rec, rec.FieldNo(Image));
                    //         FileManagement.BLOBExport(TempBlob, 'Label.TXT', true);
                    //     end;
                    // end;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(PostedWhShipment)
            {
                ApplicationArea = All;
                Caption = 'Posted Wh Shipment';
                Ellipsis = true;
                Image = Warehouse;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PostedWhseShiptHdr: Record "Posted Whse. Shipment Header";
                begin
                    PostedWhseShiptHdr.Reset;
                    PostedWhseShiptHdr.SetRange(PostedWhseShiptHdr."Whse. Shipment No.", Rec."Warehouse Shipment No");
                    if PostedWhseShiptHdr.FindFirst then
                        PAGE.Run(PAGE::"Posted Whse. Shipment", PostedWhseShiptHdr);
                end;
            }

            action("Check Zprinter")
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    outFile: File;
                    Line: Text;
                    Text1: array[10] of Text[1024];
                    OStream: OutStream;
                    Tempblob: Codeunit "Temp Blob";
                    FileName: Text;
                    RequestMsg: HttpRequestMessage;
                    ContentHeaders: HttpHeaders;
                    HttpWebClient: HttpClient;
                    HttpWebContent: HttpContent;
                    HttpWebResponse: HttpResponseMessage;
                    WebClientURL: Text[250];
                    Bodytext: Text;
                    Iinstream: InStream;
                    PdfInStream: InStream;
                    txtResponce: Text;
                begin

                    Rec.CalcFields(Image);
                    Rec.Image.CreateInStream(Iinstream);
                    Iinstream.ReadText(Bodytext);

                    WebClientURL := 'http://api.labelary.com/v1/printers/8dpmm/labels/4x3/';

                    HttpWebContent.WriteFrom(Bodytext);
                    Message(Bodytext);
                    HttpWebContent.GetHeaders(ContentHeaders);
                    //ContentHeaders.Clear();
                    ContentHeaders.Add('Accept', 'application/pdf');
                    ContentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');
                    ContentHeaders.Add('X-Page-Size', 'Letter');
                    ContentHeaders.Add('X-Page-Layout', '1x2');
                    ContentHeaders.Add('Content-Length', format(StrLen(Bodytext)));

                    RequestMsg.Content := HttpWebContent;
                    RequestMsg.SetRequestUri(WebClientURL);
                    RequestMsg.Method := 'POST';
                    HttpWebClient.Send(RequestMsg, HttpWebResponse);
                    if HttpWebResponse.HttpStatusCode = 200 then BEGIN
                        HttpWebResponse.Content().ReadAs(txtResponce);
                        Message(txtResponce);
                    END;

                    //HttpWebResponse.Content().ReadAs(PdfInStream);
                    //FileName := 'Zfile.pdf';
                    //DownloadFromStream(PdfInStream, '', '', '', FileName);

                end;
            }

        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if cdDoc1 <> '' then
            Rec."Source Document No." := cdDoc1;
    end;

    var
        cdDoc1: Code[20];

    procedure Init(cdDocNo: Code[20])
    begin
        cdDoc1 := cdDocNo;
    end;

}

