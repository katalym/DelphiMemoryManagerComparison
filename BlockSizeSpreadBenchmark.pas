unit BlockSizeSpreadBenchmark;

interface

uses
  BenchmarkClassUnit, Math;

const
  {The number of pointers}
  NumPointers = 3000000;
  {The maximum block size}
  MaxBlockSize = 25;

type

  TBlockSizeSpreadBench = class(TFastcodeMMBenchmark)
  protected
    FPointers: array[0..NumPointers - 1] of PAnsiChar;
  public
    constructor CreateBenchmark; override;
    destructor Destroy; override;
    procedure RunBenchmark; override;
    class function GetBenchmarkName: string; override;
    class function GetBenchmarkDescription: string; override;
    class function GetCategory: TBenchmarkCategory; override;
  end;

implementation

const
// full debug mode is used to detect memory leaks - not for actual performance test
// value is decreased to avoid Out of Memory in fuul debug mode
{$IFDEF MM_FASTMM4_FullDebug}
  IterationsCount = 5;
{$ELSE}
{$IFDEF MM_FASTMM5_FullDebug}
  IterationsCount = 5;
{$ELSE}
  IterationsCount = 20;
{$ENDIF}
{$ENDIF}

constructor TBlockSizeSpreadBench.CreateBenchmark;
begin
  inherited;
end;

destructor TBlockSizeSpreadBench.Destroy;
begin
  inherited;
end;

class function TBlockSizeSpreadBench.GetBenchmarkDescription: string;
begin
  Result := 'Allocates millions of small objects, checking that the MM '
    + 'has a decent block size spread.  '
    + 'Benchmark submitted by Pierre le Riche.';
end;

class function TBlockSizeSpreadBench.GetBenchmarkName: string;
begin
  Result := 'Block size spread';
end;

class function TBlockSizeSpreadBench.GetCategory: TBenchmarkCategory;
begin
  Result := bmSingleThreadAllocAndFree;
end;

procedure TBlockSizeSpreadBench.RunBenchmark;
const
  Prime = 17;
var
  i, n, LSize: integer;
  NextValue: Int64;
begin
  {Call the inherited handler}
  inherited;
  NextValue := Prime;
  for n := 1 to IterationsCount do     // loop added to have more than 1000 MTicks for this benchmark
  begin
    {Do the benchmark}
    for i := 0 to high(FPointers) do
    begin
      {Get the initial block size, assume object sizes are 4-byte aligned}
      LSize := (1 + (MaxBlockSize+NextValue) mod NextValue) * 4;
      Inc(NextValue, Prime);
      GetMem(FPointers[i], LSize);
      FPointers[i][0] := #13;
      if LSize > 2 then
      begin
        FPointers[i][LSize - 1] := #13;
      end;
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
