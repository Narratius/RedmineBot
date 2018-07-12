program rmbot;

uses
  Forms,
  main in 'main.pas' {Form1},
  PassForm in 'PassForm.pas' {PasswordForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TPasswordForm, PasswordForm);
  Application.Run;
end.
