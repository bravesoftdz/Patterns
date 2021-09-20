unit fmPreviewPatterns;

interface

uses
  RLFilters, RLPDFFilter, RLReport,  ServerModule, krUtil,
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, fmFormPatterns, uniBitBtn, uniButton, uniPanel,
  uniGUIBaseClasses, uniURLFrame, Menus, uniMainMenu, uniMenuButton,
  RLXLSXFilter, RLHTMLFilter, RLRichFilter, RLPreviewForm;

type
  TfrmPreviewPatterns = class(TfrmFormPatterns)
    UniURLFrame1: TUniURLFrame;
    UniPanel1: TUniPanel;
    btClose: TUniBitBtn;
    UniPopupMenu1: TUniPopupMenu;
    mnXLS: TUniMenuItem;
    mnXLSX: TUniMenuItem;
    UniPanel2: TUniPanel;
    UniMenuButton1: TUniMenuButton;
    mnHTML: TUniMenuItem;
    mnRTF: TUniMenuItem;
    procedure btCloseClick(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure mnXLSClick(Sender: TObject);
    procedure mnXLSXClick(Sender: TObject);
    procedure mnHTMLClick(Sender: TObject);
    procedure mnRTFClick(Sender: TObject);
  private
    RLReport01:TRLReport;
    FRLReport: TRLReport;
    FTitle: string;
    procedure SetRLReport(const Value: TRLReport);
    procedure SetTitle(const Value: string);
    { Private declarations }
  public
    procedure GerarPDF(Button:TUniBitBtn; Ext:String='.pdf');
    property RLReport:TRLReport read FRLReport write SetRLReport;
    property Title   :string    read FTitle    write SetTitle;
    { Public declarations }
  end;

function frmPreviewPatterns: TfrmPreviewPatterns;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function frmPreviewPatterns: TfrmPreviewPatterns;
begin
  Result := TfrmPreviewPatterns(UniMainModule.GetFormInstance(TfrmPreviewPatterns));
end;

procedure TfrmPreviewPatterns.btCloseClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmPreviewPatterns.GerarPDF(Button:TUniBitBtn; Ext:String='.pdf');
Var
  aFilename:String;
  URL      :String;
  RLRichFilter:TRLRichFilter;
  RLPDFFilter:TRLPDFFilter;
  RLHTMLFilter:TRLHTMLFilter;
Begin
  Button.Enabled := False;
  aFilename:=UniServerModule.LocalCachePath + GerarNomeArquivo + Ext;
  URL:='http://'+uniGUIApplication.UniSession.Host+'/'+UniServerModule.LocalCacheURL;
  //
  Try
    Try
      if Uppercase(Ext) = '.PDF' then
      Begin
        RLPDFFilter:=TRLPDFFilter.Create(self);
        RLPDFFilter.DocumentInfo.Clear;
        RLPDFFilter.DocumentInfo.Title  := Title;
        RLPDFFilter.DocumentInfo.Author := 'Jairo dos Santos Gurgel';
        RLPDFFilter.DocumentInfo.Creator:= 'Polícia Civil do Ceará';
        RLPDFFilter.FileName            := aFilename;
      End;
      if Uppercase(Ext) = '.HTM' then
      Begin
        RLHTMLFilter:=TRLHTMLFilter.Create(self);
        RLHTMLFilter.FileName            := aFilename;
      End;
      if Uppercase(Ext) = '.RTF' then
      Begin
        RLRichFilter:=TRLRichFilter.Create(self);
        RLRichFilter.FileName            := aFilename;
      End;
      //
      RLReport.ShowProgress       := false;
      RLReport.PrintDialog        := false;
      RLReport.ShowTracks         := false;

      RLReport.SaveToFile(aFilename);
    Finally
      if Uppercase(Ext) = '.PDF' then   FreeAndNil(RLPDFFilter);
      if Uppercase(Ext) = '.HTML' then  FreeAndNil(RLHTMLFilter);
      if Uppercase(Ext) = '.RTF' then   FreeAndNil(RLRichFilter);
    End;
  Except
    Button.Enabled := True;
  End;
  if (FileExists(aFilename)) and (Ext = '.pdf')  then
    UniURLFrame1.URL := URL + ExtractFileName(aFilename);
  Show();
  Button.Enabled := True;
End;

procedure TfrmPreviewPatterns.mnHTMLClick(Sender: TObject);
begin
  inherited;
  GerarPDF(btClose, '.htm');
end;

procedure TfrmPreviewPatterns.mnRTFClick(Sender: TObject);
begin
  inherited;
  GerarPDF(btClose, '.rtf');
end;

procedure TfrmPreviewPatterns.mnXLSClick(Sender: TObject);
begin
  inherited;
  GerarPDF(btClose, '.xls');
end;

procedure TfrmPreviewPatterns.mnXLSXClick(Sender: TObject);
begin
  inherited;
  GerarPDF(btClose, '.xlsx');
end;

procedure TfrmPreviewPatterns.SetRLReport(const Value: TRLReport);
begin
  FRLReport := Value;
end;

procedure TfrmPreviewPatterns.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TfrmPreviewPatterns.UniFormShow(Sender: TObject);
begin
  inherited;
  WindowState := wsMaximized;
  Width       := Screen.Width;
end;

end.
{
Verônica
//7411 -> Vanessa DPM
}
