unit FormSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Spin, ExtCtrls;

type
  TfrmSettings = class(TForm)
    PageControl: TPageControl;
    tabGeneral: TTabSheet;
    tabI2C: TTabSheet;
    tabSPI: TTabSheet;
    tabWindow: TTabSheet;
    btnOK: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    grpConnection: TGroupBox;
    cbAutoConnect: TCheckBox;
    grpLogging: TGroupBox;
    cbSaveLogOnExit: TCheckBox;
    edtLogFilePath: TEdit;
    btnBrowseLog: TButton;
    lblLanguage: TLabel;
    cbLanguage: TComboBox;
    grpI2CSettings: TGroupBox;
    lblI2CClock: TLabel;
    seI2CClock: TSpinEdit;
    grpSPISettings: TGroupBox;
    lblSPIClock: TLabel;
    seSPIClock: TSpinEdit;
    lblSPIChipSelect: TLabel;
    cbSPIChipSelect: TComboBox;
    grpWindowPos: TGroupBox;
    chkRememberPos: TCheckBox;
    btnSaveDefaults: TButton;
    dlgOpenFolder: TFileOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnBrowseLogClick(Sender: TObject);
    procedure btnSaveDefaultsClick(Sender: TObject);
  private
    procedure LoadSettingsToControls;
    procedure SaveControlsToSettings;
  public
  end;

var
  frmSettings: TfrmSettings;

implementation

uses
  Settings, Log;

{$R *.dfm}

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  // Populate language combo
  cbLanguage.Items.Add('English');
  cbLanguage.Items.Add('Russian');
  cbLanguage.Items.Add('Chinese');
  
  // Populate SPI chip select
  cbSPIChipSelect.Items.Add('CS0');
  cbSPIChipSelect.Items.Add('CS1');
  cbSPIChipSelect.Items.Add('CS2');
  cbSPIChipSelect.Items.Add('CS3');
end;

procedure TfrmSettings.FormShow(Sender: TObject);
begin
  LoadSettingsToControls;
end;

procedure TfrmSettings.LoadSettingsToControls;
begin
  // General settings
  cbAutoConnect.Checked := AppSettings.AutoConnect;
  cbSaveLogOnExit.Checked := AppSettings.SaveLogOnExit;
  edtLogFilePath.Text := AppSettings.LogFilePath;
  
  case AppSettings.Language of
    'en': cbLanguage.ItemIndex := 0;
    'ru': cbLanguage.ItemIndex := 1;
    'zh': cbLanguage.ItemIndex := 2;
  else
    cbLanguage.ItemIndex := 0;
  end;
  
  // I2C settings
  seI2CClock.Value := AppSettings.I2CClockSpeed;
  
  // SPI settings
  seSPIClock.Value := AppSettings.SPIClockSpeed;
  cbSPIChipSelect.ItemIndex := AppSettings.SPIChipSelect;
  
  // Window settings
  chkRememberPos.Checked := (AppSettings.WindowPositionX >= 0);
end;

procedure TfrmSettings.SaveControlsToSettings;
begin
  // General settings
  AppSettings.AutoConnect := cbAutoConnect.Checked;
  AppSettings.SaveLogOnExit := cbSaveLogOnExit.Checked;
  AppSettings.LogFilePath := edtLogFilePath.Text;
  
  case cbLanguage.ItemIndex of
    0: AppSettings.Language := 'en';
    1: AppSettings.Language := 'ru';
    2: AppSettings.Language := 'zh';
  else
    AppSettings.Language := 'en';
  end;
  
  // I2C settings
  AppSettings.I2CClockSpeed := seI2CClock.Value;
  
  // SPI settings
  AppSettings.SPIClockSpeed := seSPIClock.Value;
  AppSettings.SPIChipSelect := cbSPIChipSelect.ItemIndex;
  
  // Window settings
  if not chkRememberPos.Checked then
  begin
    AppSettings.WindowPositionX := -1;
    AppSettings.WindowPositionY := -1;
  end;
end;

procedure TfrmSettings.btnOKClick(Sender: TObject);
begin
  SaveControlsToSettings;
  ModalResult := mrOk;
end;

procedure TfrmSettings.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmSettings.btnApplyClick(Sender: TObject);
begin
  SaveControlsToSettings;
  AppSettings.Save;
  Logger.Info('Settings applied');
end;

procedure TfrmSettings.btnBrowseLogClick(Sender: TObject);
begin
  if dlgOpenFolder.Execute then
    edtLogFilePath.Text := dlgOpenFolder.FileName;
end;

procedure TfrmSettings.btnSaveDefaultsClick(Sender: TObject);
begin
  AppSettings.ResetToDefaults;
  LoadSettingsToControls;
  Logger.Info('Settings reset to defaults');
end;

end.
