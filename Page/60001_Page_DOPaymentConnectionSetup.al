page 60001 "DO Payment Connection Setup"
{
    Caption = 'Microsoft Dynamics ERP Payment Services Connection Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "DO Payment Connection Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Active; Rec.Active)
                {
                    ApplicationArea = all;
                }
                field("Run in Test Mode"; Rec."Run in Test Mode")
                {
                    ApplicationArea = all;
                }
                field("Service ID"; Rec."Service ID")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(SignUpNowAction)
                {
                    Caption = 'Sign up Now';
                    Ellipsis = true;
                    Image = SignUp;
                    ApplicationArea = all;

                    trigger OnAction()
                    begin
                        Rec.SignUp;
                    end;
                }
                action(ManageAccountAction)
                {
                    Caption = 'Manage Account';
                    Ellipsis = true;
                    Image = EditCustomer;
                    ApplicationArea = all;

                    trigger OnAction()
                    begin
                        Rec.ManageAccount;
                    end;
                }
                action(DisassociateAccountAction)
                {
                    Caption = 'Disassociate Account';
                    Ellipsis = true;
                    Image = UnLinkAccount;
                    ApplicationArea = all;

                    trigger OnAction()
                    begin
                        Rec.Disassociate;
                        Message(UnlinkMessage);
                    end;
                }
            }
            group(EncryptionActionGroup)
            {
                Caption = 'Encryption';
                action(GenerateKeyAction)
                {
                    Caption = 'Generate Key';
                    Image = CreateDocument;
                    ApplicationArea = all;

                    trigger OnAction()
                    begin
                        //if EncryptionMgt.IsEncryptionEnabled then
                        if EncryptionEnabled() then
                            if not Confirm(OverwriteExistingKeyWarning) then
                                exit;

                        //EncryptionMgt.ChangeKey();
                        // CreateEncryptionKey(); //Vr
                        Message(KeyGeneratedMessage);
                    end;
                }
                action(DeleteKeyAction)
                {
                    Caption = 'Delete Key';
                    Image = Delete;
                    ApplicationArea = all;

                    trigger OnAction()
                    begin
                        //if not EncryptionMgt.IsEncryptionEnabled() then
                        if not EncryptionEnabled() then
                            Error(KeyDoesNotExistError);

                        if not Confirm(DeleteKeyWarning) then
                            exit;

                        // EncryptionMgt.DisableEncryption(true);
                        // DeleteEncryptionKey(); //VR
                        Message(KeyDeletedMessage);
                    end;
                }
                action(ExportKeyAction)
                {
                    Caption = 'Download Key';
                    Image = Export;
                    ApplicationArea = all;

                    trigger OnAction()
                    var
                        FileMgt: Codeunit "File Management";
                        //StdPasswordDialog: Page "Std. Password Dialog"; //VR
                        ServerFilename: Text;
                        ClientFilename: Text;
                        PasswordText: Text;
                    begin
                        //EncryptionMgt.ExportKey(); //VR

                        /*
                        ServerFilename := FileMgt.ServerTempFileName('key');
                        StdPasswordDialog.EnableBlankPassword(FALSE);
                        IF StdPasswordDialog.RUNMODAL = ACTION::OK THEN
                          PasswordText := StdPasswordDialog.GetPasswordValue
                        ELSE
                          EXIT;
                        
                        EncryptionMgt.Export(ServerFilename,PasswordText);
                        
                        ClientFilename := 'Encryption.key';
                        IF DOWNLOAD(ServerFilename,'','','',ClientFilename) THEN;
                        ERASE(ServerFilename);
                        */

                    end;
                }
                action(ImportKeyAction)
                {
                    Caption = 'Upload Key';
                    Image = Import;
                    ApplicationArea = all;

                    trigger OnAction()
                    var
                        //StdPasswordDialog: Page "Std. Password Dialog"; //VR
                        ServerFilename: Text;
                        PasswordText: Text;
                    begin
                        //EncryptionMgt.ImportKey(); //VR
                        //CreateEncryptionKey(); //vr

                        /*
                        IF UPLOAD('','','','',ServerFilename) THEN BEGIN
                          StdPasswordDialog.EnableBlankPassword(TRUE);
                          IF StdPasswordDialog.RUNMODAL = ACTION::OK THEN
                            PasswordText := StdPasswordDialog.GetPasswordValue
                          ELSE
                            EXIT;
                        
                          IF EncryptionMgt.HasKey THEN
                            IF NOT CONFIRM(OverwriteExistingKeyWarning) THEN
                              EXIT;
                        
                          EncryptionMgt.Import(ServerFilename,PasswordText);
                        END;
                        */

                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.CreateDefaultSetup;
    end;

    var
        // EncryptionMgt: Codeunit "Encryption Management";
        OverwriteExistingKeyWarning: Label 'Changing the key may render existing data unreadable. Do you want to continue?';
        DeleteKeyWarning: Label 'Deleting the key will render existing data unreadable. Do you want to continue?';
        KeyDoesNotExistError: Label 'Encryption key does not exist.';
        KeyDeletedMessage: Label 'Encryption key was successfully deleted.';
        KeyGeneratedMessage: Label 'Encryption key was successfully generated.';
        UnlinkMessage: Label 'Disassociation of the account has succeeded.';
    //EncryptedKeyValueManagement: Codeunit "Encrypted Key/Value Management";
}

