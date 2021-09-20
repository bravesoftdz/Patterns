unit fmSobre;

interface

uses
  uniKrUtil,
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniGUIBaseClasses, uniTimer, uniImage,
  uniLabel, uniPanel, uniScrollBox, uniCanvas;

type
  TfrmSobre = class(TUniForm)
    pbxBackground: TUniCanvas;
    sbxCast: TUniScrollBox;
    lblTitle: TUniLabel;
    lblVersao1: TUniLabel;
    Label2: TUniLabel;
    Label6: TUniLabel;
    Label3: TUniLabel;
    Label5: TUniLabel;
    Label4: TUniLabel;
    Label7: TUniLabel;
    Label8: TUniLabel;
    Timer1: TUniTimer;
    imgTela: TUniImage;
    procedure UniFormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure UniFormKeyPress(Sender: TObject; var Key: Char);
    procedure UniFormShow(Sender: TObject);
  private
    py,Dist: Integer;
    Up: Boolean;
    fAnoFinal: String;
    fAnoInicial: String;
    { Private declarations }
  protected
    Fundo: TBitMap;
  public
    procedure MyShowModal(AnoInicial, AnoFinal: String);
    { Public declarations }
  end;

Const
  fFileVersion='1.0b';
  crOpenedHand = 1;
  crClosedHand = 2;
  SisOperacional:string='for Windows';

function frmSobre: TfrmSobre;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function frmSobre: TfrmSobre;
begin
  Result := TfrmSobre(UniMainModule.GetFormInstance(TfrmSobre));
end;

procedure TfrmSobre.MyShowModal(AnoInicial, AnoFinal:String);
Begin
  ProcessMessages;
  fAnoInicial:='2014';
  fAnoFinal  :='2017';
  Self.ShowModal();
End;

procedure TfrmSobre.Timer1Timer(Sender: TObject);
var
  i,lp: Integer;
begin
  inherited;
  with Fundo.Canvas do
  begin
    ProcessMessages;
    StretchDraw(Rect(0,0,pbxBackground.Width,pbxBackground.Height),ImgTela.Picture.Bitmap);
    if Timer1.Tag=60 then
      Timer1.Tag:=0;
    Brush.Style:=bsClear;
    Font.Name  :=pbxBackground.Font.Name;
    if Up and (Dist+py<=0) then
      py:=pbxBackground.Height
    else
      if not Up and (py>=pbxBackground.Height) then
        py:=0-Dist;
    Dist:=0;

    for i:=0 to sbxCast.ControlCount-1 do
    begin
      ProcessMessages;
      Font.Name  :=TUniLabel(sbxCast.Controls[i]).Font.Name;
      Font.Size  :=TUniLabel(sbxCast.Controls[i]).Font.Size;
      Font.Height:=TUniLabel(sbxCast.Controls[i]).Font.Height;
      Font.Style :=TUniLabel(sbxCast.Controls[i]).Font.Style;

      lp:=(pbxBackground.Width div 2)-(TextWidth(TUniLabel(sbxCast.Controls[i]).Caption) div 2);
      Font.Color:=clWhite;
      TextOut(lp+1,py+Dist+1,TUniLabel(sbxCast.Controls[i]).Caption);
      Font.Color:=TUniLabel(sbxCast.Controls[i]).Font.Color;
      TextOut(lp,py+Dist,TUniLabel(sbxCast.Controls[i]).Caption);
      Dist:=Dist+TextHeight('T')+2;
    end;
    if pbxBackground.Tag=0 then
      if Up then
        Dec(py)
      else
        Inc(py);
    pbxBackground.BitmapCanvas.Draw(0,0,Fundo);
  end;
end;

procedure TfrmSobre.UniFormDestroy(Sender: TObject);
begin
  FreeAndNil(Fundo);
end;

procedure TfrmSobre.UniFormKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#27 then Close;
end;

procedure TfrmSobre.UniFormShow(Sender: TObject);
begin
  ProcessMessages;
  lblTitle.Caption:=UniApplicationTitle;// Application.MainForm.Caption;// Application.Title;
  lblVersao1.Caption:='Versão '+fFileVersion;
  Label2.Caption := 'Copyrigth©  '+fAnoInicial+' - '+ fAnoFinal;// 10/02/2017

  Fundo       :=TBitMap.Create;
  Fundo.Width :=pbxBackground.Width;
  Fundo.Height:=pbxBackground.Height;
  py          :=pbxBackground.Height;
  Up          :=True;
  Screen.Cursors[crOpenedHand]:=LoadCursor(Hinstance,Pchar('CURSOR_1'));
  Screen.Cursors[crClosedHand]:=LoadCursor(Hinstance,Pchar('CURSOR_2'));
  pbxBackground.Cursor:=crOpenedHand;
end;

end.


