object RedmineBotForm: TRedmineBotForm
  Left = 0
  Top = 0
  Caption = 'Redmine Assistant'
  ClientHeight = 610
  ClientWidth = 983
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object wb: TWebBrowser
    Left = 0
    Top = 145
    Width = 722
    Height = 465
    Align = alClient
    TabOrder = 0
    OnDocumentComplete = wbDocumentComplete
    ExplicitLeft = 8
    ExplicitTop = 8
    ExplicitWidth = 300
    ExplicitHeight = 150
    ControlData = {
      4C0000009F4A00000F3000000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E12620A000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 983
    Height = 145
    Align = alTop
    TabOrder = 1
    object btnAuth: TButton
      Left = 20
      Top = 10
      Width = 109
      Height = 25
      Caption = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100#1089#1103
      TabOrder = 0
      OnClick = btnAuthClick
    end
    object GroupBox1: TGroupBox
      Left = 416
      Top = 10
      Width = 265
      Height = 64
      Caption = ' '#1054#1073#1085#1086#1074#1080#1090#1100' '#1079#1072#1076#1072#1095#1080' '
      TabOrder = 1
      object btnLoadTasks: TButton
        Left = 3
        Top = 15
        Width = 118
        Height = 25
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1087#1080#1089#1086#1082
        TabOrder = 0
        OnClick = btnLoadTasksClick
      end
      object checkUpdateUseMemo: TCheckBox
        Left = 3
        Top = 44
        Width = 126
        Height = 17
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1084#1077#1084#1086
        TabOrder = 1
        OnClick = checkUpdateUseMemoClick
      end
    end
    object Button1: TButton
      Left = 16
      Top = 56
      Width = 75
      Height = 25
      Caption = #1043#1072#1085#1090
      TabOrder = 2
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 208
      Top = 80
      Width = 75
      Height = 25
      Caption = #1058#1077#1089#1090
      TabOrder = 3
      OnClick = Button2Click
    end
    object GroupBox2: TGroupBox
      Left = 228
      Top = 10
      Width = 182
      Height = 64
      Caption = ' '#1059#1087#1086#1088#1103#1076#1086#1095#1080#1090#1100' '#1079#1072#1076#1072#1095#1080' '
      TabOrder = 4
      object btnGanttLoadList: TButton
        Left = 3
        Top = 15
        Width = 75
        Height = 25
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
        TabOrder = 0
        OnClick = btnGanttLoadListClick
      end
      object btnGanttArrange: TButton
        Left = 84
        Top = 15
        Width = 89
        Height = 25
        Caption = #1059#1087#1086#1088#1103#1076#1086#1095#1080#1090#1100
        Enabled = False
        TabOrder = 1
        OnClick = btnGanttArrangeClick
      end
      object checkGanttUseMemo: TCheckBox
        Left = 3
        Top = 44
        Width = 126
        Height = 17
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1084#1077#1084#1086
        TabOrder = 2
        OnClick = checkGanttUseMemoClick
      end
    end
  end
  object MemoInfo: TMemo
    Left = 722
    Top = 145
    Width = 261
    Height = 465
    Align = alRight
    TabOrder = 2
  end
  object btnUpdateTasks: TButton
    Left = 551
    Top = 25
    Width = 118
    Height = 25
    Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1079#1072#1076#1072#1095#1080
    Enabled = False
    TabOrder = 3
    OnClick = btnUpdateTasksClick
  end
end
