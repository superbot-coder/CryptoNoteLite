program CryptoNoteLite;

uses
  Vcl.Forms,
  UFrmMain in 'UFrmMain.pas' {FrmMain},
  UFrmSelectEncrypt in 'UFrmSelectEncrypt.pas',
  UFrmMasterPwd in 'UFrmMasterPwd.pas',
  UFrmEdit in 'UFrmEdit.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Sapphire Kamri');
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmSelectEncrypt, FrmSelectEncrypt);
  Application.CreateForm(TFrmMasterPwd, FrmMasterPwd);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
