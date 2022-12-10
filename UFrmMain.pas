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
    LblOpenFile: TLabel;
    LblFileName: TLabel;
    procedure ActExitExecute(Sender: TObject);
    procedure ActOpenFileExecute(Sender: TObject);
    procedure ActEncryptAndSaveFileExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MM_WordWrapClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
  private
    FIsEncrypt: Boolean;
    FFileName: string;
    FDate_create: TDateTime;
    FDate_change: TDateTime;
    FSessionKey: AnsiString;
    FMasterPassword: AnsiString;
    FPASSWORD: AnsiString;
    procedure DecryptOpenFile;
    function GetMasterPaswword: AnsiString;
    procedure SetMasterPassword(APassStr: AnsiString);
    procedure UpDateStatusBar;
  public
    JSONFile: TJSONObject;
    property MASTER_PASSWORD: AnsiString read GetMasterPaswword write SetMasterPassword;
    property FileName: string read FFileName;
    property DateCreate: TDateTime read FDate_create;
    property DateChange: TDateTime read FDate_change;
    property IsEncrypt: Boolean read FIsEncrypt;
    procedure MsgBox(MsgStr: String; uType: Cardinal);
    function FormatFileTimeToStr(LocalTime: tFileTime): String;
    function FormatDateTimeToStr(DateTimeStr: String): String;
  end;

var
  FrmMain: TFrmMain;
  G_PWDHASH: AnsiString;

Const
  CAPTION_MB = 'Crypto NOTE Lite';

implementation

{$R *.dfm}

USES UFrmSelectEncrypt, UFrmMasterPwd;

procedure TFrmMain.ActOpenFileExecute(Sender: TObject);
var
  ext: string;
begin
  if Not OpenDialog.Execute then Exit;
  FFileName := OpenDialog.FileName;
  FrmMain.LblFileName.Caption := OpenDialog.FileName;
  ext := ExtractFileExt(AnsiLowerCase(OpenDialog.fileName));
  if (ext = '.cryjson') or (ext = '.ctxt') or (ext = '.crytxt') then
  begin
    DecryptOpenFile;
  end
  else
  begin
    SynEdit.Lines.LoadFromFile(OpenDialog.FileName);
    JSONFile := Nil;
    FIsEncrypt := false;
  end;
  UpDateStatusBar;
end;

procedure TFrmMain.BtnSaveClick(Sender: TObject);
Var
  JValue: TJSONValue;
begin
  //JSONFile.SetPairs('algo_type' TJSONString.Create('MODIFED'));
  JValue := JSONFile.GetValue('algo_type');
  JValue.Free;
  Jvalue := TJSONString.Create('Modifed');
  //JSONFile.AddPair('algo_type', 'Modifed');
  ///JSONFile.GetValue('algo_type') := TJSONString.Create('Modifed');
  ShowMessage(JSONFile.GetValue('algo_type').Value);
end;

procedure TFrmMain.ActExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.ActEncryptAndSaveFileExecute(Sender: TObject);
var
  dt: TDateTime;
  JContent     : TJSONObject;
  content_hash : String;
  AEContent    : AnsiString;
  JSONBytes    : TBytes;
  JValue       : TJSONValue;
begin

  if (Not SynEdit.Modified) and (SynEdit.lines.Text = '') then
  begin
    MsgBox('Действие остановлено: Пустое содержание', MB_ICONWARNING);
    Exit;
  end;

  // Выбор алгоритма шифрования; Select crypt algoritm for encrypt
  FrmSelectEncrypt.FrmShowModal(DLG_ECRYPT);
  if Not FrmSelectEncrypt.Apply then Exit;

  dt := Date + Time;
  JContent := TJSONObject.Create;
  JContent.AddPair('content', SynEdit.Lines.Text);
  JContent.AddPair('content_hash', GetSHA1Hash(SynEdit.Lines.Text));

  case FrmSelectEncrypt.ALGO of
    RC4_SHA1   : AEContent := EncryptRC4_SHA1(MASTER_PASSWORD, JContent.ToJSON);
    RC4_SHA256 : AEContent := EncryptRC4_SHA256(MASTER_PASSWORD, JContent.ToJSON);
    RC4_SHA512 : AEContent := EncryptRC4_SHA512(MASTER_PASSWORD, JContent.ToJSON);
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
  if FileName = '' then
  begin
    if SaveDialog.Execute then Exit;
    FFileName  := SaveDialog.FileName;
  end;

  // Сохраняю содержимое в файл; Saving content to a file
  TFile.WriteAllText(FileName, JSONFile.toJson);
  FIsEncrypt := true;
  MsgBox('Всё выполнена успешно.', MB_ICONINFORMATION);
end;

{------------------------------- DecryptOpenFile ------------------------------}
procedure TFrmMain.DecryptOpenFile;
var
  ALGO: TAlgoType;
  AStrCrypt, AContent: AnsiString;
  StrValue: string;
  JContent: TJSONObject;
  Hash: String;
begin
  JSONFile := TJSONObject.ParseJSONValue(TFile.ReadAllBytes(FileName), 0) as TJSONObject;
  if JSONFile = Nil then
  begin
    MsgBox('Файл не сродержит формат "JSON" JSONFile = Nil', MB_ICONERROR); // error message
    Exit;
  end;

  if JSONFile.FindValue('encrypted_content') = Nil then
  begin
    MsgBox('В файле не найден параметр "encrypted_content"', MB_ICONERROR); //error message
    Exit;
  end;

  AStrCrypt := JSONFile.GetValue('encrypted_content').Value;

  if JSONFile.FindValue('algo_type') = Nil then
  begin
    MsgBox('В файле не найден параметр: "algo_type"', MB_ICONERROR); //error message
    Exit;
  end;

  case GetAlgoType(JSONFile.GetValue('algo_type').Value) of
    RC4_SHA1:   AContent := DecryptRC4_SHA1(MASTER_PASSWORD, AStrCrypt);
    RC4_SHA256: AContent := DecryptRC4_SHA1(MASTER_PASSWORD, AStrCrypt);
    RC4_SHA512: AContent := DecryptRC4_SHA1(MASTER_PASSWORD, AStrCrypt);
    else
    begin
      MsgBox('В файле указан не верный тип шифрования.', MB_ICONERROR);
      Exit;
    end;
  end;

  if Length(AContent) = 0 then
  begin
    MsgBox('AContent имеет 0 символов', MB_ICONERROR); // error message
    Exit;
  end;
  JContent := TJSONObject.ParseJSONValue(AContent) as TJSONObject;
  if JContent = nil then
  begin
    MsgBox('Parse JContent = nil ', MB_ICONERROR); // error message
    Exit;
  end;
  if JContent.FindValue('content') = Nil then
  begin
    MsgBox('Не найден параметр "content" в JContent', MB_ICONERROR);// error message
    Exit;
  end;
  StrValue := JContent.GetValue('content').Value;
  if Jcontent.FindValue('content_hash') = Nil then
  begin
    MsgBox('Не найден параметр "content_hash" в JContent', MB_ICONERROR);// error message
    Exit;
  end;
  Hash := JContent.GetValue('content_hash').Value;
  if Hash <> GetSHA1Hash(StrValue) then
  begin
    // error message
    MsgBox('Проверка content_hash вернула, ' +
                'что он не равен хешу контента', MB_ICONERROR);
    // Exit;
  end;

  SynEdit.Lines.Text := StrValue;
  SynEdit.Modified   := false;

  if JSONFile.FindValue('date_create') <> Nil then
  begin
    StrValue     := JSONFile.GetValue('date_create').Value;
    FDate_create := StrToDateTime(StrValue);
    //StatusBar.Panels[0].Text := 'Файл сoздан: ' + StrValue;
  end
  else
    MsgBox('В файле не найден параметр "date_create"', MB_ICONERROR);

  if JSONFile.FindValue('date_change') <> Nil then
  begin
    StrValue     := JSONFile.GetValue('date_change').Value;
    FDate_change := StrToDateTime(StrValue);
    //StatusBar.Panels[1].Text := 'Файл изменен: ' + StrValue;
  end
  else
    MsgBox('В файле не найден параметр "date_change"', MB_ICONERROR);
  FIsEncrypt := true;
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
  //FPASSWORD := '';

  FSessionKey := GetTrashStr(20);
  FIsEncrypt  := false;
  UpDateStatusBar;
  TStyleManager.SetStyle('Amethyst Kamri'); // 'Sapphire Kamri'

end;

function TFrmMain.GetMasterPaswword: AnsiString;
begin
  Result := DecryptRC4_SHA1(FSessionKey, FMasterPassword);
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
  FMasterPassword := EncryptRC4_SHA1(FSessionKey, APassStr);
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
    if FileExists(FileName) then
    begin
      if FindFirst(FileName, faAnyFile, SR) = 0 then
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
    StatusBar.Panels[2].Text := 'Шифрованный: Да'
  else
    StatusBar.Panels[2].Text := 'Шифрованный: Нет'
end;

procedure TFrmMain.MsgBox(MsgStr: String; uType: Cardinal);
var
  s: String;
begin
  case uType of
    MB_ICONERROR:       s := 'Ошибка: ';
    MB_ICONWARNING:     s := 'Предупреждение: ';
    MB_ICONINFORMATION: s := 'Информация: ';
  end;
  MessageBox(Handle, PChar(s + MsgStr), PChar(CAPTION_MB), uType);
end;

end.
