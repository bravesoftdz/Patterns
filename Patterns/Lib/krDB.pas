{
@abstract(Kernel de funções para acesso à Banco de Dados.)
@author(Analista / Programador : Jairo dos Santos Gurgel <jsgurgel@hotmail.com>)
@created(2010)
@lastmod(26/10/2012)
}
unit krDB;


interface

uses
  Forms,
  uniGUIFrame, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniGUIBaseClasses,
  SysUtils, KrUtil, IniFiles, ExtDlgs, StdCtrls,
  ZConnection, ZDataset, DB, ZAbstractRODataset, ZAbstractDataset, ZAbstractTable;

Var
  // Irmações de configuração do banco de dados
  DB_HostName        :String;
  DB_DataBase        :String;
  DB_UserName        :String;
  DB_Password        :String;
  DB_OSAuthentication:boolean;
  DB_FileConfig      :String;
  DB_Protocol        :String;


  procedure AjustarFetchRow(fForm:TuniForm; Value:integer=100); overload;
  procedure AjustarFetchRow(fForm:TUniFrame; Value:integer=100);overload;

  procedure ConfigDataBase(Var aSQLConnection:TZConnection); overload;
  procedure ConfigDataBase(Var aSQLConnection:TZConnection; HostName, DataBase, UserName,
                         Password, Protocol:String; OSAuthentication:boolean);overload;

  function ConectDataBase(Var aDatabase: TZConnection):boolean;
  procedure GravarIni(Var aDatabase: TZConnection);
  function CarregarIni(Var aDatabase: TZConnection):Boolean;
//  procedure SetCalendario(DataSet: TDataSet; Edit:TCustomEdit; Field:String);

implementation
//Uses

procedure AjustarFetchRow(fForm:TuniForm; Value:integer=100);
Var // Forms, ZConnection, ZDataset, DB, ZAbstractRODataset, ZAbstractDataset, ZAbstractTable
  I:Integer;
  fActive:Boolean;
begin
//  Screen.co
 // if Assigned(fForm) then
  Begin
    For I:=0 To fForm.ComponentCount - 1 do
    Begin
      if UpperCase(fForm.Components[I].ClassName) = 'TZTABLE' then
      Begin
        fActive := TZTable(fForm.Components[I]).Active;
        TZTable(fForm.Components[I]).FetchRow := 100;
        TZTable(fForm.Components[I]).Active := fActive;
      End
      else
       if UpperCase(fForm.Components[I].ClassName) = 'TZQUERY' then
       Begin
         fActive := TZQuery(fForm.Components[I]).Active;
         TZQuery(fForm.Components[I]).FetchRow := 100;
         TZQuery(fForm.Components[I]).Active := fActive;
       End;
    End;
  End;
end;

procedure AjustarFetchRow(fForm:TUniFrame; Value:integer=100);
Var // Forms, ZConnection, ZDataset, DB, ZAbstractRODataset, ZAbstractDataset, ZAbstractTable
  I:Integer;
  fActive:Boolean;
begin
//  Screen.co
  if Assigned(fForm) then
  Begin
    For I:=0 To fForm.ComponentCount - 1 do
    Begin
      if UpperCase(fForm.Components[I].ClassName) = 'TZTABLE' then
      Begin
        fActive := TZTable(fForm.Components[I]).Active;
        TZTable(fForm.Components[I]).FetchRow := 100;
        TZTable(fForm.Components[I]).Active := fActive;
      End
      else
       if UpperCase(fForm.Components[I].ClassName) = 'TZQUERY' then
       Begin
         fActive := TZQuery(fForm.Components[I]).Active;
         TZQuery(fForm.Components[I]).FetchRow := 100;
         TZQuery(fForm.Components[I]).Active := fActive;
       End;
    End;
  End;
end;
(*
procedure SetCalendario(DataSet: TDataSet; Edit:TCustomEdit; Field:String);
Var // Uses ExtDlgs, db, StdCtrls
  Calendar:TCalendarDialog;
begin
  Calendar:=TCalendarDialog.Create(nil);
  Try
    if DataSet.State in [dsEdit, dsInsert] then
    Begin
      if DataSet.State = dsInsert then
        Calendar.Date:=Now
      else
        Calendar.Date:=DataSet.FieldByName(Field).AsDateTime;
      Calendar.CancelCaption:='Cancelar';
      Calendar.Title        :='Calendário';
      Calendar.OKCaption    :='Ok';
      Calendar.Execute;
      if Calendar.Execute then
        Edit.Text:=DateToStr(Calendar.Date);
    end;
  finally
    FreeAndNil(Calendar);
  end;
end; *)

function CarregarIni(Var aDatabase: TZConnection):Boolean;
Var
  fFileIni:TIniFile;
  fConfig:String;
Begin
  DB_FileConfig      :=HomeDir+'Config.ini';
  Result           :=False;
  fFileIni:=TIniFile.Create(DB_FileConfig);
  Try
    if FileExists(DB_FileConfig) then
    Begin
      DB_Protocol        :=Trim(fFileIni.ReadString('Database', 'Protocol', DB_Protocol));
      DB_HostName        :=Trim(fFileIni.ReadString('Database', 'HostName', DB_HostName));
      DB_Database        :=Trim(fFileIni.ReadString('Database', 'DatabaseName', DB_Database));


      fConfig        :=Trim(fFileIni.ReadString('Database', 'Username', fConfig));
      if fConfig <> '' then
        DB_UserName        :=Trim(Criptografar(fFileIni.ReadString('Database', 'Username', DB_UserName)));

      fConfig        :=Trim(fFileIni.ReadString('Database', 'Password', fConfig));
      if fConfig <> '' then
        DB_Password        :=Trim(Criptografar(fFileIni.ReadString('Database', 'Password', DB_Password)));


      DB_OSAuthentication:=fFileIni.ReadBool('System', 'OSAuthentication', DB_OSAuthentication);
      Result           :=True;
      if Uppercase(Copy(DB_Protocol,1,8))='FIREBIRD' then
      Begin
        DB_UserName:='sysdba';
        DB_Password:='masterkey';
      end;
    end
    else GravarIni(aDatabase);
  finally
    if ((Copy(aDatabase.Protocol, 1, 6) = 'sqlite') or (Copy(aDatabase.Protocol, 1, 8) = 'firebird')) and
        (DB_Database = ExtractFilename(aDatabase.Database)) then // Adaptado para funcionar direto no Pendrive
      DB_Database := HomeDir + DB_Database;
    ConfigDataBase(aDatabase);
    FreeAndNil(fFileIni);
  end;
end;

procedure GravarIni(Var aDatabase: TZConnection);
Var
  DB_FileIni:TIniFile;
Begin
  if not FileExists(DB_FileConfig) then
  Begin
    if aDatabase.HostName='' then
      DB_HostName        :=' ' else DB_HostName := aDatabase.HostName;
    DB_Database        :=ExtractFileName(aDatabase.Database);
    DB_UserName        :=aDatabase.User;
    DB_Password        :=aDatabase.Password;
    DB_Protocol        :=aDatabase.Protocol;
    DB_OSAuthentication:=False;
  end;
  //
  DB_FileIni:=TIniFile.Create(DB_FileConfig);
  Try
    DB_FileIni.WriteString('Database', 'Protocol', DB_Protocol);
    DB_FileIni.WriteString('Database', 'HostName', DB_HostName);
    DB_FileIni.WriteString('Database', 'DatabaseName', DB_Database);
    DB_FileIni.WriteString('Database', 'Username', Criptografar(DB_UserName));
    DB_FileIni.WriteString('Database', 'Password', Criptografar(DB_Password));
    DB_FileIni.WriteBool('System', 'OSAuthentication', DB_OSAuthentication);
    DB_FileIni.UpdateFile;// Salva as informações no Arquivo INI
  finally
    FreeAndNil(DB_FileIni);
  end;
end;

function ConectDataBase(Var aDatabase: TZConnection):boolean;
begin
  aDataBase.Connected:=false;
  try
    aDataBase.connected:=true;
    Result:=True;
  except
    on e:Exception do
    begin
      Result:=False;
      Warning(e.Message);
      aDatabase.Connected:=false;
      Warning('Servidor desligado ou inválido.');
    end;
  end;
end;

procedure ConfigDataBase(Var aSQLConnection:TZConnection);
Begin
  ConfigDataBase(aSQLConnection, DB_HostName, DB_DataBase, DB_UserName, DB_Password, DB_Protocol, DB_OSAuthentication);
end;

procedure ConfigDataBase(Var aSQLConnection:TZConnection; HostName, DataBase, UserName,
                         Password, Protocol:String; OSAuthentication:boolean);
Var
  fActive:boolean;
Begin
  fActive                 := aSQLConnection.Connected;
  aSQLConnection.Connected:= False;
  aSQLConnection.Database := DataBase;
  if Trim(HostName)<>'' then aSQLConnection.HostName := HostName;
  aSQLConnection.Protocol := Protocol;
  if Trim(Password)<>'' then aSQLConnection.Password := Password;
  if Trim(UserName)<>'' then aSQLConnection.User     := UserName;
  aSQLConnection.Connected:= fActive;
end;

end.

