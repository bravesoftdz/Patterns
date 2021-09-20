unit fmCalcPatterns;

interface

uses
  math,
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniGUIBaseClasses, uniButton, uniPanel, uniMemo;

type
  TCalculadoraDisplayChange = procedure(Sender: TObject; Valor : Double) of object;
  TCalculadora = class ( TComponent )
    private
      FBorderStyle    : TFormBorderStyle;
      FTitulo         : String ;
      FValor          : Double ;
      FTexto          : String ;
      FPrecisao       : Integer;
      FSaiComEsc      : Boolean;
      FCalcLeft       : Integer;
      FCalcTop        : Integer;
      FCor            : TColor;
      FCorForm        : TColor;
      FCentraliza     : Boolean;
      FOnCalcKey      : TKeyPressEvent;
      FOnDisplayChange: TCalculadoraDisplayChange;
    public
      constructor Create(AOwner: TComponent); override;
      function Execute: Boolean;
      property Texto  : String read FTexto ;
    published
       property Valor          : Double                    read FValor           write FValor            stored false ;
       property Titulo         : String                    read FTitulo          write FTitulo;
       property Precisao       : Integer                   read FPrecisao        write FPrecisao         default 4 ;
       property SaiComEsc      : Boolean                   read FSaiComEsc       write FSaiComEsc        default true;
       property Centraliza     : Boolean                   read FCentraliza      write FCentraliza       default false ;
       property CalcTop        : Integer                   read FCalcTop         write FCalcTop          default 0;
       property CalcLeft       : Integer                   read FCalcLeft        write FCalcLeft         default 0;
       property CorDisplay     : TColor                    read FCor             write FCor              default clLime ;
       property CorForm        : TColor                    read FCorForm         write FCorForm          default clBtnFace ;
       property OnCalcKey      : TKeyPressEvent            read FOnCalcKey       write FOnCalcKey;
       property OnDisplayChange: TCalculadoraDisplayChange read FOnDisplayChange write FOnDisplayChange;
       property BorderStyle    : TFormBorderStyle          read FBorderStyle     write FBorderStyle;
    end;
  { TfrmCalc }

  TfrmCalcPatterns = class(TUniForm)
    bc: TUniButton;
    b0: TUniButton;
    bponto: TUniButton;
    bigual: TUniButton;
    bmais: TUniButton;
    bce: TUniButton;
    b1: TUniButton;
    b2: TUniButton;
    b3: TUniButton;
    bmenos: TUniButton;
    bporc: TUniButton;
    b4: TUniButton;
    b5: TUniButton;
    b6: TUniButton;
    bmulti: TUniButton;
    bapaga: TUniButton;
    b7: TUniButton;
    b8: TUniButton;
    b9: TUniButton;
    bdiv: TUniButton;
    mBobina: TUniMemo;
    pValor: TUniPanel;
    procedure b1Click(Sender: TObject);
    procedure AcaoClick(Sender: TObject);
    procedure ExecOnDisplayChange(Sender: TObject);
    procedure ZeraDisplay(Sender: TObject);
    procedure bpontoClick(Sender: TObject);
    procedure bcClick(Sender: TObject);
    procedure bceClick(Sender: TObject);
    procedure bporcClick(Sender: TObject);
    procedure bapagaClick(Sender: TObject);
    procedure b0Click(Sender: TObject);
  private
    fValor : Double;
    fOperacao : String;
    function GetValorDisplay: String;
    procedure SetValorDisplay(const Value: String);
    procedure ExecOnCalcKey(Sender: TObject; Key: Char);


  { Private declarations }
  public
    pPrecisao  : Integer ;
    pSaiComEsc : Boolean ;
    pOnCalKey  : TKeyPressEvent ;
    pOnDisplayChange : TCalculadoraDisplayChange ;

    Property ValorDisplay : String read GetValorDisplay write SetValorDisplay ;
    { Public declarations }
  end;

function frmCalcPatterns: TfrmCalcPatterns;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function frmCalcPatterns: TfrmCalcPatterns;
begin
  Result := TfrmCalcPatterns(UniMainModule.GetFormInstance(TfrmCalcPatterns));
end;

procedure TfrmCalcPatterns.ZeraDisplay( Sender : TObject ) ;
begin
  inherited;
  ValorDisplay := '0' ;
  if mBobina.Showing then
    mBobina.SetFocus ;
end ;

procedure TfrmCalcPatterns.ExecOnDisplayChange(Sender : TObject ) ;
var Valor : Double ;
begin
  inherited;
  Valor := StrToFloatDef( ValorDisplay, 0 );
  if Assigned( pOnDisplayChange ) then
    pOnDisplayChange( Sender, Valor ) ;
end;

procedure TfrmCalcPatterns.AcaoClick(Sender: TObject);
Var ValDisp : Double ;
    Acao    : String ;
    ResStr  : String ;
begin
  inherited;
  Acao := '' ;
  if Sender is TUniButton then
  begin
    Acao := TUniButton(Sender).Caption ;
  end ;
  ValDisp := StrToFloatDef(ValorDisplay,0) ;
  if ValDisp <> 0 then
  begin
    if (fOperacao <> '') and (fOperacao <> '=') then
    begin
      if fOperacao = '+' then fValor := fValor + ValDisp ;
      if fOperacao = '-' then fValor := fValor - ValDisp ;
      if fOperacao = 'x' then fValor := fValor * ValDisp ;
      if fOperacao = '/' then fValor := fValor / ValDisp ;
    end
    else
      fValor := ValDisp ;

    if Acao <> '=' then
    begin
      mBobina.Lines.Add(ValorDisplay + '  ' + Acao ) ;
      ExecOnDisplayChange(Sender) ;
      ZeraDisplay( Sender ) ;
    end
    else
      if ValorDisplay <> '0' then
      begin
        fValor := RoundTo(fValor,-pPrecisao) ;
        ResStr := FloatToStr(fValor) ;
        mBobina.Lines.Add(ValorDisplay + '    ' ) ;
        mBobina.Lines.Add(StringOfChar('=',max(Length(ResStr)+1,10)) + '    ') ;
        mBobina.Lines.Add(ResStr + '  =') ;
        mBobina.Lines.Add('') ;
        ValorDisplay := ResStr ;
        ExecOnDisplayChange(Sender) ;
      end ;
  end
  else
  begin   { Usuário Trocou de Operaçao }
    mBobina.Lines.Delete(mBobina.Lines.Count-1) ;
    mBobina.Lines.Add(FloatToStr(fValor) + '  ' + Acao ) ;
  end ;

  fOperacao := Acao ;

  if Acao <> '' then
    ExecOnCalcKey(Sender, Acao[1]);

  mBobina.SetFocus ;
end;

function TfrmCalcPatterns.GetValorDisplay: String;
begin
  inherited;
  Result := Trim(pValor.Caption) ;
end;

procedure TfrmCalcPatterns.SetValorDisplay(const Value: String);
begin
  pValor.Caption := Value + '   '   // Espaço para alinhamento no display
end;

procedure TfrmCalcPatterns.ExecOnCalcKey(Sender : TObject; Key : Char ) ;
begin
  if Assigned( pOnCalKey ) and (Key <> '') then
     pOnCalKey( Sender, Key ) ;
end ;

procedure TfrmCalcPatterns.b0Click(Sender: TObject);
begin
  if ValorDisplay <> '0' then
    b1Click(Sender) ;
end;

procedure TfrmCalcPatterns.b1Click(Sender: TObject);
var Tecla : String ;
begin
  inherited;
  if Sender is TUniButton then
    with Sender as TUniButton do
    begin
      if fOperacao = '=' then
      begin
        ValorDisplay := Caption ;
        fOperacao := '' ;
      end
      else
        if ValorDisplay = '0' then
          ValorDisplay := Caption
        else
          ValorDisplay := ValorDisplay + Caption ;
      Tecla := Caption ;
      ExecOnCalcKey(Sender, Tecla[1]);
    end;
  mBobina.SetFocus ;
end ;

procedure TfrmCalcPatterns.bapagaClick(Sender: TObject);
begin
  inherited;
  ValorDisplay := copy( ValorDisplay, 1, length(ValorDisplay)-1 ) ;
  if ValorDisplay  = '' then
  begin
    ZeraDisplay( Sender ) ;
    ExecOnCalcKey(Sender, #8);
  end;
  mBobina.SetFocus ;
end;

procedure TfrmCalcPatterns.bcClick(Sender: TObject);
begin
  inherited;
  ZeraDisplay( Sender ) ;
  ExecOnCalcKey(Sender, 'C');
  ExecOnDisplayChange(Sender);
end;

procedure TfrmCalcPatterns.bceClick(Sender: TObject);
begin
  inherited;
  fValor    := 0 ;
  fOperacao := '' ;
  ZeraDisplay( Sender );
  mBobina.Lines.Clear ;
  mBobina.Lines.Add('0   CE');
  ExecOnCalcKey(Sender, 'E');
  ExecOnDisplayChange(Sender);
end;

procedure TfrmCalcPatterns.bpontoClick(Sender: TObject);
begin
  inherited;
  if pos(DecimalSeparator,ValorDisplay ) = 0 then
  begin
    b1Click(Sender);
    ExecOnCalcKey(Sender, DecimalSeparator);
  end;
  mBobina.SetFocus ;
end;

procedure TfrmCalcPatterns.bporcClick(Sender: TObject);
Var ValDisp : Double ;
begin
  inherited;
  Try
    ValDisp := StrToFloat( ValorDisplay ) ;
    ValDisp := fValor * ( ValDisp / 100 ) ;
    ValorDisplay := FloatToStr(ValDisp) ;
    ExecOnDisplayChange(Sender) ;
    ExecOnCalcKey(Sender, '%');
  except
     ValorDisplay := '0' ;
  end;
  mBobina.SetFocus ;
end;

{ TCalculadora }

constructor TCalculadora.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );
  FTitulo     := 'Calculadora' ;
  FPrecisao   := 4 ;
  FSaiComEsc  := true ;
  FCor        := clLime ;
  FCentraliza := false ;
  FCorForm    := clBtnFace ;
  FBorderStyle:= bsDialog;
end;

function TCalculadora.Execute: Boolean;
var
  frmCalcPatterns : TfrmCalcPatterns;
begin
  inherited;
  frmCalcPatterns := TfrmCalcPatterns.Create(Application);
  try
    if FCentraliza then
      frmCalcPatterns.Position := poMainFormCenter
    else
      if (FCalcTop = 0) and (FCalcLeft = 0) then
        frmCalcPatterns.Position := poDefault
      else
      begin
        frmCalcPatterns.Top  := FCalcTop  ;
        frmCalcPatterns.Left := FCalcLeft ;
      end ;

    frmCalcPatterns.BorderStyle      := FBorderStyle ;
    frmCalcPatterns.Caption          := FTitulo ;
    frmCalcPatterns.Color            := FCorForm;
    frmCalcPatterns.pValor.Font.Color:= FCor ;
    frmCalcPatterns.ValorDisplay     := FloatToStr( FValor ) ;
    frmCalcPatterns.pSaiComEsc       := FSaiComEsc ;
    frmCalcPatterns.pPrecisao        := FPrecisao ;
    frmCalcPatterns.pOnCalKey        := FOnCalcKey ;
    frmCalcPatterns.pOnDisplayChange := FOnDisplayChange ;

//    Result := ( frmCalcPatterns.ShowModal = mrOk ) ;

    FTexto := frmCalcPatterns.ValorDisplay ;
    FValor := StrToFloat( FTexto ) ;
  finally
    FCalcTop  := frmCalcPatterns.Top  ;
    FCalcLeft := frmCalcPatterns.Left ;
    frmCalcPatterns.Free;
  end;
end;

end.
