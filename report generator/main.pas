unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, DBClient, DBCtrls, Grids, DBGrids, ComCtrls, ExtCtrls,
  dblookup, Mask;

type
  TFormMain = class(TForm)
    dsRep: TClientDataSet;
    dsRepDate: TDateField;
    dsRepDay: TStringField;
    dsRepHours: TFloatField;
    dsRepDraftReport: TMemoField;
    dsRepFormatedReport: TMemoField;
    DataSource: TDataSource;
    PageControl1: TPageControl;
    tsInData: TTabSheet;
    MemoInData: TMemo;
    TabSheet1: TTabSheet;
    DBGrid1: TDBGrid;
    Button1: TButton;
    TabSheet2: TTabSheet;
    MemoOut: TMemo;
    dsRepCalcHours: TFloatField;
    MemoDebug: TMemo;
    Panel1: TPanel;
    btnSave: TButton;
    btnLoad: TButton;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    dsRepHoursAcc: TFloatField;
    dsRepTime: TTimeField;
    dsRepBegin: TTimeField;
    dsRepEnd: TTimeField;
    dsRepDinner: TTimeField;
    dsRepDayRep: TDataSetField;
    PageControl2: TPageControl;
    tsOrigRep: TTabSheet;
    DBMemoReport: TDBMemo;
    tsFormatedRep: TTabSheet;
    DBMemoFormatedReport: TDBMemo;
    Splitter1: TSplitter;
    DBGrid2: TDBGrid;
    Splitter2: TSplitter;
    Panel2: TPanel;
    dsDayRep: TClientDataSet;
    DataSourceDay: TDataSource;
    dsDayRepTask: TIntegerField;
    dsDayRepText: TStringField;
    dsDayRepHours: TFloatField;
    dsDayRepClearTask: TBooleanField;
    dsDayRepActivityID: TIntegerField;
    dsActivity: TClientDataSet;
    btnConvertToDs: TButton;
    dsActivityID: TIntegerField;
    dsActivityText: TStringField;
    DataSourceActLookup: TDataSource;
    dsDayRepActivity: TStringField;
    btnConvertBack: TButton;
    edCalcHours: TDBEdit;
    Panel3: TPanel;
    LabelHours: TLabel;
    cbFilterOk: TCheckBox;
    btnTextOut: TButton;
    procedure Button1Click(Sender: TObject);
    procedure DBMemoFormatedReportChange(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnConvertToDsClick(Sender: TObject);
    procedure DataSourceDayDataChange(Sender: TObject; Field: TField);
    procedure btnConvertBackClick(Sender: TObject);
    procedure dsDayRepAfterPost(DataSet: TDataSet);
    procedure DBMemoFormatedReportKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbFilterOkClick(Sender: TObject);
    procedure DataSourceDataChange(Sender: TObject; Field: TField);
    procedure btnTextOutClick(Sender: TObject);
  private
    procedure ParseInData;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation
uses
  strutils,math;
{$R *.dfm}

procedure TFormMain.DataSourceDataChange(Sender: TObject; Field: TField);
begin
Caption := inttostr(dsRep.RecNo)+'/'+inttostr(dsRep.RecordCount)
end;

procedure TFormMain.DataSourceDayDataChange(Sender: TObject; Field: TField);
begin
//if dsDayRep.Aggregates[0].Value<>Null then
//MemoDebug.Lines.Add(vartostr())
//edCalcHours.Text := vartostr(dsDayRep.Aggregates[0].Value);
end;

procedure TFormMain.DBMemoFormatedReportChange(Sender: TObject);
  function gethours(s: string): real;
  var
    sl: TStringList;
  begin
    sl := TStringList.Create;
    try
      sl.LineBreak := '|';
      sl.Text := s;
      result := StrToFloatDef(sl[0],0);
    finally
      sl.Free;
    end;
  end;
var
  i: integer;
  r,h: Real;
begin
  r := 0;
  for i := 0 to DBMemoFormatedReport.Lines.Count - 1 do
    r := r + gethours(DBMemoFormatedReport.Lines[i]);
  h := dsRepHours.Value;
  if not samevalue(r, h,0.01) then LabelHours.Font.Color := clRed else LabelHours.Font.Color := clBlack;
  LabelHours.Caption := FloatToStr(r) + ifthen(r=h,' = ', ' <> ') + FloatToStr(h);
  if dsRepCalcHours.Value <> r then
    dsRepCalcHours.Value := r;
//MemoDebug.Lines.Add('DBMemo1Change')

end;
function ParseReport(r: string; hours:Real): string;
var
  sl: TStringList;
  i,n,t: integer;
  actid,task,clear: string;
begin
//11:23-41:56:
  sl := TStringList.Create;
  try
    sl.Text := r;
    n := pos(': ',sl[0]);
    if (n>9) and (n<13) then
      sl[0] := Copy(sl[0],n+2,length(sl[0]));
    for i := 0 to sl.Count - 1 do
    begin
      n := pos(') ',sl[i]);
      if (n>1) and (n<4) then
        sl[i] := Copy(sl[i],n+2,length(sl[i]));
      n := pos('|',sl[i]);
      if n>0 then
        continue;
      n := pos('пров',AnsiLowerCase(sl[i]));
      actid:=ifthen(n>0,'12','17');
      task := '4490';
      clear := '|1';
      n := pos('#',sl[i]);
      if n>0 then
      begin
        t:=strtointdef(copy(sl[i],n+1,4),0);
        if t>0 then
        begin
          task := inttostr(t);
          clear := '';
        end
      end;
      sl[i] := task +'|'+actid+'|' + sl[i] + clear;
      sl[i] := floattostr(round(hours/(sl.Count)*10)/10)+'|'+sl[i];
    end;
    result := sl.Text;
  finally
    sl.Free;
  end;
end;
procedure TFormMain.DBMemoFormatedReportKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=VK_UP) and (ssCtrl in Shift) {(DBMemoFormatedReport.SelStart=0)} then dsRep.Prior;
  if (key=VK_DOWN) and (ssCtrl in Shift) {(DBMemoFormatedReport.SelStart=length(DBMemoFormatedReport.Lines.Text))} then dsRep.Next;
  if (key=ord('Q')) and (ssCtrl in Shift) then
  begin
    dsRep.Edit;
    DBMemoFormatedReport.Text := parsereport(DBMemoFormatedReport.Text,dsRepHours.Value);
    key := 0;
  end;
end;

procedure TFormMain.dsDayRepAfterPost(DataSet: TDataSet);
begin
  if dsDayRep.Aggregates[0].Value<>null then
    MemoDebug.text := dsDayRep.Aggregates[0].Value;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
dsRep.IndexFieldNames := 'Date';
//  dsRep.LoadFromFile('D:\MyDocs\work\_tracker\reps\totracker1.rmrep');
{dsActivity.Append; dsActivityID.Value := 24; dsActivityText.Value := 'Обсуждение'; dsActivity.Post;
dsActivity.Append; dsActivityID.Value := 23; dsActivityText.Value := 'Коммерция'; dsActivity.Post;
dsActivity.Append; dsActivityID.Value := 8; dsActivityText.Value := 'Обследование'; dsActivity.Post;
dsActivity.Append; dsActivityID.Value := 9; dsActivityText.Value := 'Разработка'; dsActivity.Post;
dsActivity.Append; dsActivityID.Value := 12; dsActivityText.Value := 'Проверка СП'; dsActivity.Post;
dsActivity.Append; dsActivityID.Value := 16; dsActivityText.Value := 'Включение в этал'; dsActivity.Post;
dsActivity.Append; dsActivityID.Value := 22; dsActivityText.Value := 'Внедрение'; dsActivity.Post;
dsActivity.Append; dsActivityID.Value := 11; dsActivityText.Value := 'Выезд к клиенту'; dsActivity.Post;
dsActivity.Append; dsActivityID.Value := 19; dsActivityText.Value := 'Тех-поддержка'; dsActivity.Post;
dsActivity.Append; dsActivityID.Value := 17; dsActivityText.Value := 'Другое'; dsActivity.Post;
dsActivity.MergeChangeLog;
dsActivity.SaveToFile('activity.xml');}
end;

procedure TFormMain.ParseInData;
  function ParseReport(s: string): string;
  var
    sl: TStringList;
  begin
    sl := TStringList.Create;
    try

    finally
      sl.Free;
    end;
  end;
  procedure ParseOneLine(ALine: string);
  var
    sl: TStringList;
  begin
    sl := TStringList.Create;
    try
      sl.Text := AnsiReplaceStr(ALine,#9,#13#10);
      if sl.Count<8 then exit;
      if StrToFloatDef(sl[2],0) <= 0 then exit;
      {date,	day,	окр часы,	часы,	сумма,	приход,	уход,	обед,	отчет}
      dsRep.Append;
      try
        dsRepDate.Value := StrToDate(sl[0]);
        dsRepDay.Value := sl[1];
        dsRepHours.Value := StrToFloat(sl[2]);
        dsRepHoursAcc.Value := StrToFloat(sl[3]);
        dsRepTime.Value := StrToTimeDef(sl[4],0);
        dsRepBegin.Value := StrToTimeDef(sl[5],0);
        dsRepEnd.Value := StrToTimeDef(sl[6],0);
        dsRepDinner.Value := StrToTimeDef(sl[7],0);

        if sl.Count>8 then
        begin
          dsRepDraftReport.Value := AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(sl[8],#19,#13#10),'""',#19),'"',''),#19,'"');
          dsRepFormatedReport.Value := dsRepDraftReport.Value;
          dsRepCalcHours.Value := 0;
        end;
        dsRep.Post;
      except
        dsRep.Cancel;
        raise;
      end;

    finally
      sl.Free;
    end;

  end;
var
  i,j: integer;
//  sl: TStringList;
begin
//  sl := TStringList.Create;
  try
    for i := 0 to MemoInData.lines.Count - 1 do
    begin
      try
        ParseOneLine(AnsiReplaceStr(MemoInData.Lines[i],#10,#19));
      except
        on e: exception do
          MemoDebug.Lines.Add(MemoInData.Lines[i])
      end;
//      sl.Text := AnsiReplaceStr(AnsiReplaceStr(MemoInData.Lines[i],#10,#19),#9,#13#10);
//      for j := 0 to sl.Count - 1 do
//        sl[j]
//      MemoOut.Lines.Add(inttostr(sl.Count) + sl.text);
    end;
  finally
//    sl.Free;
  end;

end;

procedure TFormMain.btnConvertToDsClick(Sender: TObject);
var
  i: integer;
begin
  while not dsDayRep.Eof do
    dsDayRep.Delete;
  for i := 0 to DBMemoFormatedReport.Lines.Count - 1 do
  begin
    dsDayRep.Append;
    try
      dsDayRepText.Value := DBMemoFormatedReport.Lines[i];
      dsDayRep.Post;
    except
      dsDayRep.Cancel;
    end;
  end;
end;

procedure TFormMain.btnLoadClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    dsRep.LoadFromFile(OpenDialog.FileName);
end;

procedure TFormMain.btnSaveClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    dsRep.SaveToFile(SaveDialog.FileName);
end;

procedure TFormMain.btnTextOutClick(Sender: TObject);
  function slval(s: TStrings;i: integer): string;
  begin
    result := '';
    if s.Count>i then
      result := s[i];
  end;
var
  date,day,dayh,orgtext,task,text,hours,clear,activityid: string;
  sl,sl2,sl3: TStringList;
  i: integer;
begin
  sl := TStringList.Create;
  sl2 := TStringList.Create;
  sl3 := TStringList.Create;
  dsRep.DisableControls;
  try
    sl3.LineBreak := '|';
    dsRep.First;
    while not dsRep.Eof do
    begin
      sl.Text := dsRepDraftReport.Value;
      sl2.Text := dsRepFormatedReport.Value;
      for i := 0 to sl2.Count - 1 do
      begin
        date := '';
        day := '';
        dayh := '';
        if i=0 then
        begin
          date := DateToStr(dsRepDate.Value);
          day := dsRepDay.Value;
          dayh := FloatToStr(dsRepHours.Value);
        end;
        orgtext := slval(sl,i);
        sl3.Text := sl2[i];
        //3,4|4490|17|заполнение трекера и отчета, проверка отчетов|1
        hours := slval(sl3,0);
        task  := slval(sl3,1);
        activityid := slval(sl3,2);
        text := slval(sl3,3);
        clear := slval(sl3,4);
        MemoOut.Lines.Add(date+#9+
day+#9+
dayh+#9+
''+#9+
''+#9+
orgtext+#9+
''+#9+
''+#9+
task+#9+
text+#9+
hours+#9+
clear+#9+
activityid);
      end;
      dsRep.Next;
    end;
  finally
    dsRep.EnableControls;
    sl.Free;
    sl2.Free;
    sl3.Free;
  end;
end;

procedure TFormMain.Button1Click(Sender: TObject);
begin
ParseInData;
//Caption := inttostr(MemoInData.Lines.Count);
//MemoInData.Text := AnsiReplaceStr(MemoInData.Text,#9,#13#10);
end;

procedure TFormMain.cbFilterOkClick(Sender: TObject);
begin
  if cbFilterOk.Checked then
  begin
    dsRep.Filter := '(hours<>calchours)';
    dsRep.Filtered := true;
  end
  else
    dsRep.Filtered := false;
end;

procedure TFormMain.btnConvertBackClick(Sender: TObject);
begin
  if not dsRep.Active then exit;
  if not (dsRep.State in dsEditModes) then
    dsRep.Edit;
  if dsDayRep.Aggregates[0].Value<>null then
    dsRepCalcHours.Value := dsDayRep.Aggregates[0].Value;
  dsRep.post;
end;

end.
