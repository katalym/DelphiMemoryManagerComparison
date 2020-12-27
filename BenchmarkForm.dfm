object BenchmarkFrm: TBenchmarkFrm
  Left = 179
  Top = 89
  Caption = 'Memory Manager Test'
  ClientHeight = 582
  ClientWidth = 1192
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter2: TSplitter
    Left = 0
    Top = 322
    Width = 1192
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object gbBenchmarks: TGroupBox
    Left = 0
    Top = 0
    Width = 1192
    Height = 322
    Align = alClient
    Caption = 'Benchmarks'
    TabOrder = 0
    object lvBenchmarkList: TListView
      AlignWithMargins = True
      Left = 3
      Top = 18
      Width = 1184
      Height = 225
      Margins.Left = 1
      Align = alClient
      Checkboxes = True
      Columns = <
        item
          Caption = 'Benchmarks'
          Width = 300
        end
        item
          Caption = 'Category'
          Width = 250
        end>
      ColumnClick = False
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      PopupMenu = mnuBenchmarks
      TabOrder = 0
      ViewStyle = vsReport
      OnSelectItem = lvBenchmarkListSelectItem
    end
    object mBenchmarkDescription: TMemo
      AlignWithMargins = True
      Left = 3
      Top = 249
      Width = 1186
      Height = 68
      Margins.Left = 1
      Margins.Right = 1
      Align = alBottom
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
  object pcBenchmarkResults: TPageControl
    Left = 0
    Top = 325
    Width = 1192
    Height = 226
    ActivePage = TabSheetBenchmarkResults
    Align = alBottom
    TabOrder = 1
    object TabSheetBenchmarkResults: TTabSheet
      Caption = 'Benchmark Results'
      ImageIndex = 1
      object ListViewResults: TListView
        Left = 0
        Top = 36
        Width = 1184
        Height = 162
        Align = alClient
        Columns = <
          item
            Caption = 'Benchmark'
            Width = 220
          end
          item
            Caption = 'Memory Manager'
            Width = 90
          end
          item
            Alignment = taRightJustify
            Caption = 'CPU Usage (ms)'
            Width = 110
          end
          item
            Alignment = taRightJustify
            Caption = 'Ticks (ms)'
            Width = 110
          end
          item
            Alignment = taRightJustify
            Caption = 'Peak Addr Space (Kb)'
            Width = 120
          end>
        ColumnClick = False
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
      object ToolBar1: TToolBar
        Left = 0
        Top = 0
        Width = 1184
        Height = 36
        AutoSize = True
        ButtonHeight = 36
        ButtonWidth = 90
        Caption = 'ToolBar1'
        Images = imlImages
        ShowCaptions = True
        TabOrder = 1
        object btnCopyResultsToClipboard: TToolButton
          Left = 0
          Top = 0
          Action = actCopyResultsToClipboard
        end
        object btnDeleteTestResults: TToolButton
          Left = 90
          Top = 0
          Action = actDeletelTestResults
        end
      end
    end
    object TabSheetProgress: TTabSheet
      Margins.Left = 1
      Margins.Right = 1
      Caption = 'Progress'
      ImageIndex = 2
      object mResults: TMemo
        Left = 0
        Top = 0
        Width = 1184
        Height = 198
        Margins.Right = 1
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheetCPU: TTabSheet
      Caption = 'Environment'
      ImageIndex = 4
      object MemoEnvironment: TMemo
        Left = 0
        Top = 0
        Width = 1184
        Height = 198
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 551
    Width = 1192
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    Color = clBtnShadow
    ParentBackground = False
    TabOrder = 2
    object btnClose: TBitBtn
      AlignWithMargins = True
      Left = 1088
      Top = 3
      Width = 101
      Height = 25
      Align = alRight
      Kind = bkClose
      NumGlyphs = 2
      TabOrder = 2
    end
    object btnRunSelectedBenchmark: TBitBtn
      AlignWithMargins = True
      Left = 234
      Top = 3
      Width = 220
      Height = 25
      Margins.Left = 8
      Action = actRunSelectedBenchmark
      Align = alLeft
      Caption = 'Run Selected Benchmark'
      TabOrder = 1
    end
    object btnRunAllCheckedBenchmarks: TBitBtn
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 220
      Height = 25
      Action = actRunAllCheckedBenchmarks
      Align = alLeft
      Caption = 'Run All Checked Benchmarks'
      TabOrder = 0
    end
  end
  object imlImages: TImageList
    Left = 100
    Top = 136
    Bitmap = {
      494C010107000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C00000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C0000000000000000000C0C0C0000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C00000000000C0C0C000C0C0C000C0C0C0000000000000000000C0C0C000C0C0
      C000C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000000000000000C0C0
      C000C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000000000000000
      0000C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF007F7F7F00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000005B7000005B7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF007F7F7F00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF0000000000000000000005B7000005B7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000005B7000005B700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000FFFF007F7F7F00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF0000000000000000000005B7000005B7000005
      B700000000000000000000000000000000000000000000000000000000000000
      00000005B7000005B70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF0000000000FFFF
      FF000000000000000000FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000FFFF007F7F7F00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF0000000000000000000005B7000005B6000005
      B7000005B7000000000000000000000000000000000000000000000000000005
      B7000005B7000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF0000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F0000000000000000007F7F7F000000000000000000000000000005D8000005
      BA000005B7000005B700000000000000000000000000000000000005B7000005
      B700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF00000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00007F7F7F007F7F7F0000FFFF00000000000000000000000000000000000000
      00000005B7000005B7000005B600000000000005B6000005B7000005B7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000800000008000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000000000FFFFFF000000
      000000000000FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00007F7F7F0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000005B6000005C8000005C8000005CD000005B400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF00000080000000
      000000000000000000000000000000000000FFFF00000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF00000000000000000000000000000000000000000000FF
      FF0000000000FFFFFF00FFFFFF000000000000000000FFFFFF00000000000000
      0000FFFFFF00000000000000000000000000FFFFFF0000000000000000000000
      00000000FF0000000000000000007F7F7F000000000000000000000000000000
      000000000000000000000005C1000005C1000005D80000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF000000FF000000
      800000000000000000000000000000000000FFFF000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000005B6000005D8000005CD000005D8000005E700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      000000808000000000000000000000000000FFFF00000000000000FFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00000000000000
      00000000000000000000FFFFFF0000000000FFFFFF00000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      00000005E3000005D8000005D40000000000000000000005E3000005EF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000000000FF
      FF000000000000808000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00000000000000000000FFFF0000000000FFFFFF00FFFF
      FF000000000000000000FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000005
      F2000005D8000005EF00000000000000000000000000000000000005F2000005
      F200000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      000000FFFF000000000000808000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF00000000000000000000000000000000000005F2000005
      F2000005F2000000000000000000000000000000000000000000000000000005
      F2000005F2000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF000000000000FFFF0000808000008080000000000000000000000000000000
      0000000000000000000000FFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF000000000000000000000000000000
      FF000000FF000000FF000000000000000000000000000005F2000005F2000005
      F200000000000000000000000000000000000000000000000000000000000000
      0000000000000005F20000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF00008080000000000000000000000000000000
      00000000000000FFFF0000000000FFFFFF00FFFFFF000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF000000000000000000FFFFFF0000000000BFBF
      BF00FFFFFF0000000000FFFFFF000000000000000000000000007F7F7F000000
      FF000000FF000000FF0000000000000000000005F2000005F2000005F2000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF000000000000000000000000000000
      000000FFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000005F2000005F200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF000000000000000000000000000000
      FF00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000FFFFFFFFFFFF0000
      C003C003C0030000DFFBC003DFFB0000DDFBC003DFFB0000D8FBC003DFFB0000
      D27BC003DFFB0000D73BC003DFFB0000DF9BC003DFFB0000DFCBC003DFFB0000
      DFEBC003DFFB0000DFFBC003DFFB0000DFFBC003DFFB0000C003C003C0030000
      FFFFFFFFFFFF0000FFFFFFFFFFFF0000FC00FFFC847FFC00FC009FF900EFFC00
      FC008FF331BF2000FC0087E739FF00000000C3CF993F00000000F11FCA1F0000
      0000F83FF40F00000000FC7F9C0700000023F83F960300000001F19FCB010000
      0000E3CFFF80E0000023C7E7F7C0F80000638FFBFFE0F00000C31FFFEFF0E001
      01073FFFFFF8C40303FFFFFFFFFCEC0700000000000000000000000000000000
      000000000000}
  end
  object mnuBenchmarks: TPopupMenu
    Images = imlImages
    Left = 100
    Top = 76
    object mniPopupClearAllCheckMarks: TMenuItem
      Action = actPopupClearAllCheckMarks
    end
    object mniPopupSelectAllCheckMarks: TMenuItem
      Action = actPopupSelectAllCheckMarks
    end
    object mniSep: TMenuItem
      Caption = '-'
    end
    object mniPopupCheckAllDefaultBenchmarks: TMenuItem
      Action = actPopupCheckAllDefaultBenchmarks
    end
    object mniPopupCheckAllThreadedBenchmarks: TMenuItem
      Action = actPopupCheckAllThreadedBenchmarks
    end
  end
  object tmrAutoRun: TTimer
    Enabled = False
    OnTimer = tmrAutoRunTimer
    Left = 256
    Top = 80
  end
  object alActions: TActionList
    Images = imlImages
    Left = 256
    Top = 136
    object actCopyResultsToClipboard: TAction
      Category = 'Actions'
      Caption = 'Copy to Clipboard'
      Hint = 'Copy Results to Clipboard'
      ImageIndex = 0
      OnExecute = actCopyResultsToClipboardExecute
    end
    object actDeletelTestResults: TAction
      Category = 'Actions'
      Caption = 'Delete Results'
      Hint = 'Delete Results'
      ImageIndex = 1
      OnExecute = actDeletelTestResultsExecute
    end
    object actRunAllCheckedBenchmarks: TAction
      Category = 'Actions'
      Caption = 'Run All Checked Benchmarks'
      Hint = 'Run All Checked Benchmarks'
      ImageIndex = 4
      OnExecute = actRunAllCheckedBenchmarksExecute
    end
    object actRunSelectedBenchmark: TAction
      Category = 'Actions'
      Caption = 'Run Selected Benchmark'
      Hint = 'Run Selected Benchmark'
      ImageIndex = 5
      OnExecute = actRunSelectedBenchmarkExecute
    end
    object actPopupClearAllCheckMarks: TAction
      Category = 'Popup'
      Caption = 'Clear All Check Marks'
      Hint = 'Clear All Check Marks'
      ImageIndex = 6
      OnExecute = actPopupClearAllCheckMarksExecute
    end
    object actPopupSelectAllCheckMarks: TAction
      Category = 'Popup'
      Caption = 'Check All Benchmarks'
      Hint = 'Check All Benchmarks'
      ImageIndex = 4
      OnExecute = actPopupSelectAllCheckMarksExecute
    end
    object actPopupCheckAllDefaultBenchmarks: TAction
      Category = 'Popup'
      Caption = 'Check All Default Benchmarks'
      Hint = 'Check All Default Benchmarks'
      ImageIndex = 4
      OnExecute = actPopupCheckAllDefaultBenchmarksExecute
    end
    object actPopupCheckAllThreadedBenchmarks: TAction
      Category = 'Popup'
      Caption = 'Check Special Thread Benchmarks'
      Hint = 'Check Special Thread Benchmarks'
      OnExecute = actPopupCheckAllThreadedBenchmarksExecute
    end
  end
end