unit UFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls,
  Vcl.ActnMenus, System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls,
  SynEdit, SynEditHighlighter, SynEditCodeFolding, SynHighlighterPas,
  SynHighlighterGeneral, Vcl.StdCtrls, SynHighlighterJSON, System.JSON, REST.JSON,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Menus, System.ImageList, Vcl.ImgList,
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
    procedure ActExitExecute(Sender: TObject);
    procedure ActOpenFileExecute(Sender: TObject);
    procedure ActEncryptAndSaveFileExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MM_WordWrapClick(Sender: TObject);
  private
    FOpenFileName: string;
    FDate_create: TDateTime;
    FDate_change: TDateTime;
    FPASS_MASTER: AnsiString;
    FPASSWORD: AnsiString;
    procedure DecryptOpenFile;
  public
    JSONFile: TJSONObject;
    property OpenFileName: string read FOpenFileName;
    property DateCreate: TDateTime read FDate_create;
    property DateChange: TDateTime read FDate_change;
    procedure EMsgBox(Msg: String);
  end;

var
  FrmMain: TFrmMain;

Const
  CAPTION_MB = 'Crypto View';

implementation

{$R *.dfm}

procedure TFrmMain.ActOpenFileExecute(Sender: TObject);
var
  ext: string;
begin
  if Not OpenDialog.Execute then Exit;
  FOpenFileName := OpenDialog.FileName;
  ext := ExtractFileExt(AnsiLowerCase(OpenDialog.fileName));
  if (ext = '.cryjson') or (ext = '.ctxt') or (ext = '.json') then
  begin
    DecryptOpenFile;
    Exit;
  end;
  SynEdit.Lines.LoadFromFile(OpenDialog.FileName);
end;

procedure TFrmMain.ActExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.ActEncryptAndSaveFileExecute(Sender: TObject);
var
  JItem, Jitem2: TJSONObject;
  dt_create, dt_change: TDateTime;
  CheckSumm: String;
begin
  SynEdit.Highlighter := SynJSONSyn;

  dt_create := Date + Time;
  dt_change := dt_create;

  JItem := TJSONObject.Create;
  With JItem do
  begin
    //AddPair('file_name', 'www.wex.nz');
    //AddPair('allias', 'wex.nz');
    AddPair('description', 'Крипто биржа');
    //AddPair('name_encrypted', TJSONBool.Create(false));
    //AddPair('content_encryption', TJSONBool.Create(false));
    AddPair('algo_type', Nil);
    AddPair('date_creatе', DateTimeToStr(dt_create));
    AddPair('date_change', DateTimeToStr(dt_change));
    AddPair('content_hash', CheckSumm);
    AddPair('content', SynEdit.Lines.Text);
  end;

  SynEdit.Lines.Text := TJson.Format(JItem);
  //SynEdit.Lines.Text := JItem.ToString;
end;

procedure TFrmMain.DecryptOpenFile;
var
  ALGO: TAlgoType;
  AStrCrypt, AContent: AnsiString;
  StrValue: string;
  JContent: TJSONObject;
  Hash: String;
begin
  JSONFile := TJSONObject.ParseJSONValue(TFile.ReadAllBytes(OpenFileName), 0) as TJSONObject;
  if JSONFile = Nil then
  begin
    EMsgBox('Ошибка: JSONFile = Nil'); // error message
    Exit;
  end;

  if JSONFile.FindValue('content') = Nil then
  begin
    EMsgBox('Ошибка: В файле не найден параметр "content"'); //error message
    Exit;
  end;

  AStrCrypt := JSONFile.GetValue('content').Value;

  if JSONFile.FindValue('algo_type') = Nil then
  begin
    EMsgBox('Ошибка: В файле не найден параметр: "algo_type"'); //error message
    Exit;
  end;

  StrValue := JSONFile.GetValue('algo_type').Value;
  ALGO := TAlgoType(AnsiIndexStr(StrValue, AlgoName));
  case ALGO of
    RC4_SHA1:   AContent := DecryptRC4_SHA1(FPASSWORD, AStrCrypt);
    RC4_SHA256: AContent := DecryptRC4_SHA1(FPASSWORD, AStrCrypt);
    RC4_SHA512: AContent := DecryptRC4_SHA1(FPASSWORD, AStrCrypt);
  end;

  if Length(AContent) = 0 then
  begin
    EMsgBox('Ошибка: AContent имеет 0 символов'); // error message
    Exit;
  end;
  JContent := TJSONObject.ParseJSONValue(AContent) as TJSONObject;
  if JContent = nil then
  begin
    EMsgBox('Ошибка: Parse JContent = nil '); // error message
    Exit;
  end;
  if JContent.FindValue('content') = Nil then
  begin
    EMsgBox('Ошибка: Не найден параметр "content" в JContent');// error message
    Exit;
  end;
  StrValue := JContent.GetValue('content').Value;
  if Jcontent.FindValue('content_hash') = Nil then
  begin
    EMsgBox('Ошибка: Не найден параметр "content_hash" в JContent');// error message
    Exit;
  end;
  Hash := JContent.GetValue('content_hash').Value;
  if Hash <> GetSHA1Hash(StrValue) then
  begin
    // error message
    ShowMessage('Ошибка: Проверка content_hash вернула, ' +
                'что он не равен хешу контента');
    // Exit;
  end;

  SynEdit.Lines.Text := StrValue;
  SynEdit.Modified   := false;

  if JSONFile.FindValue('date_create') <> Nil then
  begin
    StrValue     := JSONFile.GetValue('date_create').Value;
    FDate_create := StrToDateTime(StrValue);
    StatusBar.Panels[0].Text := 'Файл сoздан: ' + StrValue;
  end
  else
    EMsgBox('Ошибка: В файле не найден параметр "date_create"');

  if JSONFile.FindValue('date_change') <> Nil then
  begin
    StrValue     := JSONFile.GetValue('date_change').Value;
    FDate_change := StrToDateTime(StrValue);
    StatusBar.Panels[1].Text := 'Файл изменен: ' + StrValue;
  end
  else
    EMsgBox('Ошибка: В файле не найден параметр "date_change"');

end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  FPASSWORD := 'crypt0_l0g1c';
end;

procedure TFrmMain.MM_WordWrapClick(Sender: TObject);
begin
  if MM_WordWrap.Checked then
    SynEdit.WordWrap := true
  else
    SynEdit.WordWrap := false;
end;

procedure TFrmMain.EMsgBox(Msg: String);
begin
  MessageBox(Handle, PChar(Msg), PChar(CAPTION_MB), MB_ICONERROR);
end;

end.
