unit FormAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmAbout = class(TForm)
    pnlMain: TPanel;
    lblTitle: TLabel;
    lblVersion: TLabel;
    lblDescription: TLabel;
    lblCopyright: TLabel;
    btnOK: TButton;
    imgIcon: TImage;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

procedure TfrmAbout.btnOKClick(Sender: TObject);
begin
  Close;
end;

end.
