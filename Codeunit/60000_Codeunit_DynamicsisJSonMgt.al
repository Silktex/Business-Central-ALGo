// codeunit 60000 "Dynamics.is JSon Mgt."
// {

//     trigger OnRun()
//     begin
//     end;

//     var
//         StringBuilder: DotNet StringBuilder;
//         StringWriter: DotNet StringWriter;
//         StringReader: DotNet StringReader;
//         JsonTextWriter: DotNet JsonTextWriter;
//         JsonTextReader: DotNet JsonTextReader;

//     local procedure Initialize()
//     var
//         Formatting: DotNet Formatting;
//     begin
//         StringBuilder := StringBuilder.StringBuilder;
//         StringWriter := StringWriter.StringWriter(StringBuilder);
//         JsonTextWriter := JsonTextWriter.JsonTextWriter(StringWriter);
//         JsonTextWriter.Formatting := Formatting.Indented;
//     end;


//     procedure StartJSon()
//     begin
//         IF ISNULL(StringBuilder) THEN
//             Initialize;
//         JsonTextWriter.WriteStartObject;
//     end;


//     procedure StartJSonArray()
//     begin
//         IF ISNULL(StringBuilder) THEN
//             Initialize;
//         JsonTextWriter.WriteStartArray;
//     end;


//     procedure AddJSonBranch(BranchName: Text)
//     begin
//         JsonTextWriter.WritePropertyName(BranchName);
//         JsonTextWriter.WriteStartObject;
//     end;


//     procedure AddToJSon(VariableName: Text; Variable: Variant)
//     begin
//         JsonTextWriter.WritePropertyName(VariableName);
//         JsonTextWriter.WriteValue(FORMAT(Variable, 0, 9));
//     end;


//     procedure EndJSonBranch()
//     begin
//         JsonTextWriter.WriteEndObject;
//     end;


//     procedure EndJSonArray()
//     begin
//         JsonTextWriter.WriteEndArray;
//     end;


//     procedure EndJSon()
//     begin
//         JsonTextWriter.WriteEndObject;
//     end;


//     procedure GetJSon() JSon: Text
//     begin
//         JSon := StringBuilder.ToString;
//         Initialize;
//     end;


//     procedure ReadJSon(var String: DotNet String; var TempPostingExchField: Record "Data Exch. Field" temporary)
//     var
//         JsonToken: DotNet JsonToken;
//         PrefixArray: DotNet Array;
//         PrefixString: DotNet String;
//         PropertyName: Text;
//         ColumnNo: Integer;
//         InArray: array[250] of Boolean;
//     begin
//         PrefixArray := PrefixArray.CreateInstance(GETDOTNETTYPE(String), 250);
//         StringReader := StringReader.StringReader(String);
//         JsonTextReader := JsonTextReader.JsonTextReader(StringReader);
//         WHILE JsonTextReader.Read DO
//             CASE TRUE OF
//                 JsonTextReader.TokenType.CompareTo(JsonToken.StartObject) = 0:
//                     ;
//                 JsonTextReader.TokenType.CompareTo(JsonToken.StartArray) = 0:
//                     BEGIN
//                         InArray[JsonTextReader.Depth + 1] := TRUE;
//                         ColumnNo := 0;
//                     END;
//                 JsonTextReader.TokenType.CompareTo(JsonToken.StartConstructor) = 0:
//                     ;
//                 JsonTextReader.TokenType.CompareTo(JsonToken.PropertyName) = 0:
//                     BEGIN
//                         PrefixArray.SetValue(JsonTextReader.Value, JsonTextReader.Depth - 1);
//                         IF JsonTextReader.Depth > 1 THEN BEGIN
//                             PrefixString := PrefixString.Join('.', PrefixArray, 0, JsonTextReader.Depth - 1);
//                             IF PrefixString.Length > 0 THEN
//                                 PropertyName := PrefixString.ToString + '.' + FORMAT(JsonTextReader.Value, 0, 9)
//                             ELSE
//                                 PropertyName := FORMAT(JsonTextReader.Value, 0, 9);
//                         END ELSE
//                             PropertyName := FORMAT(JsonTextReader.Value, 0, 9);
//                     END;
//                 JsonTextReader.TokenType.CompareTo(JsonToken.String) = 0,
//                 JsonTextReader.TokenType.CompareTo(JsonToken.Integer) = 0,
//                 JsonTextReader.TokenType.CompareTo(JsonToken.Float) = 0,
//                 JsonTextReader.TokenType.CompareTo(JsonToken.Boolean) = 0,
//                 JsonTextReader.TokenType.CompareTo(JsonToken.Date) = 0,
//                 JsonTextReader.TokenType.CompareTo(JsonToken.Bytes) = 0:
//                     BEGIN
//                         TempPostingExchField."Data Exch. No." := JsonTextReader.Depth;
//                         TempPostingExchField."Line No." := JsonTextReader.LineNumber;
//                         TempPostingExchField."Column No." := ColumnNo;
//                         TempPostingExchField."Node ID" := PropertyName;
//                         TempPostingExchField.Value := FORMAT(JsonTextReader.Value, 0, 9);
//                         //TempPostingExchField."Posting Exch. Line Def Code" := JsonTextReader.TokenType.ToString;
//                         TempPostingExchField.INSERT;
//                     END;
//                 JsonTextReader.TokenType.CompareTo(JsonToken.EndConstructor) = 0:
//                     ;
//                 JsonTextReader.TokenType.CompareTo(JsonToken.EndArray) = 0:
//                     InArray[JsonTextReader.Depth + 1] := FALSE;
//                 JsonTextReader.TokenType.CompareTo(JsonToken.EndObject) = 0:
//                     IF JsonTextReader.Depth > 0 THEN
//                         IF InArray[JsonTextReader.Depth] THEN ColumnNo += 1;
//             END;
//     end;


//     procedure ReadFirstJSonValue(var String: DotNet String; ParameterName: Text) ParameterValue: Text
//     var
//         JsonToken: DotNet JsonToken;
//         PropertyName: Text;
//     begin
//         StringReader := StringReader.StringReader(String);
//         JsonTextReader := JsonTextReader.JsonTextReader(StringReader);
//         WHILE JsonTextReader.Read DO
//             CASE TRUE OF
//                 JsonTextReader.TokenType.CompareTo(JsonToken.PropertyName) = 0:
//                     PropertyName := FORMAT(JsonTextReader.Value, 0, 9);
//                 (PropertyName = ParameterName) AND NOT ISNULL(JsonTextReader.Value):
//                     BEGIN
//                         ParameterValue := FORMAT(JsonTextReader.Value, 0, 9);
//                         EXIT;
//                     END;
//             END;
//     end;


//     procedure UploadJSon(WebServiceURL: Text; UserName: Text; Password: Text; var String: DotNet String)
//     var
//         HttpWebRequest: DotNet HttpWebRequest;
//         HttpWebResponse: DotNet WebResponse;
//         HttpWebRequestMgt: Codeunit "Http Web Request Mgt.";
//         InStr: InStream;
//         tempblob: Record TempBlob temporary;
//         HttpStatusCode: DotNet HttpStatusCode;
//     begin
//         CreateWebRequest(HttpWebRequest, WebServiceURL, 'POST');
//         CreateCredentials(HttpWebRequest, UserName, Password);
//         SetRequestStream(HttpWebRequest, String);
//         //DoWebRequest(HttpWebRequest,HttpWebResponse,'');

//         tempblob.INIT;
//         tempblob.Blob.CREATEINSTREAM(InStr, TEXTENCODING::UTF8);

//         IF HttpWebRequestMgt.GetResponse(InStr, HttpStatusCode, HttpWebResponse) THEN
//             GetResponseStream(HttpWebResponse, String)
//         ELSE
//             ERROR('Exception/Error Occured.');
//     end;


//     procedure DownloadString(Url: Text; UserName: Text; Password: Text): Text
//     var
//         WebClient: DotNet WebClient;
//         Credential: DotNet NetworkCredential;
//     begin
//         Credential := Credential.NetworkCredential;
//         Credential.UserName := UserName;
//         Credential.Password := Password;

//         WebClient := WebClient.WebClient;
//         WebClient.Credentials := Credential;
//         EXIT(WebClient.DownloadString(Url));
//     end;


//     procedure CreateWebRequest(var HttpWebRequest: DotNet HttpWebRequest; WebServiceURL: Text; Method: Text)
//     begin
//         HttpWebRequest := HttpWebRequest.Create(WebServiceURL);
//         HttpWebRequest.Timeout := 30000;
//         HttpWebRequest.Method := Method;
//         HttpWebRequest.Accept := 'application/json';
//     end;


//     procedure CreateCredentials(var HttpWebRequest: DotNet HttpWebRequest; UserName: Text; Password: Text)
//     var
//         Credential: DotNet NetworkCredential;
//     begin
//         Credential := Credential.NetworkCredential;
//         Credential.UserName := UserName;
//         Credential.Password := Password;
//         HttpWebRequest.Credentials := Credential;
//     end;


//     procedure SetRequestStream(var HttpWebRequest: DotNet HttpWebRequest; var String: DotNet String)
//     var
//         StreamWriter: DotNet StreamWriter;
//         Encoding: DotNet Encoding;
//     begin
//         StreamWriter := StreamWriter.StreamWriter(HttpWebRequest.GetRequestStream, Encoding.GetEncoding('iso8859-1'));
//         StreamWriter.Write(String);
//         StreamWriter.Close;
//     end;


//     procedure DoWebRequest(var HttpWebRequest: DotNet HttpWebRequest; var HttpWebResponse: DotNet HttpWebResponse; IgnoreCode: Code[10])
//     var
//         NAVWebRequest: DotNet HttpWebRequest;
//         HttpWebException: DotNet WebException;
//         HttpWebRequestError: Label 'Error: %1\%2';
//     begin
//         NAVWebRequest := HttpWebRequest.HttpWebRequest();
//         /*
//         IF NOT NAVWebRequest.doRequest(HttpWebRequest,HttpWebException,HttpWebResponse) THEN
//           IF (IgnoreCode = '') OR (STRPOS(HttpWebException.Message,IgnoreCode) = 0) THEN
//             ERROR(HttpWebRequestError,HttpWebException.Status.ToString,HttpWebException.Message);
//         */

//         CLEARLASTERROR;
//         HttpWebResponse := HttpWebRequest.GetResponse;

//     end;


//     procedure GetResponseStream(var HttpWebResponse: DotNet WebResponse; var String: DotNet String)
//     var
//         StreamReader: DotNet StreamReader;
//         MemoryStream: DotNet MemoryStream;
//     begin
//         StreamReader := StreamReader.StreamReader(HttpWebResponse.GetResponseStream);
//         String := StreamReader.ReadToEnd;
//     end;


//     procedure GetValueFromJsonString(var String: DotNet String; ParameterName: Text): Text
//     var
//         TempPostingExchField: Record "Data Exch. Field" temporary;
//     begin
//         ReadJSon(String, TempPostingExchField);
//         EXIT(GetJsonValue(TempPostingExchField, ParameterName));
//     end;


//     procedure GetJsonValue(var TempPostingExchField: Record "Data Exch. Field" temporary; ParameterName: Text): Text
//     begin
//         WITH TempPostingExchField DO BEGIN
//             SETRANGE("Node ID", ParameterName);
//             IF FINDFIRST THEN EXIT(Value);
//         END;
//     end;
// }

