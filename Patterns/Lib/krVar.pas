unit krVar;

interface
Uses
  Classes, Forms, ExtCtrls, IniFiles;

type
  TIPType = (iptLocal, iptExternal); 

Const
   fIPLocal                :String  = '';
   UserControl_User        :String  = ''; // Usuário do sistema
   UserControl_LoginName   :String  = ''; // Login do
   UserControl_Pass        :String  = '';
   UserControl_Email       :String  = '';
   UserControl_UserID      :Integer = -1;
   UserControl_Profile     :Integer = -1;
   UserControl_Privilegiado:Boolean = False;
   WhereExtra              :String  = '';
   OrderBy                 :String  = '';
   FoneMask                :String  = '(99)9999-9999;1;_';
   DataMask                :String  = '99/99/9999;1;_';
   HoraMask                :String  = '99:99:99;1;_';
   Enter                   :char    = #13;
   Status_Concluido                 = 4;
   Status_Pendente                  = 5;
   DataNula                :String  = '30/12/1899';
  // NewTitleMain            :String  ='';



Var
  fForm:TForm;
  ArrayForms      : TStringList; // Guarda o nome de todos os forma que estão abertos no sistema
  //IPServer      : String;    // Guarda o número IP do servidor de Banco de Dados
  DefaultFilter   : Boolean;     // Define sea impressorapadrão é a matricial ou não
  TrayIcon        : TTrayIcon;   // Coloca o Icone do sistema no TrayIcon do S.O.
  Config          : TIniFile;
  FileNameConf    : String;
  Versao          : String;      // Guarda as informações da Versão do Sistema
  //TitleMain     : String;


implementation




end.

