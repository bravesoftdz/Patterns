unit fmLoginPatterns;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniButton, uniPanel, uniLabel,
  uniGUIBaseClasses, uniEdit, ZAbstractConnection, ZConnection, DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, pngimage, uniImage,
  uniCheckBox, uniBitBtn, ZAbstractTable;

type
  TfrmLoginPatterns = class(TUniLoginForm)
    dqrLogin: TZQuery;
    imgDiv: TUniImage;
    edUsername: TUniEdit;
    img3: TUniImage;
    edPassword: TUniEdit;
    btLogin: TUniImage;
    UniLabel1: TUniLabel;
    procedure UniLoginFormCreate(Sender: TObject);
    procedure btLoginClick(Sender: TObject);
    procedure edPasswordKeyPress(Sender: TObject; var Key: Char);
  private
    FPassAdmin   : String;
    FUserAdmin   : String;
    FFieldPass   : String;
    FFieldUser   : String;
    FFieldID_USer: string;
    procedure SetPassAdmin(const Value: String);
    procedure SetUserAdmin(const Value: String);
    procedure SetFieldID_USer(const Value: string);
    procedure SetFieldPass(const Value: String);
    procedure SetFieldUser(const Value: String);
    { Private declarations }
  public
    property UserAdmin   :String read FUserAdmin    write SetUserAdmin;
    property PassAdmin   :String read FPassAdmin    write SetPassAdmin;
    property FieldID_USer:string read FFieldID_USer write SetFieldID_USer;
    property FieldUser   :String read FFieldUser    write SetFieldUser;
    property FieldPass   :String read FFieldPass    write SetFieldPass;
    { Public declarations }
  end;

function frmLoginPatterns: TfrmLoginPatterns;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication, ServerModule;

function frmLoginPatterns: TfrmLoginPatterns;
begin
  Result := TfrmLoginPatterns(UniMainModule.GetFormInstance(TfrmLoginPatterns));
end;

procedure TfrmLoginPatterns.btLoginClick(Sender: TObject);
begin
  if Trim(edUsername.Text) = '' then
  Begin
    MessageDlg('Favor informar o usuário de acesso ao sistema',mtInformation, [mbOk]);
    Exit;
  end else
  if Trim(edPassword.Text) = '' then
  Begin
    MessageDlg('Favor informar a senha de acesso ao sistema',mtInformation, [mbOk]);
    Exit;
  end;
  if (UpperCase(Trim(edUsername.Text)) = UpperCase(UserAdmin) ) and (UpperCase(Trim(edPassword.Text)) = UpperCase(PassAdmin)) then
  Begin
    UniMainModule.Usuario := edUsername.Text;
    UniMainModule.Senha   := edPassword.Text;
    UniMainModule.isAdmin := True;
    ModalResult           := mroK;
  End
  Else
  Begin
    dqrLogin.Close;
    dqrLogin.ParamByName(FieldUser).Value := edUsername.Text;
    dqrLogin.ParamByName(FieldPass).Value := edPassword.Text;
    dqrLogin.Open;

    if not dqrLogin.IsEmpty then
    Begin
      UniMainModule.Usuario := edUsername.Text;
      UniMainModule.Senha   := edPassword.Text;
      UniMainModule.ID_User := dqrLogin.FieldByName(FieldID_USer).AsInteger;
      UniMainModule.isAdmin := False;
      ModalResult           := mroK;
    End
    else
    Begin
      ModalResult := mrNone;
      MessageDlg('Usuário ou senha inválida !', mtError, [MBOK]);
    End;
  End;
end;

procedure TfrmLoginPatterns.edPasswordKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    btLoginClick(Self);
end;

procedure TfrmLoginPatterns.SetFieldID_USer(const Value: string);
begin
  FFieldID_USer := Value;
end;

procedure TfrmLoginPatterns.SetFieldPass(const Value: String);
begin
  FFieldPass := Value;
end;

procedure TfrmLoginPatterns.SetFieldUser(const Value: String);
begin
  FFieldUser := Value;
end;

procedure TfrmLoginPatterns.SetPassAdmin(const Value: String);
begin
  FPassAdmin := Value;
end;

procedure TfrmLoginPatterns.SetUserAdmin(const Value: String);
begin
  FUserAdmin := Value;
end;

procedure TfrmLoginPatterns.UniLoginFormCreate(Sender: TObject);
begin
 //  UniMainModule.ZConnection1.Connected := True;
end;

initialization
  RegisterAppFormClass(TfrmLoginPatterns);

end.
