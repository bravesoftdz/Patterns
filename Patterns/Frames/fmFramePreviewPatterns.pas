unit fmFramePreviewPatterns;

interface

uses
  krUtil,
  RLReport, uniTabControl, uniPageControl, uniGUIApplication,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmFramePatterns, Menus, uniMainMenu, uniURLFrame, uniMenuButton,
  uniButton, uniBitBtn, uniGUIBaseClasses, uniGUIClasses, uniPanel,
  RLXLSXFilter, RLXLSFilter, RLPDFFilter, RLHTMLFilter, RLFilters, RLRichFilter;

type
  TfrmFramePreviewPatterns = class(TfrmFramePatterns)
    UniPanel1: TUniPanel;
    btClose: TUniBitBtn;
    UniPanel2: TUniPanel;
    UniMenuButton1: TUniMenuButton;
    UniURLFrame1: TUniURLFrame;
    UniPopupMenu1: TUniPopupMenu;
    mnXLS: TUniMenuItem;
    mnXLSX: TUniMenuItem;
    mnHTML: TUniMenuItem;
    mnRTF: TUniMenuItem;
    procedure btCloseClick(Sender: TObject);
    procedure mnHTMLClick(Sender: TObject);
    procedure mnRTFClick(Sender: TObject);
    procedure mnXLSClick(Sender: TObject);
    procedure mnXLSXClick(Sender: TObject);
    procedure UniFrameCreate(Sender: TObject);
  private
    { Private declarations }
    RLReport01:TRLReport;
    FRLReport: TRLReport;
    FTitle: string;
    procedure SetRLReport(const Value: TRLReport);
    procedure SetTitle(const Value: string);
  public
    { Public declarations }
    procedure GerarPDF(Button:TUniBitBtn; Ext:String='.pdf'); overload;
    procedure GerarPDF(Ext:String='.pdf'); overload;
    procedure GerarPDF(fFilename:String; Ext:String='.pdf'); overload;
    property RLReport:TRLReport read FRLReport write SetRLReport;
    property Title   :string    read FTitle    write SetTitle;
  end;

var
  frmFramePreviewPatterns: TfrmFramePreviewPatterns;

implementation

uses ServerModule;

{$R *.dfm}
function BackSlashed(const aFolder:string):string;
Const
  DirectorySeparator = '\';
var
  L:Integer;
begin
  Result := aFolder;
  L := Length(Result);
  if L > 0 then
    if Result[L] <> DirectorySeparator then
      Result:= Result + DirectorySeparator;
end;

procedure TfrmFramePreviewPatterns.btCloseClick(Sender: TObject);
begin
  inherited;
  TUniTabSheet(Self.Parent).Destroy;
end;

procedure TfrmFramePreviewPatterns.GerarPDF(Button:TUniBitBtn; Ext:String='.pdf');
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

procedure TfrmFramePreviewPatterns.GerarPDF(Ext:String='.pdf');
Var
  aFilename:String;
  URL      :String;
  RLRichFilter:TRLRichFilter;
  RLPDFFilter:TRLPDFFilter;
  RLHTMLFilter:TRLHTMLFilter;
Begin
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
    //Button.Enabled := True;
  End;
  if (FileExists(aFilename)) and (Ext = '.pdf')  then
    UniURLFrame1.URL := URL + ExtractFileName(aFilename);
  Show();
  //Button.Enabled := True;
End;

procedure TfrmFramePreviewPatterns.GerarPDF(fFilename:String; Ext:String='.pdf');
Var
  aFilename:String;
  URL      :String;
  RLRichFilter:TRLRichFilter;
  RLPDFFilter:TRLPDFFilter;
  RLHTMLFilter:TRLHTMLFilter;
  DirTemp:String;
Begin
  DirTemp := UniServerModule.NewCacheFolder;
  aFilename:= BackSlashed(DirTemp) + fFilename + Ext;
  DirTemp := TokenN(DirTemp, CountToken(DirTemp, '\'), '\');
  URL:='http://'+uniGUIApplication.UniSession.Host+'/'+UniServerModule.LocalCacheURL+DirTemp+'/';
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
    //Button.Enabled := True;
  End;
  if (FileExists(aFilename)) and (Ext = '.pdf')  then
    UniURLFrame1.URL := URL + ExtractFileName(aFilename);
  Show();
  //Button.Enabled := True;
End;


procedure TfrmFramePreviewPatterns.mnHTMLClick(Sender: TObject);
begin
  inherited;
  GerarPDF(btClose, '.htm');
end;

procedure TfrmFramePreviewPatterns.mnRTFClick(Sender: TObject);
begin
  inherited;
  GerarPDF(btClose, '.rtf');
end;

procedure TfrmFramePreviewPatterns.mnXLSClick(Sender: TObject);
begin
  inherited;
  GerarPDF(btClose, '.xls');
end;

procedure TfrmFramePreviewPatterns.mnXLSXClick(Sender: TObject);
begin
  inherited;
  GerarPDF(btClose, '.xlsx');
end;

procedure TfrmFramePreviewPatterns.SetRLReport(const Value: TRLReport);
begin
  FRLReport := Value;
end;

procedure TfrmFramePreviewPatterns.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TfrmFramePreviewPatterns.UniFrameCreate(Sender: TObject);
begin
  inherited;
//  WindowState := wsMaximized;
//  Width       := Screen.Width;
end;

end.
