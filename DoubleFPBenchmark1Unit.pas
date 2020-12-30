unit DoubleFPBenchmark1Unit;

interface

uses Windows, BenchmarkClassUnit, Classes, Math;

type

  TDoubleFPThreads1 = class(TMMBenchmark)
  public
    class function GetBenchmarkDescription: string; override;
    class function GetBenchmarkName: string; override;
    class function GetCategory: TBenchmarkCategory; override;
    procedure RunBenchmark(const aUsageFileToReplay: string =''); override;
  end;

implementation

uses
  SysUtils;

const
  IterationCount = 5;

type

  TDoubleFPThread1 = class(TThread)
    FBenchmark: TMMBenchmark;
    procedure Execute; override;
  end;

  TRegtangularComplexD = packed record
    RealPart, ImaginaryPart: Double;
  end;

  // Loading some double values

procedure TestFunction(var Res: TRegtangularComplexD;
  const X, Y: TRegtangularComplexD);
begin
  Res.RealPart := X.RealPart + Y.RealPart + X.RealPart + Y.RealPart + X.RealPart
    + Y.RealPart + X.RealPart + Y.RealPart + X.RealPart + Y.RealPart;
  Res.ImaginaryPart := X.ImaginaryPart + Y.ImaginaryPart + X.ImaginaryPart +
    Y.ImaginaryPart + X.ImaginaryPart + Y.ImaginaryPart + X.ImaginaryPart +
    Y.ImaginaryPart + X.ImaginaryPart + Y.ImaginaryPart;
end;

procedure TDoubleFPThread1.Execute;
var
  I1, I3, I4, I5, I6, I7, I8, J1, J2, J3, J4, J5, J6: Integer;
  // Need many arrays because a 4 byte aligned array can be 8 byte aligned by pure chance
  Src1Array1: array of TRegtangularComplexD;
  Src2Array1: array of TRegtangularComplexD;
  ResultArray1: array of TRegtangularComplexD;
  Src1Array2: array of TRegtangularComplexD;
  Src2Array2: array of TRegtangularComplexD;
  ResultArray2: array of TRegtangularComplexD;
  Src1Array3: array of TRegtangularComplexD;
  Src2Array3: array of TRegtangularComplexD;
  ResultArray3: array of TRegtangularComplexD;
  Src1Array4: array of TRegtangularComplexD;
  Src2Array4: array of TRegtangularComplexD;
  ResultArray4: array of TRegtangularComplexD;
  Src1Array5: array of TRegtangularComplexD;
  Src2Array5: array of TRegtangularComplexD;
  ResultArray5: array of TRegtangularComplexD;
  Src1Array6: array of TRegtangularComplexD;
  Src2Array6: array of TRegtangularComplexD;
  ResultArray6: array of TRegtangularComplexD;
  BenchArraySize: Integer;
const
  MINBENCHARRAYSIZE = 9500;
  MAXBENCHARRAYSIZE = 10000;

begin
  for BenchArraySize := MINBENCHARRAYSIZE to MAXBENCHARRAYSIZE do
  begin
    SetLength(Src1Array1, BenchArraySize);
    SetLength(Src2Array1, BenchArraySize);
    SetLength(ResultArray1, BenchArraySize);
    SetLength(Src1Array2, BenchArraySize);
    SetLength(Src2Array2, BenchArraySize);
    SetLength(ResultArray2, BenchArraySize);
    SetLength(Src1Array3, BenchArraySize);
    SetLength(Src2Array3, BenchArraySize);
    SetLength(ResultArray3, BenchArraySize);
    SetLength(Src1Array4, BenchArraySize);
    SetLength(Src2Array4, BenchArraySize);
    SetLength(ResultArray4, BenchArraySize);
    SetLength(Src1Array5, BenchArraySize);
    SetLength(Src2Array5, BenchArraySize);
    SetLength(ResultArray5, BenchArraySize);
    SetLength(Src1Array6, BenchArraySize);
    SetLength(Src2Array6, BenchArraySize);
    SetLength(ResultArray6, BenchArraySize);
    FBenchmark.UpdateUsageStatistics;
    // Fill source arrays
    for I1 := 0 to BenchArraySize - 1 do
    begin
      Src1Array1[I1].RealPart := 1;
      Src1Array1[I1].ImaginaryPart := 1;
      Src2Array1[I1].RealPart := 1;
      Src2Array1[I1].ImaginaryPart := 1;
    end;
    // Run on one set of arrays at a time
    // Only 3 memory blocks active at a time
    for J1 := 1 to IterationCount do
      for I3 := 0 to BenchArraySize - 1 do
        TestFunction(ResultArray1[I3], Src1Array1[I3], Src2Array1[I3]);
    for J2 := 1 to IterationCount do
      for I4 := 0 to BenchArraySize - 1 do
        TestFunction(ResultArray2[I4], Src1Array2[I4], Src2Array2[I4]);
    for J3 := 2 to IterationCount do
      for I5 := 0 to BenchArraySize - 1 do
        TestFunction(ResultArray3[I5], Src1Array3[I5], Src2Array3[I5]);
    for J4 := 1 to IterationCount do
      for I6 := 0 to BenchArraySize - 1 do
        TestFunction(ResultArray4[I6], Src1Array4[I6], Src2Array4[I6]);
    for J5 := 1 to IterationCount do
      for I7 := 0 to BenchArraySize - 1 do
        TestFunction(ResultArray5[I7], Src1Array5[I7], Src2Array5[I7]);
    for J6 := 1 to IterationCount do
      for I8 := 0 to BenchArraySize - 1 do
        TestFunction(ResultArray6[I8], Src1Array6[I8], Src2Array6[I8]);
  end;
end;

class function TDoubleFPThreads1.GetBenchmarkDescription: string;
begin
  Result := 'A benchmark that tests access to Double FP variables ' +
    'in a dynamic array. ' +
    'Gives bonus for 8 byte aligned blocks. Also reveals set associativity related issues.'
    + 'Benchmark submitted by Dennis Kjaer Christensen.';
end;

class function TDoubleFPThreads1.GetBenchmarkName: string;
begin
  Result := 'Double Variables Access  3 arrays at a time';
end;

class function TDoubleFPThreads1.GetCategory: TBenchmarkCategory;
begin
  Result := bmMemoryAccessSpeed;
end;

procedure TDoubleFPThreads1.RunBenchmark;
var
  DoubleFPThread1: TDoubleFPThread1;
begin
  inherited;
  DoubleFPThread1 := TDoubleFPThread1.Create(True);
  DoubleFPThread1.FreeOnTerminate := False;
  DoubleFPThread1.FBenchmark := Self;
  DoubleFPThread1.Suspended := False;
  DoubleFPThread1.WaitFor;
  FreeAndNil(DoubleFPThread1);
end;

end.
