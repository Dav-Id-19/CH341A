unit Log;

interface

uses
  Classes, SysUtils, SyncObjs;

type
  TLogLevel = (llDebug, llInfo, llWarning, llError);

  TLogEntry = record
    TimeStamp: TDateTime;
    Level: TLogLevel;
    Message: string;
  end;

  TLogNotifyEvent = procedure(const Entry: TLogEntry) of object;

  TLog = class
  private
    FEntries: TStringList;
    FCriticalSection: TCriticalSection;
    FMaxEntries: Integer;
    FLogFile: string;
    FOnNewEntry: TLogNotifyEvent;
    procedure AddEntry(const Level: TLogLevel; const Msg: string);
    function GetEntryCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure Clear;
    procedure Debug(const Msg: string);
    procedure Info(const Msg: string);
    procedure Warning(const Msg: string);
    procedure Error(const Msg: string);
    procedure SaveToFile(const FileName: string);
    function GetEntries: TStringList;
    
    property EntryCount: Integer read GetEntryCount;
    property MaxEntries: Integer read FMaxEntries write FMaxEntries;
    property LogFile: string read FLogFile write FLogFile;
    property OnNewEntry: TLogNotifyEvent read FOnNewEntry write FOnNewEntry;
  end;

var
  Logger: TLog;

implementation

{ TLog }

constructor TLog.Create;
begin
  inherited Create;
  FEntries := TStringList.Create;
  FCriticalSection := TCriticalSection.Create;
  FMaxEntries := 1000;
  FLogFile := '';
end;

destructor TLog.Destroy;
begin
  FCriticalSection.Free;
  FEntries.Free;
  inherited Destroy;
end;

procedure TLog.AddEntry(const Level: TLogLevel; const Msg: string);
var
  Entry: TLogEntry;
  EntryStr: string;
begin
  FCriticalSection.Enter;
  try
    Entry.TimeStamp := Now;
    Entry.Level := Level;
    Entry.Message := Msg;
    
    case Level of
      llDebug: EntryStr := Format('[DEBUG] %s - %s', [DateTimeToStr(Entry.TimeStamp), Msg]);
      llInfo: EntryStr := Format('[INFO] %s - %s', [DateTimeToStr(Entry.TimeStamp), Msg]);
      llWarning: EntryStr := Format('[WARNING] %s - %s', [DateTimeToStr(Entry.TimeStamp), Msg]);
      llError: EntryStr := Format('[ERROR] %s - %s', [DateTimeToStr(Entry.TimeStamp), Msg]);
    end;
    
    FEntries.Add(EntryStr);
    
    // Remove oldest entries if limit exceeded
    while FEntries.Count > FMaxEntries do
      FEntries.Delete(0);
    
    if Assigned(FOnNewEntry) then
      FOnNewEntry(Entry);
      
    // Write to file if log file is specified
    if FLogFile <> '' then
    begin
      try
        with TStringList.Create do
        try
          Add(EntryStr);
          SaveToFile(FLogFile);
        finally
          Free;
        end;
      except
        // Ignore file write errors
      end;
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TLog.Clear;
begin
  FCriticalSection.Enter;
  try
    FEntries.Clear;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TLog.Debug(const Msg: string);
begin
  AddEntry(llDebug, Msg);
end;

procedure TLog.Info(const Msg: string);
begin
  AddEntry(llInfo, Msg);
end;

procedure TLog.Warning(const Msg: string);
begin
  AddEntry(llWarning, Msg);
end;

procedure TLog.Error(const Msg: string);
begin
  AddEntry(llError, Msg);
end;

procedure TLog.SaveToFile(const FileName: string);
begin
  FCriticalSection.Enter;
  try
    FEntries.SaveToFile(FileName);
  finally
    FCriticalSection.Leave;
  end;
end;

function TLog.GetEntries: TStringList;
begin
  FCriticalSection.Enter;
  try
    Result := TStringList.Create;
    Result.Assign(FEntries);
  finally
    FCriticalSection.Leave;
  end;
end;

function TLog.GetEntryCount: Integer;
begin
  FCriticalSection.Enter;
  try
    Result := FEntries.Count;
  finally
    FCriticalSection.Leave;
  end;
end;

initialization
  Logger := TLog.Create;
  
finalization
  Logger.Free;
  
end.
