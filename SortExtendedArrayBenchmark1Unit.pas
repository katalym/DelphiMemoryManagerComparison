unit SortExtendedArrayBenchmark1Unit;

interface

uses
  Windows, BenchmarkClassUnit, Classes, Math;

type

  TStandardSortExtendedArrayThreads = class(TFastcodeMMBenchmark)
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

  TStandardSortExtendedArrayThread = class(TThread)
    FBenchmark: TFastcodeMMBenchmark;
    Prime: Integer;
    procedure Execute; override;
  end;

  TExtended = record
   X : Extended;
   Pad1, Pad2, Pad3, Pad4, Pad5, Pad6 : Byte;
  end;

 TExtendedArray = array[0..500000] of TExtended;
 PExtendedArray = ^TExtendedArray;

procedure TStandardSortExtendedArrayThread.Execute;
var
 ExtArray :  PExtendedArray;
 Size, I1, I2, I3, IndexMax, RunNo, LowIndex, HighIndex: Integer;
 CurValue: Int64;
 Temp, Max : Extended;
const
 MAXRUNNO = 100;
 MAXELEMENTVALUE = MAXINT;
 MINSIZE = 100;
 MAXSIZE = 10000;
begin
  CurValue := Prime;
  GetMem(ExtArray, MINSIZE * SizeOf(TExtended));
  for RunNo := 1 to MAXRUNNO do
  begin
    Size := (CurValue mod (MAXSIZE-MINSIZE)) + MINSIZE;
    Inc(CurValue, Prime);
    //SetLength(ExtArray, Size);
    ReallocMem(ExtArray, Size * SizeOf(TExtended));
    //Fill array with arbitary values
    for I1 := 0 to Size-1 do
    begin
      ExtArray^[I1].X := (CurValue mod MAXELEMENTVALUE)*pi;
      Inc(CurValue, Prime);
    end;
    //Sort array just to create an acces pattern
    //Using some weird DKC sort algorithm
    LowIndex := 0;
    HighIndex := Size-1;
    repeat
    if ExtArray^[LowIndex].X > ExtArray^[HighIndex].X then
     begin
      //Swap
      Temp := ExtArray^[LowIndex].X;
      ExtArray^[LowIndex].X := ExtArray^[HighIndex].X;
      ExtArray^[HighIndex].X := Temp;
     end;
    Inc(LowIndex);
    Dec(HighIndex);
    until(LowIndex >= HighIndex);
    for I2 := Size-1 downto 1 do
    begin
     //Find biggest element in unsorted part of array
     Max := ExtArray^[I2].X;
     IndexMax := I2;
     for I3 := I2-1 downto 0 do
      begin
       if ExtArray^[I3].X > Max then
        begin
         Max := ExtArray^[I3].X;
         IndexMax := I3;
        end;
      end;
     //Swap current element with biggest remaining element
     Temp := ExtArray^[I2].X;
     ExtArray^[I2].X := ExtArray^[IndexMax].X;
     ExtArray^[IndexMax].X := Temp;
    end;
  end;
  //Free array
  FreeMem(ExtArray);
  FBenchmark.UpdateUsageStatistics;
end;

class function TStandardSortExtendedArrayThreads.GetBenchmarkDescription: string;
begin
  Result := 'A benchmark that measures read and write speed to an array of Extendeds. '
          + 'The Extended type is padded to be 16 byte. '
          + 'Bonus is given for 16 byte alignment of array '
          + 'Will also reveil cache set associativity related issues. '
          + 'Access pattern is created by X sorting array of arbitrary values. '
          + 'Measures memory usage after all blocks have been freed. '
          + 'Benchmark submitted by Dennis Kjaer Christensen.';
end;

class function TStandardSortExtendedArrayThreads.GetBenchmarkName: string;
begin
  Result := 'Sort Extended Array';
end;

class function TStandardSortExtendedArrayThreads.GetCategory: TBenchmarkCategory;
begin
  Result := bmMemoryAccessSpeed;
end;

procedure TStandardSortExtendedArrayThreads.RunBenchmark;
var
  SortExtendedArrayThread1,
  SortExtendedArrayThread2,
  SortExtendedArrayThread3,
  SortExtendedArrayThread4,
  SortExtendedArrayThread5,
  SortExtendedArrayThread6,
  SortExtendedArrayThread7,
  SortExtendedArrayThread8: TStandardSortExtendedArrayThread;
begin
  inherited;
  SortExtendedArrayThread1 := TStandardSortExtendedArrayThread.Create(True);
  SortExtendedArrayThread2 := TStandardSortExtendedArrayThread.Create(True);
  SortExtendedArrayThread3 := TStandardSortExtendedArrayThread.Create(True);
  SortExtendedArrayThread4 := TStandardSortExtendedArrayThread.Create(True);
  SortExtendedArrayThread5 := TStandardSortExtendedArrayThread.Create(True);
  SortExtendedArrayThread6 := TStandardSortExtendedArrayThread.Create(True);
  SortExtendedArrayThread7 := TStandardSortExtendedArrayThread.Create(True);
  SortExtendedArrayThread8 := TStandardSortExtendedArrayThread.Create(True);

  SortExtendedArrayThread1.Prime := 4451;
  SortExtendedArrayThread2.Prime := 4457;
  SortExtendedArrayThread3.Prime := 4463;
  SortExtendedArrayThread4.Prime := 4481;
  SortExtendedArrayThread5.Prime := 4483;
  SortExtendedArrayThread6.Prime := 4493;
  SortExtendedArrayThread7.Prime := 4507;
  SortExtendedArrayThread8.Prime := 4513;

  SortExtendedArrayThread1.FreeOnTerminate := False;
  SortExtendedArrayThread2.FreeOnTerminate := False;
  SortExtendedArrayThread3.FreeOnTerminate := False;
  SortExtendedArrayThread4.FreeOnTerminate := False;
  SortExtendedArrayThread5.FreeOnTerminate := False;
  SortExtendedArrayThread6.FreeOnTerminate := False;
  SortExtendedArrayThread7.FreeOnTerminate := False;
  SortExtendedArrayThread8.FreeOnTerminate := False;

  SortExtendedArrayThread1.Priority := tpIdle;
  SortExtendedArrayThread2.Priority := tpLowest;
  SortExtendedArrayThread3.Priority := tpLower;
  SortExtendedArrayThread4.Priority := tpNormal;
  SortExtendedArrayThread5.Priority := tpHigher;
  SortExtendedArrayThread6.Priority := tpHighest;
  SortExtendedArrayThread7.Priority := tpTimeCritical;
  SortExtendedArrayThread8.Priority := tpTimeCritical;

  SortExtendedArrayThread1.FBenchmark := Self;
  SortExtendedArrayThread2.FBenchmark := Self;
  SortExtendedArrayThread3.FBenchmark := Self;
  SortExtendedArrayThread4.FBenchmark := Self;
  SortExtendedArrayThread5.FBenchmark := Self;
  SortExtendedArrayThread6.FBenchmark := Self;
  SortExtendedArrayThread7.FBenchmark := Self;
  SortExtendedArrayThread8.FBenchmark := Self;

  SortExtendedArrayThread1.Suspended := False;
  SortExtendedArrayThread2.Suspended := False;
  SortExtendedArrayThread3.Suspended := False;
  SortExtendedArrayThread4.Suspended := False;
  SortExtendedArrayThread5.Suspended := False;
  SortExtendedArrayThread6.Suspended := False;
  SortExtendedArrayThread7.Suspended := False;
  SortExtendedArrayThread8.Suspended := False;

  SortExtendedArrayThread8.WaitFor;
  SortExtendedArrayThread1.Priority := tpTimeCritical;

  SortExtendedArrayThread7.WaitFor;
  SortExtendedArrayThread2.Priority := tpTimeCritical;

  SortExtendedArrayThread6.WaitFor;
  SortExtendedArrayThread3.Priority := tpTimeCritical;

  SortExtendedArrayThread5.WaitFor;
  SortExtendedArrayThread4.Priority := tpTimeCritical;

  SortExtendedArrayThread4.WaitFor;
  SortExtendedArrayThread3.WaitFor;
  SortExtendedArrayThread2.WaitFor;
  SortExtendedArrayThread1.WaitFor;

  FreeAndNil(SortExtendedArrayThread1);
  FreeAndNil(SortExtendedArrayThread2);
  FreeAndNil(SortExtendedArrayThread3);
  FreeAndNil(SortExtendedArrayThread4);
  FreeAndNil(SortExtendedArrayThread5);
  FreeAndNil(SortExtendedArrayThread6);
  FreeAndNil(SortExtendedArrayThread7);
  FreeAndNil(SortExtendedArrayThread8);

end;

end.
