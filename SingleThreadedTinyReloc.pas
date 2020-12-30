{A single-threaded benchmark that reallocates and uses memory blocks.}

unit SingleThreadedTinyReloc;

interface

uses Windows, BenchmarkClassUnit, Classes, Math;

type

  TSingleThreadedTinyRelocBenchmark = class(TMMBenchmark)
  public
    class function GetBenchmarkDescription: string; override;
    class function GetBenchmarkName: string; override;
    class function GetCategory: TBenchmarkCategory; override;
    procedure RunBenchmark(const aUsageFileToReplay: string =''); override;
  end;

implementation

const
  IterationsCount = 10000;

class function TSingleThreadedTinyRelocBenchmark.GetBenchmarkDescription: string;
begin
  Result := 'A single-threaded benchmark for tiny memory blocs. It allocates and reallocates tiny memory '
    + 'blocks. Allocated memory is actually "used", i.e. written to and read. '
    + 'Rough breakdown: 50% of pointers are <=64 bytes, 95% < 128 bytes, 99% < 256 bytes, rest < 512 bytes. '
    + 'Benchmark submitted by Pierre le Riche.';
end;

class function TSingleThreadedTinyRelocBenchmark.GetBenchmarkName: string;
begin
  Result := 'Single-threaded tiny reallocate and use';
end;

class function TSingleThreadedTinyRelocBenchmark.GetCategory: TBenchmarkCategory;
begin
  Result := bmSingleThreadRealloc;
end;

procedure TSingleThreadedTinyRelocBenchmark.RunBenchmark;
const
  Prime        = 83;
  PointerCount = 500; {small number to fit the cache}
type
  PPointers = ^TPointers;
  TPointers = array [0 .. PointerCount - 1] of Pointer;
var
  i, j: Integer;
  kcalc: NativeUint;
  kloop: Cardinal;
  CurValue: Int64;
  LPointers: PPointers;
  LMax, LSize, LSum: Integer;
begin
  inherited;
  {We want predictable results}
  New(LPointers);
  CurValue := Prime;
  {Allocate the initial pointers}
  for i := 0 to PointerCount - 1 do
  begin
    {Rough breakdown: 50% of pointers are <=64 bytes, 95% < 1K, 99% < 4K, rest < 256K}
    if i and 1 <> 0 then
      LMax := 67 {prime}
    else
      if i and 15 <> 0 then
      LMax := 131 {prime}
    else
      if i and 255 <> 0 then
      LMax := 257 {prime}
    else
      LMax := 521 {prime};
    {Get the size, minimum 1}
    LSize := (CurValue mod LMax) + 1;
    Inc(CurValue, Prime);
    {Get the pointer}
    GetMem(LPointers^[i], LSize);
  end;
  {Reallocate in a loop}
  for j := 1 to IterationsCount do
  begin
    {Update usage statistics}
    UpdateUsageStatistics;
    for i := 0 to PointerCount - 1 do
    begin
      {Rough breakdown: 50% of pointers are <=64 bytes, 95% < 128 bytes, 99% < 256 bytes, rest < 512 bytes.}
      if i and 1 <> 0 then
        LMax := 67 {prime}
      else
        if i and 15 <> 0 then
        LMax := 131 {prime}
      else
        if i and 255 <> 0 then
        LMax := 257 {prime}
      else
        LMax := 521 {prime};
      {Get the size, minimum 1}
      LSize := (CurValue mod LMax) + 1;
      Inc(CurValue, Prime);

      {Reallocate the pointer}
      ReallocMem(LPointers^[i], LSize);
      {Write the memory}
      for kloop := 0 to (LSize - 1) div 32 do
      begin
        kcalc := kloop;
        PByte(NativeUint(LPointers^[i]) + kcalc * 32)^ := byte(i);
      end;
      {Read the memory}
      LSum := 0;
      if LSize > 15 then
      begin
        for kloop := 0 to (LSize - 16) div 32 do
        begin
          kcalc := kloop;
          Inc(LSum, PShortInt(NativeUint(LPointers^[i]) + kcalc * 32 + 15)^);
        end;
      end;
      {"Use" the sum to suppress the compiler warning}
      if LSum > 0 then;
    end;
  end;
  {Free all the objects}
  for i := 0 to PointerCount - 1 do
  begin
    FreeMem(LPointers^[i]);
    LPointers^[i] := nil;
  end;
  Dispose(LPointers);
end;

end.
