unit FormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Menus, ExtCtrls;

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    FileMenu: TMenuItem;
    ExitItem: TMenuItem;
    ToolsMenu: TMenuItem;
    I2CToolsItem: TMenuItem;
    SPIToolsItem: TMenuItem;
    GPIOToolsItem: TMenuItem;
    HelpMenu: TMenuItem;
    AboutItem: TMenuItem;
    SettingsItem: TMenuItem;
    StatusBar: TStatusBar;
    ToolBar: TToolBar;
    btnConnect: TToolButton;
    btnDisconnect: TToolButton;
    ToolButton1: TToolButton;
    btnRead: TToolButton;
    btnWrite: TToolButton;
    PageControl: TPageControl;
    tabI2C: TTabSheet;
    tabSPI: TTabSheet;
    tabGPIO: TTabSheet;
    tabEEPROM: TTabSheet;
    pnlI2C: TPanel;
    pnlSPI: TPanel;
    pnlGPIO: TPanel;
    pnlEEPROM: TPanel;
    lblStatus: TLabel;
    LogMenuItem: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ExitItemClick(Sender: TObject);
    procedure AboutItemClick(Sender: TObject);
    procedure SettingsItemClick(Sender: TObject);
    procedure LogItemClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure I2CToolsItemClick(Sender: TObject);
    procedure SPIToolsItemClick(Sender: TObject);
    procedure GPIOToolsItemClick(Sender: TObject);
  private
    FDeviceConnected: Boolean;
    FDeviceIndex: Integer;
    procedure UpdateStatusBar;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure ConnectToDevice;
    procedure DisconnectFromDevice;
  public
    property DeviceConnected: Boolean read FDeviceConnected;
    property DeviceIndex: Integer read FDeviceIndex;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  FormAbout, FormSettings, LogUnit, Log, Settings, CH341DLL;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FDeviceConnected := False;
  FDeviceIndex := -1;
  
  // Initialize DLL
  try
    if not LoadCH341DLL then
    begin
      Logger.Error('Failed to load CH341DLL.DLL');
      ShowMessage('Error: Cannot load CH341DLL.DLL. Please ensure the DLL is in the application directory.');
    end
    else
      Logger.Info('CH341DLL.DLL loaded successfully');
  except
    on E: Exception do
    begin
      Logger.Error('Exception loading DLL: ' + E.Message);
      ShowMessage('Error loading DLL: ' + E.Message);
    end;
  end;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if FDeviceConnected then
    DisconnectFromDevice;
    
  UnloadCH341DLL;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  LoadSettings;
  
  if AppSettings.AutoConnect then
    ConnectToDevice;
end;

procedure TfrmMain.LoadSettings;
begin
  AppSettings.Load;
  
  // Apply window position
  if AppSettings.WindowPositionX >= 0 then
  begin
    Left := AppSettings.WindowPositionX;
    Top := AppSettings.WindowPositionY;
    Width := AppSettings.WindowWidth;
    Height := AppSettings.WindowHeight;
  end;
  
  Logger.Info('Settings loaded');
end;

procedure TfrmMain.SaveSettings;
begin
  AppSettings.WindowPositionX := Left;
  AppSettings.WindowPositionY := Top;
  AppSettings.WindowWidth := Width;
  AppSettings.WindowHeight := Height;
  
  AppSettings.Save;
  Logger.Info('Settings saved');
end;

procedure TfrmMain.ConnectToDevice;
begin
  if not IsDLLLoaded then
  begin
    Logger.Error('Cannot connect: DLL not loaded');
    ShowMessage('Error: CH341DLL.DLL not loaded');
    Exit;
  end;
  
  try
    FDeviceIndex := CH341OpenDevice();
    if FDeviceIndex >= 0 then
    begin
      FDeviceConnected := True;
      Logger.Info('Device connected successfully (Index: ' + IntToStr(FDeviceIndex) + ')');
      UpdateStatusBar;
      btnConnect.Enabled := False;
      btnDisconnect.Enabled := True;
    end
    else
    begin
      Logger.Error('Failed to open device');
      ShowMessage('Error: Cannot open CH341A device. Please check if it is connected.');
    end;
  except
    on E: Exception do
    begin
      Logger.Error('Exception connecting to device: ' + E.Message);
      ShowMessage('Error connecting to device: ' + E.Message);
    end;
  end;
end;

procedure TfrmMain.DisconnectFromDevice;
begin
  if FDeviceConnected and (FDeviceIndex >= 0) then
  begin
    try
      CH341CloseDevice(FDeviceIndex);
      Logger.Info('Device disconnected');
      FDeviceConnected := False;
      FDeviceIndex := -1;
      UpdateStatusBar;
      btnConnect.Enabled := True;
      btnDisconnect.Enabled := False;
    except
      on E: Exception do
      begin
        Logger.Error('Exception disconnecting device: ' + E.Message);
      end;
    end;
  end;
end;

procedure TfrmMain.UpdateStatusBar;
begin
  if FDeviceConnected then
    StatusBar.SimpleText := 'Connected - Device Index: ' + IntToStr(FDeviceIndex)
  else
    StatusBar.SimpleText := 'Disconnected';
    
  lblStatus.Caption := StatusBar.SimpleText;
end;

procedure TfrmMain.ExitItemClick(Sender: TObject);
begin
  SaveSettings;
  Close;
end;

procedure TfrmMain.AboutItemClick(Sender: TObject);
begin
  frmAbout := TfrmAbout.Create(Self);
  try
    frmAbout.ShowModal;
  finally
    frmAbout.Free;
  end;
end;

procedure TfrmMain.SettingsItemClick(Sender: TObject);
begin
  frmSettings := TfrmSettings.Create(Self);
  try
    if frmSettings.ShowModal = mrOk then
    begin
      AppSettings.Save;
      Logger.Info('Settings updated');
    end;
  finally
    frmSettings.Free;
  end;
end;

procedure TfrmMain.LogItemClick(Sender: TObject);
begin
  frmLog := TfrmLog.Create(Self);
  try
    frmLog.Show;
  finally
    // Don't free, allow multiple views
  end;
end;

procedure TfrmMain.btnConnectClick(Sender: TObject);
begin
  ConnectToDevice;
end;

procedure TfrmMain.btnDisconnectClick(Sender: TObject);
begin
  DisconnectFromDevice;
end;

procedure TfrmMain.I2CToolsItemClick(Sender: TObject);
begin
  ShowMessage('I2C Tools - To be implemented');
  Logger.Info('I2C Tools menu clicked');
end;

procedure TfrmMain.SPIToolsItemClick(Sender: TObject);
begin
  ShowMessage('SPI Tools - To be implemented');
  Logger.Info('SPI Tools menu clicked');
end;

procedure TfrmMain.GPIOToolsItemClick(Sender: TObject);
begin
  ShowMessage('GPIO Tools - To be implemented');
  Logger.Info('GPIO Tools menu clicked');
end;

end.
