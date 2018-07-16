program rmbot;

uses
  Forms,
  main in 'main.pas' {RedmineBotForm},
  PassForm in 'PassForm.pas' {PasswordForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TRedmineBotForm, RedmineBotForm);
  Application.CreateForm(TPasswordForm, PasswordForm);
  Application.Run;
end.
