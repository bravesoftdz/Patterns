object UniMainModule: TUniMainModule
  OldCreateOrder = False
  OnCreate = UniGUIMainModuleCreate
  BrowserOptions = [boDisableMouseRightClick]
  MonitoredKeys.Keys = <>
  Height = 182
  Width = 246
  object ZConnection1: TZConnection
    ControlsCodePage = cCP_UTF16
    ClientCodepage = 'utf8'
    Properties.Strings = (
      'codepage=utf8'
      'controls_cp=CP_UTF16')
    TransactIsolationLevel = tiReadCommitted
    HostName = '172.17.104.4'
    Port = 0
    Database = 'db_sgh'
    User = 'root'
    Password = 'deinf'
    Protocol = 'mysql'
    LibraryLocation = 'C:\xampp\htdocs\libmysql.dll'
    Left = 52
    Top = 8
  end
  object dqrLog: TZTable
    Connection = ZConnection1
    TableName = 'tb_log'
    Left = 56
    Top = 72
  end
end
