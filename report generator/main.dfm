object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'FormMain'
  ClientHeight = 623
  ClientWidth = 1045
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1045
    Height = 623
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object tsInData: TTabSheet
      Caption = 'tsInData'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object MemoInData: TMemo
        Left = 0
        Top = 0
        Width = 1037
        Height = 595
        Align = alClient
        TabOrder = 0
        WordWrap = False
      end
      object Button1: TButton
        Left = 516
        Top = 356
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 1
        OnClick = Button1Click
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Splitter1: TSplitter
        Left = 0
        Top = 247
        Width = 1037
        Height = 3
        Cursor = crVSplit
        Align = alTop
        ExplicitTop = 266
        ExplicitWidth = 329
      end
      object DBGrid1: TDBGrid
        Left = 0
        Top = 35
        Width = 1037
        Height = 212
        Align = alTop
        DataSource = DataSource
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 1037
        Height = 35
        Align = alTop
        Caption = 'Panel1'
        TabOrder = 1
        object btnSave: TButton
          Left = 4
          Top = 0
          Width = 75
          Height = 25
          Caption = 'btnSave'
          TabOrder = 0
          OnClick = btnSaveClick
        end
        object btnLoad: TButton
          Left = 85
          Top = 0
          Width = 75
          Height = 25
          Caption = 'btnLoad'
          TabOrder = 1
          OnClick = btnLoadClick
        end
        object cbFilterOk: TCheckBox
          Left = 252
          Top = 4
          Width = 97
          Height = 17
          Caption = 'cbFilter calc=hours'
          TabOrder = 2
          OnClick = cbFilterOkClick
        end
      end
      object PageControl2: TPageControl
        Left = 0
        Top = 250
        Width = 1037
        Height = 345
        ActivePage = tsFormatedRep
        Align = alClient
        TabOrder = 2
        object tsOrigRep: TTabSheet
          Caption = 'tsOrigRep'
          object DBMemoReport: TDBMemo
            Left = 0
            Top = 0
            Width = 1029
            Height = 317
            Align = alClient
            DataField = 'DraftReport'
            DataSource = DataSource
            ReadOnly = True
            TabOrder = 0
          end
        end
        object tsFormatedRep: TTabSheet
          Caption = 'tsFormatedRep'
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Splitter2: TSplitter
            Left = 0
            Top = 198
            Width = 1029
            Height = 3
            Cursor = crVSplit
            Align = alTop
            ExplicitTop = 133
            ExplicitWidth = 178
          end
          object DBMemoFormatedReport: TDBMemo
            Left = 0
            Top = 21
            Width = 1029
            Height = 133
            Align = alTop
            DataField = 'FormatedReport'
            DataSource = DataSource
            TabOrder = 0
            OnChange = DBMemoFormatedReportChange
            OnKeyDown = DBMemoFormatedReportKeyDown
          end
          object DBGrid2: TDBGrid
            Left = 0
            Top = 201
            Width = 1029
            Height = 116
            Align = alClient
            DataSource = DataSourceDay
            TabOrder = 1
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            Columns = <
              item
                Expanded = False
                FieldName = 'Task'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'Text'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'Hours'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'ClearTask'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'ActivityID'
                PickList.Strings = (
                  #1054#1073#1089#1091#1078#1076#1077#1085#1080#1077
                  #1050#1086#1084#1084#1077#1088#1094#1080#1103
                  #1054#1073#1089#1083#1077#1076#1086#1074#1072#1085#1080#1077
                  #1056#1072#1079#1088#1072#1073#1086#1090#1082#1072
                  #1055#1088#1086#1074#1077#1088#1082#1072' '#1057#1055
                  #1042#1082#1083#1102#1095#1077#1085#1080#1077' '#1074' '#1101#1090#1072#1083
                  #1042#1085#1077#1076#1088#1077#1085#1080#1077
                  #1042#1099#1077#1079#1076' '#1082' '#1082#1083#1080#1077#1085#1090#1091
                  #1058#1077#1093'-'#1087#1086#1076#1076#1077#1088#1078#1082#1072
                  #1044#1088#1091#1075#1086#1077)
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'Activity'
                Visible = True
              end>
          end
          object Panel2: TPanel
            Left = 0
            Top = 154
            Width = 1029
            Height = 44
            Align = alTop
            Caption = 'Panel2'
            TabOrder = 2
            object btnConvertToDs: TButton
              Left = 44
              Top = 6
              Width = 112
              Height = 25
              Caption = 'btnConvert vvv'
              TabOrder = 0
              OnClick = btnConvertToDsClick
            end
            object btnConvertBack: TButton
              Left = 172
              Top = 6
              Width = 101
              Height = 25
              Caption = 'btnConver ^^^'
              TabOrder = 1
              OnClick = btnConvertBackClick
            end
            object edCalcHours: TDBEdit
              Left = 308
              Top = 8
              Width = 121
              Height = 21
              DataField = 'CalcHours'
              DataSource = DataSource
              TabOrder = 2
            end
          end
          object MemoDebug: TMemo
            Left = 744
            Top = 56
            Width = 185
            Height = 89
            Lines.Strings = (
              'MemoDebug')
            TabOrder = 3
          end
          object Panel3: TPanel
            Left = 0
            Top = 0
            Width = 1029
            Height = 21
            Align = alTop
            Caption = 'Panel3'
            TabOrder = 4
            object LabelHours: TLabel
              Left = 16
              Top = 4
              Width = 53
              Height = 13
              Caption = 'LabelHours'
            end
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 2
      object MemoOut: TMemo
        Left = 0
        Top = 0
        Width = 1037
        Height = 595
        Align = alClient
        Lines.Strings = (
          'MemoOut')
        TabOrder = 0
        WordWrap = False
      end
      object btnTextOut: TButton
        Left = 312
        Top = 188
        Width = 75
        Height = 25
        Caption = 'btnTextOut'
        TabOrder = 1
        OnClick = btnTextOutClick
      end
    end
  end
  object dsActivity: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'ID'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'Text'
        Attributes = [faUnNamed]
        DataType = ftString
        Size = 20
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 20
    Top = 544
    Data = {
      F30000009619E0BD010000001800000002000A000000030000003E0002494404
      0001001000000004546578740100490010000100055749445448020002001400
      00000000180000000ACEE1F1F3E6E4E5EDE8E500001700000009CAEEECECE5F0
      F6E8FF0000080000000CCEE1F1EBE5E4EEE2E0EDE8E50000090000000AD0E0E7
      F0E0E1EEF2EAE000000C0000000BCFF0EEE2E5F0EAE020D1CF00001000000010
      C2EAEBFEF7E5EDE8E520E220FDF2E0EB00001600000009C2EDE5E4F0E5EDE8E5
      00000B0000000FC2FBE5E7E420EA20EAEBE8E5EDF2F30000130000000DD2E5F5
      2DEFEEE4E4E5F0E6EAE000001100000006C4F0F3E3EEE5}
    object dsActivityID: TIntegerField
      FieldName = 'ID'
    end
    object dsActivityText: TStringField
      FieldName = 'Text'
    end
  end
  object dsRep: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Date'
        DataType = ftDate
      end
      item
        Name = 'Day'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'Hours'
        DataType = ftFloat
      end
      item
        Name = 'HoursAcc'
        DataType = ftFloat
      end
      item
        Name = 'Time'
        DataType = ftTime
      end
      item
        Name = 'Begin'
        DataType = ftTime
      end
      item
        Name = 'End'
        DataType = ftTime
      end
      item
        Name = 'Dinner'
        DataType = ftTime
      end
      item
        Name = 'DraftReport'
        DataType = ftMemo
      end
      item
        Name = 'FormatedReport'
        DataType = ftMemo
      end
      item
        Name = 'CalcHours'
        DataType = ftFloat
      end
      item
        Name = 'DayRep'
        DataType = ftDataSet
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 20
    Top = 68
    Data = {
      610100009619E0BD020000001800000011000000000003000000610104446174
      6504000600000000000344617901004900000001000557494454480200020002
      0005486F757273080004000000000008486F7572734163630800040000000000
      0454696D65040007000000000005426567696E040007000000000003456E6404
      000700000000000644696E6E657204000700000000000B44726166745265706F
      727404004B0000000100075355425459504502004900050054657874000E466F
      726D617465645265706F727404004B0000000100075355425459504502004900
      050054657874000943616C63486F757273080004000000000006446179526570
      05000E0500000000045461736B04000100000000000454657874010049000000
      010005574944544802000200640005486F757273080004000000000009436C65
      61725461736B02000300000000000A4163746976697479494404000100000000
      0000000000}
    object dsRepDate: TDateField
      FieldName = 'Date'
    end
    object dsRepDay: TStringField
      FieldName = 'Day'
      Size = 2
    end
    object dsRepHours: TFloatField
      FieldName = 'Hours'
    end
    object dsRepHoursAcc: TFloatField
      FieldName = 'HoursAcc'
    end
    object dsRepTime: TTimeField
      FieldName = 'Time'
    end
    object dsRepBegin: TTimeField
      FieldName = 'Begin'
    end
    object dsRepEnd: TTimeField
      FieldName = 'End'
    end
    object dsRepDinner: TTimeField
      FieldName = 'Dinner'
    end
    object dsRepDraftReport: TMemoField
      FieldName = 'DraftReport'
      BlobType = ftMemo
    end
    object dsRepFormatedReport: TMemoField
      FieldName = 'FormatedReport'
      BlobType = ftMemo
    end
    object dsRepCalcHours: TFloatField
      FieldName = 'CalcHours'
    end
    object dsRepDayRep: TDataSetField
      FieldName = 'DayRep'
    end
  end
  object DataSource: TDataSource
    DataSet = dsRep
    OnDataChange = DataSourceDataChange
    Left = 56
    Top = 68
  end
  object OpenDialog: TOpenDialog
    Filter = 'rmrep|*.rmrep'
    Left = 172
    Top = 24
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'rmrep'
    Filter = 'rmrep|*.rmrep'
    Left = 204
    Top = 24
  end
  object dsDayRep: TClientDataSet
    Active = True
    Aggregates = <
      item
        Active = True
        AggregateName = 'HourSum'
        Expression = 'sum(hours)'
        Visible = False
      end>
    AggregatesActive = True
    DataSetField = dsRepDayRep
    Params = <>
    AfterPost = dsDayRepAfterPost
    Left = 20
    Top = 512
    object dsDayRepTask: TIntegerField
      FieldName = 'Task'
    end
    object dsDayRepText: TStringField
      FieldName = 'Text'
      Size = 100
    end
    object dsDayRepHours: TFloatField
      FieldName = 'Hours'
    end
    object dsDayRepClearTask: TBooleanField
      FieldName = 'ClearTask'
    end
    object dsDayRepActivityID: TIntegerField
      FieldName = 'ActivityID'
      LookupDataSet = dsActivity
      LookupKeyFields = 'ID'
      LookupResultField = 'Text'
      KeyFields = 'ActivityID'
    end
    object dsDayRepActivity: TStringField
      FieldKind = fkLookup
      FieldName = 'Activity'
      LookupDataSet = dsActivity
      LookupKeyFields = 'ID'
      LookupResultField = 'Text'
      KeyFields = 'ActivityID'
      Lookup = True
    end
  end
  object DataSourceDay: TDataSource
    DataSet = dsDayRep
    OnDataChange = DataSourceDayDataChange
    Left = 52
    Top = 512
  end
  object DataSourceActLookup: TDataSource
    DataSet = dsActivity
    Left = 52
    Top = 544
  end
end
