{ Última atualização 06/05/2004}
unit fmPreview;

interface

uses
  // Uses do Fortes Report
  RLFilters, RLDraftFilter, RLPreview, RLPDFFilter, RLHTMLFilter, RLRichFilter,
  RLReport, RLPreviewForm, RLXLSFilter, RLPrintDialog, RLSaveDialog, RLXLSXFilter,
  // Uses nativas do Delphi
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, Buttons, StdCtrls, DB;

type
  TNewRLReport=Class(TRLPreviewForm);
  TfrmPreview = class(TForm)
    StatusBar1: TStatusBar;
    RLPreview1: TRLPreview;
    RLDraftFilter1: TRLDraftFilter;
    PrinterSetupDialog1: TPrinterSetupDialog;
    PrintDialog1: TPrintDialog;
    SaveDialog1: TSaveDialog;
    RLXLSFilter1: TRLXLSFilter;
    RLPDFFilter1: TRLPDFFilter;
    RLHTMLFilter1: TRLHTMLFilter;
    RLRichFilter1: TRLRichFilter;
    PanelTools: TPanel;
    SpeedButtonPrint: TSpeedButton;
    SpeedButtonSetup: TSpeedButton;
    SpeedButtonFirst: TSpeedButton;
    SpeedButtonPrior: TSpeedButton;
    SpeedButtonNext: TSpeedButton;
    SpeedButtonLast: TSpeedButton;
    SpeedButtonZoomDown: TSpeedButton;
    SpeedButtonZoomUp: TSpeedButton;
    SpeedButtonClose: TSpeedButton;
    Bevel7: TBevel;
    Bevel8: TBevel;
    Bevel9: TBevel;
    Bevel10: TBevel;
    SpeedButtonSave: TSpeedButton;
    SpeedButtonViews: TSpeedButton;
    Bevel11: TBevel;
    SpeedButtonEdit: TSpeedButton;
    Bevel12: TBevel;
    PanelPages: TPanel;
    LabelPage: TLabel;
    LabelOf: TLabel;
    EditPageNo: TEdit;
    PanelPageCount: TPanel;
    PanelZoom: TPanel;
    ComboBoxZoom: TComboBox;
    PanelCopyright: TPanel;
    SpeedButtonCopyright: TImage;
    RLPreviewSetup1: TRLPreviewSetup;
    RLXLSXFilter1: TRLXLSXFilter;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButtonPrintClick(Sender: TObject);
    procedure SpeedButtonSaveClick(Sender: TObject);
    procedure SpeedButtonSetupClick(Sender: TObject);
    procedure SpeedButtonFirstClick(Sender: TObject);
    procedure SpeedButtonPriorClick(Sender: TObject);
    procedure EditPageNoExit(Sender: TObject);
    procedure EditPageNoKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButtonNextClick(Sender: TObject);
    procedure SpeedButtonLastClick(Sender: TObject);
    procedure SpeedButtonZoomDownClick(Sender: TObject);
    procedure SpeedButtonZoomUpClick(Sender: TObject);
    procedure ComboBoxZoomChange(Sender: TObject);
    procedure SpeedButtonViewsClick(Sender: TObject);
    procedure SpeedButtonEditClick(Sender: TObject);
    procedure SpeedButtonCloseClick(Sender: TObject);
    procedure EditPageNoChange(Sender: TObject);
  private
    fRLReport : TRLReport;
    fImagem   : Boolean;
    fHintImage: string;
    fTitle    : string;
    procedure SetRLReport(const Value: TRLReport);
    procedure SetImagem(const Value: Boolean);
    procedure SetHintImage(const Value: string);
    procedure SetTitle(const Value: string);
    procedure OnHint(Sender: TObject);
    { Private declarations }
  public
    property RLReport  :TRLReport read fRLReport  write SetRLReport   default nil;
    property Imagem    :Boolean   read fImagem    write SetImagem     default False;
    property HintImage :string    read fHintImage write SetHintImage;
    property Title     :string    read fTitle     write SetTitle;
    { Public declarations }
  end;

var
  frmPreview: TfrmPreview;
  SourceBuffer: PChar;
implementation

{$R *.dfm}
////////////////////////////////////////////////////////////////////////////////
function GetFieldStr(Field: TField): string;

function GetDig(i, j: Word): string;
begin
  Result := IntToStr(i);
  while (Length(Result) < j) do
    Result := '0' + Result;
end;

var Hour, Min, Sec, MSec: Word;
begin
  Case Field.DataType of
    ftBoolean: Result := UpperCase(Field.AsString);
    ftDate: Result := FormatDateTime('yyyymmdd', Field.AsDateTime);
    ftTime: Result := FormatDateTime('hhnnss', Field.AsDateTime);
    ftDateTime: Begin
                  Result := FormatDateTime('yyyymmdd', Field.AsDateTime);
                  DecodeTime(Field.AsDateTime, Hour, Min, Sec, MSec);
                  if (Hour <> 0) or (Min <> 0) or (Sec <> 0) or (MSec <> 0) then
                    Result := Result + 'T' + GetDig(Hour, 2) + ':' + GetDig(Min, 2) + ':' + GetDig(Sec, 2) + GetDig(MSec, 3);
                end;
  else
    Result := Field.AsString;
  end;
end;

procedure WriteString(Stream: TFileStream; s: string);
begin
  StrPCopy(SourceBuffer, s);
  Stream.Write(SourceBuffer[0], StrLen(SourceBuffer));
end;

procedure WriteFileEnd(Stream: TFileStream);
begin
  WriteString(Stream, '</ROWDATA></DATAPACKET>');
end;

procedure WriteRowStart(Stream: TFileStream; IsAddedTitle: Boolean);
begin
  if not IsAddedTitle then
    WriteString(Stream, '<ROW');
end;

procedure WriteRowEnd(Stream: TFileStream; IsAddedTitle: Boolean);
begin
  if not IsAddedTitle then
    WriteString(Stream, '/>');
end;

procedure WriteData(Stream: TFileStream; fld: TField; AString: ShortString);
begin
  if Assigned(fld) and (AString <> '') then
    WriteString(Stream, ' ' + fld.FieldName + '="' + AString + '"');
end;

procedure WriteFileBegin(Stream: TFileStream; Dataset: TDataset);

  function XMLFieldType(fld: TField): string;
  begin
    Case fld.DataType of
      ftString  : Result := '"string" WIDTH="' + IntToStr(fld.Size) + '"';
      ftSmallint: Result := '"i4"'; //??
      ftInteger : Result := '"i4"';
      ftWord    : Result := '"i4"'; //??
      ftBoolean : Result := '"boolean"';
      ftAutoInc : Result := '"i4" SUBTYPE="Autoinc"';
      ftFloat   : Result := '"r8"';
      ftCurrency: Result := '"r8" SUBTYPE="Money"';
      ftBCD     : Result := '"r8"'; //??
      ftDate    : Result := '"date"';
      ftTime    : Result := '"time"'; //??
      ftDateTime: Result := '"datetime"';
    else
    end;
    if fld.Required then
      Result := Result + ' required="true"';
    if fld.Readonly then
      Result := Result + ' readonly="true"';
  end;

var
  i: Integer;

begin
  WriteString(Stream, '<?xml version="1.0" standalone="yes"?><!-- Generated by SMExport -->  ' +
                      '<DATAPACKET Version="2.0">');
  WriteString(Stream, '<METADATA><FIELDS>');

  {write th metadata}
  with Dataset do
    for i := 0 to FieldCount-1 do
    begin
      WriteString(Stream, '<FIELD attrname="' +
                          Fields[i].FieldName +
                          '" fieldtype=' +
                          XMLFieldType(Fields[i]) +
                          '/>');
    end;
  WriteString(Stream, '</FIELDS>');
  WriteString(Stream, '<PARAMS DEFAULT_ORDER="1" PRIMARY_KEY="1" LCID="1033"/>');
  WriteString(Stream, '</METADATA><ROWDATA>');
end;

procedure DatasetToXML(Dataset: TDataset; FileName: string);
var
  Stream: TFileStream;
  bkmark: TBookmark;
  i: Integer;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  SourceBuffer := StrAlloc(1024);
  WriteFileBegin(Stream, Dataset);

  with DataSet do
  begin
    DisableControls;
    bkmark := GetBookmark;
    First;

    {write a title row}
    WriteRowStart(Stream, True);
    for i := 0 to FieldCount-1 do
      WriteData(Stream, nil, Fields[i].DisplayLabel);
    {write the end of row}
    WriteRowEnd(Stream, True);

    while (not EOF) do
    begin
      WriteRowStart(Stream, False);
      for i := 0 to FieldCount-1 do
        WriteData(Stream, Fields[i], GetFieldStr(Fields[i]));
      {write the end of row}
      WriteRowEnd(Stream, False);
      Next;
    end;
    GotoBookmark(bkmark);
    EnableControls;
  end;
  WriteFileEnd(Stream);
  Stream.Free;
  StrDispose(SourceBuffer);
end;

procedure ExportToCSV( DataSet : TDataSet; Filename: string; Delimitador : char = ';');
var f : TextFile;
    n : Integer;
    LineStr  : string;
begin
  AssignFile(f,Filename); Rewrite(f);
  With DataSet do begin
    DisableControls;
    First;
    While Not Eof do begin
      LineStr := '';
      for n := 0 to FieldCount-1 do begin
         If Fields[n].IsNull Then Begin
            LineStr := LineStr + Delimitador;
         end else Begin
           Case FieldDefs.Items[n].DataType of
             ftDate     : LineStr := LineStr + Delimitador + '"'+Fields[n].AsString+'"';
             ftTime     : LineStr := LineStr + Delimitador + '"'+Fields[n].AsString+'"';
             ftDateTime : LineStr := LineStr + Delimitador + '"'+Fields[n].AsString+'"';
             ftString   : LineStr := LineStr + Delimitador + '"'+Fields[n].AsString+'"';
             ftSmallint : LineStr := LineStr + Delimitador + Fields[n].AsString;
             ftInteger  : LineStr := LineStr + Delimitador + Fields[n].AsString;
             ftWord     : LineStr := LineStr + Delimitador + Fields[n].AsString;
             ftBoolean  : LineStr := LineStr + Delimitador + Fields[n].AsString;
             ftFloat    : LineStr := LineStr + Delimitador + Fields[n].AsString;
             ftCurrency : LineStr := LineStr + Delimitador + Fields[n].AsString;
             ftBCD      : LineStr := LineStr + Delimitador + Fields[n].AsString;
             ftBytes    : LineStr := LineStr + Delimitador + Fields[n].AsString;
             ftMemo     : LineStr := LineStr + Delimitador + Fields[n].AsString;
           else           LineStr := LineStr + Delimitador;
           end;
         End;
      End;
      Writeln(f,Copy(LineStr,2,Length(LineStr)-1));
      Next;
    end;
    EnableControls;
  end;
  CloseFile(f);
end;
////////////////////////////////////////////////////////////////////////////////
function Floor(const X: Extended): Integer;
begin
  Result := Integer(Trunc(X));
  if Frac(X) < 0 then
    Dec(Result);
end;

procedure TfrmPreview.SetRLReport(const Value: TRLReport);
begin
  if Value<>nil then
  begin
    fRLReport := Value;
    fRLReport.PreviewOptions.Defaults:=pdIgnoreDefaults;
    fRLReport.PreviewOptions.ShowModal:=true;
    fRLReport.Preview(RLPreview1);
    PanelPageCount.Caption:=IntToStr(RLPreview1.Pages.LastPageNumber);
    EditPageNo.MaxLength:=Length(PanelPageCount.Caption);
    ShowModal;
  end;
end;

procedure TfrmPreview.FormShow(Sender: TObject);
begin
  ComboBoxZoom.Text:=IntToStr(Floor(RLPreview1.ZoomFactor))+'%';
end;

procedure TfrmPreview.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#27 then Close;
end;

procedure TfrmPreview.SetImagem(const Value: Boolean);
begin
  if Value<>null then
  begin
    FImagem := Value;
    SpeedButtonCopyright.Visible:=FImagem;
  end;
end;

procedure TfrmPreview.SetHintImage(const Value: string);
begin
  fHintImage := Value;
  SpeedButtonCopyright.Hint:=fHintImage;
end;

procedure TfrmPreview.SetTitle(const Value: string);
begin
  if Value<>'' then
  begin
    fTitle := Value;
    Caption:=fTitle;
  end;
end;

procedure TfrmPreview.OnHint(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := GetLongHint(Application.Hint);
end;

procedure TfrmPreview.FormCreate(Sender: TObject);
begin
  Application.OnHint:=OnHint;
  Title:='Pré-Visualização';
end;

procedure TfrmPreview.FormDestroy(Sender: TObject);
begin
  Application.OnHint:=nil;
end;

procedure TfrmPreview.SpeedButtonPrintClick(Sender: TObject);
begin
  RLReport.Print;
end;

procedure TfrmPreview.SpeedButtonSaveClick(Sender: TObject);
Var
  Ext:String;
begin
  SaveDialog1.InitialDir:=ExtractFilePath(ParamStr(0));
  if SaveDialog1.Execute then
  begin
    Case SaveDialog1.FilterIndex of
      1:Ext:='.pdf';
      2:Ext:='.xls';
      3:Ext:='.htm';
      4:Ext:='.rtf';
      5:Ext:='.xml';
      6:Ext:='.csv';
    end;
    if SaveDialog1.FilterIndex in [1..4] then
      RLReport.SaveToFile(ChangeFileExt(SaveDialog1.FileName, Ext));
    if SaveDialog1.FilterIndex in [5..6] then
    begin
      Case SaveDialog1.FilterIndex of
        5:DatasetToXML(RLReport.DataSource.DataSet,ChangeFileExt(SaveDialog1.FileName,Ext));
        6:ExportToCSV(RLReport.DataSource.DataSet,ChangeFileExt(SaveDialog1.FileName,Ext));
      end;
    end;
  end;
end;

procedure TfrmPreview.SpeedButtonSetupClick(Sender: TObject);
begin
  PrinterSetupDialog1.Execute;
end;

procedure TfrmPreview.SpeedButtonFirstClick(Sender: TObject);
begin
  RLPreview1.FirstPage;
  EditPageNo.Text:=IntToStr(RLPreview1.PageNumber);
end;

procedure TfrmPreview.SpeedButtonPriorClick(Sender: TObject);
begin
  RLPreview1.PriorPage;
  EditPageNo.Text:=IntToStr(RLPreview1.PageNumber);
end;

procedure TfrmPreview.EditPageNoExit(Sender: TObject);
begin
  if (EditPageNo.Text='') or (EditPageNo.Text='0') then
    EditPageNo.Text:='1';
  if StrToInt(EditPageNo.Text)> StrToInt(EditPageNo.Text) then
    EditPageNo.Text:=EditPageNo.Text;
  RLPreview1.PageNumber:=StrToInt(EditPageNo.Text);
end;

procedure TfrmPreview.EditPageNoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
    ComboBoxZoomChange(Self)
  else
    if not (Key in ['0'..'9',#8]) then
      key:=#0;
end;

procedure TfrmPreview.SpeedButtonNextClick(Sender: TObject);
begin
  RLPreview1.NextPage;
  EditPageNo.Text:=IntToStr(RLPreview1.PageNumber);
end;

procedure TfrmPreview.SpeedButtonLastClick(Sender: TObject);
begin
  RLPreview1.LastPage;
  EditPageNo.Text:=IntToStr(RLPreview1.PageNumber);
end;

procedure TfrmPreview.SpeedButtonZoomDownClick(Sender: TObject);
begin
  RLPreview1.ZoomFactor:=RLPreview1.ZoomFactor-10;
  ComboBoxZoom.Text:=IntToStr(Floor(RLPreview1.ZoomFactor))+'%';
end;

procedure TfrmPreview.SpeedButtonZoomUpClick(Sender: TObject);
begin
  RLPreview1.ZoomFactor:=RLPreview1.ZoomFactor+10;
  ComboBoxZoom.Text:=IntToStr(Floor(RLPreview1.ZoomFactor))+'%';
end;

procedure TfrmPreview.ComboBoxZoomChange(Sender: TObject);
Var
 Zoom: Integer;
 Str : string;
begin
  Str:=ComboBoxZoom.Text;
  Zoom:=0;
  if Length(Str)>0 then
  begin
    if Str='Largura da página' then
      RLPreview1.ZoomFullWidth
    else
      if Str='Página inteira' then
        RLPreview1.ZoomFullPage
      else
        if Str='Várias páginas' then
          RLPreview1.ZoomMultiplePages
        else
          if Str[Length(Str)]='%' then
            Zoom:=StrToInt(Copy(Str,1, Length(Str)-1))
          else
             StrToInt(Str);
    if Zoom>500 then
      Zoom:=500;
    if Zoom<>0 then
      RLPreview1.ZoomFactor:=Zoom;
  end;
end;

procedure TfrmPreview.SpeedButtonViewsClick(Sender: TObject);
begin
  RLPreview1.MultipleMode:=NOt RLPreview1.MultipleMode;
end;

procedure TfrmPreview.SpeedButtonEditClick(Sender: TObject);
begin
  SpeedButtonEdit.AllowAllUp := True;
  SpeedButtonEdit.GroupIndex := 1;
  RLPreview1.Editing         := not RLPreview1.Editing;
  SpeedButtonEdit.Down       := RLPreview1.Editing;
end;

procedure TfrmPreview.SpeedButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPreview.EditPageNoChange(Sender: TObject);
begin
  if (EditPageNo.Text<>'') and (StrToInt(EditPageNo.Text)>StrToInt(PanelPageCount.Caption)) then
    EditPageNo.Text:=PanelPageCount.Caption;
end;

end.
