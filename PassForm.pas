unit PassForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TPasswordForm = class(TForm)
    Label1: TLabel;
    EditLogin: TEdit;
    Label2: TLabel;
    EditPass: TEdit;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
    function Execute(out Login, Password: String): Boolean;
  end;

var
  PasswordForm: TPasswordForm;

implementation

{$R *.dfm}

{ TForm2 }

function TPasswordForm.Execute(out Login, Password: String): Boolean;
begin
  if IsPositiveResult(ShowModal) then
  begin
    Login:= editLogin.Text;
    Password:= editPass.Text;
  end;
end;

end.
