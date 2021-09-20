unit fmFormPatterns2;
 { Masked input plugin
 http://forums.unigui.com/index.php?/topic/4523-masked-input-plugin/?hl=format#entry22465
 }

interface

uses
  KrUtil,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm, uniDBEdit,
  uniGUIBaseClasses, uniEdit, uniDBLookupComboBox, uniDBDateTimePicker,
  UniDateTimePicker ;

type
  TfrmFormPatterns2 = class(TUniForm)
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormKeyPress(Sender: TObject; var Key: Char);
    procedure UniFormShow(Sender: TObject);
  private
    function GetDataNula: String;
    procedure AddEditLookpCombobox;
    { Private declarations }
  public
    Const
      MaskFone  :String='(99)9999-9999';      // Fone
      MaskDate  :String='99/99/9999';         // Data
      MaskTime  :String='99:99';              // Hora
      MaskCPF   :String='999.999.999-99';     // CPF
      MaskPlaca :String='aaa-9999';           // Placa de Autovóvel
      MaskIPol  :String='999-9999/9999';       // inquérito Policial
      MaskIP    :String='9999.9999.9999.9999';// IP de computador
      MaskCNPJ  :String='99.999.999/9999-99';  // CNPJ

      ResultCPF:String='___.___.___-__' ;


    function DelCharEspeciais(Str:String):string;
    function Idade(DataNasc:String):string; Overload;
    function Idade(DataNasc:String; dtAtual:TDate):string; Overload;
    procedure OpenURL(URL:String);
    procedure OpenURLWindow(URL:String);
    procedure AddMask(Edit: TUniDBEdit; Mask: String); Overload;  // Adiciona mascara
    procedure AddMask(Edit: TUniEdit; Mask: String); Overload;    // Adiciona mascara
    procedure AddMask(Edit: TUniDBDateTimePicker; Mask:String); Overload; // Adiciona mascara
    procedure AddMask(Edit: TUniDateTimePicker; Mask:String);  Overload; // Adiciona mascara
    procedure AddMaskDate;
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
    property DataNula :String read GetDataNula;
    function IsTituloEleitor(NumTitulo: string): Boolean; // Valida Título de Eleitor

    // Date e Time
    function Dias_Uteis(DT_Ini, DT_Fin:TDateTime):Integer;
    { Public declarations }
    Function GetWhere(Value:TStrings):String;

    function StrToBool1(Str:string):boolean;
  end;

function frmFormPatterns2: TfrmFormPatterns2;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function frmFormPatterns2: TfrmFormPatterns2;
begin
  Result := TfrmFormPatterns2(UniMainModule.GetFormInstance(TfrmFormPatterns2));
end;

procedure TfrmFormPatterns2.OpenURLWindow(URL:String);
Begin
  if Trim(URL) <> '' then
    UniSession.AddJS('window.open("'+URL+'", "janela", "directories=no, resizable=no, scrollbars=no, status=no, location=no, toolbar=no, menubar=no, scrollbars=yes, resizable=no, fullscreen=no")');
End; //http://www.guj.com.br/10470-esconder-urllink-da-barra-do-navegador-ou-a-propria-barra-de-nagegacao

procedure TfrmFormPatterns2.OpenURL(URL:String);
Begin
  if Trim(URL) <> '' then
    UniSession.AddJS('window.open("'+URL+'")');
End;

function TfrmFormPatterns2.DelCharEspeciais(Str: String): string;
begin
  Result := KrUtil.DelCharEspeciais(Str);
end;

function TfrmFormPatterns2.Dias_Uteis(DT_Ini, DT_Fin: TDateTime): Integer;
begin
  Result := KrUtil.Dias_Uteis(DT_Ini, DT_Fin);
end;

procedure TfrmFormPatterns2.DisplayError(Msg: string);
begin
  MessageDlg(Msg, mtError, [mbOk]);
end;

function TfrmFormPatterns2.GerarNomeArquivo: String;
begin
  Result:=krUtil.GerarNomeArquivo;
end;

function TfrmFormPatterns2.GeraSenha(n: integer): String;
begin
  Result:=krUtil.GeraSenha(n);
end;

function TfrmFormPatterns2.GetDataNula: String;
begin
  Result:=krUtil.DataNula;
end;

function TfrmFormPatterns2.GetWhere(Value: TStrings): String;
begin
  Result:=KrUtil.GetWhere(Value);
end;

function TfrmFormPatterns2.Soundex(S: String): String;
begin
  Result:=KrUtil.Soundex(S);
end;

function TfrmFormPatterns2.StrToBool1(Str: string): boolean;
begin
  Result:=KrUtil.StrToBool1(Str);
end;

procedure TfrmFormPatterns2.UniFormCreate(Sender: TObject);
begin
  KrUtil.Create;
end;

procedure TfrmFormPatterns2.UniFormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    Close;
end;

procedure TfrmFormPatterns2.UniFormShow(Sender: TObject);
begin
  AddMaskDate;
  AddEditLookpCombobox;
end;

function TfrmFormPatterns2.BoolToStr2(Bool:Boolean):String;
Begin
  Result:=KrUtil.BoolToStr2(Bool);
End;

function TfrmFormPatterns2.Idade(DataNasc: String): string;
begin
  Result:=KrUtil.Idade(DataNasc);
end;

function TfrmFormPatterns2.Idade(DataNasc: String; dtAtual: TDate): string;
begin
  Result:=KrUtil.Idade(DataNasc, dtAtual);
end;

function TfrmFormPatterns2.IsCnpj(const aCode: string): boolean;
begin
  Result:=KrUtil.IsCnpj(aCode);
end;

function TfrmFormPatterns2.IsCpf(const aCode: string): boolean;
begin
  Result:=KrUtil.IsCpf(aCode);
end;

function TfrmFormPatterns2.IsCpfCnpj(const aCode: string): boolean;
begin
  Result:=KrUtil.IsCpfCnpj(aCode);
end;

function TfrmFormPatterns2.IsDate(fDate: String): Boolean;
begin
  Result:=KrUtil.IsDate(fDate);
end;

function TfrmFormPatterns2.IsEMail(eMail: String): boolean;
begin
  Result:=KrUtil.IsEMail(eMail);
end;

function TfrmFormPatterns2.IsIE(UF, IE: string): boolean;
begin
  Result:=KrUtil.IsIE(UF, IE);
end;

function TfrmFormPatterns2.IsIP(IP: string): Boolean;
begin
  Result:=KrUtil.IsIP(IP);
end;

function TfrmFormPatterns2.isKeyValid(Value: Char): Boolean;
begin
  Result:=KrUtil.isKeyValid(Value);
end;

function TfrmFormPatterns2.IsPlaca(Value: String): Boolean;
begin
  Result:=KrUtil.IsPlaca(Value);
end;

function TfrmFormPatterns2.IsTitulo(numero: String): Boolean;
begin
  Result:=KrUtil.IsTitulo(numero);
end;

function TfrmFormPatterns2.IsTituloEleitor(NumTitulo: string): Boolean;
begin
  Result := KrUtil.IsTituloEleitor(NumTitulo);
end;

procedure TfrmFormPatterns2.AddMaskDate;
Var
  I:Integer;
begin // Adiciona mascara do componente informado
  For I:=0 to ComponentCount - 1 do
    if lowercase(Components[I].ClassName) = 'tunidbdatetimepicker' then
      AddMask(TUniDBDateTimePicker(Components[I]), MaskDate);
end;

procedure TfrmFormPatterns2.AddMask(Edit: TUniDBDateTimePicker; Mask:String);
begin // Uses uniDBDateTimePicker
  Edit.ClientEvents.ExtEvents.Add
  ('Onfocus=function function focus(sender, the, eOpts)'+
  ' { $("#"+sender.id+"-inputEl").mask("'+Mask+'"); }');
end;

procedure TfrmFormPatterns2.AddMask(Edit: TUniDateTimePicker; Mask:String);
begin // Uses uniDBDateTimePicker
  Edit.ClientEvents.ExtEvents.Add
  ('Onfocus=function function focus(sender, the, eOpts)'+
  ' { $("#"+sender.id+"-inputEl").mask("'+Mask+'"); }');
end;

procedure TfrmFormPatterns2.AddMask(Edit: TUniDBEdit; Mask:String);
begin
  Edit.ClientEvents.ExtEvents.Add
  ('Onfocus=function function focus(sender, the, eOpts)'+
  ' { $("#"+sender.id+"-inputEl").mask("'+Mask+'"); }');
end;

procedure TfrmFormPatterns2.AddMask(Edit: TUniEdit; Mask:String);
begin
  Edit.ClientEvents.ExtEvents.Add
  ('Onfocus=function function focus(sender, the, eOpts)'+
  ' { $("#"+sender.id+"-inputEl").mask("'+Mask+'"); }');
end;

procedure TfrmFormPatterns2.AddEditLookpCombobox;
Var
  I:Integer;
begin // Uses uniDBLookupComboBox
  For I:=0 to ComponentCount - 1 do
    if lowercase(Components[I].ClassName) = 'tunidblookupcombobox' then
      TUniDBLookupComboBox(Components[I]).ClientEvents.ExtEvents.Add
      ('OnAfterrender=function afterrender(sender, eOpts)'+
      ' { sender.allowBlank=true; sender.editable = true;}');
end;

function TfrmFormPatterns2.Confirm(msg:String):Boolean;
Begin
  MessageDlg(Msg, mtConfirmation, mbYesNo);
End;

procedure TfrmFormPatterns2.Warning(msg:String);
Begin
  MessageDlg(Msg, mtWarning, [mbOk]);
End;

procedure TfrmFormPatterns2.AddFeriados(Data: String);
begin
  KrUtil.AddFeriados(Data);
end;

function TfrmFormPatterns2.BoolToStr2(Bool: Integer): String;
begin
  Result:=KrUtil.BoolToStr2(Bool);
end;

function TfrmFormPatterns2.Criptografar(wStri: String): String;
begin
  Result := krUtil.Criptografar(wStri);
end;

end.
