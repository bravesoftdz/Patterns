unit fmFrameCadPatterns;

interface

uses
  uniGUIFrame, fmFramePatterns, UniKrUtil,

  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
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
  TfrmFrameCadPatterns = class(TfrmFramePatterns)
    dqrMain: TZTable;
    dqrConsMain: TZReadOnlyQuery;
    ddsMain: TDataSource;
    ddsConsMain: TDataSource;
    msgSalvando: TUniScreenMask;
    msgInserir: TUniScreenMask;
    msgEditar: TUniScreenMask;
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
    pnlMensage: TUniPanel;
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
    procedure UniFrameCreate(Sender: TObject);
    procedure btInsertClick(Sender: TObject);
    procedure btEditClick(Sender: TObject);
    procedure btPostClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure btFirstClick(Sender: TObject);
    procedure btPriorClick(Sender: TObject);
    procedure btNextClick(Sender: TObject);
    procedure btLastClick(Sender: TObject);
    procedure btSearchClick(Sender: TObject);
    procedure cbxListFieldsChange(Sender: TObject);
    procedure edSearchChange(Sender: TObject);
    procedure edSearchKeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure btClose2Click(Sender: TObject);
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

implementation

{$R *.dfm}
Function TfrmFrameCadPatterns.SelectFirstNRegistry(ZConnection:TZAbstractConnection; Campos, Table, OrderBy:String; N:Integer=25):String;
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

procedure TfrmFrameCadPatterns.Filtrar(Value: boolean=False);
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

      if (Trim(edSearch.Text) = '')  then
        dqrConsMain.SQL.Text:=OldQuery;
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

procedure TfrmFrameCadPatterns.AbilitarControls(fActive: Boolean=False);
begin
  UniKrUtil.AbilitarControls(Self, fActive);
end;

procedure TfrmFrameCadPatterns.AtualizarNavegador(fbtInsert, fbtEdit, fbtPost,
  fbtCancel, fbtDelete: Boolean);
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

procedure TfrmFrameCadPatterns.btCancelClick(Sender: TObject);
begin
  inherited;
  dqrMain.Cancel;
  AbilitarControls(False);
  AtualizarNavegador(True, True, False, False, True);
 // UniDBNavigator3.Enabled := True;
end;

procedure TfrmFrameCadPatterns.btClose2Click(Sender: TObject);
begin
  inherited;
  TUniTabSheet(Self.Parent).Destroy;
end;

procedure TfrmFrameCadPatterns.CallBackClose(AResult:Integer);
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

procedure TfrmFrameCadPatterns.CallBackConfirm(Sender: TComponent; AResult: Integer);
begin
  if AResult = mrYes then
    dqrMain.Delete;
end;

procedure TfrmFrameCadPatterns.cbxListFieldsChange(Sender: TObject);
begin
  inherited;
  edSearch.SetFocus;
end;

function TfrmFrameCadPatterns.DatasetInsertEdt: Boolean;
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

procedure TfrmFrameCadPatterns.DBGrid1DblClick(Sender: TObject);
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

procedure TfrmFrameCadPatterns.edSearchChange(Sender: TObject);
begin
  inherited;
  if Trim(edSearch.Text) = '' then
    Filtrar;
end;

procedure TfrmFrameCadPatterns.edSearchKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if key = #13 then
    Filtrar;
end;

function TfrmFrameCadPatterns.GridFindField(fField: String): Boolean;
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

procedure TfrmFrameCadPatterns.H_Editar;
begin
  AbilitarControls(True);
  AtualizarNavegador(False, False, True, True, False);
end;

procedure TfrmFrameCadPatterns.IncPrimaryKey;
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

function TfrmFrameCadPatterns.IsInsert: Boolean;
begin
  Result:=ddsMain.State in [dsEdit, dsInsert];
end;

function TfrmFrameCadPatterns.IsInsertOrEdit: Boolean;
begin
  Result:=ddsMain.State in [dsEdit, dsInsert];
end;

function TfrmFrameCadPatterns.SelectPrimaryKeyFields: String;
var
  PKeys: TZSQLMetadata;
begin
  Result := '';
  if dqrMain.Active then
  Begin
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
end;

procedure TfrmFrameCadPatterns.SetFilterIndex(const Value: Integer);
begin
  if FFilterIndex = Value then exit;
    FFilterIndex := Value;
  //
  if FFilterIndex <> -1 then
    cbxListFields.ItemIndex := FFilterIndex;
end;

procedure TfrmFrameCadPatterns.SetTabIndex(const Value: Integer);
begin
  FTabIndex := Value;
  PageControl1.TabIndex := FTabIndex;
end;

procedure TfrmFrameCadPatterns.btDeleteClick(Sender: TObject);
begin
  inherited;
  MessageDlg('Deseja realmente deletar o registro atual?', mtConfirmation, mbYesNo,CallBackConfirm);
end;

procedure TfrmFrameCadPatterns.btEditClick(Sender: TObject);
begin
  inherited;
  AbilitarControls(True);
  AtualizarNavegador(False, False, True, True, False);
  dqrMain.Edit;
end;

procedure TfrmFrameCadPatterns.btFirstClick(Sender: TObject);
begin
  inherited;
  dqrMain.First;
end;

procedure TfrmFrameCadPatterns.btInsertClick(Sender: TObject);
begin
  inherited;
  AbilitarControls(True);
  AtualizarNavegador(False, False, True, True, False);
  dqrMain.Insert;
end;

procedure TfrmFrameCadPatterns.btLastClick(Sender: TObject);
begin
  inherited;
  dqrMain.Last;
end;

procedure TfrmFrameCadPatterns.btNextClick(Sender: TObject);
begin
  inherited;
  dqrMain.Next;
end;

procedure TfrmFrameCadPatterns.btPostClick(Sender: TObject);
begin
  dqrMain.Post;
  inherited;
end;

procedure TfrmFrameCadPatterns.btPriorClick(Sender: TObject);
begin
  inherited;
  dqrMain.Prior;
end;

procedure TfrmFrameCadPatterns.btSearchClick(Sender: TObject);
begin
  inherited;
  Filtrar;
end;

procedure TfrmFrameCadPatterns.UniFrameCreate(Sender: TObject);
Var
  I           : Integer;
 // Teste : TProviderFlag;
begin
  Height := 443;
  Width  := 755;
  //
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

function TfrmFrameCadPatterns.ValidarDados(Value: TUniDBDateTimePicker;
  Msg: String): Boolean;
begin
  Result:=False;
  if (Value.Field.IsNull) or (Value.Text = DataNula) then
  Begin
    Warning(Msg);
    Result:=True;
  End;
end;

function TfrmFrameCadPatterns.ValidarDados(Value: TUniDBLookupComboBox;
  Msg: String): Boolean;
begin
  Result:=False;
  if (Trim(Value.Text) = '') or (Value.Field.IsNull) then
  Begin
    Warning(Msg);
    Result:=True;
  End;
end;

function TfrmFrameCadPatterns.ValidarDados(Value: TUniDBEdit;
  Msg: String): Boolean;
begin
  Result:=False;
  if (Trim(Value.Text) = '') or (Value.Field.IsNull) then
  Begin
    Warning(Msg);
    Result:=True;
  End;
end;

end.
