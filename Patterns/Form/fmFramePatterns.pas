unit fmFramePatterns;

interface

uses
  KrUtil, uniKrUtil, krVar, KrDB,
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  //
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIFrame,
  uniLabel, uniGUIBaseClasses, uniPanel, uniGUIForm, uniDBEdit,
  uniEdit, uniDBLookupComboBox, uniDBDateTimePicker,
  UniDateTimePicker;

type
  TfrmFramePatterns = class(TUniFrame)
    procedure UniFrameCreate(Sender: TObject);
    procedure UniFrameDestroy(Sender: TObject);
  private
    { Private declarations }
    fCallBackConfirm:Boolean;
    function GetDataNula: String;
    procedure AddEditLookpCombobox;
    procedure CallBackConfirm(Sender: TComponent; AResult: Integer);
//    procedure OnColumnSort(Column: TUniDBGridColumn; Direction: Boolean);
    procedure SortedBy;
  public
    { Public declarations }
    Const
      MaskFone    :String = '(99)9999-9999';       // Fone
      MaskCelular :String = '(99)9 9999-9999';     // Celular com 9 digitos
      MaskDate    :String = '99/99/9999';          // Data
      MaskTime    :String = '99:99';               // Hora
      MaskCPF     :String = '999.999.999-99';      // CPF
      MaskPlaca   :String = 'aaa-9999';            // Placa de Autovóvel
      MaskIP      :String = '9999.9999.9999.9999'; // IP de computador
      MaskCNPJ    :String = '99.999.999/9999-99';  // CNPJ
      MaskVIPROC  :String = '9999999/9999';        // VIPROC
      MaskIPol    :String = '999-9999/9999';       // Inquérito Policial

      ResultCPF:String='___.___.___-__' ;
      //
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
    Function IsEMail(Value: String):Boolean;
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
    function IsNum(Value:String):Boolean;
    // Date e Time
    function Dias_Uteis(DT_Ini, DT_Fin:TDateTime):Integer;
    { Public declarations }
    Function GetWhere(Value:TStrings):String;

    function StrToBool1(Str:string):boolean;
    //
    property DataNula :String read GetDataNula;
  end;

implementation

{$R *.dfm}



procedure TfrmFramePatterns.CallBackConfirm(Sender: TComponent; AResult: Integer);
begin
  fCallBackConfirm :=  AResult = mrYes;
end;

procedure TfrmFramePatterns.OpenURLWindow(URL:String);
Begin
  uniKrUtil.OpenURLWindow(URL);
End;

procedure TfrmFramePatterns.OpenURL(URL:String);
Begin
  uniKrUtil.OpenURL(URL);
End;

function TfrmFramePatterns.DelCharEspeciais(Str: String): string;
begin
  Result := KrUtil.DelCharEspeciais(Str);
end;

function TfrmFramePatterns.Dias_Uteis(DT_Ini, DT_Fin: TDateTime): Integer;
begin
  Result := KrUtil.Dias_Uteis(DT_Ini, DT_Fin);
end;

procedure TfrmFramePatterns.DisplayError(Msg: string);
begin
  uniKrUtil.DisplayError(Msg);
end;

function TfrmFramePatterns.GerarNomeArquivo: String;
begin
  Result:=krUtil.GerarNomeArquivo;
end;

function TfrmFramePatterns.GeraSenha(n: integer): String;
begin
  Result:=krUtil.GeraSenha(n);
end;

function TfrmFramePatterns.GetDataNula: String;
begin
  Result:=krVar.DataNula;
end;

function TfrmFramePatterns.GetWhere(Value: TStrings): String;
begin
  Result:=KrUtil.GetWhere(Value);
end;

function TfrmFramePatterns.Soundex(S: String): String;
begin
  Result:=KrUtil.Soundex(S);
end;

function TfrmFramePatterns.StrToBool1(Str: string): boolean;
begin
  Result:=KrUtil.StrToBool1(Str);
end;

procedure TfrmFramePatterns.UniFrameCreate(Sender: TObject);
begin
  KrUtil.Create;
  SortedBy;
  ArrayForms.Add(self.Name);
  AjustarFetchRow(self);
end;

procedure TfrmFramePatterns.UniFrameDestroy(Sender: TObject);
begin
  ArrayForms.Delete(ArrayForms.Add(self.Name));
end;

{procedure TfrmFrameCadastro.OnColumnSort(Column: TUniDBGridColumn; Direction: Boolean);
begin // Uses uniDBGrid, ZAbstractDataset, ZAbstractRODataset
  inherited; // Ordena as informações pelo campo da coluna que foi clicada
  if TZAbstractDataSet(Column.Field.DataSet).Active then
  Begin
    if Column.FieldName <> TZAbstractDataSet(Column.Field.DataSet).SortedFields then
    Begin
      TZAbstractDataSet(Column.Field.DataSet).SortedFields := Column.FieldName;
      TZAbstractDataSet(Column.Field.DataSet).SortType     := stAscending;
    End
    else
    Begin
      case TZAbstractDataSet(Column.Field.DataSet).SortType of
        stAscending : TZAbstractDataSet(Column.Field.DataSet).SortType := stDescending;
        stDescending: TZAbstractDataSet(Column.Field.DataSet).SortType := stAscending;
      end;
    End;
  End;
end;}

procedure TfrmFramePatterns.SortedBy;
Var
  I, J :Integer;

begin
  inherited;
(*  For I:=0 To Self.ComponentCount - 1 do
  Begin
    if (LowerCase(self.Components[I].ClassName) = 'tunidbgrid') and
       (TUniDBGrid(self.Components[I]).Tag = 0) then
    Begin
      TUniDBGrid(self.Components[I]).OnColumnSort := OnColumnSort;
      TUniDBGrid(self.Components[I]).Tag := 1;
      //
{      if TUniDBGrid(self.Components[I]).DataSource.DataSet.Active then
        For J:= 0 to TUniDBGrid(self.Components[I]).Columns.Count - 1 do
          if not TUniDBGrid(self.Components[I]).Columns[J].Sortable then
            TUniDBGrid(self.Components[I]).Columns[J].Sortable := True;}
    End;
  end;   *)
end;

(*procedure TfrmFrameCadastro.UniFormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    Close;
end;    *)

(*procedure TfrmFrameCadastro.UniFormShow(Sender: TObject);
begin
  AddMaskDate;
  AddEditLookpCombobox;
end;  *)

function TfrmFramePatterns.BoolToStr2(Bool:Boolean):String;
Begin
  Result:=KrUtil.BoolToStr2(Bool);
End;

function TfrmFramePatterns.Idade(DataNasc: String): string;
begin
  Result:=KrUtil.Idade(DataNasc);
end;

function TfrmFramePatterns.Idade(DataNasc: String; dtAtual: TDate): string;
begin
  Result:=KrUtil.Idade(DataNasc, dtAtual);
end;

function TfrmFramePatterns.IsCnpj(const aCode: string): boolean;
begin
  Result:=KrUtil.IsCnpj(aCode);
end;

function TfrmFramePatterns.IsCpf(const aCode: string): boolean;
begin
  Result:=KrUtil.IsCpf(aCode);
end;

function TfrmFramePatterns.IsCpfCnpj(const aCode: string): boolean;
begin
  Result:=KrUtil.IsCpfCnpj(aCode);
end;

function TfrmFramePatterns.IsDate(fDate: String): Boolean;
begin
  Result:=KrUtil.IsDate(fDate);
end;

function TfrmFramePatterns.IsEMail(Value: String):Boolean;
begin
  Result:=KrUtil.IsEMail(Value);
end;

function TfrmFramePatterns.IsIE(UF, IE: string): boolean;
begin
  Result:=KrUtil.IsIE(UF, IE);
end;

function TfrmFramePatterns.IsIP(IP: string): Boolean;
begin
  Result:=KrUtil.IsIP(IP);
end;

function TfrmFramePatterns.isKeyValid(Value: Char): Boolean;
begin
  Result:=KrUtil.isKeyValid(Value);
end;

function TfrmFramePatterns.IsNum(Value: String): Boolean;
begin
  Result:=KrUtil.IsNum(Value);
end;

function TfrmFramePatterns.IsPlaca(Value: String): Boolean;
begin
  Result:=KrUtil.IsPlaca(Value);
end;

function TfrmFramePatterns.IsTitulo(numero: String): Boolean;
begin
  Result:=KrUtil.IsTitulo(numero);
end;

function TfrmFramePatterns.IsTituloEleitor(NumTitulo: string): Boolean;
begin
  Result := KrUtil.IsTituloEleitor(NumTitulo);
end;

procedure TfrmFramePatterns.AddMaskDate;
Var
  I:Integer;
begin // Adiciona mascara do componente informado
  For I:=0 to ComponentCount - 1 do
    if lowercase(Components[I].ClassName) = 'tunidbdatetimepicker' then
      AddMask(TUniDBDateTimePicker(Components[I]), MaskDate);
end;

procedure TfrmFramePatterns.AddMask(Edit: TUniDBDateTimePicker; Mask:String);
begin // Uses uniDBDateTimePicker
  Edit.ClientEvents.ExtEvents.Add
  ('Onfocus=function function focus(sender, the, eOpts)'+
  ' { $("#"+sender.id+"-inputEl").mask("'+Mask+'"); }');
end;

procedure TfrmFramePatterns.AddMask(Edit: TUniDateTimePicker; Mask:String);
begin // Uses uniDBDateTimePicker
  Edit.ClientEvents.ExtEvents.Add
  ('Onfocus=function function focus(sender, the, eOpts)'+
  ' { $("#"+sender.id+"-inputEl").mask("'+Mask+'"); }');
end;

procedure TfrmFramePatterns.AddMask(Edit: TUniDBEdit; Mask:String);
begin
  Edit.ClientEvents.ExtEvents.Add
  ('Onfocus=function function focus(sender, the, eOpts)'+
  ' { $("#"+sender.id+"-inputEl").mask("'+Mask+'"); }');
end;

procedure TfrmFramePatterns.AddMask(Edit: TUniEdit; Mask:String);
begin
  Edit.ClientEvents.ExtEvents.Add
  ('Onfocus=function function focus(sender, the, eOpts)'+
  ' { $("#"+sender.id+"-inputEl").mask("'+Mask+'"); }');
end;

procedure TfrmFramePatterns.AddEditLookpCombobox;
Var
  I:Integer;
begin // Uses uniDBLookupComboBox
  For I:=0 to ComponentCount - 1 do
    if lowercase(Components[I].ClassName) = 'tunidblookupcombobox' then
      TUniDBLookupComboBox(Components[I]).ClientEvents.ExtEvents.Add
      ('OnAfterrender=function afterrender(sender, eOpts)'+
      ' { sender.allowBlank=true; sender.editable = true;}'); // sender.allowBlank=true; sender.editable = true;
end;

function TfrmFramePatterns.Confirm(msg:String):Boolean;
Begin
  MessageDlg(Msg, mtConfirmation, mbYesNo,CallBackConfirm);
  Result := fCallBackConfirm;
End;

procedure TfrmFramePatterns.Warning(msg:String);
Begin
  uniKrUtil.Warning(msg);
End;

procedure TfrmFramePatterns.AddFeriados(Data: String);
begin
  KrUtil.AddFeriados(Data);
end;

function TfrmFramePatterns.BoolToStr2(Bool: Integer): String;
begin
  Result:=KrUtil.BoolToStr2(Bool);
end;

function TfrmFramePatterns.Criptografar(wStri: String): String;
begin
  Result := krUtil.Criptografar(wStri);
end;

end.
