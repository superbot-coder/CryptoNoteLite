object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'CRYPTO NOTE Lite'
  ClientHeight = 785
  ClientWidth = 872
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PnlMain: TPanel
    Left = 0
    Top = 57
    Width = 872
    Height = 728
    Align = alClient
    BevelOuter = bvNone
    Caption = 'PnlMain'
    TabOrder = 0
    object SynEdit: TSynEdit
      Left = 0
      Top = 0
      Width = 872
      Height = 709
      Align = alClient
      Ctl3D = True
      ParentCtl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = []
      Font.Quality = fqClearTypeNatural
      TabOrder = 0
      CodeFolding.CollapsedLineColor = clGray
      CodeFolding.FolderBarLinesColor = clInactiveBorder
      UseCodeFolding = False
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -11
      Gutter.Font.Name = 'Consolas'
      Gutter.Font.Style = []
      Highlighter = SynGeneralSyn
      OnChange = SynEditChange
    end
    object StatusBar: TStatusBar
      Left = 0
      Top = 709
      Width = 872
      Height = 19
      Panels = <
        item
          Text = #1060#1072#1081#1083' '#1089#1086#1079#1076#1072#1085':'
          Width = 230
        end
        item
          Text = #1060#1072#1081#1083' '#1080#1084#1077#1085':'
          Width = 230
        end
        item
          Text = #1064#1080#1092#1088#1086#1074#1072#1085#1085#1099#1081': '
          Width = 150
        end
        item
          Text = 'ALGO:'
          Width = 100
        end>
    end
  end
  object PnlBar: TPanel
    Left = 0
    Top = 0
    Width = 872
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object LblFile: TLabel
      Left = 15
      Top = 7
      Width = 30
      Height = 13
      Caption = #1060#1072#1081#1083':'
    end
    object LblFileName: TLabel
      Left = 51
      Top = 7
      Width = 78
      Height = 13
      Caption = '<'#1053#1086#1074#1099#1081' '#1092#1072#1081#1083'>'
    end
    object BtnEnCrypt: TButton
      Left = 15
      Top = 26
      Width = 178
      Height = 25
      Action = ActEncryptAndSaveFile
      TabOrder = 0
    end
    object BtnSave: TButton
      Left = 199
      Top = 26
      Width = 178
      Height = 25
      Action = ActSaveEdit
      TabOrder = 1
    end
    object BtnSaveAsDecrypt: TButton
      Left = 383
      Top = 26
      Width = 178
      Height = 25
      Action = ActKeepDecrypt
      TabOrder = 2
    end
  end
  object ActionManager: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = ActOpenFile
              end
              item
                Action = ActEncryptAndSaveFile
              end
              item
                Action = ActExit
              end>
            Caption = '&File'
          end>
      end>
    Left = 408
    Top = 296
    StyleName = 'Platform Default'
    object ActOpenFile: TAction
      Category = 'File'
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083
      OnExecute = ActOpenFileExecute
    end
    object ActAddNew: TAction
      Category = 'File'
      Caption = #1053#1086#1074#1072#1103' '#1079#1072#1087#1080#1089#1100
      OnExecute = ActAddNewExecute
    end
    object ActEncryptAndSaveFile: TAction
      Category = 'File'
      Caption = #1047#1072#1096#1080#1092#1088#1086#1074#1072#1090#1100' '#1080' '#1089#1086#1093#1088#1072#1085#1080#1090#1100
      OnExecute = ActEncryptAndSaveFileExecute
    end
    object ActKeepDecrypt: TAction
      Category = 'File'
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1073#1077#1079' '#1096#1080#1092#1088#1086#1074#1072#1085#1080#1103
      OnExecute = ActKeepDecryptExecute
    end
    object ActSaveEdit: TAction
      Category = 'File'
      Caption = #1057#1088#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
      OnExecute = ActSaveEditExecute
    end
    object ActExit: TAction
      Category = 'File'
      Caption = #1042#1099#1093#1086#1076
      OnExecute = ActExitExecute
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 
      #1047#1072#1096#1080#1092#1088#1086#1074#1072#1085#1099#1077' '#1092#1072#1081#1083#1099' (*.cryjson)|*.cryjson|'#1047#1072#1096#1080#1092#1088#1086#1074#1072#1085#1099#1081' '#1092#1072#1081#1083' *.cry' +
      'txt|*.crytxt|'#1058#1077#1082#1090#1086#1074#1099#1081' '#1092#1072#1081#1083' (*.txt)|*.txt'
    Left = 488
    Top = 296
  end
  object SynGeneralSyn: TSynGeneralSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    DetectPreprocessor = False
    Left = 320
    Top = 240
  end
  object SynJSONSyn: TSynJSONSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    Left = 400
    Top = 240
  end
  object PMenu: TPopupMenu
    Left = 523
    Top = 241
  end
  object MainMenu: TMainMenu
    Left = 335
    Top = 297
    object A1: TMenuItem
      Caption = #1060#1072#1081#1083
      object Openfilejson1: TMenuItem
        Action = ActOpenFile
      end
      object N9: TMenuItem
        Action = ActAddNew
      end
      object N3: TMenuItem
        Action = ActEncryptAndSaveFile
      end
      object N4: TMenuItem
        Action = ActKeepDecrypt
      end
      object N6: TMenuItem
        Action = ActSaveEdit
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object N5: TMenuItem
        Action = ActExit
      end
    end
    object N2: TMenuItem
      Caption = #1042#1080#1076
      object MM_WordWrap: TMenuItem
        AutoCheck = True
        Caption = #1055#1077#1088#1077#1085#1086#1089' '#1089#1090#1088#1086#1082
        OnClick = MM_WordWrapClick
      end
    end
    object N7: TMenuItem
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
      object MM_SetMasterPass: TMenuItem
        Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1084#1072#1089#1090#1077#1088' '#1087#1072#1088#1086#1083#1100
      end
      object MM_Settings: TMenuItem
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      end
    end
    object N8: TMenuItem
      Caption = #1055#1086#1084#1086#1097#1100
    end
  end
  object ImageList: TImageList
    ColorDepth = cd32Bit
    DrawingStyle = dsTransparent
    Left = 467
    Top = 240
    Bitmap = {
      494C010104000800040010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001A1A1A1B585E
      5F6372969FB14FACC4F36897A3C85A6061682020202100000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B7A293FF6147
      33FF614733FF614733FF614733FF614733FF614733FF614733FF614733FF6147
      33FF614733FF614733FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007FA5AEBC5DC3D9FF5BC0
      D6FF5CBFD6FF5EBFD6FF42AFCAFF49A6C1FF54B8D4FF5CC0D7FF5BBFD7FF5ABE
      D6FF72B1C0DB636B6D7200000000000000000000000000000000F4DBCEFFDCBE
      AEFFDBBBAAFFD8B7A5FFD7B3A1FFD6B09CFFD4AB97FFD2A893FFD0A48FFFCFA0
      8BFFCD9E87FF0000000000000000000000000000000000000000B7A293FFF7E5
      DCFFB7A293FF0099CCFF0099CCFF0099CCFF0099CCFF0099CCFF0099CCFF0099
      CCFF006499FF614733FF00000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000063636378E7E7
      E6FF00000000000000000000000000000000000000006ACEE1FF80D4E4FF75CE
      E0FF6DC9DDFF65C4DAFF42AFCAFF41A6C3FF4CB8D7FF4CC1DEFF4CC1DEFF4CC1
      DEFF4EC1DDFF73B1C0DB00000000000000000000000000000000F5DFD3FFF9EE
      E8FFF9E9E2FFF8E5DCFFF5E1D6FFF5DDD1FFF3D8CBFFF2D3C5FFF0CFBEFFEFCA
      B9FFCFA18BFF0000000000000000000000000000000000000000B7A293FFF9E9
      E2FFF8E6DDFF0099CCFF46DBFFFF46DBFFFF00CCFFFF000000FF00CCFFFF00CC
      FFFF006499FF614733FF00000000000000000000000000000000000000000000
      0000000000000000000032313134D8D9D9FFF2F1EEFFDBD4BFFFDDD7C2FFE1DF
      D7FF989584FF6060607E0000000000000000000000006ED1E4FF89DBE8FF80D4
      E4FF75CEE0FF6DC9DDFF42AFCAFF43A8C4FF4CB8D7FF4CC1DEFF4CC1DEFF4CC1
      DEFFD3A547FF5BBFD7FF00000000000000000000000000000000F6E2D8FFFCF3
      EEFFFAEDE8FFF8E9E1FFF7E4DCFFF6E1D6FFF5DCD0FFF3D8CAFFF1D3C4FFF0CE
      BFFFD0A48FFF0000000000000000000000000000000000000000B7A293FFF9EE
      E8FFF8EAE3FF0099CCFF46DBFFFF00CCFFFF00CCFFFF000000FF00CCFFFF00CC
      FFFF006499FF614733FF00000000000000000000000000000000000000002525
      2526F9F7F2FFD0C6A0FFC7B66CFFCFBB63FFC2AD58FFDAD1B9FFE0DCCBFFE0DC
      CAFF9C9A8AFF4E646DFF21516AFF0909090A0000000073D4E7FF92E1ECFF89DB
      E8FF80D4E4FF75CEE0FF43B0CAFF47A9C4FF50BAD8FF50C3DFFF4CC1DEFF4CC1
      DEFFDDB95BFF5CC0D8FF00000000000000000000000000000000F8E6DEFFFCF7
      F3FFD4672FFFCC612DFFC05B2BFFB25528FFA44F25FF984822FF8E4220FFF2D2
      C3FFD2A994FF0000000000000000000000000000000000000000B7A293FFFBF2
      EDFFD86830FF0099CCFF46DBFFFF00CCFFFF00CCFFFF000000FF00CCFFFF00CC
      FFFF006499FF614733FF000000000000000000000000AAA589C3C3B677E2A79D
      6EBEC5B264FFBEAE63FFB8A653FFB5A34FFFB8A85FFFB9A967FFE9E6D9FFE4E0
      CFFFC3C2BBFF798380FF225671FA000000000000000077D8E9FF9BE7F0FF92E1
      ECFF89DBE8FF80D4E4FF45B2CCFF4CACC6FF54BCD9FF59C7E1FF54C5E0FF50C3
      DFFFECECECFF5EC1D9FF00000000000000000000000000000000F9EAE3FFFEFA
      F8FFFCF6F3FFFCF1EDFFFAEDE7FFF8E9E1FFF6E4DBFFF5E0D6FFF4DCD0FFF3D7
      C9FFD4AC99FF0000000000000000000000000000000000000000B7A293FFFCF6
      F3FFFBF2EEFF0099CCFF00CCFFFF46DBFFFF46DBFFFF46DBFFFF46DBFFFF00CC
      FFFF006499FF614733FF00000000000000005B5A565F928B69A98A8467A08680
      659BBDAE6AFFBFAE65FFBFAF60FFC0B062FFC0B06CFFC0AF6EFFECE8DDFFEAE6
      D8FFE8E7E2FFA9A596FF1F526BF600000000000000007BDBECFFA3ECF4FF9BE7
      F0FF92E1ECFF89DBE8FF48B4CEFF52AFC8FF5ABFDAFF64CDE4FF5ECAE3FF59C7
      E1FFECECECFF60C2DAFF00000000000000000000000000000000FAEEE8FFFEFD
      FDFFFDF9F8FFFDF6F2FFFBF2EDFFFAEDE7FFF8E8E0FFF7E3DBFFF6DFD6FFF4DB
      CFFFD6B19EFF0000000000000000000000000000000000000000BAA596FFFDF9
      F6FFD86830FFD0642EFFC0C0C0FF808080FFA85026FF9A4922FFC0C0C0FF8080
      80FFB7A293FF614733FF0000000000000000000000008B8567A0847F6A938480
      6B93A29B75C0CBBC78FFCBBD76FFC9BA76FFC5B678FFC7B975FFBEAF61FFEEEB
      E0FFE8E5D8FFB9B19DFF20516AF4000000000000000081DEEEFFAAF1F7FFA3EC
      F4FF9BE7F0FF92E1ECFF4CB7D0FF59B2C9FF61C2DCFF71D3E8FF6BD0E6FF64CD
      E4FFECECECFF61C3DBFF00000000000000000000000000000000FBF2EEFFFFFF
      FFFFD4672FFFCC622DFFC05C2BFFB35527FFA54F24FF984822FF8D4320FFF6E0
      D4FFD7B5A3FF0000000000000000000000000000000000000000BEA99AFFFEFC
      FBFFFDF9F8FFFDF7F4FFC0C0C0FF808080FFFAEEE8FFF8EAE4FFC0C0C0FF8080
      80FFB7A293FF614733FF0000000000000000000000000C0C0C0D898673968D88
      769986827391D7CA90FFD4C78CFFCEC086FFCCBD82FFCDBF7CFFCFBE77FFF0ED
      E5FFE4DFCDFFB4AC99FF0F4562FC000000000000000084E0F0FFB0F5F9FFAAF1
      F7FFA3ECF4FFC6F1F6FF50BAD2FF5FB6CBFF67C6DEFF82DAECFF78D7EAFF71D3
      E8FF6BD0E6FF63C5DCFF00000000000000000000000000000000FCF6F3FFFFFF
      FFFFFFFFFFFFFEFCFCFFFDF9F7FFFCF5F2FFFBF1ECFFF9ECE6FFF8E8E0FFF6E3
      DAFFDAB9A7FF0000000000000000000000000000000000000000C3AE9EFFFEFE
      FEFFD86830FFD0642EFFC0C0C0FF808080FF808080FF808080FF808080FF8080
      80FFB7A293FF614733FF00000000000000000000000000000000ACA68DBE9B97
      85A9979483A3DED3A4FFD8CC9BFFD3C795FFD6C995FFD1C584FFCFC17BFFB9A7
      5DFFDBD2B7FFA9A291FF1C4D68F5000000000000000088E3F2FFB4F7FBFFB0F5
      F9FFAAF1F7FFE8FAFCFF54BDD4FF66B9CDFF6EC9E0FF90E2F0FF89DEEEFF82DA
      ECFF6DCCE2FF768A8E9600000000000000000000000000000000FEF9F8FFFFFF
      FFFFFFFFFFFFFFFFFFFFFEFDFCFFFDF9F7FFFCF5F2FFFAF1ECFFF9EDE6FFF8E8
      E0FFDBBCACFF0000000000000000000000000000000000000000C8B2A3FFFFFF
      FFFFFFFFFFFFFFFDFCFFFDFBF9FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFF9EC
      E6FFB7A293FF614733FF0000000000000000000000000000000000000000AFAB
      98BCAEAA98BAE3D9B4FFDED5B0FFDED4ACFFD9CE9BFFD9CB93FFD7CB91FFD2C4
      88FFD9D0B6FFACA494FF325C71E600000000000000008AE5F3FFB4F7FBFFB4F7
      FBFFB0F5F9FFF4FDFEFF58C0D7FF6CBCCEFF74CCE1FF9EE9F3FF97E5F2FF90E2
      F0FF69C9DFFF0000000000000000000000000000000000000000FEFCFCFFFFFF
      FFFFD5662FFFCC612DFFC05C2BFFB25528FFA54F24FF984922FF8D421FFFFAEB
      E6FFDDC1B1FF0000000000000000000000000000000000000000CCB6A7FFFFFF
      FFFFD86830FFD0642EFFC45E2BFFB75728FFA85026FFFCF6F3FFFBF4EFFFB7A2
      93FFB7A293FF624834FF0000000000000000000000000000000000000000B1AE
      9CC0C1BEAFCDEBE5CBFFE2D9B8FFE0D7B0FFE8E2BFFFE3DAB0FFDBCF9DFFD2C4
      8CFFBFB07BFFB9B5A7FF536E7CC500000000000000008DE6F5FFB4F7FBFFB4F7
      FBFFB4F7FBFFFCFFFFFF5DC4DAFF72BED0FF7BCFE3FFACEFF7FFA5ECF5FF9EE9
      F3FF6CCAE1FF0000000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFCFBFFFDF9F7FFFCF4F1FFFBF0
      EBFFDFC4B6FF0000000000000000000000000000000000000000D1BBABFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFDFFFEFBFBFFFDF9F8FFB7A293FF6248
      34FF624834FF624834FF00000000000000000000000000000000000000000000
      0000EAE9E0EFE8E0C7FFEAE4C9FFF0EBD8FFEEE9CFFFE9E1BEFFDDD2A7FFD1C3
      8FFFCFC082FFD0CEC9FF5E717CB400000000000000008DE7F5FFB4F7FBFFB4F7
      FBFFB4F7FBFFFFFFFFFF62C8DDFF76C0D1FF81D2E5FFB7F4FAFFB1F2F9FFACEF
      F7FF6ECCE2FF0000000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFFFEFBFBFFFDF8F6FFBDA5
      97FFA48A76FF0000000000000000000000000000000000000000D5BFAFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFFFEFCFBFFB9A495FFD4C5
      BAFF614733FF8D8782A900000000000000000000000000000000000000000000
      000072706A78F1EDE0FFF5F2E5FFF8F4E7FFF4F0DCFFEFE9CDFFEAE0B6FFE7DA
      A2FFC6B982FFC9BC89FF6370779C00000000000000008DE7F5FFB4F7FBFFB4F7
      FBFFFCFFFFFFFCFFFFFF67CBE0FF7DC6D5FFAEEEF6FFBFF9FCFFBBF7FBFFB7F4
      FAFF70CDE4FF0000000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA08977FFC7B1
      A5FF6A503CFF0000000000000000000000000000000000000000D8C2B2FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFC0AB9CFF6147
      33FF8D8681A80000000000000000000000000000000000000000000000000000
      000000000000FFFFFFFFC7C4B8FFA8A49AFF9B9485FFA09883FFA39C87FFA6A3
      8FFF778277F1747F81C40000000000000000020202038DE7F5FFB1F6FBFFE9FB
      FDFF99EAF4FF87DFEDFF77CDDCFFBCF5FAFFC2FAFDFFC2FAFDFFC2FAFDFFB6F4
      F9FF82BDCCDE0000000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA58E7CFF886E
      5BFF000000000000000000000000000000000000000000000000D8C2B2FFD8C2
      B2FFD8C2B2FFD8C2B2FFD8C2B2FFD8C2B2FFD4BEAEFFCFB9A9FFC9B3A4FF817E
      7B8B000000000000000000000000000000000000000000000000000000000000
      000000000000686A696E778278E794948CEAACADA6D6828682912C2C2C2D0000
      000000000000000000000000000000000000000000008DACB2B68DE4F2FC8DE4
      F4FF89E0F2FF88DEF1FF89DDF1FF86DBEFFF83D9EEFF80D7ECFF7BD5EAFF86C0
      CDDE676F72750000000000000000000000000000000000000000C3AFA1FFC0AC
      9FFFBDA99BFFBBA697FFB7A294FFB39F90FFB09B8DFFAD9888FFA99484FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000C07FFFFFC003FFFF8003C007C003FFCF
      8003C007C003FC038003C007C003E0008003C007C00380018003C007C0030001
      8003C007C00380018003C007C00380018003C007C003C0018003C007C003E001
      8007C007C003E0018007C007C003F0018007C007C003F0018007C007C007F803
      0007C00FC00FF81F8007C01FFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object SaveDialog: TSaveDialog
    InitialDir = 'C:\Users\USER\Desktop'
    Left = 544
    Top = 297
  end
end
