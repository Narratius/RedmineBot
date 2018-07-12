object PasswordForm: TPasswordForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' Redmine'
  ClientHeight = 140
  ClientWidth = 252
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 72
    Height = 13
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
  end
  object Label2: TLabel
    Left = 16
    Top = 48
    Width = 37
    Height = 13
    Caption = #1055#1072#1088#1086#1083#1100
  end
  object EditLogin: TEdit
    Left = 104
    Top = 13
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object EditPass: TEdit
    Left = 104
    Top = 45
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object Button1: TButton
    Left = 40
    Top = 107
    Width = 75
    Height = 25
    Caption = #1054#1050
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 136
    Top = 107
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
end
