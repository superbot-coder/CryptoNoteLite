unit UFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls,
  Vcl.ActnMenus, System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls,
  SynEdit, SynEditHighlighter, SynEditCodeFolding, SynHighlighterPas,
  SynHighlighterGeneral, Vcl.StdCtrls, SynHighlighterJSON, System.JSON, REST.JSON,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Menus, System.ImageList, Vcl.ImgList, Vcl.Themes,
  System.IOUtils, System.StrUtils, CryptMod;

type
  TFrmMain = class(TForm)
    ActionManager: TActionManager;
    ActOpenFile: TAction;
    ActExit: TAction;
    OpenDialog: TOpenDialog;
    SynGeneralSyn: TSynGeneralSyn;
    SynJSONSyn: TSynJSONSyn;
    ActEncryptAndSaveFile: TAction;
    PnlMain: TPanel;
    SynEdit: TSynEdit;
    PMenu: TPopupMenu;
    MainMenu: TMainMenu;
    A1: TMenuItem;
    Openfilejson1: TMenuItem;
    N1: TMenuItem;
    ImageList: TImageList;
    StatusBar: TStatusBar;
    N2: TMenuItem;
    MM_WordWrap: TMenuItem;
    PnlBar: TPanel;
    BtnEnCrypt: TButton;
    BtnSave: TButton;
    BtnSaveAsDecrypt: TButton;
    ActKeepDecrypt: TAction;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    ActSaveEdit: TAction;
    N6: TMenuItem;
    N7: TMenuItem;
    MM_SetMasterPass: TMenuItem;
    MM_Settings: TMenuItem;
    N8: TMenuItem;
    SaveDialog: TSaveDialog;
    LblFile: TLabel;
    LblFileName: TLabel;
    ActAddNew: TAction;
    N9: TMenuItem;
    ActMasterPassDown: TAction;
    N10: TMenuItem;
    procedure ActExitExecute(Sender: TObject);
    procedure ActOpenFileExecute(Sender: TObject);
    procedure ActEncryptAndSaveFileExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MM_WordWrapClick(Sender: TObject);
    procedure ActKeepDecryptExecute(Sender: TObject);
    function MBox(MsgStr: String; uType: Cardinal): Integer;
    procedure SynEditChange(Sender: TObject);
    procedure ActSaveEditExecute(Sender: TObject);
    procedure ActAddNewExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MM_SetMasterPassClick(Sender: TObject);
    procedure ActMasterPassDownExecute(Sender: TObject);
  private
    FIsEncrypt: Boolean;
    FFileName: string;
    FDate_create: TDateTime;
    FDate_change: TDateTime;
    FSessionKey: AnsiString;
    FMasterPassword: AnsiString;
    FOldPassword: AnsiString;
    FPASSWORD: AnsiString;
    FSuccessDecrypted: Boolean;
    procedure DecryptOpenFile;
    function GetMasterPassword: AnsiString;
    procedure SetMasterPassword(APassStr: AnsiString);
    procedure UpDateStatusBar;
    function GetOldPassword: AnsiString;
    procedure SetOldPassword(const Value: AnsiString);
    function GetPassword: AnsiString;
    procedure SetPassword(const Value: AnsiString);
  public
    JSONFile: TJSONObject;
    property MASTER_PASSWORD: AnsiString read GetMasterPassword write SetMasterPassword;
    property OLD_PASSWORD: AnsiString read GetOldPassword write SetOldPassword;
    property PASSWORD: AnsiString read GetPassword write SetPassword;
    property CurrentFileName: string read FFileName;
    property DateCreate: TDateTime read FDate_create;
    property DateChange: TDateTime read FDate_change;
    property IsEncrypt: Boolean read FIsEncrypt;
    property IsSuccessDecrypted: Boolean read FSuccessDecrypted;
    function FormatFileTimeToStr(LocalTime: tFileTime): String;
    function FormatDateTimeToStr(DateTimeStr: String): String;
  end;

var
  FrmMain: TFrmMain;
  G_PWDHASH: AnsiString;

Const
  CAPTION_MB = 'Crypto NOTE Lite';
  FileFilter1 = 'Шифрованный файл (*.cryjson)|*.cryjson';
  FileFilter2 = 'Текстовый файл (*.txt)|*.txt';
  FileFilter3 = 'Любой файл (*.*)|*.*';

implementation

{$R *.dfm}

USES UFrmSelectEncrypt, UFrmMasterPwd;

procedure TFrmMain.ActOpenFileExecute(Sender: TObject);
var
  ext: string;
begin
  if Not OpenDialog.Execute then Exit;
  FFileName := OpenDialog.FileName;
  LblFileName.Caption := OpenDialog.FileName;
  ext := ExtractFileExt(AnsiLowerCase(OpenDialog.fileName));
  if (ext = '.cryjson') or (ext = '.crytxt') then
  begin
    DecryptOpenFile;
    if IsSuccessDecrypted = false then
    begin
      FFileName := '';
    end;

  end
  else
  begin
    SynEdit.Lines.LoadFromFile(OpenDialog.FileName);
    SynEdit.Modified := false;
    JSONFile         := Nil;
    FIsEncrypt       := false;
    ActKeepDecrypt.Enabled := false;
    ActSaveEdit.Enabled    := false;
  end;
  UpDateStatusBar;
end;

procedure TFrmMain.ActSaveEditExecute(Sender: TObject);
begin
  if Not SynEdit.Modified then
  begin
    MBox('OK!', MB_ICONINFORMATION);
    Exit;
  end;

  if IsEncrypt then
  begin
    ActEncryptAndSaveFileExecute(Sender);
  end
    else
  begin
    ActKeepDecryptExecute(Sender);
  end;
end;

procedure TFrmMain.ActExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.ActKeepDecryptExecute(Sender: TObject);
var
  ext: string;
  SaveFileName: string;
begin
  {
  if SynEdit.Lines.Text = '' then
  begin
    // message
    Exit;
  end; }

  SaveDialog.Filter := FileFilter2 + '|' + FileFilter3;

  if CurrentFileName = '' then
  begin
    if Not SaveDialog.Execute then Exit;
    if SaveDialog.FilterIndex = 1 then
    begin
     ext := AnsiLowerCase(ExtractFileExt(SaveDialog.FileName));
     if (ext = '') or (ext <> '.txt') then
       SaveFileName := SaveDialog.FileName + '.txt';
    end
    else
      SaveFileName := SaveDialog.FileName;
  end
    else
  begin
    if Sender = ActKeepDecrypt then
    begin
      SaveFileName := CurrentFileName;
      ext := ExtractFileExt(CurrentFileName);
      delete(SaveFileName, Length(SaveFileName)-length(ext)+1, length(ext));
      SaveFileName := SaveFileName + '.txt';
      SaveDialog.FileName := SaveFileName;
      if Not SaveDialog.Execute then Exit;
      SaveFileName := SaveDialog.FileName;
    end
    else
      SaveFileName := CurrentFileName;
  end;

  if Sender = ActKeepDecrypt then
    if FileExists(SaveFileName) then
      if MessageBox(Handle,
                    PChar('Файл с таким именем уже существует, заменить его?'),
                    PChar(CAPTION_MB), MB_YESNO) = ID_NO then Exit;

  //ShowMessage(SaveFileName);
  SynEdit.Lines.SaveToFile(SaveFileName);
  //LblFileName.Caption := SaveDialog.FileName;
  //FIsEncrypt          := false;
  //SynEdit.Modified    := false;
  UpDateStatusBar;
  MBox('Данные успешно сохранены.', MB_ICONINFORMATION);
end;

procedure TFrmMain.ActMasterPassDownExecute(Sender: TObject);
begin
  if MASTER_PASSWORD = '' then Exit;
  if MBox('Что бы выполнить это действие' + #13
          + 'необходимо ввести мастер-пароль' + #13
          + 'продолжить?', MB_YESNO or MB_ICONQUESTION) = ID_NO then Exit;
  Repeat
    FrmMasterPwd.ShowModeDlg(DLG_OLDPWD);
    if Not FrmMasterPwd.Apply then Exit;
  Until MASTER_PASSWORD = FrmMasterPwd.OLD_PASSWORD;

  // Сбрас MASTER_PASSWORD
  FMasterPassword := '';
  MBox('мастер-пароль сброшен.', MB_ICONINFORMATION);
end;

procedure TFrmMain.ActAddNewExecute(Sender: TObject);
var
  ID_RES: integer;
begin
  if (SynEdit.lines.Text <> '') and SynEdit.Modified then  // (CurrentFileName <> '')
  begin
    ID_RES := MBox('Предыдущий текст необходимо сохранить?', MB_YESNOCANCEL or MB_ICONQUESTION);
    if ID_RES = ID_CANCEL then Exit;
    if ID_RES = ID_YES then ActSaveEditExecute(Sender);
  end;
  SynEdit.Lines.Clear;
  SynEdit.Modified    := false;
  FFileName           := '';
  FPASSWORD           := '';
  FIsEncrypt          := false;
  JSONFile            := Nil;
  LblFileName.Caption := '<Новая запись>';
  ActEncryptAndSaveFile.Enabled := false;
  ActSaveEdit.Enabled    := false;
  ActKeepDecrypt.Enabled := false;
  UpDateStatusBar;
end;

procedure TFrmMain.ActEncryptAndSaveFileExecute(Sender: TObject);
var
  dt: TDateTime;
  JContent     : TJSONObject;
  content_hash : String;
  AEContent    : AnsiString;
  JSONBytes    : TBytes;
  JValue       : TJSONValue;
  SaveFile     : String;
  ALGO         : TAlgoType;
  //PASSWORD     : AnsiString;
begin

  if (Not SynEdit.Modified) and (SynEdit.lines.Text = '') then
  begin
    MBox('Действие остановлено: Пустое содержание', MB_ICONWARNING);
    Exit;
  end;

  // Выбор алгоритма шифрования; Select crypt algoritm for encrypt
  if Sender = ActEncryptAndSaveFile then
  begin
    FrmSelectEncrypt.FrmShowModal(DLG_ECRYPT);
    if Not FrmSelectEncrypt.Apply then Exit;
    ALGO := FrmSelectEncrypt.ALGO;
  end;

  if PASSWORD = '' then
    if (not FrmSelectEncrypt.SelMasterPassword) or (MASTER_PASSWORD = '') then
    begin
      FrmMasterPwd.ShowModeDlg(DLG_OLDPWD);
      if Not FrmMasterPwd.Apply then Exit;
      PASSWORD := FrmMasterPwd.OLD_PASSWORD;
    end
    else
      PASSWORD := MASTER_PASSWORD;

  dt := Date + Time;
  JContent := TJSONObject.Create;
  JContent.AddPair('content', SynEdit.Lines.Text);
  JContent.AddPair('content_hash', GetSHA1Hash(SynEdit.Lines.Text));

  if Sender = ActSaveEdit then
    ALGO := GetAlgoType(JSONFile.FindValue('algo_type').Value);

  case ALGO of
    RC4_SHA1   : AEContent := EncryptRC4_SHA1(PASSWORD, JContent.ToJSON);
    RC4_SHA256 : AEContent := EncryptRC4_SHA256(PASSWORD, JContent.ToJSON);
    RC4_SHA512 : AEContent := EncryptRC4_SHA512(PASSWORD, JContent.ToJSON);
  end;

  content_hash := GetSHA1Hash(AEContent);

  if JSONFile = Nil then
  begin
    JSONFile := TJSONObject.Create;
    With JSONFile do
    begin
      AddPair('version', TJSONNumber.Create(1));
      AddPair('algo_type', FrmSelectEncrypt.CmBoxExAlgo.Text);
      AddPair('date_create', DateTimeToStr(dt));
      AddPair('date_change', DateTimeToStr(dt));
      AddPair('content_hash', content_hash);
      AddPair('encrypted_content', AEContent);
    end;
  end
  else
  begin
    With JSONFile do
    begin
      JValue := FindValue('algo_type');
      JValue.Free;
      JValue := TJSONString.Create(FrmSelectEncrypt.CmBoxExAlgo.Text);
      JValue := FindValue('date_change');
      JValue.Free;
      JValue := TJSONString.Create(DateTimeToStr(dt));
      Jvalue := FindValue('content_hash');
      JValue.Free;
      JValue := TJSONString.Create(content_hash);
      JValue := FindValue('encrypted_content');
      JValue.Free;
      JValue := TJSONString.Create(AEContent);
    end;
  end;

  // Выбор файла, если он не существует; Select file If filename not existes
  if CurrentFileName = '' then
  begin
    SaveDialog.filter := FileFilter1;
    if Not SaveDialog.Execute then Exit;

    SaveFile :=  AnsiLowerCase(SaveDialog.FileName);

    if ExtractFileExt(SaveFile) <> '.cryjson' then SaveFile := SaveFile + '.cryjson';


    if FileExists(SaveFile) then
      if MBox('Файл с таким именем существует, заменить его?',
              MB_YESNO or MB_ICONWARNING) = ID_NO then Exit;

    // Сохраняю содержимое в файл; Saving content to a file
    TFile.WriteAllText(SaveFile, JSONFile.toJson);
    FFileName  := SaveFile;
    FIsEncrypt := true;
    LblFileName.Caption := SaveFile;
  end
  else
  begin
    if Sender = ActEncryptAndSaveFile then
      if FileExists(CurrentFileName) then
        if MBox('Открытый файл будет сохранен с новыми изменениями, продолжить?',
              MB_YESNO or MB_ICONWARNING) = ID_NO then Exit;
    // Сохраняю содержимое в файл; Saving content to a file
    TFile.WriteAllText(CurrentFileName, JSONFile.toJson);
    SynEdit.Modified    := false;
    ActSaveEdit.Enabled := false;
  end;
  MBox('Всё выполнено успешно.', MB_ICONINFORMATION);
  UpDateStatusBar;
end;

{------------------------------- DecryptOpenFile ------------------------------}
procedure TFrmMain.DecryptOpenFile;
var
  ALGO: TAlgoType;
  AStrCrypt, AContent: AnsiString;
  StrValue: string;
  JContent: TJSONObject;
  Hash: String;
  //PASSWORD: AnsiString;
  second_attempt: Boolean;
begin
  FSuccessDecrypted := false;
  JSONFile := TJSONObject.ParseJSONValue(TFile.ReadAllBytes(CurrentFileName), 0) as TJSONObject;
  if JSONFile = Nil then
  begin
    MBox('Файл не сродержит формат "JSON" JSONFile = Nil', MB_ICONERROR); // error message
    Exit;
  end;

  if JSONFile.FindValue('encrypted_content') = Nil then
  begin
    MBox('В файле не найден параметр "encrypted_content"', MB_ICONERROR); //error message
    Exit;
  end;

  AStrCrypt := JSONFile.GetValue('encrypted_content').Value;

  if JSONFile.FindValue('algo_type') = Nil then
  begin
    MBox('В файле не найден параметр: "algo_type"', MB_ICONERROR); //error message
    Exit;
  end;

  ALGO := GetAlgoType(JSONFile.GetValue('algo_type').Value);

  repeat

    if (MASTER_PASSWORD = '') or second_attempt then
    begin
      FrmMasterPwd.ShowModeDlg(DLG_OLDPWD);
      PASSWORD := FrmMasterPwd.OLD_PASSWORD;
    end
    else
      PASSWORD := MASTER_PASSWORD;

    //ShowMessage('PASSWORD: ' + PASSWORD);
    case ALGO of
      RC4_SHA1:   AContent := DecryptRC4_SHA1(PASSWORD, AStrCrypt);
      RC4_SHA256: AContent := DecryptRC4_SHA1(PASSWORD, AStrCrypt);
      RC4_SHA512: AContent := DecryptRC4_SHA1(PASSWORD, AStrCrypt);
      else
      begin
        MBox('В файле указан не верный тип шифрования.', MB_ICONERROR);
        Exit;
      end;
    end;

    if Length(AContent) = 0 then
    begin
      MBox('AContent имеет 0 символов', MB_ICONERROR); // error message
      Exit;
    end;

    JContent := TJSONObject.ParseJSONValue(AContent) as TJSONObject;
    if JContent = nil then
    begin
      if MBox('Не удалось расшифровать содержание' + #13
              + 'сделать попытку с другим паролем?',
              MB_ICONQUESTION or MB_YESNO) = ID_NO then Exit; // error message
      second_attempt := true;
    end
      else
    FSuccessDecrypted := true;

  until FSuccessDecrypted;

  if JContent.FindValue('content') = Nil then
  begin
    MBox('Не найден параметр "content" в JContent', MB_ICONERROR);// error message
    Exit;
  end;
  StrValue := JContent.GetValue('content').Value;
  if Jcontent.FindValue('content_hash') = Nil then
  begin
    MBox('Не найден параметр "content_hash" в JContent', MB_ICONERROR);// error message
    Exit;
  end;
  Hash := JContent.GetValue('content_hash').Value;
  if Hash <> GetSHA1Hash(StrValue) then
  begin
    // error message
    MBox('Проверка content_hash вернула, ' +
                'что он не равен хешу контента', MB_ICONERROR);
    // Exit;
  end;

  SynEdit.Lines.Text := StrValue;
  SynEdit.Modified   := false;

  FIsEncrypt := true;
  UpDateStatusBar;
  ActKeepDecrypt.Enabled := true;
  ActSaveEdit.Enabled    := false;
end;


function TFrmMain.FormatDateTimeToStr(DateTimeStr: String): String;
var
  sys_time: _SYSTEMTIME;
  dt_str: string;
begin
  DateTimeToSystemTime(StrToDateTime(DateTimeStr), sys_time);
  SetLength(dt_str, GetDateFormat(LOCALE_SYSTEM_DEFAULT, 0, @sys_time, PChar('dd MMMM yyyy'), Nil, 0));
  GetDateFormat(LOCALE_SYSTEM_DEFAULT, 0, @sys_time, PChar('dd MMMM yyyy'), PChar(dt_str), Length(dt_str));
  Result := Trim(dt_str) + ' ' +TimeToStr(SystemTimeToDateTime(sys_time));
end;

function TFrmMain.FormatFileTimeToStr(LocalTime: tFileTime): String;
var
  sys_time: _SYSTEMTIME;
  dt_str: string;
begin
  FileTimeToSystemTime(LocalTime, sys_time);
  SetLength(dt_str, GetDateFormat(LOCALE_SYSTEM_DEFAULT, 0, @sys_time, PChar('dd MMMM yyyy'), Nil, 0));
  GetDateFormat(LOCALE_SYSTEM_DEFAULT, 0, @sys_time, PChar('dd MMMM yyyy'), PChar(dt_str), Length(dt_str));
  Result := Trim(dt_str) + ' ' +TimeToStr(SystemTimeToDateTime(sys_time));
end;

{-------------------------------- FormCreate ----------------------------------}
procedure TFrmMain.FormCreate(Sender: TObject);
begin
  FSessionKey := GetTrashStr(20);
  FIsEncrypt  := false;
  ActEncryptAndSaveFile.Enabled := false;
  ActKeepDecrypt.Enabled        := false;
  ActSaveEdit.Enabled           := false;
  UpDateStatusBar;
  TStyleManager.SetStyle('Amethyst Kamri'); // 'Sapphire Kamri'
end;

procedure TFrmMain.FormShow(Sender: TObject);
var
  ext: string;
begin
  if ParamCount > 0 then
  begin
    ext := AnsiLowerCase(ExtractFileExt(ParamStr(1)));
    if ext <> '.cryjson' then Exit;
    FFileName := ParamStr(1);
    DecryptOpenFile;
    LblFileName.Caption := (ParamStr(1));
  end;
end;

function TFrmMain.GetMasterPassword: AnsiString;
begin
  if FMasterPassword = '' then Exit;
  Result := DecryptRC4_SHA1(FSessionKey, FMasterPassword);
end;

function TFrmMain.GetOldPassword: AnsiString;
begin
  Result := DecryptRC4_SHA1(FSessionKey, FOldPassword);
end;

function TFrmMain.GetPassword: AnsiString;
begin
  Result := DecryptRC4_SHA1(FSessionKey, FPASSWORD);
end;

procedure TFrmMain.MM_SetMasterPassClick(Sender: TObject);
begin
  FrmMasterPwd.ShowModeDlg(DLG_MASTERPWD);
end;

procedure TFrmMain.MM_WordWrapClick(Sender: TObject);
begin
  if MM_WordWrap.Checked then
    SynEdit.WordWrap := true
  else
    SynEdit.WordWrap := false;
end;

procedure TFrmMain.SetMasterPassword(APassStr: AnsiString);
begin
  if APassStr = '' then
  begin
    FMasterPassword := '';
    Exit;
  end;
  FMasterPassword := EncryptRC4_SHA1(FSessionKey, APassStr);
end;

procedure TFrmMain.SetOldPassword(const Value: AnsiString);
begin
  FOldPassword := EncryptRC4_SHA1(FSessionKey, Value);
end;

procedure TFrmMain.SetPassword(const Value: AnsiString);
begin
  FPASSWORD := EncryptRC4_SHA1(FSessionKey, Value);
end;

procedure TFrmMain.SynEditChange(Sender: TObject);
begin
  if CurrentFileName <> '' then ActSaveEdit.Enabled := true;
  ActEncryptAndSaveFile.Enabled := true;
  if IsEncrypt then ActKeepDecrypt.Enabled := true;
end;

procedure TFrmMain.UpDateStatusBar;
var
  SR: TSearchRec;
  LocalTime: tFileTime;
begin
  if JSONFile <> Nil then
  begin
    if JSONFile.FindValue('date_create') <> nil then
      StatusBar.Panels[0].Text := 'Создан: ' +
              FormatDateTimeToStr(JSONFile.GetValue('date_create').Value);

    if JSONFile.FindValue('date_change') <> nil then
      StatusBar.Panels[1].Text := 'Изменен: ' +
              FormatDateTimeToStr(JSONFile.GetValue('date_change').Value);
  end
  else
  begin
    if FileExists(CurrentFileName) then
    begin
      if FindFirst(CurrentFileName, faAnyFile, SR) = 0 then
      begin
        FileTimeToLocalFileTime(SR.FindData.ftCreationTime, LocalTime);
        StatusBar.Panels[0].Text := 'Создан: ' + FormatFileTimeToStr(LocalTime);
        FileTimeToLocalFileTime(SR.FindData.ftLastWriteTime, LocalTime);
        StatusBar.Panels[1].Text := 'Изменен: ' + FormatFileTimeToStr(LocalTime);
      end;
    end
    else
    begin
      StatusBar.Panels[0].Text := 'Создан:';
      StatusBar.Panels[1].Text := 'Изменен:';
    end;
  end;
  if IsEncrypt then
  begin
    StatusBar.Panels[2].Text := 'Шифрованный: Да';
    //if JSONFile.FindValue('algo_type') <> Nil then
    StatusBar.Panels[3].Text := 'ALGO: ' + JSONFile.GetValue('algo_type').Value;
  end
    else
  begin
    StatusBar.Panels[2].Text := 'Шифрованный: Нет';
    StatusBar.Panels[3].Text := 'ALGO: ';
  end;
end;

function TFrmMain.MBox(MsgStr: String; uType: Cardinal): Integer;
var
  s: String;
begin
  case uType of
    MB_ICONERROR:       s := 'Ошибка: ';
    MB_ICONWARNING:     s := 'Предупреждение: ';
    MB_ICONINFORMATION: s := 'Информация: ';
  end;
  Result := MessageBox(FrmMain.Handle, PChar(s + MsgStr), PChar(CAPTION_MB), uType);
end;

end.
