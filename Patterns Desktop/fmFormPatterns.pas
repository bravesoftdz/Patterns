unit fmFormPatterns;

interface

uses
  KrUtil,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TfrmFormPatterns = class(TForm)
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    function DelCharEspeciais(Str:String):string;
    function Idade(DataNasc:String):string; Overload;
    function Idade(DataNasc:String; dtAtual:TDate):string; Overload;
    procedure OpenURL(URL:String);
    procedure OpenURLWindow(URL:String);
    function Confirm(msg: String): Boolean;
    function Soundex(S: String): String;
    procedure Warning(msg: String);
    procedure DisplayError(Msg:string); // Mensagem de dialog de erro
    Procedure AddFeriados(Data:String);
    function Criptografar(wStri: String): String;
    function GeraSenha(n: integer): String;
    function GerarNomeArquivo:String;
    //
    // Validação
    function IsEMail(eMail: String): boolean;
    function isKeyValid(Value:Char):Boolean;
    function IsCnpj(const aCode:string):boolean; //Retorna verdadeiro se aCode for um CNPJ válido
    function IsCpf(const aCode:string):boolean; //Retorna verdadeiro se aCode for um CPF válido
    function IsCpfCnpj(const aCode:string):boolean;//Retorna verdadeiro se aCode for um CPF ou CNPJ válido
    function IsDate(fDate:String):Boolean; // verifica se uma determinada data é válida ou não
    function IsPlaca(Value:String):Boolean; // Faz a validação de uma placa de automóvel
    function IsTitulo(numero: String): Boolean; // Validação de titulo de eleitor
    function IsIP(IP: string): Boolean; // Verifica se o IP inofmado é válido
    function IsIE(UF, IE: string): boolean;
    function BoolToStr2(Bool:Boolean):String; overload;// Converte o valor de uma variável booleana em String
    function BoolToStr2(Bool:Integer):String; overload;
    function IsTituloEleitor(NumTitulo: string): Boolean; // Valida Título de Eleitor

    // Date e Time
    function Dias_Uteis(DT_Ini, DT_Fin:TDateTime):Integer;
    function GetDataNula: String;
    function GetWhere(Value: TStrings): String;
    function StrToBool1(Str: string): boolean;
    procedure CentralizedComponent(Component: TControl);
    procedure ComponentPos(Component, Owner: TControl; const Horz, Vert: byte);
    { Private declarations }
  public
    property DataNula :String read GetDataNula;
    { Public declarations }
  end;

var
  frmFormPatterns: TfrmFormPatterns;

implementation

{$R *.dfm}

procedure TfrmFormPatterns.CentralizedComponent(Component: TControl);
begin
  KrUtil.CentralizedComponent(Component);
end;

procedure TfrmFormPatterns.ComponentPos(Component, Owner: TControl; const Horz,
  Vert: byte);
begin
  KrUtil.ComponentPos(Component, Owner, Horz, Vert);
end;

function TfrmFormPatterns.Confirm(msg:String):Boolean;
Begin
  KrUtil.Confirm(Msg);
End;

procedure TfrmFormPatterns.Warning(msg:String);
Begin
  KrUtil.Warning(msg);
End;

procedure TfrmFormPatterns.AddFeriados(Data: String);
begin
  KrUtil.AddFeriados(Data);
end;

function TfrmFormPatterns.BoolToStr2(Bool: Integer): String;
begin
  Result:=KrUtil.BoolToStr2(Bool);
end;

function TfrmFormPatterns.Criptografar(wStri: String): String;
begin
  Result := krUtil.Criptografar(wStri);
end;

procedure TfrmFormPatterns.FormCreate(Sender: TObject);
begin
  KrUtil.Create;
end;

function TfrmFormPatterns.DelCharEspeciais(Str: String): string;
begin
  Result := KrUtil.DelCharEspeciais(Str);
end;

function TfrmFormPatterns.Dias_Uteis(DT_Ini, DT_Fin: TDateTime): Integer;
begin
  Result := KrUtil.Dias_Uteis(DT_Ini, DT_Fin);
end;

procedure TfrmFormPatterns.DisplayError(Msg: string);
begin
  KrUtil.DisplayError(Msg);
end;

function TfrmFormPatterns.GerarNomeArquivo: String;
begin
  Result:=krUtil.GerarNomeArquivo;
end;

function TfrmFormPatterns.GeraSenha(n: integer): String;
begin
  Result:=krUtil.GeraSenha(n);
end;

function TfrmFormPatterns.GetDataNula: String;
begin
  Result:=krUtil.DataNula;
end;

function TfrmFormPatterns.GetWhere(Value: TStrings): String;
begin
  Result:=KrUtil.GetWhere(Value);
end;

function TfrmFormPatterns.Soundex(S: String): String;
begin
  Result:=KrUtil.Soundex(S);
end;

function TfrmFormPatterns.StrToBool1(Str: string): boolean;
begin
  Result:=KrUtil.StrToBool1(Str);
end;

function TfrmFormPatterns.BoolToStr2(Bool:Boolean):String;
Begin
  Result:=KrUtil.BoolToStr2(Bool);
End;

function TfrmFormPatterns.Idade(DataNasc: String): string;
begin
  Result:=KrUtil.Idade(DataNasc);
end;

function TfrmFormPatterns.Idade(DataNasc: String; dtAtual: TDate): string;
begin
  Result:=KrUtil.Idade(DataNasc, dtAtual);
end;

function TfrmFormPatterns.IsCnpj(const aCode: string): boolean;
begin
  Result:=KrUtil.IsCnpj(aCode);
end;

function TfrmFormPatterns.IsCpf(const aCode: string): boolean;
begin
  Result:=KrUtil.IsCpf(aCode);
end;

function TfrmFormPatterns.IsCpfCnpj(const aCode: string): boolean;
begin
  Result:=KrUtil.IsCpfCnpj(aCode);
end;

function TfrmFormPatterns.IsDate(fDate: String): Boolean;
begin
  Result:=KrUtil.IsDate(fDate);
end;

function TfrmFormPatterns.IsEMail(eMail: String): boolean;
begin
  Result:=KrUtil.IsEMail(eMail);
end;

function TfrmFormPatterns.IsIE(UF, IE: string): boolean;
begin
  Result:=KrUtil.IsIE(UF, IE);
end;

function TfrmFormPatterns.IsIP(IP: string): Boolean;
begin
  Result:=KrUtil.IsIP(IP);
end;

function TfrmFormPatterns.isKeyValid(Value: Char): Boolean;
begin
  Result:=KrUtil.isKeyValid(Value);
end;

function TfrmFormPatterns.IsPlaca(Value: String): Boolean;
begin
  Result:=KrUtil.IsPlaca(Value);
end;

function TfrmFormPatterns.IsTitulo(numero: String): Boolean;
begin
  Result:=KrUtil.IsTitulo(numero);
end;

function TfrmFormPatterns.IsTituloEleitor(NumTitulo: string): Boolean;
begin
  Result := KrUtil.IsTituloEleitor(NumTitulo);
end;

procedure TfrmFormPatterns.OpenURL(URL: String);
begin

end;

procedure TfrmFormPatterns.OpenURLWindow(URL: String);
begin

end;

procedure TfrmFormPatterns.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

end.
