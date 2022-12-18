unit UFrmGitUpdate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, json, Vcl.StdCtrls, System.IOUtils, REST.JSON,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Buttons, REST.Types, REST.Client,
  System.ImageList, Vcl.ImgList, GetVer, FormatFileSizeMod, System.StrUtils,
  Data.Bind.Components, Data.Bind.ObjectScope, ShellApi, SynEdit;

type
  TFrmGitUpdate = class(TForm)
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    ImageList: TImageList;
    SynEdit: TSynEdit;
    LVFiles: TListView;
    BtnDownLoad: TButton;
    BtnClose: TButton;
    BtnCheckUpdate: TButton;
    procedure CheckReleases;
    procedure BtnCheckUpdateClick(Sender: TObject);
    function AddLVFilesItems: integer;
    procedure BtnDownloadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
  private
    FFileList: TStrings;
  public
    procedure ShowModalInit;
  end;

var
  FrmGitUpdate: TFrmGitUpdate;
  CurrentVersion: String;
  // extArray: array[0..2] of string = ('.zip','.7z','.rar');

  //Url_GitHub_Releases: String;

Const
  CAPTION_MB = 'Проверка обновления';
  // URL_GITHUB_RELEASES = 'http://api.github.com/repos/superbot-coder/CryptoNoteLite/releases';

  // URL for test
  URL_GITHUB_RELEASES = 'http://api.github.com/repos/superbot-coder/chia_plotting_tools/releases';
  lv_size  = 0;
  lv_url   = 1;

  msg_timer_check_update = 'Идет проверка обновления';
  msg_timer_download_file = 'Идет загрузка файла';

implementation

USES UFrmMain;

{$R *.dfm}

procedure TFrmGitUpdate.BtnDownloadClick(Sender: TObject);
var
  FileName: string;
  i: SmallInt;
begin

  if LVFiles.Items.Count = 0 then
  begin
    MessageBox(Handle, PChar('Ни один файл не выбран для скачивания.'),
               PChar(CAPTION_MB), MB_ICONWARNING);
    Exit;
  end;

  for i := 0 to LVFiles.Items.Count -1 do
  begin
    RESTClient.BaseURL := LVFiles.Selected.SubItems[lv_url];
    RESTClient.Accept  := 'appl';
    RESTResponse.RootElement := '';
    RESTRequest.Execute;

    if RESTResponse.StatusCode <> 200 then Exit;
     FileName := USERPROFILE + '\Downloads\' + LVFiles.Selected.Caption;

    TFile.WriteAllBytes(FileName, RESTResponse.RawBytes);

  end;

  If FileExists(FileName) then
  begin
    MessageBox(Handle, PChar('Файл "' + LVFiles.Selected.Caption + '" успешно загружен!'),
      PChar(CAPTION_MB), MB_ICONINFORMATION);

    ShellExecute(Handle, PChar('open'), PChar('explorer.exe'), PChar('/select, ' + LVFiles.Selected.Caption),
               PChar(USERPROFILE + '\Downloads'), SW_NORMAL);
  end

end;

function TFrmGitUpdate.AddLVFilesItems: integer;
begin
  with LVFiles.Items.Add do
  begin
    Caption := '';
    ImageIndex := -1;
    SubItems.Add('');
    SubItems.Add('');
    Checked := true;
    Result  := index;
  end;
end;

procedure TFrmGitUpdate.CheckReleases;
var
  LastRelease: TJSONObject;
  tag_name: string;
  StrValue: string;
  FileName: string;
  assetsArray: TJSONArray;
  i, x: Word;
begin

  SynEdit.Clear;
  RESTClient.BaseURL       := URL_GITHUB_RELEASES;
  RESTClient.Accept        := 'application/json';
  RESTResponse.RootElement := '[0]';
  RESTRequest.Execute;

  // Проверка, что нужный ресурс найден
  if RESTResponse.StatusCode <> 200 then
  begin
    SynEdit.Clear;
    SynEdit.Lines.Add('Status: ' + RESTResponse.StatusText);
    Exit;
  end;

  SynEdit.Clear;
  // mmInfo.Lines.Add('Status: ' + RESTResponse.StatusText);

  if RESTResponse.JSONValue = Nil then
  begin
    // SynEdit.Lines.Add('JSONValue = Nil');
    Exit;
  end;

  LastRelease := RESTResponse.JSONValue as TJSONObject;
  if LastRelease.FindValue('tag_name') = Nil then
  begin
    SynEdit.Lines.Add('Не найден параметр: tag_name');
    exit;
  end;

  tag_name := LastRelease.GetValue('tag_name').Value;
  CurrentVersion := GetVertionInfo(Application.ExeName, true);

  CurrentVersion := '3.0.0.0';

  if CurrentVersion = tag_name then
  begin
    SynEdit.Lines.Add('Ваша версия программы: ' + CurrentVersion +
                      ' является самой актуальной');
    Exit;
  end;

  // SynEdit.Lines.Add('Было обнаружена новая версия программы: ' + tag_name);
  if LastRelease.FindValue('body') <> Nil then
  begin
    //SynEdit.Lines.Add('Описание:');
    SynEdit.Lines.Text := LastRelease.GetValue('body').Value;
    SynEdit.Perform(WM_VScroll, SB_TOP, 0);
  end;

  if LastRelease.FindValue('assets') = Nil then
  begin
    SynEdit.Lines.Add('Not found the parametr: "assets"');
    SynEdit.Lines.Add('The End!');
    Exit;
  end;

  assetsArray := LastRelease.GetValue('assets')  as TJSONArray;
  for i:=0 to assetsArray.Count -1 do
  begin
    x := AddLVFilesItems;
    LVFiles.Items[x].Caption := assetsArray.Items[i].FindValue('name').Value;
    StrValue := assetsArray.Items[i].FindValue('size').Value;
    LVFiles.Items[x].SubItems[lv_size]  := FormatFileSize(StrToInt64(StrValue));
    LVFiles.Items[x].ImageIndex := 0;
    StrValue := assetsArray.Items[i].FindValue('browser_download_url').Value;
    FFileList.Add(StrValue);
  end;

end;

procedure TFrmGitUpdate.FormCreate(Sender: TObject);
begin
  FFileList := TStringList.Create;

end;

procedure TFrmGitUpdate.FormDestroy(Sender: TObject);
begin
  FFileList.Free;
end;

procedure TFrmGitUpdate.ShowModalInit;
begin
  SynEdit.Clear;
  LVFiles.Clear;
  FFileList.Clear;
  BtnDownLoad.Enabled := false;
  CheckReleases;
  ShowModal;
end;

procedure TFrmGitUpdate.BtnCheckUpdateClick(Sender: TObject);
begin
  CheckReleases;
end;

procedure TFrmGitUpdate.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
