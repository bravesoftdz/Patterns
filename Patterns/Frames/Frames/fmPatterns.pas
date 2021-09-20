unit fmPatterns;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, uniButton, uniBitBtn, uniSpeedButton,
  uniGUIBaseClasses, uniPanel;

type
  TUniFrame1 = class(TUniFrame)
    UniPanel1: TUniPanel;
    btXLS: TUniBitBtn;
    btODS: TUniBitBtn;
    bt4PDF: TUniBitBtn;
    btCSV: TUniBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



end.
