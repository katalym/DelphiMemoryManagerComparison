{A benchmark replaying the allocations/deallocations performed by a user's application}

unit ReplayBenchmarkUnit;

interface

uses
  Windows, SysUtils, Classes, VCL.Dialogs, BenchmarkClassUnit, Math;

type
  {A single operation}
  PMMOperation = ^TMMOperation;
  TMMOperation = packed record
    {The old pointer number. Will be < 0 for GetMem requests, non-zero otherwise.}
    OldPointerNumber: Integer;
    {The requested size. Will be zero for FreeMem requests, non-zero otherwise.}
    RequestedSize: Integer;
    {The new pointer number. Will be < 0 for FreeMem requests, non-zero otherwise.}
    NewPointerNumber: Integer;
  end;

  {The single-thread replay benchmark ancestor}
  TReplayBenchmark = class(TMMBenchmark)
  protected
    {The operations}
    FOperations: string;
    FPointers: array of pointer;
    {The log file name, can be specified by descendant}
    FUsageLogFileName: string;
    {Gets the memory overhead of the benchmark that should be subtracted}
    function GetBenchmarkOverhead: NativeUInt; override;
    procedure RunReplay;
  public
    constructor CreateBenchmark; override;
    class function GetBenchmarkDescription: string; override;
    class function GetBenchmarkName: string; override;
    class function GetCategory: TBenchmarkCategory; override;
    {repeat count for replay log}
    class function RepeatCount: integer; virtual;
    procedure RunBenchmark; override;
    class function RunByDefault: boolean; override;
  end;

  {The multi-threaded replay benchmark ancestor}
  TMultiThreadReplayBenchmark = class(TReplayBenchmark)
  public
    class function GetCategory: TBenchmarkCategory; override;
    procedure RunBenchmark; override;
    {number of simultaneously running threads}
    class function RunningThreads: Integer; virtual;
    {total number of threads running}
    class function ThreadCount: Integer; virtual;
  end;

  {Single-threaded replays}

  TReservationsSystemBenchmark = class(TReplayBenchmark)
  public
    constructor CreateBenchmark; override;
    class function GetBenchmarkDescription: string; override;
    class function GetBenchmarkName: string; override;
    class function RepeatCount: integer; override;
    class function RunByDefault: boolean; override;
  end;

  TXMLParserBenchmark = class(TReplayBenchmark)
  public
    constructor CreateBenchmark; override;
    class function GetBenchmarkDescription: string; override;
    class function GetBenchmarkName: string; override;
    class function RepeatCount: integer; override;
    class function RunByDefault: boolean; override;
  end;

  TDocumentClassificationBenchmark = class(TReplayBenchmark)
  public
    constructor CreateBenchmark; override;
    class function GetBenchmarkDescription: string; override;
    class function GetBenchmarkName: string; override;
    class function RepeatCount: integer; override;
    class function RunByDefault: boolean; override;
  end;

  {Multi-threaded replays}

  TeLinkBenchmark = class(TMultiThreadReplayBenchmark)
  public
    constructor CreateBenchmark; override;
    class function GetBenchmarkDescription: string; override;
    class function GetBenchmarkName: string; override;
    class function RunByDefault: boolean; override;
    class function RunningThreads: Integer; override;
    class function ThreadCount: Integer; override;
  end;

  TeLinkComServerBenchmark = class(TMultiThreadReplayBenchmark)
  public
    constructor CreateBenchmark; override;
    class function GetBenchmarkDescription: string; override;
    class function GetBenchmarkName: string; override;
    class function RunByDefault: boolean; override;
    class function RunningThreads: Integer; override;
    class function ThreadCount: Integer; override;
  end;

  TWebbrokerReplayBenchmark = class(TMultiThreadReplayBenchmark)
  public
    constructor CreateBenchmark; override;
    class function GetBenchmarkDescription: string; override;
    class function GetBenchmarkName: string; override;
    class function RepeatCount: Integer; override;
    class function RunByDefault: boolean; override;
    class function RunningThreads: Integer; override;
    class function ThreadCount: Integer; override;
  end;

  TBeyondCompareBenchmark = class(TMultiThreadReplayBenchmark)
  public
    constructor CreateBenchmark; override;
    class function GetBenchmarkDescription: string; override;
    class function GetBenchmarkName: string; override;
    class function RepeatCount: integer; override;
    class function RunByDefault: boolean; override;
    class function RunningThreads: Integer; override;
    class function ThreadCount: Integer; override;
  end;

implementation

uses
  BenchmarkUtilities, System.UITypes;

type
  {The replay thread used in multi-threaded replay benchmarks}
  TReplayThread = class(TThread)
  private
    FBenchmark: TMMBenchmark;
    FOperations: string;
    FRepeatCount: integer;
    procedure ExecuteReplay;
  public
    constructor Create(ASuspended: Boolean; ABenchmark: TMMBenchmark; RepeatCount: integer);
    procedure Execute; override;
    property Operations: string read FOperations write FOperations;
  end;

const
  INVALID_SET_FILE_POINTER = DWORD(-1);

{Reads a file in its entirety and returns the contents as a string. Returns a blank string on error.}
function LoadFile(const AFileName: string): string;
var
//  LFileInfo: OFSTRUCT;
  LHandle: THandle;
  LFileSize: Cardinal;
  LBytesRead: Cardinal;
begin
  {Default to empty string (file not found)}
  Result := '';
  {Try to open the file}
  LHandle := CreateFile(PChar(AFileName),  GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  if LHandle <> HFILE_ERROR then
  begin
    try
      {Find the FileSize}
      LFileSize := SetFilePointer(LHandle, 0, nil, FILE_END);
      {Read the file}
      if (LFileSize > 0) and (LFileSize <> INVALID_SET_FILE_POINTER) then
      begin
        {Allocate the buffer}
        SetLength(Result, LFileSize);
        {Go back to the start of the file}
        if SetFilePointer(LHandle, 0, nil, FILE_BEGIN) = 0 then
        begin
          {Read the file}
          LBytesRead := 0;
          Windows.ReadFile(LHandle, Result[1], LFileSize, LBytesRead, nil);
          {Was all the data read?}
          if LBytesRead <> LFileSize then
            Result := '';
        end;
      end;
    finally
      {Close the file}
      CloseHandle(LHandle);
    end;
  end;
end;

constructor TReplayBenchmark.CreateBenchmark;
begin
  inherited;
  {Try to load the usage log}
  if FUsageLogFileName <> '' then
  begin
    // descendant has specified usage log file
    FOperations := LoadFile(FUsageLogFileName);
    if FOperations = '' then
      FCanRunBenchmark := False;
//      raise Exception.CreateFmt('The file "%s" could not be found in the current folder', [FUsageLogFileName]);
  end
  else
  begin
    // use default usage log file
    FOperations := LoadFile('MMUsage.Log');
    if FOperations = '' then
    begin
      FOperations := LoadFile('c:\MMUsage.Log');
      if FOperations = '' then
        raise Exception.Create('The file MMUsage.Log could not be found in the current folder or c:\');
    end;
  end;
  {Set the list of pointers}
  SetLength(FPointers, length(FOperations) div SizeOf(TMMOperation));
  Sleep(20);  // RH let system relax after big file load... seems to be useful to get consistent results
end;

class function TReplayBenchmark.GetBenchmarkDescription: string;
begin
  Result := 'Plays back the memory operations of another application as '
    + 'recorded by the MMUsageLogger utility. To record and replay the '
    + 'operations performed by your application:'#13#10
    + '1) Place MMUsageLogger.pas as the first unit in the .dpr of your app.'#13#10
    + '2) Run the application (a file c:\MMUsage.log will be created).'#13#10
    + '3) Copy the .log into the this Application folder.'#13#10
    + '4) Run the Application with the replacement MM that you want to test as the '
    + 'first unit in the .dpr.'#13#10
    + '5) Select this benchmark and run it.'#13#10
    + '6) The Application tool will replay the exact sequence of '
    + 'allocations/deallocations/reallocations of your application, giving you a '
    + 'good idea of how your app will perform with the given memory manager.';
end;

class function TReplayBenchmark.GetBenchmarkName: string;
begin
  Result := 'Usage Replay';
end;

function TReplayBenchmark.GetBenchmarkOverhead: NativeUInt;
begin
  {Take into account the size of the replay file}
  Result := InitialAddressSpaceUsed + NativeUInt((length(FOperations) + length(FPointers) * 4) shr 10);
end;

class function TReplayBenchmark.GetCategory: TBenchmarkCategory;
begin
  Result := bmSingleThreadReplay;
end;

class function TReplayBenchmark.RepeatCount: integer;
begin
  Result := 1;
end;

procedure TReplayBenchmark.RunBenchmark;
var
  i: integer;
begin
  inherited;
  for i := 1 to RepeatCount do
    RunReplay;
end;

class function TReplayBenchmark.RunByDefault: boolean;
begin
  Result := False;
end;

procedure TReplayBenchmark.RunReplay;
var
  LPOperation: PMMOperation;
  LInd, LOperationCount, LOffset: integer;
  UintOfs: NativeUint;
begin
  {Get a pointer to the first operation}
  LPOperation := pointer(FOperations);
  {Get the number of operations to perform}
  LOperationCount := length(FPointers);
  {Perform all the operations}
  for LInd := 0 to LOperationCount - 1 do
  begin
    {Perform the operation}
    if LPOperation^.NewPointerNumber >= 0 then
    begin
      if LPOperation^.OldPointerNumber <> LPOperation^.NewPointerNumber then
      begin
        {GetMem}
        GetMem(FPointers[LPOperation^.NewPointerNumber], LPOperation^.RequestedSize);
      end
      else
      begin
        {ReallocMem}
        ReallocMem(FPointers[LPOperation^.OldPointerNumber], LPOperation^.RequestedSize);
      end;
      {Touch every 4K page}
      LOffset := 0;
      while LOffset < LPOperation^.RequestedSize do
      begin
        UintOfs := LOffset;
        PByte(NativeUInt(FPointers[LPOperation^.NewPointerNumber]) + UintOfs)^ := 1;
        Inc(LOffset, 4096);
      end;
      {Touch the last byte}
      if LPOperation^.RequestedSize > 2 then
      begin
        UintOfs := LPOperation^.RequestedSize;
        Dec(UintOfs);
        PByte(NativeUInt(FPointers[LPOperation^.NewPointerNumber]) + UintOfs)^ := 1;
      end;
    end
    else
    begin
      {FreeMem}
      FreeMem(FPointers[LPOperation^.OldPointerNumber]);
      FPointers[LPOperation^.OldPointerNumber] := nil;
    end;
    {Next operation}
    Inc(LPOperation);
    {Log peak usage every 1024 operations}
    if LInd and $3ff = 0 then
      UpdateUsageStatistics;
  end;
  {Make sure all memory is released to avoid memory leaks in benchmark}
  for LInd := 0 to High(FPointers) do
    if FPointers[LInd] <> nil then
      FreeMem(FPointers[LInd]);
end;

constructor TReplayThread.Create(ASuspended: Boolean; ABenchmark: TMMBenchmark; RepeatCount: integer);
begin
  inherited Create(ASuspended);
  FreeOnTerminate := False;
  Priority := tpNormal;
  FBenchmark := ABenchmark;
  FRepeatCount := RepeatCount;
end;

procedure TReplayThread.Execute;
var
  i: Integer;
begin
  // Repeat the replay log RepeatCount times
  for i := 1 to FRepeatCount do
    ExecuteReplay;
end;

procedure TReplayThread.ExecuteReplay;
var
  LPOperation: PMMOperation;
  LInd, LOperationCount, LOffset: integer;
  FPointers: array of pointer;
  UintOfs: NativeUInt;
begin
  {Set the list of pointers}
  SetLength(FPointers, length(FOperations) div SizeOf(TMMOperation));
  {Get a pointer to the first operation}
  LPOperation := pointer(FOperations);
  {Get the number of operations to perform}
  LOperationCount := length(FPointers);
  {Perform all the operations}
  for LInd := 0 to LOperationCount - 1 do
  begin
    {Perform the operation}
    if LPOperation^.NewPointerNumber >= 0 then
    begin
      if LPOperation^.OldPointerNumber <> LPOperation^.NewPointerNumber then
      begin
        {GetMem}
        GetMem(FPointers[LPOperation^.NewPointerNumber], LPOperation^.RequestedSize);
      end
      else
      begin
        {ReallocMem}
        ReallocMem(FPointers[LPOperation^.OldPointerNumber], LPOperation^.RequestedSize);
      end;
      {Touch every 4K page}
      LOffset := 0;
      while LOffset < LPOperation^.RequestedSize do
      begin
        UintOfs := LOffset;
        PByte(NativeUInt(FPointers[LPOperation^.NewPointerNumber]) + UintOfs)^ := 1;
        Inc(LOffset, 4096);
      end;
      {Touch the last byte}
      if LPOperation^.RequestedSize > 2 then
      begin
        UintOfs := LPOperation^.RequestedSize;
        Dec(UintOfs);
        PByte(NativeUInt(FPointers[LPOperation^.NewPointerNumber]) + UintOfs)^ := 1;
      end;
    end
    else
    begin
      {FreeMem}
      FreeMem(FPointers[LPOperation^.OldPointerNumber]);
      FPointers[LPOperation^.OldPointerNumber] := nil;
    end;
    {Next operation}
    Inc(LPOperation);
    {Log peak usage every 1024 operations}
    if LInd and $3ff = 0 then
      FBenchMark.UpdateUsageStatistics;
    {the replay is probably running about 10 to 50 times faster than reality}
    {force thread switch every 8192 operations to prevent whole benchmark from running in a single time-slice}
    if LInd and $1fff = 0 then
      Sleep(0);
  end;
  {Make sure all memory is released to avoid memory leaks in benchmark}
  for LInd := 0 to High(FPointers) do
    if FPointers[LInd] <> nil then
      FreeMem(FPointers[LInd]);
end;

// add your replay benchmarks below...

class function TMultiThreadReplayBenchmark.GetCategory: TBenchmarkCategory;
begin
  Result := bmMultiThreadReplay;
end;

procedure TMultiThreadReplayBenchmark.RunBenchmark;
var
  i, rc, slot : Integer;
  WT : TReplayThread;
  ThreadArray : array[0..63] of TReplayThread;
  HandleArray : TWOHandleArray;
begin
  inherited;

  Assert(RunningThreads <= 64, 'Maximum 64 simultaneously running threads in TMultiThreadReplayBenchmark');
  {create threads to start with}
  for i := 0 to RunningThreads - 1 do
  begin
    WT := TReplayThread.Create(True, Self, RepeatCount);
    WT.Operations := FOperations;
    HandleArray[i] := WT.Handle;
    ThreadArray[i] := WT;
  end;
  {start threads...}
  for i := 0 to RunningThreads - 1 do
  begin
    ThreadArray[i].Suspended := False;
  end;
  {loop to replace terminated threads}
  for i := RunningThreads + 1 to ThreadCount do
  begin
    rc := WaitForMultipleObjects(RunningThreads, @HandleArray, False, INFINITE);
    slot := rc - WAIT_OBJECT_0;
    if (slot < 0) or (slot >= RunningThreads) then
    begin
      MessageDlg(SysErrorMessage(GetLastError), mtError, [mbOK], 0);
      Exit;
    end;
    ThreadArray[slot].Free;
    WT := TReplayThread.Create(True, Self, RepeatCount);
    WT.Operations := FOperations;
    HandleArray[slot] := WT.Handle;
    ThreadArray[slot] := WT;
    WT.Suspended := False;
  end;
  rc := WaitForMultipleObjects(RunningThreads, @HandleArray, True, INFINITE);
  for i := 0 to RunningThreads - 1 do
    ThreadArray[i].Free;
  if rc < WAIT_OBJECT_0 then
    MessageDlg(SysErrorMessage(GetLastError), mtError, [mbOK], 0);
end;

class function TMultiThreadReplayBenchmark.RunningThreads: Integer;
begin
  Result := 4;
end;

class function TMultiThreadReplayBenchmark.ThreadCount: Integer;
begin
  Result := 100;
end;

constructor TeLinkBenchmark.CreateBenchmark;
begin
  FUsageLogFileName := 'eLink_MMUsage.log';
  inherited;
end;

class function TeLinkBenchmark.GetBenchmarkDescription: string;
begin
  Result := 'A play-back of the generation of about 300 web pages with '
    + 'the eLink application, a real-world Apache/ISAPI web server extension '
    + '(see www.nextapplication.com). The application involves mostly string '
    + 'manipulations.';
end;

class function TeLinkBenchmark.GetBenchmarkName: string;
begin
  Result := Format('Replay: eLink - %d threads', [RunningThreads]);
end;

class function TeLinkBenchmark.RunByDefault: boolean;
begin
  Result := False;
end;

class function TeLinkBenchmark.RunningThreads: Integer;
begin
  Result := 16;
end;

class function TeLinkBenchmark.ThreadCount: Integer;
begin
  Result := 200;
end;

constructor TeLinkComServerBenchmark.CreateBenchmark;
begin
  FUsageLogFileName := 'LinkCom+Server_MMUsage.log';
  inherited;
end;

class function TeLinkComServerBenchmark.GetBenchmarkDescription: string;
begin
  Result := 'A play-back of the COM+ server side of the eLink application '
    + '(see eLink Benchmark). The application involves mostly database operations: '
    + 'constructing and executing SQL queries and retrieving results in datasets.';
end;

class function TeLinkComServerBenchmark.GetBenchmarkName: string;
begin
  Result := Format('Replay: Link COM+ Server - %d threads', [RunningThreads]);
end;

class function TeLinkComServerBenchmark.RunByDefault: boolean;
begin
  Result := False;
end;

class function TeLinkComServerBenchmark.RunningThreads: Integer;
begin
  Result := 4;
end;

class function TeLinkComServerBenchmark.ThreadCount: Integer;
begin
  Result := 200;
end;

constructor TWebbrokerReplayBenchmark.CreateBenchmark;
begin
  FUsageLogFileName := 'WebBroker_MMUsage.log';
  inherited;
end;

class function TWebbrokerReplayBenchmark.GetBenchmarkDescription: string;
begin
  Result := 'Plays back the memory operations of a webbroker app that was '
    + 'recorded by the MMUsageLogger utility. The recording is played back '
    + IntToStr(RepeatCount * ThreadCount) + ' times using a maximum of '
    + IntToStr(RunningThreads) + ' thread(s).';
end;

class function TWebbrokerReplayBenchmark.GetBenchmarkName: string;
begin
  Result := 'Replay: Webbroker - ' + IntToStr(RunningThreads) + ' thread(s)';
end;

class function TWebbrokerReplayBenchmark.RepeatCount: Integer;
begin
  Result := 1;
end;

class function TWebbrokerReplayBenchmark.RunByDefault: boolean;
begin
  Result := False;
end;

class function TWebbrokerReplayBenchmark.RunningThreads: Integer;
begin
  Result := 8;
end;

class function TWebbrokerReplayBenchmark.ThreadCount: Integer;
begin
  Result := 16;
end;

constructor TReservationsSystemBenchmark.CreateBenchmark;
begin
  FUsageLogFileName := 'Reservations_System_MMUsage.log';
  inherited;
end;

class function TReservationsSystemBenchmark.GetBenchmarkDescription: string;
begin
  Result := 'A replay of typical operations performed by a reservations system: Bookings and clients are created and checked in/out and transactions are processed.';
end;

class function TReservationsSystemBenchmark.GetBenchmarkName: string;
begin
  Result := 'Replay: Reservations System';
end;

class function TReservationsSystemBenchmark.RepeatCount: integer;
begin
  Result := 50;
end;

class function TReservationsSystemBenchmark.RunByDefault: boolean;
begin
  Result := False;
end;

constructor TXMLParserBenchmark.CreateBenchmark;
begin
  FUsageLogFileName := 'XMLParser_MMUsage.log';
  inherited;
end;

class function TXMLParserBenchmark.GetBenchmarkDescription: string;
begin
  Result := 'A recording of a XML parser opening an 11 MB XML file'
    + ' (an Openoffice spreadsheet) and building  a complete DOM'
    + ' (the spreadsheet is then altered in memory and saved back).'
    + ' It is characterized by the allocation of a'
    + ' lot of small blocks.';
end;

class function TXMLParserBenchmark.GetBenchmarkName: string;
begin
  Result := 'Replay: XML Parser';
end;

class function TXMLParserBenchmark.RepeatCount: integer;
begin
  Result := 15;
end;

class function TXMLParserBenchmark.RunByDefault: boolean;
begin
  Result := False;
end;

constructor TBeyondCompareBenchmark.CreateBenchmark;
begin
  FUsageLogFileName := 'BeyondCompare3_MMUsage.log';
  inherited;
end;

class function TBeyondCompareBenchmark.GetBenchmarkDescription: string;
begin
  Result := 'A recording of the Beyond Compare application comparing two files (www.scootersoftware.com).';
end;

class function TBeyondCompareBenchmark.GetBenchmarkName: string;
begin
  Result := 'Replay: Beyond Compare 3 - 4 threads';
end;

class function TBeyondCompareBenchmark.RepeatCount: integer;
begin
  Result := 15;
end;

class function TBeyondCompareBenchmark.RunByDefault: boolean;
begin
  Result := False;
end;

class function TBeyondCompareBenchmark.RunningThreads: Integer;
begin
  Result := 4;
end;

class function TBeyondCompareBenchmark.ThreadCount: Integer;
begin
  Result := 4;
end;

constructor TDocumentClassificationBenchmark.CreateBenchmark;
begin
  FUsageLogFileName := 'Document_Classification_MMUsage.log';
  inherited;
end;

class function TDocumentClassificationBenchmark.GetBenchmarkDescription: string;
begin
  Result := 'A recording of a document indexing and classification application (www.provalisresearch.com).';
end;

class function TDocumentClassificationBenchmark.GetBenchmarkName: string;
begin
  Result := 'Replay: Document Classification';
end;

class function TDocumentClassificationBenchmark.RepeatCount: integer;
begin
  Result := 30;
end;

class function TDocumentClassificationBenchmark.RunByDefault: boolean;
begin
  Result := False;
end;

end.
