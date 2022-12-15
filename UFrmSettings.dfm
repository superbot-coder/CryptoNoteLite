object FrmSettings: TFrmSettings
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'FrmSettings'
  ClientHeight = 338
  ClientWidth = 495
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object BtnClose: TButton
    Left = 400
    Top = 296
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 0
    OnClick = BtnCloseClick
  end
  object BtnApply: TButton
    Left = 160
    Top = 296
    Width = 169
    Height = 25
    Caption = #1055#1056#1048#1052#1045#1053#1048#1058#1068
    TabOrder = 1
    OnClick = BtnApplyClick
  end
  object ChBoxRegisterExtension: TCheckBox
    Left = 24
    Top = 32
    Width = 273
    Height = 17
    Caption = #1047#1072#1088#1077#1075#1080#1089#1090#1088#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1096#1080#1088#1077#1085#1080#1103'  '#1092#1072#1081#1083#1086#1074' *.cryjson'
    TabOrder = 2
  end
end
