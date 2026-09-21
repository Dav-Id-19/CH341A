unit Settings;

interface

uses
  Classes, SysUtils, IniFiles;

type
  TConnectionType = (ctI2C, ctSPI, ctGPIO, ctEEPROM);
  
  TAppSettings = record
    ConnectionType: TConnectionType;
    I2CClockSpeed: Integer;      // in kHz
    SPIClockSpeed: Integer;      // in kHz
    SPIChipSelect: Integer;
    AutoConnect: Boolean;
    SaveLogOnExit: Boolean;
    LogFilePath: string;
    WindowPositionX: Integer;
    WindowPositionY: Integer;
    WindowWidth: Integer;
    WindowHeight: Integer;
    LastUsedFolder: string;
    Language: string;
  end;

  TSettings = class
  private
    FSettings: TAppSettings;
    FIniFile: TIniFile;
    FFileName: string;
    procedure SetDefaults;
    function GetConnectionType: TConnectionType;
    procedure SetConnectionType(const Value: TConnectionType);
    function GetI2CClockSpeed: Integer;
    procedure SetI2CClockSpeed(const Value: Integer);
    function GetSPIClockSpeed: Integer;
    procedure SetSPIClockSpeed(const Value: Integer);
    function GetSPIChipSelect: Integer;
    procedure SetSPIChipSelect(const Value: Integer);
    function GetAutoConnect: Boolean;
    procedure SetAutoConnect(const Value: Boolean);
    function GetSaveLogOnExit: Boolean;
    procedure SetSaveLogOnExit(const Value: Boolean);
    function GetLogFilePath: string;
    procedure SetLogFilePath(const Value: string);
    function GetWindowPositionX: Integer;
    procedure SetWindowPositionX(const Value: Integer);
    function GetWindowPositionY: Integer;
    procedure SetWindowPositionY(const Value: Integer);
    function GetWindowWidth: Integer;
    procedure SetWindowWidth(const Value: Integer);
    function GetWindowHeight: Integer;
    procedure SetWindowHeight(const Value: Integer);
    function GetLastUsedFolder: string;
    procedure SetLastUsedFolder(const Value: string);
    function GetLanguage: string;
    procedure SetLanguage(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure Load;
    procedure Save;
    procedure ResetToDefaults;
    
    property ConnectionType: TConnectionType read GetConnectionType write SetConnectionType;
    property I2CClockSpeed: Integer read GetI2CClockSpeed write SetI2CClockSpeed;
    property SPIClockSpeed: Integer read GetSPIClockSpeed write SetSPIClockSpeed;
    property SPIChipSelect: Integer read GetSPIChipSelect write SetSPIChipSelect;
    property AutoConnect: Boolean read GetAutoConnect write SetAutoConnect;
    property SaveLogOnExit: Boolean read GetSaveLogOnExit write SetSaveLogOnExit;
    property LogFilePath: string read GetLogFilePath write SetLogFilePath;
    property WindowPositionX: Integer read GetWindowPositionX write SetWindowPositionX;
    property WindowPositionY: Integer read GetWindowPositionY write SetWindowPositionY;
    property WindowWidth: Integer read GetWindowWidth write SetWindowWidth;
    property WindowHeight: Integer read GetWindowHeight write SetWindowHeight;
    property LastUsedFolder: string read GetLastUsedFolder write SetLastUsedFolder;
    property Language: string read GetLanguage write SetLanguage;
  end;

var
  AppSettings: TSettings;

implementation

{ TSettings }

constructor TSettings.Create;
begin
  inherited Create;
  FFileName := ExtractFilePath(ParamStr(0)) + 'CH341A_Tool.ini';
  FIniFile := nil;
  SetDefaults;
end;

destructor TSettings.Destroy;
begin
  if Assigned(FIniFile) then
    FIniFile.Free;
  inherited Destroy;
end;

procedure TSettings.SetDefaults;
begin
  FSettings.ConnectionType := ctI2C;
  FSettings.I2CClockSpeed := 100;      // 100 kHz default
  FSettings.SPIClockSpeed := 500;      // 500 kHz default
  FSettings.SPIChipSelect := 0;
  FSettings.AutoConnect := False;
  FSettings.SaveLogOnExit := True;
  FSettings.LogFilePath := '';
  FSettings.WindowPositionX := -1;
  FSettings.WindowPositionY := -1;
  FSettings.WindowWidth := 800;
  FSettings.WindowHeight := 600;
  FSettings.LastUsedFolder := '';
  FSettings.Language := 'en';
end;

procedure TSettings.Load;
begin
  if not FileExists(FFileName) then
  begin
    SetDefaults;
    Exit;
  end;
  
  FIniFile := TIniFile.Create(FFileName);
  try
    FSettings.ConnectionType := TConnectionType(FIniFile.ReadInteger('General', 'ConnectionType', Ord(ctI2C)));
    FSettings.I2CClockSpeed := FIniFile.ReadInteger('I2C', 'ClockSpeed', 100);
    FSettings.SPIClockSpeed := FIniFile.ReadInteger('SPI', 'ClockSpeed', 500);
    FSettings.SPIChipSelect := FIniFile.ReadInteger('SPI', 'ChipSelect', 0);
    FSettings.AutoConnect := FIniFile.ReadBool('General', 'AutoConnect', False);
    FSettings.SaveLogOnExit := FIniFile.ReadBool('General', 'SaveLogOnExit', True);
    FSettings.LogFilePath := FIniFile.ReadString('General', 'LogFilePath', '');
    FSettings.WindowPositionX := FIniFile.ReadInteger('Window', 'PositionX', -1);
    FSettings.WindowPositionY := FIniFile.ReadInteger('Window', 'PositionY', -1);
    FSettings.WindowWidth := FIniFile.ReadInteger('Window', 'Width', 800);
    FSettings.WindowHeight := FIniFile.ReadInteger('Window', 'Height', 600);
    FSettings.LastUsedFolder := FIniFile.ReadString('General', 'LastUsedFolder', '');
    FSettings.Language := FIniFile.ReadString('General', 'Language', 'en');
  finally
    FIniFile.Free;
    FIniFile := nil;
  end;
end;

procedure TSettings.Save;
begin
  FIniFile := TIniFile.Create(FFileName);
  try
    FIniFile.WriteInteger('General', 'ConnectionType', Ord(FSettings.ConnectionType));
    FIniFile.WriteInteger('I2C', 'ClockSpeed', FSettings.I2CClockSpeed);
    FIniFile.WriteInteger('SPI', 'ClockSpeed', FSettings.SPIClockSpeed);
    FIniFile.WriteInteger('SPI', 'ChipSelect', FSettings.SPIChipSelect);
    FIniFile.WriteBool('General', 'AutoConnect', FSettings.AutoConnect);
    FIniFile.WriteBool('General', 'SaveLogOnExit', FSettings.SaveLogOnExit);
    FIniFile.WriteString('General', 'LogFilePath', FSettings.LogFilePath);
    FIniFile.WriteInteger('Window', 'PositionX', FSettings.WindowPositionX);
    FIniFile.WriteInteger('Window', 'PositionY', FSettings.WindowPositionY);
    FIniFile.WriteInteger('Window', 'Width', FSettings.WindowWidth);
    FIniFile.WriteInteger('Window', 'Height', FSettings.WindowHeight);
    FIniFile.WriteString('General', 'LastUsedFolder', FSettings.LastUsedFolder);
    FIniFile.WriteString('General', 'Language', FSettings.Language);
  finally
    FIniFile.Free;
    FIniFile := nil;
  end;
end;

procedure TSettings.ResetToDefaults;
begin
  SetDefaults;
end;

function TSettings.GetConnectionType: TConnectionType;
begin
  Result := FSettings.ConnectionType;
end;

procedure TSettings.SetConnectionType(const Value: TConnectionType);
begin
  FSettings.ConnectionType := Value;
end;

function TSettings.GetI2CClockSpeed: Integer;
begin
  Result := FSettings.I2CClockSpeed;
end;

procedure TSettings.SetI2CClockSpeed(const Value: Integer);
begin
  FSettings.I2CClockSpeed := Value;
end;

function TSettings.GetSPIClockSpeed: Integer;
begin
  Result := FSettings.SPIClockSpeed;
end;

procedure TSettings.SetSPIClockSpeed(const Value: Integer);
begin
  FSettings.SPIClockSpeed := Value;
end;

function TSettings.GetSPIChipSelect: Integer;
begin
  Result := FSettings.SPIChipSelect;
end;

procedure TSettings.SetSPIChipSelect(const Value: Integer);
begin
  FSettings.SPIChipSelect := Value;
end;

function TSettings.GetAutoConnect: Boolean;
begin
  Result := FSettings.AutoConnect;
end;

procedure TSettings.SetAutoConnect(const Value: Boolean);
begin
  FSettings.AutoConnect := Value;
end;

function TSettings.GetSaveLogOnExit: Boolean;
begin
  Result := FSettings.SaveLogOnExit;
end;

procedure TSettings.SetSaveLogOnExit(const Value: Boolean);
begin
  FSettings.SaveLogOnExit := Value;
end;

function TSettings.GetLogFilePath: string;
begin
  Result := FSettings.LogFilePath;
end;

procedure TSettings.SetLogFilePath(const Value: string);
begin
  FSettings.LogFilePath := Value;
end;

function TSettings.GetWindowPositionX: Integer;
begin
  Result := FSettings.WindowPositionX;
end;

procedure TSettings.SetWindowPositionX(const Value: Integer);
begin
  FSettings.WindowPositionX := Value;
end;

function TSettings.GetWindowPositionY: Integer;
begin
  Result := FSettings.WindowPositionY;
end;

procedure TSettings.SetWindowPositionY(const Value: Integer);
begin
  FSettings.WindowPositionY := Value;
end;

function TSettings.GetWindowWidth: Integer;
begin
  Result := FSettings.WindowWidth;
end;

procedure TSettings.SetWindowWidth(const Value: Integer);
begin
  FSettings.WindowWidth := Value;
end;

function TSettings.GetWindowHeight: Integer;
begin
  Result := FSettings.WindowHeight;
end;

procedure TSettings.SetWindowHeight(const Value: Integer);
begin
  FSettings.WindowHeight := Value;
end;

function TSettings.GetLastUsedFolder: string;
begin
  Result := FSettings.LastUsedFolder;
end;

procedure TSettings.SetLastUsedFolder(const Value: string);
begin
  FSettings.LastUsedFolder := Value;
end;

function TSettings.GetLanguage: string;
begin
  Result := FSettings.Language;
end;

procedure TSettings.SetLanguage(const Value: string);
begin
  FSettings.Language := Value;
end;

initialization
  AppSettings := TSettings.Create;
  
finalization
  AppSettings.Free;
  
end.
