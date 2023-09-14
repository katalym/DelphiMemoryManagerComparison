unit LargeBlockSpreadMemTest;

interface

{$I MemoryManagerTest.inc}

uses
  MemTestClassUnit, Math;

const
  // full debug mode is used to detect memory leaks - not for actual performance test
  // value is decreased to avoid Out of Memory in fuul debug mode
{$IFDEF FullDebug}
  NumPointers = 50;
{$ELSE}
  NumPointers = 2000;
{$ENDIF}
  {The block size}
  BlockSize = 65537;

type

  TLargeBlockSpreadBench = class(TMemTest)
  protected
    FPointers: array [0 .. NumPointers - 1] of PAnsiChar;
  public
    constructor CreateMemTest; override;
    destructor Destroy; override;
    procedure RunMemTest; override;
    class function GetMemTestName: string; override;
    class function GetMemTestDescription: string; override;
    class function GetCategory: TMemTestCategory; override;
  end;

implementation

uses
  bvDataTypes, System.SysUtils;

const
  IterationCount = 5;

constructor TLargeBlockSpreadBench.CreateMemTest;
begin
  inherited;
end;

destructor TLargeBlockSpreadBench.Destroy;
begin
  inherited;
end;

class function TLargeBlockSpreadBench.GetMemTestDescription: string;
begin
  Result := 'Allocates a few large blocks (>64K), checking that '
    + 'the MM manages large blocks efficiently.  '
    + 'MemTest submitted by Pierre le Riche.';
end;

class function TLargeBlockSpreadBench.GetMemTestName: string;
begin
  Result := 'Large block spread';
end;

class function TLargeBlockSpreadBench.GetCategory: TMemTestCategory;
begin
  Result := bmSingleThreadAllocAndFree;
end;

procedure TLargeBlockSpreadBench.RunMemTest;
const
  Prime = 7;
var
  i, j, k, LSize: integer;
  NextValue: Int64;
begin
  {Call the inherited handler}
  inherited;
  NextValue := Prime;
  {Do the MemTest}
  for j := 1 to IterationCount do
  begin
    for i := 0 to high(FPointers) do
    begin
      {Get the block}
      LSize := bvInt64ToInt((1 + (NextValue mod 3)) * BlockSize);
      Inc(NextValue, Prime);
      GetMem(FPointers[i], LSize);
      {Fill the memory}
      for k := 0 to LSize - 1 do
        FPointers[i][k] := AnsiChar(k);
    end;
    {What we end with should be close to the peak usage}
    UpdateUsageStatistics;
    {Free the pointers}
    for i := 0 to high(FPointers) do
    begin
      FreeMem(FPointers[i]);
      FPointers[i] := nil;
    end;
  end;
end;

end.
