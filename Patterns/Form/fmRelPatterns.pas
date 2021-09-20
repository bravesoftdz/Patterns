unit fmRelPatterns;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RLReport, pngimage;

type
  TfrmRelPatterns = class(TForm)
    RLReport1: TRLReport;
    RLBand1: TRLBand;
    RLBand2: TRLBand;
    rlData: TRLSystemInfo;
    pnlTitle: TRLPanel;
    imgBrasao: TRLImage;
    lblTitle: TRLLabel;
    procedure rlDataBeforePrint(Sender: TObject; var AText: string;
      var PrintIt: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRelPatterns: TfrmRelPatterns;

implementation

{$R *.dfm}

procedure TfrmRelPatterns.rlDataBeforePrint(Sender: TObject; var AText: string;
  var PrintIt: Boolean);
begin
  aText:=AText + FormatDateTime('  hh:mm:ss', Now);
end;

end.
