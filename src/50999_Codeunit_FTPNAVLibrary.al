// codeunit 50999 "FTP NAV Library"
// {

//     trigger OnRun()
//     begin
//         //UploadFilesToFTP('D:\TEST\Test.xlsx');
//         UploadFilesToFTP('D:\ReOrder\ReOrderReport1851.xls');
//     end;

//     var
//         FTPRequest: DotNet FtpWebRequest;
//         FTPResponse: DotNet FtpWebResponse;
//         Credentials: DotNet NetworkCredential;
//         ResponseStream: DotNet Stream;
//         StreamReader: DotNet StreamReader;
//         FileStream: DotNet File;
//         RealFileStream: DotNet FileStream;
//         FilesList: DotNet ArrayList;
//         SimpleStream: DotNet Stream;
//         StatusCode: DotNet FtpStatusCode;
//         Files: Record File;


//     procedure GetFilesList(FTPAddress: Text; Login: Text; Password: Text): Integer
//     begin
//         FTPRequest := FTPRequest.Create(FTPAddress);
//         Credentials := Credentials.NetworkCredential(Login, Password);
//         FTPRequest.Credentials := Credentials;
//         FTPRequest.KeepAlive := TRUE;
//         FTPRequest.Method := 'NLST';
//         FTPRequest.UsePassive := TRUE;
//         FTPRequest.UseBinary := TRUE;

//         FTPResponse := FTPRequest.GetResponse;
//         ResponseStream := FTPResponse.GetResponseStream();
//         StreamReader := StreamReader.StreamReader(ResponseStream);
//         FilesList := FilesList.ArrayList;
//         WHILE NOT StreamReader.EndOfStream DO BEGIN
//             FilesList.Add(StreamReader.ReadLine);
//         END;

//         StreamReader.Close;
//         ResponseStream.Close;
//         FTPResponse.Close;
//         EXIT(FilesList.Count);
//     end;


//     procedure DownloadFile(FTPAddressFile: Text; DownloadToFile: Text; Login: Text; Password: Text; DeleteAfterDownload: Boolean)
//     begin
//         FTPRequest := FTPRequest.Create(FTPAddressFile);
//         Credentials := Credentials.NetworkCredential(Login, Password);
//         FTPRequest.Credentials := Credentials;
//         FTPRequest.KeepAlive := TRUE;
//         FTPRequest.Method := 'RETR';
//         FTPRequest.UsePassive := TRUE;
//         FTPRequest.UseBinary := TRUE;

//         FTPResponse := FTPRequest.GetResponse;
//         ResponseStream := FTPResponse.GetResponseStream();
//         SimpleStream := FileStream.Create(DownloadToFile);
//         ResponseStream.CopyTo(SimpleStream);
//         SimpleStream.Close;
//         ResponseStream.Close;
//         FTPResponse.Close;
//         IF DeleteAfterDownload THEN BEGIN
//             DeleteFile(FTPAddressFile, Login, Password);
//         END;
//     end;


//     procedure DeleteFile(FTPAddressFile: Text; Login: Text; Password: Text): Boolean
//     var
//         Deleted: Boolean;
//     begin
//         CLEAR(Deleted);
//         FTPRequest := FTPRequest.Create(FTPAddressFile);
//         Credentials := Credentials.NetworkCredential(Login, Password);
//         FTPRequest.Credentials := Credentials;
//         FTPRequest.KeepAlive := TRUE;
//         FTPRequest.Method := 'DELE';
//         FTPRequest.UsePassive := TRUE;
//         FTPRequest.UseBinary := TRUE;
//         StatusCode := FTPResponse.StatusCode;
//         FTPResponse := FTPRequest.GetResponse;
//         IF FTPResponse.StatusCode.ToString() = StatusCode.FileActionOK.ToString() THEN BEGIN
//             Deleted := TRUE;
//         END;
//         FTPResponse.Close;
//         EXIT(Deleted);
//     end;


//     procedure UploadFile(FileNameToUpload: Text; UploadToFtp: Text; Login: Text; Password: Text)
//     begin
//         FTPRequest := FTPRequest.Create(UploadToFtp);
//         Credentials := Credentials.NetworkCredential(Login, Password);
//         FTPRequest.Credentials := Credentials;
//         FTPRequest.KeepAlive := TRUE;
//         FTPRequest.Method := 'STOR';
//         FTPRequest.UsePassive := TRUE;
//         FTPRequest.UseBinary := TRUE;
//         RealFileStream := FileStream.OpenRead(FileNameToUpload);
//         SimpleStream := FTPRequest.GetRequestStream;
//         RealFileStream.CopyTo(SimpleStream);
//         SimpleStream.Close;
//         RealFileStream.Close;
//     end;


//     procedure GetFilename(Index: Integer): Text
//     begin
//         EXIT(FORMAT(FilesList.Item(Index)));
//     end;


//     procedure DownloadFiles(FTPAddressWithFolder: Text; DownloadToFolder: Text; FTPUserID: Text; FTPPassword: Text)
//     var
//         Counter: Integer;
//         FilesCount: Integer;
//     begin
//         FilesCount := GetFilesList(FTPAddressWithFolder, FTPUserID, FTPPassword);
//         IF FilesCount > 0 THEN BEGIN
//             FOR Counter := 0 TO FilesCount - 1 DO BEGIN
//                 DownloadFile(FTPAddressWithFolder + GetFilename(Counter), DownloadToFolder + GetFilename(Counter), FTPUserID, FTPPassword, FALSE);//TRUE TO DELETE
//             END;
//         END;
//     end;


//     procedure UploadFiles(UploadFromFolder: Text; UploadToFTPAddressWithFolder: Text; FTPUserID: Text; FTPPassword: Text)
//     begin
//         Files.RESET;
//         Files.SETRANGE(Path, UploadFromFolder);
//         Files.SETRANGE("Is a file", TRUE);
//         IF Files.FIND('-') THEN BEGIN
//             REPEAT
//                 UploadFile(Files.Path + Files.Name, UploadToFTPAddressWithFolder + Files.Name, FTPUserID, FTPPassword);
//             UNTIL Files.NEXT = 0;
//         END;
//     end;


//     procedure UploadFilesToFTP(FileToUpload: Text)
//     var
//         FTPWebRequest: DotNet FtpWebRequest;
//         FTPWebResponse: DotNet FileWebResponse;
//         NetworkCredential: DotNet NetworkCredential;
//         WebRequestMethods: DotNet WebRequestMethods_File;
//         UTF8Encoding: DotNet UTF8Encoding;
//         ResponseStream: InStream;
//         FileStream: DotNet FileStream;
//         TempBlob: Record TempBlob temporary;
//         FileName: Text;
//         OutStream: OutStream;
//         [RunOnClient]
//         SearchOption: DotNet SearchOption;
//         [RunOnClient]
//         ArrayHelper: DotNet Array;
//         ArrayLength: Integer;
//         [RunOnClient]
//         DirectoryHelper: DotNet Directory;
//         i: Integer;
//         RelativeServerPath: Text;
//         ClientFilePath: DotNet String;
//         PathHelper: DotNet Path;
//         FileDotNet: DotNet File;
//         Stream: DotNet Stream;
//     begin
//         FTPWebRequest := FTPWebRequest.Create('ftp://silk8/' + PathHelper.GetFileName(FileToUpload));
//         //FTPWebRequest := FTPWebRequest.Create('ftp://nav:nav@silk8/' + PathHelper.GetFileName(FileToUpload));
//         FTPWebRequest.Credentials := NetworkCredential.NetworkCredential('nav', 'nav');
//         //FTPWebRequest.Credentials := NetworkCredential.NetworkCredential('anonymous','');



//         FTPWebRequest.UseBinary := TRUE;
//         FTPWebRequest.UsePassive := TRUE;
//         FTPWebRequest.KeepAlive := TRUE;
//         FTPWebRequest.Method := 'STOR';

//         FileStream := FileDotNet.OpenRead(FileToUpload);
//         Stream := FTPWebRequest.GetRequestStream();
//         FileStream.CopyTo(Stream);
//         Stream.Close;

//         FTPWebResponse := FTPWebRequest.GetResponse();
//         FTPWebResponse.Close();
//         //FILE.ERASE(FileToUpload);
//     end;
// }

