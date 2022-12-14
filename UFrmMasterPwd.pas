unit UFrmMasterPwd;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Registry, CryptMod;

Type
  TDlgPwdMode = (DLG_MASTERPWD, DLG_OLDPWD, DLG_OLDPWD_TWO);

type
  TFrmMasterPwd = class(TForm)
    BtnApply: TButton;
    edPwd1: TLabeledEdit;
    edPwd2: TLabeledEdit;
    ChBoxStrView: TCheckBox;
    ChBoxSaveНаrdLink: TCheckBox;
    procedure BtnApplyClick(Sender: TObject);
    procedure ChBoxStrViewClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure SaveMasterPassword;
    procedure ShowModeDlg(DlgMode: TDlgPwdMode);
  private
    FApply: Boolean;
    FDialogMode: TDlgPwdMode;
    FPassword: AnsiString;
    Procedure ReadPassword;
    function GetPassword: AnsiString;
  public
    property PASSWORD: AnsiString read GetPassword;
    Property Apply: Boolean read FApply;
  end;

var
  FrmMasterPwd: TFrmMasterPwd;
  Reg: Tregistry;

implementation

USES UFrmMain;

{$R *.dfm}

procedure TFrmMasterPwd.BtnApplyClick(Sender: TObject);
begin
  if edPwd1.Text = '' then
  begin
    ShowMessage('Введите пароль.');
    exit;
  end;

  case FDialogMode of
    DLG_MASTERPWD:
      begin
        if edPwd1.Text <> edPwd2.Text then
        begin
          ShowMessage('Веденные пароли не совпадают');
          exit;
        end;
        FrmMain.MASTER_PASSWORD := edPwd1.Text; //  := ;
        SaveMasterPassword;
      end;
    DLG_OLDPWD:
      begin
        FPassword := edPwd1.Text;
        edPwd1.Text  := '';
      end;
    DLG_OLDPWD_TWO:
     begin
       if edPwd1.Text <> edPwd2.Text then
       begin
         ShowMessage('Веденные пароли не совпадают');
         exit;
       end;
       FPassword := edPwd1.Text;
     end;
  end;
  FApply := True;
  Close;
end;

procedure TFrmMasterPwd.ChBoxStrViewClick(Sender: TObject);
begin
  if ChBoxStrView.Checked then
  begin
    edPwd1.PasswordChar := #0;
    edPwd2.PasswordChar := #0;
  end
  else
  begin
    edPwd1.PasswordChar := '*';
    edPwd2.PasswordChar := '*';
  end;
end;

procedure TFrmMasterPwd.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  edPwd1.Text := '';
  edPwd2.Text := '';
end;

procedure TFrmMasterPwd.FormCreate(Sender: TObject);
begin
  ReadPassword;
end;

function TFrmMasterPwd.GetPassword: AnsiString;
begin
  Result := FPassword;
  FPassword := '';
end;

procedure TFrmMasterPwd.ShowModeDlg(DlgMode: TDlgPwdMode);
begin
  FApply := False;
  FDialogMode := DlgMode;

  Case DlgMode of
    DLG_MASTERPWD:
      begin
        Height  := 230;
        Caption := 'Мастер пароль';
        ChBoxSaveНаrdLink.Visible := True;
        ChBoxSaveНаrdLink.Checked := False;
        edPwd2.Show;
      end;
    DLG_OLDPWD:
      begin
        Height  := 160;
        Caption := 'Пароль';
        ChBoxSaveНаrdLink.Visible := False;
        edPwd1.Text := '';
        edPwd2.Hide;
      end;
    DLG_OLDPWD_TWO:
      begin
        Height  := 210;
        Caption := 'Пароль';
        ChBoxSaveНаrdLink.Visible := false;
        ChBoxSaveНаrdLink.Checked := False;
        edPwd2.Show;
      end;
  End;
  ShowModal;
end;

procedure TFrmMasterPwd.ReadPassword;
var
  Reg: Tregistry;
begin
  try
    Reg := Tregistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\CryptoNote', True) then
    begin
      G_PWDHASH := Reg.ReadString('PasswordHash');
      FrmMain.MASTER_PASSWORD := Reg.ReadString('MasterPassword');

      if FrmMain.MASTER_PASSWORD = '' then
      begin
        G_PWDHASH := '';
        exit;
      end;

      FrmMain.MASTER_PASSWORD := DecryptRC4_SHA1(GetKey, FrmMain.MASTER_PASSWORD);

      if G_PWDHASH = GetMD5Hash(FrmMain.MASTER_PASSWORD) then
      begin
        FrmMain.MASTER_PASSWORD := copy(FrmMain.MASTER_PASSWORD, 1,
          Length(FrmMain.MASTER_PASSWORD) - 16);
        edPwd1.Text := '********';
        edPwd2.Text := '********';
        ChBoxSaveНаrdLink.Checked := True;
      end
      else
      begin;
        G_PWDHASH := '';
        FrmMain.MASTER_PASSWORD := '';
        edPwd1.Text := '';
        edPwd2.Text := '';
      end;

      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TFrmMasterPwd.SaveMasterPassword;
var
  s_rand: AnsiString;
  PwdHash: AnsiString;
  i: Integer;
begin
  if ChBoxSaveНаrdLink.Checked then
  begin
    try
      Reg := Tregistry.Create;
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey('\Software\CryptoNote', True) then
      begin

        for i := 1 to 16 do
          s_rand := s_rand + AnsiChar(Random(255));
        PwdHash := GetMD5Hash(FrmMain.MASTER_PASSWORD + s_rand);

        Reg.WriteString('MasterPassword', EncryptRC4_SHA1(GetKey,
          FrmMain.MASTER_PASSWORD + s_rand));
        Reg.WriteString('PasswordHash', PwdHash);

        Reg.CloseKey;
        MessageBox(Handle,
          PChar('МАСТЕР ПАРОЛЬ сохранен и привязан к компьютеру, ' +
          ' МАСТЕР ПАРОЛЬ будет действовать пока его не замените.'),
          PChar(CAPTION_MB), MB_ICONINFORMATION);
      end;
    finally
      Reg.Free;
    end;
  end
  else
  begin
    try
      Reg := Tregistry.Create;
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey('\Software\CryptoNote', True) then
      begin
        Reg.WriteString('MasterPassword', '');
        Reg.WriteString('PasswordHash', '');
        Reg.CloseKey;
        MessageBox(Handle,
          PChar('МАСТЕР ПАРОЛЬ введен и будет действовать пока не закроете программу'),
          PChar(CAPTION_MB), MB_ICONINFORMATION);
      end;
    finally
      Reg.Free;
    end
  end;
end;

end.
