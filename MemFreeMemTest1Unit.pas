unit MemFreeMemTest1Unit;

interface

{$I MemoryManagerTest.inc}

uses Windows, MemTestClassUnit, Classes, Math;

type

  TMemFreeThreads1 = class(TMemTest)
  public
    class function GetMemTestDescription: string; override;
    class function GetMemTestName: string; override;
    class function GetCategory: TMemTestCategory; override;
    procedure RunMemTest; override;
  end;

implementation

uses SysUtils, bvDataTypes;

type
  TMemFreeThread1 = class(TThread)
    FMemTest: TMemTest;
    procedure Execute; override;
  end;

procedure TMemFreeThread1.Execute;
var
  PointerArray: array of Pointer;
  I, AllocSize, J: Integer;
  AllocSizeFP: Double;
const
  // full debug mode is used to detect memory leaks - not for actual performance test
  // value is decreased to avoid Out of Memory in fuul debug mode
{$IFDEF FullDebug}
  RUNS         = 1;
  NOOFPOINTERS = 120000;
{$ELSE}
  RUNS         = 2;
  NOOFPOINTERS = 12000000;
{$ENDIF}
  ALLOCGROWSTEPSIZE = 0.0000006;
{$IFDEF WIN32}
  SLEEPTIMEAFTERFREE = 10; // Seconds to free
{$ENDIF}
begin
  // Allocate
  SetLength(PointerArray, NOOFPOINTERS);
  for J := 1 to RUNS do
  begin
    AllocSizeFP := 1;
    for I := 0 to bvInt64ToInt(Length(PointerArray) - 1) do
    begin
      AllocSizeFP := AllocSizeFP + ALLOCGROWSTEPSIZE;
      AllocSize := bvInt64ToInt(Round(AllocSizeFP));
      GetMem(PointerArray[I], AllocSize);
    end;
    // Free
    for I := 0 to bvInt64ToInt(Length(PointerArray) - 1) do
      FreeMem(PointerArray[I]);
  end;
  SetLength(PointerArray, 0);
{$IFDEF WIN32}
  // Give a little time to free
  Sleep(SLEEPTIMEAFTERFREE);
{$ENDIF}
  FMemTest.UpdateUsageStatistics;
end;

class function TMemFreeThreads1.GetMemTestDescription: string;
begin
  Result := 'A MemTest that measures how much memory is left unfreed after heavy work '
    + 'MemTest submitted by Dennis Kjaer Christensen.';
end;

class function TMemFreeThreads1.GetMemTestName: string;
begin
  Result := 'Mem Free 1';
end;

class function TMemFreeThreads1.GetCategory: TMemTestCategory;
begin
  Result := bmSingleThreadAllocAndFree;
end;

procedure TMemFreeThreads1.RunMemTest;
var
  MemFreeThread1: TMemFreeThread1;
begin
  inherited;
  MemFreeThread1 := TMemFreeThread1.Create(True);
  MemFreeThread1.FreeOnTerminate := False;
  MemFreeThread1.FMemTest := Self;
  MemFreeThread1.Suspended := False;
  MemFreeThread1.WaitFor;
  FreeAndNil(MemFreeThread1);
end;

end.
