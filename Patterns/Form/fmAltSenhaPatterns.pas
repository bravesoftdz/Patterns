unit fmAltSenhaPatterns;

interface

uses
  fmFormPatterns, MainModule,
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniSpeedButton, uniButton, uniBitBtn,
  uniGUIBaseClasses, uniPanel, uniGroupBox, uniEdit, uniDBEdit, uniLabel, DB,
  ZAbstractRODataset, ZAbstractDataset, ZAbstractTable, ZDataset, ZSqlUpdate;

type
  TfrmAltSenhaPatterns = class(TfrmFormPatterns)
    UniPanel1: TUniPanel;
    btOk: TUniBitBtn;
    btCancel: TUniBitBtn;
    UniGroupBox1: TUniGroupBox;
    UniGroupBox2: TUniGroupBox;
    edUsuario: TUniDBEdit;
    edSenhaAtual: TUniEdit;
    UniLabel1: TUniLabel;
    UniLabel2: TUniLabel;
    UniGroupBox3: TUniGroupBox;
    edConfirmacao: TUniEdit;
    UniLabel3: TUniLabel;
    UniLabel4: TUniLabel;
    edNovaSenha: TUniEdit;
    ddsUsuario: TDataSource;
    dqrUsuario: TZQuery;
    ZUpdateSQL1: TZUpdateSQL;
    procedure btCancelClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure edSenhaAtualKeyPress(Sender: TObject; var Key: Char);
    procedure edNovaSenhaKeyPress(Sender: TObject; var Key: Char);
    procedure edConfirmacaoKeyPress(Sender: TObject; var Key: Char);
    procedure dqrUsuarioBeforePost(DataSet: TDataSet);
    procedure FormActivate(Sender: TObject);
  private
    procedure Warning(Msg: string);
    { Private declarations }
  public
    { Public declarations }
  end;

function frmAltSenhaPatterns: TfrmAltSenhaPatterns;

implementation

{$R *.dfm}

uses
   uniGUIApplication;

function frmAltSenhaPatterns: TfrmAltSenhaPatterns;
begin
  Result := TfrmAltSenhaPatterns(UniMainModule.GetFormInstance(TfrmAltSenhaPatterns));
end;

procedure TfrmAltSenhaPatterns.btCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAltSenhaPatterns.Warning(Msg: string);
Begin
  MessageDlg(Msg, mtWarning, [mbOk]);
end;

procedure TfrmAltSenhaPatterns.btOkClick(Sender: TObject);
begin
  if Trim(edSenhaAtual.Text)='' then
  Begin
    Warning('Favor Informar a Senha atual.');
    Exit;
  End
  else
    if Trim(edNovaSenha.Text)='' then
    Begin
      Warning('Favor Informar a Nova Senha.');
      Exit;
    End
    else
      if Trim(edConfirmacao.Text)='' then
      Begin
        Warning('Favor Informar a confirmação da Nova Senha.');
        Exit;
      End
      else
        if Trim(edNovaSenha.Text) <> Trim(edConfirmacao.Text) then
        Begin
          Warning('A nova senha está diferente da senha de confirmação.');
          Exit;
        End;


  if Trim(edSenhaAtual.Text) <>  UniMainModule.Senha then //dqrUsuario.FieldByName('senha').asString
  Begin
    Warning('A senha atual não está correta.');
    Exit;
  End;


  dqrUsuario.Close;
  dqrUsuario.ParamByName('nome').AsString := UniMainModule.Usuario;
  dqrUsuario.ParamByName('senha').AsString:= Criptografar(UniMainModule.Senha);
  dqrUsuario.Open;
  if not dqrUsuario.IsEmpty then
  Begin
    dqrUsuario.Edit;
    dqrUsuario.FieldByName('senha').AsString := Criptografar(Trim(edNovaSenha.Text));
    dqrUsuario.Post;
    UniMainModule.Senha := Trim(edNovaSenha.Text);
  End;
  Warning('Senha alterada com sucesso.');
  Close;
end;

procedure TfrmAltSenhaPatterns.dqrUsuarioBeforePost(DataSet: TDataSet);
begin
  inherited;
  Case Dataset.State of
    dsInsert:UniMainModule.Log(Caption,1); // Insert
    dsEdit:UniMainModule.Log(Caption,2); // Edit
  End;
end;

procedure TfrmAltSenhaPatterns.edConfirmacaoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btOk.Click;
end;

procedure TfrmAltSenhaPatterns.edNovaSenhaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    edConfirmacao.SetFocus;
end;

procedure TfrmAltSenhaPatterns.edSenhaAtualKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    edNovaSenha.SetFocus;
end;

procedure TfrmAltSenhaPatterns.FormActivate(Sender: TObject);
begin
  inherited;
  edUsuario.Text := UniMainModule.Usuario;
end;

end.
