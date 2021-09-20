unit fmCadPatterns;

interface

uses
  fmFormPatterns, UniKrUtil, krDB,
  Controls, Forms, Dialogs,
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  //
  ZSqlMetadata, DB, ZDataset, ZAbstractRODataset, ZAbstractDataset, ZAbstractTable,
  //
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm, uniTabControl,
  uniDBCheckBox, uniSpeedButton, uniListBox, uniDBListBox, uniDateTimePicker,
  uniDBDateTimePicker, uniGroupBox, uniScreenMask, uniDBLookupComboBox,
  uniMemo, uniDBMemo, uniDBEdit, uniBasicGrid, uniDBGrid, uniCheckBox,
  uniEdit, uniMultiItem, uniComboBox, uniLabel, uniDBNavigator, uniButton,
  uniBitBtn, uniPanel, uniPageControl, uniGUIBaseClasses, uniDBComboBox,
  ZAbstractConnection, ZConnection;

Var
  Campos     :String;  //Query_
  Where      :String;
  HOrderBy   :String; // Horientação da ordenação
  Enter      :char;
  OrderBy    :String;

type
  TfrmCadPatterns = class(TfrmFormPatterns)
    msgSalvando: TUniScreenMask;
    dqrMain: TZTable;
    ddsMain: TDataSource;
    dqrConsMain: TZReadOnlyQuery;
    ddsConsMain: TDataSource;
    PageControl1: TUniPageControl;
    tbCadastro: TUniTabSheet;
    UniPanel4: TUniPanel;
    UniPanel5: TUniPanel;
    btClose2: TUniBitBtn;
    btPrint3: TUniBitBtn;
    btDelete: TUniBitBtn;
    btCancel: TUniBitBtn;
    btPost: TUniBitBtn;
    btEdit: TUniBitBtn;
    btInsert: TUniBitBtn;
    pnlNavegator01: TUniPanel;
    btFirst: TUniBitBtn;
    btPrior: TUniBitBtn;
    btNext: TUniBitBtn;
    btLast: TUniBitBtn;
    tbConsulta: TUniTabSheet;
    UniPanel1: TUniPanel;
    UniLabel1: TUniLabel;
    cbxListFields: TUniComboBox;
    edSearch: TUniEdit;
    UniLabel2: TUniLabel;
    cbxAutoFiltro: TUniCheckBox;
    btSearch: TUniBitBtn;
    UniPanel3: TUniPanel;
    btClose02: TUniBitBtn;
    btPrint1: TUniBitBtn;
    DBGrid1: TUniDBGrid;
    pnlMensage: TUniPanel;
    msgInserir: TUniScreenMask;
    msgEditar: TUniScreenMask;
    procedure btClose02Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
    procedure btSearchClick(Sender: TObject);
    procedure edSearchChange(Sender: TObject);
    procedure cbxListFieldsChange(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UniFormShow(Sender: TObject);
    procedure btInsertClick(Sender: TObject);
    procedure btEditClick(Sender: TObject);
    procedure btPostClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure dqrMainAfterOpen(DataSet: TDataSet);
    procedure dqrMainAfterPost(DataSet: TDataSet);
    procedure edSearchKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure btFirstClick(Sender: TObject);
    procedure btPriorClick(Sender: TObject);
    procedure btNextClick(Sender: TObject);
    procedure btLastClick(Sender: TObject);
    procedure UniFormClose(Sender: TObject; var Action: TCloseAction);
    procedure UniFormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGrid1TitleClick(Column: TUniDBGridColumn);
  private
    FFilterIndex       : Integer;
   // FTabConsultaVisible: Boolean;
    fSoConsulta        : Boolean;
    fPrimaryKey        : String;
    fWhereExtra        : String;
    FTabIndex: Integer;
    procedure Filtrar(Value: boolean=False);
    procedure SetFilterIndex(const Value: Integer);
    procedure AtualizarNavegador(fbtInsert, fbtEdit, fbtPost, fbtCancel,
      fbtDelete: Boolean);
    procedure AbilitarControls(fActive: Boolean=False);
    procedure CallBackClose(AResult: Integer);
//    function Confirm(fValue: String): Boolean;
    function GridFindField(fField: String): Boolean;
    function DatasetInsertEdt: Boolean;
    procedure SetTabIndex(const Value: Integer);
    procedure CallBackConfirm(Sender: TComponent; AResult: Integer);
    function SelectFirstNRegistry(ZConnection:TZAbstractConnection; Campos, Table, OrderBy:String; N:Integer=25):String;
    { Private declarations }
  public
    { Public declarations }
    //
    function ValidarDados(Value:TUniDBEdit; Msg:String): Boolean; overload;
    function ValidarDados(Value:TUniDBLookupComboBox; Msg:String):Boolean; overload;
    function ValidarDados(Value:TUniDBDateTimePicker; Msg:String):Boolean; overload;
    function SelectPrimaryKeyFields: String;
    procedure IncPrimaryKey;
    function IsInsertOrEdit: Boolean;
    function IsInsert: Boolean;
    procedure H_Editar;
    property FilterIndex   : Integer read FFilterIndex write SetFilterIndex  Default -1;
    property SoConsulta    : Boolean read fSoConsulta  write fSoConsulta     Default False;
    property PrimaryKey    : String  read fPrimaryKey  write fPrimaryKey;
    Property WhereExtra    : String  read fWhereExtra  write fWhereExtra;
    Property TabIndex      : Integer read FTabIndex    write SetTabIndex     Default 0;
  end;

Var
  FieldNameReal : TStringList;

function frmCadPatterns: TfrmCadPatterns;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;
////////////////////////////////////////////////////////////////////////////////
function TfrmCadPatterns.ValidarDados(Value:TUniDBEdit; Msg:String):Boolean;
Begin
  Result:=False;
  if (Trim(Value.Text) = '') or (Value.Field.IsNull) then
  Begin
    Warning(Msg);
    Result:=True;
  End;
End;

function TfrmCadPatterns.ValidarDados(Value:TUniDBLookupComboBox; Msg:String):Boolean;
Begin
  Result:=False;
  if (Trim(Value.Text) = '') or (Value.Field.IsNull) then
  Begin
    Warning(Msg);
    Result:=True;
  End;
End;

function TfrmCadPatterns.ValidarDados(Value:TUniDBDateTimePicker; Msg:String):Boolean;
Begin
  Result:=False;
  if (Value.Field.IsNull) or (Value.Text = DataNula) then
  Begin
    Warning(Msg);
    Result:=True;
  End;
End;

Function TfrmCadPatterns.SelectFirstNRegistry(ZConnection:TZAbstractConnection; Campos, Table, OrderBy:String; N:Integer=25):String;
VAr
  Connector:String;
Begin
  Connector := LowerCase(ZConnection.Protocol);
  if  Pos('sqlite', Connector)     >0 then Result := 'SELECT '+Campos+' FROM '+ Table       +' LIMIT '    + IntToStr(N) else
  if  Pos('firebird', Connector)   >0 then Result := 'SELECT FIRST ' + IntToStr(N) + Campos+' FROM '   + Table       else
  if  Pos('postgresql', Connector) >0 then Result := 'SELECT TOP '   + IntToStr(N) + Campos+' FROM '   + Table       else
  if  Pos('mssql', Connector)      >0 then Result := 'SELECT TOP '   + IntToStr(N) + Campos+' FROM '   + Table       else
  if  Pos('oracle', Connector)     >0 then Result := 'SELECT '+Campos+' FROM '+ Table       +' WHERE Rownum <= ' + IntToStr(N) else
  if  Pos('mysql', Connector)      >0 then Result := 'SELECT '+Campos+' FROM '+ Table       +' LIMIT '    + IntToStr(N);
end;
////////////////////////////////////////////////////////////////////////////////

procedure TfrmCadPatterns.AbilitarControls(fActive:Boolean=False);
Begin
  UniKrUtil.AbilitarControls(Self, fActive);
end;
{Procedure _AbilitarControls(fReadOnly, fEnabled:Boolean; Count:Integer; ClassName:String);
Begin
  if ClassName = 'tunidbedit' then           TUniDBEdit(self.Components[Count]).ReadOnly           := fReadOnly;
  if ClassName = 'tuniedit' then             TUniEdit(self.Components[Count]).ReadOnly             := fReadOnly;
  if ClassName = 'tunidblookupcombobox' then TUniDBLookupComboBox(self.Components[Count]).Enabled  := fEnabled;
  if ClassName = 'tunidbmemo' then           TUniDBMemo(self.Components[Count]).ReadOnly           := fReadOnly;
  if ClassName = 'tunidblistbox' then        TUniDBListBox(self.Components[Count]).ReadOnly        := fReadOnly;
  if ClassName = 'tunidbcombobox' then       TUniDBComboBox(self.Components[Count]).ReadOnly       := fReadOnly;
  if ClassName = 'tunidbgrid' then           TUniDBGrid(self.Components[Count]).ReadOnly           := fReadOnly;
  if ClassName = 'tunicheckbox' then         TUniCheckBox(self.Components[Count]).ReadOnly         := fReadOnly;
  if ClassName = 'tunispeedbutton' then      TUniSpeedButton(self.Components[Count]).Enabled       := fEnabled;
  if ClassName = 'tunidbcheckbox' then       TUniDBCheckBox(self.Components[Count]).Enabled        := fEnabled;
  if ClassName = 'tunidbdatetimepicker' then TUniDBDateTimePicker(self.Components[Count]).ReadOnly := fReadOnly;
  if ClassName = 'tunigroupbox'   then       TUniGroupBox(self.Components[Count]).Enabled          := fEnabled;
  if ClassName = 'tunidbnumberedit' then     TUniDBNumberEdit(self.Components[Count]).ReadOnly     := fReadOnly;
  if ClassName = 'tunidbhtmlmemo' then       TUniDBHTMLMemo(self.Components[Count]).ReadOnly       := fReadOnly;
end;

Var
  I :Integer;

begin
  inherited;
  For I:=0 To Self.ComponentCount - 1 do
  Begin
    _AbilitarControls(False, True, I, LowerCase(self.Components[I].ClassName));
    if self.Components[I].Tag = 0 then
      _AbilitarControls(not fActive, fActive, I, LowerCase(self.Components[I].ClassName));
  end;
end; }

procedure TfrmCadPatterns.AtualizarNavegador(fbtInsert, fbtEdit, fbtPost, fbtCancel, fbtDelete:Boolean);
Begin  // CADVR 008
  btInsert.Enabled := fbtInsert;
  btEdit.Enabled   := fbtEdit;
  btPost.Enabled   := fbtPost;
  btCancel.Enabled := fbtCancel;
  btDelete.Enabled := fbtDelete;
  pnlNavegator01.Enabled := fbtInsert;
  //
  btPrint3.Enabled := fbtInsert;
  btClose2.Enabled := fbtInsert;
  //
  if dqrMain.IsEmpty then
  Begin
    btEdit.Enabled   := False;
    btDelete.Enabled := False;
    pnlNavegator01.Enabled := False;
  end;
end;

procedure TfrmCadPatterns.IncPrimaryKey;
Var
  Max   :Integer;
  dqrMax:TZQuery;
begin
  if dqrMain.FieldByName(PrimaryKey).IsNull then
  Begin
    Max:=1;
    dqrMax:=TZQuery.create(nil);
    dqrMax.Connection := dqrMain.Connection;
    dqrMax.SQL.Add('SELECT MAX('+PrimaryKey+') FROM '+dqrMain.TableName);
    Try
      dqrMax.Open;
      if not dqrMax.IsEmpty then
        if dqrMax.FieldByName('MAX').AsInteger >0 then
          Max := dqrMax.FieldByName('MAX').AsInteger + 1;
      dqrMax.Close;
    finally
      FreeAndNil(dqrMax);
    end;
    dqrMain.FieldByName(PrimaryKey).AsInteger:=Max;
  end;
end;

function TfrmCadPatterns.SelectPrimaryKeyFields:String;
var
  PKeys: TZSQLMetadata;
begin
  PKeys := TZSQLMetadata.Create(nil);
  try
    PKeys.Connection   := dqrMain.Connection;
    PKeys.TableName    := dqrMain.TableName;
    PKeys.MetadataType := mdPrimaryKeys;
    PKeys.Open;
    PKeys.First;
    while not PKeys.Eof do
    begin
      Result := PKeys.FieldByName('COLUMN_NAME').AsString;// está preparado apenas para um campo
      PKeys.Next;
    end;
  finally
    FreeAndNil(PKeys);
  end; // Exemplo; ShowMessage(SelectPrimaryKeyFields(dqrMain.TableName, frmMain.ZConnection1));
end;

procedure TfrmCadPatterns.SetFilterIndex(const Value: Integer);
begin
  inherited;
  if FFilterIndex = Value then exit;
    FFilterIndex := Value;
  //
  if FFilterIndex <> -1 then
    cbxListFields.ItemIndex := FFilterIndex;
end;

procedure TfrmCadPatterns.SetTabIndex(const Value: Integer);
begin
  FTabIndex := Value;
  PageControl1.TabIndex := FTabIndex;
end;

procedure TfrmCadPatterns.btEditClick(Sender: TObject);
begin
  inherited;
  AbilitarControls(True);
  AtualizarNavegador(False, False, True, True, False);
  dqrMain.Edit;
end;

procedure TfrmCadPatterns.btFirstClick(Sender: TObject);
begin
  inherited;
  dqrMain.First;
end;

procedure TfrmCadPatterns.btInsertClick(Sender: TObject);
begin
  inherited;
  AbilitarControls(True);
  AtualizarNavegador(False, False, True, True, False);
  dqrMain.Insert;
end;

procedure TfrmCadPatterns.btLastClick(Sender: TObject);
begin
  inherited;
  dqrMain.Last;
end;

procedure TfrmCadPatterns.btNextClick(Sender: TObject);
begin
  inherited;
  dqrMain.Next;
end;

procedure TfrmCadPatterns.btPostClick(Sender: TObject);
begin
  dqrMain.Post;
  inherited;
end;

procedure TfrmCadPatterns.btPriorClick(Sender: TObject);
begin
  inherited;
  dqrMain.Prior;
end;

procedure TfrmCadPatterns.btSearchClick(Sender: TObject);
begin
  inherited;
  Filtrar;
end;

procedure TfrmCadPatterns.cbxListFieldsChange(Sender: TObject);
begin
  inherited;
  edSearch.SetFocus;
end;

procedure TfrmCadPatterns.edSearchChange(Sender: TObject);
begin
  inherited;
  if Trim(edSearch.Text) = '' then
    Filtrar;
end;

procedure TfrmCadPatterns.edSearchKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if key = #13 then
    Filtrar;
end;

procedure TfrmCadPatterns.Filtrar(Value: boolean=False);
Const
  Perc2='%';
  Perc1='''%';

Var
  Campo    : String;
  fWhere   : String;
  OldQuery : String;
  Tabela   : String;
  //
  ErroSQL:TStrings;
  I:Integer;
Begin
  inherited;
  if (dqrMain.TableName<>'') and (not dqrMain.IsEmpty) then
  Begin
    dqrConsMain.DisableControls;
    Tabela:=dqrMain.TableName;
    Try
      OldQuery:='SELECT '+Campos+' FROM '+Tabela+' WHERE '+Copy(Trim(WhereExtra), 1, Length(Trim(WhereExtra))-3) + Enter + OrderBy;

      dqrConsMain.Close;
      if WhereExtra = '' then
        OldQuery:=SelectFirstNRegistry(dqrMain.Connection, Campos, Tabela, OrderBy);
        //OldQuery:='SELECT '+Campos+' FROM '+Tabela + Enter + OrderBy;


      WhereExtra := Trim(WhereExtra);
      if (WhereExtra <>'') and (Copy(Trim(WhereExtra), Length(Trim(WhereExtra))-2,3)<>'AND') then
        WhereExtra:= WhereExtra + ' AND ';

      if Where<>'' then
        fWhere:=Where+' AND';

      if cbxListFields.Items.Count > 0 then
      Begin
        Campo:=UpperCase(FieldNameReal.Strings[cbxListFields.ItemIndex]);
        if not Value then
        Begin
          dqrConsMain.SQL.Text:='SELECT ' + Campos + ' FROM ' + Tabela + '' + Enter +
                                'WHERE ' + WhereExtra + Enter + fWhere + ' ' +Tabela+'.'+ Campo + ' LIKE '
                                 +'''%' + edSearch.Text + '%''' + Enter + OrderBy;
        end
        else
        Begin
          dqrConsMain.SQL.Text:='SELECT *' + Campos + ' FROM ' + Tabela + '' + Enter +
                                'WHERE ' + WhereExtra + Enter + fWhere + ' ' + Campo + ' = '+
                                '''' + edSearch.Text + '''' + Enter + OrderBy;
        end;
      end else dqrConsMain.SQL.Text:=OldQuery;
      //dqrConsMain.SQL.SaveToFile('_teste.sql');

//      if (Trim(edSearch.Text) = '')  then
//        dqrConsMain.SQL.Text:=OldQuery;
      if (Trim(edSearch.Text) <> '')  then // em fase de teste 25/02/2019
        dqrConsMain.Open;
    except
    Begin
      ErroSQL:=TStringList.Create;
      Try
        if FileExists('_ErroSQL.txt') then
          ErroSQL.LoadFromFile('_ErroSQL.txt');
        //
        ErroSQL.Add('');
        ErroSQL.Add('------------------------------------------------');
        ErroSQL.Add(FormatDateTime('dd/mm/yyyy hh:mm:ss', now));
        for I:=0 to dqrConsMain.SQL.Count - 1 do
          ErroSQL.Add(dqrConsMain.SQL.Strings[I]); // Guarda a query no arquivo para depuração
        ErroSQL.Add('------------------------------------------------');
        ErroSQL.Add('');
        ErroSQL.SaveToFile('_ErroSQL.txt');
      Finally
        FreeAndNil(ErroSQL);
      End;
      dqrConsMain.Close;
      dqrConsMain.SQL.Text:=OldQuery;
      dqrConsMain.Open;
      Warning('Não é possível realizar a consulta.');
    end;
    end;
    dqrConsMain.EnableControls;
    DBGrid1.Refresh;
  end;
end;

procedure TfrmCadPatterns.FormClose(Sender: TObject; var Action: TCloseAction);
Var
  I:Integer;
begin
  inherited;
  For I:=0 to ComponentCount - 1 do
  if Components[I].Tag = 0 then
  Begin
    if (lowercase(Components[I].ClassName) = 'tztable') then
      if Trim(TZTable(Components[I]).TableName) <> '' then
        TZTable(Components[I]).Close;   // Fecha todas as tabelas do formulário que a TAG for igual a zero
    if (lowercase(Components[I].ClassName) = 'tzreadonlyquery') or (lowercase(Components[I].ClassName) = 'tzquery') then
       TZReadOnlyQuery(Components[I]).Close;
  end;
  //dqrMain.Close;
  if dqrConsMain.Active then
    dqrConsMain.Close; // em fase de teste 11/03/2019
end;

Function TfrmCadPatterns.DatasetInsertEdt:Boolean;
Var
  I:Integer;
Begin
  For I:=0 to ComponentCount - 1 do
    if lowercase(Components[I].ClassName) = 'tdatasource' then
      if TDataSource(Components[I]).State in [dsInsert, dsEdit] then
      Begin
        Result:=True;
        Exit
      end;
End;

procedure TfrmCadPatterns.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (ssCtrl in Shift) and (ssShift in Shift) then
    Case Key of
      Ord('E'): btEdit.Click;
    end;

  if Shift = [ssAlt] then
  Begin
    Case Key of
      Ord('I'): btInsert.Click; // Inserir
      Ord('S'): btPost.Click;   // Salvar
      Ord('C'): btCancel.Click; // Cancelar
      Ord('P'): btPrint3.Click; // Imprimir
    end;
  End;

  if Shift = [ssCtrl] then
  begin
    case Key of
      Ord('D'): btDelete.Click;
    end;
  end;
  if (Key = VK_ESCAPE) and (not DatasetInsertEdt) then
    Close;
end;

function TfrmCadPatterns.IsInsert: Boolean;
begin
  inherited;
  Result:=ddsMain.State in [dsInsert];
end;

function TfrmCadPatterns.IsInsertOrEdit:Boolean;
Begin
  inherited;
  Result:=ddsMain.State in [dsEdit, dsInsert];
end;


function frmCadPatterns: TfrmCadPatterns;
begin
  Result := TfrmCadPatterns(UniMainModule.GetFormInstance(TfrmCadPatterns));
end;

procedure TfrmCadPatterns.btCancelClick(Sender: TObject);
begin
  inherited;
  dqrMain.Cancel;
  AbilitarControls(False);
  AtualizarNavegador(True, True, False, False, True);
 // UniDBNavigator3.Enabled := True;
end;

procedure TfrmCadPatterns.btClose02Click(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmCadPatterns.CallBackClose(AResult:Integer);
begin
  inherited;
  if aResult = 6 then
  Begin
    dqrMain.Delete;
    AbilitarControls(False);
    AtualizarNavegador(True, True, False, False, True);
    if dqrMain.IsEmpty then
    Begin
      btEdit.Enabled   := False;
      btDelete.Enabled := False;
    end;
   // UniDBNavigator3.Enabled := True;
  End;
end;

procedure TfrmCadPatterns.CallBackConfirm(Sender: TComponent; AResult: Integer);
begin
  if AResult = mrYes then
    dqrMain.Delete;
end;

procedure TfrmCadPatterns.btDeleteClick(Sender: TObject);
begin
  MessageDlg('Deseja realmente deletar o registro atual?', mtConfirmation, mbYesNo,CallBackConfirm);
end;

procedure TfrmCadPatterns.PageControl1Change(Sender: TObject);
Var
  fActivePageIndex, I:Integer;
begin
  inherited;
  fActivePageIndex := PageControl1.ActivePageIndex;
  For I:=0 to ComponentCount - 1 do
    if LowerCase(Components[I].ClassName) = 'tztable' then
      if TZTable(Components[I]).State in [dsEdit, dsInsert] then
        PageControl1.ActivePageIndex := fActivePageIndex; // impede que o usuário mude de aba em modo de edição ou inserção

//  dqrConsMain.Refresh;
//  dqrConsMain.Open;
end;

procedure TfrmCadPatterns.DBGrid1DblClick(Sender: TObject);
Function GetPrimareKey(FieldDefault:String=''):String;
Var
  I:Integer;
Begin
  Result := FieldDefault;
  for I:=0 To dqrMain.FieldCount - 1 do
    if pfInKey in dqrMain.FieldList.Fields[I].ProviderFlags then
      Result := dqrMain.FieldList.Fields[I].FieldName;
End;

Var
  Campo:String;
begin
  inherited;
  if (dqrConsMain.Active) and (dqrConsMain.RecordCount>0) and (not SoConsulta) then
  Begin
    dqrMain.Refresh;
    Campo:=GetPrimareKey(UpperCase(FieldNameReal.Strings[cbxListFields.ItemIndex]));
    if not dqrMain.Locate(Campo, dqrConsMain.FieldByName(Campo).Value,[loCaseInsensitive]) then
      dqrMain.Locate(Campo, dqrConsMain.FieldByName(Campo).Value,[loCaseInsensitive, loPartialKey]);
    PageControl1.ActivePage:=tbCadastro;
  end;
end;

procedure TfrmCadPatterns.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Shift = [ssCtrl]) and (Key = 46) Then
    Key := 0; // Impede que o registro seja deletado com o precionamento das teclas Ctrl + Del
end;

procedure TfrmCadPatterns.DBGrid1TitleClick(Column: TUniDBGridColumn);
begin
  inherited;
//  UniDBGrid1.Columns.Items[0].Color
  dqrConsMain.DisableControls;
  if dqrConsMain.SortedFields <> Column.FieldName then
  Begin
    dqrConsMain.SortedFields := Column.FieldName;
    dqrConsMain.SortType     := stAscending
  End
  else
  Begin
    Case dqrConsMain.SortType of
      stAscending :dqrConsMain.SortType := stDescending;
      stDescending:dqrConsMain.SortType := stAscending;
    End;
  End;
  dqrConsMain.First;
  DBGrid1.Refresh;
  dqrConsMain.EnableControls;
end;

procedure TfrmCadPatterns.dqrMainAfterOpen(DataSet: TDataSet);
begin
  inherited;
  AbilitarControls(False);
  AtualizarNavegador(True, True, False, False, True);
end;

procedure TfrmCadPatterns.dqrMainAfterPost(DataSet: TDataSet);
begin
  inherited;
  AbilitarControls(False);
  AtualizarNavegador(True, True, False, False, True);
  pnlNavegator01.Enabled := True;
  if dqrConsMain.Active then
    dqrConsMain.Refresh;
end;

procedure TfrmCadPatterns.UniFormClose(Sender: TObject;
  var Action: TCloseAction);
Var
  I:Integer;
begin
  inherited;
  For I:=0 to ComponentCount - 1 do
  if Components[I].Tag = 0 then
  Begin
    if (lowercase(Components[I].ClassName) = 'tztable') then
      if Trim(TZTable(Components[I]).TableName) <> '' then
        TZTable(Components[I]).Close;   // Fecha todas as tabelas do formulário que a TAG for igual a zero
    if (lowercase(Components[I].ClassName) = 'tzreadonlyquery') or (lowercase(Components[I].ClassName) = 'tzquery') then
       TZReadOnlyQuery(Components[I]).Close;
  end;
  //dqrMain.Close;
  if dqrConsMain.Active then
    dqrConsMain.Close;
end;

procedure TfrmCadPatterns.UniFormCreate(Sender: TObject);
begin
  inherited;
  AjustarFetchRow(self);
  Campos    :='';  //Query_
  Where     :='';
  HOrderBy  :=''; // Horientação da ordenação
  WhereExtra:='';
  Enter     :=#13;
  OrderBy   :='';   //
end;

procedure TfrmCadPatterns.UniFormDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FieldNameReal) then
    FreeAndNil(FieldNameReal);
end;

procedure TfrmCadPatterns.UniFormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (ssCtrl in Shift) and (ssShift in Shift) then
    Case Key of
      Ord('E'): btEdit.Click;
    end;

  if Shift = [ssAlt] then
  Begin
    Case Key of
      Ord('I'): btInsert.Click; // Inserir
      Ord('S'): btPost.Click;   // Salvar
      Ord('C'): btCancel.Click; // Cancelar
      Ord('P'): btPrint3.Click; // Imprimir
    end;
  End;

  if Shift = [ssCtrl] then
  begin
    case Key of
      Ord('D'): btDelete.Click;
    end;
  end;
  if (Key = VK_ESCAPE) and (not DatasetInsertEdt) then
    Close;
end;

function TfrmCadPatterns.GridFindField(fField:String):Boolean;
Var
  I:Integer;
Begin
  Result:=False;
  for I:= 0 To DBGrid1.Columns.Count -1 do
  if DBGrid1.Columns.Items[I].FieldName = fField then
  Begin
    Result:=True;
    Exit;
  End;
End;

procedure TfrmCadPatterns.H_Editar;
begin
  AbilitarControls(True);
  AtualizarNavegador(False, False, True, True, False);
end;

procedure TfrmCadPatterns.UniFormShow(Sender: TObject);
Var
  I : Integer;
 // Teste : TProviderFlag;
begin
  Campos := '';
  PrimaryKey := SelectPrimaryKeyFields;
  FFilterIndex := -1;
  FieldNameReal := TStringList.Create;
//  PageControl1.ActivePage := tbCadastro;
  if Trim(dqrMain.TableName) <> '' then
  Begin
    dqrMain.Open;
    For I:=0 To dqrMain.FieldCount -1 do
    Begin
      if (pfInKey in dqrMain.FieldByName(dqrMain.Fields[I].FieldName).ProviderFlags) and
         (PrimaryKey='') then
        PrimaryKey := dqrMain.Fields[I].FieldName;


      if dqrMain.Fields[I].Tag = 0 then
      Begin
        if not GridFindField(dqrMain.Fields[I].FieldName) then
        Begin
          DBGrid1.Columns.Add;
          DBGrid1.Columns.Items[DBGrid1.Columns.Count-1].FieldName := dqrMain.Fields[I].FieldName;
          DBGrid1.Columns.Items[DBGrid1.Columns.Count-1].Title.Caption:=dqrMain.Fields[I].DisplayLabel;
        End;
////////////////////////////////////////////////////////////////////////////////
        FieldNameReal.Add(dqrMain.Fields[I].FieldName);
        cbxListFields.Items.Add(dqrMain.Fields[I].DisplayLabel);
        Campos:= Campos + dqrMain.TableName+'.'+ dqrMain.Fields[I].FieldName+' ,';
      end;
    end;
    if PrimaryKey<>'' then
      Campos:= Campos + dqrMain.TableName+'.'+ PrimaryKey+'';

{
if PrimaryKey<>'' then
  Campos:= Campos + dqrMain.TableName+'."'+ PrimaryKey+'"';
}

    if Campos[Length(Campos)]=',' then
      Campos:=Copy(Campos, 1, Length(Campos)-1);
    cbxListFields.ItemIndex:=0;

    Filtrar;
    dqrMain.First;
  end;
  For I:=0 to ComponentCount - 1 do
    if (lowercase(Components[I].ClassName) = 'tztable') and (Components[I].Tag = 0) then
      if Trim(TZTable(Components[I]).TableName) <> '' then
        TZTable(Components[I]).Open;   // abri todas as tabelas do formulário que a TAG for igual a zero

  For I:=0 to ComponentCount - 1 do
    if (lowercase(Components[I].ClassName) = 'tzreadonlyquery') and (Components[I].Tag = 1) then
      if Trim(TZReadOnlyQuery(Components[I]).SQL.Text) <> '' then
        TZReadOnlyQuery(Components[I]).Open;   // abri todas as tabelas do formulário que a TAG for igual a zero

//  pnlTitileCad.Caption:=Self.Caption;
  if SoConsulta then
  Begin
    tbCadastro.Visible:=False;
    PageControl1.ActivePage := tbConsulta;
  End
  else
    if TabIndex = 0 then
      PageControl1.ActivePage := tbCadastro;
  //AtualizarNavegador(True, True, False, False, True);
  inherited;
end;

end.
