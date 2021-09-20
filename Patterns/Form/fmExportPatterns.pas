unit fmExportPatterns;

interface

uses
  fmFormPatterns,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, DB,
  Dialogs, uniGUITypes, uniGUIAbstractClasses, uniProgressBar, ZDataset, QExport4,
  uniGUIClasses, uniGUIForm, QExport4XLS, ZAbstractRODataset, ZAbstractDataset,
  QExport4PDF, uniGUIBaseClasses, uniButton, uniBitBtn, uniPanel, QExport4ODS,
  QExport4ASCII,
  QExport4Xlsx, QExport4RTF;

type
  TfrmExportPatterns = class(TfrmFormPatterns)
    ddsMain: TDataSource;
    btXLS: TUniBitBtn;
    btODS: TUniBitBtn;
    bt4PDF: TUniBitBtn;
    UniPanel1: TUniPanel;
    UniBitBtn4: TUniBitBtn;
    btCSV: TUniBitBtn;
    UniProgressBar1: TUniProgressBar;
    dqrMain: TZQuery;
    QExport4XLS1: TQExport4XLS;
    QExport4RTF1: TQExport4RTF;
    QExport4PDF1: TQExport4PDF;
    QExport4ODS1: TQExport4ODS;
    QExport4ASCII1: TQExport4ASCII;
    procedure btXLSClick(Sender: TObject);
    procedure bt4PDFClick(Sender: TObject);
    procedure btODSClick(Sender: TObject);
    procedure btCSVClick(Sender: TObject);
    procedure UniBitBtn4Click(Sender: TObject);
    //
    procedure BeginExport(Sender: TObject);
    procedure EndExport(Sender: TObject);
   procedure ExportedRecord(Sender: TObject; RecNo: Integer);
    procedure QExport4PDF1EndExport(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
  private
    fFileName : String;
    FDataSet: TDataSet;
    function GerarArquivo(Ext: String): String;
    procedure DownloadFile;
    procedure SetDataSet(const Value: TDataSet);
    procedure SetFilename(const Value: String);
    { Private declarations }
  public
    Property DataSet :TDataSet read FDataSet  write SetDataSet;
    Property Filename:String   read FFilename write SetFilename;
    { Public declarations }
  end;

function frmExportPatterns: TfrmExportPatterns;

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

function TfrmExportPatterns.GerarArquivo(Ext:String):String;
Begin
  fFileName := 'Lista-' + GeraChave(3) + '.' + Ext;
  While FileExists(Result) do
    fFileName := 'Lista-' + GeraChave(3) + '.' + Ext;
  fFileName := UniServerModule.LocalCachePath + fFileName;
  Result := fFileName;
end;

procedure TfrmExportPatterns.QExport4PDF1EndExport(Sender: TObject);
Begin
  UniProgressBar1.Position := 0;
  UniProgressBar1.Visible  := False;
end;

procedure TfrmExportPatterns.SetDataSet(const Value: TDataSet);
begin
  FDataSet := Value;
  if Assigned(Value) then
  Begin
    QExport4XLS1.DataSet   := Value;
    QExport4ODS1.DataSet   := Value;
    QExport4PDF1.DataSet   := Value;
    QExport4ASCII1.DataSet := Value;
    ddsMain.DataSet        := Value;
  End;
end;

procedure TfrmExportPatterns.SetFilename(const Value: String);
begin
  FFilename := Value;
end;

procedure TfrmExportPatterns.ExportedRecord(Sender: TObject;
  RecNo: Integer);
Begin
  UniProgressBar1.Position :=RecNo;
end;

procedure TfrmExportPatterns.DownloadFile;
Begin
  UniSession.SendFile(fFileName);
End;

Procedure TfrmExportPatterns.BeginExport(Sender: TObject);
Begin
  UniProgressBar1.Position:= 0;
  UniProgressBar1.Max     := DataSet.RecordCount;
  UniProgressBar1.Visible := True;
End;

procedure TfrmExportPatterns.EndExport(Sender: TObject);
begin
  UniProgressBar1.Position := 0;
  UniProgressBar1.Visible  := False;
  DownloadFile;
end;
////////////////////////////////////////////////////////////////////////////////
function frmExportPatterns: TfrmExportPatterns;
begin
  Result := TfrmExportPatterns(UniMainModule.GetFormInstance(TfrmExportPatterns));
end;

procedure TfrmExportPatterns.UniBitBtn4Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmExportPatterns.UniFormCreate(Sender: TObject);
begin
  FFilename :='';
end;

procedure TfrmExportPatterns.btCSVClick(Sender: TObject);
begin
  QExport4ASCII1.FileName := GerarArquivo('csv');
  if FFilename <> '' then QExport4ASCII1.FileName :=FFilename + ExtractFileExt(QExport4ASCII1.FileName);
  QExport4ASCII1.Execute;
end;

procedure TfrmExportPatterns.btODSClick(Sender: TObject);
begin
  QExport4ODS1.FileName := GerarArquivo('ods');
  if FFilename <> '' then QExport4ASCII1.FileName :=FFilename + ExtractFileExt(QExport4ASCII1.FileName);
  QExport4ODS1.Execute;
end;

procedure TfrmExportPatterns.bt4PDFClick(Sender: TObject);
begin
  QExport4PDF1.FileName := GerarArquivo('pdf');
  if FFilename <> '' then QExport4ASCII1.FileName :=FFilename + ExtractFileExt(QExport4ASCII1.FileName);
  QExport4PDF1.Execute;
end;

procedure TfrmExportPatterns.btXLSClick(Sender: TObject);
begin
  QExport4XLS1.FileName := GerarArquivo('xls');
  if FFilename <> '' then QExport4ASCII1.FileName :=FFilename + ExtractFileExt(QExport4ASCII1.FileName);
  QExport4XLS1.Execute;
end;

end.
