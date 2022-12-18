program CryptoNoteLite;

uses
  Vcl.Forms,
  UFrmMain in 'UFrmMain.pas' {FrmMain},
  UFrmSelectEncrypt in 'UFrmSelectEncrypt.pas',
  UFrmMasterPwd in 'UFrmMasterPwd.pas',
  Vcl.Themes,
  Vcl.Styles,
  UFrmSettings in 'UFrmSettings.pas' {FrmSettings},
  UFrmGitUpdate in 'UFrmGitUpdate.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Sapphire Kamri');
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmSelectEncrypt, FrmSelectEncrypt);
  Application.CreateForm(TFrmMasterPwd, FrmMasterPwd);
  Application.CreateForm(TFrmSettings, FrmSettings);
  Application.CreateForm(TFrmGitUpdate, FrmGitUpdate);
  Application.Run;
end.
