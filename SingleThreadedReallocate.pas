{A single-threaded MemTest that reallocates and uses memory blocks.}

unit SingleThreadedReallocate;

interface

{$I MemoryManagerTest.inc}

uses
  Windows, MemTestClassUnit, Classes, Math;

type

  TSingleThreadReallocateVariousBlocksMemTest = class(TMemTest)
  public
    class function GetMemTestDescription: string; override;
    class function GetMemTestName: string; override;
    class function GetCategory: TMemTestCategory; override;
    procedure RunMemTest; override;
  end;

implementation

uses
  bvDataTypes, System.SysUtils;

class function TSingleThreadReallocateVariousBlocksMemTest.GetMemTestDescription: string;
begin
  Result := 'A single-threaded MemTest that allocates and reallocates memory '
    + 'blocks. The usage of different block sizes approximates real-world usage '
    + 'as seen in various replays. Allocated memory is actually "used", i.e. '
    + 'written to and read.  Rough breakdown: 50% of pointers are <=64 bytes, 95% < 1K, 99% < 4K, rest < 256K'
    + 'MemTest submitted by Pierre le Riche.';
end;

class function TSingleThreadReallocateVariousBlocksMemTest.GetMemTestName: string;
begin
  Result := 'Single-threaded reallocate and use';
end;

class function TSingleThreadReallocateVariousBlocksMemTest.GetCategory: TMemTestCategory;
begin
  Result := bmSingleThreadRealloc;
end;

procedure TSingleThreadReallocateVariousBlocksMemTest.RunMemTest;
const
  Prime = 29;
{$IFDEF FullDebug}
  IterationsCount = 25;
  PointerCount    = 4000;
{$ELSE}
  IterationsCount = 45;
  PointerCount    = 450000;
{$ENDIF}
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
    LSize := bvInt64ToInt((CurValue mod LMax) + 1);
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
      LSize := bvInt64ToInt((CurValue mod LMax) + 1);
      Inc(CurValue, Prime);

      {Reallocate the pointer}
      ReallocMem(LPointers^[i], LSize);
      {Write the memory}
      for kloop := 0 to bvIntToCardinal((LSize - 1) div 32) do
      begin
        kcalc := kloop;
        PByte(NativeUint(LPointers^[i]) + kcalc * 32)^ := byte(i);
      end;
      {Read the memory}
      LSum := 0;
      if LSize > 15 then
      begin
        for kloop := 0 to bvIntToCardinal((LSize - 16) div 32) do
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
