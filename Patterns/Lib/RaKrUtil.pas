{
@abstract(Kernel de funções úteis para sistemas feitos em Raudus.)
@author(Analista / Programador : Jairo dos Santos Gurgel <jsgurgel@hotmail.com>)
@created(2018)
@lastmod(07/02/2018)
}
unit RaKrUtil;

interface

Uses
  // ShlObj, WinSock, ShellApi, IdBaseComponent, IdComponent, IdRawBase, IdRawClient, IdIcmpClient,
  // DB,  DbCtrls,
  krUtil, KrXLSExport,
  Classes, SysUtils, Controls, StdCtrls,Graphics, ComCtrls, Windows,
  DateUtils, Forms, Types, ExtCtrls, Dialogs, DB,
  RaApplication, RaBase, RaControlsVCL;


type
  TPlatform = (iPhone, iOS, Android, Phone, Desktop, Tablet, Mobile);

//  procedure HabilitarMenu(Menu: TUniMainMenu; Visible:Boolean=False);
  function UsuarioLogado:String;    // ? retorna o nome do usuário logado no sistema
  function UsuarioDoSistema:String; // ?
  function IPCliente:string;        // ? Retorna o IP do cliente
  function Inf: String;             // ? Retorna informações do cliente
  function IPServidor: String;      // Retorna o IP do Servidor
  function PathCache:String;        // ? Retorna o diretório do Cache do servidor
  function HomeDir: String;         // Retorna o diretório do binário que está no servidor
  Function Navegador:String; // Retorna o nome do navegador
  function WhatPlatform:TPlatform;  // ? Indica qual a plataforma do Sistema Operacional
  function IsDesktop:Boolean;       // ? Informa se e um Desktop
  function IsMobile:Boolean;        // ? Informa se e um Smartphone
  Function WhatBrowser:String;      // ? Retorna qual o Navegador utilizado pelo cliente
//  procedure AbilitarControls(fHWND:TUniForm; fActive:Boolean=False); overload; // Abilita e desabilita os componentes no form
//  procedure AbilitarControls(fHWND:TUniFrame; fActive:Boolean=False); overload;
  procedure ProcessMessages; // emula o Thread
  function GerarFileTemp(aFilename, Ext:String):String;// gera um nome de arquivo temporário
  function BackSlashedWWW(const aFolder:string):string;
  function BackSlashed(const aFolder:string):string;

  // Dialogos
  procedure Warning(Msg:String);
  procedure DisplayError(Msg: string); // Dialogo de erro
  procedure OpenURLWindow(URL:String);
  procedure OpenURL(URL:String);
  procedure Redirect(URL:String);

//  Procedure ExportToCSV(aDataset: TDataset; const Filename: String; const Separator: String = ';'); overload;
//  Procedure ExportToCSV(aGrid: TUniDBGrid; const Filename: String; const Separator: String = ';');overload;
//  Procedure ExportToXLS(aGrid: TUniDBGrid; const Filename: String);
//  procedure ExportToCSV(aServerModule:TUniServerModule; aGrid: TUniDBGrid)overload;
  Procedure ExportToCSV(aDataset: TDataset; const Filename: String; const Separator: String = ';'); overload;
  // Arquivo
  procedure DownloadFile(Filename:String);
  Function NewCacheFolder:String;

  // Inicia os principais parâmetros do sistema
  Procedure IniciarSistema(WindowsStyle:Boolean=False; Porta:Integer=80);
//  Function IsFormCreated(UniPageControl:TUniPageControl; Name:String):Boolean;
//  Procedure CriarForm(Name, Title:String; UniPageControl:TUniPageControl; fForm: TUniFrame); overload;
//  Procedure CriarForm(Name, Title:String; UniPageControl:TUniPageControl; fForm: TUniForm); overload;

Var
  UniApplicationTitle:String;

implementation
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

(*Function IsFormCreated(UniPageControl:TUniPageControl; Name:String):Boolean;
Var
  I:Integer;
Begin
{  Result:=False;
  for I  := 0 to UniPageControl.PageCount -1 do
    if UniPageControl.Pages[I].Name = Name then
    Begin
      Result :=True;
      Exit;
    End;}
End;

Procedure CriarForm(Name, Title:String; UniPageControl:TUniPageControl; fForm: TUniFrame);
//Var
//  TabS : TUniTabSheet;

Function IsFormCreated(Name:String):TUniTabSheet;
//Var
//  I:Integer;
Begin
 { Result:=nil;
  for I  := 0 to UniPageControl.PageCount -1 do
    if UniPageControl.Pages[I].Name = Name then
    Begin
      Result := UniPageControl.Pages[I];
      Exit;
    End;}
End;

begin
{  TabS := IsFormCreated(Name);
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
  UniPageControl.ActivePage := TabS; }
End;

Procedure CriarForm(Name, Title:String; UniPageControl:TUniPageControl; fForm: TUniForm);
//Var
//  TabS : TUniTabSheet;

Function IsFormCreated(Name:String):TUniTabSheet;
//Var
//  I:Integer;
Begin
{  Result:=nil;
  for I  := 0 to UniPageControl.PageCount -1 do
    if UniPageControl.Pages[I].Name = Name then
    Begin
      Result := UniPageControl.Pages[I];
      Exit;
    End;  }
End;

begin
{  TabS := IsFormCreated(Name);
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
  UniPageControl.ActivePage := TabS;  }
End; *)

Function NewCacheFolder:String;
Begin
//  Result := UniServerModule.NewCacheFolder;
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
(*
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
end;  *)

procedure DownloadFile(FileName:String);
Begin
//  UniApplication.UniSession.SendFile(FileName);
End;

procedure ProcessMessages;
Begin
  //if Application<>nil then
  //  Application.ProcessMessages;
end;

function GerarFileTemp(aFilename, Ext:String):String;
Var
  AUrl:String;
Begin
//  Result := UniServerModule.NewCacheFileUrl(false, Ext, aFilename, '',AUrl,True);
End;

function IPCliente:string;
Begin
//  Result:= UniApplication.UniSession.RemoteIP;
End;

function UsuarioLogado:String;
Begin
//  Result:=UniApplication.UniSession.;
End;

function UsuarioDoSistema:String;
Begin
//  Result:=UniSession.SystemUser;
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
(*
procedure AbilitarControls(fHWND:TUniForm; fActive:Boolean=False);
{
Uses UniDBEdit, UniEdit, UniDBLookupComboBox, UniDBMemo, UniDBListBox,
     UniDBComboBox, UniDBGrid, UniCheckBox, UniSpeedButton, UniDBCheckBox,
     UniDBDateTimePicker, UniGroupBox, UniBitBtn, UniComboBox,
     UniDateTimePicker;
}
Procedure _AbilitarControls(fReadOnly, fEnabled:Boolean; Count:Integer; ClassName:String);
Begin
{  if ClassName = 'tunidbedit'           then TUniDBEdit(fHWND.Components[Count]).ReadOnly           := fReadOnly;
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
  if ClassName = 'tunidatetimepicker'   then TUniDateTimePicker(fHWND.Components[Count]).ReadOnly   := fReadOnly;}
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
{  if ClassName = 'tunidbedit'           then TUniDBEdit(fHWND.Components[Count]).ReadOnly           := fReadOnly;
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
  if ClassName = 'tunidatetimepicker'   then TUniDateTimePicker(fHWND.Components[Count]).ReadOnly   := fReadOnly;}
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
end;   *)

function IsDesktop:Boolean;
Begin
//  Result := not UniApplication.UniSession.IsMobile; //WhatPlatform = Desktop;
End;

Function WhatBrowser:String;
Begin
//
End;

function IsMobile:Boolean;
Begin
//  Result := UniApplication.UniSession.IsMobile;
End;

function WhatPlatform:TPlatform;
Begin
{  if upDesktop in UniApplication.UniPlatform then Result := Desktop else
  if upPhone   in UniApplication.UniPlatform then Result := Phone   else
  if upTablet  in UniApplication.UniPlatform then Result := Tablet  else
  if upMobile  in UniApplication.UniPlatform then Result := Mobile  else
  if upAndroid in UniApplication.UniPlatform then Result := Android else
  if upiPhone  in UniApplication.UniPlatform then Result := iPhone  else
  if upiOS     in UniApplication.UniPlatform then Result := iOS;}
end;

function PathCache:String;
Begin // Retorna o caminho do cache no servidor
//  Result:=RaApplication.Application.LoadingMessage;
End;

function IPServidor: String;
begin // Mostra o IP do Servidor
  Result:=RaApplication.Application.RemoteIPAddress;
end;

Function Navegador:String; // Retorna o nome do navegador
Var
  Text:String;

Begin
  Text := UpperCase(RaApplication.Application.RemoteUserAgent);
  Result:=Text;
  //
  if Pos('OPR/', Text) <> 0 then
    Result := 'Opera'
  else
    if Pos('FIREFOX', Text)<> 0 then
      Result := 'Firefox'
    else
      if Pos('.NET', Text)<> 0 then
        Result := 'Internet Explorer'
      else
        if Pos('CHROME', Text)<> 0 then
          Result := 'Chrome';
End;


function HomeDir: String;
begin // Mostra o diretório que o binário está sendo executado
  Result := krUtil.BackSlashed(ExtractFilePath(ParamStr(0)));
end;

procedure DisplayError(Msg: string);
begin // Uses UniGUIDialogs
//  MessageDlg(Msg, mtError, [mbOk]);
end;

procedure Warning(Msg:String);
Begin // Uses UniGUIDialogs
 // MessageDlg(Msg, mtWarning, [mbOk]);
End;

procedure OpenURLWindow(URL:String);
Begin
//  if Trim(URL) <> '' then

//  if Trim(URL) <> '' then
    //UniSession.AddJS('window.open("'+URL+'", "janela", "directories=no, resizable=no, scrollbars=no, status=no, location=no, toolbar=no, menubar=no, scrollbars=yes, resizable=no, fullscreen=no")');
End; //http://www.guj.com.br/10470-esconder-urllink-da-barra-do-navegador-ou-a-propria-barra-de-nagegacao

procedure OpenURL(URL:String);
Begin
  if Trim(URL) <> '' then
    RaApplication.Application.BrowserWindowOpen(URL);
End;

procedure Redirect(URL:String);
Begin
  if Trim(URL) <> '' then
    RaApplication.Application.Redirect(URL);
End;

function Inf: String;
begin
//  Result:=uniGUIApplication.UniSession.Host + '  '+uniGUIApplication.UniSession.URLPath;
end;

Procedure IniciarSistema(WindowsStyle:Boolean=False; Porta:Integer=80);
Var
  fExceptionTemplate:TStringList;
  fInvalidSessionTemplate_TerminateTemplate:TStringList;
  fTitle:String;
  fPath, fPathEXT:String;

Begin
  RaApplication.Application.LoadingMessage        := 'Carregando as informações...';
  RaApplication.Application.Config.Port           := Porta;
  RaApplication.Application.Config.RequestTimeout := 10 * (60 * (60000)); // 10 horas
  ProcessMessages;
  (*  fPath    := 'c:\xampp\htdocs\uniGUI\'+UniServerModule.UniGUIVersion+'\';
  fPathEXT := 'c:\xampp\htdocs\uniGUI\ext\'+UniServerModule.ExtJSVersion+'\';

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
      Port                 := Porta;
      UniApplicationTitle  := Title;
      SessionTimeout       := 10 * (60 * (60000)); // 10 horas
      AjaxTimeout          := 10 * (60 * (60000)); // 10 Horas
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
        MaxConnections := 1024;
        MaxRequests    := 128;
        MaxSessions    := 512;
        MaxGDIObjects  := 16384;
      End;

      With ServerMessages do
      Begin
        InvalidSessionMessage := 'Sessão inválido ou tempo limite da sessão Encerrado.';
        TerminateMessage      := 'Sessão Web encerrado.';
      End;
      With ConnectionFailureRecovery do
      Begin
        RetryMessage := 'Tentando novamente ...';
        ErrorMessage := 'Erro na conexão';
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
  Finally
    FreeAndNil(fExceptionTemplate);
    FreeAndNil(fInvalidSessionTemplate_TerminateTemplate);
  End;   *)
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
