unit UFrmSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Extensions;

type
  TFrmSettings = class(TForm)
    BtnClose: TButton;
    BtnApply: TButton;
    ChBoxRegisterExtension: TCheckBox;
    ChBoxOpenTxtFiles: TCheckBox;
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ShowModalInit;
  end;

var
  FrmSettings: TFrmSettings;

implementation

{$R *.dfm}

procedure TFrmSettings.BtnApplyClick(Sender: TObject);
begin
  //
  Close;
end;

procedure TFrmSettings.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmSettings.ShowModalInit;
begin
  //
end;

end.
