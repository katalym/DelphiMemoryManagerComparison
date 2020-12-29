unit SortIntArrayBenchmark1Unit;

interface

{$I MemoryManagerTest.inc}

uses
  Windows, BenchmarkClassUnit, Classes, Math;

type

  TSortIntArrayThreads = class(TMMBenchmark)
  public
    class function GetBenchmarkDescription: string; override;
    class function GetBenchmarkName: string; override;
    class function GetCategory: TBenchmarkCategory; override;
    procedure RunBenchmark; override;
  end;

implementation

uses
  SysUtils;

type

  TSortIntArrayThread = class(TThread)
    FBenchmark: TMMBenchmark;
    FCurValue: Int64;
    FPrime: Integer;
    procedure Execute; override;
  end;

procedure TSortIntArrayThread.Execute;
var
 IntArray : array of Integer;
 Size, I1, I2, I3, IndexMax, Temp, Max : Integer;
const
 MINSIZE = 5;
{$IFDEF MM_FASTMM4_FullDebug or MM_FASTMM5_FullDebug}
  MAXSIZE = 300;
{$ELSE}
  MAXSIZE = 3200;
{$ENDIF}
 MaxValue = 103 {prime};
begin
 FCurValue := FPrime;
 for Size := MINSIZE to MAXSIZE do
 begin
   SetLength(IntArray, Size);
   //Fill array with arbitrary values
   for I1 := 0 to Size-1 do
   begin
     IntArray[I1] := FCurValue mod MaxValue;
     Inc(FCurValue, FPrime);
   end;
   //Sort array just to create an acces pattern
   for I2 := 0 to Size-2 do
    begin
     //Find biggest element in unsorted part of array
     Max := IntArray[I2];
     IndexMax := I2;
     for I3 := I2+1 to Size-1 do
      begin
       if IntArray[I3] > Max then
        begin
         Max := IntArray[I3];
         IndexMax := I3;
        end;
      end;
     //Swap current element with biggest remaining element
     Temp := IntArray[I2];
     IntArray[I2] := IntArray[IndexMax];
     IntArray[IndexMax] := Temp;
    end;
  end;
 //"Free" array
 SetLength(IntArray, 0);
 FBenchmark.UpdateUsageStatistics;
end;

class function TSortIntArrayThreads.GetBenchmarkDescription: string;
begin
  Result := 'A benchmark that measures read and write speed to an array of Integer. '
          + 'Access pattern is created by  selection sorting array of arbitrary values. '
          + 'Measures memory usage after all blocks have been freed. '
          + 'Benchmark submitted by Dennis Kjaer Christensen.';
end;

class function TSortIntArrayThreads.GetBenchmarkName: string;
begin
  Result := 'Sort Integer Array';
end;

class function TSortIntArrayThreads.GetCategory: TBenchmarkCategory;
begin
  Result := bmMemoryAccessSpeed;
end;

procedure TSortIntArrayThreads.RunBenchmark;
var
  SortIntArrayThread : TSortIntArrayThread;
begin
  inherited;
  SortIntArrayThread := TSortIntArrayThread.Create(True);
  SortIntArrayThread.FreeOnTerminate := False;
  SortIntArrayThread.FBenchmark := Self;
  SortIntArrayThread.FPrime := 1153;
  SortIntArrayThread.Suspended := False;
  SortIntArrayThread.WaitFor;
  FreeAndNil(SortIntArrayThread);
end;

end.
