unit fie;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask,shellapi;

type
  TForm1 = class(TForm)
    mskIe: TMaskEdit;
    BitBtn1: TBitBtn;
    edtUf: TEdit;
    Label1: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    { Private declarations }
  public
  function checaie(uf : string;ie : string) : boolean;
    { Public declarations }

  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{ TForm1 }


{ TForm1 }

function TForm1.checaie(uf, ie: string): boolean;
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

procedure TForm1.BitBtn1Click(Sender: TObject);
begin

  if checaie(edtUF.Text, mskIe.Text) Then
    ShowMessage('Ok')
  Else
    ShowMessage('Inscrição Estadual Inválida');

end;

procedure TForm1.Label1Click(Sender: TObject);
begin
  shellexecute(handle,'open','http://www.delphibr.com.br',nil,nil,SW_MAXIMIZE);
end;

end.
