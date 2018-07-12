program rmbot;

uses
  Forms,
  main in 'main.pas' {RedmineBotFrame},
  PassForm in 'PassForm.pas' {PasswordForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TRedmineBotFrame, RedmineBotFrame);
  Application.CreateForm(TPasswordForm, PasswordForm);
  Application.Run;
end.
