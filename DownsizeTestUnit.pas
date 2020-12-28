{A benchmark demonstrating that never downsizing memory blocks can lead to problems.}

unit DownsizeTestUnit;

interface

{$I MemoryManagerTest.inc}

uses BenchmarkClassUnit;

type

  TDownsizeTest = class(TMMBenchmark)
  protected
    FStrings: array of string;
  public
    class function GetBenchmarkDescription: string; override;
    class function GetBenchmarkName: string; override;
    class function GetCategory: TBenchmarkCategory; override;
    procedure RunBenchmark; override;
  end;

implementation

const
  IterationCount = 45;

class function TDownsizeTest.GetBenchmarkDescription: string;
begin
  Result := 'Allocates large blocks and immediately resizes them to a '
    + 'much smaller size. This checks whether the memory manager downsizes '
    + 'memory blocks correctly.  '
    + 'Benchmark submitted by Pierre le Riche.';
end;

class function TDownsizeTest.GetBenchmarkName: string;
begin
  Result := 'Block downsize';
end;

class function TDownsizeTest.GetCategory: TBenchmarkCategory;
begin
  Result := bmSingleThreadRealloc;
end;

procedure TDownsizeTest.RunBenchmark;
Const
// full debug mode is used to detect memory leaks - not for actual performance test
// value is decreased to avoid Out of Memory in fuul debug mode
{$IFDEF MM_FASTMM4_FullDebug}
  TotalStrings = 100000;
{$ELSE}
{$IFDEF MM_FASTMM5_FullDebug}
  TotalStrings = 100000;
{$ELSE}
  TotalStrings = 3000000;
{$ENDIF}
{$ENDIF}
var
  i, n, LOffset: integer;
begin
  inherited;

  for n := 1 to IterationCount do
  begin
    {Allocate a lot of strings}
    SetLength(FStrings, TotalStrings);
    for i := Low(FStrings) to High(FStrings) do begin
      {Grab a 20K block}
      SetLength(FStrings[i], 20000);
      {Touch memory}
      LOffset := 1;
      while LOffset <= 20000 do
      begin
        FStrings[i][LOffset] := #1;
        Inc(LOffset, 4096);
      end;
      {Reduce the size to 1 byte}
      SetLength(FStrings[i], 1);
    end;
    {Update the peak address space usage}
    UpdateUsageStatistics;
  end;
end;

end.
