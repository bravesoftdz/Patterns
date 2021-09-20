{
@abstract(Kernel de funções úteis para sistemas.)
@author(Analista / Programador : Jairo dos Santos Gurgel <jsgurgel@hotmail.com>)
@created(2017)
@lastmod(24/04/2017)
}
unit UniKrUtil;

interface

Uses
  // ShlObj, WinSock, ShellApi, IdBaseComponent, IdComponent, IdRawBase, IdRawClient, IdIcmpClient,
  // DB,  DbCtrls,
  krUtil, KrXLSExport, IniFiles,
  StdCtrls,Graphics, ComCtrls, Windows, Classes, SysUtils,
  DateUtils, Forms, Controls, Types, ExtCtrls, Dialogs, DB,
  //
  ServerModule,
  uniGUIApplication, uniGUIRegClasses, UniGUIDialogs, uniGUIServer,
  uniGUIMainModule, uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm,
  uniGUIBaseClasses,
  //
  Menus, uniMainMenu, uniPageControl,
  UniDBEdit, UniEdit, UniDBLookupComboBox, UniDBMemo, UniDBListBox, UniDBComboBox,
  UniDBGrid, UniCheckBox, UniSpeedButton, UniDBCheckBox, UniDBDateTimePicker,
  UniGroupBox, UniBitBtn, UniComboBox, UniDateTimePicker, uniGUIFrame;

type
  TPlatform = (iPhone, iOS, Android, Phone, Desktop, Tablet, Mobile);

  procedure HabilitarMenu(Menu: TUniMainMenu; Visible:Boolean=False);
  function UsuarioLogado:String;    // retorna o nome do usuário logado no sistema
  function UsuarioDoSistema:String;
  function IPCliente:string;        // Retorna o IP do cliente
  function Inf: String;             // Retorna informações do cliente
  function IPServidor: String;      // Retorna o IP do Servidor
  function PathCache:String;        // Retorna o diretório do Cache do servidor
  function HomeDir: String;         // Retorna o diretório do binário que está no servidor
  function WhatPlatform:TPlatform;  // Indica qual a plataforma do Sistema Operacional
  function IsDesktop:Boolean;       // Informa se e um Desktop
  function IsMobile:Boolean;        // Informa se e um Smartphone
  Function WhatBrowser:String;      // Retorna qual o Navegador utilizado pelo cliente
  procedure AbilitarControls(fHWND:TUniForm; fActive:Boolean=False); overload; // Abilita e desabilita os componentes no form
  procedure AbilitarControls(fHWND:TUniFrame; fActive:Boolean=False); overload;
  procedure ProcessMessages; // emula o Thread
  function BackSlashedWWW(const aFolder:string):string;
  function BackSlashed(const aFolder:string):string;

  // Dialogos
  function GerarFileTemp(aFilename, Ext:String):String;// gera um nome de arquivo temporário
  procedure Warning(Msg:String);
  procedure DisplayError(Msg: string); // Dialogo de erro
  procedure OpenURLWindow(URL:String);
  Procedure Alert(Value:String);
  procedure OpenURL(URL:String);

//  Procedure ExportToCSV(aDataset: TDataset; const Filename: String; const Separator: String = ';'); overload;
  Procedure ExportToCSV(aGrid: TUniDBGrid; const Filename: String; const Separator: String = ';');overload;
  Procedure ExportToXLS(aGrid: TUniDBGrid; const Filename: String);
//  procedure ExportToCSV(aServerModule:TUniServerModule; aGrid: TUniDBGrid)overload;
  Procedure ExportToCSV(aDataset: TDataset; const Filename: String; const Separator: String = ';'); overload;
  // Arquivo
  procedure DownloadFile(Filename:String);
  Function NewCacheFolder:String;
  Procedure JavaScript(JS:String);

  // Inicia os principais parâmetros do sistema
  Procedure IniciarSistema(WindowsStyle:Boolean=False; Porta:Integer=80);
  Procedure IniciarMainModule;
  Function IsFormCreated(UniPageControl:TUniPageControl; Name:String):Boolean;
  Procedure CriarForm(Name, Title:String; UniPageControl:TUniPageControl; fForm: TUniFrame); overload;
  Procedure CriarForm(Name, Title:String; UniPageControl:TUniPageControl; fForm: TUniForm); overload;
  Function BrowserType:String; // Retorna o nome do navegador
  Function OSType:String; // Retorna o nome do sistema operacional

Var
  UniApplicationTitle:String;

implementation
Uses MainModule;

Function BrowserType:String;
Var
  ClientInfo:TUniClientInfoRec;

Begin
  ClientInfo := UniApplication.ClientInfoRec;
  Result := ClientInfo.BrowserType;
End;

Function OSType:String;
Var
  ClientInfo:TUniClientInfoRec;

Begin
  ClientInfo := UniApplication.ClientInfoRec;
  Result := ClientInfo.OSType;
End;

function BackSlashedWWW(const aFolder:string):string;
Const
  DirectorySeparator = '/';
var
  L:Integer;
begin
  Result := aFolder;
  L := Length(Result);
  if L > 0 then
    if Result[L] <> DirectorySeparator then
      Result:= Result + DirectorySeparator;
end;

function BackSlashed(const aFolder:string):string;
Begin
  Result:= krUtil.BackSlashed(aFolder);
End;

Function IsFormCreated(UniPageControl:TUniPageControl; Name:String):Boolean;
Var
  I:Integer;
Begin
  Result:=False;
  for I  := 0 to UniPageControl.PageCount -1 do
    if UniPageControl.Pages[I].Name = Name then
    Begin
      Result :=True;
      Exit;
    End;
End;

Procedure CriarForm(Name, Title:String; UniPageControl:TUniPageControl; fForm: TUniFrame);
Var
  TabS : TUniTabSheet;

Function IsFormCreated(Name:String):TUniTabSheet;
Var
  I:Integer;
Begin
  Result:=nil;
  for I  := 0 to UniPageControl.PageCount -1 do
    if UniPageControl.Pages[I].Name = Name then
    Begin
      Result := UniPageControl.Pages[I];
      Exit;
    End;
End;

begin
  TabS := IsFormCreated(Name);
  if TabS = Nil  then
  Begin
    TabS             := TUniTabSheet.Create(UniPageControl);
    TabS.Caption     := Title;
    TabS.PageControl := UniPageControl;
    TabS.Name        := Name;
    TabS.Closable    := True;
    //
    fForm.Align      := alClient; // wsMaximized;
//    fForm.BorderStyle := bsSingle;
    fForm.Parent     := TabS;
    fForm.Show;
  end;
  UniPageControl.ActivePage := TabS;
End;

Procedure CriarForm(Name, Title:String; UniPageControl:TUniPageControl; fForm: TUniForm);
Var
  TabS : TUniTabSheet;

Function IsFormCreated(Name:String):TUniTabSheet;
Var
  I:Integer;
Begin
  Result:=nil;
  for I  := 0 to UniPageControl.PageCount -1 do
    if UniPageControl.Pages[I].Name = Name then
    Begin
      Result := UniPageControl.Pages[I];
      Exit;
    End;
End;

begin
  TabS := IsFormCreated(Name);
  if TabS = Nil  then
  Begin
    TabS             := TUniTabSheet.Create(UniPageControl);
    TabS.Caption     := Title;
    TabS.PageControl := UniPageControl;
    TabS.Name        := Name;
    TabS.Closable    := True;
    //
    fForm.WindowState:= wsMaximized;
    fForm.BorderStyle := bsSingle;
    fForm.Parent     := TabS;
    fForm.Show;
  end;
  UniPageControl.ActivePage := TabS;
End;

Function NewCacheFolder:String;
Begin
  Result := UniServerModule.NewCacheFolder;
End;

Procedure ExportToCSV(aDataset: TDataset; const Filename: String; const Separator: String = ';');
var
  sl: TStringList;
  s: String;
  i: Integer;
  bm: TBookmark;

Procedure ClipIt;
begin
  s := Copy(s, 1, Length(s) - Length(Separator));
  sl.Add(s);
  s := '';
end;

Function FixIt(const s: String): String;
begin
  Result := StringReplace(StringReplace(StringReplace(s, Separator, '', [rfReplaceAll]), #13, '', [rfReplaceAll]), #10, '', [rfReplaceAll]);
end;

begin
  sl := TStringList.Create;
  try
    s := '';
    For i := 0 to aDataset.FieldCount - 1 do
    begin
      if aDataset.Fields[i].Visible then
        s := s + FixIt(aDataset.Fields[i].DisplayLabel) + Separator;
    end;
    ClipIt;
    bm := aDataset.GetBookmark;
    aDataset.DisableControls;
    try
      aDataset.First;
      while not aDataset.Eof do
      begin
        For i := 0 to aDataset.FieldCount - 1 do
        begin
          if aDataset.Fields[i].Visible then
            s := s + FixIt(aDataset.Fields[i].DisplayText) + Separator;
        end;
        ClipIt;
        aDataset.Next;
      end;
      aDataset.GotoBookmark(bm);
    finally
      aDataset.EnableControls;
      aDataset.FreeBookmark(bm);
    end;
    sl.SaveToFile(Filename);
  finally
    FreeAndNil(sl);
  end;
end;

Procedure ExportToXLS(aGrid: TUniDBGrid; const Filename: String);
Begin
  if aGrid.DataSource.DataSet.Active then
    DataSetToXLS(aGrid.DataSource.DataSet, Filename);
End;

Procedure ExportToCSV(aGrid: TUniDBGrid; const Filename: String; const Separator: String = ';');
var
  sl: TStringList;
  s: String;
  i: Integer;
  bm: TBookmark;

Procedure ClipIt;
begin
  s := Copy(s, 1, Length(s) - Length(Separator));
  sl.Add(s);
  s := '';
end;

Function FixIt(const s: String): String;
begin
  Result := StringReplace(StringReplace(StringReplace(s, Separator, '', [rfReplaceAll]), #13, '', [rfReplaceAll]), #10, '', [rfReplaceAll]);
end;

begin
  sl := TStringList.Create;
  try
    s := '';
    For i := 0 to aGrid.Columns.Count - 1 do
      if aGrid.Columns.Items[I].Visible then
        s := s + FixIt(aGrid.Columns.Items[I].Title.Caption) + Separator;

    ClipIt;
    bm := aGrid.DataSource.DataSet.Bookmark;
    aGrid.DataSource.DataSet.DisableControls;
    try
      aGrid.DataSource.DataSet.First;
      while not aGrid.DataSource.DataSet.Eof do
      begin
        For i := 0 to aGrid.Columns.Count - 1 do
          if aGrid.Columns.Items[I].Visible then
            s := s + FixIt(aGrid.Columns.Items[I].Field.AsString) + Separator;
        ClipIt;
        aGrid.DataSource.DataSet.Next;
      end;
      aGrid.DataSource.DataSet.Bookmark := bm;
    finally
      aGrid.DataSource.DataSet.EnableControls;
      aGrid.DataSource.DataSet.FreeBookmark(bm);
    end;
    sl.SaveToFile(Filename);
  finally
    FreeAndNil(sl);
  end;
end;

{procedure ExportToCSV(aServerModule:TUniServerModule; aGrid: TUniDBGrid);
Var
  aFilename:String;
  DirTemp  :String;

begin
  DirTemp  := aServerModule.NewCacheFolder;
  aFilename:= BackSlashed(DirTemp) + 'Resultado';
  DirTemp  := TokenN(DirTemp, CountToken(DirTemp, '\'), '\');

  ExportToCSV(aGrid, ExtractFilePath(DirTemp)+aFilename);
  DownloadFile(aFilename);
end;}

procedure DownloadFile(FileName:String);
Begin
  UniApplication.UniSession.SendFile(FileName);
  //UniSession.SendFile(FileName);
End;

procedure ProcessMessages;
Begin
  if Application<>nil then
    Application.ProcessMessages;
end;

procedure HabilitarMenu(Menu: TUniMainMenu; Visible:Boolean=False);
{função chamada para adicionar itens ou subitens de forma recursiva}
procedure AdicionaSubItens(mS, mI : TMenuItem);
var
  j,p: integer;//j= usado no for - p= guarda posiçao
  a,b,c2: string;//guarda valores de texto a serem adicionados na Tree

begin
  for j := 0 to mI.Count - 1 do
  begin
    {pega os itens do submenu}
    mS := mI.Items[j];
    {titulos de itens/submenus}
    a := mI.Caption;
    b := mS.Caption;
    p := pos('&',b);
    if p > 0 then
      Delete(b,p,1);
    if b <> '-' then
      if mS.Tag = 0 then
        mS.Visible := Visible;

    {verifica se o item tem sub-itens, e então entra em recursividade}
    if mI.Items[j].Count > 0 then
    begin
      c2 := mS.Caption;
      AdicionaSubItens(mS,mS);//função recursiva
     end;
  end;
end;

var
  i,p: integer;//i= contador - p=posição
  a: string;//caption dos menus principais
  mI,mS: TUniMenuItem;//guarda posiçoes e itens do menu
begin
  for i := 0 to Menu.Items.Count - 1 do
  begin
    mI := Menu.Items[i];
    a := mI.Caption; // Titulos do menus
    if mI.Tag = 0 then
      mI.Visible := Visible;
    p := pos('&',a);
    if p > 0 then
      Delete(a,p,1);
    AdicionaSubItens(mS,Mi);
  end;
end;

function GerarFileTemp(aFilename, Ext:String):String;
Var
  AUrl:String;
Begin
  Result := UniServerModule.NewCacheFileUrl(false, Ext, aFilename, '',AUrl,True);
End;

function IPCliente:string;
Begin
  Result:= UniApplication.UniSession.RemoteIP;
End;

function UsuarioLogado:String;
Begin
//  Result:=UniApplication.UniSession.;
End;

function UsuarioDoSistema:String;
Begin
  Result:=UniSession.SystemUser;
End;

procedure Log(Value:String='');
Var
  fFile:TStringList;
Begin
  if Trim(Value)<>'' then
  Begin
    fFile:=TStringList.Create;
    Try
      if FileExists(PathCache+'\Log.txt') then
        fFile.LoadFromFile(PathCache+'\Log.txt');
      fFile.Add(Value+' - '+FormatDateTime('dd/mm/yyyy hh:mm', now));
    Finally
      FreeAndNil(fFile);
    End;
  End;
End;

procedure AbilitarControls(fHWND:TUniForm; fActive:Boolean=False);
{
Uses UniDBEdit, UniEdit, UniDBLookupComboBox, UniDBMemo, UniDBListBox,
     UniDBComboBox, UniDBGrid, UniCheckBox, UniSpeedButton, UniDBCheckBox,
     UniDBDateTimePicker, UniGroupBox, UniBitBtn, UniComboBox,
     UniDateTimePicker;
}
Procedure _AbilitarControls(fReadOnly, fEnabled:Boolean; Count:Integer; ClassName:String);
Begin
  if ClassName = 'tunidbedit'           then TUniDBEdit(fHWND.Components[Count]).ReadOnly           := fReadOnly;
  if ClassName = 'tuniedit'             then TUniEdit(fHWND.Components[Count]).ReadOnly             := fReadOnly;
  if ClassName = 'tunidblookupcombobox' then TUniDBLookupComboBox(fHWND.Components[Count]).Enabled  := fEnabled;
  if ClassName = 'tunidbmemo'           then TUniDBMemo(fHWND.Components[Count]).ReadOnly           := fReadOnly;
  if ClassName = 'tunidblistbox'        then TUniDBListBox(fHWND.Components[Count]).ReadOnly        := fReadOnly;
  if ClassName = 'tunidbcombobox'       then TUniDBComboBox(fHWND.Components[Count]).ReadOnly       := fReadOnly;
  if ClassName = 'tunidbgrid'           then TUniDBGrid(fHWND.Components[Count]).ReadOnly           := fReadOnly;
  if ClassName = 'tunicheckbox'         then TUniCheckBox(fHWND.Components[Count]).ReadOnly         := fReadOnly;
  if ClassName = 'tunispeedbutton'      then TUniSpeedButton(fHWND.Components[Count]).Enabled       := fEnabled;
  if ClassName = 'tunibitbtn'           then TUniBitBtn(fHWND.Components[Count]).Enabled            := fEnabled;
  if ClassName = 'tunidbcheckbox'       then TUniDBCheckBox(fHWND.Components[Count]).Enabled        := fEnabled;
  if ClassName = 'tunidbdatetimepicker' then TUniDBDateTimePicker(fHWND.Components[Count]).ReadOnly := fReadOnly;
  if ClassName = 'tunigroupbox'         then TUniGroupBox(fHWND.Components[Count]).Enabled          := fEnabled;
  if ClassName = 'tunidbnumberedit'     then TUniDBNumberEdit(fHWND.Components[Count]).ReadOnly     := fReadOnly;
  if ClassName = 'tunidbhtmlmemo'       then TUniDBHTMLMemo(fHWND.Components[Count]).ReadOnly       := fReadOnly;
  if ClassName = 'tunicombobox'         then TUniComboBox(fHWND.Components[Count]).ReadOnly         := fReadOnly;
  if ClassName = 'tunidatetimepicker'   then TUniDateTimePicker(fHWND.Components[Count]).ReadOnly   := fReadOnly;
end;

Var
  I :Integer;

begin
  For I:=0 To fHWND.ComponentCount - 1 do
  Begin
    ProcessMessages; // em fase de teste 22/03/2017
    _AbilitarControls(False, True, I, LowerCase(fHWND.Components[I].ClassName));
    if fHWND.Components[I].Tag = 0 then
      _AbilitarControls(not fActive, fActive, I, LowerCase(fHWND.Components[I].ClassName));
  end;
end;

procedure AbilitarControls(fHWND:TUniFrame; fActive:Boolean=False);
{
Uses UniDBEdit, UniEdit, UniDBLookupComboBox, UniDBMemo, UniDBListBox,
     UniDBComboBox, UniDBGrid, UniCheckBox, UniSpeedButton, UniDBCheckBox,
     UniDBDateTimePicker, UniGroupBox, UniBitBtn, UniComboBox,
     UniDateTimePicker;
}
Procedure _AbilitarControls(fReadOnly, fEnabled:Boolean; Count:Integer; ClassName:String);
Begin
  if ClassName = 'tunidbedit'           then TUniDBEdit(fHWND.Components[Count]).ReadOnly           := fReadOnly;
  if ClassName = 'tuniedit'             then TUniEdit(fHWND.Components[Count]).ReadOnly             := fReadOnly;
  if ClassName = 'tunidblookupcombobox' then TUniDBLookupComboBox(fHWND.Components[Count]).Enabled  := fEnabled;
  if ClassName = 'tunidbmemo'           then TUniDBMemo(fHWND.Components[Count]).ReadOnly           := fReadOnly;
  if ClassName = 'tunidblistbox'        then TUniDBListBox(fHWND.Components[Count]).ReadOnly        := fReadOnly;
  if ClassName = 'tunidbcombobox'       then TUniDBComboBox(fHWND.Components[Count]).ReadOnly       := fReadOnly;
  if ClassName = 'tunidbgrid'           then TUniDBGrid(fHWND.Components[Count]).ReadOnly           := fReadOnly;
  if ClassName = 'tunicheckbox'         then TUniCheckBox(fHWND.Components[Count]).ReadOnly         := fReadOnly;
  if ClassName = 'tunispeedbutton'      then TUniSpeedButton(fHWND.Components[Count]).Enabled       := fEnabled;
  if ClassName = 'tunibitbtn'           then TUniBitBtn(fHWND.Components[Count]).Enabled            := fEnabled;
  if ClassName = 'tunidbcheckbox'       then TUniDBCheckBox(fHWND.Components[Count]).Enabled        := fEnabled;
  if ClassName = 'tunidbdatetimepicker' then TUniDBDateTimePicker(fHWND.Components[Count]).ReadOnly := fReadOnly;
  if ClassName = 'tunigroupbox'         then TUniGroupBox(fHWND.Components[Count]).Enabled          := fEnabled;
  if ClassName = 'tunidbnumberedit'     then TUniDBNumberEdit(fHWND.Components[Count]).ReadOnly     := fReadOnly;
  if ClassName = 'tunidbhtmlmemo'       then TUniDBHTMLMemo(fHWND.Components[Count]).ReadOnly       := fReadOnly;
  if ClassName = 'tunicombobox'         then TUniComboBox(fHWND.Components[Count]).ReadOnly         := fReadOnly;
  if ClassName = 'tunidatetimepicker'   then TUniDateTimePicker(fHWND.Components[Count]).ReadOnly   := fReadOnly;
end;

Var
  I :Integer;

begin
  For I:=0 To fHWND.ComponentCount - 1 do
  Begin
    ProcessMessages; // em fase de teste 22/03/2017
    _AbilitarControls(False, True, I, LowerCase(fHWND.Components[I].ClassName));
    if fHWND.Components[I].Tag = 0 then
      _AbilitarControls(not fActive, fActive, I, LowerCase(fHWND.Components[I].ClassName));
  end;
end;

function IsDesktop:Boolean;
Begin
  Result := not UniApplication.UniSession.IsMobile; //WhatPlatform = Desktop;
End;

Function WhatBrowser:String;
var
  C    : TUniClientInfoRec;
  Texto: String;
Begin
  if C.BrowserType = 'gecko' then
    Result := 'Firefox'
  else
    Result := C.BrowserType;

{  Texto := UniApplication.RemoteAddress+#13;
  C:=UniApplication.ClientInfoRec;
  Texto := Texto + C.BrowserType+#13;
  Texto := Texto + IntToStr(C.BrowserVersion)+#13;
  Texto := Texto + C.OSType;
  Warning(Texto);
  Result:=Texto;}
End;

function IsMobile:Boolean;
Begin
  Result := UniApplication.UniSession.IsMobile;
{  Result := (WhatPlatform = Phone)  or (WhatPlatform = Tablet)  or
            (WhatPlatform = Mobile) or (WhatPlatform = Android) or
            (WhatPlatform = iPhone) ;}
End;

function WhatPlatform:TPlatform;
Begin
  if upDesktop in UniApplication.UniPlatform then Result := Desktop else
  if upPhone   in UniApplication.UniPlatform then Result := Phone   else
  if upTablet  in UniApplication.UniPlatform then Result := Tablet  else
  if upMobile  in UniApplication.UniPlatform then Result := Mobile  else
  if upAndroid in UniApplication.UniPlatform then Result := Android else
  if upiPhone  in UniApplication.UniPlatform then Result := iPhone  else
  if upiOS     in UniApplication.UniPlatform then Result := iOS;
end;

function PathCache:String;
Begin // Retorna o caminho do cache no servidor
  Result:=UniServerModule.LocalCachePath;
End;

function IPServidor: String;
begin // Mostra o IP do Servidor
  Result:=uniGUIApplication.UniSession.Host;
end;

function HomeDir: String;
begin // Mostra o diretório que o binário está sendo executado
  Result := UniServerModule.ServerRoot;
end;

procedure DisplayError(Msg: string);
begin // Uses UniGUIDialogs
  MessageDlg(Msg, mtError, [mbOk]);
end;

procedure Warning(Msg:String);
Begin // Uses UniGUIDialogs
  MessageDlg(Msg, mtWarning, [mbOk]);
End;

procedure OpenURLWindow(URL:String);
Begin
  if Trim(URL) <> '' then
    JavaScript('window.open("'+URL+'", "janela", "directories=no, resizable=no, scrollbars=no, status=no, location=no, toolbar=no, menubar=no, scrollbars=yes, resizable=no, fullscreen=no")');
//    UniSession.AddJS('window.open("'+URL+'", "janela", "directories=no, resizable=no, scrollbars=no, status=no, location=no, toolbar=no, menubar=no, scrollbars=yes, resizable=no, fullscreen=no")');
End; //http://www.guj.com.br/10470-esconder-urllink-da-barra-do-navegador-ou-a-propria-barra-de-nagegacao

Procedure Alert(Value:String);
Begin
  JavaScript('alert('+Value+')');
//  UniSession.ShowAlert(Value);
End;

Procedure JavaScript(JS:String);
Begin
  UniSession.AddJS(JS);
 // JavaScript('alert("Jairo dos Santos Gurgel")');
End;

procedure OpenURL(URL:String);
Begin
  if Trim(URL) <> '' then
    JavaScript('window.open("'+URL+'")');
 //   UniSession.AddJS('window.open("'+URL+'")');
End;

function Inf: String;
begin
  Result:=uniGUIApplication.UniSession.Host + '  '+uniGUIApplication.UniSession.URLPath;
end;

Procedure IniciarMainModule;
Begin
  CurrencyFormat   :=0;
  NegCurrFormat    :=0;
  ThousandSeparator:='.';
  DecimalSeparator :=',';
  CurrencyDecimals :=2;
  DateSeparator    :='/';
  ShortDateFormat  :='dd/MM/yyyy';
  LongDateFormat   :='dddd, d'' de ''MMMM'' de ''yyyy';
  TimeSeparator    :=':';
  TimeAMString     :='';
  TimePMString     :='';
  ShortTimeFormat  :='hh:mm';
  LongTimeFormat   :='hh:mm:ss';
  //
  With UniMainModule do
  Begin
    BrowserOptions          := [boDisableMouseRightClick,boDisableChromeRefresh];
    DocumentKeyOptions      := [dkDisableBackSpace,dkDisableF5];
    MonitoredKeys.Enabled   := True;
    NavigateKeys.SelectText := True;
    with ServerMessages do
    Begin
      LoadingMessage        := 'Carregando...';
      InvalidSessionMessage := 'Sessão inválida ou sessão expirada.';
    End;
  End;
End;

Procedure IniciarSistema(WindowsStyle:Boolean=False; Porta:Integer=80);
Var
  fExceptionTemplate:TStringList;
  fInvalidSessionTemplate_TerminateTemplate:TStringList;
  fTitle:String;
  fFile :String;
  fPath, fPathEXT:String;
  PathFramework:String;

procedure GravaIni(Filename:String);
var
  ArqIni: TIniFile;
begin
  ArqIni := TIniFile.Create(Filename);
  try
    ArqIni.WriteString('Configs', 'PathFramework', '');
  finally
    FreeAndNil(ArqIni);
  end;
end;

procedure LeIni(Filename:String);
var
  ArqIni: TIniFile;
begin
  ArqIni := TIniFile.Create(Filename);
  try
    PathFramework := BackSlashed(ArqIni.ReadString('Configs', 'PathFramework', ''));
  finally
    FreeAndNil(ArqIni);
  end;
end;

Begin
  ProcessMessages;
  fFile := HomeDir + 'Config.ini';
  if FileExists(fFile) then
    LeIni(fFile)
  else
    GravaIni(fFile);
  //
  fPath    := BackSlashed(PathFramework+UniServerModule.UniGUIVersion);
  fPathEXT := BackSlashed(fPath+BackSlashed('ext')+UniServerModule.ExtJSVersion);

  UniServerModule.ExtRoot       :=fPathEXT;
  UniServerModule.TouchRoot     :=fPath + 'touch';
  UniServerModule.UniRoot       :=fPath + 'uni';
  UniServerModule.UniMobileRoot :=fPath + 'unim';
  //
  ProcessMessages;
  fExceptionTemplate:=TStringList.Create;
  fInvalidSessionTemplate_TerminateTemplate:=TStringList.Create;
  Try
//    UniApplication
//    Application.MainForm.WindowState := wsMaximized;



    With UniServerModule, ServerMessages do // UniApplication.UniMainModule
    Begin
      ExceptionTemplate     := fExceptionTemplate;
      InvalidSessionTemplate:= fInvalidSessionTemplate_TerminateTemplate;
      TerminateTemplate     := fInvalidSessionTemplate_TerminateTemplate;
      //
      Options              := [soShowLicenseInfo,soAutoPlatformSwitch,soRestartSessionOnTimeout,soWipeShadowSessions];
      Port                 := Porta;
      UniApplicationTitle  := Title;
      SessionTimeout       := 15 * (60000); // 60000 = 1 minuto
      AjaxTimeout          := 15 * (60000); //2 * (60 * (60000)); // 02 Horas
      UnavailableErrMsg    := 'Servidor não disponível, por favor, tente mais tarde.';
      LoadingMessage       := 'Carregando...';
      UniServerModule.Title:=Title;
   //   UniMainModule.EnableSynchronousOperations := True; // ShowModal igual ao Desktop
      //
      With fExceptionTemplate do
      Begin
        Add('<html>');
        Add('<body bgcolor="#dfe8f6">');
        Add('<p style="text-align:center;color:#A05050"> '+UniServerModule.Title+' </p>');
        Add('<p style="text-align:center;color:#A05050">Uma exceção ocorreu em aplicação:</p>');
        Add('<p style="text-align:center;color:#0000A0">[###message###]</p>');
        Add('<p style="text-align:center;color:#A05050"><a href="[###url###]">Reiniciar Aplicação</a></p>');
        Add('</body>');
        Add('</htm');
      End;
     With fInvalidSessionTemplate_TerminateTemplate do
      Begin
        Add('<html>');
        Add('<body bgcolor="#dfe8f6">');
        Add('<p style="text-align:center;color:#A05050"> '+UniServerModule.Title+' </p>');
        Add('<p style="text-align:center;color:#0000A0">[###message###]</p>');
        Add('<p style="text-align:center;color:#A05050"><a href="[###url###]">Reiniciar Aplicação</a></p>');
        Add('</body>');
        Add('</html>');
      End;
      //
      if WindowsStyle  then
        MainFormDisplayMode := mfWindow
      else
        MainFormDisplayMode := mfPage;
      With ServerLimits do
      Begin
        MaxConnections := 500;//1000
        MaxRequests    := 128; //128
        MaxSessions    := 300; // 512
        MaxGDIObjects  := 10000;
        ThreadPoolSize := 250;//750
      End;

      With ServerMessages do
      Begin
        InvalidSessionMessage := 'Sessão inválido ou tempo limite da sessão Encerrado.';
        TerminateMessage      := 'Sessão Web encerrado.';
      End;

      With ConnectionFailureRecovery do
      Begin
        Enabled      := True;
        ErrorMessage := 'Erro de conexão';
        RetryMessage := 'Tentando novamente ...';
        LogEnabled   := True;
        ShowMessage  := True;
      End;
    End;
    // Uses UniGUIClasses, uniGUITypes
    UniAddJsLibrary('/js/internal_ip.js',True,[upoFolderJS,upoPlatformBoth]);
  Finally
    FreeAndNil(fExceptionTemplate);
    FreeAndNil(fInvalidSessionTemplate_TerminateTemplate);
  End;
End;

procedure Create;
begin
//  IniciarVariaveisDeAmbiente;
//  IniciarSistema;
end;

procedure Destroy;
begin
 //
end;

Initialization
  Create;

Finalization
  Destroy;

end.
