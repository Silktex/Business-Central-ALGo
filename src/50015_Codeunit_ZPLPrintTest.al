codeunit 50025 ZPLTestPrint
{
    procedure TestPrint()
    var
        HttpWebContent: HttpContent;
        ContentHeaders: HttpHeaders;
        RequestMsg: HttpRequestMessage;
        HttpWebClient: HttpClient;
        HttpWebResponse: HttpResponseMessage;
        WebClientURL: Text;
        reqText: Text;
        tempText: Text;
    begin
        WebClientURL := 'http://192.168.1.178/pstprnt';
        reqText := '^XA^PW400^LL200^FO20,20^A0N,30,30^FDThis is a TEST^FS^XZ';

        // Add the payload to the content
        HttpWebContent.WriteFrom(reqText);

        // Retrieve the contentHeaders associated with the content
        HttpWebContent.GetHeaders(ContentHeaders);
        //ContentHeaders.Clear();
        //RequestMsg.GetHeaders(contentHeaders);
        //ContentHeaders.Add('content-type', 'application/json');
        RequestMsg.Content := HttpWebContent;
        RequestMsg.SetRequestUri(WebClientURL);
        RequestMsg.Method := 'POST';
        HttpWebClient.Send(RequestMsg, HttpWebResponse);
        // Read the response content as json.
        HttpWebResponse.Content().ReadAs(tempText);
        MESSAGE('%1', tempText);
    end;


}

