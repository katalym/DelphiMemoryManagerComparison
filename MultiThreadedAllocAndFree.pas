{A benchmark that allocates and frees many blocks in a multi-threaded environment.}

unit MultiThreadedAllocAndFree;

interface

{$I MemoryManagerTest.inc}

uses
  Windows, BenchmarkClassUnit, Classes, Math;

type

  TMultiThreadAllocateAndFreeBenchmarkAbstract = class(TMMBenchmark)
  public
    class function GetBenchmarkDescription: string; override;
    class function GetBenchmarkName: string; override;
    class function GetCategory: TBenchmarkCategory; override;
    class function GetNumThreads: Integer; virtual; abstract;
    class function IsThreadedSpecial: Boolean; override;
    procedure RunBenchmark; override;
  end;

  TMultiThreadAllocateAndFreeBenchmark2 = class(TMultiThreadAllocateAndFreeBenchmarkAbstract)
    class function GetNumThreads: Integer; override;
  end;

  TMultiThreadAllocateAndFreeBenchmark4 = class(TMultiThreadAllocateAndFreeBenchmarkAbstract)
    class function GetNumThreads: Integer; override;
  end;

  TMultiThreadAllocateAndFreeBenchmark8 = class(TMultiThreadAllocateAndFreeBenchmarkAbstract)
    class function GetNumThreads: Integer; override;
  end;

  TMultiThreadAllocateAndFreeBenchmark12 = class(TMultiThreadAllocateAndFreeBenchmarkAbstract)
    class function GetNumThreads: Integer; override;
  end;

  TMultiThreadAllocateAndFreeBenchmark16 = class(TMultiThreadAllocateAndFreeBenchmarkAbstract)
    class function GetNumThreads: Integer; override;
  end;

  TMultiThreadAllocateAndFreeBenchmark31 = class(TMultiThreadAllocateAndFreeBenchmarkAbstract)
    class function GetNumThreads: Integer; override;
  end;

  TMultiThreadAllocateAndFreeBenchmark64 = class(TMultiThreadAllocateAndFreeBenchmarkAbstract)
    class function GetNumThreads: Integer; override;
  end;

implementation

uses
  SysUtils,
  PrimeNumbers,
  bvDataTypes;

type
  TCreateAndFreeThread = class(TThread)
  public
    FCurValue: Int64;
    FPrime: Cardinal;
    FRepeatCount: Integer;
    procedure Execute; override;
  end;

procedure TCreateAndFreeThread.Execute;
const
{$IFDEF FullDebug}
  PointerCount = 25;
{$ELSE}
  PointerCount = 2500;
{$ENDIF}
var
  i, j: Integer;
  kloop: Cardinal;
  kcalc: NativeUint;
  LPointers: array [0 .. PointerCount - 1] of Pointer;
  LMax, LSize, LSum: Integer;
begin
  {Allocate the initial pointers}
  for i := 0 to PointerCount - 1 do
  begin
    {Rough breakdown: 50% of pointers are <=64 bytes, 95% < 1K, 99% < 4K, rest < 256K}
    if i and 1 <> 0 then
      LMax := 64
    else
      if i and 15 <> 0 then
      LMax := 1024
    else
      if i and 255 <> 0 then
      LMax := 4 * 1024
    else
      LMax := 256 * 1024;
    {Get the size, minimum 1}
    Inc(FCurValue, FPrime);
    LSize := bvInt64ToInt((FCurValue mod LMax) + 1);
    {Get the pointer}
    GetMem(LPointers[i], LSize);
  end;
  {Free and allocate in a loop}
  for j := 1 to FRepeatCount do
  begin
    for i := 0 to PointerCount - 1 do
    begin
      {Free the pointer}
      FreeMem(LPointers[i]);
      {Rough breakdown: 50% of pointers are <=64 bytes, 95% < 1K, 99% < 4K, rest < 256K}
      if i and 1 <> 0 then
        LMax := 64
      else
        if i and 15 <> 0 then
        LMax := 1024
      else
        if i and 255 <> 0 then
        LMax := 4 * 1024
      else
        LMax := 256 * 1024;
      {Get the size, minimum 1}
      Inc(FCurValue, FPrime);
      LSize := bvInt64ToInt((FCurValue mod LMax) + 1);
      {Get the pointer}
      GetMem(LPointers[i], LSize);
      {Write the memory}
      for kloop := 0 to bvIntToCardinal((LSize - 1) div 32) do
      begin
        kcalc := kloop;
        PByte(NativeUint(LPointers[i]) + kcalc * 32)^ := byte(i);
      end;
      {Read the memory}
      LSum := 0;
      if LSize > 15 then
      begin
        for kloop := 0 to bvIntToCardinal((LSize - 16) div 32) do
        begin
          kcalc := kloop;
          Inc(LSum, PShortInt(NativeUint(LPointers[i]) + kcalc * 32 + 15)^);
        end;
      end;
      {"Use" the sum to suppress the compiler warning}
      if LSum > 0 then;
    end;
  end;
  {Free all the objects}
  for i := 0 to PointerCount - 1 do
    FreeMem(LPointers[i]);
  {Set the return value}
  ReturnValue := 1;
end;

class function TMultiThreadAllocateAndFreeBenchmarkAbstract.GetBenchmarkDescription: string;
begin
  Result := 'A ' + IntToStr(GetNumThreads) + '-threaded benchmark that allocates and frees memory blocks. '
    + 'The usage of different block sizes approximates real-world usage as seen '
    + 'in various replays. Allocated memory is actually "used", i.e. written to '
    + 'and read.  '
    + 'Benchmark submitted by Pierre le Riche.';
end;

class function TMultiThreadAllocateAndFreeBenchmarkAbstract.GetBenchmarkName: string;
begin
  Result := 'Multi-threaded ' + GetNumThreads.ToString.PadLeft(2, ' ') + ' allocate, use and free';
end;

class function TMultiThreadAllocateAndFreeBenchmarkAbstract.GetCategory: TBenchmarkCategory;
begin
  Result := bmMultiThreadAllocAndFree;
end;

class function TMultiThreadAllocateAndFreeBenchmarkAbstract.IsThreadedSpecial: Boolean;
begin
  Result := True;
end;

procedure TMultiThreadAllocateAndFreeBenchmarkAbstract.RunBenchmark;
const
  CRepeatCountTotal = 5555;
var
  PrimeIndex, n: Integer;
  LCreateAndFree: TCreateAndFreeThread;
  LNumThreads: Integer;
  threads: TList;
  LFinished: Boolean;
begin
  inherited;
  LNumThreads := GetNumThreads;
  PrimeIndex := low(VeryGoodPrimes);
  threads := TList.Create;
  {create threads}
  for n := 1 to LNumThreads do
  begin
    LCreateAndFree := TCreateAndFreeThread.Create(True);
    LCreateAndFree.Priority := tpLower;
    LCreateAndFree.FPrime := VeryGoodPrimes[PrimeIndex];
    LCreateAndFree.FRepeatCount := CRepeatCountTotal div LNumThreads;
    Inc(PrimeIndex);
    if PrimeIndex > high(VeryGoodPrimes) then
      PrimeIndex := low(VeryGoodPrimes);
    LCreateAndFree.FreeOnTerminate := False;
    threads.Add(LCreateAndFree);
  end;
  {start all threads at the same time}
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_ABOVE_NORMAL);
  for n := 0 to threads.Count - 1 do
  begin
    LCreateAndFree := TCreateAndFreeThread(threads.Items[n]);
    LCreateAndFree.Suspended := False;
  end;
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_NORMAL);
  {wait for completion of the threads}
  repeat
    {Any threads still running?}
    LFinished := True;
    for n := 0 to threads.Count - 1 do
    begin
      LCreateAndFree := TCreateAndFreeThread(threads.Items[n]);
      LFinished := LFinished and (LCreateAndFree.ReturnValue <> 0);
    end;
    {Update usage statistics}
    UpdateUsageStatistics;
{$IFDEF WIN32}
    {Don't sleep on Win64 to influence the results}
    sleep(10);
{$ENDIF}
  until LFinished;
  {Free the threads}
  for n := 0 to threads.Count - 1 do
  begin
    LCreateAndFree := TCreateAndFreeThread(threads.Items[n]);
    LCreateAndFree.Terminate;
  end;
  for n := 0 to threads.Count - 1 do
  begin
    LCreateAndFree := TCreateAndFreeThread(threads.Items[n]);
    LCreateAndFree.WaitFor;
  end;
  for n := 0 to threads.Count - 1 do
  begin
    LCreateAndFree := TCreateAndFreeThread(threads.Items[n]);
    LCreateAndFree.Free;
  end;
  threads.Clear;
  FreeAndNil(threads);
end;

class function TMultiThreadAllocateAndFreeBenchmark2.GetNumThreads: Integer;
begin
  Result := 2;
end;

class function TMultiThreadAllocateAndFreeBenchmark4.GetNumThreads: Integer;
begin
  Result := 4;
end;

class function TMultiThreadAllocateAndFreeBenchmark8.GetNumThreads: Integer;
begin
  Result := 8;
end;

class function TMultiThreadAllocateAndFreeBenchmark12.GetNumThreads: Integer;
begin
  Result := 12;
end;

class function TMultiThreadAllocateAndFreeBenchmark16.GetNumThreads: Integer;
begin
  Result := 16;
end;

class function TMultiThreadAllocateAndFreeBenchmark31.GetNumThreads: Integer;
begin
  Result := 32;
end;

class function TMultiThreadAllocateAndFreeBenchmark64.GetNumThreads: Integer;
begin
  Result := 64;
end;

end.
