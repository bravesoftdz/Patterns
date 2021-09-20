unit fmCadPatternsSamples;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, fmFormPatterns, uniButton, uniBitBtn,
  uniGUIBaseClasses, uniPanel;

type
  TfrmFormPatternsSamples = class(TfrmFormPatterns)
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

function frmFormPatternsSamples: TfrmFormPatternsSamples;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function frmFormPatternsSamples: TfrmFormPatternsSamples;
begin
  Result := TfrmFormPatternsSamples(UniMainModule.GetFormInstance(TfrmFormPatternsSamples));
end;

procedure TfrmFormPatternsSamples.btClose2Click(Sender: TObject);
begin
  inherited;
  cLOSE;
end;

end.
