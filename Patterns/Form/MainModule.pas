unit MainModule;

interface

uses
  krUtil, SysUtils, Classes, ZAbstractConnection, ZConnection, DB, Controls,
  uniGUIForm, Dialogs, uniGUIBaseClasses, uniGUIMainModule, ZAbstractRODataset,
  ZAbstractDataset, ZAbstractTable, ZDataset, uniGUIClasses, uniBasicGrid,
  uniDBGrid, uniLabel,  uniPanel;

type
  TUniMainModule = class(TUniGUIMainModule)
    ZConnection1: TZConnection;
    dqrLog: TZTable;
    procedure UniGUIMainModuleCreate(Sender: TObject);
  private
    FSenha     : String;
    FUsuario   : String;
    FInf       : String;
    FisAdmin   : Boolean;
    FID_Setor  : integer;
    FID_USer   : Integer;
    FSetor     : String;
    FUnidade   : integer;
    FFiltrarAIS: Boolean;
    FAREA      : integer;
    FFiltrarRegiao: Boolean;
    FRegiao: integer;
    FFiltrarUnidade: String;
    procedure SetSenha(const Value: String);
    procedure SetUsuario(const Value: String);
    procedure SetInf(const Value: String);
    function GetInf: String;
    function GetIPRemoto: String;
    function GetHomeDir: String;
    function GerIPServidor: String;
    procedure SetisAdmin(const Value: Boolean);
    procedure SetID_Setor(const Value: integer);
    procedure SetID_User(const Value: Integer);
    procedure SetSetor(const Value: String);
    procedure SetUnidade(const Value: integer);
    procedure SetFiltrarAIS(const Value: Boolean);
    procedure SetAREA(const Value: integer);
    procedure SetFiltrarRegiao(const Value: Boolean);
    procedure SetRegiao(const Value: integer);
    procedure SetFiltrarUnidade(const Value: String);
    { Private declarations }
  public
    ID_Vitima : Integer;
    Nome_vitima:String;
    procedure AutoCommit(Value:Boolean=True);
    Procedure Log(Form:String; id_Acao:integer);
    //
    property ID_User       : Integer read FID_User        write SetID_User;
    property ID_Setor      : integer read FID_Setor       write SetID_Setor;
    property Setor         : String  read FSetor          write SetSetor;
    property Usuario       : String  read FUsuario        write SetUsuario;
    property Senha         : String  read FSenha          write SetSenha;
    property Inf           : String  read GetInf          write SetInf;
    property IPRemoto      : String  read GetIPRemoto;   // Retorna o IP do Cliente que está acessando o Site
    Property HomeDir       : String  read GetHomeDir;    // Retorna o diretório do arquivo CGI
    property IPServidor    : String  read GerIPServidor; // Retorna o IP do Servidor que o site está hospedado
    property isAdmin       : Boolean read FisAdmin        write SetisAdmin;
    property Unidade       : integer read FUnidade        write SetUnidade; // Guarda o ID da Unidade policial
    property FiltrarAIS    : Boolean read FFiltrarAIS     write SetFiltrarAIS     Default False;
    property FiltrarRegiao : Boolean read FFiltrarRegiao  write SetFiltrarRegiao  Default False;
    property AREA          : integer read FAREA           write SetAREA;
    property Regiao        : integer read FRegiao         write SetRegiao;
    Property FiltrarUnidade: String  read FFiltrarUnidade write SetFiltrarUnidade;
    { Public declarations }
  end;

function UniMainModule: TUniMainModule;

implementation

{$R *.dfm}

uses
  UniGUIVars, ServerModule, uniGUIApplication, fmMain;

function UniMainModule: TUniMainModule;
begin
  Result := TUniMainModule(UniApplication.UniMainModule)
end;

function TUniMainModule.GerIPServidor: String;
begin
  Result:=uniGUIApplication.UniSession.Host;
end;

function TUniMainModule.GetHomeDir: String;
Const
  Separador :Char='\';
Var
  Token, Cache:String;

begin
  Token := UniServerModule.LocalCachePath;
  Cache := TokenN(Token,CountToken(Token, Separador), Separador);
  Result:=Copy(Token,1, Pos(Cache, Token)-1);
end;

function TUniMainModule.GetInf: String;
begin
  Result:=uniGUIApplication.UniSession.Host +
  '  '+uniGUIApplication.UniSession.URLPath;
end;

function TUniMainModule.GetIPRemoto: String;
begin
  Result:=UniSession.UniApplication.RemoteAddress;//uniGUIApplication.UniApplication.RemoteAddress//; GetRemoteAddress;
end;

procedure TUniMainModule.Log(Form: String; id_Acao: integer);
begin
  if (Trim(Form) <> '') then
  Begin
    dqrLog.Insert;
    dqrLog.FieldByName('id_usuario').AsInteger := ID_User;
    dqrLog.FieldByName('id_acao').AsInteger    := id_Acao;
    dqrLog.FieldByName('Form').AsString        := Form;
    dqrLog.FieldByName('IP').AsString          := IPRemoto;
    dqrLog.FieldByName('dt_acao').AsDateTime   := Date;
    dqrLog.FieldByName('hr_acao').AsDateTime   := Time;
    dqrLog.Post;
  End;
end;

procedure TUniMainModule.SetAREA(const Value: integer);
begin
  FAREA := Value;
end;

procedure TUniMainModule.SetFiltrarAIS(const Value: Boolean);
begin
  FFiltrarAIS := Value;
end;

procedure TUniMainModule.SetFiltrarRegiao(const Value: Boolean);
begin
  FFiltrarRegiao := Value;
end;

procedure TUniMainModule.SetFiltrarUnidade(const Value: String);
begin
  FFiltrarUnidade := Value;
end;

procedure TUniMainModule.SetID_Setor(const Value: integer);
begin
  FID_Setor := Value;
end;

procedure TUniMainModule.SetID_User(const Value: Integer);
begin
  FID_User := Value;
end;

procedure TUniMainModule.SetInf(const Value: String);
begin
  FInf := Value;
end;

procedure TUniMainModule.SetisAdmin(const Value: Boolean);
begin
  FisAdmin := Value;
end;

procedure TUniMainModule.SetRegiao(const Value: integer);
begin
  FRegiao := Value;
end;

procedure TUniMainModule.SetSenha(const Value: String);
begin
  FSenha := Value;
end;

procedure TUniMainModule.SetSetor(const Value: String);
begin
  FSetor := Value;
end;

procedure TUniMainModule.SetUnidade(const Value: integer);
begin
  FUnidade := Value;
end;

procedure TUniMainModule.SetUsuario(const Value: String);
begin
  FUsuario := Value;
end;

procedure TUniMainModule.UniGUIMainModuleCreate(Sender: TObject);
begin
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
  ZConnection1.AutoCommit := True;
  dqrLog.Open;
end;

procedure TUniMainModule.AutoCommit(Value:Boolean=True);
Begin
  ZConnection1.Connected := False;
  ZConnection1.AutoCommit:= Value;
  ZConnection1.Connected := True;
End;

initialization
  RegisterMainModuleClass(TUniMainModule);
end.
