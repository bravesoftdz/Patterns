unit uShow;

interface

uses
  Classes, SysUtils, Controls, RaApplication, RaBase, RaControlsVCL,
  Dialogs, StdCtrls;

procedure Message(AText: string; aCallBack: TNotifyEvent);

procedure MessageBox(AText, ATitulo: string; aButonDefault: Integer);

function MessageDlg(const aMsg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): TModalResult; overload;

function MessageDlg(const aCaption, aMsg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): TModalResult; overload;

function MessageDlg(const aCaption, aMsg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; DefaultButton: TMsgDlgBtn): TModalResult; overload;

function MessageDlg(const aMsg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; DefaultButton: TMsgDlgBtn): TModalResult; overload;

function MessageDlg(const aCaption, aMsg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; const HelpKeyword: string): TModalResult; overload;

function MessageDlgPos(const aMsg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): TModalResult; overload;

function MessageDlgPosHelp(const aMsg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer; const HelpFileName: string): TModalResult; overload;

type
    TCloseAction = (caNone, caHide, caFree, caMinimize);
    
  TShow = class(TRaFormCompatible)
    lblMensagem: TRaLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { private declarations }
    FCallBack: TNotifyEvent;
  public
    { public declarations }
    procedure Message(AText: string; aCallBack: TNotifyEvent);
  end;

var
  Show: TShow;

implementation

{$R *.dfm}

procedure Message(AText: string; aCallBack: TNotifyEvent);
var
  frm: TShow;
begin
  Application.CreateForm(TShow, frm);
  //frm := TShow.Create(application);
  frm.Message(AText, aCallBack);
  frm.show;
end;

procedure MessageBox(AText, ATitulo: string; aButonDefault: Integer);
var
  frm: TShow;
begin
  Application.CreateForm(TShow, frm);
  //frm := application. TShow.Create(application);
  frm.caption := ATitulo;
  frm.Message(AText, nil);
  frm.show;

end;

function MessageDlg(const aMsg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): TModalResult; overload;
begin

end;

function MessageDlg(const aCaption, aMsg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): TModalResult; overload;
begin

end;

function MessageDlg(const aCaption, aMsg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; DefaultButton: TMsgDlgBtn): TModalResult; overload;
begin

end;

function MessageDlg(const aMsg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; DefaultButton: TMsgDlgBtn): TModalResult; overload;
begin

end;

function MessageDlg(const aCaption, aMsg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; const HelpKeyword: string): TModalResult; overload;
begin

end;

function MessageDlgPos(const aMsg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): TModalResult; overload;
begin

end;

function MessageDlgPosHelp(const aMsg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer; const HelpFileName: string): TModalResult; overload;
begin

end;

{ TShow }

procedure TShow.Message(AText: string; aCallBack: TNotifyEvent);
begin
  if Assigned(aCallBack) then
    FCallBack := aCallBack;
  lblMensagem.Caption := AText;

end;

procedure TShow.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FCallBack) then
    FCallBack(Sender);
  //CloseAction := cafree;
end;


end.

