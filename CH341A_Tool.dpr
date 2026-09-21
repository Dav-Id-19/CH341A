program CH341A_Tool;

uses
  Forms,
  FormMain in 'Source\FormMain.pas' {frmMain},
  FormAbout in 'Forms\FormAbout.pas' {frmAbout},
  FormSettings in 'Forms\FormSettings.pas' {frmSettings},
  LogUnit in 'Forms\LogUnit.pas' {frmLog},
  Settings in 'Source\Settings.pas',
  Log in 'Source\Log.pas',
  CH341DLL in 'Lib\CH341DLL.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'CH341A Tool';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
