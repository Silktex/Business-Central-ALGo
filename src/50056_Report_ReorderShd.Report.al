// report 50056 "Reorder Shd"
// {
//     ProcessingOnly = true;

//     dataset
//     {
//     }

//     requestpage
//     {

//         layout
//         {
//         }

//         actions
//         {
//         }
//     }

//     labels
//     {
//     }

//     trigger OnPostReport()
//     var
//         Name: Text[50];
//         FileName: Text[250];
//         ToFile: Text[250];
//         SMTPMail: Codeunit "SMTP Mail";
//         textDate: Text[8];
//         PathHelper: DotNet Path;
//     begin
//         textDate := FORMAT(WORKDATE, 0, '<Year4><Month,2><Day,2>');
//         Name := 'ReOrderReport' + textDate + '.xlsx';
//         ToFile := Name;
//         FileName := TEMPORARYPATH + ToFile;
//         REPORT.SAVEASEXCEL(50030, FileName);
//         //ToFile := SMTPMail.DownloadToClientFileName(FileName, ToFile);
//         //COPY(FileName,'\\silk4\share\'+PathHelper.GetFileName(FileName));
//         COPY(FileName, '\\silk8\users\Reports\SC ReOrder\' + PathHelper.GetFileName(FileName));
//         //UploadFilesToFTP(FileName);

//         ERASE(FileName);
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

