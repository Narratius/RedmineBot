unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, OleCtrls, SHDocVw;

type
  TRedmineBotForm = class(TForm)
    wb: TWebBrowser;
    Panel1: TPanel;
    MemoInfo: TMemo;
    btnAuth: TButton;
    GroupBox1: TGroupBox;
    btnLoadTasks: TButton;
    btnUpdateTasks: TButton;
    Button1: TButton;
    Button2: TButton;
    GroupBox2: TGroupBox;
    btnGanttLoadList: TButton;
    btnGanttArrange: TButton;
    checkGanttUseMemo: TCheckBox;
    checkUpdateUseMemo: TCheckBox;
    procedure btnAuthClick(Sender: TObject);
    procedure btnLoadTasksClick(Sender: TObject);
    procedure wbDocumentComplete(ASender: TObject; const pDisp: IDispatch;
      const URL: OleVariant);
    procedure Button1Click(Sender: TObject);
    procedure btnUpdateTasksClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnGanttLoadListClick(Sender: TObject);
    procedure btnGanttArrangeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure checkGanttUseMemoClick(Sender: TObject);
    procedure checkUpdateUseMemoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    fdone: boolean;
    f_LogFile: TStream;
  private
    procedure ArrangeTask(aPrevTask, aTask: String);
    procedure GoUrl(AUrl: string);
    procedure GetStatus(aTask: String);
    procedure GetTaskDates(aTask: String; out aStart, aFinish, aTime, aAddTime: String);
    procedure Submit(AFormID: string);
    procedure UpdateStatus(ATask, AStatus, ANotes: string);
    procedure tt(adate, atask: string; acleartask: boolean; acomment,
      aactivityid, ahours: string);
    procedure ClickByName(AName: string);
    procedure UpdateUser(ATask, AUser, AStatus, ANotes: string);
    procedure CheckActual(ATask: string; AActual: boolean);
    function SetCheckBoxValue(AID: string; ACheckValue: boolean): boolean;
    procedure UpdateTaskDates(ATask, ASD, AED: string);
    procedure ud(ATask, ASD, AED: string);
    procedure MoveTask(ATask, ANewProjectID: string);
    procedure addtask(prj, subj, desc, time, categ: string);
    procedure setparent(id,parent: string);
    procedure upd2(ATask, AUser, ASD, AED: string);
    procedure Login;
    procedure ShowGantt;
    procedure Log(const St: String; ToFile: Boolean = False);
  public
    { Public declarations }
  end;

var
  RedmineBotForm: TRedmineBotForm;

implementation

{$R *.dfm}

Uses
  PassForm,
  ClipBrd, RegularExpressions, DateUtils, Math;

 (*
<select id="time_entry_activity_id" name="time_entry[activity_id]">
<option value="">--- Выберите ---</option>
<option value="23">Коммерция</option>
<option value="8">Обследование</option>
<option value="25">Орг. вопросы</option>
<option value="24">Обсуждение</option><option value="9">Разработка</option>
<option value="12">Проверка СП</option>
<option value="16">Включение в этал</option>
<option value="22">Внедрение</option>
<option value="11">Выезд к клиенту</option>
<option value="19">Тех-поддержка</option>
<option value="26">Согласование</option>
<option value="27">Протокол</option>
<option value="17">Другое</option>
<option value="28">ТестированиеММЦ</option>
<option value="29">ДоработкиММЦ</option>
<option value="46">Консультации</option>
<option value="47">Обучение</option></select>
*)

const
 actCommerce = '23';
 actObserve  = '8';
 actOrgTasks = '25';

procedure TRedmineBotForm.GoUrl(AUrl: string);
begin
  fdone := false;
  wb.Navigate(AUrl);
  repeat Application.ProcessMessages until FDone;
end;


procedure TRedmineBotForm.Log(const St: String; ToFile: Boolean = False);
var
 l_B: AnsiString;
begin
  MemoInfo.Lines.Add(St);
  if ToFile then
  begin
   l_B:= FormatDateTime('dd-mm-yyyy hh:nn:ss:zzz ', Now) + St + #13#10;
   f_LogFile.Write(l_B[1], Length(l_B));
  end;
end;

procedure TRedmineBotForm.Login;
var
  sl: TStringList;
  l_FileName, l_Login, l_Password: String;
begin
  l_FileName:= ExtractFileDir(Application.ExeName)+'\rmpass.txt';
  sl := TStringList.Create;
  try
    if not FileExists(l_FileName) then
    begin
     with TPasswordForm.Create(Application) do
     Try
       if Execute(l_Login, l_Password) then
       begin
         sl.Values['user']:= l_Login;
         sl.Values['pass']:= l_Password;
         sl.SaveToFile(l_FileName);
         sl.Clear;
       end;
     Finally
      Free;
     End;
    end;

    sl.LoadFromFile(l_FileName);
    GoUrl('http://ws2.medwork.ru:33380/redmine/login');
    wb.OleObject.Document.getElementById('username').value := sl.values['user'];
    wb.OleObject.Document.getElementById('password').value := sl.values['pass'];
    Log(Format('Вход по именем %s', [sl.values['user']]), True);
  finally
    sl.Free;
  end;
end;

procedure TRedmineBotForm.ShowGantt;
begin
 GoUrl('http://ws2.medwork.ru:33380/redmine/issues/gantt');
end;

procedure TRedmineBotForm.Submit(AFormID: string);
begin
  fdone := false;
  if aformid='' then
    wb.OleObject.Document.GetElementsByTagName('form').item(0).Submit
  else
    wb.OleObject.Document.getElementById(AFormID).Submit;
  repeat Application.ProcessMessages until FDone;
end;

procedure TRedmineBotForm.ClickByName(AName: string);
var
  v: OleVariant;
begin
  fdone := false;
  v := wb.OleObject.Document.getElementsByName(AName).item(0);//.InvokeMember('Click');//click;
  v.Click;
//  showmessage(v.type);
  repeat Application.ProcessMessages until FDone;
end;

procedure TRedmineBotForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(f_LogFile);
end;

procedure TRedmineBotForm.FormCreate(Sender: TObject);
var
 l_FileName: String;
 l_Mode: Word;
begin
 l_FileName:= ChangeFileExt(Application.ExeName, '.log');
 l_Mode:= IfThen(FileExists(l_FileName), fmOpenWrite, fmCreate);
 f_LogFile:= TFileStream.Create(l_FileName, l_Mode or fmShareDenyWrite);
 f_LogFile.Seek(0, soEnd);
end;

procedure TRedmineBotForm.UpdateStatus(ATask, AStatus, ANotes: string);
begin
  GoUrl('http://ws2.medwork.ru:33380/redmine/issues/'+ATask+'/edit');
  wb.OleObject.Document.getElementById('issue_status_id').value := AStatus;
  wb.OleObject.Document.getElementById('notes').value := ANotes;
  submit('issue-form');
end;

procedure TRedmineBotForm.UpdateTaskDates(ATask, ASD, AED: string);
begin
  GoUrl('http://ws2.medwork.ru:33380/redmine/issues/'+ATask+'/edit');
  wb.OleObject.Document.getElementById('issue_start_date').value := ASD;
  wb.OleObject.Document.getElementById('issue_due_date').value := AED;
  wb.OleObject.Document.getElementById('time_entry_hours').Value:= '0.15';
  wb.OleObject.Document.getElementById('time_entry_comments').value := 'Выравнивание задачи';
  wb.OleObject.Document.getElementById('time_entry_activity_id').value := '25';
  submit('issue-form');
  Log(ATask + ' done');
end;

procedure TRedmineBotForm.UpdateUser(ATask, AUser, AStatus, ANotes: string);
begin
  GoUrl('http://ws2.medwork.ru:33380/redmine/issues/'+ATask+'/edit');
  wb.OleObject.Document.getElementById('issue_assigned_to_id').value := AUser;
  wb.OleObject.Document.getElementById('issue_status_id').value := AStatus;
  wb.OleObject.Document.getElementById('notes').value := ANotes;
  submit('issue-form');
end;

procedure TRedmineBotForm.ud(ATask, ASD, AED: string);
begin
  UpdateTaskDates(aTask, aSD, aED)
end;

procedure TRedmineBotForm.upd2(ATask, AUser, ASD, AED: string);
begin
  GoUrl('http://ws2.medwork.ru:33380/redmine/issues/'+ATask+'/edit');
  wb.OleObject.Document.getElementById('issue_assigned_to_id').value := AUser;
  wb.OleObject.Document.getElementById('issue_start_date').value := ASD;
  wb.OleObject.Document.getElementById('issue_due_date').value := AED;
  wb.OleObject.Document.getElementById('issue_status_id').value := '25';
  submit('issue-form');
  Log(ATask + ' done');
end;
{issue-form
GetElementsByTagName
}
function TRedmineBotForm.SetCheckBoxValue(AID: string; ACheckValue: boolean): boolean;
var
  el: variant;
  i: integer;
begin
  result := false;
  el := wb.OleObject.Document.GetElementsByTagName('input');
  for i := 0 to el.Length - 1 do
    //if el.item(i).id <> null then
    if (el.item(i).id=aid) and (el.item(i).type='checkbox') then
    begin
      if ACheckValue and (el.item(i).checked <> 'True') then
      begin
        el.item(i).Click;
        //el.item(i).checked := 'True';
        result := true;
      end;
      if (not ACheckValue) and (el.item(i).checked = 'True') then
      begin
        el.item(i).Click;
        //el.item(i).checked := '';//'False';
        result := true;
      end;
      exit;
    end;
{      Log( el.item(i).id );
      Log( el.item(i).type );
      Log( el.item(i).checked );}
//    Log( el.item(i).type );
{    if ( AnsiUpperCase( el[i].type ) = 'CHECKBOX' ) then
      if ( el[i].id = aid ) then
      begin
        result := el[i];
        exit;
      end;}
end;
procedure TRedmineBotForm.setparent(id, parent: string);
begin
  GoUrl('http://ws2.medwork.ru:33380/redmine/issues/parent_edit?ids%5B%5D='+id);
  wb.OleObject.Document.getElementById('parent').value := parent;
  ClickByName('commit');
  Log(id+#9'done');
end;

procedure TRedmineBotForm.CheckActual(ATask: string; AActual: boolean);
var
  el: OleVariant;
begin
//  if AActual then exit;
  GoUrl('http://ws2.medwork.ru:33380/redmine/issues/'+ATask+'/edit');
//  wb.OleObject.Document.getElementById('issue_status_id').value := AStatus;
//  wb.OleObject.Document.getElementById('notes').value := ANotes;
//  submit('issue-form');
  if SetCheckBoxValue('issue_custom_field_values_8',AActual) then
  begin
    Log('need to save');
    submit('issue-form');
  end
  else
    Log('not need to save');
  Log(ATask + ' done');
{  el := FindCheckBox('issue_custom_field_values_8');
  if el <> null then
  begin
    Log(FindCheckBox('issue_custom_field_values_8').checked);
  end;}
//Log(FindCheckBox('issue_custom_field_values_8').checked)
//  Log(ATask+#9+vartostr(wb.OleObject.Document.getElementById('issue_custom_field_values_8').checked));
end;

procedure TRedmineBotForm.checkUpdateUseMemoClick(Sender: TObject);
begin
  btnUpdateTasks.Enabled:= checkUpdateUseMemo.Checked
end;

procedure TRedmineBotForm.checkGanttUseMemoClick(Sender: TObject);
begin
 btnGanttArrange.Enabled:= checkGanttUseMemo.Checked;
end;

procedure TRedmineBotForm.addtask(prj,subj,desc,time,categ: string);
begin
  GoUrl('http://ws2.medwork.ru:33380/redmine/projects/'+prj+'/issues/new');
  wb.OleObject.Document.getElementById('issue_subject').value := subj;
  wb.OleObject.Document.getElementById('issue_description').value := desc;
  wb.OleObject.Document.getElementById('issue_estimated_hours').value := time;
  SetCheckBoxValue('issue_custom_field_values_15',true);
  wb.OleObject.Document.getElementById('issue_custom_field_values_21').value := categ;
  ClickByName('commit');
  Log(subj+#9'done');
end;

procedure TRedmineBotForm.btnLoadTasksClick(Sender: TObject);
var
  l_List: TStrings;
  l_Task: TArray<string>;
begin
 { 1. Загрузить из буфера изменения
   2. Разделить на параметры
   3. Применить изменения }
 MemoInfo.Lines.Clear;
 MemoInfo.Lines.Text:= Clipboard.AsText;
end;

procedure TRedmineBotForm.btnUpdateTasksClick(Sender: TObject);
var
  l_Count, i, j: Integer;
  l_RegEx: TRegEx;
  l_Match: TMatch;
  M: TMatchCollection;
begin
   l_Count:= MemoInfo.Lines.Count;
   l_RegEx:= TRegEx.Create('(\d{5})|([0-9][0-9][0-9][0-9]\-[0-9][0-9]\-[0-9][0-9])');
   for i := 0 to Pred(l_Count) do
   begin
    if l_RegEx.IsMatch(MemoInfo.Lines[i]) then
    begin
     M:= l_RegEx.Matches(MemoInfo.Lines[i]);
     UpdateTaskDates(M.Item[0].Value, M.Item[1].Value, M.Item[2].Value);
    end;
   end;
 ShowGantt;
end;

procedure TRedmineBotForm.ArrangeTask(aPrevTask, aTask: String);
var
 l_PDS, l_PDF, l_TDS, l_TDF, l_Time, l_AddTime: String;
 l_DateFinish: TDateTime;
 l_Duration: Integer;
 l_DS: TFormatSettings;
begin
 // Выравнивание дат относительно предыдущей задачи - aTask.StartDate = aPrevTask.FinishDate
 GetTaskDates(aPrevTask, l_PDS, l_PDF, l_Time, l_AddTime);
 GetTaskDates(aTask, l_TDS, l_TDF, l_Time, l_AddTime);

 Log(aTask, True);
 Log(Format('From: %s - %s', [l_TDS, l_TDF]), True);

 l_Duration:= Max(StrToIntDef(l_Time, 0) + StrToIntDef(l_AddTime, 0), 8) div 8 + 1;
 l_TDS:= l_PDF;
 l_DS:= TFormatSettings.Create;
 l_DS.ShortDateFormat:= 'YYYY-MM-DD';
 l_DS.DateSeparator:= '-';
 l_DateFinish:= StrToDateTime(l_TDS, l_DS);
 if DayOfTheWeek(l_dateFinish) = 5 then
  Inc(l_Duration, 2);
 l_DateFinish:= IncDay(l_dateFinish, l_Duration);
 l_TDF:= DateTimeToStr(l_DateFinish, l_DS);
 Log(Format('To:   %s - %s', [l_TDS, l_TDF]), True);
 UpdateTaskDates(aTask, l_TDS, l_TDF);
end;

procedure TRedmineBotForm.btnAuthClick(Sender: TObject);
begin
  Login;
end;

procedure TRedmineBotForm.btnGanttArrangeClick(Sender: TObject);
var
 l_Prev, l_Task: String;
 i, l_Count: Integer;
begin
 // Последовательно сдвигаем задачи
 l_Prev:= MemoInfo.Lines[0];
 l_Count:= MemoInfo.Lines.Count;
 for I := 1 to l_Count-1 do
 begin
   l_Task:= MemoInfo.Lines[i];
   ArrangeTask(l_Prev, l_Task);
   l_Prev:= l_Task;
 end;
end;

procedure TRedmineBotForm.btnGanttLoadListClick(Sender: TObject);
begin
 // В буфере обмена должен быть список номеров задач
 MemoInfo.Lines.Clear;
 MemoInfo.Lines.Text:= Clipboard.AsText;
 btnGanttArrange.Enabled:= MemoInfo.Lines.Count > 1;
end;

procedure TRedmineBotForm.MoveTask(ATask, ANewProjectID: string);
begin
  GoUrl('http://ws2.medwork.ru:33380/redmine/issues/'+ATask+'/move');
  wb.OleObject.Document.getElementById('new_project_id').value := ANewProjectID;
  ClickByName('commit');
end;


procedure TRedmineBotForm.GetStatus(ATask: string);
begin
  GoUrl('http://ws2.medwork.ru:33380/redmine/issues/'+ATask+'/edit');
  Log(ATask+#9+vartostr(wb.OleObject.Document.getElementById('issue_status_id').value));
end;



procedure TRedmineBotForm.GetTaskDates(aTask: String; out aStart, aFinish, aTime, aAddTime: String);
begin
  GoUrl('http://ws2.medwork.ru:33380/redmine/issues/'+ATask+'/edit');
  aStart:= wb.OleObject.Document.getElementById('issue_start_date').value;
  aFinish:= wb.OleObject.Document.getElementById('issue_due_date').value;
  aTime:= wb.OleObject.Document.getElementById('issue_estimated_hours').value;
  aAddTime:= wb.OleObject.Document.getElementById('issue_custom_field_values_20').value;
end;

procedure TRedmineBotForm.tt(adate,atask: string; acleartask: boolean; acomment, aactivityid, ahours: string);
begin
  Log(adate+#9+atask);
  GoUrl('http://ws2.medwork.ru:33380/redmine/issues/'+atask+'/time_entries/new');
  if acleartask then
    wb.OleObject.Document.getElementById('time_entry_issue_id').value := '';
  wb.OleObject.Document.getElementById('time_entry_spent_on').value := adate;
  wb.OleObject.Document.getElementById('time_entry_hours').value := ahours;
  wb.OleObject.Document.getElementById('time_entry_comments').value := acomment;
  wb.OleObject.Document.getElementById('time_entry_activity_id').value := aactivityid;
  ClickByName('commit');
  Log(adate+#9+atask+#9'done');
end;

procedure TRedmineBotForm.Button1Click(Sender: TObject);
begin
 ShowGantt;
end;


procedure TRedmineBotForm.Button2Click(Sender: TObject);
begin
 ArrangeTask('18551', '18064');
end;

procedure TRedmineBotForm.wbDocumentComplete(ASender: TObject; const pDisp: IDispatch;
  const URL: OleVariant);
begin
  fdone := true;
end;


end.
