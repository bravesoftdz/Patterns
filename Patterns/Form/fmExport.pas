unit fmExport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, DB,
  Dialogs, uniGUITypes, uniGUIAbstractClasses, uniProgressBar, ZDataset, QExport4,
  uniGUIClasses, uniGUIForm, QExport4XLS, ZAbstractRODataset, ZAbstractDataset,
  QExport4PDF, uniGUIBaseClasses, uniButton, uniBitBtn, uniPanel, QExport4ODS,
  QExport4ASCII,
  QExport4Xlsx;

type
  TfrmExport = class(TUniForm)
    dqrMain: TZQuery;
    ddsMain: TDataSource;
    btXLS: TUniBitBtn;
    btODS: TUniBitBtn;
    btPDF: TUniBitBtn;
    UniPanel1: TUniPanel;
    UniBitBtn4: TUniBitBtn;
    btCSV: TUniBitBtn;
    UniProgressBar1: TUniProgressBar;
    QExport4PDF1: TQExport4PDF;
    QExport4ASCII1: TQExport4ASCII;
    QExport4ODS1: TQExport4ODS;
    QExport4XLS1: TQExport4Xlsx;
    procedure btXLSClick(Sender: TObject);
    procedure btPDFClick(Sender: TObject);
    procedure btODSClick(Sender: TObject);
    procedure btCSVClick(Sender: TObject);
    procedure UniBitBtn4Click(Sender: TObject);
    //
    procedure BeginExport(Sender: TObject);
    procedure EndExport(Sender: TObject);
   procedure ExportedRecord(Sender: TObject; RecNo: Integer);
    procedure QExport4PDF1EndExport(Sender: TObject);
  private
    fFileName : String;
    function GerarArquivo(Ext: String): String;
    procedure DownloadFile;
    { Private declarations }
  public
    { Public declarations }
  end;

function frmExport: TfrmExport;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, ServerModule;

////////////////////////////////////////////////////////////////////////////////
function GeraChave(Tamanho: Integer): String;
var
  I    : Integer;
  Chave: String;
Const
  str = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
Begin
  Chave := '';
  for I := 1 to Tamanho do
    Chave := Chave + str[Random(Length(str)) + 1];
  Result := Chave;
end;

function TfrmExport.GerarArquivo(Ext:String):String;
Begin
  fFileName := 'Lista-' + GeraChave(3) + '.' + Ext;
  While FileExists(Result) do
    fFileName := 'Lista-' + GeraChave(3) + '.' + Ext;
  fFileName := UniServerModule.LocalCachePath + fFileName;
  Result := fFileName;
end;

procedure TfrmExport.QExport4PDF1EndExport(Sender: TObject);
Begin
  UniProgressBar1.Position := 0;
  UniProgressBar1.Visible  := False;
end;

procedure TfrmExport.ExportedRecord(Sender: TObject;
  RecNo: Integer);
Begin
  UniProgressBar1.Position :=RecNo;
end;

procedure TfrmExport.DownloadFile;
Begin
  UniSession.SendFile(fFileName);
End;

Procedure TfrmExport.BeginExport(Sender: TObject);
Begin
  UniProgressBar1.Position:= 0;
  UniProgressBar1.Max     := dqrMain.RecordCount;
  UniProgressBar1.Visible := True;
End;

procedure TfrmExport.EndExport(Sender: TObject);
begin
  UniProgressBar1.Position := 0;
  UniProgressBar1.Visible  := False;
  DownloadFile;
end;
////////////////////////////////////////////////////////////////////////////////
function frmExport: TfrmExport;
begin
  Result := TfrmExport(UniMainModule.GetFormInstance(TfrmExport));
end;

procedure TfrmExport.UniBitBtn4Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmExport.btCSVClick(Sender: TObject);
begin
  QExport4ASCII1.FileName := GerarArquivo('csv');
  QExport4ASCII1.Execute;
end;

procedure TfrmExport.btODSClick(Sender: TObject);
begin
  QExport4ODS1.FileName := GerarArquivo('ods');
  QExport4ODS1.Execute;
end;

procedure TfrmExport.btPDFClick(Sender: TObject);
begin
  QExport4PDF1.FileName := GerarArquivo('pdf');
  QExport4PDF1.Execute;
end;

procedure TfrmExport.btXLSClick(Sender: TObject);
begin
  QExport4XLS1.FileName := GerarArquivo('xls');
  QExport4XLS1.Execute;
end;

end.
