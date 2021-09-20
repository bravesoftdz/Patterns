unit fmCadPatternsSimples;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, fmFormPatterns, uniButton, uniBitBtn,
  uniGUIBaseClasses, uniPanel;

type
  TfrmFormPatterns1 = class(TfrmFormPatterns)
    UniPanel1: TUniPanel;
    UniPanel5: TUniPanel;
    btClose2: TUniBitBtn;
    btPrint3: TUniBitBtn;
    procedure btClose2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function frmFormPatterns1: TfrmFormPatterns1;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function frmFormPatterns1: TfrmFormPatterns1;
begin
  Result := TfrmFormPatterns1(UniMainModule.GetFormInstance(TfrmFormPatterns1));
end;

procedure TfrmFormPatterns1.btClose2Click(Sender: TObject);
begin
  inherited;
  cLOSE;
end;

end.
