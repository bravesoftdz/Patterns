object frmPreview: TfrmPreview
  Left = 194
  Top = 156
  ClientHeight = 500
  ClientWidth = 644
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 481
    Width = 644
    Height = 19
    Panels = <
      item
        Width = 200
      end
      item
        Width = 50
      end>
  end
  object RLPreview1: TRLPreview
    Left = 0
    Top = 24
    Width = 644
    Height = 457
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    Align = alClient
    TabOrder = 1
  end
  object PanelTools: TPanel
    Left = 0
    Top = 0
    Width = 644
    Height = 24
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 1
    Caption = ' '
    TabOrder = 2
    object SpeedButtonPrint: TSpeedButton
      Left = 1
      Top = 1
      Width = 53
      Height = 22
      Hint = 'Imprimir'
      Caption = 'Imprimir...'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      OnClick = SpeedButtonPrintClick
    end
    object SpeedButtonSetup: TSpeedButton
      Left = 124
      Top = 1
      Width = 22
      Height = 22
      Hint = 'Configura'#231#245'es'
      Caption = ' '
      Flat = True
      Glyph.Data = {
        4E010000424D4E01000000000000760000002800000011000000120000000100
        040000000000D8000000C40E0000C40E00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777700000007777830388888888700000007700833370077778700000007733
        037303737F7870000000770F33F33F30F778700000007330F77770337F787000
        0000737F7383F7F3F77870000000733738F837337F78700000007703F8F8733F
        F77870000000773F08F8073F7F787000000077338888F33FF778700000007777
        8FFFFFFF7F787000000077778FFFFFFFFF887000000077778FFFFFFF88887000
        000077778FFFFFFF87887000000077778FFFFFFF888770000000777788888888
        887770000000777777777777777770000000}
      Spacing = -1
      OnClick = SpeedButtonSetupClick
    end
    object SpeedButtonFirst: TSpeedButton
      Left = 160
      Top = 1
      Width = 22
      Height = 22
      Hint = 'Primeira P'#225'gina'
      Caption = ' '
      Flat = True
      Glyph.Data = {
        D6000000424DD60000000000000076000000280000000E0000000C0000000100
        04000000000060000000C40E0000C40E00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7700777770777077770077770077007777007770C070C0777700770CE00CE000
        070070CEEECEEEEEC70070E7FFE7FFFFC700770EFC0EFCCCC7007770EC70EC77
        770077770C770C77770077777C777C7777007777777777777700}
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      OnClick = SpeedButtonFirstClick
    end
    object SpeedButtonPrior: TSpeedButton
      Left = 184
      Top = 1
      Width = 22
      Height = 22
      Hint = 'P'#225'gina Anterior'
      Caption = ' '
      Flat = True
      Glyph.Data = {
        D6000000424DD60000000000000076000000280000000E0000000C0000000100
        04000000000060000000C40E0000C40E00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7700777770777777770077770077777777007770C07777777700770CE0000000
        070070CEEEEEEEEEC70070E7FFFFFFFFC700770EFCCCCCCCC7007770EC777777
        770077770C777777770077777C77777777007777777777777700}
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      OnClick = SpeedButtonPriorClick
    end
    object SpeedButtonNext: TSpeedButton
      Left = 344
      Top = 1
      Width = 22
      Height = 22
      Hint = 'Pr'#243'xima P'#225'gina'
      Caption = ' '
      Flat = True
      Glyph.Data = {
        D6000000424DD60000000000000076000000280000000E0000000C0000000100
        04000000000060000000C40E0000C40E00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        770077777777077777007777777700777700777777770C077700700000000EC0
        77007CEEEEEEEEEC07007CFFFFFFFF7E07007CCCCCCCCFE0770077777777CE07
        770077777777C077770077777777C77777007777777777777700}
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      OnClick = SpeedButtonNextClick
    end
    object SpeedButtonLast: TSpeedButton
      Left = 368
      Top = 1
      Width = 22
      Height = 22
      Hint = #218'ltima P'#225'gina'
      Caption = ' '
      Flat = True
      Glyph.Data = {
        D6000000424DD60000000000000076000000280000000E0000000C0000000100
        04000000000060000000C40E0000C40E00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        77007777077707777700777700770077770077770C070C07770070000EC00EC0
        77007CEEEEECEEEC07007CFFFF7EFF7E07007CCCCFE0CFE077007777CE07CE07
        77007777C077C07777007777C777C77777007777777777777700}
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      OnClick = SpeedButtonLastClick
    end
    object SpeedButtonZoomDown: TSpeedButton
      Left = 404
      Top = 1
      Width = 22
      Height = 22
      Hint = 'Diminuir Zoom'
      Caption = ' '
      Flat = True
      Glyph.Data = {
        4E010000424D4E01000000000000760000002800000012000000120000000100
        040000000000D8000000C40E0000C40E00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        77777700000070000000007777777700000070FFF7F7F07777777700000070F7
        7777707777000700000070F77777F07776F60700000070F7777770776FE60700
        000070F7778800067E607700000070F77866666786077700000070F78EEEEE66
        00777700000070F8777777EE60777700000070F877F777EE6077770000007008
        7700000E60777700000077787FFFFF7E60777700000077787FFFFF7E60777700
        0000777787FFFF7E077777000000777778777770777777000000777777880007
        777777000000777777777777777777000000}
      Spacing = -1
      OnClick = SpeedButtonZoomDownClick
    end
    object SpeedButtonZoomUp: TSpeedButton
      Left = 428
      Top = 1
      Width = 22
      Height = 22
      Hint = 'Aumentar Foom'
      Caption = ' '
      Flat = True
      Glyph.Data = {
        4E010000424D4E01000000000000760000002800000012000000120000000100
        040000000000D8000000C40E0000C40E00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        77777700000070000000007777777700000070FFF7F7F07777777700000070F7
        7777707777007700000070F77777F07776F60700000070F7777770776FE60700
        000070F7778800067E600700000070F77866666786077700000070F78EEEEE66
        00777700000070F8777707EE60777700000070F877F7077E6077770000007008
        7700000E60777700000077787FF7077E60777700000077787FFF0F7E60777700
        0000777787FFFF7E077777000000777778777770777777000000777777880007
        777777000000777777777777777777000000}
      Spacing = -1
      OnClick = SpeedButtonZoomUpClick
    end
    object SpeedButtonClose: TSpeedButton
      Left = 680
      Top = 1
      Width = 49
      Height = 22
      Hint = 'Fechar Preview'
      Caption = 'Fechar'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      OnClick = SpeedButtonCloseClick
    end
    object Bevel7: TBevel
      Left = 116
      Top = 0
      Width = 2
      Height = 24
    end
    object Bevel8: TBevel
      Left = 152
      Top = 0
      Width = 2
      Height = 24
    end
    object Bevel9: TBevel
      Left = 396
      Top = 0
      Width = 2
      Height = 24
    end
    object Bevel10: TBevel
      Left = 600
      Top = 0
      Width = 2
      Height = 24
    end
    object SpeedButtonSave: TSpeedButton
      Left = 56
      Top = 1
      Width = 53
      Height = 22
      Hint = 'Salvar'
      Caption = 'Salvar...'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      OnClick = SpeedButtonSaveClick
    end
    object SpeedButtonViews: TSpeedButton
      Left = 608
      Top = 1
      Width = 22
      Height = 22
      Hint = 'V'#225'rias P'#225'ginas'
      Flat = True
      Glyph.Data = {
        EE000000424DEE000000000000007600000028000000100000000F0000000100
        04000000000078000000C40E0000C40E00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00BBBBBBB00BBB
        BBBBBBBBBB0000BBBBBBBBBBB0B00B0BBBBBBBBBBBB00BBBBBBBBBBBBBB00BBB
        BBBB8888888008888888F777777007777778F770000000000778F77777700777
        7778FFFFFFF00FFFFFF8BBBBBBB00BBBBBBBBBBBBBB00BBBBBBBBBBBB0B00B0B
        BBBBBBBBBB0000BBBBBBBBBBBBB00BBBBBBB}
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      OnClick = SpeedButtonViewsClick
    end
    object Bevel11: TBevel
      Left = 636
      Top = 0
      Width = 2
      Height = 24
    end
    object SpeedButtonEdit: TSpeedButton
      Left = 644
      Top = 1
      Width = 22
      Height = 22
      Hint = 'Editar'
      AllowAllUp = True
      GroupIndex = 1
      Flat = True
      Glyph.Data = {
        EE000000424DEE000000000000007600000028000000100000000F0000000100
        04000000000078000000C40E0000C40E00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00BBBBBBBBBBBB
        BBBBBBBBBBBBB00BBBBBBBBBBBBBB00BBBBBBBBBB0BB00BBBBBBBBBBB00000BB
        BBBBBBBBB00000BBBBBBBBBBB0000000BBBBBBBBB000000BBBBBBBBBB00000BB
        BBBBBBBBB0000BBBBBBBBBBBB000BBBBBBBBBBBBB00BBBBBBBBBBBBBB0BBBBBB
        BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB}
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      OnClick = SpeedButtonEditClick
    end
    object Bevel12: TBevel
      Left = 672
      Top = 0
      Width = 2
      Height = 24
    end
    object PanelPages: TPanel
      Left = 207
      Top = 2
      Width = 134
      Height = 21
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 0
      object LabelPage: TLabel
        Left = 0
        Top = 4
        Width = 33
        Height = 13
        Caption = 'P'#225'gina'
      end
      object LabelOf: TLabel
        Left = 80
        Top = 4
        Width = 12
        Height = 13
        Caption = 'de'
      end
      object EditPageNo: TEdit
        Left = 40
        Top = 0
        Width = 37
        Height = 21
        Hint = 'Ir para a P'#225'gina'
        TabOrder = 0
        Text = '1'
        OnChange = EditPageNoChange
        OnExit = EditPageNoExit
        OnKeyPress = EditPageNoKeyPress
      end
      object PanelPageCount: TPanel
        Left = 96
        Top = 0
        Width = 37
        Height = 21
        Hint = 'Total de P'#225'ginas'
        Alignment = taLeftJustify
        BevelOuter = bvLowered
        Caption = '99999'
        TabOrder = 1
      end
    end
    object PanelZoom: TPanel
      Left = 451
      Top = 2
      Width = 145
      Height = 21
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 1
      object ComboBoxZoom: TComboBox
        Left = 0
        Top = 0
        Width = 145
        Height = 21
        DropDownCount = 11
        TabOrder = 0
        OnChange = ComboBoxZoomChange
        Items.Strings = (
          '500%'
          '200%'
          '150%'
          '100%'
          '75%'
          '50%'
          '25%'
          '10%'
          'Largura da p'#225'gina'
          'P'#225'gina inteira'
          'V'#225'rias p'#225'ginas')
      end
    end
    object PanelCopyright: TPanel
      Left = 621
      Top = 1
      Width = 22
      Height = 22
      Align = alRight
      BevelInner = bvLowered
      BevelOuter = bvSpace
      Caption = ' '
      TabOrder = 2
      Visible = False
      object SpeedButtonCopyright: TImage
        Left = 2
        Top = 2
        Width = 18
        Height = 18
        Align = alClient
        Picture.Data = {
          055449636F6E0000010001001818000001002000880900001600000028000000
          1800000030000000010020000000000060090000000000000000000000000000
          000000000000000000000000000000000000000094896F27968965A69A9587EC
          8D846FFF87857FFF91918FFFACADABFFD6D6D5FFADAEABFFA0A09EFF898984FF
          878479FF928972FA8F8978D5948B74818F8A7F14000000000000000000000000
          00000000000000000000000000000000958A703E928A7AA6999690F7A8A9A6FF
          9E9FA9FF8183AEFF7071B2FF6D6EB8FF8383D2FF6A6CBAFF6A6CB2FF797CAFFF
          9293AAFFA8A9A7FF9E9D98FF8F8C82E19089796890897A110000000000000000
          000000000000000000000000968B6B33978D728C8E8E8BFF7B7DAEFF4144B8FF
          3F42C6FF686AD1FF5759CCFF6A6CD1FF686AD1FF6C6ED1FF5A5BCDFF595ACDFF
          4345C9FF3B3EBCFF6467B2FFA9A9A8FF858173D8978D72270000000000000000
          0000000000000000998959149A8C65697D7354FF9798AAFF474ABAFF3135BFFF
          6C6EC6FF6365BAFF6A6CB3FF7C7EB7FFA5A6DAFF8385B7FF7173B1FF6668B7FF
          696BC2FF4D50C4FF3538BEFF7A7BADFF9C998BFF91866697938A6F1600000000
          00000000000000009689611A948248B59C9D9AFFA9AAA7FF8A8BACFF8688AEFF
          7C7DB0FF9B9CBEFF7F81BFFF9698CBFFAEAFDFFF8788C8FF9899C6FF9697BEFF
          9192B5FF8486ADFF8183ADFFA9AAA8FFA3A4A1FF98927BB2938B724F00000000
          00000000000000008F85634A897C54CEA9AAA8FF9293AAFF494DB6FF2C2FC1FF
          3F42CAFF797AD6FF6B6DD2FF9697DDFF8B8DDBFF6062D1FF9E9FE0FFA9AAE3FF
          3D40C8FF2E31C2FF4547B8FF7C7EAEFFA9AAA7FF908560FF938C745C00000000
          00000000000000008B8369597F7966D6A3A5A7FF5E60B4FF3236BEFF373EBBFF
          474FB2FF7778B6FF7F81AEFF838CA5FFBBBED7FF678284FF697892FF7F82B1FF
          5659B8FF3940B6FF3034BDFF3235BFFF8284ABFF898370FF918B74638B836627
          00000000000000008B836A5B7D7967D5A9AAA7FF9B9DA9FF75809EFF526F70FF
          9BA19FFFA9AAA7FF8C9D8AFF7D9B6DFFEAECE2FFA9C2A6FF4F8548FF6D9168FF
          A4A7A2FF7D8A90FF65778EFF7678AEFFAAABA8FF8A856FFF928B71638C83642A
          00000000000000008F856354897C55D0A9AAA7FFA9AAA7FF5D7B66FF4C6763FF
          AAAAA8FF98A297FF498241FFA08F46FFC9C097FFF2F5EFFF759F6FFF488240FF
          568750FF88928EFF406551FFA8A9A7FFA9AAA7FF908661FF988D636491866128
          0000000000000000978B621C938249B79FA09EFF9AA19BFF57746BFF979D98FF
          A7A9A4FF6A8F64FF498140FFC2974CFFA6984EFFE1E6D6FFA0BD9DFF488240FF
          488240FF6D8F6AFF5F7970FF778E81FFA5A6A3FF9D967CC29A8E5E58968B6221
          000000000000000098885216998D6271817A64FF8D9694FF667C72FFA9AAA7FF
          92A49DFF4F895BFF498140FF96A26BFF8F8F55FFA3A08FFF869F82FF458347FF
          3E8758FF5A8956FF788B7CFF4B6A62FFA0A099EE969071959A8E5E43988D6309
          0000000000000000000000009C8F614C8E782AFF8D9694FF667C72FFAAAAA8FF
          2AB2D3FF0DB4D7FF448348FF3AD7DCFF37C0C5FF328989FF3D7C5AFF1FA4A9FF
          09B9E3FF4AA6AFFF7E8E82FF46685FFF9D9E94E4928C6C740000000000000000
          0000000000000000000000009E8E5640938B5FA4818883FF687D72FFAAABA7FF
          5EA5A8FF309580FF448349FF3EB9A3FF39E0E7FF45DFE7FF85ADA4FF77AAB2FF
          6AAEBCFF82ABB3FF7E8C84FF637D70FF878679E090875F650000000000000000
          0000000000000000000000009388613B8C896B7C7D8076FF577068FFA7A7A6FF
          8E9E8CFF4C8344FF488240FF569562FF97DCD6FFACCECFFFBDBEBCFFA7A9A6FF
          A7A9A6FFA7A8A6FF637773FF7F9087FF807B66DA8B8462530000000000000000
          0000000000000000000000008A8367398B887276888571FF58736AFF909791FF
          96A194FF52854CFF488240FF699562FFE4E9E2FFB6B7B6FFAAAAA7FFA8A9A6FF
          A2A4A2FFA3A5A2FF556F67FF9CA39CFF827B5BCF8983674F0000000000000000
          000000000000000000000000898267388D8770918E876FFF7D8D85FF667B71FF
          A3A7A2FF5C937BFF299890FF3AACBDFF3EBBD8FF4AB0C9FF4BAEC5FF74AAB4FF
          A2A5A3FF959C97FF677E73FFA9AAA8FF887C57D18B8466548C85690F00000000
          0000000000000000000000008C83643C8E866F948E866DFFA6A7A5FF8F9892FF
          A9AAA7FF97A294FF51844EFF8CAFB1FF61C3D9FF83B2BCFF9BABACFFA9AAA7FF
          A9AAA8FFA1A4A0FF9DA19DFFA9AAA7FF887D58D48D85674F0000000000000000
          0000000000000000000000008F856239968A67917D7B7FFF8487ACFFAAABA8FF
          A9AAA7FFA9AAA8FF9AA6A3FF73B1BFFF33B6D5FF62B0C1FF83ADB4FFA5AAA8FF
          A9AAA7FFA9AAA7FF9597AAFF8C8DAAFF817A65DD9187666B0000000000000000
          000000000000000095896106988B5D56958036FF8081A5FF383BBDFF494BB9FF
          8081B0FF9394ADFF9899ACFF7891ABFF336E9DFF5182A4FF919CADFF9A9BACFF
          999AB1FF7174B1FF3438BEFF6365B1FF8E8B8AEE96895B909789544197884F07
          0000000000000000968A6413978B65709A9993FF9C9DA9FF575BB6FF2A2DC4FF
          4144C9FF8384D2FF8D8ECFFF8688CCFF8285C5FF3E40B7FF898ACEFF8E8FD1FF
          5F60CBFF2A2EC4FF3639BFFF8586ADFF9F9FA0FF8E8150E79B8B4D4A97884F1B
          0000000000000000958B65129B8E5D68746E56FFAAABA8FFAAAAA8FF9D9DA8FF
          7677B2FF7071BEFF5657C0FF7070CCFF696BCEFF2A2DBFFF6869CAFF5B5DC1FF
          5B5EB7FF7C7EAFFFA4A5A8FFA9AAA7FF98978CFF928656AA958858529789521A
          000000000000000000000000998C582A9A9068848F8D80EDA7A7A5FFA7A8A5FF
          9C9D9BFF9A9B98FF9FA09DFFA0A2A2FF5B617DFF8A8E96FFA5A6A3FF9C9D9AFF
          9A9B98FFA1A29FFFA9AAA7FFA0A19DFF8D876CC5998F6869958A5D2A00000000
          00000000000000000000000000000000968B5E4C968E6A979C977ECBA19977D6
          94907CC68E8B7AC39D936CD9938F80E689898AFF858171FF988B57F1978E6BD1
          9C9164D3999379CC938C6FEE959179AD9C92696D98906C2A0000000000000000
          0000000000000000000000000000000000000000958854639588562600000000
          000000000000000000000000A0915741998330F19D8F58D10000000000000000
          0000000000000000000000009791736399906D3B9A916D0E0000000000000000
          00000000F0000F00E0000700C000070080000300800003008000030080000100
          80000100800001008000010080000100C0000700C0000700C0000700C0000700
          C0000300C0000700C0000700800001008000010080000100C0000300E0000700
          F3C7C700}
        Stretch = True
      end
    end
  end
  object RLDraftFilter1: TRLDraftFilter
    DisplayName = 'Matricial'
    Left = 267
    Top = 127
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 507
    Top = 119
  end
  object PrintDialog1: TPrintDialog
    Collate = True
    Copies = 1
    Options = [poPrintToFile, poPageNums, poSelection, poWarning]
    PrintRange = prPageNums
    Left = 446
    Top = 103
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.pdf'
    Filter = 
      'Documento PDF|*.pdf|Planilha Excel|*.xls|P'#225'gina da Web|*.htm|For' +
      'mato RichText|*.rtf|XML|*.xml|CSV|*.csv'
    Left = 377
    Top = 127
  end
  object RLXLSFilter1: TRLXLSFilter
    DisplayName = 'Planilha Excel'
    Left = 90
    Top = 119
  end
  object RLPDFFilter1: TRLPDFFilter
    DocumentInfo.Creator = 
      'FortesReport v0.3.10e \251 Copyright '#169' 1999-2003 Fortes Inform'#225't' +
      'ica'
    DisplayName = 'Documento PDF'
    Left = 90
    Top = 163
  end
  object RLHTMLFilter1: TRLHTMLFilter
    DocumentStyle = dsCSS2
    DisplayName = 'P'#225'gina da Web'
    Left = 175
    Top = 171
  end
  object RLRichFilter1: TRLRichFilter
    DisplayName = 'Formato RichText'
    Left = 167
    Top = 119
  end
  object RLPreviewSetup1: TRLPreviewSetup
    ShowModal = True
    EditOptions = [eoCanReposition, eoCanEditText, eoCanDeleteItems]
    Left = 263
    Top = 175
  end
  object RLXLSXFilter1: TRLXLSXFilter
    DisplayName = 'Planilha Excel'
    Left = 88
    Top = 216
  end
end