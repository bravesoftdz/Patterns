?
 TFRMALTSENHAPATTERNS 0?  TPF0TfrmAltSenhaPatternsfrmAltSenhaPatternsLeft Top ActiveControledSenhaAtualBorderIcons BorderStylebsDialogCaptionAlterar SenhaClientHeight? ClientWidthColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height?	Font.NameTahoma
Font.Style OldCreateOrder
OnActivateFormActivatePixelsPerInch`
TextHeight 	TUniPanel	UniPanel1Left Top? WidthHeight)AlignalBottomAnchorsakLeftakRightakBottom TabOrderBorderStyleubsFrameLoweredColorclWindow 
TUniBitBtnbtOkLeft:TopWidthKHeightCaptionOkTabOrder OnClick	btOkClick  
TUniBitBtnbtCancelLeft? TopWidthKHeightCaptionCancelarTabOrderOnClickbtCancelClick  TUniGroupBoxUniGroupBox1LeftXTop?Width? HeightiCaptionUniGroupBox1TabOrder   TUniGroupBoxUniGroupBox2LeftTop?WidthHeightJTabOrder  
TUniDBEdit	edUsuarioLeftFTopWidth? Height	DataFieldnome
DataSource
ddsUsuarioTabOrder ReadOnly	  TUniEditedSenhaAtualLeftFTop,Width? PasswordChar*TabOrderClearButton	
OnKeyPressedSenhaAtualKeyPress  	TUniLabel	UniLabel1Left	TopWidth$HeightCaption   UsuárioTabOrder  	TUniLabel	UniLabel2Left	Top.Width:HeightCaptionSenha AtualTabOrder   TUniGroupBoxUniGroupBox3LeftTopLWidthHeightJTabOrder TUniEditedConfirmacaoLeftFTop,Width? PasswordChar*TabOrderClearButton	
OnKeyPressedConfirmacaoKeyPress  	TUniLabel	UniLabel3Left	TopWidth:HeightCaption
Nova SenhaTabOrder  	TUniLabel	UniLabel4Left	Top.Width<HeightCaption   ConfirmaçãoTabOrder  TUniEditedNovaSenhaLeftFTopWidth? PasswordChar*TabOrder ClearButton	
OnKeyPressedNovaSenhaKeyPress   TDataSource
ddsUsuarioDataSet
dqrUsuarioLeft? Top  TZQuery
dqrUsuario
ConnectionUniMainModule.ZConnection1UpdateObjectZUpdateSQL1
BeforePostdqrUsuarioBeforePostSQL.StringsSELECT *from tb_usuariowhere   usuario  = :nome and  senha   = :senha ParamsDataTypeftStringNamenome	ParamType	ptUnknown DataTypeftStringNamesenha	ParamType	ptUnknown  Left? TopP	ParamDataDataTypeftStringNamenome	ParamType	ptUnknown DataTypeftStringNamesenha	ParamType	ptUnknown    TZUpdateSQLZUpdateSQL1DeleteSQL.StringsDELETE FROM tb_usuarioWHERE)  tb_usuario.id_usuario = :OLD_id_usuario InsertSQL.StringsINSERT INTO tb_usuario8  (id_usuario, nome, usuario, senha, is_adm, id_unidade)VALUES>  (:id_usuario, :nome, :usuario, :senha, :is_adm, :id_unidade) ModifySQL.StringsUPDATE tb_usuario SET  id_usuario = :id_usuario,  nome = :nome,  usuario = :usuario,  senha = :senha,  is_adm = :is_adm,  id_unidade = :id_unidadeWHERE)  tb_usuario.id_usuario = :OLD_id_usuario UseSequenceFieldForRefreshSQLLeft? TopH	ParamDataDataType	ftUnknownName
id_usuario	ParamType	ptUnknown DataType	ftUnknownNamenome	ParamType	ptUnknown DataType	ftUnknownNameusuario	ParamType	ptUnknown DataType	ftUnknownNamesenha	ParamType	ptUnknown DataType	ftUnknownNameis_adm	ParamType	ptUnknown DataType	ftUnknownName
id_unidade	ParamType	ptUnknown DataType	ftUnknownNameOLD_id_usuario	ParamType	ptUnknown     