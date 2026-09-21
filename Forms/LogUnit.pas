unit LogUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Clipbrd;

type
  TfrmLog = class(TForm)
    pnlMain: TPanel;
    memLog: TMemo;
    btnClear: TButton;
    btnCopy: TButton;
    btnSave: TButton;
    btnClose: TButton;
    pnlButtons: TPanel;
    dlgSaveFile: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    procedure OnNewLogEntry(const Entry: TLogEntry);
  public
  end;

var
  frmLog: TfrmLog;

implementation

uses
  Log;

{$R *.dfm}

procedure TfrmLog.FormCreate(Sender: TObject);
begin
  // Subscribe to log events
  Logger.OnNewEntry := OnNewLogEntry;
  
  // Load existing entries
  memLog.Lines.Assign(Logger.GetEntries);
  
  Caption := 'Log Viewer - ' + IntToStr(Logger.EntryCount) + ' entries';
end;

procedure TfrmLog.FormDestroy(Sender: TObject);
begin
  Logger.OnNewEntry := nil;
end;

procedure TfrmLog.OnNewLogEntry(const Entry: TLogEntry);
var
  EntryStr: string;
begin
  case Entry.Level of
    llDebug: EntryStr := Format('[DEBUG] %s - %s', [DateTimeToStr(Entry.TimeStamp), Entry.Message]);
    llInfo: EntryStr := Format('[INFO] %s - %s', [DateTimeToStr(Entry.TimeStamp), Entry.Message]);
    llWarning: EntryStr := Format('[WARNING] %s - %s', [DateTimeToStr(Entry.TimeStamp), Entry.Message]);
    llError: EntryStr := Format('[ERROR] %s - %s', [DateTimeToStr(Entry.TimeStamp), Entry.Message]);
  end;
  
  memLog.Lines.Add(EntryStr);
  
  // Scroll to bottom
  memLog.SelStart := Length(memLog.Text);
  memLog.SelLength := 0;
  
  // Update caption
  Caption := 'Log Viewer - ' + IntToStr(Logger.EntryCount) + ' entries';
end;

procedure TfrmLog.btnClearClick(Sender: TObject);
begin
  Logger.Clear;
  memLog.Clear;
  Caption := 'Log Viewer - 0 entries';
end;

procedure TfrmLog.btnCopyClick(Sender: TObject);
begin
  Clipboard.AsText := memLog.Text;
end;

procedure TfrmLog.btnSaveClick(Sender: TObject);
begin
  if dlgSaveFile.Execute then
  begin
    try
      memLog.Lines.SaveToFile(dlgSaveFile.FileName);
    except
      on E: Exception do
        ShowMessage('Error saving file: ' + E.Message);
    end;
  end;
end;

procedure TfrmLog.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
