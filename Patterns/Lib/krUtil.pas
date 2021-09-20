{
@abstract(Kernel de funções úteis para sistemas.)
@author(Analista / Programador : Jairo dos Santos Gurgel <jsgurgel@hotmail.com>)
@created(2010)
@lastmod(01/12/2014)
}
unit krUtil;

interface

Uses
  krVar, //typinfo, DBGrids, MaskEdit, IniFiles
  IdBaseComponent, IdComponent, IdRawBase, IdRawClient, IdIcmpClient,
  StdCtrls, DbCtrls, Graphics,  ComCtrls, DB,
  WinSock, ShellApi, Windows, ShlObj,  Classes, SysUtils,
  DateUtils, Forms, Controls, Types,
  Dialogs, Buttons, ExtCtrls, Menus;

type
  TFeriados = (frPascoa, frCarnaval, frQuartaCinzas, frSextaSanta, frCorpusChristi);


Const
  Numeric=['0'..'9'];
  Acent  =['á','à','ã','â','é','è','ê','í','ì','î','ó','ò','õ','ô','ú','ù','û',
           'Á','À','Ã','Â','É','È','Ê','Í','Ì','Î','Ó','Ò','Õ','Ô','Ú','Ù','Û',
           'ç','Ç','&'];
  Symbols=['_','-'];
  Alpha  =['A'..'Z','a'..'z']+Acent+Numeric+Symbols;
  Vogal  =['A','E','I','O','U','Y','W']+Acent-['ç','Ç'];
  SomI   =['E','I','Y'];
  Acents1:string[37]='áàãâéèêíìîóòõôúùûÁÀÃÂÉÈÊÍÌÎÓÒÕÔÚÙÛçÇ&';
  Acents2:string[37]='AAAAEEEIIIOOOOUUUAAAAEEEIIIOOOOUUUSSE';
//  DataNula:String='30/12/1899';

Var
  Feriados:TStrings;

  Procedure DatasetToSCV(aDataset: TDataset; const Filename: String; const Separator: String = ';');

  // Dialogos
  procedure Warning(Msg:string);// Dialogo que é um alerta
  procedure DisplayError(Msg:string); // Mensagem de dialog de erro
  function Confirm(Msg:string; DefaultButton:TModalResult=mrNo):Boolean;// Caixa de dialogo de confirmação
  function QuitApplication:Boolean; // deve ser utilizado nio final de uma aplicação no evento OnCloseQuery

  // Funções de String
  function DelCharEspeciais(Str:String):string; // Deletea os caracteres especiais de uma string
  function TokenN(const aTokenList:string; aIndex:integer; aTokenSeparator:char='|'):string; // funções de Token
  function CountToken(const aTokenList:string; aTokenSeparator:char='|'):Integer; // funções de Token
  function StrZero(aNumber,aWidth:integer):string; overload;// completa uma String com Zero a esquerda
  function StrZero(aNumber:String; aWidth:integer):string; overload;// completa uma String com Zero a esquerda
  function Empty(const aString:string):boolean;// verifica se uma determinada String está vazia
  function SemAcento(Text:String):String;
  Function CountWorld(Text:String; Progress:TProgressBar=Nil):TStrings; // Separa as palavras de uma String
  function RetirarEspacosExtrasUp(psTexto: string): string;
  function RetirarEspacosExtras(psTexto: string): string;// Retira os espaço duplicados na string
  function DelChar(Str :string; aChar:Char):string;
  function LPad(Texto : String; Caractere : Char; Quantidade : SmallInt) : String;
  function RPad(Texto : String; Caractere : Char; Quantidade : SmallInt) : String;
  function GetFirstName(Nome : String) : String;
  Function GetLastName(Name: string): string;
  function ComplereTamanhoR(Value: String; aWidth: integer; Caractere:String='|'): string;
  function ComplereTamanhoL(Value: String; aWidth: integer; Caractere:String='|'): string;

  // Validação
  Function IsEMail(Value: String):Boolean; // Verifica se um e-mail é válido ou não
  function IsCnpj(const aCode:string):boolean; //Retorna verdadeiro se aCode for um CNPJ válido
  function IsCpf(const aCode:string):boolean; //Retorna verdadeiro se aCode for um CPF válido
  function IsCpfCnpj(const aCode:string):boolean;//Retorna verdadeiro se aCode for um CPF ou CNPJ válido
  function IsDate(fDate:String):Boolean; // verifica se uma determinada data é válida ou não
  function IsPlaca(Value:String):Boolean; // Faz a validação de uma placa de automóvel
  function IsTitulo(numero: String): Boolean; // Validação de titulo de eleitor
  function IsIP(ip: string): Boolean; // Verifica se o IP inofmado é válido
  function IsCNH(cnh: string): Boolean; // Verifica se a CNH está correta
  function IsIE(UF, IE: string): boolean;// Valida a Inscrição Estadual
  function IsTituloEleitor(NumTitulo: string): Boolean; // Valida Título de Eleitor
  function IsRenavam(Num: String):Boolean; //
  function IsNum(Value:String):Boolean;

  // Criação de Formulário
  procedure CriarFormModal(Formulario:TFormClass); overload;// cria um formulário modal
  procedure CriarFormModal(Formulario:TFormClass; fParent:TTabSheet; FormName:String); overload;
  procedure CriarFormModal(Formulario:TFormClass; fParent:TTabSheet; MenuItem:TMenuItem; FormName:String); overload;

  // Outras funções
  procedure CentralizedComponent(Component, Owner: TControl; const Horz, Vert: byte); Overload; // centraliza o componente usando como padrão o Owner
  procedure CentralizedComponentHorz(Component: TControl; const Horz: byte);
  procedure CentralizedComponentVert(Component: TControl; const Vert: byte);
  procedure CentralizedComponent(Component: TControl); overload;
  procedure _RegisterClass(AClass: TPersistentClass);// Faz o registrio das classes do objeto
  procedure ProcessMessages; // emula o Thread
  function HomeDir:String; // Informa o diretório da aplicação.
  function Soundex(S:String):String; // Fornece uma String para a busca fonética
  function Idade(DataNasc:String):string; Overload; // Calcula a idade a luz da data informada
  function Idade(DataNasc:String; dtAtual:TDate):string; Overload;
  function BackSlashed(const aFolder:string):string;// virifica se o último caractere da String é o separador de diretório
  function BackSlashedWWW(const aFolder:string):string;
  function BoolToStr2(Bool:Boolean):String; overload;// Converte o valor de uma variável booleana em String
  function BoolToStr2(Bool:Integer):String; overload;
  function BoolToStr1(Bool:Boolean):String;// Converte o valor de uma variável booleana em String
  function BoolToStr (Valor : Boolean) : String;// Transforma um valor boolean em String
  function StrToBool1(Str:string):boolean;// Converte o valor de uma variável String em Booleano
  function StrToBool ( Valor : String) : Boolean;// Transforma uma string em Boolean. O valor tem que ser o ou 1
  function DeletarCharExpeciais(Value:String):String;// deleta alguns caracteres expeciais
  function DeletarChar(Value, fCHAR: String): String;
  function _SubstChar (Value, Localizar, Substituir : string) : string; // Substitui um caractere por outro em uma String
  procedure NewCollor(Sender: TObject; fColor :TColor);
  function GerarNomeArquivo:String; // Gera no de arquivo aleatório
  Function ComputerIsOn:String; // Retorna quanto tempo o computador está ligado
  function IsInsertOrEdit(DataSource: TDataSource):Boolean;
  function DeleteFileExists(fFilename:String):boolean;

  // Date e Time
  function MonthLastDay(Mdt: TDateTime) : TDateTime; /// Retorna o ultimo dia do mes informado
  function FirstMonthDay(Mdt: TDateTime) : TDateTime; // Retorna o primero do do mes informado
  function PriorMonth:TDateTime;// Retorna o mes anterio ao mes corrente
  function DataExtenso:String;// Retorna a data atual por extenso
  function HoraMiliSegundos(Hora: TDatetime): LongInt;// Transforma uma determinada hora em segundos
  function MiliSegundosHora(MiliSegundo: LongInt): string;// Converte uma quantidade de milésimo de segundos em horas
  function AddTime(fAddTime, TimeTotal:String):String;// Realiza a soma entre duas horas
  function SubTime(fAddTime, TimeTotal:String):String; // Subtrai uma quantidade de horas de um valor total de horas - Não está Ok
  function MesAnterior:TDateTime;
  function Dias_Uteis(DT_Ini, DT_Fin:TDateTime):Integer; // Retorna a quantidade de dias entre duas datas considerando apenas os dias uteis
  function GetTickCount64: Int64;
  function SToHMS(I: Integer): String;

  // Sistema Operacional
  Function SearchParamStr(aValue:String):Boolean;
  function Ping(host: String): Boolean;
  function PingIP(host: String): Boolean;
  Function WinExecAndWait(const Path:  PChar; const Visibility:  Word; const Wait:  Boolean):  Boolean; // Executa uma aplicação externa e espera o témino

  // Funções específicas para o Sistema Operacional Windows
  procedure Create;
  function isKeyValid(Value:Char):Boolean;
  function SoLetras(Value:Char):Boolean;  overload;
  Function SoLetras(Texto: String):Boolean;  overload;
  function SoNumeros(Value:Char):Boolean;
  procedure IniciarVariaveisDeAmbiente;
  Function GetWhere(Value:TStrings):String;
  Procedure AddFeriados(Data:String);
  Function FeriadosFixos(Ano:String):String; overload;
  Function FeriadosFixos:String;  overload;
  function GeraSenha(n: integer): String;

  // Cripitografia
  function Criptografar(wStri: String): String;
  Function Crypt(Action, Value: String): String;  //


implementation
Function WinExecAndWait(const Path:  PChar; const Visibility:  Word; const Wait:  Boolean):  Boolean;
var
  ProcessInformation:  TProcessInformation;
  StartupInfo:  TStartupInfo;
begin
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  with StartupInfo do
  begin
    cb          := SizeOf(TStartupInfo);
    lpReserved  := NIL;
    lpDesktop   := NIL;
    lpTitle     := NIL;
    dwFlags     := STARTF_USESHOWWINDOW;
    wShowWindow := Visibility;
    cbReserved2 := 0;
    lpReserved2 := NIL
  end;

  result := CreateProcess(NIL,       {address of module name}
                          Path,      {address of command line}
                          NIL,       {address of process security attributes}
                          NIL,       {address of thread security attributes}
                          FALSE,     {new process inherits handle}
                          NORMAL_PRIORITY_CLASS,   {creation flags}
                          NIL,       {address of new environment block}
                          NIL,       {address of current directory name}
                          StartupInfo,
                          ProcessInformation);
  if Result then
  begin
    with ProcessInformation do
    begin
      if Wait then
      WaitForSingleObject(hProcess, INFINITE);
      CloseHandle(hThread);
      CloseHandle(hProcess)
    end;
   end;
 (*SW_SHOWNORMAL - Janela em modo normal
   SW_MAXIMIZE   - Janela maximizada
   SW_MINIMIZE   - Janela minimizada
   SW_HIDE       - Janela Escondida *)
end;

function GetFirstName(Nome : String) : String;
var
  PNome : String;
begin
  PNome := '';
  if pos (' ', Nome) <> 0 then
    PNome := copy (Nome, 1, pos (' ', Nome) - 1);
  Result := PNome;
end;

Function GetLastName(Name: string): string;
begin
  Result := Name;
  repeat
    Delete(Result,1,Pos(' ',Result));
  until Pos(' ',Result)=0;
end;

Procedure DatasetToSCV(aDataset: TDataset; const Filename: String; const Separator: String = ';');
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

function LPad(Texto : String; Caractere : Char; Quantidade : SmallInt) : String;
var
  i : SmallInt;
  s : String;
begin
  Result := '';
  s := '';
  for i := 1 to Quantidade - Length(Texto) do
    s := Caractere + s;
  Result := s + Texto;
end;

function RPad(Texto : String; Caractere : Char; Quantidade : SmallInt) : String;
var
  i : SmallInt;
  s : String;
begin
  Result := '';
  s := '';
  for i := 1 to Quantidade - Length(Texto) do
    s := Caractere + s;
  Result := Texto + s;
end;

function IsInsertOrEdit(DataSource: TDataSource):Boolean;
Begin
  Result:= DataSource.DataSet.State  in [dsEdit, dsInsert]
End;

function DeleteFileExists(fFilename:String):boolean;
Begin
  Result:=False;
  if FileExists(fFilename) then
    Result:=DeleteFile(fFilename);
End;

function RetirarEspacosExtras(psTexto: string): string;
var
  nCont, nTamanhoDoTexto: integer;
begin
  nTamanhoDoTexto := Length(psTexto);
  for nCont := 0 to nTamanhoDoTexto - 1 do
    psTexto := StringReplace(psTexto, '  ', ' ', [rfReplaceAll]);
  result := psTexto;
end;

function RetirarEspacosExtrasUp(psTexto: string): string;
var
 nCont, nTamanhoDoTexto: integer;
 fpsTexto:String;
begin
  fpsTexto := UpperCase(psTexto);
  nTamanhoDoTexto := Length(fpsTexto);
  for nCont := 0 to nTamanhoDoTexto - 1 do
    fpsTexto := StringReplace(fpsTexto, '  ', ' ', [rfReplaceAll]);
  result := fpsTexto;
end;

Function CountWorld(Text:String; Progress:TProgressBar=Nil):TStrings;
// http://www.scriptbrasil.com.br/forum/topic/118300-ap%C3%B3s-ler-um-txt-indentificar-palavras-e-depois-separar-cada-letrinha/
var // Separa as palavras de uma String
  S: string;
  x, n : integer;
begin
  x := -1;
  S := Trim(Text);
  Result := TStringList.Create;
  if Assigned(Progress) then
  Begin
    Progress.Max := Length(S);
    Progress.Position := 0;
  End;
  while Pos(' ', S) > 0 do
  begin
    Application.ProcessMessages;
    Inc(x);
    if Assigned(Progress) then Progress.Position := x;
    Result.Add(trim(copy(s,1,Pos(' ', S)))); // SEPARAR AS PALAVRAS
    S[Pos(' ', S)] := '#';
    Delete(S,1,Pos('#', S));
    n := Length(trim(Result.Strings[x]));
  end;
  n := Length(trim(Result.Strings[x]));
  Inc(x);
  if Assigned(Progress) then Progress.Position := x;
  Result.Add(trim(copy(s,1,n+1))); // SEPARAR A ULTIMA PALAVRAS
  if Assigned(Progress) then Progress.Position := 0;
end;

function PingIP(host: String): Boolean;
var
  IdICMPClient: TIdICMPClient;
begin // IdBaseComponent, IdComponent, IdRawBase, IdRawClient, IdIcmpClient
  try
    IdICMPClient := TIdICMPClient.Create( nil );
    IdICMPClient.Host := host;
    IdICMPClient.ReceiveTimeout := 500;
    IdICMPClient.Ping;
    result := ( IdICMPClient.ReplyStatus.BytesReceived > 0 );
  finally
    FreeAndNil(IdICMPClient);
  end
end;

function Ping(host: String): Boolean;
var
  IdICMPClient: TIdICMPClient;
begin // IdBaseComponent, IdComponent, IdRawBase, IdRawClient, IdIcmpClient
  try
    IdICMPClient := TIdICMPClient.Create( nil );
    IdICMPClient.Host := host;
    IdICMPClient.ReceiveTimeout := 500;
    IdICMPClient.Ping;
    result := ( IdICMPClient.ReplyStatus.BytesReceived > 0 );
  finally
    FreeAndNil(IdICMPClient);
  end
end;

function SemAcento(Text:String):String;
Const
  Acents1:string[37]='áàãâéèêíìîóòõôúùûÁÀÃÂÉÈÊÍÌÎÓÒÕÔÚÙÛçÇ';
  Acents2:string[37]='aaaaeeeiiioooouuuAAAAEEEIIIOOOOUUUcC';

Var
  I, P:Integer;
Begin
  For I:=1 to Length(Text) do
  begin
    P:=Pos(Text[I],Acents1);
    If P>0 then
      Text[I]:=Char(Acents2[P])
    else
      Text[I]:=Text[I];
  end;
  Result:=Text;
End;

// http://forum.imasters.com.br/topic/381749-resolvidofuno-para-criptografar-128-bits-com-escolha-de-cara/
Function Crypt(Action, Value: String): String;
var
  KeyLen   : Integer;
  KeyPos   : Integer;
  OffSet   : Integer;
  Dest     : String;
  Key      : String;
  SrcPos   : Integer;
  SrcAsc   : Integer;
  TmpSrcAsc: Integer;
  Range    : Integer;
begin
  Result:= '';
  if (Value = '') Then
    Exit;
  Key := 'YUQL23KL23DF90WI5E1JAS467NMCXXL6JAOAUWWMCL0AOMM4A4 VZYW9KHJUI2347EJHJKDF3424SKLK3LAKDJSL9RTIKJ';
  Dest := '';
  KeyLen := Length(Key);
  KeyPos := 0;
  SrcPos := 0;
  SrcAsc := 0;
  Range := 256;
  if (Action = UpperCase('C')) then
  begin
    Randomize;
    OffSet := Random(Range);
    Dest := Format('%1.2x',[OffSet]);
    for SrcPos := 1 to Length(Value) do
    begin
      Application.ProcessMessages;
      SrcAsc := (Ord(Value[SrcPos]) + OffSet) Mod 255;
      if KeyPos < KeyLen then KeyPos := KeyPos + 1 else KeyPos := 1;
      SrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
      Dest := Dest + Format('%1.2x',[SrcAsc]);
      OffSet := SrcAsc;
    end;
  end
  Else if (Action = UpperCase('D')) then
  begin
    OffSet := StrToInt('$'+ copy(Value,1,2));
    SrcPos := 3;
    repeat
    SrcAsc := StrToInt('$'+ copy(Value,SrcPos,2));
    if (KeyPos < KeyLen) Then KeyPos := KeyPos + 1 else KeyPos := 1;
    TmpSrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
    if TmpSrcAsc <= OffSet then TmpSrcAsc := 255 + TmpSrcAsc - OffSet
    else TmpSrcAsc := TmpSrcAsc - OffSet;
    Dest := Dest + Chr(TmpSrcAsc);
    OffSet := SrcAsc;
    SrcPos := SrcPos + 2;
    until (SrcPos >= Length(Value));
  end;
  Result:= Dest;
end;

function Criptografar(wStri: String): String;
var
  Simbolos : array [0..4] of String;
  x        : Integer;
begin
  Simbolos[1]:='ABCDEFGHIJLMNOPQRSTUVXZYWK ~!@#$%^&*()';
  Simbolos[2]:= 'ÂÀ©Øû×ƒçêùÿ5Üø£úñÑªº¿®¬¼ëèïÙýÄÅÉæÆôöò»Á';
  Simbolos[3]:= 'abcdefghijlmnopqrstuvxzywk1234567890';
  Simbolos[4]:= 'áâäàåíóÇüé¾¶§÷ÎÏ-+ÌÓß¸°¨·¹³²Õµþîì¡«½';
  for x := 1 to Length(Trim(wStri)) do
  begin
    if pos(copy(wStri,x,1),Simbolos[1])>0 then
      Result := Result+copy(Simbolos[2], pos(copy(wStri,x,1),Simbolos[1]),1)
    else
  	if pos(copy(wStri,x,1),Simbolos[2])>0 then
      Result := Result+copy(Simbolos[1], pos(copy(wStri,x,1),Simbolos[2]),1)
    else
		if pos(copy(wStri,x,1),Simbolos[3])>0 then
      Result := Result+copy(Simbolos[4], pos(copy(wStri,x,1),Simbolos[3]),1)
    else
		if pos(copy(wStri,x,1),Simbolos[4])>0 then
      Result := Result+copy(Simbolos[3], pos(copy(wStri,x,1),Simbolos[4]),1);
  end;
end;

Function GetWhere(Value:TStrings):String;
Var
  I:Integer;
Begin
  Result:='';
  I:=Pos('WHERE',UpperCase(Value.Text));
  if I>0 then
    Result:=Copy(Value.Text,I+5,Length(Value.Text)-I);

  I:=Pos('GROUP BY',UpperCase(Result));
  if I>0 then
    Result:=Trim(Copy(Result,1,I-1));

  I:=Pos('ORDER BY',UpperCase(Result));
  if I>0 then
    Result:=Trim(Copy(Result,1,I-1));
End;

function GeraSenha(n: integer): String;
const
  S = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
  i : integer;
begin
  Result:='';
  Randomize;
  for i:= 1 to n do
    Result := Result + S[Random(Length(S)) +1];
end;

function GerarNomeArquivo:String;
function Senha( n: integer ): String;
const // http://www.gambiarras.net/index.php/categorias-delphi/item/361-gerar-senha-aleatoria
  str='1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
  i: integer;
begin
  Result:= '';
  Randomize;
  for i:=1 to n do
    result:= result + str[random(length(str))+1];
end;
Begin
  Result := Senha(8)+'-'+Senha(4)+'-'+Senha(4)+'-'+Senha(5)+'-'+Senha(12);
End;

function CalculaPascoa(AAno: Word): TDateTime;
var
  R1, R2, R3, R4, R5 : Longint;
  FPascoa : TDateTime;
  VJ, VM, VD : Word;
begin
  R1 := AAno mod 19;
  R2 := AAno mod 4;
  R3 := AAno mod 7;
  R4 := (19 * R1 + 24) mod 30;
  R5 := (6 * R4 + 4 * R3 + 2 * R2 + 5) mod 7;
  FPascoa := EncodeDate(AAno, 3, 22);
  FPascoa := FPascoa + R4 + R5;
  DecodeDate(FPascoa, VJ, VM, VD);
  case VD of
    26 : FPascoa := EncodeDate(Aano, 4, 19);
    25 : if R1 > 10 then
           FPascoa := EncodeDate(AAno, 4, 18);
  end;
  Result:= FPascoa;
end;

function CalculaFeriado(AAno: Word; ATipo: TFeriados): TDateTime;
var
  Aux: TDateTime;
begin
  Aux := CalculaPascoa(AAno);
  Case ATipo of
    frCarnaval     : Aux := Aux - 47;
    frQuartaCinzas : Aux := Aux - 46;
    frSextaSanta   : Aux := Aux - 2;
    frCorpusChristi: Aux := Aux + 60;
  end;
  Result := Aux;
end;

Function FeriadosFixos(Ano:String):String;
Begin
  Try
   // Feriados.Add('01/01/'+Ano);//	- Confraternização Universal
   // Feriados.Add('21/04/'+Ano);//	- Tiradentes
   // Feriados.Add('01/05/'+Ano);//	- Dia do Trabalho
   // Feriados.Add('07/09/'+Ano);//	- Independência do Brasil
   // Feriados.Add('12/10/'+Ano);//	- Nossa Senhora Aparecida
   // Feriados.Add('02/11/'+Ano);//	- Finados
   // Feriados.Add('15/11/'+Ano);//	- Proclamação da República
    //Feriados.Add('25/12/'+Ano);//	- Natal
    Feriados.Add(DateToStr(CalculaFeriado(StrToInt(Ano), frCarnaval)));
    Feriados.Add(DateToStr(CalculaFeriado(StrToInt(Ano), frPascoa)));
    Feriados.Add(DateToStr(CalculaFeriado(StrToInt(Ano), frQuartaCinzas)));
    Feriados.Add(DateToStr(CalculaFeriado(StrToInt(Ano), frSextaSanta)));
    Feriados.Add(DateToStr(CalculaFeriado(StrToInt(Ano), frCorpusChristi)));
  Finally
    Result:=Feriados.Text;
  End;
End;

Function FeriadosFixos:String;
Begin
  Result:=Feriados.Text;
End;

Procedure AddFeriados(Data:String);
Begin
  if Feriados.IndexOf(Data + '/'+ FormatDateTime('yyyy', now)) = -1 then
    Feriados.Add(Data + '/'+ FormatDateTime('yyyy', now));
End;

{Function FeriadosFixos(Ano:String):String;
Var
  Feriados:TStrings;
Begin
  Feriados:=TStringList.Create;
  Try
    Feriados.Add('01/01/'+Ano);//	- Confraternização Universal
    Feriados.Add('21/04/'+Ano);//	- Tiradentes
    Feriados.Add('01/05/'+Ano);//	- Dia do Trabalho
    Feriados.Add('07/09/'+Ano);//	- Independência do Brasil
    Feriados.Add('12/10/'+Ano);//	- Nossa Senhora Aparecida
    Feriados.Add('02/11/'+Ano);//	- Finados
    Feriados.Add('15/11/'+Ano);//	- Proclamação da República
    Feriados.Add('25/12/'+Ano);//	- Natal
    Feriados.Add(DateToStr(CalculaFeriado(StrToInt(Ano), frCarnaval)));
    Feriados.Add(DateToStr(CalculaFeriado(StrToInt(Ano), frPascoa)));
    Feriados.Add(DateToStr(CalculaFeriado(StrToInt(Ano), frQuartaCinzas)));
    Feriados.Add(DateToStr(CalculaFeriado(StrToInt(Ano), frSextaSanta)));
    Feriados.Add(DateToStr(CalculaFeriado(StrToInt(Ano), frCorpusChristi)));
  Finally
    Result:=Feriados.Text;
    FreeAndNil(Feriados);
  End;
End;}

function Dias_Uteis(DT_Ini, DT_Fin:TDateTime):Integer;
var
  contador:Integer;
  Feriados:TStrings;
begin
  if DT_Ini > DT_Fin then
  begin
    result  := 0;
    exit;
  end;
  Contador := 0;
  Feriados:=TStringList.Create;
  Feriados.Text := FeriadosFixos; //FeriadosFixos(FormatDateTime('yyyy', DT_Ini));
  while (DT_Ini <= DT_Fin) do
  begin
    if Feriados.IndexOf(DateToStr(DT_Ini)) = -1 then
      if ((DayOfWeek(DT_Ini) <> 1) and (DayOfWeek(DT_Ini) <> 7)) then
        Inc(Contador);
    DT_Ini := DT_Ini + 1;
  end;
  Result := Contador;
end;

Function ComputerIsOn:String;
Begin
  Result := SToHMS(GetTickCount64 div 1000);
End;

function SToHMS(I: Integer): String;
var
  H, M: Integer;
  Hs, Ms, Ss: String;
begin
  H := I div 3600; //horas completas
  I := I mod 3600; //segundos que sobraram das horas completas
  M := I div 60; //minutos completos
  I := I mod 60; //segundos que sobraram dos minutos completos
  if (H < 10) then
    Hs := '0' + IntToStr(H)
  else
    Hs := IntToStr(H);
  if (M < 10) then
    Ms := '0' + IntToStr(M)
  else
    Ms := IntToStr(M);
  if (I < 10) then
    Ss := '0' + IntToStr(I)
  else
    Ss := IntToStr(I);
  Result := Hs + ':' + Ms + ':' + Ss;
end;

function GetTickCount64: Int64;
var
  QFreq, QCount: Int64;
begin
  Result := GetTickCount;
  if QueryPerformanceFrequency(QFreq) then
  begin
    QueryPerformanceCounter(QCount);
    if QFreq <> 0 then
      Result := (QCount div QFreq) * 1000;
  end;
end;

function SoLetras(Value:Char):Boolean;
Begin
  Result:=  Value in ['a'..'z', 'A'..'Z',#8, #13];
End;

function SoNumeros(Value:Char):Boolean;
Begin
  Result:=  Value in ['1'..'1',#8, #13];
End;


Function  SoLetras(Texto: String):Boolean;
var Resultado:Boolean;
    nContador:Integer;
begin
  Resultado := true;
  For nContador:=1 to Length(Texto) do
    begin
      if Texto[nContador] in ['a'..'z','A'..'Z', ' '] then
      else
         Resultado := false;
    end;
    Result:=Resultado;
end;

function isKeyValid(Value:Char):Boolean;
Begin
  Result:=  Value in ['0'..'9', #8, #13, '.', '-', '/'];
End;

function IsPlaca(Value:String):Boolean;
Var
  aValue:String;
Begin
  Result:=False;
  aValue:=DelCharEspeciais(Value);
  if (Length(aValue)<>7) then
    Exit;
  if (not (aValue[1] in ['A'..'Z', 'a'..'z'])) or
     (not (aValue[2] in ['A'..'Z', 'a'..'z'])) or
     (not (aValue[3] in ['A'..'Z', 'a'..'z'])) or
     (not (aValue[4] in ['0'..'9'])) or
     (not (aValue[5] in ['0'..'9'])) or
     (not (aValue[6] in ['0'..'9'])) or
     (not (aValue[7] in ['0'..'9'])) then
    Exit;
  Result:=True;
end;

Function SearchParamStr(aValue:String):Boolean;
Var
  I:integer;
Begin
  Result:=False;
  For I:=1 to ParamCount do
   if UpperCase(ParamStr(I))= UpperCase(aValue) then
   Begin
     Result:=True;
     Exit;
   end;
end;

function DelChar(Str :string; aChar:Char):string;
Begin
  Result:=Str;
  while Pos(aChar, Result)> 0 do
    Delete(Result, Pos(aChar, Result), 1);
end;

function DelCharEspeciais(Str:String):string; // Deletea os caracteres especiais de uma string
Const
  fChar : array[0..16] of char = (',','''','$','&',';','.','-','/','(',')','\','|', '%', '[', ']', #13, #10);
Var
  I:Integer;
Begin
  Result:=Str;
  for I:= Low(fChar) to High(fChar) do
    Result:=DelChar(Result, fChar[I]);
end;

function MesAnterior:TDateTime;
Var
  Dia, Mes, Ano:word;
Begin
  Decodedate(Now, Ano, Mes, Dia);
  Dec(Mes);
  if Mes = 0 then
  Begin
    Mes :=12;
    Dec(Ano);
  end;
  Result:=EncodeDate(Ano, Mes,Dia);
end;

procedure NewCollor(Sender: TObject; fColor :TColor);
// Uses StdCtrls, Graphics
begin
{  if (LowerCase(Sender.ClassName) = 'tlabel') then
    TControl(Sender).Font.Color := fColor
  else
    TControl(Sender).Color := fColor;   }
end;

function StrToBool ( Valor : String) : Boolean;
begin  //  if Valor = '-1' then Result := True else Result := False;
  Result := Valor = '-1';
end;

function BoolToStr ( Valor : Boolean) : String;
begin
  Result := IntToStr(Ord(Valor));
end;

////////////////////////////////////////////////////////////////////////////////
procedure CriarFormModal(Formulario:TFormClass; fParent:TTabSheet; MenuItem:TMenuItem; FormName:String);
begin
  if MenuItem.Enabled then
  Begin
    if Assigned(Formulario) then
    Begin
      ArrayForms.Add(FormName);
      With Formulario.Create(fParent) do
      Begin
        Parent     := fParent;
        Align      := alClient;
        BorderStyle:= bsNone;
        Visible    := true;
      end;
    end;
  end;
end;

procedure CriarFormModal(Formulario:TFormClass; fParent:TTabSheet; FormName:String);
begin
  if Assigned(Formulario) then
  Begin
    ArrayForms.Add(FormName);
    With Formulario.Create(fParent) do
    Begin
      Parent     := fParent;
      Align      := alClient;
      BorderStyle:= bsNone;
      Visible    := true;
    end;
  end;
end;

function StrPasW(Const Data):WideString;
var
  FAddr: PWideChar;
Begin
  FAddr:=@Data;
  result:='';
  If FAddr<>NIl then
  Begin
    try
      repeat
        Result:=Result + FAddr^;
        inc(FAddr);
      Until FAddr^=#0000;
    except
      on exception do
        exit;
    end;
  end;
end;

function SubTime(fAddTime, TimeTotal:String):String;
Var // Faz o subtração entre horas
  Hor3, Min3, Seg3:Integer;
Begin
  Result:='';
  if (fAddTime<>'') and  (TimeTotal<>'') then
  Begin
    Hor3:= StrToInt(TokenN(TimeTotal,1,':')) - StrToInt(TokenN(fAddTime,1,':'));
    Min3:= StrToInt(TokenN(TimeTotal,2,':')) - StrToInt(TokenN(fAddTime,2,':'));
    Seg3:= StrToInt(TokenN(TimeTotal,3,':')) - StrToInt(TokenN(fAddTime,3,':'));
    //
    if Hor3<=0 then
      Dec(Min3);
    if Min3 <= -60 then
    Begin
      Min3 := (Min3 mod 60);
      Dec(Hor3, Min3 Div 60);
    end;
    if Seg3 <= -60 then
      Seg3 := (Seg3 mod 60);

    Result:=StrZero(Hor3, 2) + ':' + StrZero(Min3, 2) + ':' + StrZero(Seg3, 2);
  end;
end;

function AddTime(fAddTime, TimeTotal:String):String;
Var // Faz o somatório de horas
  Hor3, Min3, Seg3:Integer;
Begin
  Result := '';
  if (fAddTime<>'') and  (TimeTotal<>'') then
  Begin
    Hor3 := StrToInt(TokenN(fAddTime,1,':')) + StrToInt(TokenN(TimeTotal,1,':'));
    Min3 := StrToInt(TokenN(fAddTime,2,':')) + StrToInt(TokenN(TimeTotal,2,':'));
    Seg3 := StrToInt(TokenN(fAddTime,3,':')) + StrToInt(TokenN(TimeTotal,3,':'));
    if Seg3 >= 60 then
    Begin
      Seg3 := Seg3 - 60;
      Inc(Min3);
    end;
    if Min3 >= 60 then
    Begin
      Min3 := Min3 - 60;
      Inc(Hor3);
    end;
    Result := StrZero(Hor3, 2) + ':' + StrZero(Min3, 2) + ':' + StrZero(Seg3, 2);
  end;
end;

function StrZero(aNumber,aWidth:integer):string;
begin// Coloca Zeros a esquerda de uma string
  str(aNumber,result);
  while System.length(result)<aWidth do
    Insert('0',result,1);
end;

function StrZero(aNumber: String; aWidth: integer): string;
begin
  if Trim(aNumber)<>'' then
    Result:=StrZero(StrToInt(aNumber), aWidth);
end;

function ComplereTamanhoR(Value: String; aWidth: integer; Caractere:String='|'): string;
begin
  Result := Trim(Value);
//  if Trim(Result)<>'' then
    while System.length(result)<aWidth do
      Result := Result + Caractere;
end;

function ComplereTamanhoL(Value: String; aWidth: integer; Caractere:String='|'): string;
begin
  Result := Trim(Value);
 // if Trim(Result)<>'' then
    while System.length(result)<aWidth do
      Result := Caractere + Result;
end;

function HoraMiliSegundos(Hora: TDatetime): LongInt;
var
  Hor, Min, Sec, MSec: Word; //Ano, Mes, Dia,
begin
  DecodeTime(Hora, Hor, Min, Sec, MSec);
  HoraMiliSegundos:= MSec + (Sec * 1000) + (Min * 60000) + (Hor * 3600000);
end;

function MiliSegundosHora(MiliSegundo: LongInt): string;
var
  MSecut, Hrs, Minut, Secut: word;
begin
  Hrs         := MiliSegundo div 3600000;
  MiliSegundo := MiliSegundo mod 3600000;
  Minut       := MiliSegundo div 60000;
  MiliSegundo := MiliSegundo mod 60000;
  Secut       := MiliSegundo div 1000;
  MSecut      := MiliSegundo mod 1000;
  Result      := Format('%d:%d:%d', [Hrs, Minut, Secut]);
end;

function DataExtenso: String;
begin
  Result:=FormatDateTime('dddd ", " dd " de " mmmm " de " yyyy', Now);
end;

function MonthLastDay(Mdt: TDateTime) : TDateTime;
//retorna o ultimo dia o mes, de uma data fornecida
var
  ano, mes, dia : word;
  mDtTemp : TDateTime;
begin
  Decodedate(mDt, ano, mes, dia);
  mDtTemp:= (mDt - dia) + 33;
  Decodedate(mDtTemp, ano, mes, dia);
  Result := mDtTemp - dia;
end;

function FirstMonthDay(Mdt: TDateTime) : TDateTime;
//retorna o Primeiro dia o mes, de uma data fornecida
var
  ano, mes, dia : word;
begin
  Decodedate(mDt, ano, mes, dia);
  dia:=1;
  Result := EncodeDate(ano, mes, dia);;
end;

function PriorMonth:TDateTime;
Var
  Dia, Mes, Ano:word;
Begin
  Decodedate(Now, Ano, Mes, Dia);
  Dec(Mes);
  if Mes = 0 then
  Begin
    Mes :=12;
    Dec(Ano);
  end;
  Result:=EncodeDate(Ano, Mes,Dia);
end;

function _SubstChar (Value, Localizar, Substituir : string) : string;
var
  Retorno: String;
  Posicao: Integer;
begin
  Retorno := Value;
  While Pos(Localizar, Retorno)<>0 do
  Begin
    Posicao := Pos (Localizar, Retorno);
    if Posicao <> 0 then
    begin
      Delete(Retorno, Posicao, Length (Localizar));
      Insert(Substituir, Retorno , Posicao);
    end;
  end;
  Result := Retorno;
end;

function DeletarCharExpeciais(Value: String): String;
Var
  fValue:String;
begin
  fValue:=Trim(Value);
  While Pos('.',fValue)<>0 do Delete(fValue,Pos('.',fValue), 0);
  While Pos('/',fValue)<>0 do Delete(fValue,Pos('/',fValue), 0);
  While Pos('-',fValue)<>0 do Delete(fValue,Pos('-',fValue), 0);
  While Pos('_',fValue)<>0 do Delete(fValue,Pos('_',fValue), 0);
  Result:=fValue;
end;

function DeletarChar(Value, fCHAR: String): String;
begin
  Result:=StringReplace(Value,fCHAR,'',[rfReplaceAll, rfIgnoreCase]);
end;

function BoolToStr2(Bool:Boolean):String;
Const
   BoolStr:array[0..1] of string=('Não','Sim');
Begin
  Result:=BoolStr[Ord(Bool)];
end;

function BoolToStr2(Bool:Integer):String;
Const
   BoolStr:array[0..1] of string=('Não','Sim');
Begin
  Result:=BoolStr[Bool];
end;

function StrToBool1(Str:string):boolean;
Begin
  Result:=Str[1]='S';
end;

function BoolToStr1(Bool:Boolean):String;
Const
   BoolStr:array[0..1] of string=('False','True');

Begin
  Result:=BoolStr[Ord(Bool)];
end;

function Modulo11(aNumber:integer):integer;
begin
  result:=11-(aNumber-trunc(aNumber/11)*11);
  if result>9 then
    result:=0;
end;

function IsCpfCnpj(const aCode:string):boolean;
Var
  fCode:String;

Begin
  result:=False;
  fCode:=DeletarCharExpeciais(Trim(aCode));
  Case Length(fCode) of
    11:result:=IsCPF(fCode);
    14:result:=IsCnpj(fCode);
  end;
end;

function IsCnpj(const aCode:string):boolean;
var
  x,y,d1,d2:integer;
  sdg,dgg:string[2];
  fCode:String;
begin
  result:=false;
  fCode:=DeletarCharExpeciais(Trim(aCode));
  if Length(fCode)<>14 then
    exit;

  sdg:=aCode[13]+fCode[14];
  x:=StrToInt(Copy(fCode, 1,1))*5+
     StrToInt(Copy(fCode, 2,1))*4+
     StrToInt(Copy(fCode, 3,1))*3+
     StrToInt(Copy(fCode, 4,1))*2+
     StrToInt(Copy(fCode, 5,1))*9+
     StrToInt(Copy(fCode, 6,1))*8+
     StrToInt(Copy(fCode, 7,1))*7+
     StrToInt(Copy(fCode, 8,1))*6+
     StrToInt(Copy(fCode, 9,1))*5+
     StrToInt(Copy(fCode,10,1))*4+
     StrToInt(Copy(fCode,11,1))*3+
     StrToInt(Copy(fCode,12,1))*2;
  d1:=11-(x-(x div 11)*11);
  if d1>9 then
    d1:=0;
  y:=StrToInt(Copy(fCode, 1,1))*6+
     StrToInt(Copy(fCode, 2,1))*5+
     StrToInt(Copy(fCode, 3,1))*4+
     StrToInt(Copy(fCode, 4,1))*3+
     StrToInt(Copy(fCode, 5,1))*2+
     StrToInt(Copy(fCode, 6,1))*9+
     StrToInt(Copy(fCode, 7,1))*8+
     StrToInt(Copy(fCode, 8,1))*7+
     StrToInt(Copy(fCode, 9,1))*6+
     StrToInt(Copy(fCode,10,1))*5+
     StrToInt(Copy(fCode,11,1))*4+
     StrToInt(Copy(fCode,12,1))*3+
     StrToInt(Copy(fCode,13,1))*2;
  d2:=11-(y-(y div 11)*11);
  if d2>9 then
    d2:=0;
  dgg:=IntToStr(d1)+IntToStr(d2);
  Result:=(dgg=sdg);
end;

function IsCpf(const aCode:string):boolean;
var
  v,d1,d2:integer;
begin
  Result:=false;
  if Length(aCode)<>11 then
    exit;
  v:=StrToInt(aCode[1])*10+
     StrToInt(aCode[2])* 9+
     StrToInt(aCode[3])* 8+
     StrToInt(aCode[4])* 7+
     StrToInt(aCode[5])* 6+
     StrToInt(aCode[6])* 5+
     StrToInt(aCode[7])* 4+
     StrToInt(aCode[8])* 3+
     StrToInt(aCode[9])* 2;
  d1:=modulo11(v);
  if d1<>StrToInt(aCode[10]) then
    exit;
  v:=StrToInt(aCode[1])*11+
     StrToInt(aCode[2])*10+
     StrToInt(aCode[3])* 9+
     StrToInt(aCode[4])* 8+
     StrToInt(aCode[5])* 7+
     StrToInt(aCode[6])* 6+
     StrToInt(aCode[7])* 5+
     StrToInt(aCode[8])* 4+
     StrToInt(aCode[9])* 3+
     d1            * 2;
  d2:=modulo11(v);
  if d2<>StrToInt(aCode[11]) then
    exit;
  Result:=True;
end;

function DataExtensa(Data: TDateTime) : String;
Begin
  Result:=FormatDateTime('dd "de" mmmm "de" yyyy',Data);
end;

function IsDate(fDate:String):Boolean;
Begin // Verifica se a data é válida
  Result:=True;
  Try
    StrToDate(fDate);
  Except
    Result:=False;
  end;
end;

function IsIP(ip: string): Boolean;
var
   z:integer;
   i: byte;
   st: array[1..3] of byte;
const
   ziff = ['0'..'9'];
begin
   st[1] := 0;
   st[2] := 0;
   st[3] := 0;
   z     := 0;
   Result:= False;
   for i := 1 to Length(ip) do if ip[i] in ziff then
   else
   begin
      if ip[i] = '.' then
      begin
         Inc(z);
         if z < 4 then st[z] := i
         else
         begin
            IsIP := True;
            Exit;
         end;
      end
      else
      begin
         IsIP := True;
         Exit;
      end;
   end;
   if (z <> 3) or (st[1] < 2) or (st[3] = Length(ip)) or (st[1] + 2 > st[2])
or
     (st[2] + 2 > st[3]) or (st[1] > 4) or (st[2] > st[1] + 4) or (st[3] >
st[2] + 4) then
   begin
      IsIP := True;
      Exit;
   end;
   z := StrToInt(Copy(ip, 1, st[1] - 1));
   if (z > 255) or (ip[1] = '0') then
   begin
      IsIP := True;
      Exit;
   end;
   z := StrToInt(Copy(ip, st[1] + 1, st[2] - st[1] - 1));
   if (z > 255) or ((z <> 0) and (ip[st[1] + 1] = '0')) then
   begin
      IsIP := True;
      Exit;
   end;
   z := StrToInt(Copy(ip, st[2] + 1, st[3] - st[2] - 1));
   if (z > 255) or ((z <> 0) and (ip[st[2] + 1] = '0')) then
   begin
      IsIP := True;
      Exit;
   end;
   z := StrToInt(Copy(ip, st[3] + 1, Length(ip) - st[3]));
   if (z > 255) or ((z <> 0) and (ip[st[3] + 1] = '0')) then
   begin
      IsIP := True;
      Exit;
   end;
end;

function IsCNH(cnh: string): Boolean;
 function valida_new_cnh(cnh: String): Boolean;
 var
   Soma, Conta, Dv, Digito, i: Integer;
   CnhN: String;
   NumerosIguais: Boolean;
 begin
   Result := False;
   NumerosIguais := True;

   CnhN := FormatFloat('00000000000', StrToFloat(trim(cnh)));
   Soma := 0;

   {Validando se todos o números são iguais}
   for i := 1 to length(CnhN) - 1 do
     if CnhN[1] <> CnhN[i] then
       NumerosIguais := False;

   if NumerosIguais then
     Exit;

   for i := 1 to length(CnhN) - 2 do
     Soma := Soma + (StrtoInt(CnhN[i]) * (i + 1));

   Conta := (Soma div 11) * 11;
   if (Soma - Conta) < 2 then
     Dv := 0
   else
     Dv := 11 - (Soma - Conta);

   Digito := StrToInt(CnhN[10]);

   if Digito = Dv then
     Result := True;
 end;

function valida_old_cnh(cnh: String): Boolean;
 var
   Soma, Conta, Dv, Digito, i: Integer;
   CnhN: String;
   NumerosIguais: Boolean;
 begin
   Result := False;
   NumerosIguais := True;;

   CnhN := FormatFloat('000000000', StrToFloat(trim(cnh)));
   Soma := 0;

   {Validando se todos o números são iguais}
   for i := 1 to length(CnhN) - 1 do
     if CnhN[1] <> CnhN[i] then
       NumerosIguais := False;

   if NumerosIguais then
     Exit;

   for i := 1 to length(CnhN) - 1 do
     Soma := Soma + (StrtoInt(CnhN[i]) * (i + 1));

   Digito := StrToInt(CnhN[9]);
   Conta := Soma mod 11;

   if Conta = 10 then
     Conta := 0;

   if Digito = Conta then
     result := True;
 end;
begin
 result := (valida_new_cnh(cnh) or valida_old_cnh(cnh));
end;

function IsRenavam(Num: String):Boolean;
const SEQUENCIA = '3298765432';
var I,SOMA,DV : INTEGER;
begin
  Result := False;
  if Length(Num) = 11 then
  begin
    SOMA := 0;
    FOR I := 1 TO 10 DO
      SOMA := SOMA + (StrToInt(Num[I]) * StrToInt(SEQUENCIA[I]));
    DV := (SOMA * 10) MOD 11;
    if DV = 10 then DV := 0;
    if DV = StrToInt(Num[11]) THEN
      Result := True;
  end;
end;

function IsNum(Value: String): Boolean;
begin
  Result:=True;
  Try
    StrToInt(Value);
  Except
    Result:=False;
  End;
end;

function IsTituloEleitor(NumTitulo: string): Boolean;
var
  i, Soma : integer;
  sTitulo: string;
  Resto, Dig1, Dig2 : double;
begin
  sTitulo := '';
  for i := 1 to Length(NumTitulo) do
    if (Copy(NumTitulo,i,1) >= '0') and (Copy(NumTitulo,i,1) <= '9') then
      sTitulo := sTitulo + Copy(NumTitulo,i,1);
  sTitulo := FormatFloat('0000000000000', StrToFloat(sTitulo));
  Soma := StrToInt(sTitulo[1]) * 2 +
  StrToInt(sTitulo[2]) * 9 +
  StrToInt(sTitulo[3]) * 8 +
  StrToInt(sTitulo[4]) * 7 +
  StrToInt(sTitulo[5]) * 6 +
  StrToInt(sTitulo[6]) * 5 +
  StrToInt(sTitulo[7]) * 4 +
  StrToInt(sTitulo[8]) * 3 +
  StrToInt(sTitulo[9]) * 2 ;
  Resto := Soma mod 11;

  if (Resto = 0) or (Resto = 1) then
  begin
    if (Copy(sTitulo,10,2) = '01') or (Copy(sTitulo,10,2) = '02') then
    begin
      if Resto = 0 then
        Dig1 := 1
      else
        Dig1 := 0;
    end
    else
      Dig1 := 0
  end
  else
    Dig1 := 11 - Resto;

  Soma := StrToInt(FloatToStr((StrToInt(sTitulo[10]) * 4) +
  (StrToInt(sTitulo[11]) * 3) + (Dig1 * 2)));
  Resto := Soma mod 11;

  if (Resto = 0) or (Resto = 1) then
  begin
    if (Copy(sTitulo,10,2) = '01') or (Copy(sTitulo,10,2) = '02') then
    begin
      if Resto = 0 then
        Dig2 := 1
      else
        Dig2 := 0;
    end
    else
      Dig2 := 0;
  end
  else
    Dig2 := 11 - Resto;
  if (StrToInt(sTitulo[12]) > Dig1) or (StrToInt(sTitulo[13]) > Dig2) then
    Result := False
  else
    Result := True;
end;

function IsIE(UF, IE: string): boolean;
Const
  //Define Peso1 e peso2 com os pesos para o calculo do
  //1o. digito e 2o. Digito
  Peso1 : array[1..8] of Integer = (1,3,4,5,6,7,8,10);
  Peso2 : array[1..11] of Integer = (3,2,10,9,8,7,6,5,4,3,2);
Var
  tmp,soma,dig1,dig2 : Integer;
  FimIE : String;
begin
  Soma := 0;
  tmp  := 0;  //Zera todas as variaveis
  dig1 := 0;
  dig2 := 0;
  FimIE := '';
  If upperCase(uf) = 'SP' Then
  Begin
    //Vamos achar o valor do 1o. digito
    for tmp := 1 to 8 do
      Soma := Soma + ( StrToInt(ie[tmp]) * Peso1[tmp]);

    Dig1 := Soma mod 11;  //Grava o resto da divisão de soma por 11
    if (Dig1 >= 10) Then
      Dig1 := 0;

    //faz a junção dos 8 primeiros numeros com o digito encontrado,
    //apartir desse ponto acharemos o segundo digito.
    FimIE := Copy(Ie,1,8) + IntToStr(Dig1) +  Copy(Ie,10,2);
    Soma := 0;

    For tmp := 1 To 11 Do
      Soma := Soma + ( StrToInt( FimIE[tmp] ) * Peso2[tmp] );
    Dig2 := Soma mod 11;
    If Dig2 >= 10 Then
      Dig2 := 0;

    //Faz a junção do 2o. digito
    FimIE := FimIE + Inttostr(Dig2);
    If FimIE = IE Then
      Result := True
    else
      Result := False;
  End;
end;

function IsTitulo(numero: String): Boolean;
var //http://www.activedelphi.com.br/modules.php?op=modload&name=News&file=article&sid=733
  intInd1,intInd2,intLimite    : Integer;
  intSoma,intDigito            : Integer;
  strDVc,strSequencial         : String;
  strUF,strDV1,strDV2          : String;
begin
  numero := Trim(numero);
  while (Length(numero) < 13) do  numero := '0' + numero;
  intInd1 := 0; intInd2 := 0; strDVc := '';
  strSequencial := Copy(numero,1,9);
  strUF  := Copy(numero,10,2);
  strDV1 := Copy(numero,12,1);
  strDV2 := Copy(numero,13,1);
  {Verifca se a UF estiver entre os código possíveis, de 1(SP) até 28(ZZ-Exterior)}
  if ((StrToInt(strUF) >  0) and (StrToInt(strUF) < 29)) then
  begin
   intLimite := 9;
   {Loop para calcular os 2 dígitos verificadores}
   for intInd1 := 1 to 2 do
   begin
     intSoma := 0;
     {Calcula a soma para submeter ao módulo 11}
     for intInd2 := 1 to intLimite do
     begin
      intSoma := intSoma + StrToInt(Copy(strSequencial,intInd2,1)) * (intLimite + 2 - intInd2);
     end;
     {Pega o resto da dívisão, o módulo, por 11}
     intDigito := intSoma mod 11;
     { Se a UF for SP ou MG}
     if  (StrToInt(strUF) in [1,2]) then
     begin
       if (intDigito = 1) then  intDigito := 0
       else if (intDigito = 0) then intDigito := 1
       else intDigito := 11 - intDigito;
     end
     { Outros UF e Exterior}
     else begin
       if ((intDigito = 1) or (intDigito = 0)) then intDigito := 0
       else intDigito := 11 - intDigito;
     end;
     {Atribui à variavel strDVc o dígito calculado}
     strDVc := strDVc + IntToStr(intDigito);
     {Muda o valor de intLimite para o cáculo do segundo dígito}
     intLimite:= 3;
     {O cálculo do segundo dígito será sobre o código da UF + primeiro dígito verificador}
     strSequencial:= strUF + IntToStr(intDigito);
   end;
  end;
  result := (strDV1+strDV2 = strDVc);
end;

Function IsEMail(Value: String):Boolean;
  function CheckAllowed(const s: string): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    for i := 1 to Length(s) do
      if not(s[i] in ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '_', '-', '.']) then
        Exit;
    Result := true;
  end;
var
  i: Integer;
  NamePart, ServerPart: string;
begin
  Result := False;
  i := Pos('@', Value);
  if i = 0 then
    Exit;
  NamePart := Copy(Value, 1, i - 1);
  ServerPart := Copy(Value, i + 1, Length(Value));
  if (Length(NamePart) = 0) or ((Length(ServerPart) < 5)) then
    Exit;
  i := Pos('.', ServerPart);
  if (i = 0) or (i > (Length(ServerPart) - 2)) then
    Exit;
  Result := CheckAllowed(NamePart) and CheckAllowed(ServerPart);
end;
////////////////////////////////////////////////////////////////////////////////
procedure CriarFormModal(Formulario:TFormClass);
Begin
  Try
    ProcessMessages;
    Try
      Formulario.Create(Application).ShowModal;
    Finally
      FreeAndNil(Formulario);
    end;
  except
   //
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure _RegisterClass(AClass: TPersistentClass);
begin
  Classes.RegisterClass(AClass);
end;

procedure ProcessMessages;
Begin
  if Application<>nil then
    Application.ProcessMessages;
end;

function Empty(const aString:string):boolean;
begin
  result:=(Trim(aString)='');
end;

function TokenN(const aTokenList:string; aIndex:integer; aTokenSeparator:char='|'):string;
var
  i,m,count:integer;
begin
  Result:='';
  count:=0;
  i:=1;
  while i<=Length(aTokenList) do
  begin
    m:=i;
    while (i<=Length(aTokenList)) and (aTokenList[i]<>aTokenSeparator) do
      Inc(i);
    inc(count);
    if count=aIndex then
    begin
      Result:=Copy(aTokenList,m,i-m);
      break;
    end;
    Inc(i);
  end;
end;

function CountToken(const aTokenList:string; aTokenSeparator:char='|'):Integer;
var
  i:integer;
begin
  Result:=0;
  i:=1;
  while i<=Length(aTokenList) do
  begin
    if aTokenList[i] = aTokenSeparator then Inc(Result);
    Inc(i);
  end;
end;

function CustomMessage(const strCaption, Msg: string; AType: TMsgDlgType; AButtons: TMsgDlgButtons; DefButton : TModalResult; HelpCtx: Longint): Word;
var
  i : Integer;
begin
  with CreateMessageDialog(Msg,AType,AButtons) do
  Begin
    try
      HelpContext := HelpCtx;
      Caption := strCaption;
      //if Width<150 then Width := 150;
      for i := 0 to ComponentCount - 1 do
      begin
        if (Components[i] is TLabel) then TLabel(Components[i]).Top := 20;

        if (Components[i] is TButton) then
        begin
          with TButton(Components[i]) do
          Begin
            case ModalResult of
              mrYes    : Caption := '&Sim';
              mrNo     : Caption := 'Não';
              mrCancel : Caption := '&Cancelar';
              mrAbort  : Caption := 'Abortar';
              mrRetry  : Caption := 'Tentar';
              mrIgnore : Caption := 'Ignorar';
              mrAll    : Caption := 'Todos';
            end;
          end;
          if (TButton(Components[i]).ModalResult = DefButton) then ActiveControl := TButton(Components[i]);
        end;
      end;
      Result := ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure Warning(Msg:string);
Begin
  CustomMessage('Atenção', Msg, mtInformation, [mbOk], mrOk, 0);
end;

procedure DisplayError(Msg:string);
Begin
  CustomMessage('Erro', Msg, mtError, [mbOk], mrOk, 0);
end;

function Confirm(Msg:string; DefaultButton:TModalResult=mrNo):Boolean;
Begin
  Result := MessageDlg(Msg, mtConfirmation, mbYesNo, 0)=mrYes;
end;

procedure NewException(ErrorMsg:string);
Begin
  raise Exception.Create(ErrorMsg);
end;

function QuitApplication:Boolean;
Begin
  Result := Confirm('Deseja encerrar a aplicação?');
end;

function InputString(const ACaption, APrompt, ADefault: string): string;
function InputQuery(const ACaption, APrompt: string; var Value: string): Boolean;
var
  W: TForm;
  Edit: TEdit;
  L: TLabel;
  OKButton,CancelButton: TBitBtn;
begin
  Result := False;
  W := TForm.Create(Application);
  try
    with W do
    begin
      BorderStyle := bsDialog;
      // Ctl3D := True;
      Width       := 280;
      Height      := 160;
      Caption     := ACaption;
      Font.Name   := 'MS Sans Serif';
      Position    := poScreenCenter;
      L           := TLabel.Create(W);
      with L do
      begin
        Parent   := W;
        AutoSize := True;
        Left     := 10;
        Top      := 10;
        Caption  := APrompt;
      end;

      Edit := TEdit.Create(W);
      with Edit do
      begin
        Parent    := W;
        Left      := 10;
        Top       := L.Top + L.Height + 5;
        Width     := W.ClientWidth - 20;
        MaxLength := 255;
        Text      := Value;
        SelectAll;
      end;
      L.FocusControl := Edit;

      OKButton := TBitBtn.Create(W);
      with OKButton do
      begin
        Parent := W;
        Kind   := bkOK;
        //Style := bsAutoDetect;
        Top    := Edit.Top + Edit.Height + 10;
        Width  := 77;
        Height := 27;
        Left   := (W.ClientWidth div 2) - (((OKButton.Width * 2) + 10) div 2)
      end;

      CancelButton := TBitBtn.Create(W);
      with CancelButton do
      begin
        Parent  := W;
        Kind    := bkCancel;
        Caption := 'Cancelar';
        // Style := bsAutoDetect;
        Top     := OKButton.Top;
        Width   := 77;
        Height  := 27;
        Left    := OKButton.Left + OKButton.Width + 10;
      end;
      ClientHeight := OKButton.Top + OKButton.Height + 10;
    end;
    if W.ShowModal = mrOK then
    begin
      Result := True;
      Value  := Edit.Text;
    end;
  finally
    FreeAndNil(W);
  end;
end;

var
  S: string;
begin
  S := ADefault;
  if InputQuery(ACaption, APrompt, S) then
    Result := S
  else
    Result := ADefault;
end;
////////////////////////////////////////////////////////////////////////////////
procedure CentralizedComponent(Component, Owner: TControl; const Horz, Vert: byte);
{ Horz: 1=esquerda, 2=centro, 3=direita
  Vert: 1=topo,     2=centro, 3=em baixo }
var
  R: TRect;
begin
  R := Rect(0, 0, Owner.Width, Owner.Height);
  with Component do
    case Horz of
      1: Component.Left := 0;
      2: Component.Left := (R.Right - R.Left - Width) div 2;
      3: Component.Left := R.Right - Width;
    end;
  with Component do
    case Vert of
      1: Component.Top := 0;
      2: Component.Top := (R.Bottom - R.Top - Height) div 2;
      3: Component.Top := R.Bottom - Height;
    end;
end;

procedure CentralizedComponent(Component: TControl);
begin
  CentralizedComponent(Component, TControl(Component.Owner), 2, 2);
end;

procedure CentralizedComponentHorz(Component: TControl; const Horz: byte);
begin
  CentralizedComponent(Component, TControl(Component.Owner), Horz, 0);
end;

procedure CentralizedComponentVert(Component: TControl; const Vert: byte);
begin
  CentralizedComponent(Component, TControl(Component.Owner), 0, Vert);
end;

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
Const
{$ifdef Linux}
  DirectorySeparator = '/';
{$else}
  DirectorySeparator = '\';
{$endif}

var
  L:Integer;
begin
  Result := aFolder;
  L := Length(Result);
  if L > 0 then
    if Result[L] <> DirectorySeparator then
      Result:= Result + DirectorySeparator;
end;

function HomeDir:String;
Begin
  Result:=BackSlashed(ExtractFilePath(ParamStr(0)));
end;

function Idade(DataNasc:String):string;
begin
  Result := Idade(DataNasc, Now);
end;

function Idade(DataNasc:String; dtAtual:TDate):string;
Var
  Dia1, Mes1, Ano1, Dia2, Ano2, Mes2 :word;
begin
  Result:='0';
  if DataNasc = '' then
    Exit;
  if not IsDate(DataNasc) then
    Exit;
  DecodeDate(Now, Ano2,Mes2, Dia2);
  DecodeDate(StrToDateTime(DataNasc), Ano1,Mes1, Dia1);

  if (Dia2 >= Dia1) and (Mes2 = Mes1) and (Ano1 < Ano2) then
    Dec(Ano1);

  //
  if Dia2 > 1 then
    Dec(Mes2)
  else
  begin
    Mes2:=12;
    Dec(Ano2);
  end;
  //
  if Mes2 < Mes1 then
  begin
    Dec(Ano2);
    Inc(Mes2,12);
  end;
  //
  if Ano2-Ano1<0 then
    Result:='0'
  else
    Result:=IntToStr(Ano2-Ano1);
end;

function Soundex(S:String):String;
Var
  I,P:Integer;
  C,N:AnsiChar;
  Procedure AppendChar(c:Ansichar);
  Begin
    If (Length(Result)>0) and (C in (Vogal+[' '])) and (C = String(Result[Length(Result)])) then
      Exit;
    Result:=String(Result+C);
  end;

  Procedure AppendString(const s:string);
  Var
    I:integer;
  Begin
    For I:=1 to Length(S) do
     AppendChar(AnsiChar(s[i]));
  end;

Begin
  Result:='';
  For I:=1 to Length(S) do
  begin
    P:=Pos(S[I],Acents1);
    If P>0 then
      S[I]:=Char(Acents2[P])
    else
      S[I]:=UpCase(S[I]);
  end;
  I:=1;
  While I<=Length(S) do
  Begin
    c:=AnsiChar(s[i]);
    if i<length(s) then
      n:=AnsiChar(s[i+1])
    else
      n:=#32;
    if c in Numeric then
      AppendChar(c)
    else if C in Alpha then
      Case C of
        'B',
        'C',
        'D',
        'F',
        'G',
        'J',
        'K',
        'L',
        'P',
        'Q',
        'R',
        'T': Begin
               If n='U' then
                 If c in ['Q','G'] then
                   n:='I';
               case c of
                 'C',
                 'K',
                 'Q': c:='S';
                 'G': c:='J';
                 'L': c:='U';
                 'P': if n='H' then
                        c:='F'
                      else
                        c:='B';
               end;
               AppendChar(c);
               If N in (SomI+['H']) then
                 Inc(I);
             end;
        'E',
        'Y',
        'I': begin
               if N='S' then
               begin
                 C:='S';
                 Inc(I);
               end else
                 c:='I';
               AppendChar(c);
             end;
        'H':;
        'N': AppendChar('M');
        'V',
        'W': AppendChar('U');
        'X',
        'Z': AppendChar('S');
        '-',
        '_':;
      else
        AppendChar(C);
      end
    else
      AppendChar(#32);
    Inc(I);
  end;
end;

procedure IniciarVariaveisDeAmbiente;
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
End;

procedure Create;
begin
  fForm            := nil;
  ArrayForms       := TStringList.Create;
  FileNameConf     := HomeDir+'Config.conf';
  Feriados         := TStringList.Create;  // em fase de teste 23/12/2014
  FeriadosFixos(FormatDateTime('yyyy', now));
  //
  IniciarVariaveisDeAmbiente;
  //
  //LoadConfig;
  //fCompletion      :=TStringList.Create;
end;

procedure Destroy;
begin
  fForm:=nil;
end;

Initialization
  Create;

Finalization
  Destroy;

end.
