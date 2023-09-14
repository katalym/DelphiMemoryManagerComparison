unit SingleFPMemTest2Unit;

interface

uses Windows, MemTestClassUnit, Classes, Math;

type

  TSingleFPThreads2 = class(TMemTest)
  public
    class function GetMemTestDescription: string; override;
    class function GetMemTestName: string; override;
    class function GetCategory: TMemTestCategory; override;
    procedure RunMemTest; override;
  end;

implementation

uses SysUtils;

type

  TSingleFPThread2 = class(TThread)
    FMemTest: TMemTest;
    procedure Execute; override;
  end;

  TRegtangularComplexS = packed record
    RealPart, ImaginaryPart: Single;
  end;

  // Loading some Single values

procedure TestFunction(var Res: TRegtangularComplexS; const X, Y: TRegtangularComplexS);
begin
  Res.RealPart := X.RealPart + Y.RealPart
    + X.RealPart + Y.RealPart
    + X.RealPart + Y.RealPart
    + X.RealPart + Y.RealPart
    + X.RealPart + Y.RealPart
    + X.RealPart + Y.RealPart
    + X.RealPart + Y.RealPart;
  Res.ImaginaryPart := X.ImaginaryPart + Y.ImaginaryPart
    + X.ImaginaryPart + Y.ImaginaryPart
    + X.ImaginaryPart + Y.ImaginaryPart
    + X.ImaginaryPart + Y.ImaginaryPart
    + X.ImaginaryPart + Y.ImaginaryPart
    + X.ImaginaryPart + Y.ImaginaryPart
    + X.ImaginaryPart + Y.ImaginaryPart;
end;

procedure TSingleFPThread2.Execute;
var
  I1, I2, I5: Integer;
  Src1Array1: array of TRegtangularComplexS;
  Src2Array1: array of TRegtangularComplexS;
  ResultArray1: array of TRegtangularComplexS;
  BenchArraySize, PrevArraySize: Integer;
const
  MINBENCHARRAYSIZE: Integer = 1000;
  MAXBENCHARRAYSIZE: Integer = 100000;
  ARRAYSIZEINCREMENT         = 1000;
  NOOFRUNS: Integer          = 20;

begin
  PrevArraySize := 0;
  BenchArraySize := MINBENCHARRAYSIZE;
  while BenchArraySize < MAXBENCHARRAYSIZE do
  begin
    SetLength(Src1Array1, BenchArraySize);
    SetLength(Src2Array1, BenchArraySize);
    SetLength(ResultArray1, BenchArraySize);
    FMemTest.UpdateUsageStatistics;
    // Fill source arrays
    for I1 := PrevArraySize to BenchArraySize - 1 do
    begin
      Src1Array1[I1].RealPart := 1;
      Src1Array1[I1].ImaginaryPart := 1;
      Src2Array1[I1].RealPart := 1;
      Src2Array1[I1].ImaginaryPart := 1;
    end;
    // This is the real botleneck and the performance we want to measure
    for I2 := 0 to NOOFRUNS do
    begin
      for I5 := 0 to BenchArraySize - 1 do
      begin
        TestFunction(ResultArray1[I5], Src1Array1[I5], Src2Array1[I5]);
      end;
    end;
    PrevArraySize := BenchArraySize;
    inc(BenchArraySize, ARRAYSIZEINCREMENT);
  end;
end;

class function TSingleFPThreads2.GetMemTestDescription: string;
begin
  Result := 'A MemTest that tests access to Single FP variables '
    + 'in a dynamic array. '
    + 'Reveals set associativity related issues.'
    + 'MemTest submitted by Dennis Kjaer Christensen.';
end;

class function TSingleFPThreads2.GetMemTestName: string;
begin
  Result := 'Single Variables Access  3 arrays at a time';
end;

class function TSingleFPThreads2.GetCategory: TMemTestCategory;
begin
  Result := bmMemoryAccessSpeed;
end;

procedure TSingleFPThreads2.RunMemTest;
var
  SingleFPThread: TSingleFPThread2;
begin
  inherited;
  SingleFPThread := TSingleFPThread2.Create(True);
  SingleFPThread.FreeOnTerminate := False;
  SingleFPThread.FMemTest := Self;
{$WARN SYMBOL_DEPRECATED OFF}
  SingleFPThread.Resume;
{$WARN SYMBOL_DEPRECATED ON}
  SingleFPThread.WaitFor;
  FreeAndNil(SingleFPThread);
end;

end.
