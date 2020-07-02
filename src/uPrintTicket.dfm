object frmPrintTicket: TfrmPrintTicket
  Left = 548
  Top = 572
  Width = 427
  Height = 738
  Caption = #917#954#964#973#960#969#963#951
  Color = 14346731
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object qrTicket: TQuickRep
    Left = 0
    Top = 0
    Width = 363
    Height = 567
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    BeforePrint = qrTicketBeforePrint
    DataSet = qPrint
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Functions.Strings = (
      'PAGENUMBER'
      'COLUMNNUMBER'
      'REPORTTITLE')
    Functions.DATA = (
      '0'
      '0'
      #39#39)
    Options = [FirstPageHeader, LastPageFooter]
    Page.Columns = 1
    Page.Orientation = poPortrait
    Page.PaperSize = Custom
    Page.Values = (
      0
      1250
      0
      800.364583333333
      0
      0
      0)
    PrinterSettings.Copies = 1
    PrinterSettings.Duplex = False
    PrinterSettings.FirstPage = 0
    PrinterSettings.LastPage = 0
    PrinterSettings.OutputBin = Auto
    PrintIfEmpty = True
    SnapToGrid = True
    Units = MM
    Zoom = 120
    object bDetails: TQRBand
      Left = 0
      Top = 229
      Width = 363
      Height = 20
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        44.0972222222222
        800.364583333333)
      BandType = rbDetail
      object tItem: TQRDBText
        Left = 22
        Top = 0
        Width = 171
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          48.5069444444444
          0
          377.03125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = qPrint
        DataField = 'ItemDesc'
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object tQuantity: TQRDBText
        Left = 200
        Top = 0
        Width = 52
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          440.972222222222
          0
          114.652777777778)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = qPrint
        DataField = 'Quantity'
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object tSubTotal: TQRDBText
        Left = 259
        Top = 0
        Width = 78
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          571.059027777778
          0
          171.979166666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = qPrint
        DataField = 'SubTotal'
        Mask = '0.00'
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
    end
    object bGroup: TQRGroup
      Left = 0
      Top = 55
      Width = 363
      Height = 174
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = True
      Size.Values = (
        383.645833333333
        800.364583333333)
      Expression = 'qPrint.ItemGroupDesc'
      FooterBand = bGroupFooter
      Master = qrTicket
      ReprintOnNewPage = False
      object sh1: TQRShape
        Left = 0
        Top = 1
        Width = 361
        Height = 3
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          6.61458333333333
          0
          2.20486111111111
          795.954861111111)
        Brush.Style = bsClear
        Shape = qrsHorLine
      end
      object sh3: TQRShape
        Left = 0
        Top = 158
        Width = 361
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          0
          348.368055555556
          795.954861111111)
        Brush.Style = bsClear
        Shape = qrsHorLine
      end
      object sh2: TQRShape
        Left = 0
        Top = 126
        Width = 361
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          28.6631944444444
          0
          277.8125
          795.954861111111)
        Brush.Style = bsClear
        Shape = qrsHorLine
      end
      object tItemGroup: TQRDBText
        Left = 93
        Top = 107
        Width = 177
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          205.052083333333
          235.920138888889
          390.260416666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clBlack
        DataSet = qPrint
        DataField = 'ItemGroupDesc'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        OnPrint = tItemGroupPrint
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object lItem: TQRLabel
        Left = 22
        Top = 142
        Width = 83
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          48.5069444444444
          313.090277777778
          183.003472222222)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = #928#929#927#938#927#925
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object lQuantity: TQRLabel
        Left = 160
        Top = 142
        Width = 92
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          352.777777777778
          313.090277777778
          202.847222222222)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = #928#927#931#927#932#919#932#913
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object lPrice: TQRLabel
        Left = 264
        Top = 142
        Width = 73
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          582.083333333333
          313.090277777778
          160.954861111111)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = #913#926#921#913
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRLabel23: TQRLabel
        Left = 26
        Top = 8
        Width = 74
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          57.3263888888889
          17.6388888888889
          163.159722222222)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = #932#949#961#956#945#964#953#954#972':'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRDBText5: TQRDBText
        Left = 125
        Top = 8
        Width = 145
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          275.607638888889
          17.6388888888889
          319.704861111111)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = qPrint
        DataField = 'TerminalCode'
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel24: TQRLabel
        Left = 26
        Top = 28
        Width = 90
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          57.3263888888889
          61.7361111111111
          198.4375)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = #928#945#961#945#947#947#949#955#943#945':'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRDBText11: TQRDBText
        Left = 125
        Top = 28
        Width = 136
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          275.607638888889
          61.7361111111111
          299.861111111111)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = qPrint
        DataField = 'OrderId'
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel25: TQRLabel
        Left = 26
        Top = 48
        Width = 53
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          57.3263888888889
          105.833333333333
          116.857638888889)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = #932#945#956#943#945#962':'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRDBText13: TQRDBText
        Left = 125
        Top = 48
        Width = 217
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          275.607638888889
          105.833333333333
          478.454861111111)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = qPrint
        DataField = 'UserName'
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel26: TQRLabel
        Left = 26
        Top = 68
        Width = 94
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          57.3263888888889
          149.930555555556
          207.256944444444)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = #917#954#964#965#960#974#952#951#954#949':'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRDBText14: TQRDBText
        Left = 125
        Top = 68
        Width = 193
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          275.607638888889
          149.930555555556
          425.538194444444)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = qPrint
        DataField = 'PrintedAt'
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
    end
    object bHeader: TQRBand
      Left = 0
      Top = 0
      Width = 363
      Height = 55
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        121.267361111111
        800.364583333333)
      BandType = rbPageHeader
      object lEventName: TQRLabel
        Left = 0
        Top = 38
        Width = 363
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          0
          83.7847222222222
          800.364583333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '23'#959#962' '#913#954#961#953#964#953#954#972#962' '#922#973#954#955#959#962' - '#921#959#973#957#953#959#962' 2019'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 8
      end
      object lCompanyName: TQRLabel
        Left = 0
        Top = 19
        Width = 363
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          0
          41.8923611111111
          800.364583333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = #913#922#929#921#932#917#931' '#932#927#933' '#928#927#925#932#927#933
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object lCopy: TQRLabel
        Left = 0
        Top = 0
        Width = 363
        Height = 20
        Enabled = False
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          0
          0
          800.364583333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = #913#925#932#921#915#929#913#934#927' '#913#928#927#916#917#921#926#919#931
        Color = clBlack
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
    end
    object bSummary: TQRBand
      Left = 0
      Top = 293
      Width = 363
      Height = 156
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = True
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        343.958333333333
        800.364583333333)
      BandType = rbSummary
      object sh5: TQRShape
        Left = 0
        Top = 4
        Width = 361
        Height = 3
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          6.61458333333333
          0
          8.81944444444444
          795.954861111111)
        Brush.Style = bsClear
        Shape = qrsHorLine
      end
      object lThanks: TQRLabel
        Left = 8
        Top = 112
        Width = 345
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          17.6388888888889
          246.944444444444
          760.677083333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = #917#933#935#913#929#921#931#932#927#933#924#917' - '#922#913#923#919' '#916#921#913#931#922#917#916#913#931#919'!'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object lTotalAmount: TQRLabel
        Left = 40
        Top = 20
        Width = 211
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          88.1944444444445
          44.0972222222222
          465.225694444444)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = #931#973#957#959#955#959' '#928#945#961#945#947#947#949#955#943#945#962' '#8364
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object tTotalAmount: TQRDBText
        Left = 259
        Top = 20
        Width = 78
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          571.059027777778
          44.0972222222222
          171.979166666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = qPrint
        DataField = 'TotalAmount'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Mask = '0.00'
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object lNoReceipt: TQRLabel
        Left = 8
        Top = 136
        Width = 345
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          17.6388888888889
          299.861111111111
          760.677083333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = #932#927' '#928#913#929#927#925' '#916#917#925' '#913#928#927#932#917#923#917#921' '#934#927#929#927#923#927#915#921#922#919' '#913#928#927#916#917#921#926#919
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object lPaidAmount: TQRLabel
        Left = 120
        Top = 44
        Width = 131
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          264.583333333333
          97.0138888888889
          288.836805555556)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = #928#955#951#961#969#964#941#959' '#8364
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object tPaidAmount: TQRDBText
        Left = 259
        Top = 44
        Width = 78
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          571.059027777778
          97.0138888888889
          171.979166666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = qPrint
        DataField = 'PaidAmount'
        Mask = '0.00'
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object lChange: TQRLabel
        Left = 120
        Top = 68
        Width = 131
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          264.583333333333
          149.930555555556
          288.836805555556)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = #929#941#963#964#945' '#8364
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object expChange: TQRExpr
        Left = 259
        Top = 68
        Width = 78
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          571.059027777778
          149.930555555556
          171.979166666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        ResetAfterPrint = True
        Transparent = False
        WordWrap = True
        Expression = 'qPrint.PaidAmount - qPrint.TotalAmount'
        Mask = '0.00'
        FontSize = 10
      end
      object sh6: TQRShape
        Left = 0
        Top = 8
        Width = 361
        Height = 3
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          6.61458333333333
          0
          17.6388888888889
          795.954861111111)
        Brush.Style = bsClear
        Shape = qrsHorLine
      end
    end
    object bGroupFooter: TQRBand
      Left = 0
      Top = 249
      Width = 363
      Height = 44
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = bGroupFooterBeforePrint
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        97.0138888888889
        800.364583333333)
      BandType = rbGroupFooter
      object sh4: TQRShape
        Left = 0
        Top = 4
        Width = 361
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          28.6631944444444
          0
          8.81944444444444
          795.954861111111)
        Brush.Style = bsClear
        Shape = qrsHorLine
      end
      object QRLabel21: TQRLabel
        Left = 88
        Top = 20
        Width = 163
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          194.027777777778
          44.0972222222222
          359.392361111111)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = #924#949#961#953#954#972' '#931#973#957#959#955#959' '#8364
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRExpr1: TQRExpr
        Left = 259
        Top = 20
        Width = 78
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          571.059027777778
          44.0972222222222
          171.979166666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        ResetAfterPrint = True
        Transparent = False
        WordWrap = True
        Expression = 'SUM(qPrint.SubTotal)'
        Mask = '0.00'
        FontSize = 10
      end
    end
    object bFooter: TQRBand
      Left = 0
      Top = 449
      Width = 363
      Height = 32
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        70.5555555555556
        800.364583333333)
      BandType = rbPageFooter
      object sh7: TQRShape
        Left = 0
        Top = 0
        Width = 361
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          28.6631944444444
          0
          0
          795.954861111111)
        Brush.Style = bsClear
        Shape = qrsHorLine
      end
      object lPages: TQRLabel
        Left = 8
        Top = 10
        Width = 345
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          17.6388888888889
          22.0486111111111
          760.677083333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '- / -'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        OnPrint = lPagesPrint
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
    end
  end
  object dbPrint: TDatabase
    AliasName = 'pos'
    DatabaseName = 'PrintDB'
    LoginPrompt = False
    Params.Strings = (
      '=')
    SessionName = 'Default'
    Left = 8
    Top = 536
  end
  object qPrint: TBDEClientDataSet
    CommandText = 
      'SELECT'#13#10'  t.Code AS TerminalCode, o.Id AS OrderId, u.NickName AS' +
      ' UserName, ig.Description AS ItemGroupDesc, i.Description AS Ite' +
      'mDesc, od.Quantity as Quantity, od.SubTotal AS SubTotal, o.Print' +
      'edAt AS PrintedAt, o.PaidAmount AS PaidAmount, o.TotalAmount AS ' +
      'TotalAmount'#13#10'FROM'#13#10'  Orders o, OrderDetails od, Items i, ItemGro' +
      'ups ig, Users u, Terminals t'#13#10'WHERE'#13#10'  o.Id = 59'#13#10'  AND od.Order' +
      'Id = o.Id'#13#10'  AND t.Id = o.TerminalId'#13#10'  AND u.Id = o.UserId'#13#10'  A' +
      'ND od.ItemId = i.Id'#13#10'  AND i.ItemGroupId = ig.Id'#13#10'ORDER BY'#13#10'  o.' +
      'Id, i.ItemGroupId, od.ItemId'
    Aggregates = <>
    Options = [poAllowCommandText]
    Params = <>
    BeforeOpen = qPrintBeforeOpen
    DBConnection = dbPrint
    Left = 48
    Top = 536
  end
  object qMaxOrderItems: TBDEClientDataSet
    CommandText = 
      'SELECT MAX(GroupCount) AS MaxCount'#13#10'FROM'#13#10'   (SELECT COUNT(*) AS' +
      ' GroupCount, i.ItemGroupId'#13#10'    FROM OrderDetails od, Items i'#13#10' ' +
      '   WHERE od.ItemId = i.Id'#13#10'    AND od.OrderId = 6064'#13#10'    GROUP ' +
      'BY i.ItemGroupId)'#13#10
    Aggregates = <>
    Options = [poAllowCommandText]
    Params = <>
    DBConnection = dbPrint
    Left = 88
    Top = 536
  end
end
